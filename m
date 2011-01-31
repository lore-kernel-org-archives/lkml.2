Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab1AaXLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:11:51 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22794 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab1AaXJQ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 31 Jan 2011 18:09:16 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, jeremy@goop.org
Cc: hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 03/11] xen/mmu: Set _PAGE_IOMAP if PFN is an identity PFN.
Date: Mon, 31 Jan 2011 17:44:28 -0500
Message-Id: <1296513876-31415-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
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
index 0180ae8..9c9e076 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -416,8 +416,12 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
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
@@ -427,8 +431,18 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
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

