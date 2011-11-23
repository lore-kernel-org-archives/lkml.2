Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1KWXrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 18:47:35 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46712 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1KWXrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 18:47:08 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, DM <dm.n9107@gmail.com>,
        David Howells <dhowells@redhat.com>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH v3 2/2] hugetlb: Replace BUG() with BUILD_BUG() for dummy definitions.
Date: Wed, 23 Nov 2011 15:46:57 -0800
Message-Id: <1322092017-21471-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1322092017-21471-1-git-send-email-ddaney.cavm@gmail.com>
References: <1322092017-21471-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The files linux/hugetlb.h and linux/huge_mm.h have several places
where dummy symbols were defined so that the main source code would
contain fewer:

    #ifdef CONFIG_HUGETLBFS

or

    #ifdef CONFIG_TRANSPARENT_HUGEPAGE

If there were any misuse of these symbols, the only symptom would be
an OOPS at runtime.  Change the BUG() to BUILD_BUG() to catch
any such abuse at compile time instead.

Acked-by: David Howells <dhowells@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: David Daney <david.daney@cavium.com>
---
 include/linux/huge_mm.h |    8 ++++----
 include/linux/hugetlb.h |   14 +++++++-------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a9ace9c..33e47d8 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -145,10 +145,10 @@ static inline struct page *compound_trans_head(struct page *page)
 	}
 	return page;
 }
-#else /* CONFIG_TRANSPARENT_HUGEPAGE */
-#define HPAGE_PMD_SHIFT ({ BUG(); 0; })
-#define HPAGE_PMD_MASK ({ BUG(); 0; })
-#define HPAGE_PMD_SIZE ({ BUG(); 0; })
+#else /* !CONFIG_TRANSPARENT_HUGEPAGE */
+#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
+#define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
+#define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
 
 #define hpage_nr_pages(x) 1
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index d9d6c86..1289937 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -85,11 +85,11 @@ static inline unsigned long hugetlb_total_pages(void)
 	return 0;
 }
 
-#define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUG(); 0; })
+#define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUILD_BUG(); 0; })
 #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
-#define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
-#define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
-#define unmap_hugepage_range(vma, start, end, page)	BUG()
+#define copy_hugetlb_page_range(src, dst, vma)	({ BUILD_BUG(); 0; })
+#define hugetlb_prefault(mapping, vma)		({ BUILD_BUG(); 0; })
+#define unmap_hugepage_range(vma, start, end, page)	BUILD_BUG()
 static inline void hugetlb_report_meminfo(struct seq_file *m)
 {
 }
@@ -100,8 +100,8 @@ static inline void hugetlb_report_meminfo(struct seq_file *m)
 #define pmd_huge(x)	0
 #define pud_huge(x)	0
 #define is_hugepage_only_range(mm, addr, len)	0
-#define hugetlb_free_pgd_range(tlb, addr, end, floor, ceiling) ({BUG(); 0; })
-#define hugetlb_fault(mm, vma, addr, flags)	({ BUG(); 0; })
+#define hugetlb_free_pgd_range(tlb, addr, end, f, c) ({BUILD_BUG(); 0; })
+#define hugetlb_fault(mm, vma, addr, flags)	({ BUILD_BUG(); 0; })
 #define huge_pte_offset(mm, address)	0
 #define dequeue_hwpoisoned_huge_page(page)	0
 static inline void copy_huge_page(struct page *dst, struct page *src)
@@ -186,7 +186,7 @@ static inline void set_file_hugepages(struct file *file)
 #else /* !CONFIG_HUGETLBFS */
 
 #define is_file_hugepages(file)			0
-#define set_file_hugepages(file)		BUG()
+#define set_file_hugepages(file)		BUILD_BUG()
 static inline struct file *hugetlb_file_setup(const char *name, size_t size,
 		vm_flags_t acctflag, struct user_struct **user, int creat_flags)
 {
-- 
1.7.2.3

