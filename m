Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934969Ab2C3W4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:56:53 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934922Ab2C3VFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:51 -0400
Message-Id: <201203302105.q2UL55q7006290@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:36:53 -0400
Subject: [PATCH] arch/tile: don't set the homecache of a PTE unless appropriate
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:05.0600 (UTC) FILETIME=[C802A400:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We make sure not to try to set the home for an MMIO PTE (on tilegx)
or a PTE that isn't referencing memory managed by Linux.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/pgtable.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index 14e7e9e..277645f 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -467,10 +467,18 @@ void __set_pte(pte_t *ptep, pte_t pte)
 
 void set_pte(pte_t *ptep, pte_t pte)
 {
-	struct page *page = pfn_to_page(pte_pfn(pte));
-
-	/* Update the home of a PTE if necessary */
-	pte = pte_set_home(pte, page_home(page));
+	if (pte_present(pte) &&
+	    (!CHIP_HAS_MMIO() || hv_pte_get_mode(pte) != HV_PTE_MODE_MMIO)) {
+		/* The PTE actually references physical memory. */
+		unsigned long pfn = pte_pfn(pte);
+		if (pfn_valid(pfn)) {
+			/* Update the home of the PTE from the struct page. */
+			pte = pte_set_home(pte, page_home(pfn_to_page(pfn)));
+		} else if (hv_pte_get_mode(pte) == 0) {
+			/* remap_pfn_range(), etc, must supply PTE mode. */
+			panic("set_pte(): out-of-range PFN and mode 0\n");
+		}
+	}
 
 	__set_pte(ptep, pte);
 }
-- 
1.6.5.2

