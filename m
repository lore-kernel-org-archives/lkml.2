Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab0LONlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:41:45 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:47842 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab0LONky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:40:54 -0500
X-IronPort-AV: E=Sophos;i="4.59,349,1288584000"; 
   d="scan'208";a="126991594"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 08/11] xen p2m: transparently change the p2m mappings in the m2p override
Date: Wed, 15 Dec 2010 13:40:43 +0000
Message-Id: <1292420446-3348-8-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
X-OriginalArrivalTime: 15 Dec 2010 13:40:53.0468 (UTC) FILETIME=[B189C9C0:01CB9C5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

In m2p_add_override store the original mfn into page->index and then
change the p2m mapping, setting mfns as FOREIGN_FRAME.

In m2p_remove_override restore the original mapping.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/p2m.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 8db19d5..7dde8e4 100644
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
@@ -420,6 +423,7 @@ void m2p_remove_override(struct page *page)
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_del(&page->lru);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
+	__set_phys_to_machine(page_to_pfn(page), page->index);
 }
 
 struct page *m2p_find_override(unsigned long mfn)
-- 
1.5.6.5

