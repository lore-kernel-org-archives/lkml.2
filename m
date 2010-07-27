Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab0G0Tvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 15:51:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50823 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0G0Tvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 15:51:48 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Neil Horman <nhorman@tuxdriver.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, vgoyal@redhat.com
Subject: Re: [PATCH] Enable kdump with EFI boot
Date: Tue, 27 Jul 2010 15:49:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: HidemaruMail 5.38 (WinNT,501)
In-Reply-To: <m1eieolsy6.fsf@fess.ebiederm.org>
References: <C0CB2D0F31868Bindou.takao@jp.fujitsu.com> <20100727111029.GA6303@hmsreliant.think-freely.org> <m1eieolsy6.fsf@fess.ebiederm.org>
Message-Id: <C1CB2DC4DB0586indou.takao@jp.fujitsu.com>
X-Antivirus: avast! (VPS 100727-0, 2010/07/27), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 10:45:21 -0700, "Eric W. Biederman" wrote:

>Neil Horman <nhorman@tuxdriver.com> writes:
>
>> On Mon, Jul 26, 2010 at 06:09:18PM -0400, Takao Indoh wrote:
>>> Hi all,
>>> 
>>> The attached patch enables kdump on EFI-boot machine.
>>> 
>>> [Background]
>>> Current kdump does not work on EFI-boot system because 2nd kernel cannot
>>> find ACPI Table(RSDP). The URL below explains this problem.
>>> http://lists.infradead.org/pipermail/kexec/2010-March/003889.html
>>> 
>>> This problem can be solved by fixing kexec-tools so that it can set up
>>> struct efi_info correctly in the boot_params for 2nd kernel. However
>>> there is another problem.
>>> 
>>> When the 1st kernel boots, EFI system table(efi_system_table_t) is
>>> modified by SetVirtualAddressMap, which is one of EFI runtime service.
>>> This runtime changes physical address in EFI system table to virtual
>>> address.
>>> 
>>> When the 2nd kernel boots, it also receives the same EFI system table,
>>> and the address included in it is already virtual address(1st kernel
>>> rewrote it).  But 2nd kernel does not know that, 2nd kernel thinks it is
>>> a physical address. This causes problems.
>>> 
>>> For example, the following is a part of efi_init().
>>> 
>>> c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);
>>> if (c16) {
>>>     for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
>>>         vendor[i] = *c16++;
>>>     vendor[i] = '\0';
>>> } else
>>>     printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
>>> 
>>> 2nd kernel thinks efi.systab->fw_vendor has a physical address and tries
>>> to change it to virtual address, but it is already virtual address, so
>>> this code fails and 2nd kernel hangs up.
>>> 
>>> [How to fix]
>>> My solution is as follows.
>>> 1) Export physical address of each EFI system table entry via debugfs
>>> /sys/kernel/debug/efi/systab/fw_vendor
>>> /sys/kernel/debug/efi/systab/tables
>>> /sys/kernel/debug/efi/systab/runtime
>>> 
>>> Kexec-tools can get physical address of each entry in EFI system table
>>> via these entries. Kexec tools adds these physical addresses to boot
>>> parameters
>>> ex.)
>>> efi_systab_fw_vendor=0x7a6a1398 efi_systab_tables=0x7a6a2e18 \
>>> efi_systab_runtime=0x7a6a3e18
>>> 
>>> 2) Kernel parses these parameters and use them in efi_init()
>>> 
>>> 
>>> So, what this patch is doing is:
>>> - Add debugfs interface for each EFI system table entry
>>> - eif_init() gets physical address of each EFI system table entry from
>>>   boot paramteter instead of the table
>>> - Don't call SetVirtualAddressMap in 2nd kernel because panic occurred
>>>   when SetVirtualAddressMap is called in 2nd kernel. This is called in
>>>   1st kernel, and doesn't need to be called again.
>>> Any comments would be appreciated!
>
>As I recall after SetVirtualAddressMap is called we can not you physical
>addresses in EFI.
>
>We should not call SetVirtualAddressMap in the first kernel. EFI should
>not be doing anything performance critical and we already are required
>to have code that runs EFI at it's physical address, so just removing
>the false optimization of calling SetVirtualAddressMap should fix this
>issue.
>
>Furthermore is_kdump_kernel is a bad test because it presumes this is
>only an issue for a crash dump kernel.  kexec is used in some
>instances as a general purpose bootloader, so we may kexec a new
>kernel and that kernel will not be a kdump kernel.
>
>Also having to use debugfs for a production usage appears strongly
>wrong.  We are not talking about debugging information so if we still
>need these files after we remove SetVirtualAddressMap, we should design
>a proper interface and use sysfs or proc.

If SetVirtualAddressMap is not called in 1st kernel, EFI system table 
keeps its physical address, so it's ok, my patch is not needed. Did
anyone post a patch to do that, or anyone are trying that?

Thanks,
Takao Indoh




>
>>> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
>> CC-ing the maintainers for x86. nd kexec
>>
>> Acked-by: Neil Horman <nhorman@tuxdriver.com> 
>
>A good attempt but not something we want to run.
>
>Eric
>
>>> ---
>>>  arch/x86/kernel/efi.c |  132 +++++++++++++++++++++++++++++++++++++---
>>>  1 file changed, 123 insertions(+), 9 deletions(-)
>>> 
>>> diff -Nurp linux-2.6.35-rc6.org/arch/x86/kernel/efi.c linux-2.6.35-rc6/
>>> arch/x86/kernel/efi.c
>>> --- linux-2.6.35-rc6.org/arch/x86/kernel/efi.c	2010-07-26 12:02:31.
>>> 216675044 -0400
>>> +++ linux-2.6.35-rc6/arch/x86/kernel/efi.c	2010-07-26 12:17:24.486677191 
>>> -0400
>>> @@ -36,6 +36,8 @@
>>>  #include <linux/io.h>
>>>  #include <linux/reboot.h>
>>>  #include <linux/bcd.h>
>>> +#include <linux/crash_dump.h>
>>> +#include <linux/debugfs.h>
>>>  
>>>  #include <asm/setup.h>
>>>  #include <asm/efi.h>
>>> @@ -314,6 +316,97 @@ static void __init print_efi_memmap(void
>>>  }
>>>  #endif  /*  EFI_DEBUG  */
>>>  
>>> +unsigned long systab_fw_vendor_paddr;
>>> +unsigned long systab_runtime_paddr;
>>> +unsigned long systab_tables_paddr;
>>> +
>>> +static struct debugfs_blob_wrapper fw_vendor_blob = {
>>> +	.data		= &systab_fw_vendor_paddr,
>>> +	.size		= sizeof(systab_fw_vendor_paddr),
>>> +};
>>> +
>>> +static struct debugfs_blob_wrapper runtime_blob = {
>>> +	.data		= &systab_runtime_paddr,
>>> +	.size		= sizeof(systab_runtime_paddr),
>>> +};
>>> +
>>> +static struct debugfs_blob_wrapper tables_blob = {
>>> +	.data		= &systab_tables_paddr,
>>> +	.size		= sizeof(systab_tables_paddr),
>>> +};
>>> +
>>> +static int __init setup_systab_fw_vendor_paddr(char *arg)
>>> +{
>>> +	systab_fw_vendor_paddr = simple_strtoul(arg, NULL, 16);
>>> +	return 0;
>>> +}
>>> +early_param("efi_systab_fw_vendor", setup_systab_fw_vendor_paddr);
>>> +
>>> +static int __init setup_systab_runtime_paddr(char *arg)
>>> +{
>>> +	systab_runtime_paddr = simple_strtoul(arg, NULL, 16);
>>> +	return 0;
>>> +}
>>> +early_param("efi_systab_runtime", setup_systab_runtime_paddr);
>>> +
>>> +static int __init setup_systab_tables_paddr(char *arg)
>>> +{
>>> +	systab_tables_paddr = simple_strtoul(arg, NULL, 16);
>>> +	return 0;
>>> +}
>>> +early_param("efi_systab_tables", setup_systab_tables_paddr);
>>> +
>>> +static int create_debug_files_systab (struct dentry *root)
>>> +{
>>> +	struct dentry *systab_dir, *fw_vendor, *runtime, *tables;
>>> +
>>> +	systab_dir = debugfs_create_dir("systab", root);
>>> +	if (!systab_dir)
>>> +		return -1;
>>> +
>>> +	fw_vendor = debugfs_create_blob("fw_vendor", S_IRUGO, systab_dir,
>>> +				            &fw_vendor_blob);
>>> +	if (!fw_vendor)
>>> +		goto err_fw;
>>> +
>>> +	runtime = debugfs_create_blob("runtime", S_IRUGO, systab_dir,
>>> +				            &runtime_blob);
>>> +	if (!runtime)
>>> +		goto err_runtime;
>>> +
>>> +	tables = debugfs_create_blob("tables", S_IRUGO, systab_dir,
>>> +				            &tables_blob);
>>> +	if (tables)
>>> +		return 0;
>>> +
>>> +	debugfs_remove(runtime);
>>> +err_runtime:
>>> +	debugfs_remove(fw_vendor);
>>> +err_fw:
>>> +	debugfs_remove(systab_dir);
>>> +	return -1;
>>> +}
>>> +
>>> +static int crate_debug_files (void)
>>> +{
>>> +	int error;
>>> +	struct dentry *efi_dir;
>>> +
>>> +	efi_dir = debugfs_create_dir("efi", NULL);
>>> +	if (!efi_dir)
>>> +		return -1;
>>> +
>>> +	error = create_debug_files_systab(efi_dir);
>>> +	if (error) {
>>> +		debugfs_remove(efi_dir);
>>> +		return -1;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +late_initcall(crate_debug_files);
>>> +
>>>  void __init efi_init(void)
>>>  {
>>>  	efi_config_table_t *config_tables;
>>> @@ -322,6 +415,7 @@ void __init efi_init(void)
>>>  	char vendor[100] = "unknown";
>>>  	int i = 0;
>>>  	void *tmp;
>>> +	resource_size_t phys_addr;
>>>  
>>>  #ifdef CONFIG_X86_32
>>>  	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.
>>> efi_systab;
>>> @@ -353,7 +447,11 @@ void __init efi_init(void)
>>>  	/*
>>>  	 * Show what we know for posterity
>>>  	 */
>>> -	c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);
>>> +	if (is_kdump_kernel() && systab_fw_vendor_paddr != 0)
>>> +		phys_addr = systab_fw_vendor_paddr;
>>> +	else
>>> +		phys_addr = efi.systab->fw_vendor;
>>> +	c16 = tmp = early_ioremap(phys_addr, 2);
>>>  	if (c16) {
>>>  		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
>>>  			vendor[i] = *c16++;
>>> @@ -369,8 +467,12 @@ void __init efi_init(void)
>>>  	/*
>>>  	 * Let's see what config tables the firmware passed to us.
>>>  	 */
>>> +	if (is_kdump_kernel() && systab_tables_paddr != 0)
>>> +		phys_addr = systab_tables_paddr;
>>> +	else
>>> +		phys_addr = efi.systab->tables;
>>>  	config_tables = early_ioremap(
>>> -		efi.systab->tables,
>>> +		phys_addr,
>>>  		efi.systab->nr_tables * sizeof(efi_config_table_t));
>>>  	if (config_tables == NULL)
>>>  		printk(KERN_ERR "Could not map EFI Configuration Table!\n");
>>> @@ -418,8 +520,11 @@ void __init efi_init(void)
>>>  	 * address of several of the EFI runtime functions, needed to
>>>  	 * set the firmware into virtual mode.
>>>  	 */
>>> -	runtime = early_ioremap((unsigned long)efi.systab->runtime,
>>> -				sizeof(efi_runtime_services_t));
>>> +	if (is_kdump_kernel() && systab_runtime_paddr != 0)
>>> +		phys_addr = systab_runtime_paddr;
>>> +	else
>>> +		phys_addr = (unsigned long)efi.systab->runtime;
>>> +	runtime = early_ioremap(phys_addr, sizeof(efi_runtime_services_t));
>>>  	if (runtime != NULL) {
>>>  		/*
>>>  		 * We will only need *early* access to the following
>>> @@ -465,6 +570,12 @@ void __init efi_init(void)
>>>  #if EFI_DEBUG
>>>  	print_efi_memmap();
>>>  #endif
>>> +	/* Save original physical address */
>>> +	if (!is_kdump_kernel()) {
>>> +		systab_fw_vendor_paddr = efi.systab->fw_vendor;
>>> +		systab_tables_paddr = efi.systab->tables;
>>> +		systab_runtime_paddr = (unsigned long)efi.systab->runtime;
>>> +	}
>>>  }
>>>  
>>>  static void __init runtime_code_page_mkexec(void)
>>> @@ -544,11 +655,14 @@ void __init efi_enter_virtual_mode(void)
>>>  
>>>  	BUG_ON(!efi.systab);
>>>  
>>> -	status = phys_efi_set_virtual_address_map(
>>> -		memmap.desc_size * memmap.nr_map,
>>> -		memmap.desc_size,
>>> -		memmap.desc_version,
>>> -		memmap.phys_map);
>>> +	if (!is_kdump_kernel())
>>> +		status = phys_efi_set_virtual_address_map(
>>> +			memmap.desc_size * memmap.nr_map,
>>> +			memmap.desc_size,
>>> +			memmap.desc_version,
>>> +			memmap.phys_map);
>>> +	else
>>> +		status = EFI_SUCCESS;
>>>  
>>>  	if (status != EFI_SUCCESS) {
>>>  		printk(KERN_ALERT "Unable to switch EFI into virtual mode "
>>> 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>> 
