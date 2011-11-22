Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab1KVBbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:31:36 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51474 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab1KVBbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:31:13 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: ralf@linux-mips.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: [PATCH 2/2] hugetlb: Replace BUG() with BUILD_BUG_ON_USED() for dummy definitions.
Date: Mon, 21 Nov 2011 17:31:06 -0800
Message-Id: <1321925466-11280-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1321925466-11280-1-git-send-email-ddaney.cavm@gmail.com>
References: <1321925466-11280-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The file linux/hugetlb.h has many places where dummy symbols were
defined so that the main source code would contain fewer:

    #ifdef CONFIG_HUGETLBFS

If there were any misuse of these symbols, the only symptom would be
an OOPS at runtime.  Change the BUG() to BUILD_BUG_ON_USED() to catch
any such abuse at compile time instead.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 include/linux/hugetlb.h |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index d9d6c86..0067191 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -85,11 +85,11 @@ static inline unsigned long hugetlb_total_pages(void)
 	return 0;
 }
 
-#define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUG(); 0; })
+#define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUILD_BUG_ON_USED(); 0; })
 #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
-#define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
-#define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
-#define unmap_hugepage_range(vma, start, end, page)	BUG()
+#define copy_hugetlb_page_range(src, dst, vma)	({ BUILD_BUG_ON_USED(); 0; })
+#define hugetlb_prefault(mapping, vma)		({ BUILD_BUG_ON_USED(); 0; })
+#define unmap_hugepage_range(vma, start, end, page)	BUILD_BUG_ON_USED()
 static inline void hugetlb_report_meminfo(struct seq_file *m)
 {
 }
@@ -100,8 +100,9 @@ static inline void hugetlb_report_meminfo(struct seq_file *m)
 #define pmd_huge(x)	0
 #define pud_huge(x)	0
 #define is_hugepage_only_range(mm, addr, len)	0
-#define hugetlb_free_pgd_range(tlb, addr, end, floor, ceiling) ({BUG(); 0; })
-#define hugetlb_fault(mm, vma, addr, flags)	({ BUG(); 0; })
+#define hugetlb_free_pgd_range(tlb, addr, end, floor, ceiling)	\
+	({BUILD_BUG_ON_USED(); 0; })
+#define hugetlb_fault(mm, vma, addr, flags)	({ BUILD_BUG_ON_USED(); 0; })
 #define huge_pte_offset(mm, address)	0
 #define dequeue_hwpoisoned_huge_page(page)	0
 static inline void copy_huge_page(struct page *dst, struct page *src)
@@ -186,7 +187,7 @@ static inline void set_file_hugepages(struct file *file)
 #else /* !CONFIG_HUGETLBFS */
 
 #define is_file_hugepages(file)			0
-#define set_file_hugepages(file)		BUG()
+#define set_file_hugepages(file)		BUILD_BUG_ON_USED()
 static inline struct file *hugetlb_file_setup(const char *name, size_t size,
 		vm_flags_t acctflag, struct user_struct **user, int creat_flags)
 {
-- 
1.7.2.3

