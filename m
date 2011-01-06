Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1AFKLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:11:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36841 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab1AFKLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:11:45 -0500
Date: Thu, 6 Jan 2011 11:11:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/security for v2.6.38
Message-ID: <20110106101113.GA22312@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-security-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-security-for-linus


out-of-topic modifications in x86-security-for-linus:
-----------------------------------------------------
include/linux/module.h             # 84e1c6b: x86: Add RO/NX protection for loa
kernel/module.c                    # 94462ad: module: Move RO/NX module protect
                                   # 84e1c6b: x86: Add RO/NX protection for loa

 Thanks,

	Ingo

------------------>
Lin Ming (1):
      x86: Resume trampoline must be executable

Matthieu CASTET (3):
      x86: Fix improper large page preservation
      x86: Add NX protection for kernel data
      x86: Add RO/NX protection for loadable kernel modules

Steven Rostedt (1):
      module: Move RO/NX module protection to after ftrace module update


 arch/x86/Kconfig.debug        |   11 +++
 arch/x86/include/asm/pci.h    |    1 +
 arch/x86/kernel/ftrace.c      |    3 +
 arch/x86/kernel/vmlinux.lds.S |    8 ++-
 arch/x86/mm/init.c            |    3 +-
 arch/x86/mm/init_32.c         |   20 +++++-
 arch/x86/mm/pageattr.c        |   33 +++++---
 arch/x86/pci/pcbios.c         |   23 ++++++
 include/linux/module.h        |   11 +++-
 kernel/module.c               |  171 ++++++++++++++++++++++++++++++++++++++++-
 10 files changed, 266 insertions(+), 18 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index b59ee76..45143bb 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -117,6 +117,17 @@ config DEBUG_RODATA_TEST
 	  feature as well as for the change_page_attr() infrastructure.
 	  If in doubt, say "N"
 
+config DEBUG_SET_MODULE_RONX
+	bool "Set loadable kernel module data as NX and text as RO"
+	depends on MODULES
+	---help---
+	  This option helps catch unintended modifications to loadable
+	  kernel module's text and read-only data. It also prevents execution
+	  of module data. Such protection may interfere with run-time code
+	  patching and dynamic kernel tracing - and they might also protect
+	  against certain classes of kernel exploits.
+	  If in doubt, say "N".
+
 config DEBUG_NX_TEST
 	tristate "Testcase for the NX non-executable stack feature"
 	depends on DEBUG_KERNEL && m
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index ca0437c..6761292 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -65,6 +65,7 @@ extern unsigned long pci_mem_start;
 
 #define PCIBIOS_MIN_CARDBUS_IO	0x4000
 
+extern int pcibios_enabled;
 void pcibios_config_init(void);
 struct pci_bus *pcibios_scan_root(int bus);
 
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 3afb33f..2984486 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/module.h>
 
 #include <trace/syscall.h>
 
@@ -49,6 +50,7 @@ static DEFINE_PER_CPU(int, save_modifying_code);
 int ftrace_arch_code_modify_prepare(void)
 {
 	set_kernel_text_rw();
+	set_all_modules_text_rw();
 	modifying_code = 1;
 	return 0;
 }
@@ -56,6 +58,7 @@ int ftrace_arch_code_modify_prepare(void)
 int ftrace_arch_code_modify_post_process(void)
 {
 	modifying_code = 0;
+	set_all_modules_text_ro();
 	set_kernel_text_ro();
 	return 0;
 }
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index e03530a..bf47007 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -69,7 +69,7 @@ jiffies_64 = jiffies;
 
 PHDRS {
 	text PT_LOAD FLAGS(5);          /* R_E */
-	data PT_LOAD FLAGS(7);          /* RWE */
+	data PT_LOAD FLAGS(6);          /* RW_ */
 #ifdef CONFIG_X86_64
 	user PT_LOAD FLAGS(5);          /* R_E */
 #ifdef CONFIG_SMP
@@ -116,6 +116,10 @@ SECTIONS
 
 	EXCEPTION_TABLE(16) :text = 0x9090
 
+#if defined(CONFIG_DEBUG_RODATA)
+	/* .text should occupy whole number of pages */
+	. = ALIGN(PAGE_SIZE);
+#endif
 	X64_ALIGN_DEBUG_RODATA_BEGIN
 	RO_DATA(PAGE_SIZE)
 	X64_ALIGN_DEBUG_RODATA_END
@@ -335,7 +339,7 @@ SECTIONS
 		__bss_start = .;
 		*(.bss..page_aligned)
 		*(.bss)
-		. = ALIGN(4);
+		. = ALIGN(PAGE_SIZE);
 		__bss_stop = .;
 	}
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index c0e28a1..947f42a 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -364,8 +364,9 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 	/*
 	 * We just marked the kernel text read only above, now that
 	 * we are going to free part of that, we need to make that
-	 * writeable first.
+	 * writeable and non-executable first.
 	 */
+	set_memory_nx(begin, (end - begin) >> PAGE_SHIFT);
 	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
 
 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 0e969f9..f89b5bb 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -226,7 +226,7 @@ page_table_range_init(unsigned long start, unsigned long end, pgd_t *pgd_base)
 
 static inline int is_kernel_text(unsigned long addr)
 {
-	if (addr >= PAGE_OFFSET && addr <= (unsigned long)__init_end)
+	if (addr >= (unsigned long)_text && addr <= (unsigned long)__init_end)
 		return 1;
 	return 0;
 }
@@ -912,6 +912,23 @@ void set_kernel_text_ro(void)
 	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 }
 
+static void mark_nxdata_nx(void)
+{
+	/*
+	 * When this called, init has already been executed and released,
+	 * so everything past _etext sould be NX.
+	 */
+	unsigned long start = PFN_ALIGN(_etext);
+	/*
+	 * This comes from is_kernel_text upper limit. Also HPAGE where used:
+	 */
+	unsigned long size = (((unsigned long)__init_end + HPAGE_SIZE) & HPAGE_MASK) - start;
+
+	if (__supported_pte_mask & _PAGE_NX)
+		printk(KERN_INFO "NX-protecting the kernel data: %luk\n", size >> 10);
+	set_pages_nx(virt_to_page(start), size >> PAGE_SHIFT);
+}
+
 void mark_rodata_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
@@ -946,6 +963,7 @@ void mark_rodata_ro(void)
 	printk(KERN_INFO "Testing CPA: write protecting again\n");
 	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 #endif
+	mark_nxdata_nx();
 }
 #endif
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 532e793..8b830ca 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -13,6 +13,7 @@
 #include <linux/pfn.h>
 #include <linux/percpu.h>
 #include <linux/gfp.h>
+#include <linux/pci.h>
 
 #include <asm/e820.h>
 #include <asm/processor.h>
@@ -255,13 +256,16 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 				   unsigned long pfn)
 {
 	pgprot_t forbidden = __pgprot(0);
+	pgprot_t required = __pgprot(0);
 
 	/*
 	 * The BIOS area between 640k and 1Mb needs to be executable for
 	 * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
 	 */
-	if (within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
+#ifdef CONFIG_PCI_BIOS
+	if (pcibios_enabled && within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_NX;
+#endif
 
 	/*
 	 * The kernel text needs to be executable for obvious reasons
@@ -278,6 +282,12 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	if (within(pfn, __pa((unsigned long)__start_rodata) >> PAGE_SHIFT,
 		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_RW;
+	/*
+	 * .data and .bss should always be writable.
+	 */
+	if (within(address, (unsigned long)_sdata, (unsigned long)_edata) ||
+	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop))
+		pgprot_val(required) |= _PAGE_RW;
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
 	/*
@@ -317,6 +327,7 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 #endif
 
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
+	prot = __pgprot(pgprot_val(prot) | pgprot_val(required));
 
 	return prot;
 }
@@ -393,7 +404,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 {
 	unsigned long nextpage_addr, numpages, pmask, psize, flags, addr, pfn;
 	pte_t new_pte, old_pte, *tmp;
-	pgprot_t old_prot, new_prot;
+	pgprot_t old_prot, new_prot, req_prot;
 	int i, do_split = 1;
 	unsigned int level;
 
@@ -438,10 +449,10 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 * We are safe now. Check whether the new pgprot is the same:
 	 */
 	old_pte = *kpte;
-	old_prot = new_prot = pte_pgprot(old_pte);
+	old_prot = new_prot = req_prot = pte_pgprot(old_pte);
 
-	pgprot_val(new_prot) &= ~pgprot_val(cpa->mask_clr);
-	pgprot_val(new_prot) |= pgprot_val(cpa->mask_set);
+	pgprot_val(req_prot) &= ~pgprot_val(cpa->mask_clr);
+	pgprot_val(req_prot) |= pgprot_val(cpa->mask_set);
 
 	/*
 	 * old_pte points to the large page base address. So we need
@@ -450,17 +461,17 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	pfn = pte_pfn(old_pte) + ((address & (psize - 1)) >> PAGE_SHIFT);
 	cpa->pfn = pfn;
 
-	new_prot = static_protections(new_prot, address, pfn);
+	new_prot = static_protections(req_prot, address, pfn);
 
 	/*
 	 * We need to check the full range, whether
 	 * static_protection() requires a different pgprot for one of
 	 * the pages in the range we try to preserve:
 	 */
-	addr = address + PAGE_SIZE;
-	pfn++;
-	for (i = 1; i < cpa->numpages; i++, addr += PAGE_SIZE, pfn++) {
-		pgprot_t chk_prot = static_protections(new_prot, addr, pfn);
+	addr = address & pmask;
+	pfn = pte_pfn(old_pte);
+	for (i = 0; i < (psize >> PAGE_SHIFT); i++, addr += PAGE_SIZE, pfn++) {
+		pgprot_t chk_prot = static_protections(req_prot, addr, pfn);
 
 		if (pgprot_val(chk_prot) != pgprot_val(new_prot))
 			goto out_unlock;
@@ -483,7 +494,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 * that we limited the number of possible pages already to
 	 * the number of pages in the large page.
 	 */
-	if (address == (nextpage_addr - psize) && cpa->numpages == numpages) {
+	if (address == (address & pmask) && cpa->numpages == (psize >> PAGE_SHIFT)) {
 		/*
 		 * The address is aligned and the number of pages
 		 * covers the full page.
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index 2492d16..a5f7d0d 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -9,6 +9,7 @@
 #include <linux/uaccess.h>
 #include <asm/pci_x86.h>
 #include <asm/pci-functions.h>
+#include <asm/cacheflush.h>
 
 /* BIOS32 signature: "_32_" */
 #define BIOS32_SIGNATURE	(('_' << 0) + ('3' << 8) + ('2' << 16) + ('_' << 24))
@@ -25,6 +26,27 @@
 #define PCIBIOS_HW_TYPE1_SPEC		0x10
 #define PCIBIOS_HW_TYPE2_SPEC		0x20
 
+int pcibios_enabled;
+
+/* According to the BIOS specification at:
+ * http://members.datafast.net.au/dft0802/specs/bios21.pdf, we could
+ * restrict the x zone to some pages and make it ro. But this may be
+ * broken on some bios, complex to handle with static_protections.
+ * We could make the 0xe0000-0x100000 range rox, but this can break
+ * some ISA mapping.
+ *
+ * So we let's an rw and x hole when pcibios is used. This shouldn't
+ * happen for modern system with mmconfig, and if you don't want it
+ * you could disable pcibios...
+ */
+static inline void set_bios_x(void)
+{
+	pcibios_enabled = 1;
+	set_memory_x(PAGE_OFFSET + BIOS_BEGIN, (BIOS_END - BIOS_BEGIN) >> PAGE_SHIFT);
+	if (__supported_pte_mask & _PAGE_NX)
+		printk(KERN_INFO "PCI : PCI BIOS aera is rw and x. Use pci=nobios if you want it NX.\n");
+}
+
 /*
  * This is the standard structure used to identify the entry point
  * to the BIOS32 Service Directory, as documented in
@@ -332,6 +354,7 @@ static struct pci_raw_ops * __devinit pci_find_bios(void)
 			DBG("PCI: BIOS32 Service Directory entry at 0x%lx\n",
 					bios32_entry);
 			bios32_indirect.address = bios32_entry + PAGE_OFFSET;
+			set_bios_x();
 			if (check_pcibios())
 				return &pci_bios_access;
 		}
diff --git a/include/linux/module.h b/include/linux/module.h
index 7575bbb..8b17fd8 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -308,6 +308,9 @@ struct module
 	/* The size of the executable code in each section.  */
 	unsigned int init_text_size, core_text_size;
 
+	/* Size of RO sections of the module (text+rodata) */
+	unsigned int init_ro_size, core_ro_size;
+
 	/* Arch-specific module values */
 	struct mod_arch_specific arch;
 
@@ -672,7 +675,6 @@ static inline int module_get_iter_tracepoints(struct tracepoint_iter *iter)
 {
 	return 0;
 }
-
 #endif /* CONFIG_MODULES */
 
 #ifdef CONFIG_SYSFS
@@ -687,6 +689,13 @@ extern int module_sysfs_initialized;
 
 #define __MODULE_STRING(x) __stringify(x)
 
+#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+extern void set_all_modules_text_rw(void);
+extern void set_all_modules_text_ro(void);
+#else
+static inline void set_all_modules_text_rw(void) { }
+static inline void set_all_modules_text_ro(void) { }
+#endif
 
 #ifdef CONFIG_GENERIC_BUG
 void module_bug_finalize(const Elf_Ehdr *, const Elf_Shdr *,
diff --git a/kernel/module.c b/kernel/module.c
index d190664..34e00b7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -56,6 +56,7 @@
 #include <linux/percpu.h>
 #include <linux/kmemleak.h>
 #include <linux/jump_label.h>
+#include <linux/pfn.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -70,6 +71,26 @@
 #define ARCH_SHF_SMALL 0
 #endif
 
+/*
+ * Modules' sections will be aligned on page boundaries
+ * to ensure complete separation of code and data, but
+ * only when CONFIG_DEBUG_SET_MODULE_RONX=y
+ */
+#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+# define debug_align(X) ALIGN(X, PAGE_SIZE)
+#else
+# define debug_align(X) (X)
+#endif
+
+/*
+ * Given BASE and SIZE this macro calculates the number of pages the
+ * memory regions occupies
+ */
+#define MOD_NUMBER_OF_PAGES(BASE, SIZE) (((SIZE) > 0) ?		\
+		(PFN_DOWN((unsigned long)(BASE) + (SIZE) - 1) -	\
+			 PFN_DOWN((unsigned long)BASE) + 1)	\
+		: (0UL))
+
 /* If this is set, the section belongs in the init part of the module */
 #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))
 
@@ -1542,6 +1563,115 @@ static int __unlink_module(void *_mod)
 	return 0;
 }
 
+#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+/*
+ * LKM RO/NX protection: protect module's text/ro-data
+ * from modification and any data from execution.
+ */
+void set_page_attributes(void *start, void *end, int (*set)(unsigned long start, int num_pages))
+{
+	unsigned long begin_pfn = PFN_DOWN((unsigned long)start);
+	unsigned long end_pfn = PFN_DOWN((unsigned long)end);
+
+	if (end_pfn > begin_pfn)
+		set(begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);
+}
+
+static void set_section_ro_nx(void *base,
+			unsigned long text_size,
+			unsigned long ro_size,
+			unsigned long total_size)
+{
+	/* begin and end PFNs of the current subsection */
+	unsigned long begin_pfn;
+	unsigned long end_pfn;
+
+	/*
+	 * Set RO for module text and RO-data:
+	 * - Always protect first page.
+	 * - Do not protect last partial page.
+	 */
+	if (ro_size > 0)
+		set_page_attributes(base, base + ro_size, set_memory_ro);
+
+	/*
+	 * Set NX permissions for module data:
+	 * - Do not protect first partial page.
+	 * - Always protect last page.
+	 */
+	if (total_size > text_size) {
+		begin_pfn = PFN_UP((unsigned long)base + text_size);
+		end_pfn = PFN_UP((unsigned long)base + total_size);
+		if (end_pfn > begin_pfn)
+			set_memory_nx(begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);
+	}
+}
+
+/* Setting memory back to RW+NX before releasing it */
+void unset_section_ro_nx(struct module *mod, void *module_region)
+{
+	unsigned long total_pages;
+
+	if (mod->module_core == module_region) {
+		/* Set core as NX+RW */
+		total_pages = MOD_NUMBER_OF_PAGES(mod->module_core, mod->core_size);
+		set_memory_nx((unsigned long)mod->module_core, total_pages);
+		set_memory_rw((unsigned long)mod->module_core, total_pages);
+
+	} else if (mod->module_init == module_region) {
+		/* Set init as NX+RW */
+		total_pages = MOD_NUMBER_OF_PAGES(mod->module_init, mod->init_size);
+		set_memory_nx((unsigned long)mod->module_init, total_pages);
+		set_memory_rw((unsigned long)mod->module_init, total_pages);
+	}
+}
+
+/* Iterate through all modules and set each module's text as RW */
+void set_all_modules_text_rw()
+{
+	struct module *mod;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry_rcu(mod, &modules, list) {
+		if ((mod->module_core) && (mod->core_text_size)) {
+			set_page_attributes(mod->module_core,
+						mod->module_core + mod->core_text_size,
+						set_memory_rw);
+		}
+		if ((mod->module_init) && (mod->init_text_size)) {
+			set_page_attributes(mod->module_init,
+						mod->module_init + mod->init_text_size,
+						set_memory_rw);
+		}
+	}
+	mutex_unlock(&module_mutex);
+}
+
+/* Iterate through all modules and set each module's text as RO */
+void set_all_modules_text_ro()
+{
+	struct module *mod;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry_rcu(mod, &modules, list) {
+		if ((mod->module_core) && (mod->core_text_size)) {
+			set_page_attributes(mod->module_core,
+						mod->module_core + mod->core_text_size,
+						set_memory_ro);
+		}
+		if ((mod->module_init) && (mod->init_text_size)) {
+			set_page_attributes(mod->module_init,
+						mod->module_init + mod->init_text_size,
+						set_memory_ro);
+		}
+	}
+	mutex_unlock(&module_mutex);
+}
+#else
+static inline void set_section_ro_nx(void *base, unsigned long text_size, unsigned long ro_size, unsigned long total_size) { }
+static inline void unset_section_ro_nx(struct module *mod, void *module_region) { }
+#endif
+
 /* Free a module, remove from lists, etc. */
 static void free_module(struct module *mod)
 {
@@ -1566,6 +1696,7 @@ static void free_module(struct module *mod)
 	destroy_params(mod->kp, mod->num_kp);
 
 	/* This may be NULL, but that's OK */
+	unset_section_ro_nx(mod, mod->module_init);
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
 	percpu_modfree(mod);
@@ -1574,6 +1705,7 @@ static void free_module(struct module *mod)
 	lockdep_free_key_range(mod->module_core, mod->core_size);
 
 	/* Finally, free the core (containing the module structure) */
+	unset_section_ro_nx(mod, mod->module_core);
 	module_free(mod, mod->module_core);
 
 #ifdef CONFIG_MPU
@@ -1777,8 +1909,19 @@ static void layout_sections(struct module *mod, struct load_info *info)
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
 			DEBUGP("\t%s\n", name);
 		}
-		if (m == 0)
+		switch (m) {
+		case 0: /* executable */
+			mod->core_size = debug_align(mod->core_size);
 			mod->core_text_size = mod->core_size;
+			break;
+		case 1: /* RO: text and ro-data */
+			mod->core_size = debug_align(mod->core_size);
+			mod->core_ro_size = mod->core_size;
+			break;
+		case 3: /* whole core */
+			mod->core_size = debug_align(mod->core_size);
+			break;
+		}
 	}
 
 	DEBUGP("Init section allocation order:\n");
@@ -1796,8 +1939,19 @@ static void layout_sections(struct module *mod, struct load_info *info)
 					 | INIT_OFFSET_MASK);
 			DEBUGP("\t%s\n", sname);
 		}
-		if (m == 0)
+		switch (m) {
+		case 0: /* executable */
+			mod->init_size = debug_align(mod->init_size);
 			mod->init_text_size = mod->init_size;
+			break;
+		case 1: /* RO: text and ro-data */
+			mod->init_size = debug_align(mod->init_size);
+			mod->init_ro_size = mod->init_size;
+			break;
+		case 3: /* whole init */
+			mod->init_size = debug_align(mod->init_size);
+			break;
+		}
 	}
 }
 
@@ -2722,6 +2876,18 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
 
+	/* Set RO and NX regions for core */
+	set_section_ro_nx(mod->module_core,
+				mod->core_text_size,
+				mod->core_ro_size,
+				mod->core_size);
+
+	/* Set RO and NX regions for init */
+	set_section_ro_nx(mod->module_init,
+				mod->init_text_size,
+				mod->init_ro_size,
+				mod->init_size);
+
 	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)
@@ -2765,6 +2931,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	mod->symtab = mod->core_symtab;
 	mod->strtab = mod->core_strtab;
 #endif
+	unset_section_ro_nx(mod, mod->module_init);
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
