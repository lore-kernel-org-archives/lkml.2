Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab2KPJyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:54:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:43835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab2KPJyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:54:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,263,1352102400"; 
   d="scan'208";a="250179884"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: convert update_mmu_cache() and update_mmu_cache_pmd() to functions
Date: Fri, 16 Nov 2012 11:55:16 +0200
Message-Id: <1353059717-9850-2-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353059717-9850-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1353059717-9850-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Converting macros to functions unhide type problems before changes will
be integrated and trigger problems on other architectures.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/pgtable.h    | 12 ++++++++++++
 arch/x86/include/asm/pgtable_32.h |  7 -------
 arch/x86/include/asm/pgtable_64.h |  3 ---
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index a984cf9..ec08b47 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -775,6 +775,18 @@ static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
        memcpy(dst, src, count * sizeof(pgd_t));
 }
 
+/*
+ * The x86 doesn't have any external MMU info: the kernel page
+ * tables contain all the necessary information.
+ */
+static inline void update_mmu_cache(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
+{
+}
+static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmd)
+{
+}
 
 #include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLY__ */
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index 8faa215..9ee3221 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -66,13 +66,6 @@ do {						\
 	__flush_tlb_one((vaddr));		\
 } while (0)
 
-/*
- * The i386 doesn't have any external MMU info: the kernel page
- * tables contain all the necessary information.
- */
-#define update_mmu_cache(vma, address, ptep) do { } while (0)
-#define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
-
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 47356f9..615b0c7 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -142,9 +142,6 @@ static inline int pgd_large(pgd_t pgd) { return 0; }
 #define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
 #define pte_unmap(pte) ((void)(pte))/* NOP */
 
-#define update_mmu_cache(vma, address, ptep) do { } while (0)
-#define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
-
 /* Encode and de-code a swap entry */
 #if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
 #define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
-- 
1.7.11.7

