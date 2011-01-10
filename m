Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab1AJKf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:35:59 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:36877 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab1AJKfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:35:54 -0500
X-IronPort-AV: E=Sophos;i="4.60,299,1291611600"; 
   d="scan'208";a="130293798"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 09/12] xen p2m: transparently change the p2m mappings in the m2p override
Date: Mon, 10 Jan 2011 10:36:38 +0000
Message-Id: <1294655801-16230-9-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
References: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
X-OriginalArrivalTime: 10 Jan 2011 10:35:53.0799 (UTC) FILETIME=[285C3570:01CBB0B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

In m2p_add_override store the original mfn into page->index and then
change the p2m mapping, setting mfns as FOREIGN_FRAME.

In m2p_remove_override restore the original mapping.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/p2m.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 8db19d5..b3b19d4 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -407,8 +407,11 @@ static unsigned long mfn_hash(unsigned long mfn)
 void m2p_add_override(unsigned long mfn, struct page *page)
 {
 	unsigned long flags;
+	unsigned long pfn = page_to_pfn(page);
 	page->private = mfn;
+	page->index = pfn_to_mfn(pfn);
 
+	__set_phys_to_machine(pfn, FOREIGN_FRAME(mfn));
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
@@ -417,9 +420,18 @@ void m2p_add_override(unsigned long mfn, struct page *page)
 void m2p_remove_override(struct page *page)
 {
 	unsigned long flags;
+	unsigned long mfn;
+	unsigned long pfn;
+
+	pfn = page_to_pfn(page);
+	mfn = get_phys_to_machine(pfn);
+	if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT))
+		return;
+
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_del(&page->lru);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
+	__set_phys_to_machine(pfn, page->index);
 }
 
 struct page *m2p_find_override(unsigned long mfn)
-- 
1.5.6.5

