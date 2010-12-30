Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0L3TuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 14:50:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:38920 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab0L3TuR (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 30 Dec 2010 14:50:17 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        <hpa@zytor.com>, Ian Campbell <Ian.Campbell@citrix.com>
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 8/8] xen/mmu: Set _PAGE_IOMAP if PFN is in identity P2M.
Date: Thu, 30 Dec 2010 14:48:37 -0500
Message-Id: <1293738517-7287-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we find that the PFN is within the P2M as an identity
make sure to tack on the _PAGE_IOMAP flag.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index d470435..158d07a 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -828,7 +828,7 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
 	if (val & _PAGE_PRESENT) {
 		unsigned long pfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
 		pteval_t flags = val & PTE_FLAGS_MASK;
-		unsigned long mfn = pfn_to_mfn(pfn);
+		unsigned long mfn = get_phys_to_machine(pfn);
 
 		/*
 		 * If there's no mfn for the pfn, then just create an
@@ -839,8 +839,18 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
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
 
@@ -968,8 +978,9 @@ pte_t xen_make_pte_debug(pteval_t pte)
 			(unsigned long)addr, (unsigned long)other_addr);
 	} else {
 		other_addr = (_pte.pte & PTE_PFN_MASK);
-		WARN((addr == other_addr) && (!io_page),
-			"0x%lx is missing VM_IO!\n",
+		pteval_t iomap_set = (_pte.pte & PTE_FLAGS_MASK) & _PAGE_IOMAP;
+		WARN((addr == other_addr) && (!io_page) && (!iomap_set),
+			"0x%lx is missing VM_IO (and wasn't fixed)!\n",
 			(unsigned long)addr);
 	}
 
-- 
1.7.1

