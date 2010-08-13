Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090Ab0HMTUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 15:20:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58352 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab0HMTUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 15:20:15 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        vgoyal@redhat.com, nhorman@tuxdriver.com
Subject: [PATCH][EFI] Run EFI in physical mode
Date: Fri, 13 Aug 2010 15:18:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: HidemaruMail 5.38 (WinNT,501)
Message-Id: <F0CB3B1C601247indou.takao@jp.fujitsu.com>
X-Antivirus: avast! (VPS 100813-0, 2010/08/13), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The attached patch enables EFI to run in physical mode.

Basically EFI is in physical mode at first and it's switched to virtual
mode after calling SetVirtualAddressMap. By applying this patch, you can
run EFI always in physical mode. And you can also specify "virtefi" as
kernel boot parameter to run EFI in virtual mode as before. Note that
this patch supports only x86_64.

This is needed to run kexec/kdump in EFI-booted system. The following is
an original discussion. In this thread, I explained that kdump does not
work because EFI system table is modified by SetVirtualAddressMap. And
the idea to run EFI in physical mode was proposed. This patch implements
it.

http://marc.info/?l=linux-kernel&m=128018221820234&w=2
> When the 1st kernel boots, EFI system table(efi_system_table_t) is
> modified by SetVirtualAddressMap, which is one of EFI runtime service.
> This runtime changes physical address in EFI system table to virtual
> address.
> 
> When the 2nd kernel boots, it also receives the same EFI system table,
> and the address included in it is already virtual address(1st kernel
> rewrote it).  But 2nd kernel does not know that, 2nd kernel thinks it is
> a physical address. This causes problems.

Basic idea of this patch is to create EFI own pagetable. This pagetable
maps physical address of EFI runtime to the virtual address which is the
same value so that we can call it directly. For example, physical 
address 0x800000 is mapped to virtual address 0x800000. Before calling
EFI runtime, cr3 register is switched to this pagetable, and restored
when we come back from EFI.

Any comments would be appreciated.

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
---
 arch/x86/include/asm/efi.h |    3
 arch/x86/kernel/efi.c      |  142 ++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/efi_32.c   |    4
 arch/x86/kernel/efi_64.c   |   92 ++++++++++++++++++++++
 include/linux/efi.h        |    1
 include/linux/init.h       |    1
 init/main.c                |   16 +++
 7 files changed, 254 insertions(+), 5 deletions(-)

diff -Nurp linux-2.6.35.org/arch/x86/include/asm/efi.h linux-2.6.35/arch/x86/include/asm/efi.h
--- linux-2.6.35.org/arch/x86/include/asm/efi.h	2010-08-01 18:11:14.000000000 -0400
+++ linux-2.6.35/arch/x86/include/asm/efi.h	2010-08-13 14:39:25.817104994 -0400
@@ -93,6 +93,9 @@ extern int add_efi_memmap;
 extern void efi_reserve_early(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
+extern void efi_call_phys_prelog_in_physmode(void);
+extern void efi_call_phys_epilog_in_physmode(void);
+extern void efi_pagetable_init(void);
 
 #ifndef CONFIG_EFI
 /*
diff -Nurp linux-2.6.35.org/arch/x86/kernel/efi.c linux-2.6.35/arch/x86/kernel/efi.c
--- linux-2.6.35.org/arch/x86/kernel/efi.c	2010-08-01 18:11:14.000000000 -0400
+++ linux-2.6.35/arch/x86/kernel/efi.c	2010-08-13 14:39:25.819105004 -0400
@@ -57,6 +57,7 @@ struct efi_memory_map memmap;
 
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
+static efi_runtime_services_t phys_runtime;
 
 static int __init setup_noefi(char *arg)
 {
@@ -171,7 +172,7 @@ static efi_status_t __init phys_efi_set_
 	return status;
 }
 
-static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
+static efi_status_t __init phys_efi_get_time_early(efi_time_t *tm,
 					     efi_time_cap_t *tc)
 {
 	efi_status_t status;
@@ -182,6 +183,112 @@ static efi_status_t __init phys_efi_get_
 	return status;
 }
 
+static efi_status_t phys_efi_get_time(efi_time_t *tm,
+				      efi_time_cap_t *tc)
+{
+	efi_status_t status;
+
+	efi_call_phys_prelog_in_physmode();
+	status = efi_call_phys2((void*)phys_runtime.get_time, tm, tc);
+	efi_call_phys_epilog_in_physmode();
+	return status;
+}
+
+static efi_status_t __init phys_efi_set_time(efi_time_t *tm)
+{
+	efi_status_t status;
+
+	efi_call_phys_prelog_in_physmode();
+	status = efi_call_phys1((void*)phys_runtime.set_time, tm);
+	efi_call_phys_epilog_in_physmode();
+	return status;
+}
+
+static efi_status_t phys_efi_get_wakeup_time(efi_bool_t *enabled,
+                                             efi_bool_t *pending,
+                                             efi_time_t *tm)
+{
+	efi_status_t status;
+
+	efi_call_phys_prelog_in_physmode();
+	status = efi_call_phys3((void*)phys_runtime.get_wakeup_time, enabled,
+				pending, tm);
+	efi_call_phys_epilog_in_physmode();
+	return status;
+}
+
+static efi_status_t phys_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
+{
+	efi_status_t status;
+	efi_call_phys_prelog_in_physmode();
+	status = efi_call_phys2((void*)phys_runtime.set_wakeup_time, enabled,
+				tm);
+	efi_call_phys_epilog_in_physmode();
+	return status;
+}
+
+static efi_status_t phys_efi_get_variable(efi_char16_t *name,
+					  efi_guid_t *vendor,
+					  u32 *attr,
+					  unsigned long *data_size,
+					  void *data)
+{
+	efi_status_t status;
+	efi_call_phys_prelog_in_physmode();
+	status = efi_call_phys5((void*)phys_runtime.get_variable, name, vendor,
+				attr, data_size, data);
+	efi_call_phys_epilog_in_physmode();
+	return status;
+}
+
+static efi_status_t phys_efi_get_next_variable(unsigned long *name_size,
+					       efi_char16_t *name,
+					       efi_guid_t *vendor)
+{
+	efi_status_t status;
+
+	efi_call_phys_prelog_in_physmode();
+	status = efi_call_phys3((void*)phys_runtime.get_next_variable,
+				name_size, name, vendor);
+	efi_call_phys_epilog_in_physmode();
+	return status;
+}
+
+static efi_status_t phys_efi_set_variable(efi_char16_t *name,
+					  efi_guid_t *vendor,
+					  unsigned long attr,
+					  unsigned long data_size,
+					  void *data)
+{
+	efi_status_t status;
+	efi_call_phys_prelog_in_physmode();
+	status = efi_call_phys5((void*)phys_runtime.set_variable, name,
+				vendor, attr, data_size, data);
+	efi_call_phys_epilog_in_physmode();
+	return status;
+}
+
+static efi_status_t phys_efi_get_next_high_mono_count(u32 *count)
+{
+	efi_status_t status;
+	efi_call_phys_prelog_in_physmode();
+	status = efi_call_phys1((void*)phys_runtime.get_next_high_mono_count,
+				count);
+	efi_call_phys_epilog_in_physmode();
+	return status;
+}
+
+static void phys_efi_reset_system(int reset_type,
+                                  efi_status_t status,
+                                  unsigned long data_size,
+                                  efi_char16_t *data)
+{
+	efi_call_phys_prelog_in_physmode();
+	efi_call_phys4((void*)phys_runtime.reset_system, reset_type, status,
+				data_size, data);
+	efi_call_phys_epilog_in_physmode();
+}
+
 int efi_set_rtc_mmss(unsigned long nowtime)
 {
 	int real_seconds, real_minutes;
@@ -434,7 +541,9 @@ void __init efi_init(void)
 		 * Make efi_get_time can be called before entering
 		 * virtual mode.
 		 */
-		efi.get_time = phys_efi_get_time;
+		efi.get_time = phys_efi_get_time_early;
+
+		memcpy(&phys_runtime, runtime, sizeof(efi_runtime_services_t));
 	} else
 		printk(KERN_ERR "Could not map the EFI runtime service "
 		       "table!\n");
@@ -465,6 +574,14 @@ void __init efi_init(void)
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif
+
+#ifndef CONFIG_X86_64
+	/*
+	 * Only x86_64 supports physical mode as of now. Use virtual mode
+	 * forcibly.
+	 */
+	usevirtefi = 1;
+#endif
 }
 
 static void __init runtime_code_page_mkexec(void)
@@ -578,6 +695,27 @@ void __init efi_enter_virtual_mode(void)
 	memmap.map = NULL;
 }
 
+void __init efi_setup_physical_mode(void)
+{
+#ifdef CONFIG_X86_64
+	efi_pagetable_init();
+#endif
+	efi.get_time = phys_efi_get_time;
+	efi.set_time = phys_efi_set_time;
+	efi.get_wakeup_time = phys_efi_get_wakeup_time;
+	efi.set_wakeup_time = phys_efi_set_wakeup_time;
+	efi.get_variable = phys_efi_get_variable;
+	efi.get_next_variable = phys_efi_get_next_variable;
+	efi.set_variable = phys_efi_set_variable;
+	efi.get_next_high_mono_count =
+		phys_efi_get_next_high_mono_count;
+	efi.reset_system = phys_efi_reset_system;
+	efi.set_virtual_address_map = NULL; /* Not needed */
+
+	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
+	memmap.map = NULL;
+}
+
 /*
  * Convenience functions to obtain memory types and attributes
  */
diff -Nurp linux-2.6.35.org/arch/x86/kernel/efi_32.c linux-2.6.35/arch/x86/kernel/efi_32.c
--- linux-2.6.35.org/arch/x86/kernel/efi_32.c	2010-08-01 18:11:14.000000000 -0400
+++ linux-2.6.35/arch/x86/kernel/efi_32.c	2010-08-13 14:39:25.819105004 -0400
@@ -110,3 +110,7 @@ void efi_call_phys_epilog(void)
 
 	local_irq_restore(efi_rt_eflags);
 }
+
+void efi_call_phys_prelog_in_physmode(void) { /* Not supported */ }
+void efi_call_phys_epilog_in_physmode(void) { /* Not supported */ }
+
diff -Nurp linux-2.6.35.org/arch/x86/kernel/efi_64.c linux-2.6.35/arch/x86/kernel/efi_64.c
--- linux-2.6.35.org/arch/x86/kernel/efi_64.c	2010-08-01 18:11:14.000000000 -0400
+++ linux-2.6.35/arch/x86/kernel/efi_64.c	2010-08-13 14:39:25.819105004 -0400
@@ -39,7 +39,9 @@
 #include <asm/fixmap.h>
 
 static pgd_t save_pgd __initdata;
-static unsigned long efi_flags __initdata;
+static unsigned long efi_flags;
+static pgd_t efi_pgd[PTRS_PER_PGD] __page_aligned_bss;
+static unsigned long save_cr3;
 
 static void __init early_mapping_set_exec(unsigned long start,
 					  unsigned long end,
@@ -98,6 +100,19 @@ void __init efi_call_phys_epilog(void)
 	early_runtime_code_mapping_set_exec(0);
 }
 
+void efi_call_phys_prelog_in_physmode(void)
+{
+	local_irq_save(efi_flags);
+	save_cr3 = read_cr3();
+	write_cr3(virt_to_phys(efi_pgd));
+}
+
+void efi_call_phys_epilog_in_physmode(void)
+{
+	write_cr3(save_cr3);
+	local_irq_restore(efi_flags);
+}
+
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 				 u32 type)
 {
@@ -112,3 +127,78 @@ void __iomem *__init efi_ioremap(unsigne
 
 	return (void __iomem *)__va(phys_addr);
 }
+
+static pud_t *fill_pud(pgd_t *pgd, unsigned long vaddr)
+{
+	if (pgd_none(*pgd)) {
+		pud_t *pud = (pud_t *)get_zeroed_page(GFP_ATOMIC);
+		set_pgd(pgd, __pgd(_PAGE_TABLE | __pa(pud)));
+		if (pud != pud_offset(pgd, 0))
+			printk(KERN_ERR "EFI PAGETABLE BUG #00! %p <-> %p\n",
+			       pud, pud_offset(pgd, 0));
+	}
+	return pud_offset(pgd, vaddr);
+}
+
+static pmd_t *fill_pmd(pud_t *pud, unsigned long vaddr)
+{
+	if (pud_none(*pud)) {
+		pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_ATOMIC);
+		set_pud(pud, __pud(_PAGE_TABLE | __pa(pmd)));
+		if (pmd != pmd_offset(pud, 0))
+			printk(KERN_ERR "EFI PAGETABLE BUG #01! %p <-> %p\n",
+			       pmd, pmd_offset(pud, 0));
+	}
+	return pmd_offset(pud, vaddr);
+}
+
+static pte_t *fill_pte(pmd_t *pmd, unsigned long vaddr)
+{
+	if (pmd_none(*pmd)) {
+		pte_t *pte = (pte_t *)get_zeroed_page(GFP_ATOMIC);
+		set_pmd(pmd, __pmd(_PAGE_TABLE | __pa(pte)));
+		if (pte != pte_offset_kernel(pmd, 0))
+			printk(KERN_ERR "EFI PAGETABLE BUG #02!\n");
+	}
+	return pte_offset_kernel(pmd, vaddr);
+}
+
+void __init efi_pagetable_init(void)
+{
+	efi_memory_desc_t *md;
+	unsigned long size;
+	u64 start_pfn, end_pfn, pfn, vaddr;
+	void *p;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	memset(efi_pgd, 0, sizeof(efi_pgd));
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if (!(md->type & EFI_RUNTIME_SERVICES_CODE) &&
+		    !(md->type & EFI_RUNTIME_SERVICES_DATA))
+			continue;
+
+		start_pfn = md->phys_addr >> PAGE_SHIFT;
+		size = md->num_pages << EFI_PAGE_SHIFT;
+		end_pfn = PFN_UP(md->phys_addr + size);
+
+		for (pfn = start_pfn; pfn <= end_pfn; pfn++) {
+			vaddr = pfn << PAGE_SHIFT;
+			pgd = efi_pgd + pgd_index(vaddr);
+			pud = fill_pud(pgd, vaddr);
+			pmd = fill_pmd(pud, vaddr);
+			pte = fill_pte(pmd, vaddr);
+			if (md->type & EFI_RUNTIME_SERVICES_CODE)
+				set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
+			else
+				set_pte(pte, pfn_pte(pfn, PAGE_KERNEL));
+		}
+	}
+	pgd = efi_pgd + pgd_index(PAGE_OFFSET);
+	set_pgd(pgd, *pgd_offset_k(PAGE_OFFSET));
+	pgd = efi_pgd + pgd_index(__START_KERNEL_map);
+	set_pgd(pgd, *pgd_offset_k(__START_KERNEL_map));
+}
diff -Nurp linux-2.6.35.org/include/linux/efi.h linux-2.6.35/include/linux/efi.h
--- linux-2.6.35.org/include/linux/efi.h	2010-08-01 18:11:14.000000000 -0400
+++ linux-2.6.35/include/linux/efi.h	2010-08-13 14:39:25.820105006 -0400
@@ -290,6 +290,7 @@ extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
+extern void efi_setup_physical_mode(void);
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
diff -Nurp linux-2.6.35.org/include/linux/init.h linux-2.6.35/include/linux/init.h
--- linux-2.6.35.org/include/linux/init.h	2010-08-01 18:11:14.000000000 -0400
+++ linux-2.6.35/include/linux/init.h	2010-08-13 14:39:25.820105006 -0400
@@ -142,6 +142,7 @@ extern int do_one_initcall(initcall_t fn
 extern char __initdata boot_command_line[];
 extern char *saved_command_line;
 extern unsigned int reset_devices;
+extern unsigned int usevirtefi;
 
 /* used by init/main.c */
 void setup_arch(char **);
diff -Nurp linux-2.6.35.org/init/main.c linux-2.6.35/init/main.c
--- linux-2.6.35.org/init/main.c	2010-08-01 18:11:14.000000000 -0400
+++ linux-2.6.35/init/main.c	2010-08-13 14:39:25.820105006 -0400
@@ -200,6 +200,14 @@ static int __init set_reset_devices(char
 
 __setup("reset_devices", set_reset_devices);
 
+unsigned int usevirtefi;
+static int __init set_virt_efi(char *str)
+{
+	usevirtefi = 1;
+	return 1;
+}
+__setup("virtefi", set_virt_efi);
+
 static char * argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
 char * envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
 static const char *panic_later, *panic_param;
@@ -676,8 +684,12 @@ asmlinkage void __init start_kernel(void
 	pidmap_init();
 	anon_vma_init();
 #ifdef CONFIG_X86
-	if (efi_enabled)
-		efi_enter_virtual_mode();
+	if (efi_enabled) {
+		if (usevirtefi)
+			efi_enter_virtual_mode();
+		else
+			efi_setup_physical_mode();
+	}
 #endif
 	thread_info_cache_init();
 	cred_init();
