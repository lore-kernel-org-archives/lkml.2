Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1IFQLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:11:21 -0400
Received: from smtp.citrix.com ([66.165.176.89]:11060 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab1IFQLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:11:15 -0400
X-IronPort-AV: E=Sophos;i="4.68,339,1312171200"; 
   d="scan'208";a="16726480"
From: <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
CC: konrad.wilk@oracle.com, xen-devel@lists.xensource.com,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@eu.citrix.com,
        Jeremy.Fitzhardinge@citrix.com
Subject: [PATCH v2 1/2] xen: modify kernel mappings corresponding to granted pages
Date: Tue, 6 Sep 2011 17:19:28 +0100
Message-ID: <1315325969-32346-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

If we want to use granted pages for AIO, changing the mappings of a user
vma and the corresponding p2m is not enough, we also need to update the
kernel mappings accordingly.
On x86_64 it is easy, we can issue another HYPERVISOR_grant_table_op
right away in m2p_add_override. We can remove the mappings using another
HYPERVISOR_grant_table_op in m2p_remove_override.
On x86_32 it is more difficult because the pages are highmem pages and
therefore we need to catch the set_pte that tries to map a granted page
and issue an HYPERVISOR_grant_table_op instead.
Same thing for unmapping them: we need to catch the pte clear or the
set_pte that try to unmap a granted page and issue an
HYPERVISOR_grant_table_op.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/include/asm/xen/page.h |    5 ++-
 arch/x86/xen/mmu.c              |   69 +++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/p2m.c              |   47 ++++++++++++++++++++------
 drivers/xen/gntdev.c            |   27 ++++++++++++++-
 drivers/xen/grant-table.c       |    4 +-
 include/xen/grant_table.h       |    1 +
 6 files changed, 138 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 7ff4669..0ce1884 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -12,6 +12,7 @@
 #include <asm/pgtable.h>
 
 #include <xen/interface/xen.h>
+#include <xen/grant_table.h>
 #include <xen/features.h>
 
 /* Xen machine address */
@@ -31,8 +32,10 @@ typedef struct xpaddr {
 #define INVALID_P2M_ENTRY	(~0UL)
 #define FOREIGN_FRAME_BIT	(1UL<<(BITS_PER_LONG-1))
 #define IDENTITY_FRAME_BIT	(1UL<<(BITS_PER_LONG-2))
+#define GRANT_FRAME_BIT	(1UL<<(BITS_PER_LONG-3))
 #define FOREIGN_FRAME(m)	((m) | FOREIGN_FRAME_BIT)
 #define IDENTITY_FRAME(m)	((m) | IDENTITY_FRAME_BIT)
+#define GRANT_FRAME(m)	((m) | GRANT_FRAME_BIT)
 
 /* Maximum amount of memory we can handle in a domain in pages */
 #define MAX_DOMAIN_PAGES						\
@@ -48,7 +51,7 @@ extern unsigned long set_phys_range_identity(unsigned long pfn_s,
 					     unsigned long pfn_e);
 
 extern int m2p_add_override(unsigned long mfn, struct page *page,
-			    bool clear_pte);
+			    struct gnttab_map_grant_ref *kmap_op);
 extern int m2p_remove_override(struct page *page, bool clear_pte);
 extern struct page *m2p_find_override(unsigned long mfn);
 extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 20a6142..e80dad5 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -306,8 +306,71 @@ static bool xen_batched_set_pte(pte_t *ptep, pte_t pteval)
 	return true;
 }
 
+#ifdef CONFIG_HIGHMEM
+static int xen_unmap_granted_page(pte_t *ptep)
+{
+	unsigned long mfn;
+	struct page *page;
+
+	if (pte_flags(*ptep) & _PAGE_USER)
+		return 1;
+	mfn = (ptep->pte & PTE_PFN_MASK) >> PAGE_SHIFT;
+	page = m2p_find_override(mfn);
+	if (page != NULL && (page->private & GRANT_FRAME_BIT)) {
+		int ret;
+		struct gnttab_unmap_grant_ref kunmap_op;
+		struct gnttab_map_grant_ref *kmap_op =
+			(struct gnttab_map_grant_ref *) page->index;
+		kunmap_op.host_addr = kmap_op->host_addr;
+		kunmap_op.handle = kmap_op->handle;
+		kunmap_op.dev_bus_addr = 0;
+		ret = HYPERVISOR_grant_table_op(
+				GNTTABOP_unmap_grant_ref, &kunmap_op, 1);
+		WARN(ret, "m2p_remove_override: pfn %lx mfn %lx, failed to "
+			"modify kernel mappings", page_to_pfn(page), mfn);
+		return ret;
+	}
+	return 1;
+}
+#endif
+
 static inline void __xen_set_pte(pte_t *ptep, pte_t pteval)
 {
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * the old page we are about to overwrite could be a granted page
+	 * and in that case we need to unmap it using a grant table
+	 * hypercall
+	 */
+	xen_unmap_granted_page(ptep);
+
+	if (!(pte_flags(pteval) & _PAGE_USER)) {
+		int ret;
+		struct page *page;
+		unsigned long mfn = (pteval.pte & PTE_PFN_MASK) >> PAGE_SHIFT;
+		page = m2p_find_override(mfn);
+		/*
+		 * if this is a granted page we need to use a grant table
+		 * hypercall to map it instead
+		 */
+		if (page != NULL && (page->private & GRANT_FRAME_BIT)) {
+			struct gnttab_map_grant_ref *kmap_op =
+				(struct gnttab_map_grant_ref *) page->index;
+			unsigned long old_mfn = kmap_op->dev_bus_addr;
+			kmap_op->host_addr =
+				arbitrary_virt_to_machine(ptep).maddr;
+			kmap_op->dev_bus_addr = 0;
+			ret = HYPERVISOR_grant_table_op(
+					GNTTABOP_map_grant_ref, kmap_op, 1);
+			WARN(ret, "xen_set_pte: pfn %lx mfn %lx, failed to "
+				"modify kernel mappings",
+				page_to_pfn(page), mfn);
+			kmap_op->dev_bus_addr = old_mfn;
+			return;
+		}
+	}
+#endif
+
 	if (!xen_batched_set_pte(ptep, pteval))
 		native_set_pte(ptep, pteval);
 }
@@ -585,6 +648,12 @@ static void xen_set_pte_atomic(pte_t *ptep, pte_t pte)
 static void xen_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	trace_xen_mmu_pte_clear(mm, addr, ptep);
+	/*
+	 * check if this is a granted page and unmap it using a grant table
+	 * hypercall in that case
+	 */
+	if (!xen_unmap_granted_page(ptep))
+		return;
 	if (!xen_batched_set_pte(ptep, native_make_pte(0)))
 		native_pte_clear(mm, addr, ptep);
 }
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 58efeb9..1c4d2b5 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -161,6 +161,7 @@
 #include <asm/xen/page.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
+#include <xen/grant_table.h>
 
 #include "xen-ops.h"
 
@@ -676,7 +677,8 @@ static unsigned long mfn_hash(unsigned long mfn)
 }
 
 /* Add an MFN override for a particular page */
-int m2p_add_override(unsigned long mfn, struct page *page, bool clear_pte)
+int m2p_add_override(unsigned long mfn, struct page *page,
+		struct gnttab_map_grant_ref *kmap_op)
 {
 	unsigned long flags;
 	unsigned long pfn;
@@ -699,9 +701,18 @@ int m2p_add_override(unsigned long mfn, struct page *page, bool clear_pte)
 	if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))))
 		return -ENOMEM;
 
-	if (clear_pte && !PageHighMem(page))
-		/* Just zap old mapping for now */
-		pte_clear(&init_mm, address, ptep);
+	if (kmap_op != NULL) {
+		if (!PageHighMem(page)) {
+			int ret = HYPERVISOR_grant_table_op(
+					GNTTABOP_map_grant_ref, kmap_op, 1);
+			WARN(ret, "m2p_add_override: pfn %lx mfn %lx, "
+				"failed to modify kernel mappings", pfn, mfn);
+		}
+		page->private |= GRANT_FRAME_BIT;
+		/* let's use dev_bus_addr to record the old mfn instead */
+		kmap_op->dev_bus_addr = page->index;
+		page->index = (unsigned long) kmap_op;
+	}
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
@@ -735,13 +746,27 @@ int m2p_remove_override(struct page *page, bool clear_pte)
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_del(&page->lru);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
-	set_phys_to_machine(pfn, page->index);
 
-	if (clear_pte && !PageHighMem(page))
-		set_pte_at(&init_mm, address, ptep,
-				pfn_pte(pfn, PAGE_KERNEL));
-		/* No tlb flush necessary because the caller already
-		 * left the pte unmapped. */
+	if (clear_pte) {
+		struct gnttab_map_grant_ref *map_op =
+			(struct gnttab_map_grant_ref *) page->index;
+		set_phys_to_machine(pfn, map_op->dev_bus_addr);
+		if (!PageHighMem(page)) {
+			int ret;
+			struct gnttab_unmap_grant_ref unmap_op;
+			unmap_op.host_addr = map_op->host_addr;
+			unmap_op.handle = map_op->handle;
+			unmap_op.dev_bus_addr = 0;
+			ret = HYPERVISOR_grant_table_op(
+					GNTTABOP_unmap_grant_ref, &unmap_op, 1);
+			WARN(ret, "m2p_remove_override: pfn %lx mfn %lx, "
+				"failed to modify kernel mappings", pfn, mfn);
+			set_pte_at(&init_mm, address, ptep,
+					pfn_pte(pfn, PAGE_KERNEL));
+			__flush_tlb_single(address);
+		}
+	} else
+		set_phys_to_machine(pfn, page->index);
 
 	return 0;
 }
@@ -758,7 +783,7 @@ struct page *m2p_find_override(unsigned long mfn)
 	spin_lock_irqsave(&m2p_override_lock, flags);
 
 	list_for_each_entry(p, bucket, lru) {
-		if (p->private == mfn) {
+		if ((p->private & (~GRANT_FRAME_BIT)) == mfn) {
 			ret = p;
 			break;
 		}
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index f914b26..ca41772 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -83,6 +83,7 @@ struct grant_map {
 	struct ioctl_gntdev_grant_ref *grants;
 	struct gnttab_map_grant_ref   *map_ops;
 	struct gnttab_unmap_grant_ref *unmap_ops;
+	struct gnttab_map_grant_ref   *kmap_ops;
 	struct page **pages;
 };
 
@@ -116,10 +117,12 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
 	add->grants    = kzalloc(sizeof(add->grants[0])    * count, GFP_KERNEL);
 	add->map_ops   = kzalloc(sizeof(add->map_ops[0])   * count, GFP_KERNEL);
 	add->unmap_ops = kzalloc(sizeof(add->unmap_ops[0]) * count, GFP_KERNEL);
+	add->kmap_ops  = kzalloc(sizeof(add->kmap_ops[0])  * count, GFP_KERNEL);
 	add->pages     = kzalloc(sizeof(add->pages[0])     * count, GFP_KERNEL);
 	if (NULL == add->grants    ||
 	    NULL == add->map_ops   ||
 	    NULL == add->unmap_ops ||
+	    NULL == add->kmap_ops  ||
 	    NULL == add->pages)
 		goto err;
 
@@ -129,6 +132,7 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
 	for (i = 0; i < count; i++) {
 		add->map_ops[i].handle = -1;
 		add->unmap_ops[i].handle = -1;
+		add->kmap_ops[i].handle = -1;
 	}
 
 	add->index = 0;
@@ -142,6 +146,7 @@ err:
 	kfree(add->grants);
 	kfree(add->map_ops);
 	kfree(add->unmap_ops);
+	kfree(add->kmap_ops);
 	kfree(add);
 	return NULL;
 }
@@ -243,10 +248,30 @@ static int map_grant_pages(struct grant_map *map)
 			gnttab_set_unmap_op(&map->unmap_ops[i], addr,
 				map->flags, -1 /* handle */);
 		}
+	} else {
+		for (i = 0; i < map->count; i++) {
+			unsigned level;
+			unsigned long address = (unsigned long)
+				pfn_to_kaddr(page_to_pfn(map->pages[i]));
+			pte_t *ptep;
+			u64 pte_maddr = 0;
+			if (!PageHighMem(map->pages[i])) {
+				ptep = lookup_address(address, &level);
+				pte_maddr =
+					arbitrary_virt_to_machine(ptep).maddr;
+			}
+			gnttab_set_map_op(&map->kmap_ops[i], pte_maddr,
+				map->flags |
+				GNTMAP_host_map |
+				GNTMAP_contains_pte,
+				map->grants[i].ref,
+				map->grants[i].domid);
+		}
 	}
 
 	pr_debug("map %d+%d\n", map->index, map->count);
-	err = gnttab_map_refs(map->map_ops, map->pages, map->count);
+	err = gnttab_map_refs(map->map_ops, use_ptemod ? map->kmap_ops : NULL,
+			map->pages, map->count);
 	if (err)
 		return err;
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 4f44b34..ed6622f 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -448,6 +448,7 @@ unsigned int gnttab_max_grant_frames(void)
 EXPORT_SYMBOL_GPL(gnttab_max_grant_frames);
 
 int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
+			struct gnttab_map_grant_ref *kmap_ops,
 		    struct page **pages, unsigned int count)
 {
 	int i, ret;
@@ -488,8 +489,7 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 			 */
 			return -EOPNOTSUPP;
 		}
-		ret = m2p_add_override(mfn, pages[i],
-				       map_ops[i].flags & GNTMAP_contains_pte);
+		ret = m2p_add_override(mfn, pages[i], &kmap_ops[i]);
 		if (ret)
 			return ret;
 	}
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index b1fab6b..6b99bfb 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -156,6 +156,7 @@ unsigned int gnttab_max_grant_frames(void);
 #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
 
 int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
+			struct gnttab_map_grant_ref *kmap_ops,
 		    struct page **pages, unsigned int count);
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 		      struct page **pages, unsigned int count);
-- 
1.7.2.3

