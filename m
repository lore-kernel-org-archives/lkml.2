Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab1GMT7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 15:59:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab1GMT7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 15:59:42 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, tony.luck@intel.com, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V2 1/2] efi: merge x86 and ia64 code
Date: Wed, 13 Jul 2011 15:59:03 -0400
Message-Id: <1310587144-14192-1-git-send-email-mjg@redhat.com>
In-Reply-To: <4E1DEAA2.80208@zytor.com>
References: <4E1DEAA2.80208@zytor.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently have two almost entirely independent EFI implementations in
the kernel, with the x86 code having begun as a modified version of the
ia64 code. Forthcoming ARM platforms will use EFI and there are
experimental ports for some MIPS platforms, so continuing this "One EFI
implementation per architecture" model is likely to result in massive bug
duplication. This patch merges the common elements of the ia64 and x86
implementations, which should make adding any future platforms a simple
matter of adding setup code and the appropriate stubs for accessing EFI
resources and making calls.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/ia64/include/asm/efi.h    |   26 ++
 arch/ia64/include/asm/sal.h    |    3 -
 arch/ia64/kernel/efi.c         |  634 ++++----------------------------------
 arch/ia64/kernel/efi_stub.S    |    4 +-
 arch/x86/Kconfig               |    4 +
 arch/x86/include/asm/efi.h     |   39 +--
 arch/x86/platform/efi/efi.c    |  555 ++--------------------------------
 arch/x86/platform/efi/efi_32.c |    6 +-
 arch/x86/platform/efi/efi_64.c |   44 ++-
 drivers/firmware/Makefile      |    1 +
 drivers/firmware/efi/Makefile  |    1 +
 drivers/firmware/efi/efi.c     |  657 ++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h            |   57 ++++-
 init/main.c                    |    2 +-
 14 files changed, 885 insertions(+), 1148 deletions(-)
 create mode 100644 arch/ia64/include/asm/efi.h
 create mode 100644 drivers/firmware/efi/Makefile
 create mode 100644 drivers/firmware/efi/efi.c

diff --git a/arch/ia64/include/asm/efi.h b/arch/ia64/include/asm/efi.h
new file mode 100644
index 0000000..9e6cde5
--- /dev/null
+++ b/arch/ia64/include/asm/efi.h
@@ -0,0 +1,26 @@
+#ifndef _ASM_X86_EFI_H
+#define _ASM_X86_EFI_H
+
+#define EFI_DEBUG	0
+
+#define efi_map(x, y) __va(x)
+#define efi_unmap(x, y)
+
+extern efi_status_t efi_real_call_phys (void *, ...);
+
+#define efi_call_phys(f, args...) efi_real_call_phys(__va(f), args);
+#define efi_call_virt(f, args...) \
+((efi_##f##_t *)efi.systab->runtime->f)(args)
+
+#define efi_phys_arg(arg) (arg ? ((__typeof__(arg)) ia64_tpa(arg)) : arg)
+
+void *efi_call_prelog(void);
+void efi_call_epilog(void *arg);
+
+#define efi_call_phys_prelog() efi_call_prelog()
+#define efi_call_phys_epilog(x) efi_call_epilog(x)
+
+#define efi_call_virt_prelog() efi_call_prelog()
+#define efi_call_virt_epilog(x) efi_call_epilog(x)
+
+#endif
diff --git a/arch/ia64/include/asm/sal.h b/arch/ia64/include/asm/sal.h
index d19ddba..78c152b 100644
--- a/arch/ia64/include/asm/sal.h
+++ b/arch/ia64/include/asm/sal.h
@@ -296,9 +296,6 @@ enum {
     EFI_GUID(0xe429faf8, 0x3cb7, 0x11d4, 0xbc, 0xa7, 0x0, 0x80, 0xc7, 0x3c, 0x88, 0x81)
 #define SAL_PLAT_BUS_ERR_SECT_GUID  \
     EFI_GUID(0xe429faf9, 0x3cb7, 0x11d4, 0xbc, 0xa7, 0x0, 0x80, 0xc7, 0x3c, 0x88, 0x81)
-#define PROCESSOR_ABSTRACTION_LAYER_OVERWRITE_GUID \
-    EFI_GUID(0x6cb0a200, 0x893a, 0x11da, 0x96, 0xd2, 0x0, 0x10, 0x83, 0xff, \
-		0xca, 0x4d)
 
 #define MAX_CACHE_ERRORS	6
 #define MAX_TLB_ERRORS		6
diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index 6fc03af..b034eec 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -11,15 +11,6 @@
  *	Stephane Eranian <eranian@hpl.hp.com>
  * (c) Copyright 2006 Hewlett-Packard Development Company, L.P.
  *	Bjorn Helgaas <bjorn.helgaas@hp.com>
- *
- * All EFI Runtime Services are not implemented yet as EFI only
- * supports physical mode addressing on SoftSDV. This is to be fixed
- * in a future version.  --drummond 1999-07-20
- *
- * Implemented EFI runtime services and virtual mode calls.  --davidm
- *
- * Goutham Rao: <goutham.rao@intel.com>
- *	Skip non-WB memory and ignore empty memory ranges.
  */
 #include <linux/module.h>
 #include <linux/bootmem.h>
@@ -33,6 +24,7 @@
 #include <linux/kexec.h>
 #include <linux/mm.h>
 
+#include <asm/efi.h>
 #include <asm/io.h>
 #include <asm/kregs.h>
 #include <asm/meminit.h>
@@ -41,209 +33,8 @@
 #include <asm/mca.h>
 #include <asm/tlbflush.h>
 
-#define EFI_DEBUG	0
-
-extern efi_status_t efi_call_phys (void *, ...);
-
-struct efi efi;
-EXPORT_SYMBOL(efi);
-static efi_runtime_services_t *runtime;
 static u64 mem_limit = ~0UL, max_addr = ~0UL, min_addr = 0UL;
 
-#define efi_call_virt(f, args...)	(*(f))(args)
-
-#define STUB_GET_TIME(prefix, adjust_arg)				       \
-static efi_status_t							       \
-prefix##_get_time (efi_time_t *tm, efi_time_cap_t *tc)			       \
-{									       \
-	struct ia64_fpreg fr[6];					       \
-	efi_time_cap_t *atc = NULL;					       \
-	efi_status_t ret;						       \
-									       \
-	if (tc)								       \
-		atc = adjust_arg(tc);					       \
-	ia64_save_scratch_fpregs(fr);					       \
-	ret = efi_call_##prefix((efi_get_time_t *) __va(runtime->get_time),    \
-				adjust_arg(tm), atc);			       \
-	ia64_load_scratch_fpregs(fr);					       \
-	return ret;							       \
-}
-
-#define STUB_SET_TIME(prefix, adjust_arg)				       \
-static efi_status_t							       \
-prefix##_set_time (efi_time_t *tm)					       \
-{									       \
-	struct ia64_fpreg fr[6];					       \
-	efi_status_t ret;						       \
-									       \
-	ia64_save_scratch_fpregs(fr);					       \
-	ret = efi_call_##prefix((efi_set_time_t *) __va(runtime->set_time),    \
-				adjust_arg(tm));			       \
-	ia64_load_scratch_fpregs(fr);					       \
-	return ret;							       \
-}
-
-#define STUB_GET_WAKEUP_TIME(prefix, adjust_arg)			       \
-static efi_status_t							       \
-prefix##_get_wakeup_time (efi_bool_t *enabled, efi_bool_t *pending,	       \
-			  efi_time_t *tm)				       \
-{									       \
-	struct ia64_fpreg fr[6];					       \
-	efi_status_t ret;						       \
-									       \
-	ia64_save_scratch_fpregs(fr);					       \
-	ret = efi_call_##prefix(					       \
-		(efi_get_wakeup_time_t *) __va(runtime->get_wakeup_time),      \
-		adjust_arg(enabled), adjust_arg(pending), adjust_arg(tm));     \
-	ia64_load_scratch_fpregs(fr);					       \
-	return ret;							       \
-}
-
-#define STUB_SET_WAKEUP_TIME(prefix, adjust_arg)			       \
-static efi_status_t							       \
-prefix##_set_wakeup_time (efi_bool_t enabled, efi_time_t *tm)		       \
-{									       \
-	struct ia64_fpreg fr[6];					       \
-	efi_time_t *atm = NULL;						       \
-	efi_status_t ret;						       \
-									       \
-	if (tm)								       \
-		atm = adjust_arg(tm);					       \
-	ia64_save_scratch_fpregs(fr);					       \
-	ret = efi_call_##prefix(					       \
-		(efi_set_wakeup_time_t *) __va(runtime->set_wakeup_time),      \
-		enabled, atm);						       \
-	ia64_load_scratch_fpregs(fr);					       \
-	return ret;							       \
-}
-
-#define STUB_GET_VARIABLE(prefix, adjust_arg)				       \
-static efi_status_t							       \
-prefix##_get_variable (efi_char16_t *name, efi_guid_t *vendor, u32 *attr,      \
-		       unsigned long *data_size, void *data)		       \
-{									       \
-	struct ia64_fpreg fr[6];					       \
-	u32 *aattr = NULL;						       \
-	efi_status_t ret;						       \
-									       \
-	if (attr)							       \
-		aattr = adjust_arg(attr);				       \
-	ia64_save_scratch_fpregs(fr);					       \
-	ret = efi_call_##prefix(					       \
-		(efi_get_variable_t *) __va(runtime->get_variable),	       \
-		adjust_arg(name), adjust_arg(vendor), aattr,		       \
-		adjust_arg(data_size), adjust_arg(data));		       \
-	ia64_load_scratch_fpregs(fr);					       \
-	return ret;							       \
-}
-
-#define STUB_GET_NEXT_VARIABLE(prefix, adjust_arg)			       \
-static efi_status_t							       \
-prefix##_get_next_variable (unsigned long *name_size, efi_char16_t *name,      \
-			    efi_guid_t *vendor)				       \
-{									       \
-	struct ia64_fpreg fr[6];					       \
-	efi_status_t ret;						       \
-									       \
-	ia64_save_scratch_fpregs(fr);					       \
-	ret = efi_call_##prefix(					       \
-		(efi_get_next_variable_t *) __va(runtime->get_next_variable),  \
-		adjust_arg(name_size), adjust_arg(name), adjust_arg(vendor));  \
-	ia64_load_scratch_fpregs(fr);					       \
-	return ret;							       \
-}
-
-#define STUB_SET_VARIABLE(prefix, adjust_arg)				       \
-static efi_status_t							       \
-prefix##_set_variable (efi_char16_t *name, efi_guid_t *vendor,		       \
-		       unsigned long attr, unsigned long data_size,	       \
-		       void *data)					       \
-{									       \
-	struct ia64_fpreg fr[6];					       \
-	efi_status_t ret;						       \
-									       \
-	ia64_save_scratch_fpregs(fr);					       \
-	ret = efi_call_##prefix(					       \
-		(efi_set_variable_t *) __va(runtime->set_variable),	       \
-		adjust_arg(name), adjust_arg(vendor), attr, data_size,	       \
-		adjust_arg(data));					       \
-	ia64_load_scratch_fpregs(fr);					       \
-	return ret;							       \
-}
-
-#define STUB_GET_NEXT_HIGH_MONO_COUNT(prefix, adjust_arg)		       \
-static efi_status_t							       \
-prefix##_get_next_high_mono_count (u32 *count)				       \
-{									       \
-	struct ia64_fpreg fr[6];					       \
-	efi_status_t ret;						       \
-									       \
-	ia64_save_scratch_fpregs(fr);					       \
-	ret = efi_call_##prefix((efi_get_next_high_mono_count_t *)	       \
-				__va(runtime->get_next_high_mono_count),       \
-				adjust_arg(count));			       \
-	ia64_load_scratch_fpregs(fr);					       \
-	return ret;							       \
-}
-
-#define STUB_RESET_SYSTEM(prefix, adjust_arg)				       \
-static void								       \
-prefix##_reset_system (int reset_type, efi_status_t status,		       \
-		       unsigned long data_size, efi_char16_t *data)	       \
-{									       \
-	struct ia64_fpreg fr[6];					       \
-	efi_char16_t *adata = NULL;					       \
-									       \
-	if (data)							       \
-		adata = adjust_arg(data);				       \
-									       \
-	ia64_save_scratch_fpregs(fr);					       \
-	efi_call_##prefix(						       \
-		(efi_reset_system_t *) __va(runtime->reset_system),	       \
-		reset_type, status, data_size, adata);			       \
-	/* should not return, but just in case... */			       \
-	ia64_load_scratch_fpregs(fr);					       \
-}
-
-#define phys_ptr(arg)	((__typeof__(arg)) ia64_tpa(arg))
-
-STUB_GET_TIME(phys, phys_ptr)
-STUB_SET_TIME(phys, phys_ptr)
-STUB_GET_WAKEUP_TIME(phys, phys_ptr)
-STUB_SET_WAKEUP_TIME(phys, phys_ptr)
-STUB_GET_VARIABLE(phys, phys_ptr)
-STUB_GET_NEXT_VARIABLE(phys, phys_ptr)
-STUB_SET_VARIABLE(phys, phys_ptr)
-STUB_GET_NEXT_HIGH_MONO_COUNT(phys, phys_ptr)
-STUB_RESET_SYSTEM(phys, phys_ptr)
-
-#define id(arg)	arg
-
-STUB_GET_TIME(virt, id)
-STUB_SET_TIME(virt, id)
-STUB_GET_WAKEUP_TIME(virt, id)
-STUB_SET_WAKEUP_TIME(virt, id)
-STUB_GET_VARIABLE(virt, id)
-STUB_GET_NEXT_VARIABLE(virt, id)
-STUB_SET_VARIABLE(virt, id)
-STUB_GET_NEXT_HIGH_MONO_COUNT(virt, id)
-STUB_RESET_SYSTEM(virt, id)
-
-void
-efi_gettimeofday (struct timespec *ts)
-{
-	efi_time_t tm;
-
-	if ((*efi.get_time)(&tm, NULL) != EFI_SUCCESS) {
-		memset(ts, 0, sizeof(*ts));
-		return;
-	}
-
-	ts->tv_sec = mktime(tm.year, tm.month, tm.day,
-			    tm.hour, tm.minute, tm.second);
-	ts->tv_nsec = tm.nanosecond;
-}
-
 static int
 is_memory_available (efi_memory_desc_t *md)
 {
@@ -269,18 +60,40 @@ typedef struct kern_memdesc {
 
 static kern_memdesc_t *kern_memmap;
 
-#define efi_md_size(md)	(md->num_pages << EFI_PAGE_SHIFT)
+void *efi_call_prelog(void)
+{
+	struct ia64_fpreg *regs = kmalloc(sizeof(struct ia64_fpreg) * 6,
+					  GFP_KERNEL);
 
-static inline u64
-kmd_end(kern_memdesc_t *kmd)
+	ia64_save_scratch_fpregs(regs);
+	return regs;
+}
+
+void efi_call_epilog(void *regs)
 {
-	return (kmd->start + (kmd->num_pages << EFI_PAGE_SHIFT));
+	ia64_load_scratch_fpregs(regs);
+	kfree(regs);
+}
+
+unsigned long __init efi_ioremap(efi_memory_desc_t *md)
+{
+	if (md->attribute & EFI_MEMORY_RUNTIME) {
+		if (md->attribute & EFI_MEMORY_WB) {
+			return (u64) __va(md->phys_addr);
+		} else if (md->attribute & EFI_MEMORY_UC ||
+			   md->attribute & EFI_MEMORY_WC ||
+			   md->attribute & EFI_MEMORY_WT) {
+			return (u64) ioremap(md->phys_addr, 0);
+		}
+	}
+
+	return 0;
 }
 
 static inline u64
-efi_md_end(efi_memory_desc_t *md)
+kmd_end(kern_memdesc_t *kmd)
 {
-	return (md->phys_addr + efi_md_size(md));
+	return (kmd->start + (kmd->num_pages << EFI_PAGE_SHIFT));
 }
 
 static inline int
@@ -341,17 +154,12 @@ efi_memmap_walk_uc (efi_freemem_callback_t callback, void *arg)
 void *
 efi_get_pal_addr (void)
 {
-	void *efi_map_start, *efi_map_end, *p;
+	void *p;
 	efi_memory_desc_t *md;
-	u64 efi_desc_size;
 	int pal_code_count = 0;
 	u64 vaddr, mask;
 
-	efi_map_start = __va(ia64_boot_param->efi_memmap);
-	efi_map_end   = efi_map_start + ia64_boot_param->efi_memmap_size;
-	efi_desc_size = ia64_boot_param->efi_memdesc_size;
-
-	for (p = efi_map_start; p < efi_map_end; p += efi_desc_size) {
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if (md->type != EFI_PAL_CODE)
 			continue;
@@ -422,7 +230,7 @@ static u8 __init palo_checksum(u8 *buffer, u32 length)
  * Parse and handle PALO table which is published at:
  * http://www.dig64.org/home/DIG64_PALO_R1_0.pdf
  */
-static void __init handle_palo(unsigned long palo_phys)
+void __init handle_palo(unsigned long palo_phys)
 {
 	struct palo_table *palo = __va(palo_phys);
 	u8  checksum;
@@ -462,16 +270,13 @@ efi_map_pal_code (void)
 	ia64_set_psr(psr);		/* restore psr */
 }
 
+void __init efi_arch_runtime_setup(void) {};
+void __init efi_arch_setup(void) {};
+
 void __init
 efi_init (void)
 {
-	void *efi_map_start, *efi_map_end;
-	efi_config_table_t *config_tables;
-	efi_char16_t *c16;
-	u64 efi_desc_size;
-	char *cp, vendor[100] = "unknown";
-	int i;
-	unsigned long palo_phys;
+	char *cp;
 
 	/*
 	 * It's too early to be able to use the standard kernel command line
@@ -498,234 +303,17 @@ efi_init (void)
 		printk(KERN_INFO "Ignoring memory above %lluMB\n",
 		       max_addr >> 20);
 
-	efi.systab = __va(ia64_boot_param->efi_systab);
-
-	/*
-	 * Verify the EFI Table
-	 */
-	if (efi.systab == NULL)
-		panic("Whoa! Can't find EFI system table.\n");
-	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
-		panic("Whoa! EFI system table signature incorrect\n");
-	if ((efi.systab->hdr.revision >> 16) == 0)
-		printk(KERN_WARNING "Warning: EFI system table version "
-		       "%d.%02d, expected 1.00 or greater\n",
-		       efi.systab->hdr.revision >> 16,
-		       efi.systab->hdr.revision & 0xffff);
-
-	config_tables = __va(efi.systab->tables);
-
-	/* Show what we know for posterity */
-	c16 = __va(efi.systab->fw_vendor);
-	if (c16) {
-		for (i = 0;i < (int) sizeof(vendor) - 1 && *c16; ++i)
-			vendor[i] = *c16++;
-		vendor[i] = '\0';
-	}
-
-	printk(KERN_INFO "EFI v%u.%.02u by %s:",
-	       efi.systab->hdr.revision >> 16,
-	       efi.systab->hdr.revision & 0xffff, vendor);
-
-	efi.mps        = EFI_INVALID_TABLE_ADDR;
-	efi.acpi       = EFI_INVALID_TABLE_ADDR;
-	efi.acpi20     = EFI_INVALID_TABLE_ADDR;
-	efi.smbios     = EFI_INVALID_TABLE_ADDR;
-	efi.sal_systab = EFI_INVALID_TABLE_ADDR;
-	efi.boot_info  = EFI_INVALID_TABLE_ADDR;
-	efi.hcdp       = EFI_INVALID_TABLE_ADDR;
-	efi.uga        = EFI_INVALID_TABLE_ADDR;
-
-	palo_phys      = EFI_INVALID_TABLE_ADDR;
-
-	for (i = 0; i < (int) efi.systab->nr_tables; i++) {
-		if (efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID) == 0) {
-			efi.mps = config_tables[i].table;
-			printk(" MPS=0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, ACPI_20_TABLE_GUID) == 0) {
-			efi.acpi20 = config_tables[i].table;
-			printk(" ACPI 2.0=0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, ACPI_TABLE_GUID) == 0) {
-			efi.acpi = config_tables[i].table;
-			printk(" ACPI=0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, SMBIOS_TABLE_GUID) == 0) {
-			efi.smbios = config_tables[i].table;
-			printk(" SMBIOS=0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, SAL_SYSTEM_TABLE_GUID) == 0) {
-			efi.sal_systab = config_tables[i].table;
-			printk(" SALsystab=0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, HCDP_TABLE_GUID) == 0) {
-			efi.hcdp = config_tables[i].table;
-			printk(" HCDP=0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid,
-			 PROCESSOR_ABSTRACTION_LAYER_OVERWRITE_GUID) == 0) {
-			palo_phys = config_tables[i].table;
-			printk(" PALO=0x%lx", config_tables[i].table);
-		}
-	}
-	printk("\n");
-
-	if (palo_phys != EFI_INVALID_TABLE_ADDR)
-		handle_palo(palo_phys);
-
-	runtime = __va(efi.systab->runtime);
-	efi.get_time = phys_get_time;
-	efi.set_time = phys_set_time;
-	efi.get_wakeup_time = phys_get_wakeup_time;
-	efi.set_wakeup_time = phys_set_wakeup_time;
-	efi.get_variable = phys_get_variable;
-	efi.get_next_variable = phys_get_next_variable;
-	efi.set_variable = phys_set_variable;
-	efi.get_next_high_mono_count = phys_get_next_high_mono_count;
-	efi.reset_system = phys_reset_system;
-
-	efi_map_start = __va(ia64_boot_param->efi_memmap);
-	efi_map_end   = efi_map_start + ia64_boot_param->efi_memmap_size;
-	efi_desc_size = ia64_boot_param->efi_memdesc_size;
+	memmap.phys_map = (void *)ia64_boot_param->efi_memmap;
+	memmap.desc_size = ia64_boot_param->efi_memdesc_size;
+	memmap.desc_version = ia64_boot_param->efi_memdesc_version;
+	memmap.nr_map = ia64_boot_param->efi_memmap_size / memmap.desc_size;
 
-#if EFI_DEBUG
-	/* print EFI memory map: */
-	{
-		efi_memory_desc_t *md;
-		void *p;
-
-		for (i = 0, p = efi_map_start; p < efi_map_end;
-		     ++i, p += efi_desc_size)
-		{
-			const char *unit;
-			unsigned long size;
-
-			md = p;
-			size = md->num_pages << EFI_PAGE_SHIFT;
-
-			if ((size >> 40) > 0) {
-				size >>= 40;
-				unit = "TB";
-			} else if ((size >> 30) > 0) {
-				size >>= 30;
-				unit = "GB";
-			} else if ((size >> 20) > 0) {
-				size >>= 20;
-				unit = "MB";
-			} else {
-				size >>= 10;
-				unit = "KB";
-			}
+	efi_phys.systab = (efi_system_table_t *)ia64_boot_param->efi_systab;
 
-			printk("mem%02d: type=%2u, attr=0x%016lx, "
-			       "range=[0x%016lx-0x%016lx) (%4lu%s)\n",
-			       i, md->type, md->attribute, md->phys_addr,
-			       md->phys_addr + efi_md_size(md), size, unit);
-		}
-	}
-#endif
+	efi_setup_systab(__va(efi_phys.systab));
 
 	efi_map_pal_code();
-	efi_enter_virtual_mode();
-}
-
-void
-efi_enter_virtual_mode (void)
-{
-	void *efi_map_start, *efi_map_end, *p;
-	efi_memory_desc_t *md;
-	efi_status_t status;
-	u64 efi_desc_size;
-
-	efi_map_start = __va(ia64_boot_param->efi_memmap);
-	efi_map_end   = efi_map_start + ia64_boot_param->efi_memmap_size;
-	efi_desc_size = ia64_boot_param->efi_memdesc_size;
-
-	for (p = efi_map_start; p < efi_map_end; p += efi_desc_size) {
-		md = p;
-		if (md->attribute & EFI_MEMORY_RUNTIME) {
-			/*
-			 * Some descriptors have multiple bits set, so the
-			 * order of the tests is relevant.
-			 */
-			if (md->attribute & EFI_MEMORY_WB) {
-				md->virt_addr = (u64) __va(md->phys_addr);
-			} else if (md->attribute & EFI_MEMORY_UC) {
-				md->virt_addr = (u64) ioremap(md->phys_addr, 0);
-			} else if (md->attribute & EFI_MEMORY_WC) {
-#if 0
-				md->virt_addr = ia64_remap(md->phys_addr,
-							   (_PAGE_A |
-							    _PAGE_P |
-							    _PAGE_D |
-							    _PAGE_MA_WC |
-							    _PAGE_PL_0 |
-							    _PAGE_AR_RW));
-#else
-				printk(KERN_INFO "EFI_MEMORY_WC mapping\n");
-				md->virt_addr = (u64) ioremap(md->phys_addr, 0);
-#endif
-			} else if (md->attribute & EFI_MEMORY_WT) {
-#if 0
-				md->virt_addr = ia64_remap(md->phys_addr,
-							   (_PAGE_A |
-							    _PAGE_P |
-							    _PAGE_D |
-							    _PAGE_MA_WT |
-							    _PAGE_PL_0 |
-							    _PAGE_AR_RW));
-#else
-				printk(KERN_INFO "EFI_MEMORY_WT mapping\n");
-				md->virt_addr = (u64) ioremap(md->phys_addr, 0);
-#endif
-			}
-		}
-	}
-
-	status = efi_call_phys(__va(runtime->set_virtual_address_map),
-			       ia64_boot_param->efi_memmap_size,
-			       efi_desc_size,
-			       ia64_boot_param->efi_memdesc_version,
-			       ia64_boot_param->efi_memmap);
-	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "warning: unable to switch EFI into "
-		       "virtual mode (status=%lu)\n", status);
-		return;
-	}
-
-	/*
-	 * Now that EFI is in virtual mode, we call the EFI functions more
-	 * efficiently:
-	 */
-	efi.get_time = virt_get_time;
-	efi.set_time = virt_set_time;
-	efi.get_wakeup_time = virt_get_wakeup_time;
-	efi.set_wakeup_time = virt_set_wakeup_time;
-	efi.get_variable = virt_get_variable;
-	efi.get_next_variable = virt_get_next_variable;
-	efi.set_variable = virt_set_variable;
-	efi.get_next_high_mono_count = virt_get_next_high_mono_count;
-	efi.reset_system = virt_reset_system;
-}
-
-/*
- * Walk the EFI memory map looking for the I/O port range.  There can only be
- * one entry of this type, other I/O port ranges should be described via ACPI.
- */
-u64
-efi_get_iobase (void)
-{
-	void *efi_map_start, *efi_map_end, *p;
-	efi_memory_desc_t *md;
-	u64 efi_desc_size;
-
-	efi_map_start = __va(ia64_boot_param->efi_memmap);
-	efi_map_end   = efi_map_start + ia64_boot_param->efi_memmap_size;
-	efi_desc_size = ia64_boot_param->efi_memdesc_size;
-
-	for (p = efi_map_start; p < efi_map_end; p += efi_desc_size) {
-		md = p;
-		if (md->type == EFI_MEMORY_MAPPED_IO_PORT_SPACE) {
-			if (md->attribute & EFI_MEMORY_UC)
-				return md->phys_addr;
-		}
-	}
-	return 0;
+	efi_enter_virtual_mode(false);
 }
 
 static struct kern_memdesc *
@@ -740,41 +328,16 @@ kern_memory_descriptor (unsigned long phys_addr)
 	return NULL;
 }
 
-static efi_memory_desc_t *
-efi_memory_descriptor (unsigned long phys_addr)
-{
-	void *efi_map_start, *efi_map_end, *p;
-	efi_memory_desc_t *md;
-	u64 efi_desc_size;
-
-	efi_map_start = __va(ia64_boot_param->efi_memmap);
-	efi_map_end   = efi_map_start + ia64_boot_param->efi_memmap_size;
-	efi_desc_size = ia64_boot_param->efi_memdesc_size;
-
-	for (p = efi_map_start; p < efi_map_end; p += efi_desc_size) {
-		md = p;
-
-		if (phys_addr - md->phys_addr < efi_md_size(md))
-			 return md;
-	}
-	return NULL;
-}
-
 static int
 efi_memmap_intersects (unsigned long phys_addr, unsigned long size)
 {
-	void *efi_map_start, *efi_map_end, *p;
+	void *p;
 	efi_memory_desc_t *md;
-	u64 efi_desc_size;
 	unsigned long end;
 
-	efi_map_start = __va(ia64_boot_param->efi_memmap);
-	efi_map_end   = efi_map_start + ia64_boot_param->efi_memmap_size;
-	efi_desc_size = ia64_boot_param->efi_memdesc_size;
-
 	end = phys_addr + size;
 
-	for (p = efi_map_start; p < efi_map_end; p += efi_desc_size) {
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if (md->phys_addr < end && efi_md_end(md) > phys_addr)
 			return 1;
@@ -782,55 +345,6 @@ efi_memmap_intersects (unsigned long phys_addr, unsigned long size)
 	return 0;
 }
 
-u32
-efi_mem_type (unsigned long phys_addr)
-{
-	efi_memory_desc_t *md = efi_memory_descriptor(phys_addr);
-
-	if (md)
-		return md->type;
-	return 0;
-}
-
-u64
-efi_mem_attributes (unsigned long phys_addr)
-{
-	efi_memory_desc_t *md = efi_memory_descriptor(phys_addr);
-
-	if (md)
-		return md->attribute;
-	return 0;
-}
-EXPORT_SYMBOL(efi_mem_attributes);
-
-u64
-efi_mem_attribute (unsigned long phys_addr, unsigned long size)
-{
-	unsigned long end = phys_addr + size;
-	efi_memory_desc_t *md = efi_memory_descriptor(phys_addr);
-	u64 attr;
-
-	if (!md)
-		return 0;
-
-	/*
-	 * EFI_MEMORY_RUNTIME is not a memory attribute; it just tells
-	 * the kernel that firmware needs this region mapped.
-	 */
-	attr = md->attribute & ~EFI_MEMORY_RUNTIME;
-	do {
-		unsigned long md_end = efi_md_end(md);
-
-		if (end <= md_end)
-			return attr;
-
-		md = efi_memory_descriptor(md_end);
-		if (!md || (md->attribute & ~EFI_MEMORY_RUNTIME) != attr)
-			return 0;
-	} while (md);
-	return 0;	/* never reached */
-}
-
 u64
 kern_mem_attribute (unsigned long phys_addr, unsigned long size)
 {
@@ -996,24 +510,20 @@ find_memmap_space (void)
 {
 	u64	contig_low=0, contig_high=0;
 	u64	as = 0, ae;
-	void *efi_map_start, *efi_map_end, *p, *q;
+	void *p, *q;
 	efi_memory_desc_t *md, *pmd = NULL, *check_md;
-	u64	space_needed, efi_desc_size;
+	u64	space_needed;
 	unsigned long total_mem = 0;
 
-	efi_map_start = __va(ia64_boot_param->efi_memmap);
-	efi_map_end   = efi_map_start + ia64_boot_param->efi_memmap_size;
-	efi_desc_size = ia64_boot_param->efi_memdesc_size;
-
 	/*
 	 * Worst case: we need 3 kernel descriptors for each efi descriptor
 	 * (if every entry has a WB part in the middle, and UC head and tail),
 	 * plus one for the end marker.
 	 */
 	space_needed = sizeof(kern_memdesc_t) *
-		(3 * (ia64_boot_param->efi_memmap_size/efi_desc_size) + 1);
+		(3 * (ia64_boot_param->efi_memmap_size/memmap.desc_size) + 1);
 
-	for (p = efi_map_start; p < efi_map_end; pmd = md, p += efi_desc_size) {
+	for (p = memmap.map; p < memmap.map_end; pmd = md, p += memmap.desc_size) {
 		md = p;
 		if (!efi_wb(md)) {
 			continue;
@@ -1022,8 +532,8 @@ find_memmap_space (void)
 		    efi_md_end(pmd) != md->phys_addr) {
 			contig_low = GRANULEROUNDUP(md->phys_addr);
 			contig_high = efi_md_end(md);
-			for (q = p + efi_desc_size; q < efi_map_end;
-			     q += efi_desc_size) {
+			for (q = p + memmap.desc_size; q < memmap.map_end;
+			     q += memmap.desc_size) {
 				check_md = q;
 				if (!efi_wb(check_md))
 					break;
@@ -1056,7 +566,7 @@ find_memmap_space (void)
 		if (ae - as > space_needed)
 			break;
 	}
-	if (p >= efi_map_end)
+	if (p >= memmap.map_end)
 		panic("Can't allocate space for kernel memory descriptors");
 
 	return __va(as);
@@ -1073,18 +583,13 @@ efi_memmap_init(u64 *s, u64 *e)
 	struct kern_memdesc *k, *prev = NULL;
 	u64	contig_low=0, contig_high=0;
 	u64	as, ae, lim;
-	void *efi_map_start, *efi_map_end, *p, *q;
+	void *p, *q;
 	efi_memory_desc_t *md, *pmd = NULL, *check_md;
-	u64	efi_desc_size;
 	unsigned long total_mem = 0;
 
 	k = kern_memmap = find_memmap_space();
 
-	efi_map_start = __va(ia64_boot_param->efi_memmap);
-	efi_map_end   = efi_map_start + ia64_boot_param->efi_memmap_size;
-	efi_desc_size = ia64_boot_param->efi_memdesc_size;
-
-	for (p = efi_map_start; p < efi_map_end; pmd = md, p += efi_desc_size) {
+	for (p = memmap.map; p < memmap.map_end; pmd = md, p += memmap.desc_size) {
 		md = p;
 		if (!efi_wb(md)) {
 			if (efi_uc(md) &&
@@ -1101,8 +606,8 @@ efi_memmap_init(u64 *s, u64 *e)
 		    efi_md_end(pmd) != md->phys_addr) {
 			contig_low = GRANULEROUNDUP(md->phys_addr);
 			contig_high = efi_md_end(md);
-			for (q = p + efi_desc_size; q < efi_map_end;
-			     q += efi_desc_size) {
+			for (q = p + memmap.desc_size; q < memmap.map_end;
+			     q += memmap.desc_size) {
 				check_md = q;
 				if (!efi_wb(check_md))
 					break;
@@ -1202,19 +707,14 @@ efi_initialize_iomem_resources(struct resource *code_resource,
 			       struct resource *bss_resource)
 {
 	struct resource *res;
-	void *efi_map_start, *efi_map_end, *p;
+	void *p;
 	efi_memory_desc_t *md;
-	u64 efi_desc_size;
 	char *name;
 	unsigned long flags;
 
-	efi_map_start = __va(ia64_boot_param->efi_memmap);
-	efi_map_end   = efi_map_start + ia64_boot_param->efi_memmap_size;
-	efi_desc_size = ia64_boot_param->efi_memdesc_size;
-
 	res = NULL;
 
-	for (p = efi_map_start; p < efi_map_end; p += efi_desc_size) {
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 
 		if (md->num_pages == 0) /* should not happen */
@@ -1302,15 +802,10 @@ kdump_find_rsvd_region (unsigned long size, struct rsvd_region *r, int n)
 	int i;
 	u64 start, end;
 	u64 alignment = 1UL << _PAGE_SIZE_64M;
-	void *efi_map_start, *efi_map_end, *p;
+	void *p;
 	efi_memory_desc_t *md;
-	u64 efi_desc_size;
 
-	efi_map_start = __va(ia64_boot_param->efi_memmap);
-	efi_map_end   = efi_map_start + ia64_boot_param->efi_memmap_size;
-	efi_desc_size = ia64_boot_param->efi_memdesc_size;
-
-	for (p = efi_map_start; p < efi_map_end; p += efi_desc_size) {
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if (!efi_wb(md))
 			continue;
@@ -1343,16 +838,11 @@ kdump_find_rsvd_region (unsigned long size, struct rsvd_region *r, int n)
 unsigned long __init
 vmcore_find_descriptor_size (unsigned long address)
 {
-	void *efi_map_start, *efi_map_end, *p;
+	void *p;
 	efi_memory_desc_t *md;
-	u64 efi_desc_size;
 	unsigned long ret = 0;
 
-	efi_map_start = __va(ia64_boot_param->efi_memmap);
-	efi_map_end   = efi_map_start + ia64_boot_param->efi_memmap_size;
-	efi_desc_size = ia64_boot_param->efi_memdesc_size;
-
-	for (p = efi_map_start; p < efi_map_end; p += efi_desc_size) {
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if (efi_wb(md) && md->type == EFI_LOADER_DATA
 		    && md->phys_addr == address) {
diff --git a/arch/ia64/kernel/efi_stub.S b/arch/ia64/kernel/efi_stub.S
index a56e161..692e407 100644
--- a/arch/ia64/kernel/efi_stub.S
+++ b/arch/ia64/kernel/efi_stub.S
@@ -42,7 +42,7 @@
  *	r8 = EFI_STATUS returned by called function
  */
 
-GLOBAL_ENTRY(efi_call_phys)
+GLOBAL_ENTRY(efi_real_call_phys)
 	.prologue ASM_UNW_PRLG_RP|ASM_UNW_PRLG_PFS, ASM_UNW_PRLG_GRSAVE(8)
 	alloc loc1=ar.pfs,8,7,7,0
 	ld8 r2=[in0],8			// load EFI function's entry point
@@ -83,4 +83,4 @@ GLOBAL_ENTRY(efi_call_phys)
 	mov rp=loc0
 	mov gp=loc2
 	br.ret.sptk.many rp
-END(efi_call_phys)
+END(efi_real_call_phys)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fc76e42..910b588 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1437,6 +1437,10 @@ config EFI
 	  resultant kernel should continue to boot on existing non-EFI
 	  platforms.
 
+config EFI_THUNK_CALLS
+       def_bool y
+       depends on X86_64 && EFI
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 7093e4a..0504a83 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -1,20 +1,14 @@
 #ifndef _ASM_X86_EFI_H
 #define _ASM_X86_EFI_H
 
+#define EFI_DEBUG	1
+
 #ifdef CONFIG_X86_32
 
+#define efi_ioremap(x) (u32) ioremap_cache(x->phys_addr, efi_md_size(x))
+
 extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
-#define efi_call_phys0(f)		efi_call_phys(f)
-#define efi_call_phys1(f, a1)		efi_call_phys(f, a1)
-#define efi_call_phys2(f, a1, a2)	efi_call_phys(f, a1, a2)
-#define efi_call_phys3(f, a1, a2, a3)	efi_call_phys(f, a1, a2, a3)
-#define efi_call_phys4(f, a1, a2, a3, a4)	\
-	efi_call_phys(f, a1, a2, a3, a4)
-#define efi_call_phys5(f, a1, a2, a3, a4, a5)	\
-	efi_call_phys(f, a1, a2, a3, a4, a5)
-#define efi_call_phys6(f, a1, a2, a3, a4, a5, a6)	\
-	efi_call_phys(f, a1, a2, a3, a4, a5, a6)
 /*
  * Wrap all the virtual calls in a way that forces the parameters on the stack.
  */
@@ -22,19 +16,6 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 #define efi_call_virt(f, args...) \
 	((efi_##f##_t __attribute__((regparm(0)))*)efi.systab->runtime->f)(args)
 
-#define efi_call_virt0(f)		efi_call_virt(f)
-#define efi_call_virt1(f, a1)		efi_call_virt(f, a1)
-#define efi_call_virt2(f, a1, a2)	efi_call_virt(f, a1, a2)
-#define efi_call_virt3(f, a1, a2, a3)	efi_call_virt(f, a1, a2, a3)
-#define efi_call_virt4(f, a1, a2, a3, a4)	\
-	efi_call_virt(f, a1, a2, a3, a4)
-#define efi_call_virt5(f, a1, a2, a3, a4, a5)	\
-	efi_call_virt(f, a1, a2, a3, a4, a5)
-#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
-	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
-
-#define efi_ioremap(addr, size, type)		ioremap_cache(addr, size)
-
 #else /* !CONFIG_X86_32 */
 
 extern u64 efi_call0(void *fp);
@@ -84,16 +65,18 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
-extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
-				 u32 type);
-
 #endif /* CONFIG_X86_32 */
 
+#define efi_phys_arg(arg) arg
+
 extern int add_efi_memmap;
 extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern void efi_memblock_x86_reserve_range(void);
-extern void efi_call_phys_prelog(void);
-extern void efi_call_phys_epilog(void);
+extern void *efi_call_phys_prelog(void);
+extern void efi_call_phys_epilog(void *opaque);
+
+#define efi_call_virt_prelog(x) NULL
+#define efi_call_virt_epilog(x) {}
 
 #ifndef CONFIG_EFI
 /*
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e17c6d2..859c34b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -12,18 +12,6 @@
  *	Bibo Mao <bibo.mao@intel.com>
  *	Chandramouli Narayanan <mouli@linux.intel.com>
  *	Huang Ying <ying.huang@intel.com>
- *
- * Copied from efi_32.c to eliminate the duplicated code between EFI
- * 32/64 support code. --ying 2007-10-26
- *
- * All EFI Runtime Services are not implemented yet as EFI only
- * supports physical mode addressing on SoftSDV. This is to be fixed
- * in a future version.  --drummond 1999-07-20
- *
- * Implemented EFI runtime services and virtual mode calls.  --davidm
- *
- * Goutham Rao: <goutham.rao@intel.com>
- *	Skip non-WB memory and ignore empty memory ranges.
  */
 
 #include <linux/kernel.h>
@@ -31,44 +19,16 @@
 #include <linux/efi.h>
 #include <linux/bootmem.h>
 #include <linux/memblock.h>
-#include <linux/spinlock.h>
-#include <linux/uaccess.h>
-#include <linux/time.h>
-#include <linux/io.h>
-#include <linux/reboot.h>
-#include <linux/bcd.h>
 
 #include <asm/setup.h>
 #include <asm/efi.h>
-#include <asm/time.h>
 #include <asm/cacheflush.h>
-#include <asm/tlbflush.h>
-#include <asm/x86_init.h>
 
-#define EFI_DEBUG	1
 #define PFX 		"EFI: "
 
 int efi_enabled;
 EXPORT_SYMBOL(efi_enabled);
 
-struct efi __read_mostly efi = {
-	.mps        = EFI_INVALID_TABLE_ADDR,
-	.acpi       = EFI_INVALID_TABLE_ADDR,
-	.acpi20     = EFI_INVALID_TABLE_ADDR,
-	.smbios     = EFI_INVALID_TABLE_ADDR,
-	.sal_systab = EFI_INVALID_TABLE_ADDR,
-	.boot_info  = EFI_INVALID_TABLE_ADDR,
-	.hcdp       = EFI_INVALID_TABLE_ADDR,
-	.uga        = EFI_INVALID_TABLE_ADDR,
-	.uv_systab  = EFI_INVALID_TABLE_ADDR,
-};
-EXPORT_SYMBOL(efi);
-
-struct efi_memory_map memmap;
-
-static struct efi efi_phys __initdata;
-static efi_system_table_t efi_systab __initdata;
-
 static int __init setup_noefi(char *arg)
 {
 	efi_enabled = 0;
@@ -86,177 +46,14 @@ static int __init setup_add_efi_memmap(char *arg)
 }
 early_param("add_efi_memmap", setup_add_efi_memmap);
 
-
-static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
-{
-	return efi_call_virt2(get_time, tm, tc);
-}
-
-static efi_status_t virt_efi_set_time(efi_time_t *tm)
-{
-	return efi_call_virt1(set_time, tm);
-}
-
-static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
-					     efi_bool_t *pending,
-					     efi_time_t *tm)
-{
-	return efi_call_virt3(get_wakeup_time,
-			      enabled, pending, tm);
-}
-
-static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
-{
-	return efi_call_virt2(set_wakeup_time,
-			      enabled, tm);
-}
-
-static efi_status_t virt_efi_get_variable(efi_char16_t *name,
-					  efi_guid_t *vendor,
-					  u32 *attr,
-					  unsigned long *data_size,
-					  void *data)
-{
-	return efi_call_virt5(get_variable,
-			      name, vendor, attr,
-			      data_size, data);
-}
-
-static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
-					       efi_char16_t *name,
-					       efi_guid_t *vendor)
-{
-	return efi_call_virt3(get_next_variable,
-			      name_size, name, vendor);
-}
-
-static efi_status_t virt_efi_set_variable(efi_char16_t *name,
-					  efi_guid_t *vendor,
-					  u32 attr,
-					  unsigned long data_size,
-					  void *data)
-{
-	return efi_call_virt5(set_variable,
-			      name, vendor, attr,
-			      data_size, data);
-}
-
-static efi_status_t virt_efi_query_variable_info(u32 attr,
-						 u64 *storage_space,
-						 u64 *remaining_space,
-						 u64 *max_variable_size)
-{
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
-		return EFI_UNSUPPORTED;
-
-	return efi_call_virt4(query_variable_info, attr, storage_space,
-			      remaining_space, max_variable_size);
-}
-
-static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
-{
-	return efi_call_virt1(get_next_high_mono_count, count);
-}
-
-static void virt_efi_reset_system(int reset_type,
-				  efi_status_t status,
-				  unsigned long data_size,
-				  efi_char16_t *data)
-{
-	efi_call_virt4(reset_system, reset_type, status,
-		       data_size, data);
-}
-
-static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
-					    unsigned long count,
-					    unsigned long sg_list)
-{
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
-		return EFI_UNSUPPORTED;
-
-	return efi_call_virt3(update_capsule, capsules, count, sg_list);
-}
-
-static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
-						unsigned long count,
-						u64 *max_size,
-						int *reset_type)
-{
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
-		return EFI_UNSUPPORTED;
-
-	return efi_call_virt4(query_capsule_caps, capsules, count, max_size,
-			      reset_type);
-}
-
-static efi_status_t __init phys_efi_set_virtual_address_map(
-	unsigned long memory_map_size,
-	unsigned long descriptor_size,
-	u32 descriptor_version,
-	efi_memory_desc_t *virtual_map)
-{
-	efi_status_t status;
-
-	efi_call_phys_prelog();
-	status = efi_call_phys4(efi_phys.set_virtual_address_map,
-				memory_map_size, descriptor_size,
-				descriptor_version, virtual_map);
-	efi_call_phys_epilog();
-	return status;
-}
-
-static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
-					     efi_time_cap_t *tc)
+void __init __iomem *efi_map(resource_size_t addr, unsigned long size)
 {
-	efi_status_t status;
-
-	efi_call_phys_prelog();
-	status = efi_call_phys2(efi_phys.get_time, tm, tc);
-	efi_call_phys_epilog();
-	return status;
-}
-
-int efi_set_rtc_mmss(unsigned long nowtime)
-{
-	int real_seconds, real_minutes;
-	efi_status_t 	status;
-	efi_time_t 	eft;
-	efi_time_cap_t 	cap;
-
-	status = efi.get_time(&eft, &cap);
-	if (status != EFI_SUCCESS) {
-		printk(KERN_ERR "Oops: efitime: can't read time!\n");
-		return -1;
-	}
-
-	real_seconds = nowtime % 60;
-	real_minutes = nowtime / 60;
-	if (((abs(real_minutes - eft.minute) + 15)/30) & 1)
-		real_minutes += 30;
-	real_minutes %= 60;
-	eft.minute = real_minutes;
-	eft.second = real_seconds;
-
-	status = efi.set_time(&eft);
-	if (status != EFI_SUCCESS) {
-		printk(KERN_ERR "Oops: efitime: can't write time!\n");
-		return -1;
-	}
-	return 0;
+	return early_ioremap(addr, size);
 }
 
-unsigned long efi_get_time(void)
+void __init efi_unmap(void __iomem *addr, unsigned long size)
 {
-	efi_status_t status;
-	efi_time_t eft;
-	efi_time_cap_t cap;
-
-	status = efi.get_time(&eft, &cap);
-	if (status != EFI_SUCCESS)
-		printk(KERN_ERR "Oops: efitime: can't read time!\n");
-
-	return mktime(eft.year, eft.month, eft.day, eft.hour,
-		      eft.minute, eft.second);
+	early_iounmap(addr, size);
 }
 
 /*
@@ -328,26 +125,6 @@ void __init efi_memblock_x86_reserve_range(void)
 		      "EFI memmap");
 }
 
-#if EFI_DEBUG
-static void __init print_efi_memmap(void)
-{
-	efi_memory_desc_t *md;
-	void *p;
-	int i;
-
-	for (p = memmap.map, i = 0;
-	     p < memmap.map_end;
-	     p += memmap.desc_size, i++) {
-		md = p;
-		printk(KERN_INFO PFX "mem%02u: type=%u, attr=0x%llx, "
-			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
-			i, md->type, md->attribute, md->phys_addr,
-			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
-			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
-	}
-}
-#endif  /*  EFI_DEBUG  */
-
 void __init efi_reserve_boot_services(void)
 {
 	void *p;
@@ -403,156 +180,6 @@ static void __init efi_free_boot_services(void)
 	}
 }
 
-void __init efi_init(void)
-{
-	efi_config_table_t *config_tables;
-	efi_runtime_services_t *runtime;
-	efi_char16_t *c16;
-	char vendor[100] = "unknown";
-	int i = 0;
-	void *tmp;
-
-#ifdef CONFIG_X86_32
-	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
-#else
-	efi_phys.systab = (efi_system_table_t *)
-		(boot_params.efi_info.efi_systab |
-		 ((__u64)boot_params.efi_info.efi_systab_hi<<32));
-#endif
-
-	efi.systab = early_ioremap((unsigned long)efi_phys.systab,
-				   sizeof(efi_system_table_t));
-	if (efi.systab == NULL)
-		printk(KERN_ERR "Couldn't map the EFI system table!\n");
-	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
-	early_iounmap(efi.systab, sizeof(efi_system_table_t));
-	efi.systab = &efi_systab;
-
-	/*
-	 * Verify the EFI Table
-	 */
-	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
-		printk(KERN_ERR "EFI system table signature incorrect!\n");
-	if ((efi.systab->hdr.revision >> 16) == 0)
-		printk(KERN_ERR "Warning: EFI system table version "
-		       "%d.%02d, expected 1.00 or greater!\n",
-		       efi.systab->hdr.revision >> 16,
-		       efi.systab->hdr.revision & 0xffff);
-
-	/*
-	 * Show what we know for posterity
-	 */
-	c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);
-	if (c16) {
-		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
-			vendor[i] = *c16++;
-		vendor[i] = '\0';
-	} else
-		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
-	early_iounmap(tmp, 2);
-
-	printk(KERN_INFO "EFI v%u.%.02u by %s\n",
-	       efi.systab->hdr.revision >> 16,
-	       efi.systab->hdr.revision & 0xffff, vendor);
-
-	/*
-	 * Let's see what config tables the firmware passed to us.
-	 */
-	config_tables = early_ioremap(
-		efi.systab->tables,
-		efi.systab->nr_tables * sizeof(efi_config_table_t));
-	if (config_tables == NULL)
-		printk(KERN_ERR "Could not map EFI Configuration Table!\n");
-
-	printk(KERN_INFO);
-	for (i = 0; i < efi.systab->nr_tables; i++) {
-		if (!efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID)) {
-			efi.mps = config_tables[i].table;
-			printk(" MPS=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					ACPI_20_TABLE_GUID)) {
-			efi.acpi20 = config_tables[i].table;
-			printk(" ACPI 2.0=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					ACPI_TABLE_GUID)) {
-			efi.acpi = config_tables[i].table;
-			printk(" ACPI=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					SMBIOS_TABLE_GUID)) {
-			efi.smbios = config_tables[i].table;
-			printk(" SMBIOS=0x%lx ", config_tables[i].table);
-#ifdef CONFIG_X86_UV
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					UV_SYSTEM_TABLE_GUID)) {
-			efi.uv_systab = config_tables[i].table;
-			printk(" UVsystab=0x%lx ", config_tables[i].table);
-#endif
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					HCDP_TABLE_GUID)) {
-			efi.hcdp = config_tables[i].table;
-			printk(" HCDP=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					UGA_IO_PROTOCOL_GUID)) {
-			efi.uga = config_tables[i].table;
-			printk(" UGA=0x%lx ", config_tables[i].table);
-		}
-	}
-	printk("\n");
-	early_iounmap(config_tables,
-			  efi.systab->nr_tables * sizeof(efi_config_table_t));
-
-	/*
-	 * Check out the runtime services table. We need to map
-	 * the runtime services table so that we can grab the physical
-	 * address of several of the EFI runtime functions, needed to
-	 * set the firmware into virtual mode.
-	 */
-	runtime = early_ioremap((unsigned long)efi.systab->runtime,
-				sizeof(efi_runtime_services_t));
-	if (runtime != NULL) {
-		/*
-		 * We will only need *early* access to the following
-		 * two EFI runtime services before set_virtual_address_map
-		 * is invoked.
-		 */
-		efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
-		efi_phys.set_virtual_address_map =
-			(efi_set_virtual_address_map_t *)
-			runtime->set_virtual_address_map;
-		/*
-		 * Make efi_get_time can be called before entering
-		 * virtual mode.
-		 */
-		efi.get_time = phys_efi_get_time;
-	} else
-		printk(KERN_ERR "Could not map the EFI runtime service "
-		       "table!\n");
-	early_iounmap(runtime, sizeof(efi_runtime_services_t));
-
-	/* Map the EFI memory map */
-	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
-				   memmap.nr_map * memmap.desc_size);
-	if (memmap.map == NULL)
-		printk(KERN_ERR "Could not map the EFI memory map!\n");
-	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
-
-	if (memmap.desc_size != sizeof(efi_memory_desc_t))
-		printk(KERN_WARNING
-		  "Kernel-defined memdesc doesn't match the one from EFI!\n");
-
-	if (add_efi_memmap)
-		do_add_efi_memmap();
-
-#ifdef CONFIG_X86_32
-	x86_platform.get_wallclock = efi_get_time;
-	x86_platform.set_wallclock = efi_set_rtc_mmss;
-#endif
-
-#if EFI_DEBUG
-	print_efi_memmap();
-#endif
-}
-
 void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
 {
 	u64 addr, npages;
@@ -584,112 +211,8 @@ static void __init runtime_code_page_mkexec(void)
 	}
 }
 
-/*
- * This function will switch the EFI runtime services to virtual mode.
- * Essentially, look through the EFI memmap and map every region that
- * has the runtime attribute bit set in its memory descriptor and update
- * that memory descriptor with the virtual address obtained from ioremap().
- * This enables the runtime services to be called without having to
- * thunk back into physical mode for every invocation.
- */
-void __init efi_enter_virtual_mode(void)
+void __init efi_arch_runtime_setup(void)
 {
-	efi_memory_desc_t *md, *prev_md = NULL;
-	efi_status_t status;
-	unsigned long size;
-	u64 end, systab, addr, npages, end_pfn;
-	void *p, *va, *new_memmap = NULL;
-	int count = 0;
-
-	efi.systab = NULL;
-
-	/* Merge contiguous regions of the same type and attribute */
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		u64 prev_size;
-		md = p;
-
-		if (!prev_md) {
-			prev_md = md;
-			continue;
-		}
-
-		if (prev_md->type != md->type ||
-		    prev_md->attribute != md->attribute) {
-			prev_md = md;
-			continue;
-		}
-
-		prev_size = prev_md->num_pages << EFI_PAGE_SHIFT;
-
-		if (md->phys_addr == (prev_md->phys_addr + prev_size)) {
-			prev_md->num_pages += md->num_pages;
-			md->type = EFI_RESERVED_TYPE;
-			md->attribute = 0;
-			continue;
-		}
-		prev_md = md;
-	}
-
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
-
-		size = md->num_pages << EFI_PAGE_SHIFT;
-		end = md->phys_addr + size;
-
-		end_pfn = PFN_UP(end);
-		if (end_pfn <= max_low_pfn_mapped
-		    || (end_pfn > (1UL << (32 - PAGE_SHIFT))
-			&& end_pfn <= max_pfn_mapped))
-			va = __va(md->phys_addr);
-		else
-			va = efi_ioremap(md->phys_addr, size, md->type);
-
-		md->virt_addr = (u64) (unsigned long) va;
-
-		if (!va) {
-			printk(KERN_ERR PFX "ioremap of 0x%llX failed!\n",
-			       (unsigned long long)md->phys_addr);
-			continue;
-		}
-
-		if (!(md->attribute & EFI_MEMORY_WB)) {
-			addr = md->virt_addr;
-			npages = md->num_pages;
-			memrange_efi_to_native(&addr, &npages);
-			set_memory_uc(addr, npages);
-		}
-
-		systab = (u64) (unsigned long) efi_phys.systab;
-		if (md->phys_addr <= systab && systab < end) {
-			systab += md->virt_addr - md->phys_addr;
-			efi.systab = (efi_system_table_t *) (unsigned long) systab;
-		}
-		new_memmap = krealloc(new_memmap,
-				      (count + 1) * memmap.desc_size,
-				      GFP_KERNEL);
-		memcpy(new_memmap + (count * memmap.desc_size), md,
-		       memmap.desc_size);
-		count++;
-	}
-
-	BUG_ON(!efi.systab);
-
-	status = phys_efi_set_virtual_address_map(
-		memmap.desc_size * count,
-		memmap.desc_size,
-		memmap.desc_version,
-		(efi_memory_desc_t *)__pa(new_memmap));
-
-	if (status != EFI_SUCCESS) {
-		printk(KERN_ALERT "Unable to switch EFI into virtual mode "
-		       "(status=%lx)!\n", status);
-		panic("EFI call to SetVirtualAddressMap() failed!");
-	}
-
 	/*
 	 * Thankfully, it does seem that no runtime services other than
 	 * SetVirtualAddressMap() will touch boot services code, so we can
@@ -697,61 +220,37 @@ void __init efi_enter_virtual_mode(void)
 	 */
 	efi_free_boot_services();
 
-	/*
-	 * Now that EFI is in virtual mode, update the function
-	 * pointers in the runtime service table to the new virtual addresses.
-	 *
-	 * Call EFI services through wrapper functions.
-	 */
-	efi.get_time = virt_efi_get_time;
-	efi.set_time = virt_efi_set_time;
-	efi.get_wakeup_time = virt_efi_get_wakeup_time;
-	efi.set_wakeup_time = virt_efi_set_wakeup_time;
-	efi.get_variable = virt_efi_get_variable;
-	efi.get_next_variable = virt_efi_get_next_variable;
-	efi.set_variable = virt_efi_set_variable;
-	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
-	efi.reset_system = virt_efi_reset_system;
-	efi.set_virtual_address_map = NULL;
-	efi.query_variable_info = virt_efi_query_variable_info;
-	efi.update_capsule = virt_efi_update_capsule;
-	efi.query_capsule_caps = virt_efi_query_capsule_caps;
 	if (__supported_pte_mask & _PAGE_NX)
 		runtime_code_page_mkexec();
-	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
+	efi_unmap(memmap.map, memmap.nr_map * memmap.desc_size);
 	memmap.map = NULL;
-	kfree(new_memmap);
 }
 
-/*
- * Convenience functions to obtain memory types and attributes
- */
-u32 efi_mem_type(unsigned long phys_addr)
+void __init efi_init(void)
 {
-	efi_memory_desc_t *md;
-	void *p;
+	efi_system_table_t *systab;
+#ifdef CONFIG_X86_32
+	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
+#else
+	efi_phys.systab = (efi_system_table_t *)
+		(boot_params.efi_info.efi_systab |
+		 ((__u64)boot_params.efi_info.efi_systab_hi<<32));
+#endif
+	systab = efi_map((unsigned long)efi_phys.systab,
+			  sizeof(efi_system_table_t));
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		if ((md->phys_addr <= phys_addr) &&
-		    (phys_addr < (md->phys_addr +
-				  (md->num_pages << EFI_PAGE_SHIFT))))
-			return md->type;
-	}
-	return 0;
+	efi_setup_systab(systab);
+
+	efi_unmap(systab, sizeof(efi_system_table_t));
 }
 
-u64 efi_mem_attributes(unsigned long phys_addr)
+void __init efi_arch_setup(void)
 {
-	efi_memory_desc_t *md;
-	void *p;
+	if (add_efi_memmap)
+		do_add_efi_memmap();
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		if ((md->phys_addr <= phys_addr) &&
-		    (phys_addr < (md->phys_addr +
-				  (md->num_pages << EFI_PAGE_SHIFT))))
-			return md->attribute;
-	}
-	return 0;
+#ifdef CONFIG_X86_32
+	x86_platform.get_wallclock = efi_get_time;
+	x86_platform.set_wallclock = efi_set_rtc_mmss;
+#endif
 }
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 5cab48e..850204d 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -40,7 +40,7 @@
 static unsigned long efi_rt_eflags;
 static pgd_t efi_bak_pg_dir_pointer[2];
 
-void efi_call_phys_prelog(void)
+void *efi_call_phys_prelog(void)
 {
 	unsigned long cr4;
 	unsigned long temp;
@@ -80,9 +80,11 @@ void efi_call_phys_prelog(void)
 	gdt_descr.address = __pa(get_cpu_gdt_table(0));
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
+
+	return NULL;
 }
 
-void efi_call_phys_epilog(void)
+void efi_call_phys_epilog(void *opaque)
 {
 	unsigned long cr4;
 	struct desc_ptr gdt_descr;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index ac3aa54..3fa2d93 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -58,7 +58,7 @@ static void __init early_code_mapping_set_exec(int executable)
 	}
 }
 
-void __init efi_call_phys_prelog(void)
+void __init *efi_call_phys_prelog(void)
 {
 	unsigned long vaddress;
 
@@ -68,9 +68,10 @@ void __init efi_call_phys_prelog(void)
 	save_pgd = *pgd_offset_k(0x0UL);
 	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
 	__flush_tlb_all();
+	return NULL;
 }
 
-void __init efi_call_phys_epilog(void)
+void __init efi_call_phys_epilog(void *dummy)
 {
 	/*
 	 * After the lock is released, the original page table is restored.
@@ -81,19 +82,40 @@ void __init efi_call_phys_epilog(void)
 	early_code_mapping_set_exec(0);
 }
 
-void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
-				 u32 type)
+unsigned long __init efi_ioremap(efi_memory_desc_t *md)
 {
 	unsigned long last_map_pfn;
+	unsigned long phys_addr = md->phys_addr;
+	unsigned long size = efi_md_size(md);
+	void *va;
+	u64 addr, npages, end_pfn = PFN_UP(efi_md_end(md));
 
-	if (type == EFI_MEMORY_MAPPED_IO)
-		return ioremap(phys_addr, size);
+	if (end_pfn <= max_low_pfn_mapped
+	    || (end_pfn > (1UL << (32 - PAGE_SHIFT))
+		&& end_pfn <= max_pfn_mapped)) {
+		va = __va(md->phys_addr);
+	} else if (md->type == EFI_MEMORY_MAPPED_IO) {
+		va = ioremap(phys_addr, size);
+	} else {
+		last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
+		if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
+			unsigned long top = last_map_pfn << PAGE_SHIFT;
+			efi_memory_desc_t new_md;
 
-	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
-	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
-		unsigned long top = last_map_pfn << PAGE_SHIFT;
-		efi_ioremap(top, size - (top - phys_addr), type);
+			memcpy(&new_md, md, sizeof(efi_memory_desc_t));
+			new_md.phys_addr = top;
+			new_md.num_pages = (size - (top - phys_addr)) >> EFI_PAGE_SHIFT;
+			efi_ioremap(&new_md);
+		}
+		va = __va(phys_addr);
 	}
 
-	return (void __iomem *)__va(phys_addr);
+	if (!(md->attribute & EFI_MEMORY_WB)) {
+		addr = (unsigned long)va;
+		npages = md->num_pages;
+		memrange_efi_to_native(&addr, &npages);
+		set_memory_uc(addr, npages);
+	}
+
+	return (unsigned long)va;
 }
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 47338c9..fbe8397 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -15,3 +15,4 @@ obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
 obj-$(CONFIG_SIGMA)		+= sigma.o
 
 obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
+obj-$(CONFIG_EFI)		+= efi/
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
new file mode 100644
index 0000000..de5a8ba
--- /dev/null
+++ b/drivers/firmware/efi/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_EFI)		+= efi.o
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
new file mode 100644
index 0000000..b1c4629
--- /dev/null
+++ b/drivers/firmware/efi/efi.c
@@ -0,0 +1,657 @@
+/*
+ * Platform independent EFI code
+ *
+ * Copyright 2011 Red Hat <mjg@redhat.com>
+ *
+ * Based on the x86 and IA64 EFI code:
+ * Copyright (C) 1999 VA Linux Systems
+ * Copyright (C) 1999 Walt Drummond <drummond@valinux.com>
+ * Copyright (C) 1999-2002 Hewlett-Packard Co.
+ *      David Mosberger-Tang <davidm@hpl.hp.com>
+ *      Stephane Eranian <eranian@hpl.hp.com>
+ * (c) Copyright 2006 Hewlett-Packard Development Company, L.P.
+ *      Bjorn Helgaas <bjorn.helgaas@hp.com>
+ * Copyright (C) 2005-2008 Intel Co.
+ *      Fenghua Yu <fenghua.yu@intel.com>
+ *      Bibo Mao <bibo.mao@intel.com>
+ *      Chandramouli Narayanan <mouli@linux.intel.com>
+ *      Huang Ying <ying.huang@intel.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/efi.h>
+
+#include <asm/efi.h>
+
+#define PFX		"EFI: "
+
+struct efi efi_phys __initdata;
+static efi_system_table_t efi_systab __initdata;
+static efi_runtime_services_t *runtime;
+
+struct efi efi;
+EXPORT_SYMBOL(efi);
+
+struct efi_memory_map memmap;
+
+static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	void *opaque;
+	efi_status_t status;
+
+	opaque = efi_call_virt_prelog();
+	status = efi_call_virt2(get_time, tm, tc);
+	efi_call_virt_epilog(opaque);
+	return status;
+}
+
+static efi_status_t virt_efi_set_time(efi_time_t *tm)
+{
+	void *opaque;
+	efi_status_t status;
+
+	opaque = efi_call_virt_prelog();
+	status = efi_call_virt1(set_time, tm);
+	efi_call_virt_epilog(opaque);
+	return status;
+}
+
+static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
+					     efi_bool_t *pending,
+					     efi_time_t *tm)
+{
+	void *opaque;
+	efi_status_t status;
+
+	opaque = efi_call_virt_prelog();
+	status = efi_call_virt3(get_wakeup_time, enabled, pending, tm);
+	efi_call_virt_epilog(opaque);
+	return status;
+}
+
+static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled,
+					     efi_time_t *tm)
+{
+	void *opaque;
+	efi_status_t status;
+
+	opaque = efi_call_virt_prelog();
+	status = efi_call_virt2(set_wakeup_time, enabled, tm);
+	efi_call_virt_epilog(opaque);
+	return status;
+}
+
+static efi_status_t virt_efi_get_variable(efi_char16_t *name,
+					  efi_guid_t *vendor,
+					  u32 *attr,
+					  unsigned long *data_size, void *data)
+{
+	void *opaque;
+	efi_status_t status;
+
+	opaque = efi_call_virt_prelog();
+	status = efi_call_virt5(get_variable,
+				name, vendor, attr, data_size, data);
+	efi_call_virt_epilog(opaque);
+	return status;
+}
+
+static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
+					       efi_char16_t *name,
+					       efi_guid_t *vendor)
+{
+	void *opaque;
+	efi_status_t status;
+
+	opaque = efi_call_virt_prelog();
+	status = efi_call_virt3(get_next_variable, name_size, name, vendor);
+	efi_call_virt_epilog(opaque);
+	return status;
+}
+
+static efi_status_t virt_efi_set_variable(efi_char16_t *name,
+					  efi_guid_t *vendor,
+					  u32 attr,
+					  unsigned long data_size, void *data)
+{
+	void *opaque;
+	efi_status_t status;
+
+	opaque = efi_call_virt_prelog();
+	status = efi_call_virt5(set_variable,
+				name, vendor, attr, data_size, data);
+	efi_call_virt_epilog(opaque);
+	return status;
+}
+
+static efi_status_t virt_efi_query_variable_info(u32 attr,
+						 u64 *storage_space,
+						 u64 *remaining_space,
+						 u64 *max_variable_size)
+{
+	void *opaque;
+	efi_status_t status;
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	opaque = efi_call_virt_prelog();
+	status = efi_call_virt4(query_variable_info, attr, storage_space,
+				remaining_space, max_variable_size);
+	efi_call_virt_epilog(opaque);
+	return status;
+}
+
+static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
+{
+	void *opaque;
+	efi_status_t status;
+
+	opaque = efi_call_virt_prelog();
+	status = efi_call_virt1(get_next_high_mono_count, count);
+	efi_call_virt_epilog(opaque);
+	return status;
+}
+
+static void virt_efi_reset_system(int reset_type,
+				  efi_status_t status,
+				  unsigned long data_size, efi_char16_t *data)
+{
+	void *opaque;
+
+	opaque = efi_call_virt_prelog();
+	efi_call_virt4(reset_system, reset_type, status, data_size, data);
+	efi_call_virt_epilog(opaque);
+}
+
+static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
+					    unsigned long count,
+					    unsigned long sg_list)
+{
+	void *opaque;
+	efi_status_t status;
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	opaque = efi_call_virt_prelog();
+	status = efi_call_virt3(update_capsule, capsules, count, sg_list);
+	efi_call_virt_epilog(opaque);
+	return status;
+}
+
+static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
+						unsigned long count,
+						u64 *max_size, int *reset_type)
+{
+	void *opaque;
+	efi_status_t status;
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	opaque = efi_call_virt_prelog();
+	status = efi_call_virt4(query_capsule_caps, capsules, count, max_size,
+				reset_type);
+	efi_call_virt_epilog(opaque);
+	return status;
+}
+
+static efi_status_t __init phys_efi_set_virtual_address_map(unsigned long memory_map_size,
+							    unsigned long descriptor_size,
+							    u32 descriptor_version,
+							    efi_memory_desc_t *virtual_map)
+{
+	efi_status_t status;
+	void *opaque;
+
+	opaque = efi_call_phys_prelog();
+	status = efi_call_phys4(efi_phys.set_virtual_address_map,
+				memory_map_size, descriptor_size,
+				descriptor_version, virtual_map);
+	efi_call_phys_epilog(opaque);
+	return status;
+}
+
+static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
+					     efi_time_cap_t *tc)
+{
+	efi_status_t status;
+	void *opaque;
+
+	opaque = efi_call_phys_prelog();
+	status = efi_call_phys2(efi_phys.get_time, efi_phys_arg(tm),
+				efi_phys_arg(tc));
+	efi_call_phys_epilog(opaque);
+	return status;
+}
+
+int efi_set_rtc_mmss(unsigned long nowtime)
+{
+	int real_seconds, real_minutes;
+	efi_status_t status;
+	efi_time_t eft;
+	efi_time_cap_t cap;
+
+	status = efi.get_time(&eft, &cap);
+	if (status != EFI_SUCCESS) {
+		printk(KERN_ERR "Oops: efitime: can't read time!\n");
+		return -1;
+	}
+
+	real_seconds = nowtime % 60;
+	real_minutes = nowtime / 60;
+	if (((abs(real_minutes - eft.minute) + 15) / 30) & 1)
+		real_minutes += 30;
+	real_minutes %= 60;
+	eft.minute = real_minutes;
+	eft.second = real_seconds;
+
+	status = efi.set_time(&eft);
+	if (status != EFI_SUCCESS) {
+		printk(KERN_ERR "Oops: efitime: can't write time!\n");
+		return -1;
+	}
+	return 0;
+}
+
+void efi_gettimeofday(struct timespec *ts)
+{
+	efi_time_t tm;
+	efi_time_cap_t cap;
+	efi_status_t status;
+
+	status = efi.get_time(&tm, &cap);
+
+	if (status != EFI_SUCCESS) {
+		memset(ts, 0, sizeof(*ts));
+		return;
+	}
+
+	ts->tv_sec = mktime(tm.year, tm.month, tm.day, tm.hour, tm.minute,
+			    tm.second);
+	ts->tv_nsec = tm.nanosecond;
+}
+
+unsigned long efi_get_time(void)
+{
+	struct timespec ts;
+
+	efi_gettimeofday(&ts);
+
+	return ts.tv_sec;
+}
+
+#if EFI_DEBUG
+static void __init print_efi_memmap(void)
+{
+	efi_memory_desc_t *md;
+	void *p;
+	int i;
+
+	for (p = memmap.map, i = 0;
+	     p < memmap.map_end; p += memmap.desc_size, i++) {
+		md = p;
+		printk(KERN_INFO PFX "mem%02u: type=%u, attr=0x%llx, "
+		       "range=[0x%016llx-0x%016llx) (%lluMB)\n",
+		       i, md->type, md->attribute, md->phys_addr,
+		       md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
+		       (md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+	}
+}
+#endif
+
+void __init efi_setup_systab(efi_system_table_t * systab)
+{
+	efi_config_table_t *config_tables;
+	efi_char16_t *c16;
+	char vendor[100] = "unknown";
+	int i = 0;
+	void *tmp;
+
+	memcpy(&efi_systab, systab, sizeof(efi_system_table_t));
+
+	efi.systab = &efi_systab;
+
+	/*
+	 * Verify the EFI Table
+	 */
+	if (efi.systab == NULL)
+		panic("Whoa! Can't find EFI system table.\n");
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+		panic("EFI system table signature incorrect\n");
+	if ((efi.systab->hdr.revision >> 16) == 0)
+		printk(KERN_WARNING "Warning: EFI system table version "
+		       "%d.%02d, expected 1.00 or greater\n",
+		       efi.systab->hdr.revision >> 16,
+		       efi.systab->hdr.revision & 0xffff);
+
+	/* Show what we know for posterity */
+	tmp = c16 = efi_map(efi.systab->fw_vendor, 2);
+	if (c16) {
+		for (i = 0; i < (int)sizeof(vendor) - 1 && *c16; ++i)
+			vendor[i] = *c16++;
+		vendor[i] = '\0';
+	}
+	efi_unmap(tmp, 2);
+
+	printk(KERN_INFO "EFI v%u.%.02u by %s:",
+	       efi.systab->hdr.revision >> 16,
+	       efi.systab->hdr.revision & 0xffff, vendor);
+
+	config_tables = efi_map(efi.systab->tables,
+				efi.systab->nr_tables *
+				sizeof(efi_config_table_t));
+
+	efi.mps = EFI_INVALID_TABLE_ADDR;
+	efi.acpi = EFI_INVALID_TABLE_ADDR;
+	efi.acpi20 = EFI_INVALID_TABLE_ADDR;
+	efi.smbios = EFI_INVALID_TABLE_ADDR;
+	efi.sal_systab = EFI_INVALID_TABLE_ADDR;
+	efi.boot_info = EFI_INVALID_TABLE_ADDR;
+	efi.hcdp = EFI_INVALID_TABLE_ADDR;
+	efi.uga = EFI_INVALID_TABLE_ADDR;
+	efi.uv_systab = EFI_INVALID_TABLE_ADDR;
+
+	for (i = 0; i < (int)efi.systab->nr_tables; i++) {
+		if (efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID) == 0) {
+			efi.mps = config_tables[i].table;
+			printk(" MPS=0x%lx", config_tables[i].table);
+		} else
+		    if (efi_guidcmp(config_tables[i].guid, ACPI_20_TABLE_GUID)
+			== 0) {
+			efi.acpi20 = config_tables[i].table;
+			printk(" ACPI 2.0=0x%lx", config_tables[i].table);
+		} else if (efi_guidcmp(config_tables[i].guid, ACPI_TABLE_GUID)
+			   == 0) {
+			efi.acpi = config_tables[i].table;
+			printk(" ACPI=0x%lx", config_tables[i].table);
+		} else if (efi_guidcmp(config_tables[i].guid, SMBIOS_TABLE_GUID)
+			   == 0) {
+			efi.smbios = config_tables[i].table;
+			printk(" SMBIOS=0x%lx", config_tables[i].table);
+		} else
+		    if (efi_guidcmp
+			(config_tables[i].guid, SAL_SYSTEM_TABLE_GUID) == 0) {
+			efi.sal_systab = config_tables[i].table;
+			printk(" SALsystab=0x%lx", config_tables[i].table);
+		} else if (efi_guidcmp(config_tables[i].guid,
+				       PROCESSOR_ABSTRACTION_LAYER_OVERWRITE_GUID)
+			   == 0) {
+			handle_palo(config_tables[i].table);
+			printk(" PALO=0x%lx", config_tables[i].table);
+
+		} else if (efi_guidcmp(config_tables[i].guid, HCDP_TABLE_GUID)
+			   == 0) {
+			efi.hcdp = config_tables[i].table;
+			printk(" HCDP=0x%lx", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					UV_SYSTEM_TABLE_GUID)) {
+			efi.uv_systab = config_tables[i].table;
+			printk(" UVsystab=0x%lx ", config_tables[i].table);
+		}
+	}
+	printk("\n");
+
+	efi_unmap(config_tables,
+		  efi.systab->nr_tables * sizeof(efi_config_table_t));
+
+	/*
+	 * Check out the runtime services table. We need to map the
+	 * runtime services table so that we can grab the physical
+	 * address of several of the EFI runtime functions, needed to
+	 * set the firmware into virtual mode.
+	 */
+
+	runtime = efi_map((unsigned long)efi.systab->runtime,
+			  sizeof(efi_runtime_services_t));
+
+	if (runtime) {
+		/*
+		 * We will only need *early* access to the following
+		 * two EFI runtime services before set_virtual_address_map
+		 * is invoked.
+		 */
+		efi_phys.get_time = (efi_get_time_t *) runtime->get_time;
+		efi_phys.set_virtual_address_map =
+		    (efi_set_virtual_address_map_t *)
+		    runtime->set_virtual_address_map;
+
+		efi.get_time = phys_efi_get_time;
+
+		/*
+		 * Make efi_get_time can be called before entering
+		 * virtual mode.
+		 */
+
+		efi.runtime_version = runtime->hdr.revision;
+	}
+
+	efi_unmap(runtime, sizeof(efi_runtime_services_t));
+
+	memmap.map = efi_map((unsigned long)memmap.phys_map,
+			     memmap.nr_map * memmap.desc_size);
+	if (memmap.map == NULL)
+		printk(KERN_ERR "Could not map the EFI memory map!\n");
+
+	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
+
+	efi_arch_setup();
+
+#if EFI_DEBUG
+	print_efi_memmap();
+#endif
+}
+
+/*
+ * This function will switch the EFI runtime services to virtual mode.
+ * Essentially, look through the EFI memmap and map every region that
+ * has the runtime attribute bit set in its memory descriptor and
+ * update that memory descriptor with its virtual address. This
+ * enables the runtime services to be called without having to thunk
+ * back into physical mode for every invocation.
+ */
+
+void __init efi_enter_virtual_mode(bool reduce_memmap)
+{
+	efi_memory_desc_t *md, *prev_md = NULL;
+	efi_status_t status;
+	unsigned long size, map;
+	u64 end, systab;
+	void *p, *new_memmap = NULL;
+	int count = 0;
+
+	efi.systab = NULL;
+
+	/* Merge contiguous regions of the same type and attribute */
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		u64 prev_size;
+		md = p;
+
+		if (!prev_md) {
+			prev_md = md;
+			continue;
+		}
+
+		if (prev_md->type != md->type ||
+		    prev_md->attribute != md->attribute) {
+			prev_md = md;
+			continue;
+		}
+
+		prev_size = prev_md->num_pages << EFI_PAGE_SHIFT;
+
+		if (md->phys_addr == (prev_md->phys_addr + prev_size)) {
+			prev_md->num_pages += md->num_pages;
+			md->type = EFI_RESERVED_TYPE;
+			md->attribute = 0;
+			continue;
+		}
+		prev_md = md;
+	}
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+		    md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+
+		size = md->num_pages << EFI_PAGE_SHIFT;
+		end = md->phys_addr + size;
+		md->virt_addr = efi_ioremap(md);
+
+		if (!md->virt_addr)
+			continue;
+
+		systab = (u64) (unsigned long)efi_phys.systab;
+
+		if (md->phys_addr <= systab && systab < end) {
+			systab += md->virt_addr - md->phys_addr;
+			efi.systab =
+			    (efi_system_table_t *) (unsigned long)systab;
+		}
+		if (reduce_memmap) {
+			new_memmap = krealloc(new_memmap,
+					      (count + 1) * memmap.desc_size,
+					      GFP_KERNEL);
+			memcpy(new_memmap + (count * memmap.desc_size), md,
+			       memmap.desc_size);
+			count++;
+		}
+	}
+
+	BUG_ON(!efi.systab);
+
+	if (reduce_memmap) {
+		size = memmap.desc_size * count;
+		map = __pa(new_memmap);
+	} else {
+		size = memmap.desc_size * memmap.nr_map;
+		map = __pa(memmap.map);
+	}
+
+	status = phys_efi_set_virtual_address_map(size, memmap.desc_size,
+						  memmap.desc_version,
+						  (efi_memory_desc_t *) map);
+
+	if (status != EFI_SUCCESS) {
+		printk(KERN_ALERT "Unable to switch EFI into virtual mode "
+		       "(status=%lx)!\n", status);
+		panic("EFI call to SetVirtualAddressMap() failed!");
+	}
+
+	/*
+	 * Now that EFI is in virtual mode, update the function
+	 * pointers in the runtime service table to the new virtual addresses.
+	 *
+	 * Call EFI services through wrapper functions.
+	 */
+	efi.get_time = virt_efi_get_time;
+	efi.set_time = virt_efi_set_time;
+	efi.get_wakeup_time = virt_efi_get_wakeup_time;
+	efi.set_wakeup_time = virt_efi_set_wakeup_time;
+	efi.get_variable = virt_efi_get_variable;
+	efi.get_next_variable = virt_efi_get_next_variable;
+	efi.set_variable = virt_efi_set_variable;
+	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
+	efi.reset_system = virt_efi_reset_system;
+	efi.set_virtual_address_map = NULL;
+	efi.query_variable_info = virt_efi_query_variable_info;
+	efi.update_capsule = virt_efi_update_capsule;
+	efi.query_capsule_caps = virt_efi_query_capsule_caps;
+
+	efi_arch_runtime_setup();
+
+	kfree(new_memmap);
+}
+
+/*
+ * Walk the EFI memory map looking for the I/O port range. There can only be
+ * one entry of this type, other I/O port ranges should be described via
+ * platform firmware.
+ */
+u64 efi_get_iobase(void)
+{
+	void *p;
+	efi_memory_desc_t *md;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if (md->type == EFI_MEMORY_MAPPED_IO_PORT_SPACE) {
+			if (md->attribute & EFI_MEMORY_UC)
+				return md->phys_addr;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Convenience functions to obtain memory types and attributes
+ */
+static efi_memory_desc_t *efi_memory_descriptor(unsigned long phys_addr)
+{
+	void *p;
+	efi_memory_desc_t *md;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if ((md->phys_addr <= phys_addr) &&
+		    (phys_addr < (md->phys_addr +
+				  (md->num_pages << EFI_PAGE_SHIFT))))
+			return md;
+	}
+
+	return NULL;
+}
+
+u32 efi_mem_type(unsigned long phys_addr)
+{
+	efi_memory_desc_t *md;
+
+	md = efi_memory_descriptor(phys_addr);
+
+	if (md)
+		return md->type;
+
+	return 0;
+}
+
+u64 efi_mem_attributes(unsigned long phys_addr)
+{
+	efi_memory_desc_t *md = efi_memory_descriptor(phys_addr);
+
+	if (md)
+		return md->attribute;
+
+	return 0;
+}
+EXPORT_SYMBOL(efi_mem_attributes);
+
+u64 efi_mem_attribute(unsigned long phys_addr, unsigned long size)
+{
+	unsigned long end = phys_addr + size;
+	efi_memory_desc_t *md = efi_memory_descriptor(phys_addr);
+	u64 attr;
+
+	if (!md)
+		return 0;
+
+	/*
+	 * EFI_MEMORY_RUNTIME is not a memory attribute; it just tells
+	 * the kernel that firmware needs this region mapped.
+	 */
+	attr = md->attribute & ~EFI_MEMORY_RUNTIME;
+	do {
+		unsigned long md_end = efi_md_end(md);
+
+		if (end <= md_end)
+			return attr;
+
+		md = efi_memory_descriptor(md_end);
+		if (!md || (md->attribute & ~EFI_MEMORY_RUNTIME) != attr)
+			return 0;
+	} while (md);
+	return 0;		/* never reached */
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ec25726..3005275 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -108,6 +108,14 @@ typedef struct {
 	u32 imagesize;
 } efi_capsule_header_t;
 
+#define efi_md_size(md) (md->num_pages << EFI_PAGE_SHIFT)
+
+static inline u64
+efi_md_end(efi_memory_desc_t *md)
+{
+	return (md->phys_addr + efi_md_size(md));
+}
+
 typedef int (*efi_freemem_callback_t) (u64 start, u64 end, void *arg);
 
 /*
@@ -232,6 +240,9 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 #define UV_SYSTEM_TABLE_GUID \
     EFI_GUID(  0x3b13a7d4, 0x633e, 0x11dd, 0x93, 0xec, 0xda, 0x25, 0x56, 0xd8, 0x95, 0x93 )
 
+#define PROCESSOR_ABSTRACTION_LAYER_OVERWRITE_GUID \
+    EFI_GUID(  0x6cb0a200, 0x893a, 0x11da, 0x96, 0xd2, 0x00, 0x10, 0x83, 0xff, 0xca, 0x4d )
+
 typedef struct {
 	efi_guid_t guid;
 	unsigned long table;
@@ -246,6 +257,13 @@ typedef struct {
 #define EFI_1_10_SYSTEM_TABLE_REVISION  ((1 << 16) | (10))
 #define EFI_1_02_SYSTEM_TABLE_REVISION  ((1 << 16) | (02))
 
+#define EFI_2_30_SYSTEM_TABLE_REVISION  ((2 << 16) | (30))
+#define EFI_2_20_SYSTEM_TABLE_REVISION  ((2 << 16) | (20))
+#define EFI_2_10_SYSTEM_TABLE_REVISION  ((2 << 16) | (10))
+#define EFI_2_00_SYSTEM_TABLE_REVISION  ((2 << 16) | (00))
+#define EFI_1_10_SYSTEM_TABLE_REVISION  ((1 << 16) | (10))
+#define EFI_1_02_SYSTEM_TABLE_REVISION  ((1 << 16) | (02))
+
 typedef struct {
 	efi_table_hdr_t hdr;
 	unsigned long fw_vendor;	/* physical addr of CHAR16 vendor string */
@@ -316,12 +334,36 @@ efi_guid_unparse(efi_guid_t *guid, char *out)
         return out;
 }
 
+#ifndef CONFIG_EFI_THUNK_CALLS
+#define efi_call_phys0(f)               efi_call_phys(f)
+#define efi_call_phys1(f, a1)           efi_call_phys(f, a1)
+#define efi_call_phys2(f, a1, a2)       efi_call_phys(f, a1, a2)
+#define efi_call_phys3(f, a1, a2, a3)   efi_call_phys(f, a1, a2, a3)
+#define efi_call_phys4(f, a1, a2, a3, a4)       \
+	efi_call_phys(f, a1, a2, a3, a4)
+#define efi_call_phys5(f, a1, a2, a3, a4, a5)   \
+	efi_call_phys(f, a1, a2, a3, a4, a5)
+#define efi_call_phys6(f, a1, a2, a3, a4, a5, a6)       \
+	efi_call_phys(f, a1, a2, a3, a4, a5, a6)
+
+#define efi_call_virt0(f)               efi_call_virt(f)
+#define efi_call_virt1(f, a1)           efi_call_virt(f, a1)
+#define efi_call_virt2(f, a1, a2)       efi_call_virt(f, a1, a2)
+#define efi_call_virt3(f, a1, a2, a3)   efi_call_virt(f, a1, a2, a3)
+#define efi_call_virt4(f, a1, a2, a3, a4)       \
+	efi_call_virt(f, a1, a2, a3, a4)
+#define efi_call_virt5(f, a1, a2, a3, a4, a5)   \
+	efi_call_virt(f, a1, a2, a3, a4, a5)
+#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)       \
+	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
+#endif
+
 extern void efi_init (void);
 extern void *efi_get_pal_addr (void);
 extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
-extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
+extern void efi_enter_virtual_mode (bool reduce_memmap);	/* switch EFI to virtual mode, if possible */
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
@@ -332,7 +374,14 @@ extern void efi_initialize_iomem_resources(struct resource *code_resource,
 extern unsigned long efi_get_time(void);
 extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern void efi_reserve_boot_services(void);
+extern void __iomem *efi_map(resource_size_t phys_addr, unsigned long size);
+extern void efi_unmap(void __iomem *phys_addr, unsigned long size);
+extern unsigned long efi_ioremap(efi_memory_desc_t *memdesc);
+extern void efi_setup_systab(efi_system_table_t *systab);
+extern void efi_arch_setup(void);
+extern void efi_arch_runtime_setup(void);
 extern struct efi_memory_map memmap;
+extern struct efi efi_phys;
 
 /**
  * efi_range_is_wc - check the WC bit on an address range
@@ -355,6 +404,12 @@ static inline int efi_range_is_wc(unsigned long start, unsigned long len)
 	return 1;
 }
 
+#ifdef CONFIG_IA64
+void handle_palo(unsigned long palo_phys);
+#else
+static inline void handle_palo(unsigned long palo_phys) { };
+#endif
+
 #ifdef CONFIG_EFI_PCDP
 extern int __init efi_setup_pcdp_console(char *);
 #endif
diff --git a/init/main.c b/init/main.c
index d7211fa..4f4ac85 100644
--- a/init/main.c
+++ b/init/main.c
@@ -596,7 +596,7 @@ asmlinkage void __init start_kernel(void)
 	anon_vma_init();
 #ifdef CONFIG_X86
 	if (efi_enabled)
-		efi_enter_virtual_mode();
+		efi_enter_virtual_mode(true);
 #endif
 	thread_info_cache_init();
 	cred_init();
-- 
1.7.6

