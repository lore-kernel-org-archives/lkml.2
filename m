Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab0JUNzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:55:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50577 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426Ab0JUNzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:55:49 -0400
Date: Thu, 21 Oct 2010 15:55:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm for v2.6.37
Message-ID: <20101021135538.GA7330@elte.hu>
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

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mm-for-linus


out-of-topic modifications in x86-mm-for-linus:
-----------------------------------------------
include/asm-generic/pgtable.h      # 61c7732: x86, mm: Avoid unnecessary TLB fl
include/asm-generic/vmlinux.lds.h  # 2aeb66d: x86-32, percpu: Correct the order
                                   # c957ef2: percpu: Introduce a read-mostly p
include/linux/percpu-defs.h        # c957ef2: percpu: Introduce a read-mostly p
mm/memory.c                        # 61c7732: x86, mm: Avoid unnecessary TLB fl
mm/vmalloc.c                       # 3ee48b6: mm, x86: Saving vmcore with non-l

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86, mm: Fix incorrect data type in vmalloc_sync_all()

Cliff Wickman (2):
      x86, kdump: Change copy_oldmem_page() to use cached addressing
      mm, x86: Saving vmcore with non-lazy freeing of vmas

FUJITA Tomonori (1):
      x86, mm: Enable ARCH_DMA_ADDR_T_64BIT with X86_64 || HIGHMEM64G

H. Peter Anvin (1):
      x86-32, percpu: Correct the ordering of the percpu readmostly section

Haicheng Li (2):
      x86, mm: Separate x86_64 vmalloc_sync_all() into separate functions
      x86-64, mem: Update all PGDs for direct mapping and vmemmap mapping changes

Jeremy Fitzhardinge (3):
      x86, mm: Add RESERVE_BRK_ARRAY() helper
      x86, mm: Fix bogus whitespace in sync_global_pgds()
      x86, mm: Hold mm->page_table_lock while doing vmalloc_sync

Julia Lawall (1):
      x86, kmemcheck: Remove double test

Namhyung Kim (1):
      x86-32: Fix sparse warning for the __PHYSICAL_MASK calculation

Shaohua Li (4):
      x86, mm: Avoid unnecessary TLB flush
      x86, mm: Make spurious_fault check explicitly check the PRESENT bit
      percpu: Introduce a read-mostly percpu API
      x86: Spread tlb flush vector between nodes

Wu Fengguang (1):
      x86, mm: fix uninitialized addr in kernel_physical_mapping_init()


 arch/x86/Kconfig                  |    3 ++
 arch/x86/include/asm/io.h         |    1 +
 arch/x86/include/asm/page_types.h |    2 +-
 arch/x86/include/asm/pgtable.h    |    4 +++
 arch/x86/include/asm/pgtable_64.h |    2 +
 arch/x86/include/asm/setup.h      |    5 ++++
 arch/x86/kernel/crash_dump_64.c   |    3 +-
 arch/x86/mm/fault.c               |   43 ++++++++++++++-------------------
 arch/x86/mm/init_64.c             |   47 +++++++++++++++++++++++++++++++++++-
 arch/x86/mm/kmemcheck/opcode.c    |    2 +-
 arch/x86/mm/pgtable.c             |   20 +++++++++++++--
 arch/x86/mm/tlb.c                 |   48 ++++++++++++++++++++++++++++++++++++-
 include/asm-generic/pgtable.h     |    4 +++
 include/asm-generic/vmlinux.lds.h |    4 +++
 include/linux/percpu-defs.h       |    9 +++++++
 mm/memory.c                       |    2 +-
 mm/vmalloc.c                      |    9 +++++++
 17 files changed, 174 insertions(+), 34 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..2924f4e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1148,6 +1148,9 @@ config X86_PAE
 config ARCH_PHYS_ADDR_T_64BIT
 	def_bool X86_64 || X86_PAE
 
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool X86_64 || HIGHMEM64G
+
 config DIRECT_GBPAGES
 	bool "Enable 1GB pages for kernel pagetables" if EMBEDDED
 	default y
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 30a3e97..6a45ec4 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -206,6 +206,7 @@ static inline void __iomem *ioremap(resource_size_t offset, unsigned long size)
 
 extern void iounmap(volatile void __iomem *addr);
 
+extern void set_iounmap_nonlazy(void);
 
 #ifdef __KERNEL__
 
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index a667f24..1df6621 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -8,7 +8,7 @@
 #define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
-#define __PHYSICAL_MASK		((phys_addr_t)(1ULL << __PHYSICAL_MASK_SHIFT) - 1)
+#define __PHYSICAL_MASK		((phys_addr_t)((1ULL << __PHYSICAL_MASK_SHIFT) - 1))
 #define __VIRTUAL_MASK		((1UL << __VIRTUAL_MASK_SHIFT) - 1)
 
 /* Cast PAGE_MASK to a signed type so that it is sign-extended if
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index a34c785..ada823a 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -28,6 +28,8 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
 extern spinlock_t pgd_lock;
 extern struct list_head pgd_list;
 
+extern struct mm_struct *pgd_page_get_mm(struct page *page);
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else  /* !CONFIG_PARAVIRT */
@@ -603,6 +605,8 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
 	pte_update(mm, addr, ptep);
 }
 
+#define flush_tlb_fix_spurious_fault(vma, address)
+
 /*
  * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
  *
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 076052c..f96ac9b 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -102,6 +102,8 @@ static inline void native_pgd_clear(pgd_t *pgd)
 	native_set_pgd(pgd, native_make_pgd(0));
 }
 
+extern void sync_global_pgds(unsigned long start, unsigned long end);
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index ef292c7..d6763b1 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -93,6 +93,11 @@ void *extend_brk(size_t size, size_t align);
 			: : "i" (sz));					\
 	}
 
+/* Helper for reserving space for arrays of things */
+#define RESERVE_BRK_ARRAY(type, name, entries)		\
+	type *name;					\
+	RESERVE_BRK(name, sizeof(type) * entries)
+
 #ifdef __i386__
 
 void __init i386_start_kernel(void);
diff --git a/arch/x86/kernel/crash_dump_64.c b/arch/x86/kernel/crash_dump_64.c
index 045b36c..9948288 100644
--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -34,7 +34,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	if (!csize)
 		return 0;
 
-	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
+	vaddr = ioremap_cache(pfn << PAGE_SHIFT, PAGE_SIZE);
 	if (!vaddr)
 		return -ENOMEM;
 
@@ -46,6 +46,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	} else
 		memcpy(buf, vaddr + offset, csize);
 
+	set_iounmap_nonlazy();
 	iounmap(vaddr);
 	return csize;
 }
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 4c4508e..0cdb8d4 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -229,7 +229,16 @@ void vmalloc_sync_all(void)
 
 		spin_lock_irqsave(&pgd_lock, flags);
 		list_for_each_entry(page, &pgd_list, lru) {
-			if (!vmalloc_sync_one(page_address(page), address))
+			spinlock_t *pgt_lock;
+			pmd_t *ret;
+
+			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
+
+			spin_lock(pgt_lock);
+			ret = vmalloc_sync_one(page_address(page), address);
+			spin_unlock(pgt_lock);
+
+			if (!ret)
 				break;
 		}
 		spin_unlock_irqrestore(&pgd_lock, flags);
@@ -326,29 +335,7 @@ out:
 
 void vmalloc_sync_all(void)
 {
-	unsigned long address;
-
-	for (address = VMALLOC_START & PGDIR_MASK; address <= VMALLOC_END;
-	     address += PGDIR_SIZE) {
-
-		const pgd_t *pgd_ref = pgd_offset_k(address);
-		unsigned long flags;
-		struct page *page;
-
-		if (pgd_none(*pgd_ref))
-			continue;
-
-		spin_lock_irqsave(&pgd_lock, flags);
-		list_for_each_entry(page, &pgd_list, lru) {
-			pgd_t *pgd;
-			pgd = (pgd_t *)page_address(page) + pgd_index(address);
-			if (pgd_none(*pgd))
-				set_pgd(pgd, *pgd_ref);
-			else
-				BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_ref));
-		}
-		spin_unlock_irqrestore(&pgd_lock, flags);
-	}
+	sync_global_pgds(VMALLOC_START & PGDIR_MASK, VMALLOC_END);
 }
 
 /*
@@ -894,8 +881,14 @@ spurious_fault(unsigned long error_code, unsigned long address)
 	if (pmd_large(*pmd))
 		return spurious_fault_check(error_code, (pte_t *) pmd);
 
+	/*
+	 * Note: don't use pte_present() here, since it returns true
+	 * if the _PAGE_PROTNONE bit is set.  However, this aliases the
+	 * _PAGE_GLOBAL bit, which for kernel pages give false positives
+	 * when CONFIG_DEBUG_PAGEALLOC is used.
+	 */
 	pte = pte_offset_kernel(pmd, address);
-	if (!pte_present(*pte))
+	if (!(pte_flags(*pte) & _PAGE_PRESENT))
 		return 0;
 
 	ret = spurious_fault_check(error_code, pte);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 9a66746..4d323fb 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -98,6 +98,43 @@ static int __init nonx32_setup(char *str)
 __setup("noexec32=", nonx32_setup);
 
 /*
+ * When memory was added/removed make sure all the processes MM have
+ * suitable PGD entries in the local PGD level page.
+ */
+void sync_global_pgds(unsigned long start, unsigned long end)
+{
+	unsigned long address;
+
+	for (address = start; address <= end; address += PGDIR_SIZE) {
+		const pgd_t *pgd_ref = pgd_offset_k(address);
+		unsigned long flags;
+		struct page *page;
+
+		if (pgd_none(*pgd_ref))
+			continue;
+
+		spin_lock_irqsave(&pgd_lock, flags);
+		list_for_each_entry(page, &pgd_list, lru) {
+			pgd_t *pgd;
+			spinlock_t *pgt_lock;
+
+			pgd = (pgd_t *)page_address(page) + pgd_index(address);
+			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
+			spin_lock(pgt_lock);
+
+			if (pgd_none(*pgd))
+				set_pgd(pgd, *pgd_ref);
+			else
+				BUG_ON(pgd_page_vaddr(*pgd)
+				       != pgd_page_vaddr(*pgd_ref));
+
+			spin_unlock(pgt_lock);
+		}
+		spin_unlock_irqrestore(&pgd_lock, flags);
+	}
+}
+
+/*
  * NOTE: This function is marked __ref because it calls __init function
  * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
  */
@@ -534,11 +571,13 @@ kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
 			     unsigned long page_size_mask)
 {
-
+	bool pgd_changed = false;
 	unsigned long next, last_map_addr = end;
+	unsigned long addr;
 
 	start = (unsigned long)__va(start);
 	end = (unsigned long)__va(end);
+	addr = start;
 
 	for (; start < end; start = next) {
 		pgd_t *pgd = pgd_offset_k(start);
@@ -563,7 +602,12 @@ kernel_physical_mapping_init(unsigned long start,
 		spin_lock(&init_mm.page_table_lock);
 		pgd_populate(&init_mm, pgd, __va(pud_phys));
 		spin_unlock(&init_mm.page_table_lock);
+		pgd_changed = true;
 	}
+
+	if (pgd_changed)
+		sync_global_pgds(addr, end);
+
 	__flush_tlb_all();
 
 	return last_map_addr;
@@ -1003,6 +1047,7 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
 		}
 
 	}
+	sync_global_pgds((unsigned long)start_page, end);
 	return 0;
 }
 
diff --git a/arch/x86/mm/kmemcheck/opcode.c b/arch/x86/mm/kmemcheck/opcode.c
index 63c19e2..324aa3f 100644
--- a/arch/x86/mm/kmemcheck/opcode.c
+++ b/arch/x86/mm/kmemcheck/opcode.c
@@ -9,7 +9,7 @@ static bool opcode_is_prefix(uint8_t b)
 		b == 0xf0 || b == 0xf2 || b == 0xf3
 		/* Group 2 */
 		|| b == 0x2e || b == 0x36 || b == 0x3e || b == 0x26
-		|| b == 0x64 || b == 0x65 || b == 0x2e || b == 0x3e
+		|| b == 0x64 || b == 0x65
 		/* Group 3 */
 		|| b == 0x66
 		/* Group 4 */
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 5c4ee42..c70e57d 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -87,7 +87,19 @@ static inline void pgd_list_del(pgd_t *pgd)
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 
-static void pgd_ctor(pgd_t *pgd)
+
+static void pgd_set_mm(pgd_t *pgd, struct mm_struct *mm)
+{
+	BUILD_BUG_ON(sizeof(virt_to_page(pgd)->index) < sizeof(mm));
+	virt_to_page(pgd)->index = (pgoff_t)mm;
+}
+
+struct mm_struct *pgd_page_get_mm(struct page *page)
+{
+	return (struct mm_struct *)page->index;
+}
+
+static void pgd_ctor(struct mm_struct *mm, pgd_t *pgd)
 {
 	/* If the pgd points to a shared pagetable level (either the
 	   ptes in non-PAE, or shared PMD in PAE), then just copy the
@@ -105,8 +117,10 @@ static void pgd_ctor(pgd_t *pgd)
 	}
 
 	/* list required to sync kernel mapping updates */
-	if (!SHARED_KERNEL_PMD)
+	if (!SHARED_KERNEL_PMD) {
+		pgd_set_mm(pgd, mm);
 		pgd_list_add(pgd);
+	}
 }
 
 static void pgd_dtor(pgd_t *pgd)
@@ -272,7 +286,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	 */
 	spin_lock_irqsave(&pgd_lock, flags);
 
-	pgd_ctor(pgd);
+	pgd_ctor(mm, pgd);
 	pgd_prepopulate_pmd(mm, pgd, pmds);
 
 	spin_unlock_irqrestore(&pgd_lock, flags);
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index c03f14a..4935848 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -5,6 +5,7 @@
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/cpu.h>
 
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
@@ -52,6 +53,8 @@ union smp_flush_state {
    want false sharing in the per cpu data segment. */
 static union smp_flush_state flush_state[NUM_INVALIDATE_TLB_VECTORS];
 
+static DEFINE_PER_CPU_READ_MOSTLY(int, tlb_vector_offset);
+
 /*
  * We cannot call mmdrop() because we are in interrupt context,
  * instead update mm->cpu_vm_mask.
@@ -173,7 +176,7 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 	union smp_flush_state *f;
 
 	/* Caller has disabled preemption */
-	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
+	sender = this_cpu_read(tlb_vector_offset);
 	f = &flush_state[sender];
 
 	/*
@@ -218,6 +221,47 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 	flush_tlb_others_ipi(cpumask, mm, va);
 }
 
+static void __cpuinit calculate_tlb_offset(void)
+{
+	int cpu, node, nr_node_vecs;
+	/*
+	 * we are changing tlb_vector_offset for each CPU in runtime, but this
+	 * will not cause inconsistency, as the write is atomic under X86. we
+	 * might see more lock contentions in a short time, but after all CPU's
+	 * tlb_vector_offset are changed, everything should go normal
+	 *
+	 * Note: if NUM_INVALIDATE_TLB_VECTORS % nr_online_nodes !=0, we might
+	 * waste some vectors.
+	 **/
+	if (nr_online_nodes > NUM_INVALIDATE_TLB_VECTORS)
+		nr_node_vecs = 1;
+	else
+		nr_node_vecs = NUM_INVALIDATE_TLB_VECTORS/nr_online_nodes;
+
+	for_each_online_node(node) {
+		int node_offset = (node % NUM_INVALIDATE_TLB_VECTORS) *
+			nr_node_vecs;
+		int cpu_offset = 0;
+		for_each_cpu(cpu, cpumask_of_node(node)) {
+			per_cpu(tlb_vector_offset, cpu) = node_offset +
+				cpu_offset;
+			cpu_offset++;
+			cpu_offset = cpu_offset % nr_node_vecs;
+		}
+	}
+}
+
+static int tlb_cpuhp_notify(struct notifier_block *n,
+		unsigned long action, void *hcpu)
+{
+	switch (action & 0xf) {
+	case CPU_ONLINE:
+	case CPU_DEAD:
+		calculate_tlb_offset();
+	}
+	return NOTIFY_OK;
+}
+
 static int __cpuinit init_smp_flush(void)
 {
 	int i;
@@ -225,6 +269,8 @@ static int __cpuinit init_smp_flush(void)
 	for (i = 0; i < ARRAY_SIZE(flush_state); i++)
 		raw_spin_lock_init(&flush_state[i].tlbstate_lock);
 
+	calculate_tlb_offset();
+	hotcpu_notifier(tlb_cpuhp_notify, 0);
 	return 0;
 }
 core_initcall(init_smp_flush);
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index e2bd73e..f4d4120 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -129,6 +129,10 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addres
 #define move_pte(pte, prot, old_addr, new_addr)	(pte)
 #endif
 
+#ifndef flush_tlb_fix_spurious_fault
+#define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
+#endif
+
 #ifndef pgprot_noncached
 #define pgprot_noncached(prot)	(prot)
 #endif
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 8a92a17..1457b81 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -677,7 +677,9 @@
 				- LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
 		*(.data..percpu..first)					\
+		. = ALIGN(PAGE_SIZE);					\
 		*(.data..percpu..page_aligned)				\
+		*(.data..percpu..readmostly)				\
 		*(.data..percpu)					\
 		*(.data..percpu..shared_aligned)			\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
@@ -703,7 +705,9 @@
 		VMLINUX_SYMBOL(__per_cpu_load) = .;			\
 		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
 		*(.data..percpu..first)					\
+		. = ALIGN(PAGE_SIZE);					\
 		*(.data..percpu..page_aligned)				\
+		*(.data..percpu..readmostly)				\
 		*(.data..percpu)					\
 		*(.data..percpu..shared_aligned)			\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index ce2dc65..27ef6b1 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -139,6 +139,15 @@
 	__aligned(PAGE_SIZE)
 
 /*
+ * Declaration/definition used for per-CPU variables that must be read mostly.
+ */
+#define DECLARE_PER_CPU_READ_MOSTLY(type, name)			\
+	DECLARE_PER_CPU_SECTION(type, name, "..readmostly")
+
+#define DEFINE_PER_CPU_READ_MOSTLY(type, name)				\
+	DEFINE_PER_CPU_SECTION(type, name, "..readmostly")
+
+/*
  * Intermodule exports for per-CPU variables.  sparse forgets about
  * address space across EXPORT_SYMBOL(), change EXPORT_SYMBOL() to
  * noop if __CHECKER__.
diff --git a/mm/memory.c b/mm/memory.c
index 2ed2267..a40da69 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3147,7 +3147,7 @@ static inline int handle_pte_fault(struct mm_struct *mm,
 		 * with threads.
 		 */
 		if (flags & FAULT_FLAG_WRITE)
-			flush_tlb_page(vma, address);
+			flush_tlb_fix_spurious_fault(vma, address);
 	}
 unlock:
 	pte_unmap_unlock(pte, ptl);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6b8889d..d8087f0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -517,6 +517,15 @@ static atomic_t vmap_lazy_nr = ATOMIC_INIT(0);
 static void purge_fragmented_blocks_allcpus(void);
 
 /*
+ * called before a call to iounmap() if the caller wants vm_area_struct's
+ * immediately freed.
+ */
+void set_iounmap_nonlazy(void)
+{
+	atomic_set(&vmap_lazy_nr, lazy_max_pages()+1);
+}
+
+/*
  * Purges all lazily-freed vmap areas.
  *
  * If sync is 0 then don't purge if there is already a purge in progress.
