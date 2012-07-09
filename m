Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2GIKjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:39:53 -0400
Received: from smtp.citrix.com ([66.165.176.89]:1168 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab2GIKji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:39:38 -0400
X-IronPort-AV: E=Sophos;i="4.77,551,1336363200"; 
   d="scan'208";a="30818189"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: "David Vrabel" <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] xen/mm: zero PTEs for non-present MFNs in the initial page table
Date: Mon, 9 Jul 2012 11:39:06 +0100
Message-ID: <1341830348-15529-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1341830348-15529-1-git-send-email-david.vrabel@citrix.com>
References: <1341830348-15529-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

When constructing the initial page tables, if the MFN for a usable PFN
is missing in the p2m then that frame is initially ballooned out.  In
this case, zero the PTE (as in decrease_reservation() in
drivers/xen/balloon.c).

This is obviously safe instead of having an valid PTE with an MFN of
INVALID_P2M_ENTRY (~0).

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/mmu.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 3f1783a..27336df 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1432,6 +1432,10 @@ static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
  * Init-time set_pte while constructing initial pagetables, which
  * doesn't allow RO page table pages to be remapped RW.
  *
+ * If there is no MFN for this PFN then this page is initially
+ * ballooned out so clear the PTE (as in decrease_reservation() in
+ * drivers/xen/balloon.c).
+ *
  * Many of these PTE updates are done on unpinned and writable pages
  * and doing a hypercall for these is unnecessary and expensive.  At
  * this point it is not possible to tell if a page is pinned or not,
@@ -1440,7 +1444,10 @@ static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
  */
 static void __init xen_set_pte_init(pte_t *ptep, pte_t pte)
 {
-	pte = mask_rw_pte(ptep, pte);
+	if (pte_mfn(pte) != INVALID_P2M_ENTRY)
+		pte = mask_rw_pte(ptep, pte);
+	else
+		pte = __pte_ma(0);
 
 	native_set_pte(ptep, pte);
 }
-- 
1.7.2.5

