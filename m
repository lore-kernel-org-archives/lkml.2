Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1AJRT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:19:27 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:51674 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab1AJRS1 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 10 Jan 2011 12:18:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        hpa@zytor.com, Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, xen-devel@lists.xensource.com,
        Jan Beulich <JBeulich@novell.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/7] xen/mmu: Set _PAGE_IOMAP if PFN is an identity PFN.
Date: Mon, 10 Jan 2011 12:17:35 -0500
Message-Id: <1294679859-30029-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294679859-30029-1-git-send-email-konrad.wilk@oracle.com>
References: <1294679859-30029-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we find that the PFN is within the P2M as an identity
PFN make sure to tack on the _PAGE_IOMAP flag.

Reviewed-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 40e2c24..6d5b49b 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -881,8 +881,12 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
 	if (val & _PAGE_PRESENT) {
 		unsigned long pfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
 		pteval_t flags = val & PTE_FLAGS_MASK;
-		unsigned long mfn = pfn_to_mfn(pfn);
+		unsigned long mfn;
 
+		if (!xen_feature(XENFEAT_auto_translated_physmap))
+			mfn = get_phys_to_machine(pfn);
+		else
+			mfn = pfn;
 		/*
 		 * If there's no mfn for the pfn, then just create an
 		 * empty non-present pte.  Unfortunately this loses
@@ -892,8 +896,18 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
 		if (unlikely(mfn == INVALID_P2M_ENTRY)) {
 			mfn = 0;
 			flags = 0;
+		} else {
+			/*
+			 * Paramount to do this test _after_ the
+			 * INVALID_P2M_ENTRY as INVALID_P2M_ENTRY &
+			 * IDENTITY_FRAME_BIT resolves to true.
+			 */
+			mfn &= ~FOREIGN_FRAME_BIT;
+			if (mfn & IDENTITY_FRAME_BIT) {
+				mfn &= ~IDENTITY_FRAME_BIT;
+				flags |= _PAGE_IOMAP;
+			}
 		}
-
 		val = ((pteval_t)mfn << PAGE_SHIFT) | flags;
 	}
 
-- 
1.7.1

