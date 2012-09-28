Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965199Ab2I1S7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:59:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965183Ab2I1S7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:59:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 106/262] xen/m2p: do not reuse kmap_op->dev_bus_addr
Date: Fri, 28 Sep 2012 11:50:35 -0700
Message-Id: <20120928183010.725019199@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit 2fc136eecd0c647a6b13fcd00d0c41a1a28f35a5 upstream.

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

Reported-and-Tested-By: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/xen/page.h     |    3 ++-
 arch/x86/xen/p2m.c                  |   27 +++++++++++----------------
 drivers/block/xen-blkback/blkback.c |    2 +-
 drivers/xen/gntdev.c                |    5 +++--
 drivers/xen/grant-table.c           |    6 ++++--
 include/xen/grant_table.h           |    3 ++-
 6 files changed, 23 insertions(+), 23 deletions(-)

--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -51,7 +51,8 @@ extern unsigned long set_phys_range_iden
 
 extern int m2p_add_override(unsigned long mfn, struct page *page,
 			    struct gnttab_map_grant_ref *kmap_op);
-extern int m2p_remove_override(struct page *page, bool clear_pte);
+extern int m2p_remove_override(struct page *page,
+				struct gnttab_map_grant_ref *kmap_op);
 extern struct page *m2p_find_override(unsigned long mfn);
 extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
 
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -828,9 +828,6 @@ int m2p_add_override(unsigned long mfn,
 
 			xen_mc_issue(PARAVIRT_LAZY_MMU);
 		}
-		/* let's use dev_bus_addr to record the old mfn instead */
-		kmap_op->dev_bus_addr = page->index;
-		page->index = (unsigned long) kmap_op;
 	}
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
@@ -857,7 +854,8 @@ int m2p_add_override(unsigned long mfn,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(m2p_add_override);
-int m2p_remove_override(struct page *page, bool clear_pte)
+int m2p_remove_override(struct page *page,
+		struct gnttab_map_grant_ref *kmap_op)
 {
 	unsigned long flags;
 	unsigned long mfn;
@@ -887,10 +885,8 @@ int m2p_remove_override(struct page *pag
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
@@ -902,13 +898,13 @@ int m2p_remove_override(struct page *pag
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
@@ -918,8 +914,8 @@ int m2p_remove_override(struct page *pag
 			mcs = xen_mc_entry(
 					sizeof(struct gnttab_unmap_grant_ref));
 			unmap_op = mcs.args;
-			unmap_op->host_addr = map_op->host_addr;
-			unmap_op->handle = map_op->handle;
+			unmap_op->host_addr = kmap_op->host_addr;
+			unmap_op->handle = kmap_op->handle;
 			unmap_op->dev_bus_addr = 0;
 
 			MULTI_grant_table_op(mcs.mc,
@@ -930,10 +926,9 @@ int m2p_remove_override(struct page *pag
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
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -337,7 +337,7 @@ static void xen_blkbk_unmap(struct pendi
 		invcount++;
 	}
 
-	ret = gnttab_unmap_refs(unmap, pages, invcount, false);
+	ret = gnttab_unmap_refs(unmap, NULL, pages, invcount);
 	BUG_ON(ret);
 }
 
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -314,8 +314,9 @@ static int __unmap_grant_pages(struct gr
 		}
 	}
 
-	err = gnttab_unmap_refs(map->unmap_ops + offset, map->pages + offset,
-				pages, true);
+	err = gnttab_unmap_refs(map->unmap_ops + offset,
+			use_ptemod ? map->kmap_ops + offset : NULL, map->pages + offset,
+			pages);
 	if (err)
 		return err;
 
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -870,7 +870,8 @@ int gnttab_map_refs(struct gnttab_map_gr
 EXPORT_SYMBOL_GPL(gnttab_map_refs);
 
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
-		      struct page **pages, unsigned int count, bool clear_pte)
+		      struct gnttab_map_grant_ref *kmap_ops,
+		      struct page **pages, unsigned int count)
 {
 	int i, ret;
 	bool lazy = false;
@@ -888,7 +889,8 @@ int gnttab_unmap_refs(struct gnttab_unma
 	}
 
 	for (i = 0; i < count; i++) {
-		ret = m2p_remove_override(pages[i], clear_pte);
+		ret = m2p_remove_override(pages[i], kmap_ops ?
+				       &kmap_ops[i] : NULL);
 		if (ret)
 			return ret;
 	}
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -187,6 +187,7 @@ int gnttab_map_refs(struct gnttab_map_gr
 		    struct gnttab_map_grant_ref *kmap_ops,
 		    struct page **pages, unsigned int count);
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
-		      struct page **pages, unsigned int count, bool clear_pte);
+		      struct gnttab_map_grant_ref *kunmap_ops,
+		      struct page **pages, unsigned int count);
 
 #endif /* __ASM_GNTTAB_H__ */


