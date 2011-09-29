Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1I2K6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 06:58:14 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25611 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1I2K6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 06:58:13 -0400
X-IronPort-AV: E=Sophos;i="4.68,460,1312171200"; 
   d="scan'208";a="165107804"
From: <stefano.stabellini@eu.citrix.com>
To: konrad.wilk@oracle.com
CC: Stefano.Stabellini@eu.citrix.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v5 2/2] xen: modify kernel mappings corresponding to granted pages
Date: Thu, 29 Sep 2011 11:57:56 +0100
Message-ID: <1317293876-23891-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1109291148340.3519@kaball-desktop>
References: <alpine.DEB.2.00.1109291148340.3519@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

If we want to use granted pages for AIO, changing the mappings of a user
vma and the corresponding p2m is not enough, we also need to update the
kernel mappings accordingly.
Currently this is only needed for pages that are created for user usages
through /dev/xen/gntdev. As in, pages that have been in use by the
kernel and use the P2M will not need this special mapping.
However there are no guarantees that in the future the kernel won't
start accessing pages through the 1:1 even for internal usage.

In order to avoid the complexity of dealing with highmem, we allocated
the pages lowmem.
We issue a HYPERVISOR_grant_table_op right away in
m2p_add_override and we remove the mappings using another
HYPERVISOR_grant_table_op in m2p_remove_override.
Considering that m2p_add_override and m2p_remove_override are called
once per page we use multicalls and hypercall batching.

Use the kmap_op pointer directly as argument to do the mapping as it is
guaranteed to be present up until the unmapping is done.
Before issuing any unmapping multicalls, we need to make sure that the
mapping has already being done, because we need the kmap->handle to be
set correctly.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/include/asm/xen/page.h     |    5 ++-
 arch/x86/xen/p2m.c                  |   79 ++++++++++++++++++++++++++++++-----
 drivers/block/xen-blkback/blkback.c |    2 +-
 drivers/xen/gntdev.c                |   32 ++++++++++++++-
 drivers/xen/grant-table.c           |    6 +-
 include/xen/grant_table.h           |    1 +
 6 files changed, 108 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index e1dc8e6..37d3185 100644
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
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 6e56b65..5857ef0 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -161,7 +161,9 @@
 #include <asm/xen/page.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
+#include <xen/grant_table.h>
 
+#include "multicalls.h"
 #include "xen-ops.h"
 
 static void __init m2p_override_init(void);
@@ -676,7 +678,8 @@ static unsigned long mfn_hash(unsigned long mfn)
 }
 
 /* Add an MFN override for a particular page */
-int m2p_add_override(unsigned long mfn, struct page *page, bool clear_pte)
+int m2p_add_override(unsigned long mfn, struct page *page,
+		struct gnttab_map_grant_ref *kmap_op)
 {
 	unsigned long flags;
 	unsigned long pfn;
@@ -700,9 +703,21 @@ int m2p_add_override(unsigned long mfn, struct page *page, bool clear_pte)
 	if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))))
 		return -ENOMEM;
 
-	if (clear_pte && !PageHighMem(page))
-		/* Just zap old mapping for now */
-		pte_clear(&init_mm, address, ptep);
+	if (kmap_op != NULL) {
+		if (!PageHighMem(page)) {
+			struct multicall_space mcs =
+				xen_mc_entry(sizeof(*kmap_op));
+
+			MULTI_grant_table_op(mcs.mc,
+					GNTTABOP_map_grant_ref, kmap_op, 1);
+
+			xen_mc_issue(PARAVIRT_LAZY_MMU);
+		}
+		set_page_private(page, page_private(page) | GRANT_FRAME_BIT);
+		/* let's use dev_bus_addr to record the old mfn instead */
+		kmap_op->dev_bus_addr = page->index;
+		page->index = (unsigned long) kmap_op;
+	}
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
@@ -736,14 +751,56 @@ int m2p_remove_override(struct page *page, bool clear_pte)
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_del(&page->lru);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
-	set_phys_to_machine(pfn, page->index);
 	WARN_ON(!PagePrivate(page));
 	ClearPagePrivate(page);
-	if (clear_pte && !PageHighMem(page))
-		set_pte_at(&init_mm, address, ptep,
-				pfn_pte(pfn, PAGE_KERNEL));
-		/* No tlb flush necessary because the caller already
-		 * left the pte unmapped. */
+
+	if (clear_pte) {
+		struct gnttab_map_grant_ref *map_op =
+			(struct gnttab_map_grant_ref *) page->index;
+		set_phys_to_machine(pfn, map_op->dev_bus_addr);
+		if (!PageHighMem(page)) {
+			struct multicall_space mcs;
+			struct gnttab_unmap_grant_ref *unmap_op;
+
+			/*
+			 * It might be that we queued all the m2p grant table
+			 * hypercalls in a multicall, then m2p_remove_override
+			 * get called before the multicall has actually been
+			 * issued. In this case handle is going to -1 because
+			 * it hasn't been modified yet.
+			 */
+			if (map_op->handle == -1)
+				xen_mc_flush();
+			/*
+			 * Now if map_op->handle is negative it means that the
+			 * hypercall actually returned an error.
+			 */
+			if (map_op->handle == GNTST_general_error) {
+				printk(KERN_WARNING "m2p_remove_override: "
+						"pfn %lx mfn %lx, failed to modify kernel mappings",
+						pfn, mfn);
+				return -1;
+			}
+
+			mcs = xen_mc_entry(
+					sizeof(struct gnttab_unmap_grant_ref));
+			unmap_op = mcs.args;
+			unmap_op->host_addr = map_op->host_addr;
+			unmap_op->handle = map_op->handle;
+			unmap_op->dev_bus_addr = 0;
+
+			MULTI_grant_table_op(mcs.mc,
+					GNTTABOP_unmap_grant_ref, unmap_op, 1);
+
+			xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+			set_pte_at(&init_mm, address, ptep,
+					pfn_pte(pfn, PAGE_KERNEL));
+			__flush_tlb_single(address);
+			map_op->host_addr = 0;
+		}
+	} else
+		set_phys_to_machine(pfn, page->index);
 
 	return 0;
 }
@@ -760,7 +817,7 @@ struct page *m2p_find_override(unsigned long mfn)
 	spin_lock_irqsave(&m2p_override_lock, flags);
 
 	list_for_each_entry(p, bucket, lru) {
-		if (page_private(p) == mfn) {
+		if ((page_private(p) & (~GRANT_FRAME_BIT)) == mfn) {
 			ret = p;
 			break;
 		}
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 2330a9a..1540792 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -396,7 +396,7 @@ static int xen_blkbk_map(struct blkif_request *req,
 			continue;
 
 		ret = m2p_add_override(PFN_DOWN(map[i].dev_bus_addr),
-			blkbk->pending_page(pending_req, i), false);
+			blkbk->pending_page(pending_req, i), NULL);
 		if (ret) {
 			pr_alert(DRV_PFX "Failed to install M2P override for %lx (ret: %d)\n",
 				 (unsigned long)map[i].dev_bus_addr, ret);
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 7b9b1d1..3e3603f 100644
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
@@ -243,10 +248,35 @@ static int map_grant_pages(struct grant_map *map)
 			gnttab_set_unmap_op(&map->unmap_ops[i], addr,
 				map->flags, -1 /* handle */);
 		}
+	} else {
+		/*
+		 * Setup the map_ops corresponding to the pte entries pointing
+		 * to the kernel linear addresses of the struct pages.
+		 * These ptes are completely different from the user ptes dealt
+		 * with find_grant_ptes.
+		 */
+		for (i = 0; i < map->count; i++) {
+			unsigned level;
+			unsigned long address = (unsigned long)
+				pfn_to_kaddr(page_to_pfn(map->pages[i]));
+			pte_t *ptep;
+			u64 pte_maddr = 0;
+			BUG_ON(PageHighMem(map->pages[i]));
+
+			ptep = lookup_address(address, &level);
+			pte_maddr = arbitrary_virt_to_machine(ptep).maddr;
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
index 4f44b34..8c71ab8 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -448,7 +448,8 @@ unsigned int gnttab_max_grant_frames(void)
 EXPORT_SYMBOL_GPL(gnttab_max_grant_frames);
 
 int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
-		    struct page **pages, unsigned int count)
+			struct gnttab_map_grant_ref *kmap_ops,
+			struct page **pages, unsigned int count)
 {
 	int i, ret;
 	pte_t *pte;
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

