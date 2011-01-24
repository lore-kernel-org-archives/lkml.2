Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1AXR7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:59:42 -0500
Received: from service87.mimecast.com ([94.185.240.25]:51042 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753929Ab1AXR4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:56:23 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 07/19] ARM: LPAE: Use a mask for physical addresses in page table entries
Date: Mon, 24 Jan 2011 17:55:49 +0000
Message-Id: <1295891761-18366-8-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c.dirty
In-Reply-To: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 Jan 2011 17:56:12.0272 (UTC) FILETIME=[FCC7C700:01CBBBEF]
X-MC-Unique: 111012417562004101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p0OI0F1k031629

With LPAE, the physical address mask is 40-bit while the page table
entry is 64-bit. This patch introduces PHYS_MASK for the 2-level page
table format, defined as ~0UL.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/pgtable-2level-hwdef.h |    2 ++
 arch/arm/include/asm/pgtable.h              |    6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-2level-hwdef.h b/arch/arm/include/asm/pgtable-2level-hwdef.h
index 2b52c40..5cfba15 100644
--- a/arch/arm/include/asm/pgtable-2level-hwdef.h
+++ b/arch/arm/include/asm/pgtable-2level-hwdef.h
@@ -88,4 +88,6 @@
 #define PTE_SMALL_AP_URO_SRW	(_AT(pteval_t, 0xaa) << 4)
 #define PTE_SMALL_AP_URW_SRW	(_AT(pteval_t, 0xff) << 4)
 
+#define PHYS_MASK		(~0UL)
+
 #endif
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 218bdea..e35941d 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -195,10 +195,10 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
 static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 {
-	return __va(pmd_val(pmd) & PAGE_MASK);
+	return __va(pmd_val(pmd) & PHYS_MASK & (s32)PAGE_MASK);
 }
 
-#define pmd_page(pmd)		pfn_to_page(__phys_to_pfn(pmd_val(pmd)))
+#define pmd_page(pmd)		pfn_to_page(__phys_to_pfn(pmd_val(pmd) & PHYS_MASK))
 
 /* we don't need complex calculations here as the pmd is folded into the pgd */
 #define pmd_addr_end(addr,end)	(end)
@@ -219,7 +219,7 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 #define pte_offset_map(pmd,addr)	(__pte_map(pmd) + pte_index(addr))
 #define pte_unmap(pte)			__pte_unmap(pte)
 
-#define pte_pfn(pte)		(pte_val(pte) >> PAGE_SHIFT)
+#define pte_pfn(pte)		((pte_val(pte) & PHYS_MASK) >> PAGE_SHIFT)
 #define pfn_pte(pfn,prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
 #define pte_page(pte)		pfn_to_page(pte_pfn(pte))

