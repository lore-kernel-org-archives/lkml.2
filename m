Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab1IXE5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 00:57:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26112 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab1IXE5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 00:57:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/3] xen/p2m: Use SetPagePrivate and its friends for M2P overrides.
Date: Fri, 23 Sep 2011 22:28:19 -0400
Message-Id: <1316831299-4144-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316831299-4144-1-git-send-email-konrad.wilk@oracle.com>
References: <1316831299-4144-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090205.4E7D6348.004D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use the page->private field and hence should use the proper
macros and set proper bits. Also WARN_ON in case somebody
tries to overwrite our data.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index cc2f8dc..6e56b65 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -692,8 +692,9 @@ int m2p_add_override(unsigned long mfn, struct page *page, bool clear_pte)
 					"m2p_add_override: pfn %lx not mapped", pfn))
 			return -EINVAL;
 	}
-
-	page->private = mfn;
+	WARN_ON(PagePrivate(page));
+	SetPagePrivate(page);
+	set_page_private(page, mfn);
 	page->index = pfn_to_mfn(pfn);
 
 	if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))))
@@ -736,7 +737,8 @@ int m2p_remove_override(struct page *page, bool clear_pte)
 	list_del(&page->lru);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
 	set_phys_to_machine(pfn, page->index);
-
+	WARN_ON(!PagePrivate(page));
+	ClearPagePrivate(page);
 	if (clear_pte && !PageHighMem(page))
 		set_pte_at(&init_mm, address, ptep,
 				pfn_pte(pfn, PAGE_KERNEL));
@@ -758,7 +760,7 @@ struct page *m2p_find_override(unsigned long mfn)
 	spin_lock_irqsave(&m2p_override_lock, flags);
 
 	list_for_each_entry(p, bucket, lru) {
-		if (p->private == mfn) {
+		if (page_private(p) == mfn) {
 			ret = p;
 			break;
 		}
-- 
1.7.4.1

