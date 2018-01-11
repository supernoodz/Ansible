Import-Module VirtualMachineManager | Out-Null;
$template = Get-SCVMTemplate -Name 'Shielded16Temp' -VMMServer localhost;
$vmconfig = New-SCVMConfiguration -VMTemplate $template -Name 'ManageIQConfig-shielded_0002';
$vmhost   = Get-SCVMHost -ComputerName 'HV-02.KAYAN.EG';
Set-SCVMConfiguration -VMConfiguration $vmconfig -VMHost $vmhost -VMLocation 'I:\' | Out-Null;
Update-SCVMConfiguration -VMConfiguration $vmconfig | Out-Null;
$vm = New-SCVirtualMachine -Name 'shielded_0002' -VMConfiguration $vmconfig;
Set-SCVirtualMachine -VM $vm -CPUCount 1 -DynamicMemoryEnabled $false -MemoryMB 1024 | Out-Null;
$adapter = $vm | SCVirtualNetworkAdapter;
Set-SCVirtualNetworkAdapter -VirtualNetworkAdapter $adapter -LogicalNetwork (Get-SCLogicalNetwork -Name 'VMs') | Out-Null;
$vm | Select-Object ID | ConvertTo-Json -Compress