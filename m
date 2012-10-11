Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab2JKV6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 17:58:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26885 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759246Ab2JKV6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 17:58:23 -0400
Date: Thu, 11 Oct 2012 14:58:17 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 3/7]: PVH:  mmu related changes.
Message-ID: <20121011145817.0d744c99@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PVH: This patch implements mmu changes for PVH. First the set/clear
mmio pte function makes a hypercall to update the p2m in xen with 1:1
mapping. PVH uses mostly native mmu ops. Two local functions are
introduced to add to xen physmap for xen remap interface. xen unmap
interface is introduced so the privcmd pte entries can be cleared in
xen p2m table.

Signed-off-by: Mukesh R <mukesh.rathor@oracle.com>
---
 arch/x86/xen/mmu.c    |  172 ++++++++++++++++++++++++++++++++++++++++++++++---
 arch/x86/xen/mmu.h    |    2 +
 drivers/xen/privcmd.c |    5 +-
 include/xen/xen-ops.h |    4 +-
 4 files changed, 171 insertions(+), 12 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5a16824..12b56a0 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -73,6 +73,7 @@
 #include <xen/interface/version.h>
 #include <xen/interface/memory.h>
 #include <xen/hvc-console.h>
+#include <xen/balloon.h>
 
 #include "multicalls.h"
 #include "mmu.h"
@@ -331,6 +332,20 @@ static void xen_set_pte(pte_t *ptep, pte_t pteval)
 	__xen_set_pte(ptep, pteval);
 }
 
+void xen_set_clr_mmio_pvh_pte(unsigned long pfn, unsigned long mfn,
+			      int nr_mfns, int add_mapping)
+{
+	struct physdev_map_iomem iomem;
+
+	iomem.first_gfn = pfn;
+	iomem.first_mfn = mfn;
+	iomem.nr_mfns = nr_mfns;
+	iomem.add_mapping = add_mapping;
+
+	if (HYPERVISOR_physdev_op(PHYSDEVOP_pvh_map_iomem, &iomem))
+		BUG();
+}
+
 static void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval)
 {
@@ -1220,6 +1235,8 @@ static void __init xen_pagetable_init(void)
 #endif
 	paging_init();
 	xen_setup_shared_info();
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
 #ifdef CONFIG_X86_64
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
 		unsigned long new_mfn_list;
@@ -1527,6 +1544,10 @@ static void __init xen_set_pte_init(pte_t *ptep, pte_t pte)
 static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
 {
 	struct mmuext_op op;
+
+	if (xen_feature(XENFEAT_writable_page_tables))
+		return;
+
 	op.cmd = cmd;
 	op.arg1.mfn = pfn_to_mfn(pfn);
 	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
@@ -1724,6 +1745,10 @@ static void set_page_prot(void *addr, pgprot_t prot)
 	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
 	pte_t pte = pfn_pte(pfn, prot);
 
+	/* recall for PVH, page tables are native. */
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
+
 	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, 0))
 		BUG();
 }
@@ -1801,6 +1826,9 @@ static void convert_pfn_mfn(void *v)
 	pte_t *pte = v;
 	int i;
 
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
+
 	/* All levels are converted the same way, so just treat them
 	   as ptes. */
 	for (i = 0; i < PTRS_PER_PTE; i++)
@@ -1820,6 +1848,7 @@ static void __init check_pt_base(unsigned long *pt_base, unsigned long *pt_end,
 		(*pt_end)--;
 	}
 }
+
 /*
  * Set up the initial kernel pagetable.
  *
@@ -1830,6 +1859,7 @@ static void __init check_pt_base(unsigned long *pt_base, unsigned long *pt_end,
  * but that's enough to get __va working.  We need to fill in the rest
  * of the physical mapping once some sort of allocator has been set
  * up.
+ * NOTE: for PVH, the page tables are native.
  */
 void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 {
@@ -1907,10 +1937,13 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 	 * structure to attach it to, so make sure we just set kernel
 	 * pgd.
 	 */
-	xen_mc_batch();
-	__xen_write_cr3(true, __pa(init_level4_pgt));
-	xen_mc_issue(PARAVIRT_LAZY_CPU);
-
+	if (xen_feature(XENFEAT_writable_page_tables)) {
+		native_write_cr3(__pa(init_level4_pgt));
+	} else {
+		xen_mc_batch();
+		__xen_write_cr3(true, __pa(init_level4_pgt));
+		xen_mc_issue(PARAVIRT_LAZY_CPU);
+	}
 	/* We can't that easily rip out L3 and L2, as the Xen pagetables are
 	 * set out this way: [L4], [L1], [L2], [L3], [L1], [L1] ...  for
 	 * the initial domain. For guests using the toolstack, they are in:
@@ -2177,8 +2210,19 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 
 void __init xen_init_mmu_ops(void)
 {
-	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
 	x86_init.paging.pagetable_init = xen_pagetable_init;
+
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		pv_mmu_ops.flush_tlb_others = xen_flush_tlb_others;
+
+		/* For PCI devices to map iomem. */
+		if (xen_initial_domain()) {
+			pv_mmu_ops.set_pte = native_set_pte;
+			pv_mmu_ops.set_pte_at = native_set_pte_at;
+		}
+		return;
+	}
+	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
 	pv_mmu_ops = xen_mmu_ops;
 
 	memset(dummy_mapping, 0xff, PAGE_SIZE);
@@ -2414,6 +2458,87 @@ void __init xen_hvm_init_mmu_ops(void)
 }
 #endif
 
+/* Map foreign gmfn, fgmfn, to local pfn, lpfn. This for the user space
+ * creating new guest on PVH dom0 and needs to map domU pages.
+ */
+static int pvh_add_to_xen_p2m(unsigned long lpfn, unsigned long fgmfn,
+			      unsigned int domid)
+{
+	int rc;
+	struct xen_add_to_physmap xatp = { .u.foreign_domid = domid };
+
+	xatp.gpfn = lpfn;
+	xatp.idx = fgmfn;
+	xatp.domid = DOMID_SELF;
+	xatp.space = XENMAPSPACE_gmfn_foreign;
+	rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
+	if (rc)
+		pr_warn("d0: Failed to map pfn (0x%lx) to mfn (0x%lx) rc:%d\n",
+			lpfn, fgmfn, rc);
+	return rc;
+}
+
+static int pvh_rem_xen_p2m(unsigned long spfn, int count)
+{
+	struct xen_remove_from_physmap xrp;
+	int i, rc;
+
+	for (i = 0; i < count; i++) {
+		xrp.domid = DOMID_SELF;
+		xrp.gpfn = spfn+i;
+		rc = HYPERVISOR_memory_op(XENMEM_remove_from_physmap, &xrp);
+		if (rc) {
+			pr_warn("Failed to unmap pfn:%lx rc:%d done:%d\n",
+				spfn+i, rc, i);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+struct pvh_remap_data {
+	unsigned long fgmfn;		/* foreign domain's gmfn */
+	pgprot_t prot;
+	domid_t  domid;
+	int	 index;
+	struct page **pages;
+};
+
+static int pvh_map_pte_fn(pte_t *ptep, pgtable_t token, unsigned long addr,
+			void *data)
+{
+	int rc;
+	struct pvh_remap_data *remap = data;
+	unsigned long pfn = page_to_pfn(remap->pages[remap->index++]);
+	pte_t pteval = pte_mkspecial(pfn_pte(pfn, remap->prot));
+
+	rc = pvh_add_to_xen_p2m(pfn, remap->fgmfn, remap->domid);
+	if (rc)
+		return rc;
+	native_set_pte(ptep, pteval);
+
+	return 0;
+}
+
+static int pvh_remap_gmfn_range(struct vm_area_struct *vma,
+				unsigned long addr, unsigned long mfn, int nr,
+				pgprot_t prot, unsigned domid,
+				struct page **pages)
+{
+	int err;
+	struct pvh_remap_data pvhdata;
+
+	pvhdata.fgmfn = mfn;
+	pvhdata.prot = prot;
+	pvhdata.domid = domid;
+	pvhdata.index = 0;
+	pvhdata.pages = pages;
+	err = apply_to_page_range(vma->vm_mm, addr, nr << PAGE_SHIFT,
+				  pvh_map_pte_fn, &pvhdata);
+	flush_tlb_all();
+	return err;
+}
+
 #define REMAP_BATCH_SIZE 16
 
 struct remap_data {
@@ -2438,7 +2563,9 @@ static int remap_area_mfn_pte_fn(pte_t *ptep, pgtable_t token,
 int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 			       unsigned long addr,
 			       unsigned long mfn, int nr,
-			       pgprot_t prot, unsigned domid)
+			       pgprot_t prot, unsigned domid,
+			       struct page **pages)
+
 {
 	struct remap_data rmd;
 	struct mmu_update mmu_update[REMAP_BATCH_SIZE];
@@ -2446,14 +2573,17 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 	unsigned long range;
 	int err = 0;
 
-	if (xen_feature(XENFEAT_auto_translated_physmap))
-		return -EINVAL;
-
 	prot = __pgprot(pgprot_val(prot) | _PAGE_IOMAP);
 
 	BUG_ON(!((vma->vm_flags & (VM_PFNMAP | VM_RESERVED | VM_IO)) ==
 				(VM_PFNMAP | VM_RESERVED | VM_IO)));
 
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		/* We need to update the local page tables and the xen HAP */
+		return pvh_remap_gmfn_range(vma, addr, mfn, nr, prot, domid,
+					    pages);
+	}
+
 	rmd.mfn = mfn;
 	rmd.prot = prot;
 
@@ -2483,3 +2613,27 @@ out:
 	return err;
 }
 EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
+
+/* Returns: 0 success */
+int xen_unmap_domain_mfn_range(struct vm_area_struct *vma)
+{
+	int numpgs = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	struct page **pages = vma ? vma->vm_private_data : NULL;
+
+	if (!pages || !xen_feature(XENFEAT_auto_translated_physmap))
+		return 0;
+
+	while (numpgs--) {
+
+		/* the mmu has already cleaned up the process mmu resources at
+		 * this point (lookup_address will return NULL). */
+		unsigned long pfn = page_to_pfn(pages[numpgs]);
+
+		pvh_rem_xen_p2m(pfn, 1);
+	}
+	/* We don't need to flush tlbs because as part of pvh_rem_xen_p2m(),
+	 * the hypervisor will do tlb flushes after removing the p2m entries
+	 * from the EPT/NPT */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
index 73809bb..6d0bb56 100644
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -23,4 +23,6 @@ unsigned long xen_read_cr2_direct(void);
 
 extern void xen_init_mmu_ops(void);
 extern void xen_hvm_init_mmu_ops(void);
+extern void xen_set_clr_mmio_pvh_pte(unsigned long pfn, unsigned long mfn,
+				     int nr_mfns, int add_mapping);
 #endif	/* _XEN_MMU_H */
diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index ef63895..63d9ee8 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -178,7 +178,7 @@ static int mmap_mfn_range(void *data, void *state)
 					msg->va & PAGE_MASK,
 					msg->mfn, msg->npages,
 					vma->vm_page_prot,
-					st->domain);
+					st->domain, NULL);
 	if (rc < 0)
 		return rc;
 
@@ -267,7 +267,8 @@ static int mmap_batch_fn(void *data, void *state)
 	int ret;
 
 	ret = xen_remap_domain_mfn_range(st->vma, st->va & PAGE_MASK, *mfnp, 1,
-					 st->vma->vm_page_prot, st->domain);
+					 st->vma->vm_page_prot, st->domain,
+					 NULL);
 
 	/* Store error code for second pass. */
 	*(st->err++) = ret;
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 6a198e4..8b24315 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -27,6 +27,8 @@ struct vm_area_struct;
 int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 			       unsigned long addr,
 			       unsigned long mfn, int nr,
-			       pgprot_t prot, unsigned domid);
+			       pgprot_t prot, unsigned domid,
+			       struct page **pages);
+int xen_unmap_domain_mfn_range(struct vm_area_struct *vma);
 
 #endif /* INCLUDE_XEN_OPS_H */
-- 
1.7.2.3

