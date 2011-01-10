Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1AJKhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:37:01 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:36877 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab1AJKfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:35:51 -0500
X-IronPort-AV: E=Sophos;i="4.60,299,1291611600"; 
   d="scan'208";a="130293792"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 07/12] xen/gntdev: stop using "token" argument
Date: Mon, 10 Jan 2011 10:36:36 +0000
Message-Id: <1294655801-16230-7-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
References: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
X-OriginalArrivalTime: 10 Jan 2011 10:35:49.0924 (UTC) FILETIME=[260CEE40:01CBB0B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

It's the struct page of the L1 pte page.  But we can get its mfn
by simply doing an arbitrary_virt_to_machine() on it anyway (which is
the safe conservative choice; since we no longer allow HIGHPTE pages,
we would never expect to be operating on a mapped pte page).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/gntdev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 888d763..a2ea533 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -209,8 +209,8 @@ static int find_grant_ptes(pte_t *pte, pgtable_t token,
 	u64 pte_maddr;
 
 	BUG_ON(pgnr >= map->count);
-	pte_maddr  = (u64)pfn_to_mfn(page_to_pfn(token)) << PAGE_SHIFT;
-	pte_maddr += (unsigned long)pte & ~PAGE_MASK;
+	pte_maddr = arbitrary_virt_to_machine(pte).maddr;
+
 	gnttab_set_map_op(&map->map_ops[pgnr], pte_maddr,
 			  GNTMAP_contains_pte | map->flags,
 			  map->grants[pgnr].ref,
-- 
1.5.6.5

