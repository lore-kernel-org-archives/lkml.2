Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab0LONlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:41:06 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:47842 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab0LONk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:40:57 -0500
X-IronPort-AV: E=Sophos;i="4.59,349,1288584000"; 
   d="scan'208";a="126991599"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 11/11] xen p2m: clear the old pte when adding a page to m2p_override
Date: Wed, 15 Dec 2010 13:40:46 +0000
Message-Id: <1292420446-3348-11-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
X-OriginalArrivalTime: 15 Dec 2010 13:40:57.0281 (UTC) FILETIME=[B3CF9B10:01CB9C5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

When adding a page to m2p_override we change the p2m of the page so we
need to also clear the old pte of the kernel linear mapping because it
doesn't correspond anymore.

When we remove the page from m2p_override we restore the original p2m of
the page and we also restore the old pte of the kernel linear mapping.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/p2m.c |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 7dde8e4..ca6552d 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/hash.h>
+#include <linux/sched.h>
 
 #include <asm/cache.h>
 #include <asm/setup.h>
@@ -412,6 +413,22 @@ void m2p_add_override(unsigned long mfn, struct page *page)
 	page->index = pfn_to_mfn(pfn);
 
 	__set_phys_to_machine(pfn, FOREIGN_FRAME(mfn));
+	if (!PageHighMem(page)) {
+		unsigned long address = (unsigned long)__va(pfn << PAGE_SHIFT);
+		unsigned level;
+		pte_t *ptep = lookup_address(address, &level);
+
+		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
+					"m2p_add_override: pfn %lx not mapped", pfn)) {
+			__free_page(page);
+
+			return;
+		}
+
+		/* Just zap old mapping for now */
+		pte_clear(&init_mm, address, ptep);
+	}
+
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
@@ -420,10 +437,26 @@ void m2p_add_override(unsigned long mfn, struct page *page)
 void m2p_remove_override(struct page *page)
 {
 	unsigned long flags;
+	unsigned long pfn = page_to_pfn(page);
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_del(&page->lru);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
-	__set_phys_to_machine(page_to_pfn(page), page->index);
+	__set_phys_to_machine(pfn, page->index);
+
+	if (!PageHighMem(page)) {
+		unsigned long address = (unsigned long)__va(pfn << PAGE_SHIFT);
+		unsigned level;
+		pte_t *ptep = lookup_address(address, &level);
+
+		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
+					"m2p_remove_override: pfn %lx not mapped", pfn))
+			return;
+
+		set_pte_at(&init_mm, address, ptep,
+				pfn_pte(pfn, PAGE_KERNEL));
+		/* No tlb flush necessary because the caller already
+		 * left the pte unmapped. */
+	}
 }
 
 struct page *m2p_find_override(unsigned long mfn)
-- 
1.5.6.5

