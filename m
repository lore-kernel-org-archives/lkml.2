Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab2ENLXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:23:16 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:22936 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab2ENLXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:23:15 -0400
X-IronPort-AV: E=Sophos;i="4.75,584,1330923600"; 
   d="scan'208";a="194671041"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: konrad.wilk@oracle.com
CC: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH] xen: mark local pages as FOREIGN in the m2p_override
Date: Mon, 14 May 2012 12:23:07 +0100
Message-ID: <1336994587-10203-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the frontend and the backend reside on the same domain, even if we
add pages to the m2p_override, these pages will never be returned by
mfn_to_pfn because the check "get_phys_to_machine(pfn) != mfn" will
always fail, so the pfn of the frontend will be returned instead
(resulting in a deadlock because the frontend pages are already locked).

However m2p_add_override can easily find out whether another pfn
corresponding to the mfn exists in the m2p, and can set the FOREIGN bit
in the p2m, making sure that mfn_to_pfn returns the pfn of the backend.

This allows the backend to perform direct_IO on these pages, but as a
side effect prevents the frontend from using get_user_pages_fast on
them while they are being shared with the backend.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/p2m.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 7ece122..c62ae5c 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -687,6 +687,7 @@ int m2p_add_override(unsigned long mfn, struct page *page,
 	unsigned long uninitialized_var(address);
 	unsigned level;
 	pte_t *ptep = NULL;
+	int ret = 0;
 
 	pfn = page_to_pfn(page);
 	if (!PageHighMem(page)) {
@@ -722,6 +723,16 @@ int m2p_add_override(unsigned long mfn, struct page *page,
 	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
 
+	/* p2m(m2p(mfn)) == mfn: the mfn is already present somewhere in
+	 * this domain. Set the FOREIGN_FRAME_BIT in the p2m for the other
+	 * pfn so that the following mfn_to_pfn(mfn) calls will return the
+	 * pfn from the m2p_override (the backend pfn) instead.
+	 * As a side effect GUPF might not be safe on the frontend pages
+	 * while they are being shared with the backend. */
+	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
+	if (ret >= 0 && get_phys_to_machine(pfn) == mfn)
+		set_phys_to_machine(pfn, FOREIGN_FRAME(mfn));
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(m2p_add_override);
@@ -733,6 +744,7 @@ int m2p_remove_override(struct page *page, bool clear_pte)
 	unsigned long uninitialized_var(address);
 	unsigned level;
 	pte_t *ptep = NULL;
+	int ret = 0;
 
 	pfn = page_to_pfn(page);
 	mfn = get_phys_to_machine(pfn);
@@ -802,6 +814,12 @@ int m2p_remove_override(struct page *page, bool clear_pte)
 	} else
 		set_phys_to_machine(pfn, page->index);
 
+	mfn &= ~FOREIGN_FRAME_BIT;
+	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
+	if (ret >= 0 && get_phys_to_machine(pfn) == FOREIGN_FRAME(mfn) &&
+			m2p_find_override(mfn) == NULL)
+		set_phys_to_machine(pfn, mfn);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(m2p_remove_override);
-- 
1.7.2.5

