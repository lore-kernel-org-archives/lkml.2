Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab2DFVCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:02:03 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:53688 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758086Ab2DFVCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:02:00 -0400
Message-Id: <201204062101.q36L1tuU011402@farm-0027.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 6 Apr 2012 13:41:54 -0400
Subject: [PATCH 2/6] arch/tile: fix set_pte() to properly handle kernel MMIO mappings
To: linux-kernel@vger.kernel.org
In-Reply-To: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com>
References: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com>
X-OriginalArrivalTime: 06 Apr 2012 21:01:55.0917 (UTC) FILETIME=[7FD78FD0:01CD1438]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't look at the 'struct page' for such mappings.  And while we're
at it, also avoid trying to look up the 'struct page' for memory
mappings that are not being managed by Linux, or non-present PTEs.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/pgtable.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index 211558e..591621f 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -453,10 +453,18 @@ void __set_pte(pte_t *ptep, pte_t pte)
 
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

