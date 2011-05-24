Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546Ab1EXVjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:39:51 -0400
Received: from service87.mimecast.com ([94.185.240.25]:34793 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933505Ab1EXVjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:39:46 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v6 11/18] ARM: LPAE: Invalidate the TLB before freeing the PMD
Date: Tue, 24 May 2011 22:39:17 +0100
Message-Id: <1306273164-18217-12-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 May 2011 21:39:48.0068 (UTC) FILETIME=[1AC9CA40:01CC1A5B]
X-MC-Unique: 111052422394400701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p4OLeTun005031

Similar to the PTE freeing, this patch introduced __pmd_free_tlb() which
invalidates the TLB before freeing a PMD page. This is needed because on
newer processors the entry in the upper page table may be cached by the
TLB and point to random data after the PMD has been freed.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/tlb.h |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/tlb.h b/arch/arm/include/asm/tlb.h
index f9f6ecd..033ba0d 100644
--- a/arch/arm/include/asm/tlb.h
+++ b/arch/arm/include/asm/tlb.h
@@ -181,8 +181,17 @@ static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
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

