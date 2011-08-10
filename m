Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1HJPGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:06:01 -0400
Received: from service87.mimecast.com ([94.185.240.25]:41937 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753323Ab1HJPEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:04:07 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v7 10/16] ARM: LPAE: Invalidate the TLB before freeing the PMD
Date: Wed, 10 Aug 2011 16:03:33 +0100
Message-Id: <1312988619-16804-11-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 10 Aug 2011 15:03:53.0788 (UTC) FILETIME=[B85ACFC0:01CC576E]
X-MC-Unique: 111081016040502201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p7AF6OMo003957

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

