Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1KNQZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 11:25:37 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55533 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab1KNQYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 11:24:18 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 10/15] ARM: LPAE: Invalidate the TLB before freeing the PMD
Date: Mon, 14 Nov 2011 16:23:46 +0000
Message-Id: <1321287831-24560-11-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1321287831-24560-1-git-send-email-catalin.marinas@arm.com>
References: <1321287831-24560-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 14 Nov 2011 16:24:07.0663 (UTC) FILETIME=[D54DD7F0:01CCA2E9]
X-MC-Unique: 111111416241508601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pAEGPitm019392

Similar to the PTE freeing, this patch introduced __pmd_free_tlb() which
invalidates the TLB before freeing a PMD page. This is needed because on
newer processors the entry in the upper page table may be cached by the
TLB and point to random data after the PMD has been freed.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/tlb.h |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/tlb.h b/arch/arm/include/asm/tlb.h
index b509e44..5d3ed7e3 100644
--- a/arch/arm/include/asm/tlb.h
+++ b/arch/arm/include/asm/tlb.h
@@ -202,8 +202,17 @@ static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 	tlb_remove_page(tlb, pte);
 }
 
+static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
+				  unsigned long addr)
+{
+#ifdef CONFIG_ARM_LPAE
+	tlb_add_flush(tlb, addr);
+	tlb_remove_page(tlb, virt_to_page(pmdp));
+#endif
+}
+
 #define pte_free_tlb(tlb, ptep, addr)	__pte_free_tlb(tlb, ptep, addr)
-#define pmd_free_tlb(tlb, pmdp, addr)	pmd_free((tlb)->mm, pmdp)
+#define pmd_free_tlb(tlb, pmdp, addr)	__pmd_free_tlb(tlb, pmdp, addr)
 #define pud_free_tlb(tlb, pudp, addr)	pud_free((tlb)->mm, pudp)
 
 #define tlb_migrate_finish(mm)		do { } while (0)

