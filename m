Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab0HIFE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 01:04:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26760 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab0HIFEx (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 9 Aug 2010 01:04:53 -0400
Date: Mon, 9 Aug 2010 01:03:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: [GIT PULL] Xen-SWIOTLB v0.8.6 for 2.6.36
Message-ID: <20100809050309.GA5249@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull the following git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/xen-swiotlb-0.8.6 

in your new 2.6.36 branch.

They are based on top of this git commit:e40152ee1e1c7a63f4777791863215e3faa37a86
Author: Linus Torvalds <torvalds@linux-foundation.org>

    Linus 2.6.34

They have been reviewed, acked, discussed, tested and retested and been brewing
in linux-next.

This feature adds an IOMMU that can be used by Xen PV guests when a PCI
pass-through device is utilized. The necessity of adding another IOMMU is
that PV guests under Xen are running in an non-contiguous memory
architecture. More details on this are at the end of this e-mail.

One patch touched common code:
   x86: Detect whether we should use Xen SWIOTLB.

which was contentious and the comments raised were "inserting a
sub-system call in the generic code is not good." and " we should remove
all sub-system detect calls (Calgary, AMD, Intel, AGP) altogether from
pci-dma.c and depend more on  x86_init.iommu structure (perhaps expend it?)"

We [hpa, Fujita, me] decided that the patch that sparked this
discussion would be Ack-ed for 2.6.36 and I would start working on a new 
framework to address the concerns: http://lkml.org/lkml/2010/8/2/282

The rest are Xen specific patches:

Alex Nixon (3):
      xen: Allow unprivileged Xen domains to create iomap pages
      xen: Rename the balloon lock
      xen: Add xen_create_contiguous_region

Jeremy Fitzhardinge (3):
      xen: use _PAGE_IOMAP in ioremap to do machine mappings
      vmap: add flag to allow lazy unmap to be disabled at runtime
      xen/mmu: inhibit vmap aliases rather than trying to clear them out

Konrad Rzeszutek Wilk (3):
      swiotlb-xen: SWIOTLB library for Xen PV guest with PCI passthrough.
      pci-swiotlb-xen: Add glue code to setup dma_ops utilizing xen_swiotlb_*     functions.
      x86: Detect whether we should use Xen SWIOTLB.

 arch/x86/include/asm/xen/page.h        |    8 +-
 arch/x86/include/asm/xen/swiotlb-xen.h |   14 +
 arch/x86/kernel/pci-dma.c              |    7 +-
 arch/x86/xen/Makefile                  |    1 +
 arch/x86/xen/enlighten.c               |    4 +
 arch/x86/xen/mmu.c                     |  293 ++++++++++++++++++-
 arch/x86/xen/pci-swiotlb-xen.c         |   58 ++++
 drivers/xen/Kconfig                    |    4 +
 drivers/xen/Makefile                   |    3 +-
 drivers/xen/balloon.c                  |   15 +-
 drivers/xen/swiotlb-xen.c              |  515 ++++++++++++++++++++++++++++++++
 include/linux/vmalloc.h                |    2 +
 include/xen/interface/memory.h         |   50 +++
 include/xen/swiotlb-xen.h              |   65 ++++
 include/xen/xen-ops.h                  |    6 +
 mm/vmalloc.c                           |    4 +
 16 files changed, 1024 insertions(+), 25 deletions(-)

And the lengthy explanation:

These nine patches lay the groundwork for Xen Paravirtualized (PV)
domains to access PCI pass-through devices (with and without an hardware
IOMMU) These patches utilize the SWIOTLB library modifications
(http://lkml.org/lkml/2010/6/4/272).

The end user of this are:
 - The Xen PCI frontend and Xen PCI [1] which require a DMA API "backend"
   that understands Xen's MMU. This allows the PV domains to use PCI devices.
   The use case is for machines with and without hardware IOMMU. Without an
   hardware IOMMU you have a potential security hole wherein a guest domain
   can use the hardware to map pages outside its memory range and slurp
   pages up. As such, this is more restricted to a Privileged PV domain,
   aka - device driver domain (similar to Qubes but a poor-man mechanism [2]).
 - Xen PV domain 0 support. Without this domain 0 is incapable of using any
   PCI devices.

This patch-set is split in two groups. The first alter the Xen components,
while the second introduces the SWIOTLB-Xen.

The Xen components patches consist of:

      xen: Allow unprivileged Xen domains to create iomap pages
      xen: Rename the balloon lock
      xen: Add xen_create_contiguous_region
      xen: use _PAGE_IOMAP in ioremap to do machine mappings
      vmap: add flag to allow lazy unmap to be disabled at runtime
      xen/mmu: inhibit vmap aliases rather than trying to clear them out

which alter the Xen MMU, which by default utilizes a layer of indirection
wherein the PFN is translated to the Machine Frame Number (MFN) and vice-versa.
This is required to "fool" the guest in thinking its memory starts at PFN 0 and
goes up to the available amount.  While in the background, PFN 0 might as well be
MFN 1048576 (4GB).

For PCI/DMA API calls (ioremap, pci_map_page, etc) having a PFN != MFN is
not too good, so two new mechanisms are introduced:
  a). For PTEs which manipulate the PCI/DMA pages the PFN == MFN. This is done
      via utilizing the _PAGE_IOMAP flag to distinguish the PTE as an IO type.
  b). Allow a mechanism to "swizzle" the MFN's under a PFN to be under a certain
      bus width (say 32). This allows us to provide a mechanism for the
      SWIOTLB Xen to allocate memory for its pool that will be guaranteed to be
      under the 4GB mark.

We also introduce a mechanism to inhibit vmap aliases as we need to clear the
vmap's but might be doing this in atomic state.

The SWIOTLB-Xen adds a library that is only used if the machine is detected
to be running under Xen. It utilizes the SWIOTLB library bookkeeping functions
(swiotlb_tbl_*) and only deals with the virtual to [physical, bus] (and vice-versa)
address translations.

Here is the full diff:

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 018a0a4..bf5f7d3 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -112,13 +112,9 @@ static inline xpaddr_t machine_to_phys(xmaddr_t machine)
  */
 static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
 {
-	extern unsigned long max_mapnr;
 	unsigned long pfn = mfn_to_pfn(mfn);
-	if ((pfn < max_mapnr)
-	    && !xen_feature(XENFEAT_auto_translated_physmap)
-	    && (get_phys_to_machine(pfn) != mfn))
-		return max_mapnr; /* force !pfn_valid() */
-	/* XXX fixme; not true with sparsemem */
+	if (get_phys_to_machine(pfn) != mfn)
+		return -1; /* force !pfn_valid() */
 	return pfn;
 }
 
diff --git a/arch/x86/include/asm/xen/swiotlb-xen.h b/arch/x86/include/asm/xen/swiotlb-xen.h
new file mode 100644
index 0000000..1be1ab7
--- /dev/null
+++ b/arch/x86/include/asm/xen/swiotlb-xen.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_X86_SWIOTLB_XEN_H
+#define _ASM_X86_SWIOTLB_XEN_H
+
+#ifdef CONFIG_SWIOTLB_XEN
+extern int xen_swiotlb;
+extern int __init pci_xen_swiotlb_detect(void);
+extern void __init pci_xen_swiotlb_init(void);
+#else
+#define xen_swiotlb (0)
+static inline int __init pci_xen_swiotlb_detect(void) { return 0; }
+static inline void __init pci_xen_swiotlb_init(void) { }
+#endif
+
+#endif /* _ASM_X86_SWIOTLB_XEN_H */
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 4b7e3d8..9f07cfc 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -13,6 +13,7 @@
 #include <asm/calgary.h>
 #include <asm/amd_iommu.h>
 #include <asm/x86_init.h>
+#include <asm/xen/swiotlb-xen.h>
 
 static int forbid_dac __read_mostly;
 
@@ -132,7 +133,7 @@ void __init pci_iommu_alloc(void)
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 
-	if (pci_swiotlb_detect())
+	if (pci_xen_swiotlb_detect() || pci_swiotlb_detect())
 		goto out;
 
 	gart_iommu_hole_init();
@@ -144,6 +145,8 @@ void __init pci_iommu_alloc(void)
 	/* needs to be called after gart_iommu_hole_init */
 	amd_iommu_detect();
 out:
+	pci_xen_swiotlb_init();
+
 	pci_swiotlb_init();
 }
 
@@ -296,7 +299,7 @@ static int __init pci_iommu_init(void)
 #endif
 	x86_init.iommu.iommu_init();
 
-	if (swiotlb) {
+	if (swiotlb || xen_swiotlb) {
 		printk(KERN_INFO "PCI-DMA: "
 		       "Using software bounce buffering for IO (SWIOTLB)\n");
 		swiotlb_print_info();
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3bb4fc2..32af238 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
 
+obj-$(CONFIG_SWIOTLB_XEN)	+= pci-swiotlb-xen.o
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 65d8d79..3254e8b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1145,6 +1145,10 @@ asmlinkage void __init xen_start_kernel(void)
 
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
+	if (!xen_initial_domain())
+		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
+
+	__supported_pte_mask |= _PAGE_IOMAP;
 	/* Don't do the full vcpu_info placement stuff until we have a
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 914f046..ef5728d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -42,6 +42,7 @@
 #include <linux/highmem.h>
 #include <linux/debugfs.h>
 #include <linux/bug.h>
+#include <linux/vmalloc.h>
 #include <linux/module.h>
 #include <linux/gfp.h>
 
@@ -51,14 +52,18 @@
 #include <asm/mmu_context.h>
 #include <asm/setup.h>
 #include <asm/paravirt.h>
+#include <asm/e820.h>
 #include <asm/linkage.h>
+#include <asm/page.h>
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
 
+#include <xen/xen.h>
 #include <xen/page.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/version.h>
+#include <xen/interface/memory.h>
 #include <xen/hvc-console.h>
 
 #include "multicalls.h"
@@ -67,6 +72,13 @@
 
 #define MMU_UPDATE_HISTO	30
 
+/*
+ * Protects atomic reservation decrease/increase against concurrent increases.
+ * Also protects non-atomic updates of current_pages and driver_pages, and
+ * balloon lists.
+ */
+DEFINE_SPINLOCK(xen_reservation_lock);
+
 #ifdef CONFIG_XEN_DEBUG_FS
 
 static struct {
@@ -377,6 +389,28 @@ static bool xen_page_pinned(void *ptr)
 	return PagePinned(page);
 }
 
+static bool xen_iomap_pte(pte_t pte)
+{
+	return pte_flags(pte) & _PAGE_IOMAP;
+}
+
+static void xen_set_iomap_pte(pte_t *ptep, pte_t pteval)
+{
+	struct multicall_space mcs;
+	struct mmu_update *u;
+
+	mcs = xen_mc_entry(sizeof(*u));
+	u = mcs.args;
+
+	/* ptep might be kmapped when using 32-bit HIGHPTE */
+	u->ptr = arbitrary_virt_to_machine(ptep).maddr;
+	u->val = pte_val_ma(pteval);
+
+	MULTI_mmu_update(mcs.mc, mcs.args, 1, NULL, DOMID_IO);
+
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
+}
+
 static void xen_extend_mmu_update(const struct mmu_update *update)
 {
 	struct multicall_space mcs;
@@ -453,6 +487,11 @@ void set_pte_mfn(unsigned long vaddr, unsigned long mfn, pgprot_t flags)
 void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval)
 {
+	if (xen_iomap_pte(pteval)) {
+		xen_set_iomap_pte(ptep, pteval);
+		goto out;
+	}
+
 	ADD_STATS(set_pte_at, 1);
 //	ADD_STATS(set_pte_at_pinned, xen_page_pinned(ptep));
 	ADD_STATS(set_pte_at_current, mm == current->mm);
@@ -523,8 +562,25 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
 	return val;
 }
 
+static pteval_t iomap_pte(pteval_t val)
+{
+	if (val & _PAGE_PRESENT) {
+		unsigned long pfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
+		pteval_t flags = val & PTE_FLAGS_MASK;
+
+		/* We assume the pte frame number is a MFN, so
+		   just use it as-is. */
+		val = ((pteval_t)pfn << PAGE_SHIFT) | flags;
+	}
+
+	return val;
+}
+
 pteval_t xen_pte_val(pte_t pte)
 {
+	if (xen_initial_domain() && (pte.pte & _PAGE_IOMAP))
+		return pte.pte;
+
 	return pte_mfn_to_pfn(pte.pte);
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_pte_val);
@@ -537,7 +593,22 @@ PV_CALLEE_SAVE_REGS_THUNK(xen_pgd_val);
 
 pte_t xen_make_pte(pteval_t pte)
 {
-	pte = pte_pfn_to_mfn(pte);
+	phys_addr_t addr = (pte & PTE_PFN_MASK);
+
+	/*
+	 * Unprivileged domains are allowed to do IOMAPpings for
+	 * PCI passthrough, but not map ISA space.  The ISA
+	 * mappings are just dummy local mappings to keep other
+	 * parts of the kernel happy.
+	 */
+	if (unlikely(pte & _PAGE_IOMAP) &&
+	    (xen_initial_domain() || addr >= ISA_END_ADDRESS)) {
+		pte = iomap_pte(pte);
+	} else {
+		pte &= ~_PAGE_IOMAP;
+		pte = pte_pfn_to_mfn(pte);
+	}
+
 	return native_make_pte(pte);
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pte);
@@ -593,6 +664,11 @@ void xen_set_pud(pud_t *ptr, pud_t val)
 
 void xen_set_pte(pte_t *ptep, pte_t pte)
 {
+	if (xen_iomap_pte(pte)) {
+		xen_set_iomap_pte(ptep, pte);
+		return;
+	}
+
 	ADD_STATS(pte_update, 1);
 //	ADD_STATS(pte_update_pinned, xen_page_pinned(ptep));
 	ADD_STATS(pte_update_batched, paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU);
@@ -609,6 +685,11 @@ void xen_set_pte(pte_t *ptep, pte_t pte)
 #ifdef CONFIG_X86_PAE
 void xen_set_pte_atomic(pte_t *ptep, pte_t pte)
 {
+	if (xen_iomap_pte(pte)) {
+		xen_set_iomap_pte(ptep, pte);
+		return;
+	}
+
 	set_64bit((u64 *)ptep, native_pte_val(pte));
 }
 
@@ -935,8 +1016,6 @@ static int xen_pin_page(struct mm_struct *mm, struct page *page,
    read-only, and can be pinned. */
 static void __xen_pgd_pin(struct mm_struct *mm, pgd_t *pgd)
 {
-	vm_unmap_aliases();
-
 	xen_mc_batch();
 
 	if (__xen_pgd_walk(mm, pgd, xen_pin_page, USER_LIMIT)) {
@@ -1500,7 +1579,6 @@ static void xen_alloc_ptpage(struct mm_struct *mm, unsigned long pfn, unsigned l
 	if (PagePinned(virt_to_page(mm->pgd))) {
 		SetPagePinned(page);
 
-		vm_unmap_aliases();
 		if (!PageHighMem(page)) {
 			make_lowmem_page_readonly(__va(PFN_PHYS((unsigned long)pfn)));
 			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
@@ -1811,9 +1889,16 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 		pte = pfn_pte(phys, prot);
 		break;
 
-	default:
+	case FIX_PARAVIRT_BOOTMAP:
+		/* This is an MFN, but it isn't an IO mapping from the
+		   IO domain */
 		pte = mfn_pte(phys, prot);
 		break;
+
+	default:
+		/* By default, set_fixmap is used for hardware mappings */
+		pte = mfn_pte(phys, __pgprot(pgprot_val(prot) | _PAGE_IOMAP));
+		break;
 	}
 
 	__native_set_fixmap(idx, pte);
@@ -1939,7 +2024,205 @@ void __init xen_init_mmu_ops(void)
 	x86_init.paging.pagetable_setup_start = xen_pagetable_setup_start;
 	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
 	pv_mmu_ops = xen_mmu_ops;
+
+	vmap_lazy_unmap = false;
+}
+
+/* Protected by xen_reservation_lock. */
+#define MAX_CONTIG_ORDER 9 /* 2MB */
+static unsigned long discontig_frames[1<<MAX_CONTIG_ORDER];
+
+#define VOID_PTE (mfn_pte(0, __pgprot(0)))
+static void xen_zap_pfn_range(unsigned long vaddr, unsigned int order,
+				unsigned long *in_frames,
+				unsigned long *out_frames)
+{
+	int i;
+	struct multicall_space mcs;
+
+	xen_mc_batch();
+	for (i = 0; i < (1UL<<order); i++, vaddr += PAGE_SIZE) {
+		mcs = __xen_mc_entry(0);
+
+		if (in_frames)
+			in_frames[i] = virt_to_mfn(vaddr);
+
+		MULTI_update_va_mapping(mcs.mc, vaddr, VOID_PTE, 0);
+		set_phys_to_machine(virt_to_pfn(vaddr), INVALID_P2M_ENTRY);
+
+		if (out_frames)
+			out_frames[i] = virt_to_pfn(vaddr);
+	}
+	xen_mc_issue(0);
+}
+
+/*
+ * Update the pfn-to-mfn mappings for a virtual address range, either to
+ * point to an array of mfns, or contiguously from a single starting
+ * mfn.
+ */
+static void xen_remap_exchanged_ptes(unsigned long vaddr, int order,
+				     unsigned long *mfns,
+				     unsigned long first_mfn)
+{
+	unsigned i, limit;
+	unsigned long mfn;
+
+	xen_mc_batch();
+
+	limit = 1u << order;
+	for (i = 0; i < limit; i++, vaddr += PAGE_SIZE) {
+		struct multicall_space mcs;
+		unsigned flags;
+
+		mcs = __xen_mc_entry(0);
+		if (mfns)
+			mfn = mfns[i];
+		else
+			mfn = first_mfn + i;
+
+		if (i < (limit - 1))
+			flags = 0;
+		else {
+			if (order == 0)
+				flags = UVMF_INVLPG | UVMF_ALL;
+			else
+				flags = UVMF_TLB_FLUSH | UVMF_ALL;
+		}
+
+		MULTI_update_va_mapping(mcs.mc, vaddr,
+				mfn_pte(mfn, PAGE_KERNEL), flags);
+
+		set_phys_to_machine(virt_to_pfn(vaddr), mfn);
+	}
+
+	xen_mc_issue(0);
+}
+
+/*
+ * Perform the hypercall to exchange a region of our pfns to point to
+ * memory with the required contiguous alignment.  Takes the pfns as
+ * input, and populates mfns as output.
+ *
+ * Returns a success code indicating whether the hypervisor was able to
+ * satisfy the request or not.
+ */
+static int xen_exchange_memory(unsigned long extents_in, unsigned int order_in,
+			       unsigned long *pfns_in,
+			       unsigned long extents_out,
+			       unsigned int order_out,
+			       unsigned long *mfns_out,
+			       unsigned int address_bits)
+{
+	long rc;
+	int success;
+
+	struct xen_memory_exchange exchange = {
+		.in = {
+			.nr_extents   = extents_in,
+			.extent_order = order_in,
+			.extent_start = pfns_in,
+			.domid        = DOMID_SELF
+		},
+		.out = {
+			.nr_extents   = extents_out,
+			.extent_order = order_out,
+			.extent_start = mfns_out,
+			.address_bits = address_bits,
+			.domid        = DOMID_SELF
+		}
+	};
+
+	BUG_ON(extents_in << order_in != extents_out << order_out);
+
+	rc = HYPERVISOR_memory_op(XENMEM_exchange, &exchange);
+	success = (exchange.nr_exchanged == extents_in);
+
+	BUG_ON(!success && ((exchange.nr_exchanged != 0) || (rc == 0)));
+	BUG_ON(success && (rc != 0));
+
+	return success;
+}
+
+int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
+				 unsigned int address_bits)
+{
+	unsigned long *in_frames = discontig_frames, out_frame;
+	unsigned long  flags;
+	int            success;
+
+	/*
+	 * Currently an auto-translated guest will not perform I/O, nor will
+	 * it require PAE page directories below 4GB. Therefore any calls to
+	 * this function are redundant and can be ignored.
+	 */
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return 0;
+
+	if (unlikely(order > MAX_CONTIG_ORDER))
+		return -ENOMEM;
+
+	memset((void *) vstart, 0, PAGE_SIZE << order);
+
+	spin_lock_irqsave(&xen_reservation_lock, flags);
+
+	/* 1. Zap current PTEs, remembering MFNs. */
+	xen_zap_pfn_range(vstart, order, in_frames, NULL);
+
+	/* 2. Get a new contiguous memory extent. */
+	out_frame = virt_to_pfn(vstart);
+	success = xen_exchange_memory(1UL << order, 0, in_frames,
+				      1, order, &out_frame,
+				      address_bits);
+
+	/* 3. Map the new extent in place of old pages. */
+	if (success)
+		xen_remap_exchanged_ptes(vstart, order, NULL, out_frame);
+	else
+		xen_remap_exchanged_ptes(vstart, order, in_frames, 0);
+
+	spin_unlock_irqrestore(&xen_reservation_lock, flags);
+
+	return success ? 0 : -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(xen_create_contiguous_region);
+
+void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order)
+{
+	unsigned long *out_frames = discontig_frames, in_frame;
+	unsigned long  flags;
+	int success;
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
+
+	if (unlikely(order > MAX_CONTIG_ORDER))
+		return;
+
+	memset((void *) vstart, 0, PAGE_SIZE << order);
+
+	spin_lock_irqsave(&xen_reservation_lock, flags);
+
+	/* 1. Find start MFN of contiguous extent. */
+	in_frame = virt_to_mfn(vstart);
+
+	/* 2. Zap current PTEs. */
+	xen_zap_pfn_range(vstart, order, NULL, out_frames);
+
+	/* 3. Do the exchange for non-contiguous MFNs. */
+	success = xen_exchange_memory(1, order, &in_frame, 1UL << order,
+					0, out_frames, 0);
+
+	/* 4. Map new pages in place of old pages. */
+	if (success)
+		xen_remap_exchanged_ptes(vstart, order, out_frames, 0);
+	else
+		xen_remap_exchanged_ptes(vstart, order, NULL, in_frame);
+
+	spin_unlock_irqrestore(&xen_reservation_lock, flags);
 }
+EXPORT_SYMBOL_GPL(xen_destroy_contiguous_region);
 
 #ifdef CONFIG_XEN_DEBUG_FS
 
diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
new file mode 100644
index 0000000..a013ec9
--- /dev/null
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -0,0 +1,58 @@
+/* Glue code to lib/swiotlb-xen.c */
+
+#include <linux/dma-mapping.h>
+#include <xen/swiotlb-xen.h>
+
+#include <asm/xen/hypervisor.h>
+#include <xen/xen.h>
+
+int xen_swiotlb __read_mostly;
+
+static struct dma_map_ops xen_swiotlb_dma_ops = {
+	.mapping_error = xen_swiotlb_dma_mapping_error,
+	.alloc_coherent = xen_swiotlb_alloc_coherent,
+	.free_coherent = xen_swiotlb_free_coherent,
+	.sync_single_for_cpu = xen_swiotlb_sync_single_for_cpu,
+	.sync_single_for_device = xen_swiotlb_sync_single_for_device,
+	.sync_sg_for_cpu = xen_swiotlb_sync_sg_for_cpu,
+	.sync_sg_for_device = xen_swiotlb_sync_sg_for_device,
+	.map_sg = xen_swiotlb_map_sg_attrs,
+	.unmap_sg = xen_swiotlb_unmap_sg_attrs,
+	.map_page = xen_swiotlb_map_page,
+	.unmap_page = xen_swiotlb_unmap_page,
+	.dma_supported = xen_swiotlb_dma_supported,
+};
+
+/*
+ * pci_xen_swiotlb_detect - set xen_swiotlb to 1 if necessary
+ *
+ * This returns non-zero if we are forced to use xen_swiotlb (by the boot
+ * option).
+ */
+int __init pci_xen_swiotlb_detect(void)
+{
+
+	/* If running as PV guest, either iommu=soft, or swiotlb=force will
+	 * activate this IOMMU. If running as PV privileged, activate it
+	 * irregardlesss.
+	 */
+	if ((xen_initial_domain() || swiotlb || swiotlb_force) &&
+	    (xen_pv_domain()))
+		xen_swiotlb = 1;
+
+	/* If we are running under Xen, we MUST disable the native SWIOTLB.
+	 * Don't worry about swiotlb_force flag activating the native, as
+	 * the 'swiotlb' flag is the only one turning it on. */
+	if (xen_pv_domain())
+		swiotlb = 0;
+
+	return xen_swiotlb;
+}
+
+void __init pci_xen_swiotlb_init(void)
+{
+	if (xen_swiotlb) {
+		xen_swiotlb_init(1);
+		dma_ops = &xen_swiotlb_dma_ops;
+	}
+}
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index fad3df2..97199c2 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -62,4 +62,8 @@ config XEN_SYS_HYPERVISOR
 	 virtual environment, /sys/hypervisor will still be present,
 	 but will have no xen contents.
 
+config SWIOTLB_XEN
+	def_bool y
+	depends on SWIOTLB
+
 endmenu
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 7c28434..85f84cf 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
 obj-$(CONFIG_XEN_DEV_EVTCHN)	+= evtchn.o
 obj-$(CONFIG_XENFS)		+= xenfs/
-obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
\ No newline at end of file
+obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
+obj-$(CONFIG_SWIOTLB_XEN)	+= swiotlb-xen.o
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 1a0d8c2..500290b 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -85,13 +85,6 @@ static struct sys_device balloon_sysdev;
 
 static int register_balloon(struct sys_device *sysdev);
 
-/*
- * Protects atomic reservation decrease/increase against concurrent increases.
- * Also protects non-atomic updates of current_pages and driver_pages, and
- * balloon lists.
- */
-static DEFINE_SPINLOCK(balloon_lock);
-
 static struct balloon_stats balloon_stats;
 
 /* We increase/decrease in batches which fit in a page */
@@ -210,7 +203,7 @@ static int increase_reservation(unsigned long nr_pages)
 	if (nr_pages > ARRAY_SIZE(frame_list))
 		nr_pages = ARRAY_SIZE(frame_list);
 
-	spin_lock_irqsave(&balloon_lock, flags);
+	spin_lock_irqsave(&xen_reservation_lock, flags);
 
 	page = balloon_first_page();
 	for (i = 0; i < nr_pages; i++) {
@@ -254,7 +247,7 @@ static int increase_reservation(unsigned long nr_pages)
 	balloon_stats.current_pages += rc;
 
  out:
-	spin_unlock_irqrestore(&balloon_lock, flags);
+	spin_unlock_irqrestore(&xen_reservation_lock, flags);
 
 	return rc < 0 ? rc : rc != nr_pages;
 }
@@ -299,7 +292,7 @@ static int decrease_reservation(unsigned long nr_pages)
 	kmap_flush_unused();
 	flush_tlb_all();
 
-	spin_lock_irqsave(&balloon_lock, flags);
+	spin_lock_irqsave(&xen_reservation_lock, flags);
 
 	/* No more mappings: invalidate P2M and add to balloon. */
 	for (i = 0; i < nr_pages; i++) {
@@ -315,7 +308,7 @@ static int decrease_reservation(unsigned long nr_pages)
 
 	balloon_stats.current_pages -= nr_pages;
 
-	spin_unlock_irqrestore(&balloon_lock, flags);
+	spin_unlock_irqrestore(&xen_reservation_lock, flags);
 
 	return need_sleep;
 }
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
new file mode 100644
index 0000000..54469c3
--- /dev/null
+++ b/drivers/xen/swiotlb-xen.c
@@ -0,0 +1,515 @@
+/*
+ *  Copyright 2010
+ *  by Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+ *
+ * This code provides a IOMMU for Xen PV guests with PCI passthrough.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License v2.0 as published by
+ * the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * PV guests under Xen are running in an non-contiguous memory architecture.
+ *
+ * When PCI pass-through is utilized, this necessitates an IOMMU for
+ * translating bus (DMA) to virtual and vice-versa and also providing a
+ * mechanism to have contiguous pages for device drivers operations (say DMA
+ * operations).
+ *
+ * Specifically, under Xen the Linux idea of pages is an illusion. It
+ * assumes that pages start at zero and go up to the available memory. To
+ * help with that, the Linux Xen MMU provides a lookup mechanism to
+ * translate the page frame numbers (PFN) to machine frame numbers (MFN)
+ * and vice-versa. The MFN are the "real" frame numbers. Furthermore
+ * memory is not contiguous. Xen hypervisor stitches memory for guests
+ * from different pools, which means there is no guarantee that PFN==MFN
+ * and PFN+1==MFN+1. Lastly with Xen 4.0, pages (in debug mode) are
+ * allocated in descending order (high to low), meaning the guest might
+ * never get any MFN's under the 4GB mark.
+ *
+ */
+
+#include <linux/bootmem.h>
+#include <linux/dma-mapping.h>
+#include <xen/swiotlb-xen.h>
+#include <xen/page.h>
+#include <xen/xen-ops.h>
+/*
+ * Used to do a quick range check in swiotlb_tbl_unmap_single and
+ * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
+ * API.
+ */
+
+static char *xen_io_tlb_start, *xen_io_tlb_end;
+static unsigned long xen_io_tlb_nslabs;
+/*
+ * Quick lookup value of the bus address of the IOTLB.
+ */
+
+u64 start_dma_addr;
+
+static dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
+{
+	return phys_to_machine(XPADDR(paddr)).maddr;;
+}
+
+static phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
+{
+	return machine_to_phys(XMADDR(baddr)).paddr;
+}
+
+static dma_addr_t xen_virt_to_bus(void *address)
+{
+	return xen_phys_to_bus(virt_to_phys(address));
+}
+
+static int check_pages_physically_contiguous(unsigned long pfn,
+					     unsigned int offset,
+					     size_t length)
+{
+	unsigned long next_mfn;
+	int i;
+	int nr_pages;
+
+	next_mfn = pfn_to_mfn(pfn);
+	nr_pages = (offset + length + PAGE_SIZE-1) >> PAGE_SHIFT;
+
+	for (i = 1; i < nr_pages; i++) {
+		if (pfn_to_mfn(++pfn) != ++next_mfn)
+			return 0;
+	}
+	return 1;
+}
+
+static int range_straddles_page_boundary(phys_addr_t p, size_t size)
+{
+	unsigned long pfn = PFN_DOWN(p);
+	unsigned int offset = p & ~PAGE_MASK;
+
+	if (offset + size <= PAGE_SIZE)
+		return 0;
+	if (check_pages_physically_contiguous(pfn, offset, size))
+		return 0;
+	return 1;
+}
+
+static int is_xen_swiotlb_buffer(dma_addr_t dma_addr)
+{
+	unsigned long mfn = PFN_DOWN(dma_addr);
+	unsigned long pfn = mfn_to_local_pfn(mfn);
+	phys_addr_t paddr;
+
+	/* If the address is outside our domain, it CAN
+	 * have the same virtual address as another address
+	 * in our domain. Therefore _only_ check address within our domain.
+	 */
+	if (pfn_valid(pfn)) {
+		paddr = PFN_PHYS(pfn);
+		return paddr >= virt_to_phys(xen_io_tlb_start) &&
+		       paddr < virt_to_phys(xen_io_tlb_end);
+	}
+	return 0;
+}
+
+static int max_dma_bits = 32;
+
+static int
+xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
+{
+	int i, rc;
+	int dma_bits;
+
+	dma_bits = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT) + PAGE_SHIFT;
+
+	i = 0;
+	do {
+		int slabs = min(nslabs - i, (unsigned long)IO_TLB_SEGSIZE);
+
+		do {
+			rc = xen_create_contiguous_region(
+				(unsigned long)buf + (i << IO_TLB_SHIFT),
+				get_order(slabs << IO_TLB_SHIFT),
+				dma_bits);
+		} while (rc && dma_bits++ < max_dma_bits);
+		if (rc)
+			return rc;
+
+		i += slabs;
+	} while (i < nslabs);
+	return 0;
+}
+
+void __init xen_swiotlb_init(int verbose)
+{
+	unsigned long bytes;
+	int rc;
+
+	xen_io_tlb_nslabs = (64 * 1024 * 1024 >> IO_TLB_SHIFT);
+	xen_io_tlb_nslabs = ALIGN(xen_io_tlb_nslabs, IO_TLB_SEGSIZE);
+
+	bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
+
+	/*
+	 * Get IO TLB memory from any location.
+	 */
+	xen_io_tlb_start = alloc_bootmem(bytes);
+	if (!xen_io_tlb_start)
+		panic("Cannot allocate SWIOTLB buffer");
+
+	xen_io_tlb_end = xen_io_tlb_start + bytes;
+	/*
+	 * And replace that memory with pages under 4GB.
+	 */
+	rc = xen_swiotlb_fixup(xen_io_tlb_start,
+			       bytes,
+			       xen_io_tlb_nslabs);
+	if (rc)
+		goto error;
+
+	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
+	swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, verbose);
+
+	return;
+error:
+	panic("DMA(%d): Failed to exchange pages allocated for DMA with Xen! "\
+	      "We either don't have the permission or you do not have enough"\
+	      "free memory under 4GB!\n", rc);
+}
+
+void *
+xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
+			   dma_addr_t *dma_handle, gfp_t flags)
+{
+	void *ret;
+	int order = get_order(size);
+	u64 dma_mask = DMA_BIT_MASK(32);
+	unsigned long vstart;
+
+	/*
+	* Ignore region specifiers - the kernel's ideas of
+	* pseudo-phys memory layout has nothing to do with the
+	* machine physical layout.  We can't allocate highmem
+	* because we can't return a pointer to it.
+	*/
+	flags &= ~(__GFP_DMA | __GFP_HIGHMEM);
+
+	if (dma_alloc_from_coherent(hwdev, size, dma_handle, &ret))
+		return ret;
+
+	vstart = __get_free_pages(flags, order);
+	ret = (void *)vstart;
+
+	if (hwdev && hwdev->coherent_dma_mask)
+		dma_mask = dma_alloc_coherent_mask(hwdev, flags);
+
+	if (ret) {
+		if (xen_create_contiguous_region(vstart, order,
+						 fls64(dma_mask)) != 0) {
+			free_pages(vstart, order);
+			return NULL;
+		}
+		memset(ret, 0, size);
+		*dma_handle = virt_to_machine(ret).maddr;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_alloc_coherent);
+
+void
+xen_swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
+			  dma_addr_t dev_addr)
+{
+	int order = get_order(size);
+
+	if (dma_release_from_coherent(hwdev, order, vaddr))
+		return;
+
+	xen_destroy_contiguous_region((unsigned long)vaddr, order);
+	free_pages((unsigned long)vaddr, order);
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_free_coherent);
+
+
+/*
+ * Map a single buffer of the indicated size for DMA in streaming mode.  The
+ * physical address to use is returned.
+ *
+ * Once the device is given the dma address, the device owns this memory until
+ * either xen_swiotlb_unmap_page or xen_swiotlb_dma_sync_single is performed.
+ */
+dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
+				unsigned long offset, size_t size,
+				enum dma_data_direction dir,
+				struct dma_attrs *attrs)
+{
+	phys_addr_t phys = page_to_phys(page) + offset;
+	dma_addr_t dev_addr = xen_phys_to_bus(phys);
+	void *map;
+
+	BUG_ON(dir == DMA_NONE);
+	/*
+	 * If the address happens to be in the device's DMA window,
+	 * we can safely return the device addr and not worry about bounce
+	 * buffering it.
+	 */
+	if (dma_capable(dev, dev_addr, size) &&
+	    !range_straddles_page_boundary(phys, size) && !swiotlb_force)
+		return dev_addr;
+
+	/*
+	 * Oh well, have to allocate and map a bounce buffer.
+	 */
+	map = swiotlb_tbl_map_single(dev, start_dma_addr, phys, size, dir);
+	if (!map)
+		return DMA_ERROR_CODE;
+
+	dev_addr = xen_virt_to_bus(map);
+
+	/*
+	 * Ensure that the address returned is DMA'ble
+	 */
+	if (!dma_capable(dev, dev_addr, size))
+		panic("map_single: bounce buffer is not DMA'ble");
+
+	return dev_addr;
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_map_page);
+
+/*
+ * Unmap a single streaming mode DMA translation.  The dma_addr and size must
+ * match what was provided for in a previous xen_swiotlb_map_page call.  All
+ * other usages are undefined.
+ *
+ * After this call, reads by the cpu to the buffer are guaranteed to see
+ * whatever the device wrote there.
+ */
+static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
+			     size_t size, enum dma_data_direction dir)
+{
+	phys_addr_t paddr = xen_bus_to_phys(dev_addr);
+
+	BUG_ON(dir == DMA_NONE);
+
+	/* NOTE: We use dev_addr here, not paddr! */
+	if (is_xen_swiotlb_buffer(dev_addr)) {
+		swiotlb_tbl_unmap_single(hwdev, phys_to_virt(paddr), size, dir);
+		return;
+	}
+
+	if (dir != DMA_FROM_DEVICE)
+		return;
+
+	/*
+	 * phys_to_virt doesn't work with hihgmem page but we could
+	 * call dma_mark_clean() with hihgmem page here. However, we
+	 * are fine since dma_mark_clean() is null on POWERPC. We can
+	 * make dma_mark_clean() take a physical address if necessary.
+	 */
+	dma_mark_clean(phys_to_virt(paddr), size);
+}
+
+void xen_swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
+			    size_t size, enum dma_data_direction dir,
+			    struct dma_attrs *attrs)
+{
+	xen_unmap_single(hwdev, dev_addr, size, dir);
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_unmap_page);
+
+/*
+ * Make physical memory consistent for a single streaming mode DMA translation
+ * after a transfer.
+ *
+ * If you perform a xen_swiotlb_map_page() but wish to interrogate the buffer
+ * using the cpu, yet do not wish to teardown the dma mapping, you must
+ * call this function before doing so.  At the next point you give the dma
+ * address back to the card, you must first perform a
+ * xen_swiotlb_dma_sync_for_device, and then the device again owns the buffer
+ */
+static void
+xen_swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
+			size_t size, enum dma_data_direction dir,
+			enum dma_sync_target target)
+{
+	phys_addr_t paddr = xen_bus_to_phys(dev_addr);
+
+	BUG_ON(dir == DMA_NONE);
+
+	/* NOTE: We use dev_addr here, not paddr! */
+	if (is_xen_swiotlb_buffer(dev_addr)) {
+		swiotlb_tbl_sync_single(hwdev, phys_to_virt(paddr), size, dir,
+				       target);
+		return;
+	}
+
+	if (dir != DMA_FROM_DEVICE)
+		return;
+
+	dma_mark_clean(phys_to_virt(paddr), size);
+}
+
+void
+xen_swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
+				size_t size, enum dma_data_direction dir)
+{
+	xen_swiotlb_sync_single(hwdev, dev_addr, size, dir, SYNC_FOR_CPU);
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_sync_single_for_cpu);
+
+void
+xen_swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
+				   size_t size, enum dma_data_direction dir)
+{
+	xen_swiotlb_sync_single(hwdev, dev_addr, size, dir, SYNC_FOR_DEVICE);
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_sync_single_for_device);
+
+/*
+ * Map a set of buffers described by scatterlist in streaming mode for DMA.
+ * This is the scatter-gather version of the above xen_swiotlb_map_page
+ * interface.  Here the scatter gather list elements are each tagged with the
+ * appropriate dma address and length.  They are obtained via
+ * sg_dma_{address,length}(SG).
+ *
+ * NOTE: An implementation may be able to use a smaller number of
+ *       DMA address/length pairs than there are SG table elements.
+ *       (for example via virtual mapping capabilities)
+ *       The routine returns the number of addr/length pairs actually
+ *       used, at most nents.
+ *
+ * Device ownership issues as mentioned above for xen_swiotlb_map_page are the
+ * same here.
+ */
+int
+xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
+			 int nelems, enum dma_data_direction dir,
+			 struct dma_attrs *attrs)
+{
+	struct scatterlist *sg;
+	int i;
+
+	BUG_ON(dir == DMA_NONE);
+
+	for_each_sg(sgl, sg, nelems, i) {
+		phys_addr_t paddr = sg_phys(sg);
+		dma_addr_t dev_addr = xen_phys_to_bus(paddr);
+
+		if (swiotlb_force ||
+		    !dma_capable(hwdev, dev_addr, sg->length) ||
+		    range_straddles_page_boundary(paddr, sg->length)) {
+			void *map = swiotlb_tbl_map_single(hwdev,
+							   start_dma_addr,
+							   sg_phys(sg),
+							   sg->length, dir);
+			if (!map) {
+				/* Don't panic here, we expect map_sg users
+				   to do proper error handling. */
+				xen_swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
+							   attrs);
+				sgl[0].dma_length = 0;
+				return DMA_ERROR_CODE;
+			}
+			sg->dma_address = xen_virt_to_bus(map);
+		} else
+			sg->dma_address = dev_addr;
+		sg->dma_length = sg->length;
+	}
+	return nelems;
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_map_sg_attrs);
+
+int
+xen_swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
+		   enum dma_data_direction dir)
+{
+	return xen_swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, NULL);
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_map_sg);
+
+/*
+ * Unmap a set of streaming mode DMA translations.  Again, cpu read rules
+ * concerning calls here are the same as for swiotlb_unmap_page() above.
+ */
+void
+xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
+			   int nelems, enum dma_data_direction dir,
+			   struct dma_attrs *attrs)
+{
+	struct scatterlist *sg;
+	int i;
+
+	BUG_ON(dir == DMA_NONE);
+
+	for_each_sg(sgl, sg, nelems, i)
+		xen_unmap_single(hwdev, sg->dma_address, sg->dma_length, dir);
+
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_unmap_sg_attrs);
+
+void
+xen_swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
+		     enum dma_data_direction dir)
+{
+	return xen_swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_unmap_sg);
+
+/*
+ * Make physical memory consistent for a set of streaming mode DMA translations
+ * after a transfer.
+ *
+ * The same as swiotlb_sync_single_* but for a scatter-gather list, same rules
+ * and usage.
+ */
+static void
+xen_swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
+		    int nelems, enum dma_data_direction dir,
+		    enum dma_sync_target target)
+{
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(sgl, sg, nelems, i)
+		xen_swiotlb_sync_single(hwdev, sg->dma_address,
+					sg->dma_length, dir, target);
+}
+
+void
+xen_swiotlb_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
+			    int nelems, enum dma_data_direction dir)
+{
+	xen_swiotlb_sync_sg(hwdev, sg, nelems, dir, SYNC_FOR_CPU);
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_sync_sg_for_cpu);
+
+void
+xen_swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
+			       int nelems, enum dma_data_direction dir)
+{
+	xen_swiotlb_sync_sg(hwdev, sg, nelems, dir, SYNC_FOR_DEVICE);
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_sync_sg_for_device);
+
+int
+xen_swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
+{
+	return !dma_addr;
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_dma_mapping_error);
+
+/*
+ * Return whether the given device DMA address mask can be supported
+ * properly.  For example, if your device can only drive the low 24-bits
+ * during bus mastering, then you would pass 0x00ffffff as the mask to
+ * this function.
+ */
+int
+xen_swiotlb_dma_supported(struct device *hwdev, u64 mask)
+{
+	return xen_virt_to_bus(xen_io_tlb_end - 1) <= mask;
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_dma_supported);
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 227c2a5..b840fda 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -7,6 +7,8 @@
 
 struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 
+extern bool vmap_lazy_unmap;
+
 /* bits in flags of vmalloc's vm_struct below */
 #define VM_IOREMAP	0x00000001	/* ioremap() and friends */
 #define VM_ALLOC	0x00000002	/* vmalloc() */
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index af36ead..d3938d3 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -9,6 +9,8 @@
 #ifndef __XEN_PUBLIC_MEMORY_H__
 #define __XEN_PUBLIC_MEMORY_H__
 
+#include <linux/spinlock.h>
+
 /*
  * Increase or decrease the specified domain's memory reservation. Returns a
  * -ve errcode on failure, or the # extents successfully allocated or freed.
@@ -53,6 +55,48 @@ struct xen_memory_reservation {
 DEFINE_GUEST_HANDLE_STRUCT(xen_memory_reservation);
 
 /*
+ * An atomic exchange of memory pages. If return code is zero then
+ * @out.extent_list provides GMFNs of the newly-allocated memory.
+ * Returns zero on complete success, otherwise a negative error code.
+ * On complete success then always @nr_exchanged == @in.nr_extents.
+ * On partial success @nr_exchanged indicates how much work was done.
+ */
+#define XENMEM_exchange             11
+struct xen_memory_exchange {
+    /*
+     * [IN] Details of memory extents to be exchanged (GMFN bases).
+     * Note that @in.address_bits is ignored and unused.
+     */
+    struct xen_memory_reservation in;
+
+    /*
+     * [IN/OUT] Details of new memory extents.
+     * We require that:
+     *  1. @in.domid == @out.domid
+     *  2. @in.nr_extents  << @in.extent_order ==
+     *     @out.nr_extents << @out.extent_order
+     *  3. @in.extent_start and @out.extent_start lists must not overlap
+     *  4. @out.extent_start lists GPFN bases to be populated
+     *  5. @out.extent_start is overwritten with allocated GMFN bases
+     */
+    struct xen_memory_reservation out;
+
+    /*
+     * [OUT] Number of input extents that were successfully exchanged:
+     *  1. The first @nr_exchanged input extents were successfully
+     *     deallocated.
+     *  2. The corresponding first entries in the output extent list correctly
+     *     indicate the GMFNs that were successfully exchanged.
+     *  3. All other input and output extents are untouched.
+     *  4. If not all input exents are exchanged then the return code of this
+     *     command will be non-zero.
+     *  5. THIS FIELD MUST BE INITIALISED TO ZERO BY THE CALLER!
+     */
+    unsigned long nr_exchanged;
+};
+
+DEFINE_GUEST_HANDLE_STRUCT(xen_memory_exchange);
+/*
  * Returns the maximum machine frame number of mapped RAM in this system.
  * This command always succeeds (it never returns an error code).
  * arg == NULL.
@@ -142,4 +186,10 @@ struct xen_translate_gpfn_list {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_translate_gpfn_list);
 
+
+/*
+ * Prevent the balloon driver from changing the memory reservation
+ * during a driver critical region.
+ */
+extern spinlock_t xen_reservation_lock;
 #endif /* __XEN_PUBLIC_MEMORY_H__ */
diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
new file mode 100644
index 0000000..2ea2fdc
--- /dev/null
+++ b/include/xen/swiotlb-xen.h
@@ -0,0 +1,65 @@
+#ifndef __LINUX_SWIOTLB_XEN_H
+#define __LINUX_SWIOTLB_XEN_H
+
+#include <linux/swiotlb.h>
+
+extern void xen_swiotlb_init(int verbose);
+
+extern void
+*xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
+			    dma_addr_t *dma_handle, gfp_t flags);
+
+extern void
+xen_swiotlb_free_coherent(struct device *hwdev, size_t size,
+			  void *vaddr, dma_addr_t dma_handle);
+
+extern dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
+				       unsigned long offset, size_t size,
+				       enum dma_data_direction dir,
+				       struct dma_attrs *attrs);
+
+extern void xen_swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
+				   size_t size, enum dma_data_direction dir,
+				   struct dma_attrs *attrs);
+/*
+extern int
+xen_swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nents,
+		   enum dma_data_direction dir);
+
+extern void
+xen_swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
+		     enum dma_data_direction dir);
+*/
+extern int
+xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
+			 int nelems, enum dma_data_direction dir,
+			 struct dma_attrs *attrs);
+
+extern void
+xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
+			   int nelems, enum dma_data_direction dir,
+			   struct dma_attrs *attrs);
+
+extern void
+xen_swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
+				size_t size, enum dma_data_direction dir);
+
+extern void
+xen_swiotlb_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
+			    int nelems, enum dma_data_direction dir);
+
+extern void
+xen_swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
+				   size_t size, enum dma_data_direction dir);
+
+extern void
+xen_swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
+			       int nelems, enum dma_data_direction dir);
+
+extern int
+xen_swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
+
+extern int
+xen_swiotlb_dma_supported(struct device *hwdev, u64 mask);
+
+#endif /* __LINUX_SWIOTLB_XEN_H */
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 883a21b..d789c93 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -14,4 +14,10 @@ void xen_mm_unpin_all(void);
 void xen_timer_resume(void);
 void xen_arch_resume(void);
 
+extern unsigned long *xen_contiguous_bitmap;
+int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
+				unsigned int address_bits);
+
+void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order);
+
 #endif /* INCLUDE_XEN_OPS_H */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ae00746..7f35fe2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -31,6 +31,7 @@
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 
+bool vmap_lazy_unmap __read_mostly = true;
 
 /*** Page table manipulation functions ***/
 
@@ -502,6 +503,9 @@ static unsigned long lazy_max_pages(void)
 {
 	unsigned int log;
 
+	if (!vmap_lazy_unmap)
+		return 0;
+
 	log = fls(num_online_cpus());
 
 	return log * (32UL * 1024 * 1024 / PAGE_SIZE);
