Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab2ILLqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:46:14 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:9243 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab2ILLqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:46:11 -0400
X-IronPort-AV: E=Sophos;i="4.80,408,1344211200"; 
   d="scan'208";a="14493878"
Date: Wed, 12 Sep 2012 12:44:30 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Sander Eikelenboom <linux@eikelenboom.it>, <ben@guthro.net>,
        <robert.phillips@citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen/m2p: do not reuse kmap_op->dev_bus_addr
Message-ID: <alpine.DEB.2.02.1209121229590.15568@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the caller passes a valid kmap_op to m2p_add_override, we use
kmap_op->dev_bus_addr to store the original mfn, but dev_bus_addr is
part of the interface with Xen and if we are batching the hypercalls it
might not have been written by the hypervisor yet. That means that later
on Xen will write to it and we'll think that the original mfn is
actually what Xen has written to it.

Rather than "stealing" struct members from kmap_op, keep using
page->index to store the original mfn and add another parameter to
m2p_remove_override to get the corresponding kmap_op instead.
It is now responsibility of the caller to keep track of which kmap_op
corresponds to a particular page in the m2p_override (gntdev, the only
user of this interface that passes a valid kmap_op, is already doing that).

Tested-By: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 93971e8..472b9b7 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -51,7 +51,8 @@ extern unsigned long set_phys_range_identity(unsigned long pfn_s,
 
 extern int m2p_add_override(unsigned long mfn, struct page *page,
 			    struct gnttab_map_grant_ref *kmap_op);
-extern int m2p_remove_override(struct page *page, bool clear_pte);
+extern int m2p_remove_override(struct page *page,
+				struct gnttab_map_grant_ref *kmap_op);
 extern struct page *m2p_find_override(unsigned long mfn);
 extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
 
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 64effdc..2825594 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -734,9 +734,6 @@ int m2p_add_override(unsigned long mfn, struct page *page,
 
 			xen_mc_issue(PARAVIRT_LAZY_MMU);
 		}
-		/* let's use dev_bus_addr to record the old mfn instead */
-		kmap_op->dev_bus_addr = page->index;
-		page->index = (unsigned long) kmap_op;
 	}
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
@@ -763,7 +760,8 @@ int m2p_add_override(unsigned long mfn, struct page *page,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(m2p_add_override);
-int m2p_remove_override(struct page *page, bool clear_pte)
+int m2p_remove_override(struct page *page,
+		struct gnttab_map_grant_ref *kmap_op)
 {
 	unsigned long flags;
 	unsigned long mfn;
@@ -793,10 +791,8 @@ int m2p_remove_override(struct page *page, bool clear_pte)
 	WARN_ON(!PagePrivate(page));
 	ClearPagePrivate(page);
 
-	if (clear_pte) {
-		struct gnttab_map_grant_ref *map_op =
-			(struct gnttab_map_grant_ref *) page->index;
-		set_phys_to_machine(pfn, map_op->dev_bus_addr);
+	set_phys_to_machine(pfn, page->index);
+	if (kmap_op != NULL) {
 		if (!PageHighMem(page)) {
 			struct multicall_space mcs;
 			struct gnttab_unmap_grant_ref *unmap_op;
@@ -808,13 +804,13 @@ int m2p_remove_override(struct page *page, bool clear_pte)
 			 * issued. In this case handle is going to -1 because
 			 * it hasn't been modified yet.
 			 */
-			if (map_op->handle == -1)
+			if (kmap_op->handle == -1)
 				xen_mc_flush();
 			/*
-			 * Now if map_op->handle is negative it means that the
+			 * Now if kmap_op->handle is negative it means that the
 			 * hypercall actually returned an error.
 			 */
-			if (map_op->handle == GNTST_general_error) {
+			if (kmap_op->handle == GNTST_general_error) {
 				printk(KERN_WARNING "m2p_remove_override: "
 						"pfn %lx mfn %lx, failed to modify kernel mappings",
 						pfn, mfn);
@@ -824,8 +820,8 @@ int m2p_remove_override(struct page *page, bool clear_pte)
 			mcs = xen_mc_entry(
 					sizeof(struct gnttab_unmap_grant_ref));
 			unmap_op = mcs.args;
-			unmap_op->host_addr = map_op->host_addr;
-			unmap_op->handle = map_op->handle;
+			unmap_op->host_addr = kmap_op->host_addr;
+			unmap_op->handle = kmap_op->handle;
 			unmap_op->dev_bus_addr = 0;
 
 			MULTI_grant_table_op(mcs.mc,
@@ -836,10 +832,9 @@ int m2p_remove_override(struct page *page, bool clear_pte)
 			set_pte_at(&init_mm, address, ptep,
 					pfn_pte(pfn, PAGE_KERNEL));
 			__flush_tlb_single(address);
-			map_op->host_addr = 0;
+			kmap_op->host_addr = 0;
 		}
-	} else
-		set_phys_to_machine(pfn, page->index);
+	}
 
 	/* p2m(m2p(mfn)) == FOREIGN_FRAME(mfn): the mfn is already present
 	 * somewhere in this domain, even before being added to the
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 73f196c..c6decb9 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -337,7 +337,7 @@ static void xen_blkbk_unmap(struct pending_req *req)
 		invcount++;
 	}
 
-	ret = gnttab_unmap_refs(unmap, pages, invcount, false);
+	ret = gnttab_unmap_refs(unmap, NULL, pages, invcount);
 	BUG_ON(ret);
 }
 
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 1ffd03b..7f12416 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -314,8 +314,9 @@ static int __unmap_grant_pages(struct grant_map *map, int offset, int pages)
 		}
 	}
 
-	err = gnttab_unmap_refs(map->unmap_ops + offset, map->pages + offset,
-				pages, true);
+	err = gnttab_unmap_refs(map->unmap_ops + offset,
+			use_ptemod ? map->kmap_ops + offset : NULL, map->pages + offset,
+			pages);
 	if (err)
 		return err;
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 0bfc1ef..0067266 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -870,7 +870,8 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 EXPORT_SYMBOL_GPL(gnttab_map_refs);
 
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
-		      struct page **pages, unsigned int count, bool clear_pte)
+		      struct gnttab_map_grant_ref *kmap_ops,
+		      struct page **pages, unsigned int count)
 {
 	int i, ret;
 	bool lazy = false;
@@ -888,7 +889,8 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 	}
 
 	for (i = 0; i < count; i++) {
-		ret = m2p_remove_override(pages[i], clear_pte);
+		ret = m2p_remove_override(pages[i], kmap_ops ?
+				       &kmap_ops[i] : NULL);
 		if (ret)
 			return ret;
 	}
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 11e27c3..f19fff8 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -187,6 +187,7 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		    struct gnttab_map_grant_ref *kmap_ops,
 		    struct page **pages, unsigned int count);
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
-		      struct page **pages, unsigned int count, bool clear_pte);
+		      struct gnttab_map_grant_ref *kunmap_ops,
+		      struct page **pages, unsigned int count);
 
 #endif /* __ASM_GNTTAB_H__ */
