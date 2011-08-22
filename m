Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1HVQXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:23:41 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:54077 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1HVQXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:23:38 -0400
Date: Mon, 22 Aug 2011 18:23:16 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, ian.campbell@citrix.com, vgoyal@redhat.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] xen: Kexec patch for pvops kernel
Message-ID: <20110822162316.GA29771@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am posting first kexec patch for pvops kernel. It applies to
git://oss.oracle.com/git/kwilk/xen.git tree, stable/2.6.39.x branch.
Tested on x86_64. Compiles for x86_32. It should be used with
latest kexec-tools development version which could be found at
git://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git.

TODO:
  - it should work on bare metal and Xen hypervisor
    (now this future is broken; kexec/kdump works
    only on Xen hypervisor),
  - move Xen code from generic and arch source files
    to Xen specific files,
  - reuse available generic Linux Kernel code
    as much as possible.

It is WIP and I am looking for comments only.
It is not final version.

Daniel

 arch/x86/include/asm/kexec.h         |   16 ++
 arch/x86/include/asm/xen/hypercall.h |    6 +
 arch/x86/kernel/machine_kexec_32.c   |  118 ++++++++--------
 arch/x86/kernel/machine_kexec_64.c   |  192 +++++++++++++++++---------
 arch/x86/kernel/relocate_kernel_32.S |   39 +++++-
 arch/x86/kernel/relocate_kernel_64.S |   36 +++++-
 arch/x86/kernel/setup.c              |    5 +-
 arch/x86/xen/enlighten.c             |   11 ++-
 drivers/base/cpu.c                   |    4 +-
 drivers/xen/Makefile                 |    1 +
 drivers/xen/machine_kexec.c          |  256 ++++++++++++++++++++++++++++++++++
 drivers/xen/sys-hypervisor.c         |   40 ++++++
 drivers/xen/xenbus/xenbus_probe.c    |   98 +++++++++++++
 include/linux/kexec.h                |   13 ++
 include/xen/interface/kexec.h        |  158 +++++++++++++++++++++
 include/xen/interface/xen.h          |    1 +
 kernel/kexec.c                       |   93 ++++++++++--
 17 files changed, 939 insertions(+), 148 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 317ff17..578697e 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -5,14 +5,30 @@
 # define PA_CONTROL_PAGE	0
 # define VA_CONTROL_PAGE	1
 # define PA_PGD			2
+# ifndef CONFIG_XEN
 # define PA_SWAP_PAGE		3
 # define PAGES_NR		4
+# else /* CONFIG_XEN */
+/*
+ * The hypervisor interface implicitly requires that all entries (except
+ * for possibly the final one) are arranged in matching PA_/VA_ pairs.
+#  define VA_PGD		3
+ */
+#  define PA_SWAP_PAGE		4
+#  define PAGES_NR		5
+# endif /* CONFIG_XEN */
 #else
 # define PA_CONTROL_PAGE	0
 # define VA_CONTROL_PAGE	1
 # define PA_TABLE_PAGE		2
+# ifndef CONFIG_XEN
 # define PA_SWAP_PAGE		3
 # define PAGES_NR		4
+# else /* CONFIG_XEN, see comment above
+#  define VA_TABLE_PAGE		3 */
+#  define PA_SWAP_PAGE		4
+#  define PAGES_NR		5
+# endif /* CONFIG_XEN */
 #endif
 
 # define KEXEC_CONTROL_CODE_MAX_SIZE	2048
diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
index 18882f7..2db0222 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -468,6 +468,12 @@ HYPERVISOR_xenoprof_op(unsigned int op, void *arg)
 	return _hypercall2(int, xenoprof_op, op, arg);
 }
 
+static inline int __must_check
+HYPERVISOR_kexec_op(unsigned long op, void *args)
+{
+	return _hypercall2(int, kexec_op, op, args);
+}
+
 static inline void
 MULTI_fpu_taskswitch(struct multicall_entry *mcl, int set)
 {
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index a3fa43b..14b7fa8 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -27,47 +27,13 @@
 #include <asm/cacheflush.h>
 #include <asm/debugreg.h>
 
-static void set_idt(void *newidt, __u16 limit)
-{
-	struct desc_ptr curidt;
-
-	/* ia32 supports unaliged loads & stores */
-	curidt.size    = limit;
-	curidt.address = (unsigned long)newidt;
-
-	load_idt(&curidt);
-}
-
+#ifdef CONFIG_XEN
+#include <xen/xen-ops.h>
 
-static void set_gdt(void *newgdt, __u16 limit)
-{
-	struct desc_ptr curgdt;
-
-	/* ia32 supports unaligned loads & stores */
-	curgdt.size    = limit;
-	curgdt.address = (unsigned long)newgdt;
+#include <xen/interface/kexec.h>
 
-	load_gdt(&curgdt);
-}
-
-static void load_segments(void)
-{
-#define __STR(X) #X
-#define STR(X) __STR(X)
-
-	__asm__ __volatile__ (
-		"\tljmp $"STR(__KERNEL_CS)",$1f\n"
-		"\t1:\n"
-		"\tmovl $"STR(__KERNEL_DS)",%%eax\n"
-		"\tmovl %%eax,%%ds\n"
-		"\tmovl %%eax,%%es\n"
-		"\tmovl %%eax,%%fs\n"
-		"\tmovl %%eax,%%gs\n"
-		"\tmovl %%eax,%%ss\n"
-		: : : "eax", "memory");
-#undef STR
-#undef __STR
-}
+#include <asm/xen/page.h>
+#endif
 
 static void machine_kexec_free_page_tables(struct kimage *image)
 {
@@ -84,6 +50,15 @@ static int machine_kexec_alloc_page_tables(struct kimage *image)
 {
 	image->arch.pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL);
 #ifdef CONFIG_X86_PAE
+#ifdef CONFIG_XEN /* machine address must fit into xki->page_list[PA_PGD] */
+	if (image->arch.pgd) {
+		if (xen_create_contiguous_region(native_pgd_val(*image->arch.pgd), 0, BITS_PER_LONG) < 0) {
+			__free_page(virt_to_page(image->arch.pgd));
+			image->arch.pgd = NULL;
+			return -ENOMEM;
+		}
+	}
+#endif
 	image->arch.pmd0 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
 	image->arch.pmd1 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
 #endif
@@ -139,6 +114,51 @@ static void machine_kexec_prepare_page_tables(struct kimage *image)
 		__pa(control_page), __pa(control_page));
 }
 
+#ifdef CONFIG_XEN
+
+#define __ma(x) (pfn_to_mfn(__pa((x)) >> PAGE_SHIFT) << PAGE_SHIFT)
+
+#if PAGES_NR > KEXEC_XEN_NO_PAGES
+#error PAGES_NR is greater than KEXEC_XEN_NO_PAGES - Xen support will break
+#endif
+
+#if PA_CONTROL_PAGE != 0
+#error PA_CONTROL_PAGE is non zero - Xen support will break
+#endif
+
+void machine_kexec_setup_load_arg(xen_kexec_image_t *xki, struct kimage *image)
+{
+	void *control_page;
+
+	memset(xki->page_list, 0, sizeof(xki->page_list));
+
+	control_page = page_address(image->control_code_page);
+	memcpy(control_page, relocate_kernel, PAGE_SIZE);
+
+	xki->page_list[PA_CONTROL_PAGE] = __ma(control_page);
+	xki->page_list[PA_PGD] = __ma(image->arch.pgd);
+
+	if (image->type == KEXEC_TYPE_DEFAULT)
+		xki->page_list[PA_SWAP_PAGE] = page_to_phys(image->swap_page);
+}
+
+int __init machine_kexec_setup_resources(struct resource *hypervisor,
+					 struct resource *phys_cpus,
+					 int nr_phys_cpus)
+{
+	int k;
+
+	/* The per-cpu crash note resources belong to the hypervisor resource */
+	for (k = 0; k < nr_phys_cpus; k++)
+		request_resource(hypervisor, phys_cpus + k);
+
+	return 0;
+}
+
+void machine_kexec_register_resources(struct resource *res) { ; }
+
+#endif /* CONFIG_XEN */
+
 /*
  * A architecture hook called to validate the
  * proposed image and prepare the control pages
@@ -176,6 +196,7 @@ void machine_kexec_cleanup(struct kimage *image)
 	machine_kexec_free_page_tables(image);
 }
 
+#ifndef CONFIG_XEN
 /*
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
@@ -228,24 +249,6 @@ void machine_kexec(struct kimage *image)
 		page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page)
 						<< PAGE_SHIFT);
 
-	/*
-	 * The segment registers are funny things, they have both a
-	 * visible and an invisible part.  Whenever the visible part is
-	 * set to a specific selector, the invisible part is loaded
-	 * with from a table in memory.  At no other time is the
-	 * descriptor table in memory accessed.
-	 *
-	 * I take advantage of this here by force loading the
-	 * segments, before I zap the gdt with an invalid value.
-	 */
-	load_segments();
-	/*
-	 * The gdt & idt are now invalid.
-	 * If you want to load them you must set up your own idt & gdt.
-	 */
-	set_gdt(phys_to_virt(0), 0);
-	set_idt(phys_to_virt(0), 0);
-
 	/* now call it */
 	image->start = relocate_kernel_ptr((unsigned long)image->head,
 					   (unsigned long)page_list,
@@ -259,6 +262,7 @@ void machine_kexec(struct kimage *image)
 
 	__ftrace_enabled_restore(save_ftrace_enabled);
 }
+#endif
 
 void arch_crash_save_vmcoreinfo(void)
 {
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index b3ea9db..c7623a4 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -21,6 +21,115 @@
 #include <asm/mmu_context.h>
 #include <asm/debugreg.h>
 
+#ifdef CONFIG_XEN
+
+/* In the case of Xen, override hypervisor functions to be able to create
+ * a regular identity mapping page table...
+ */
+
+#include <xen/interface/kexec.h>
+#include <xen/interface/memory.h>
+
+#include <asm/xen/page.h>
+#include <asm/xen/hypercall.h>
+
+#define x__pmd(x) ((pmd_t) { (x) } )
+#define x__pud(x) ((pud_t) { (x) } )
+#define x__pgd(x) ((pgd_t) { (x) } )
+
+#define x_pmd_val(x)   ((x).pmd)
+#define x_pud_val(x)   ((x).pud)
+#define x_pgd_val(x)   ((x).pgd)
+
+static inline void x_set_pmd(pmd_t *dst, pmd_t val)
+{
+	x_pmd_val(*dst) = x_pmd_val(val);
+}
+
+static inline void x_set_pud(pud_t *dst, pud_t val)
+{
+	x_pud_val(*dst) = phys_to_machine(XPADDR(x_pud_val(val))).maddr;
+}
+
+static inline void x_pud_clear (pud_t *pud)
+{
+	x_pud_val(*pud) = 0;
+}
+
+static inline void x_set_pgd(pgd_t *dst, pgd_t val)
+{
+	x_pgd_val(*dst) = phys_to_machine(XPADDR(x_pgd_val(val))).maddr;
+}
+
+static inline void x_pgd_clear (pgd_t * pgd)
+{
+	x_pgd_val(*pgd) = 0;
+}
+
+#define X__PAGE_KERNEL_LARGE_EXEC \
+         _PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_PSE
+#define X_KERNPG_TABLE _PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY
+
+#define __ma(x) (pfn_to_mfn(__pa((x)) >> PAGE_SHIFT) << PAGE_SHIFT)
+
+#if PAGES_NR > KEXEC_XEN_NO_PAGES
+#error PAGES_NR is greater than KEXEC_XEN_NO_PAGES - Xen support will break
+#endif
+
+#if PA_CONTROL_PAGE != 0
+#error PA_CONTROL_PAGE is non zero - Xen support will break
+#endif
+
+void machine_kexec_setup_load_arg(xen_kexec_image_t *xki, struct kimage *image)
+{
+	void *control_page;
+	void *table_page;
+
+	memset(xki->page_list, 0, sizeof(xki->page_list));
+
+	control_page = page_address(image->control_code_page) + PAGE_SIZE;
+	memcpy(control_page, relocate_kernel, PAGE_SIZE);
+
+	table_page = page_address(image->control_code_page);
+
+	xki->page_list[PA_CONTROL_PAGE] = __ma(control_page);
+	xki->page_list[PA_TABLE_PAGE] = __ma(table_page);
+
+	if (image->type == KEXEC_TYPE_DEFAULT)
+		xki->page_list[PA_SWAP_PAGE] = page_to_phys(image->swap_page);
+}
+
+int __init machine_kexec_setup_resources(struct resource *hypervisor,
+					 struct resource *phys_cpus,
+					 int nr_phys_cpus)
+{
+	int k;
+
+	/* The per-cpu crash note resources belong to the hypervisor resource */
+	for (k = 0; k < nr_phys_cpus; k++)
+		request_resource(hypervisor, phys_cpus + k);
+
+	return 0;
+}
+
+#else /* CONFIG_XEN */
+
+#define x__pmd(x) __pmd(x)
+#define x__pud(x) __pud(x)
+#define x__pgd(x) __pgd(x)
+
+#define x_set_pmd(x, y) set_pmd(x, y)
+#define x_set_pud(x, y) set_pud(x, y)
+#define x_set_pgd(x, y) set_pgd(x, y)
+
+#define x_pud_clear(x) pud_clear(x)
+#define x_pgd_clear(x) pgd_clear(x)
+
+#define X__PAGE_KERNEL_LARGE_EXEC __PAGE_KERNEL_LARGE_EXEC
+#define X_KERNPG_TABLE _KERNPG_TABLE
+
+#endif /* CONFIG_XEN */
+
 static int init_one_level2_page(struct kimage *image, pgd_t *pgd,
 				unsigned long addr)
 {
@@ -50,7 +159,7 @@ static int init_one_level2_page(struct kimage *image, pgd_t *pgd,
 	}
 	pmd = pmd_offset(pud, addr);
 	if (!pmd_present(*pmd))
-		set_pmd(pmd, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
+		x_set_pmd(pmd, x__pmd(addr | X__PAGE_KERNEL_LARGE_EXEC));
 	result = 0;
 out:
 	return result;
@@ -63,7 +172,7 @@ static void init_level2_page(pmd_t *level2p, unsigned long addr)
 	addr &= PAGE_MASK;
 	end_addr = addr + PUD_SIZE;
 	while (addr < end_addr) {
-		set_pmd(level2p++, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
+		x_set_pmd(level2p++, x__pmd(addr | X__PAGE_KERNEL_LARGE_EXEC));
 		addr += PMD_SIZE;
 	}
 }
@@ -88,12 +197,12 @@ static int init_level3_page(struct kimage *image, pud_t *level3p,
 		}
 		level2p = (pmd_t *)page_address(page);
 		init_level2_page(level2p, addr);
-		set_pud(level3p++, __pud(__pa(level2p) | _KERNPG_TABLE));
+		x_set_pud(level3p++, x__pud(__pa(level2p) | X_KERNPG_TABLE));
 		addr += PUD_SIZE;
 	}
 	/* clear the unused entries */
 	while (addr < end_addr) {
-		pud_clear(level3p++);
+		x_pud_clear(level3p++);
 		addr += PUD_SIZE;
 	}
 out:
@@ -123,12 +232,12 @@ static int init_level4_page(struct kimage *image, pgd_t *level4p,
 		result = init_level3_page(image, level3p, addr, last_addr);
 		if (result)
 			goto out;
-		set_pgd(level4p++, __pgd(__pa(level3p) | _KERNPG_TABLE));
+		x_set_pgd(level4p++, x__pgd(__pa(level3p) | X_KERNPG_TABLE));
 		addr += PGDIR_SIZE;
 	}
 	/* clear the unused entries */
 	while (addr < end_addr) {
-		pgd_clear(level4p++);
+		x_pgd_clear(level4p++);
 		addr += PGDIR_SIZE;
 	}
 out:
@@ -189,8 +298,14 @@ static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 {
 	pgd_t *level4p;
 	int result;
+	unsigned long x_max_pfn = max_pfn;
+
+#ifdef CONFIG_XEN
+	x_max_pfn = HYPERVISOR_memory_op(XENMEM_maximum_ram_page, NULL);
+#endif
+
 	level4p = (pgd_t *)__va(start_pgtable);
-	result = init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
+	result = init_level4_page(image, level4p, 0, x_max_pfn << PAGE_SHIFT);
 	if (result)
 		return result;
 	/*
@@ -203,47 +318,6 @@ static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 	return init_transition_pgtable(image, level4p);
 }
 
-static void set_idt(void *newidt, u16 limit)
-{
-	struct desc_ptr curidt;
-
-	/* x86-64 supports unaliged loads & stores */
-	curidt.size    = limit;
-	curidt.address = (unsigned long)newidt;
-
-	__asm__ __volatile__ (
-		"lidtq %0\n"
-		: : "m" (curidt)
-		);
-};
-
-
-static void set_gdt(void *newgdt, u16 limit)
-{
-	struct desc_ptr curgdt;
-
-	/* x86-64 supports unaligned loads & stores */
-	curgdt.size    = limit;
-	curgdt.address = (unsigned long)newgdt;
-
-	__asm__ __volatile__ (
-		"lgdtq %0\n"
-		: : "m" (curgdt)
-		);
-};
-
-static void load_segments(void)
-{
-	__asm__ __volatile__ (
-		"\tmovl %0,%%ds\n"
-		"\tmovl %0,%%es\n"
-		"\tmovl %0,%%ss\n"
-		"\tmovl %0,%%fs\n"
-		"\tmovl %0,%%gs\n"
-		: : "a" (__KERNEL_DS) : "memory"
-		);
-}
-
 int machine_kexec_prepare(struct kimage *image)
 {
 	unsigned long start_pgtable;
@@ -265,6 +339,7 @@ void machine_kexec_cleanup(struct kimage *image)
 	free_transition_pgtable(image);
 }
 
+#ifndef CONFIG_XEN
 /*
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
@@ -311,24 +386,6 @@ void machine_kexec(struct kimage *image)
 		page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page)
 						<< PAGE_SHIFT);
 
-	/*
-	 * The segment registers are funny things, they have both a
-	 * visible and an invisible part.  Whenever the visible part is
-	 * set to a specific selector, the invisible part is loaded
-	 * with from a table in memory.  At no other time is the
-	 * descriptor table in memory accessed.
-	 *
-	 * I take advantage of this here by force loading the
-	 * segments, before I zap the gdt with an invalid value.
-	 */
-	load_segments();
-	/*
-	 * The gdt & idt are now invalid.
-	 * If you want to load them you must set up your own idt & gdt.
-	 */
-	set_gdt(phys_to_virt(0), 0);
-	set_idt(phys_to_virt(0), 0);
-
 	/* now call it */
 	image->start = relocate_kernel((unsigned long)image->head,
 				       (unsigned long)page_list,
@@ -342,10 +399,13 @@ void machine_kexec(struct kimage *image)
 
 	__ftrace_enabled_restore(save_ftrace_enabled);
 }
+#endif
 
 void arch_crash_save_vmcoreinfo(void)
 {
+#ifndef CONFIG_XEN /* could really be CONFIG_RELOCATABLE */
 	VMCOREINFO_SYMBOL(phys_base);
+#endif
 	VMCOREINFO_SYMBOL(init_level4_pgt);
 
 #ifdef CONFIG_NUMA
diff --git a/arch/x86/kernel/relocate_kernel_32.S b/arch/x86/kernel/relocate_kernel_32.S
index 4123553..fe0fbfb 100644
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -87,14 +87,32 @@ relocate_kernel:
 	movl	PTR(PA_PGD)(%ebp), %eax
 	movl	%eax, %cr3
 
+	/* setup idt */
+	lidtl	idt_48 - relocate_kernel(%edi)
+
+	/* setup gdt */
+	leal	gdt - relocate_kernel(%edi), %eax
+	movl	%eax, (gdt_48 - relocate_kernel) + 2(%edi)
+	lgdtl	gdt_48 - relocate_kernel(%edi)
+
+	/* setup data segment registers */
+	mov	$(gdt_ds - gdt), %eax
+	mov	%eax, %ds
+	mov	%eax, %es
+	mov	%eax, %fs
+	mov	%eax, %gs
+	mov	%eax, %ss
+
 	/* setup a new stack at the end of the physical control page */
 	lea	PAGE_SIZE(%edi), %esp
 
-	/* jump to identity mapped page */
+	/* load new code segment and jump to identity mapped page */
+	pushl	$0
+	pushl	$(gdt_cs - gdt)
 	movl    %edi, %eax
 	addl    $(identity_mapped - relocate_kernel), %eax
 	pushl   %eax
-	ret
+	iretl
 
 identity_mapped:
 	/* store the start address on the stack */
@@ -271,5 +289,22 @@ swap_pages:
 	popl	%ebp
 	ret
 
+	.align	16
+gdt:
+	.quad	0x0000000000000000	/* NULL descriptor */
+gdt_cs:
+	.quad	0x00cf9a000000ffff	/* kernel 4GB code at 0x00000000 */
+gdt_ds:
+	.quad	0x00cf92000000ffff	/* kernel 4GB data at 0x00000000 */
+gdt_end:
+
+gdt_48:
+	.word	gdt_end - gdt - 1	/* limit */
+	.long	0			/* base - filled in by code above */
+
+idt_48:
+	.word	0			/* limit */
+	.long	0			/* base */
+
 	.globl kexec_control_code_size
 .set kexec_control_code_size, . - relocate_kernel
diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index 4de8f5b..bb0455d 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -91,13 +91,30 @@ relocate_kernel:
 	/* Switch to the identity mapped page tables */
 	movq	%r9, %cr3
 
+	/* setup idt */
+	lidtq	idt_80 - relocate_kernel(%r8)
+
+	/* setup gdt */
+	leaq	gdt - relocate_kernel(%r8), %rax
+	movq	%rax, (gdt_80 - relocate_kernel) + 2(%r8)
+	lgdtq	gdt_80 - relocate_kernel(%r8)
+
+	/* setup data segment registers */
+	xorl	%eax, %eax
+	movl	%eax, %ds
+	movl	%eax, %es
+	movl	%eax, %fs
+	movl	%eax, %gs
+	movl	%eax, %ss
+
 	/* setup a new stack at the end of the physical control page */
 	lea	PAGE_SIZE(%r8), %rsp
 
-	/* jump to identity mapped page */
+	/* load new code segment and jump to identity mapped page */
 	addq	$(identity_mapped - relocate_kernel), %r8
+	pushq	$(gdt_cs - gdt)
 	pushq	%r8
-	ret
+	lretq
 
 identity_mapped:
 	/* store the start address on the stack */
@@ -262,5 +279,20 @@ swap_pages:
 3:
 	ret
 
+	.align  16
+gdt:
+	.quad	0x0000000000000000	/* NULL descriptor */
+gdt_cs:
+	.quad   0x00af9a000000ffff
+gdt_end:
+
+gdt_80:
+	.word	gdt_end - gdt - 1	/* limit */
+	.quad	0			/* base - filled in by code above */
+
+idt_80:
+	.word	0			/* limit */
+	.quad	0			/* base */
+
 	.globl kexec_control_code_size
 .set kexec_control_code_size, . - relocate_kernel
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c6724e4..b978d7e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -509,7 +509,7 @@ static void __init memblock_x86_reserve_range_setup_data(void)
  */
 
 #ifdef CONFIG_KEXEC
-
+#ifndef CONFIG_XEN
 static inline unsigned long long get_total_mem(void)
 {
 	unsigned long long total;
@@ -581,6 +581,9 @@ static void __init reserve_crashkernel(void)
 	insert_resource(&iomem_resource, &crashk_res);
 }
 #else
+#define reserve_crashkernel xen_machine_kexec_setup_resources
+#endif
+#else
 static void __init reserve_crashkernel(void)
 {
 }
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 8a8a156..b504d0e 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1030,7 +1030,9 @@ static void xen_emergency_restart(void)
 
 static void xen_machine_halt(void)
 {
+#ifndef CONFIG_KEXEC
 	xen_reboot(SHUTDOWN_poweroff);
+#endif
 }
 
 static void xen_machine_power_off(void)
@@ -1040,10 +1042,13 @@ static void xen_machine_power_off(void)
 	xen_reboot(SHUTDOWN_poweroff);
 }
 
+#ifdef CONFIG_KEXEC
 static void xen_crash_shutdown(struct pt_regs *regs)
 {
-	xen_reboot(SHUTDOWN_crash);
+	/* The kernel is broken so disable interrupts */
+	local_irq_disable();
 }
+#endif
 
 static int
 xen_panic_event(struct notifier_block *this, unsigned long event, void *ptr)
@@ -1067,8 +1072,10 @@ static const struct machine_ops xen_machine_ops __initconst = {
 	.halt = xen_machine_halt,
 	.power_off = xen_machine_power_off,
 	.shutdown = xen_machine_halt,
-	.crash_shutdown = xen_crash_shutdown,
 	.emergency_restart = xen_emergency_restart,
+#ifdef CONFIG_KEXEC
+	.crash_shutdown = xen_crash_shutdown
+#endif
 };
 
 /*
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 251acea..24d71fd 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -106,7 +106,7 @@ static inline void register_cpu_control(struct cpu *cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-#ifdef CONFIG_KEXEC
+#if defined(CONFIG_KEXEC) && !defined(CONFIG_XEN)
 #include <linux/kexec.h>
 
 static ssize_t show_crash_notes(struct sys_device *dev, struct sysdev_attribute *attr,
@@ -231,7 +231,7 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 	if (!error)
 		register_cpu_under_node(num, cpu_to_node(num));
 
-#ifdef CONFIG_KEXEC
+#if defined(CONFIG_KEXEC) && !defined(CONFIG_XEN)
 	if (!error)
 		error = sysdev_create_file(&cpu->sysdev, &attr_crash_notes);
 #endif
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index f1d5622..c0451cd 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_ACPI_PROCESSOR_XEN) += acpi_processor.o
 obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
 obj-$(CONFIG_XEN_DOM0)			+= pci.o
 obj-$(CONFIG_XEN_TMEM)		+= tmem.o
+obj-$(CONFIG_KEXEC)			+= machine_kexec.o
 
 xen-evtchn-y				:= evtchn.o
 xen-gntdev-y				:= gntdev.o
diff --git a/drivers/xen/machine_kexec.c b/drivers/xen/machine_kexec.c
new file mode 100644
index 0000000..8cd20e4
--- /dev/null
+++ b/drivers/xen/machine_kexec.c
@@ -0,0 +1,256 @@
+/*
+ * Handle transition of Linux booting another kernel.
+ */
+
+#include <linux/kexec.h>
+#include <linux/reboot.h>
+#include <linux/mm.h>
+#include <linux/bootmem.h>
+
+#include <xen/xen-ops.h>
+
+#include <xen/interface/kexec.h>
+
+#include <asm/xen/page.h>
+#include <asm/xen/hypercall.h>
+
+extern void machine_kexec_setup_load_arg(xen_kexec_image_t *xki, 
+					 struct kimage *image);
+extern int machine_kexec_setup_resources(struct resource *hypervisor,
+					 struct resource *phys_cpus,
+					 int nr_phys_cpus);
+extern void machine_kexec_register_resources(struct resource *res);
+
+static int __initdata xen_max_nr_phys_cpus;
+static struct resource xen_hypervisor_res;
+#if 0
+static struct resource *xen_phys_cpus;
+#endif
+static struct resource xen_phys_cpus[16];
+
+size_t vmcoreinfo_size_xen;
+unsigned long paddr_vmcoreinfo_xen;
+
+void __init xen_machine_kexec_setup_resources(void)
+{
+	xen_kexec_range_t range;
+	struct resource *res;
+	int k = 0;
+	int rc;
+
+	if (strstr(boot_command_line, "crashkernel="))
+		printk(KERN_WARNING "Ignoring crashkernel command line, "
+		       "parameter will be supplied by xen\n");
+
+	if (!xen_initial_domain())
+		return;
+
+	/* determine maximum number of physical cpus */
+
+	while (1) {
+		memset(&range, 0, sizeof(range));
+		range.range = KEXEC_RANGE_MA_CPU;
+		range.nr = k;
+
+		if(HYPERVISOR_kexec_op(KEXEC_CMD_kexec_get_range, &range))
+			break;
+
+		k++;
+	}
+
+	if (k == 0)
+		return;
+
+	xen_max_nr_phys_cpus = k;
+
+#if 0
+	/* allocate xen_phys_cpus */
+
+	xen_phys_cpus = alloc_bootmem_low(k * sizeof(struct resource));
+#endif
+
+	/* fill in xen_phys_cpus with per-cpu crash note information */
+
+	for (k = 0; k < xen_max_nr_phys_cpus; k++) {
+		memset(&range, 0, sizeof(range));
+		range.range = KEXEC_RANGE_MA_CPU;
+		range.nr = k;
+
+		if (HYPERVISOR_kexec_op(KEXEC_CMD_kexec_get_range, &range))
+			goto err;
+
+		res = xen_phys_cpus + k;
+
+		memset(res, 0, sizeof(*res));
+		res->name = "Crash note";
+		res->start = range.start;
+		res->end = range.start + range.size - 1;
+		res->flags = IORESOURCE_BUSY | IORESOURCE_MEM;
+	}
+
+	/* fill in xen_hypervisor_res with hypervisor machine address range */
+
+	memset(&range, 0, sizeof(range));
+	range.range = KEXEC_RANGE_MA_XEN;
+
+	if (HYPERVISOR_kexec_op(KEXEC_CMD_kexec_get_range, &range))
+		goto err;
+
+	xen_hypervisor_res.name = "Hypervisor code and data";
+	xen_hypervisor_res.start = range.start;
+	xen_hypervisor_res.end = range.start + range.size - 1;
+	xen_hypervisor_res.flags = IORESOURCE_BUSY | IORESOURCE_MEM;
+#ifdef CONFIG_X86
+	insert_resource(&iomem_resource, &xen_hypervisor_res);
+#endif
+
+	/* fill in crashk_res if range is reserved by hypervisor */
+
+	memset(&range, 0, sizeof(range));
+	range.range = KEXEC_RANGE_MA_CRASH;
+
+	if (HYPERVISOR_kexec_op(KEXEC_CMD_kexec_get_range, &range))
+		goto err;
+
+	if (range.size) {
+		crashk_res.start = range.start;
+		crashk_res.end = range.start + range.size - 1;
+#ifdef CONFIG_X86
+		insert_resource(&iomem_resource, &crashk_res);
+#endif
+	}
+
+	/* get physical address of vmcoreinfo */
+	memset(&range, 0, sizeof(range));
+	range.range = KEXEC_RANGE_MA_VMCOREINFO;
+
+	rc = HYPERVISOR_kexec_op(KEXEC_CMD_kexec_get_range, &range);
+
+	if (rc == 0) {
+		/* Hypercall succeeded */
+		vmcoreinfo_size_xen = range.size;
+		paddr_vmcoreinfo_xen = range.start;
+
+	} else {
+		/* Hypercall failed.
+		 * Indicate not to create sysfs file by resetting globals
+		 */
+		vmcoreinfo_size_xen = 0;
+		paddr_vmcoreinfo_xen = 0;
+		
+		/* The KEXEC_CMD_kexec_get_range hypercall did not implement
+		 * KEXEC_RANGE_MA_VMCOREINFO until Xen 3.3.
+		 * Do not bail out if it fails for this reason.
+		 */
+		if (rc != -EINVAL)
+			return;
+	}
+
+	if (machine_kexec_setup_resources(&xen_hypervisor_res, xen_phys_cpus,
+					  xen_max_nr_phys_cpus))
+		goto err;
+
+#ifdef CONFIG_X86
+	for (k = 0; k < xen_max_nr_phys_cpus; k++) {
+		res = xen_phys_cpus + k;
+		if (!res->parent) /* outside of xen_hypervisor_res range */
+			insert_resource(&iomem_resource, res);
+	}
+
+	if (xen_create_contiguous_region((unsigned long)&vmcoreinfo_note,
+					 get_order(sizeof(vmcoreinfo_note)),
+					 BITS_PER_LONG))
+		goto err;
+#endif
+
+	return;
+
+ err:
+	/*
+	 * It isn't possible to free xen_phys_cpus this early in the
+	 * boot. Failure at this stage is unexpected and the amount of
+	 * memory is small therefore we tolerate the potential leak.
+         */
+	xen_max_nr_phys_cpus = 0;
+	return;
+}
+
+#ifndef CONFIG_X86
+void __init xen_machine_kexec_register_resources(struct resource *res)
+{
+	int k;
+	struct resource *r;
+
+	request_resource(res, &xen_hypervisor_res);
+	for (k = 0; k < xen_max_nr_phys_cpus; k++) {
+		r = xen_phys_cpus + k;
+		if (r->parent == NULL) /* out of xen_hypervisor_res range */
+			request_resource(res, r);
+	} 
+	machine_kexec_register_resources(res);
+}
+#endif
+
+static void setup_load_arg(xen_kexec_image_t *xki, struct kimage *image)
+{
+	machine_kexec_setup_load_arg(xki, image);
+
+	xki->indirection_page = image->head;
+	xki->start_address = image->start;
+}
+
+/*
+ * Load the image into xen so xen can kdump itself
+ * This might have been done in prepare, but prepare
+ * is currently called too early. It might make sense
+ * to move prepare, but for now, just add an extra hook.
+ */
+int xen_machine_kexec_load(struct kimage *image)
+{
+	xen_kexec_load_t xkl;
+
+	memset(&xkl, 0, sizeof(xkl));
+	xkl.type = image->type;
+	setup_load_arg(&xkl.image, image);
+	return HYPERVISOR_kexec_op(KEXEC_CMD_kexec_load, &xkl);
+}
+
+/*
+ * Unload the image that was stored by machine_kexec_load()
+ * This might have been done in machine_kexec_cleanup() but it
+ * is called too late, and its possible xen could try and kdump
+ * using resources that have been freed.
+ */
+void xen_machine_kexec_unload(struct kimage *image)
+{
+	xen_kexec_load_t xkl;
+
+	memset(&xkl, 0, sizeof(xkl));
+	xkl.type = image->type;
+	WARN_ON(HYPERVISOR_kexec_op(KEXEC_CMD_kexec_unload, &xkl));
+}
+
+/*
+ * Do not allocate memory (or fail in any way) in machine_kexec().
+ * We are past the point of no return, committed to rebooting now.
+ *
+ * This has the hypervisor move to the prefered reboot CPU, 
+ * stop all CPUs and kexec. That is it combines machine_shutdown()
+ * and machine_kexec() in Linux kexec terms.
+ */
+NORET_TYPE void machine_kexec(struct kimage *image)
+{
+	xen_kexec_exec_t xke;
+
+	memset(&xke, 0, sizeof(xke));
+	xke.type = image->type;
+	(void)HYPERVISOR_kexec_op(KEXEC_CMD_kexec, &xke);
+	panic("KEXEC_CMD_kexec hypercall should not return\n");
+}
+
+#ifdef CONFIG_X86
+unsigned long paddr_vmcoreinfo_note(void)
+{
+	return virt_to_machine(&vmcoreinfo_note).maddr;
+}
+#endif
diff --git a/drivers/xen/sys-hypervisor.c b/drivers/xen/sys-hypervisor.c
index 1e0fe01..0dc4f51 100644
--- a/drivers/xen/sys-hypervisor.c
+++ b/drivers/xen/sys-hypervisor.c
@@ -355,6 +355,31 @@ static void xen_properties_destroy(void)
 	sysfs_remove_group(hypervisor_kobj, &xen_properties_group);
 }
 
+#ifdef CONFIG_KEXEC
+
+extern size_t vmcoreinfo_size_xen;
+extern unsigned long paddr_vmcoreinfo_xen;
+
+static ssize_t vmcoreinfo_show(struct hyp_sysfs_attr *attr, char *page)
+{
+	return sprintf(page, "%lx %zx\n",
+		paddr_vmcoreinfo_xen, vmcoreinfo_size_xen);
+}
+
+HYPERVISOR_ATTR_RO(vmcoreinfo);
+
+static int __init xen_sysfs_vmcoreinfo_init(void)
+{
+	return sysfs_create_file(hypervisor_kobj, &vmcoreinfo_attr.attr);
+}
+
+static void xen_sysfs_vmcoreinfo_destroy(void)
+{
+	sysfs_remove_file(hypervisor_kobj, &vmcoreinfo_attr.attr);
+}
+
+#endif
+
 static int __init hyper_sysfs_init(void)
 {
 	int ret;
@@ -377,9 +402,20 @@ static int __init hyper_sysfs_init(void)
 	ret = xen_properties_init();
 	if (ret)
 		goto prop_out;
+#ifdef CONFIG_KEXEC
+	if (vmcoreinfo_size_xen) {
+		ret = xen_sysfs_vmcoreinfo_init();
+		if (ret)
+			goto vmcoreinfo_out;
+	}
+#endif
 
 	goto out;
 
+#ifdef CONFIG_KEXEC
+vmcoreinfo_out:
+#endif
+	xen_properties_destroy();
 prop_out:
 	xen_sysfs_uuid_destroy();
 uuid_out:
@@ -394,6 +430,10 @@ out:
 
 static void __exit hyper_sysfs_exit(void)
 {
+#ifdef CONFIG_KEXEC
+	if (vmcoreinfo_size_xen)
+		xen_sysfs_vmcoreinfo_destroy();
+#endif
 	xen_properties_destroy();
 	xen_compilation_destroy();
 	xen_sysfs_uuid_destroy();
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 7397695..4ffe83c 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -673,8 +673,106 @@ void unregister_xenstore_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(unregister_xenstore_notifier);
 
+#ifdef CONFIG_CRASH_DUMP
+static DECLARE_WAIT_QUEUE_HEAD(be_state_wq);
+static int be_state;
+
+static void xenbus_reset_state_changed(struct xenbus_watch *w, const char **v, unsigned int l)
+{
+	xenbus_scanf(XBT_NIL, v[XS_WATCH_PATH], "", "%i", &be_state);
+	printk(KERN_INFO "XENBUS: %s %s\n", v[XS_WATCH_PATH], xenbus_strstate(be_state));
+	wake_up(&be_state_wq);
+}
+
+static int xenbus_reset_check_final(int *st)
+{
+	return *st == XenbusStateInitialising || *st == XenbusStateInitWait;
+}
+
+static void xenbus_reset_frontend_state(char *backend, char *frontend)
+{
+	struct xenbus_watch watch;
+
+	memset(&watch, 0, sizeof(watch));
+	watch.node = kasprintf(GFP_NOIO | __GFP_HIGH, "%s/state", backend);
+	if (!watch.node)
+		return;
+
+	watch.callback = xenbus_reset_state_changed;
+	be_state = XenbusStateUnknown;
+
+	printk(KERN_INFO "XENBUS: triggering reconnect on %s\n", backend);
+	register_xenbus_watch(&watch);
+
+	xenbus_printf(XBT_NIL, frontend, "state", "%d", XenbusStateClosing);
+	wait_event_interruptible(be_state_wq, be_state == XenbusStateClosing);
+
+	xenbus_printf(XBT_NIL, frontend, "state", "%d", XenbusStateClosed);
+	wait_event_interruptible(be_state_wq, be_state == XenbusStateClosed);
+
+	xenbus_printf(XBT_NIL, frontend, "state", "%d", XenbusStateInitialising);
+	wait_event_interruptible(be_state_wq, xenbus_reset_check_final(&be_state));
+
+	unregister_xenbus_watch(&watch);
+	printk(KERN_INFO "XENBUS: reconnect done on %s\n", backend);
+	kfree(watch.node);
+}
+
+static void xenbus_reset_check_state(char *class, char *dev)
+{
+	int state, err;
+	char *backend, *frontend;
+
+	frontend = kasprintf(GFP_NOIO | __GFP_HIGH, "device/%s/%s", class, dev);
+	if (!frontend)
+		return;
+
+	err = xenbus_scanf(XBT_NIL, frontend, "state", "%i", &state);
+	/* frontend connected? */
+	if (err == 1 && state == XenbusStateConnected) {
+		backend = xenbus_read(XBT_NIL, frontend, "backend", NULL);
+		if (!backend || IS_ERR(backend))
+			goto out;
+		err = xenbus_scanf(XBT_NIL, backend, "state", "%i", &state);
+		/* backend connected? */
+		if (err == 1 && state == XenbusStateConnected)
+			xenbus_reset_frontend_state(backend, frontend);
+		kfree(backend);
+	}
+out:
+	kfree(frontend);
+}
+
+static void xenbus_reset_state(void)
+{
+	char **devclass, **dev;
+	int devclass_n, dev_n;
+	int i, j;
+
+	devclass = xenbus_directory(XBT_NIL, "device", "", &devclass_n);
+	if (IS_ERR(devclass))
+		return;
+
+	for (i = 0; i < devclass_n; i++) {
+		dev = xenbus_directory(XBT_NIL, "device", devclass[i], &dev_n);
+		if (IS_ERR(dev))
+			continue;
+		for (j = 0; j < dev_n; j++)
+			xenbus_reset_check_state(devclass[i], dev[j]);
+		kfree(dev);
+	}
+	kfree(devclass);
+}
+#endif
+
 void xenbus_probe(struct work_struct *unused)
 {
+#ifdef CONFIG_CRASH_DUMP
+	/* reset devices in XenbusStateConnected state */
+	if (reset_devices)
+		xenbus_reset_state();
+#endif
+
 	xenstored_ready = 1;
 
 	/* Notify others that xenstore is up */
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index c2478a3..15565c6 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -112,6 +112,12 @@ struct kimage {
 extern void machine_kexec(struct kimage *image);
 extern int machine_kexec_prepare(struct kimage *image);
 extern void machine_kexec_cleanup(struct kimage *image);
+#ifdef CONFIG_XEN
+extern int xen_machine_kexec_load(struct kimage *image);
+extern void xen_machine_kexec_unload(struct kimage *image);
+extern void xen_machine_kexec_setup_resources(void);
+extern void xen_machine_kexec_register_resources(struct resource *res);
+#endif
 extern asmlinkage long sys_kexec_load(unsigned long entry,
 					unsigned long nr_segments,
 					struct kexec_segment __user *segments,
@@ -192,8 +198,15 @@ extern struct kimage *kexec_crash_image;
 #define VMCOREINFO_BYTES           (4096)
 #define VMCOREINFO_NOTE_NAME       "VMCOREINFO"
 #define VMCOREINFO_NOTE_NAME_BYTES ALIGN(sizeof(VMCOREINFO_NOTE_NAME), 4)
+#if !defined(CONFIG_XEN) || !defined(CONFIG_X86)
 #define VMCOREINFO_NOTE_SIZE       (KEXEC_NOTE_HEAD_BYTES*2 + VMCOREINFO_BYTES \
 				    + VMCOREINFO_NOTE_NAME_BYTES)
+#else
+#define VMCOREINFO_NOTE_SIZE       ALIGN(KEXEC_NOTE_HEAD_BYTES*2 \
+					 + VMCOREINFO_BYTES \
+					 + VMCOREINFO_NOTE_NAME_BYTES, \
+					 PAGE_SIZE)
+#endif
 
 /* Location of a reserved region to hold the crash kernel.
  */
diff --git a/include/xen/interface/kexec.h b/include/xen/interface/kexec.h
new file mode 100644
index 0000000..5fd0495
--- /dev/null
+++ b/include/xen/interface/kexec.h
@@ -0,0 +1,158 @@
+/******************************************************************************
+ * kexec.h - Public portion
+ * 
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ * 
+ * Xen port written by:
+ * - Simon 'Horms' Horman <horms@verge.net.au>
+ * - Magnus Damm <magnus@valinux.co.jp>
+ */
+
+#ifndef _XEN_PUBLIC_KEXEC_H
+#define _XEN_PUBLIC_KEXEC_H
+
+
+/* This file describes the Kexec / Kdump hypercall interface for Xen.
+ *
+ * Kexec under vanilla Linux allows a user to reboot the physical machine 
+ * into a new user-specified kernel. The Xen port extends this idea
+ * to allow rebooting of the machine from dom0. When kexec for dom0
+ * is used to reboot,  both the hypervisor and the domains get replaced
+ * with some other kernel. It is possible to kexec between vanilla
+ * Linux and Xen and back again. Xen to Xen works well too.
+ *
+ * The hypercall interface for kexec can be divided into three main
+ * types of hypercall operations:
+ *
+ * 1) Range information:
+ *    This is used by the dom0 kernel to ask the hypervisor about various 
+ *    address information. This information is needed to allow kexec-tools 
+ *    to fill in the ELF headers for /proc/vmcore properly.
+ *
+ * 2) Load and unload of images:
+ *    There are no big surprises here, the kexec binary from kexec-tools
+ *    runs in userspace in dom0. The tool loads/unloads data into the
+ *    dom0 kernel such as new kernel, initramfs and hypervisor. When
+ *    loaded the dom0 kernel performs a load hypercall operation, and
+ *    before releasing all page references the dom0 kernel calls unload.
+ *
+ * 3) Kexec operation:
+ *    This is used to start a previously loaded kernel.
+ */
+
+#include "xen.h"
+
+#if defined(__i386__) || defined(__x86_64__)
+#define KEXEC_XEN_NO_PAGES 17
+#endif
+
+/*
+ * Prototype for this hypercall is:
+ *  int kexec_op(int cmd, void *args)
+ * @cmd  == KEXEC_CMD_... 
+ *          KEXEC operation to perform
+ * @args == Operation-specific extra arguments (NULL if none).
+ */
+
+/*
+ * Kexec supports two types of operation:
+ * - kexec into a regular kernel, very similar to a standard reboot
+ *   - KEXEC_TYPE_DEFAULT is used to specify this type
+ * - kexec into a special "crash kernel", aka kexec-on-panic
+ *   - KEXEC_TYPE_CRASH is used to specify this type
+ *   - parts of our system may be broken at kexec-on-panic time
+ *     - the code should be kept as simple and self-contained as possible
+ */
+
+#define KEXEC_TYPE_DEFAULT 0
+#define KEXEC_TYPE_CRASH   1
+
+
+/* The kexec implementation for Xen allows the user to load two
+ * types of kernels, KEXEC_TYPE_DEFAULT and KEXEC_TYPE_CRASH.
+ * All data needed for a kexec reboot is kept in one xen_kexec_image_t
+ * per "instance". The data mainly consists of machine address lists to pages
+ * together with destination addresses. The data in xen_kexec_image_t
+ * is passed to the "code page" which is one page of code that performs
+ * the final relocations before jumping to the new kernel.
+ */
+ 
+typedef struct xen_kexec_image {
+#if defined(__i386__) || defined(__x86_64__)
+    unsigned long page_list[KEXEC_XEN_NO_PAGES];
+#endif
+#if defined(__ia64__)
+    unsigned long reboot_code_buffer;
+#endif
+    unsigned long indirection_page;
+    unsigned long start_address;
+} xen_kexec_image_t;
+
+/*
+ * Perform kexec having previously loaded a kexec or kdump kernel
+ * as appropriate.
+ * type == KEXEC_TYPE_DEFAULT or KEXEC_TYPE_CRASH [in]
+ */
+#define KEXEC_CMD_kexec                 0
+typedef struct xen_kexec_exec {
+    int type;
+} xen_kexec_exec_t;
+
+/*
+ * Load/Unload kernel image for kexec or kdump.
+ * type  == KEXEC_TYPE_DEFAULT or KEXEC_TYPE_CRASH [in]
+ * image == relocation information for kexec (ignored for unload) [in]
+ */
+#define KEXEC_CMD_kexec_load            1
+#define KEXEC_CMD_kexec_unload          2
+typedef struct xen_kexec_load {
+    int type;
+    xen_kexec_image_t image;
+} xen_kexec_load_t;
+
+#define KEXEC_RANGE_MA_CRASH      0 /* machine address and size of crash area */
+#define KEXEC_RANGE_MA_XEN        1 /* machine address and size of Xen itself */
+#define KEXEC_RANGE_MA_CPU        2 /* machine address and size of a CPU note */
+#define KEXEC_RANGE_MA_XENHEAP    3 /* machine address and size of xenheap
+                                     * Note that although this is adjacent
+                                     * to Xen it exists in a separate EFI
+                                     * region on ia64, and thus needs to be
+                                     * inserted into iomem_machine separately */
+#define KEXEC_RANGE_MA_BOOT_PARAM 4 /* machine address and size of
+                                     * the ia64_boot_param */
+#define KEXEC_RANGE_MA_EFI_MEMMAP 5 /* machine address and size of
+                                     * of the EFI Memory Map */
+#define KEXEC_RANGE_MA_VMCOREINFO 6 /* machine address and size of vmcoreinfo */
+
+/*
+ * Find the address and size of certain memory areas
+ * range == KEXEC_RANGE_... [in]
+ * nr    == physical CPU number (starting from 0) if KEXEC_RANGE_MA_CPU [in]
+ * size  == number of bytes reserved in window [out]
+ * start == address of the first byte in the window [out]
+ */
+#define KEXEC_CMD_kexec_get_range       3
+typedef struct xen_kexec_range {
+    int range;
+    int nr;
+    unsigned long size;
+    unsigned long start;
+} xen_kexec_range_t;
+
+#endif /* _XEN_PUBLIC_KEXEC_H */
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 9f2d370..2e23363 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -58,6 +58,7 @@
 #define __HYPERVISOR_event_channel_op     32
 #define __HYPERVISOR_physdev_op           33
 #define __HYPERVISOR_hvm_op               34
+#define __HYPERVISOR_kexec_op             37
 #define __HYPERVISOR_tmem_op              38
 
 /* Architecture-specific hypercall definitions. */
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 87b77de..b92fdf0 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -35,18 +35,26 @@
 #include <linux/kmsg_dump.h>
 #include <linux/syscore_ops.h>
 
+#include <xen/xen-ops.h>
+
 #include <asm/page.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/sections.h>
 
+#include <asm/xen/page.h>
+
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
 
 /* vmcoreinfo stuff */
 static unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
+#if defined(CONFIG_XEN) && defined(CONFIG_X86)
+u32 __page_aligned_bss vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
+#else
 u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
+#endif
 size_t vmcoreinfo_size;
 size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
 
@@ -357,13 +365,26 @@ static int kimage_is_destination_range(struct kimage *image,
 	return 0;
 }
 
-static struct page *kimage_alloc_pages(gfp_t gfp_mask, unsigned int order)
+static struct page *kimage_alloc_pages(gfp_t gfp_mask, unsigned int order, unsigned long limit)
 {
 	struct page *pages;
 
 	pages = alloc_pages(gfp_mask, order);
 	if (pages) {
 		unsigned int count, i;
+#ifdef CONFIG_XEN
+		int address_bits;
+
+		if (limit == ~0UL)
+			address_bits = BITS_PER_LONG;
+		else
+			address_bits = ilog2(limit);
+
+		if (xen_create_contiguous_region((unsigned long)page_address(pages), order, address_bits) < 0) {
+			__free_pages(pages, order);
+			return NULL;
+		}
+#endif
 		pages->mapping = NULL;
 		set_page_private(pages, order);
 		count = 1 << order;
@@ -427,10 +448,10 @@ static struct page *kimage_alloc_normal_control_pages(struct kimage *image,
 	do {
 		unsigned long pfn, epfn, addr, eaddr;
 
-		pages = kimage_alloc_pages(GFP_KERNEL, order);
+		pages = kimage_alloc_pages(GFP_KERNEL, order, KEXEC_CONTROL_MEMORY_LIMIT);
 		if (!pages)
 			break;
-		pfn   = page_to_pfn(pages);
+		pfn   = pfn_to_mfn(page_to_pfn(pages));
 		epfn  = pfn + count;
 		addr  = pfn << PAGE_SHIFT;
 		eaddr = epfn << PAGE_SHIFT;
@@ -464,6 +485,7 @@ static struct page *kimage_alloc_normal_control_pages(struct kimage *image,
 	return pages;
 }
 
+#ifndef CONFIG_XEN
 static struct page *kimage_alloc_crash_control_pages(struct kimage *image,
 						      unsigned int order)
 {
@@ -517,7 +539,7 @@ static struct page *kimage_alloc_crash_control_pages(struct kimage *image,
 		}
 		/* If I don't overlap any segments I have found my hole! */
 		if (i == image->nr_segments) {
-			pages = pfn_to_page(hole_start >> PAGE_SHIFT);
+			pages = pfn_to_page(mfn_to_pfn(hole_start >> PAGE_SHIFT));
 			break;
 		}
 	}
@@ -544,6 +566,13 @@ struct page *kimage_alloc_control_pages(struct kimage *image,
 
 	return pages;
 }
+#else /* !CONFIG_XEN */
+struct page *kimage_alloc_control_pages(struct kimage *image,
+					 unsigned int order)
+{
+	return kimage_alloc_normal_control_pages(image, order);
+}
+#endif
 
 static int kimage_add_entry(struct kimage *image, kimage_entry_t entry)
 {
@@ -559,7 +588,7 @@ static int kimage_add_entry(struct kimage *image, kimage_entry_t entry)
 			return -ENOMEM;
 
 		ind_page = page_address(page);
-		*image->entry = virt_to_phys(ind_page) | IND_INDIRECTION;
+		*image->entry = virt_to_machine(ind_page).maddr | IND_INDIRECTION;
 		image->entry = ind_page;
 		image->last_entry = ind_page +
 				      ((PAGE_SIZE/sizeof(kimage_entry_t)) - 1);
@@ -618,13 +647,13 @@ static void kimage_terminate(struct kimage *image)
 #define for_each_kimage_entry(image, ptr, entry) \
 	for (ptr = &image->head; (entry = *ptr) && !(entry & IND_DONE); \
 		ptr = (entry & IND_INDIRECTION)? \
-			phys_to_virt((entry & PAGE_MASK)): ptr +1)
+			phys_to_virt(machine_to_phys(XMADDR(entry & PAGE_MASK)).paddr): ptr +1)
 
 static void kimage_free_entry(kimage_entry_t entry)
 {
 	struct page *page;
 
-	page = pfn_to_page(entry >> PAGE_SHIFT);
+	page = pfn_to_page(mfn_to_pfn(entry >> PAGE_SHIFT));
 	kimage_free_pages(page);
 }
 
@@ -636,6 +665,10 @@ static void kimage_free(struct kimage *image)
 	if (!image)
 		return;
 
+#ifdef CONFIG_XEN
+	xen_machine_kexec_unload(image);
+#endif
+
 	kimage_free_extra_pages(image);
 	for_each_kimage_entry(image, ptr, entry) {
 		if (entry & IND_INDIRECTION) {
@@ -711,7 +744,7 @@ static struct page *kimage_alloc_page(struct kimage *image,
 	 * have a match.
 	 */
 	list_for_each_entry(page, &image->dest_pages, lru) {
-		addr = page_to_pfn(page) << PAGE_SHIFT;
+		addr = pfn_to_mfn(page_to_pfn(page)) << PAGE_SHIFT;
 		if (addr == destination) {
 			list_del(&page->lru);
 			return page;
@@ -722,16 +755,16 @@ static struct page *kimage_alloc_page(struct kimage *image,
 		kimage_entry_t *old;
 
 		/* Allocate a page, if we run out of memory give up */
-		page = kimage_alloc_pages(gfp_mask, 0);
+		page = kimage_alloc_pages(gfp_mask, 0, KEXEC_SOURCE_MEMORY_LIMIT);
 		if (!page)
 			return NULL;
 		/* If the page cannot be used file it away */
-		if (page_to_pfn(page) >
+		if (pfn_to_mfn(page_to_pfn(page)) >
 				(KEXEC_SOURCE_MEMORY_LIMIT >> PAGE_SHIFT)) {
 			list_add(&page->lru, &image->unuseable_pages);
 			continue;
 		}
-		addr = page_to_pfn(page) << PAGE_SHIFT;
+		addr = pfn_to_mfn(page_to_pfn(page)) << PAGE_SHIFT;
 
 		/* If it is the destination page we want use it */
 		if (addr == destination)
@@ -754,7 +787,7 @@ static struct page *kimage_alloc_page(struct kimage *image,
 			struct page *old_page;
 
 			old_addr = *old & PAGE_MASK;
-			old_page = pfn_to_page(old_addr >> PAGE_SHIFT);
+			old_page = pfn_to_page(mfn_to_pfn(old_addr >> PAGE_SHIFT));
 			copy_highpage(page, old_page);
 			*old = addr | (*old & ~PAGE_MASK);
 
@@ -810,7 +843,7 @@ static int kimage_load_normal_segment(struct kimage *image,
 			result  = -ENOMEM;
 			goto out;
 		}
-		result = kimage_add_page(image, page_to_pfn(page)
+		result = kimage_add_page(image, pfn_to_mfn(page_to_pfn(page))
 								<< PAGE_SHIFT);
 		if (result < 0)
 			goto out;
@@ -842,6 +875,7 @@ out:
 	return result;
 }
 
+#ifndef CONFIG_XEN
 static int kimage_load_crash_segment(struct kimage *image,
 					struct kexec_segment *segment)
 {
@@ -864,7 +898,7 @@ static int kimage_load_crash_segment(struct kimage *image,
 		char *ptr;
 		size_t uchunk, mchunk;
 
-		page = pfn_to_page(maddr >> PAGE_SHIFT);
+		page = pfn_to_page(mfn_to_pfn(maddr >> PAGE_SHIFT));
 		if (!page) {
 			result  = -ENOMEM;
 			goto out;
@@ -913,6 +947,13 @@ static int kimage_load_segment(struct kimage *image,
 
 	return result;
 }
+#else /* CONFIG_XEN */
+static int kimage_load_segment(struct kimage *image,
+				struct kexec_segment *segment)
+{
+	return kimage_load_normal_segment(image, segment);
+}
+#endif
 
 /*
  * Exec Kernel system call: for obvious reasons only root may call it.
@@ -1016,6 +1057,13 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 		}
 		kimage_terminate(image);
 	}
+#ifdef CONFIG_XEN
+	if (image) {
+		result = xen_machine_kexec_load(image);
+		if (result)
+			goto out;
+	}
+#endif
 	/* Install the new kernel, and  Uninstall the old */
 	image = xchg(dest_image, image);
 
@@ -1106,8 +1154,8 @@ void __weak crash_free_reserved_phys_range(unsigned long begin,
 	unsigned long addr;
 
 	for (addr = begin; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(pfn_to_page(addr >> PAGE_SHIFT));
-		init_page_count(pfn_to_page(addr >> PAGE_SHIFT));
+		ClearPageReserved(pfn_to_page(mfn_to_pfn(addr >> PAGE_SHIFT)));
+		init_page_count(pfn_to_page(mfn_to_pfn(addr >> PAGE_SHIFT)));
 		free_page((unsigned long)__va(addr));
 		totalram_pages++;
 	}
@@ -1216,6 +1264,7 @@ static int __init crash_notes_memory_init(void)
 module_init(crash_notes_memory_init)
 
 
+#ifndef CONFIG_XEN
 /*
  * parsing the "crashkernel" commandline
  *
@@ -1378,6 +1427,7 @@ int __init parse_crashkernel(char 		 *cmdline,
 
 	return 0;
 }
+#endif
 
 
 
@@ -1435,7 +1485,18 @@ static int __init crash_save_vmcoreinfo_init(void)
 
 	VMCOREINFO_SYMBOL(init_uts_ns);
 	VMCOREINFO_SYMBOL(node_online_map);
+#ifndef CONFIG_X86_XEN
 	VMCOREINFO_SYMBOL(swapper_pg_dir);
+#else
+/*
+ * Since for x86-32 Xen swapper_pg_dir is a pointer rather than an array,
+ * make the value stored consistent with native (i.e. the base address of
+ * the page directory).
+ */
+# define swapper_pg_dir *swapper_pg_dir
+	VMCOREINFO_SYMBOL(swapper_pg_dir);
+# undef swapper_pg_dir
+#endif
 	VMCOREINFO_SYMBOL(_stext);
 	VMCOREINFO_SYMBOL(vmlist);
 
