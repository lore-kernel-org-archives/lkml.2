Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab1AJKgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:36:03 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:36877 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab1AJKf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:35:59 -0500
X-IronPort-AV: E=Sophos;i="4.60,299,1291611600"; 
   d="scan'208";a="130293802"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 12/12] xen p2m: clear the old pte when adding a page to m2p_override
Date: Mon, 10 Jan 2011 10:36:41 +0000
Message-Id: <1294655801-16230-12-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
References: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
X-OriginalArrivalTime: 10 Jan 2011 10:35:58.0643 (UTC) FILETIME=[2B3F5830:01CBB0B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

When adding a page to m2p_override we change the p2m of the page so we
need to also clear the old pte of the kernel linear mapping because it
doesn't correspond anymore.

When we remove the page from m2p_override we restore the original p2m of
the page and we also restore the old pte of the kernel linear mapping.

Before changing the p2m mappings in m2p_add_override and
m2p_remove_override, check that the page passed as argument is valid and
return an error if it is not.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/include/asm/xen/page.h |    4 +-
 arch/x86/xen/p2m.c              |   49 +++++++++++++++++++++++++++++++++++---
 drivers/xen/grant-table.c       |   16 ++++++++++--
 3 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 50f0a0f..f25bdf2 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -42,8 +42,8 @@ extern unsigned int   machine_to_phys_order;
 extern unsigned long get_phys_to_machine(unsigned long pfn);
 extern bool set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 
-extern void m2p_add_override(unsigned long mfn, struct page *page);
-extern void m2p_remove_override(struct page *page);
+extern int m2p_add_override(unsigned long mfn, struct page *page);
+extern int m2p_remove_override(struct page *page);
 extern struct page *m2p_find_override(unsigned long mfn);
 extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
 
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index b3b19d4..40d5122 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/hash.h>
+#include <linux/sched.h>
 
 #include <asm/cache.h>
 #include <asm/setup.h>
@@ -404,34 +405,74 @@ static unsigned long mfn_hash(unsigned long mfn)
 }
 
 /* Add an MFN override for a particular page */
-void m2p_add_override(unsigned long mfn, struct page *page)
+int m2p_add_override(unsigned long mfn, struct page *page)
 {
 	unsigned long flags;
-	unsigned long pfn = page_to_pfn(page);
+	unsigned long pfn;
+	unsigned long address;
+	unsigned level;
+	pte_t *ptep = NULL;
+
+	pfn = page_to_pfn(page);
+	if (!PageHighMem(page)) {
+		address = (unsigned long)__va(pfn << PAGE_SHIFT);
+		ptep = lookup_address(address, &level);
+
+		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
+					"m2p_add_override: pfn %lx not mapped", pfn))
+			return -EINVAL;
+	}
+
 	page->private = mfn;
 	page->index = pfn_to_mfn(pfn);
 
 	__set_phys_to_machine(pfn, FOREIGN_FRAME(mfn));
+	if (!PageHighMem(page))
+		/* Just zap old mapping for now */
+		pte_clear(&init_mm, address, ptep);
+
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
+
+	return 0;
 }
 
-void m2p_remove_override(struct page *page)
+int m2p_remove_override(struct page *page)
 {
 	unsigned long flags;
 	unsigned long mfn;
 	unsigned long pfn;
+	unsigned long address;
+	unsigned level;
+	pte_t *ptep = NULL;
 
 	pfn = page_to_pfn(page);
 	mfn = get_phys_to_machine(pfn);
 	if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT))
-		return;
+		return -EINVAL;
+
+	if (!PageHighMem(page)) {
+		address = (unsigned long)__va(pfn << PAGE_SHIFT);
+		ptep = lookup_address(address, &level);
+
+		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
+					"m2p_remove_override: pfn %lx not mapped", pfn))
+			return -EINVAL;
+	}
 
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_del(&page->lru);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
 	__set_phys_to_machine(pfn, page->index);
+
+	if (!PageHighMem(page))
+		set_pte_at(&init_mm, address, ptep,
+				pfn_pte(pfn, PAGE_KERNEL));
+		/* No tlb flush necessary because the caller already
+		 * left the pte unmapped. */
+
+	return 0;
 }
 
 struct page *m2p_find_override(unsigned long mfn)
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 1afd569..9ef54eb 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -455,6 +455,8 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 	unsigned long mfn;
 
 	ret = HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, map_ops, count);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < count; i++) {
 		/* m2p override only supported for GNTMAP_contains_pte mappings */
@@ -463,7 +465,9 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		pte = (pte_t *) (mfn_to_virt(PFN_DOWN(map_ops[i].host_addr)) +
 				(map_ops[i].host_addr & ~PAGE_MASK));
 		mfn = pte_mfn(*pte);
-		m2p_add_override(mfn, pages[i]);
+		ret = m2p_add_override(mfn, pages[i]);
+		if (ret)
+			return ret;
 	}
 
 	return ret;
@@ -476,8 +480,14 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 	int i, ret;
 
 	ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap_ops, count);
-	for (i = 0; i < count; i++)
-		m2p_remove_override(pages[i]);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < count; i++) {
+		ret = m2p_remove_override(pages[i]);
+		if (ret)
+			return ret;
+	}
 
 	return ret;
 }
-- 
1.5.6.5

