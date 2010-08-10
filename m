Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab0HJJeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:34:24 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47034 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995Ab0HJJdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:33:49 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/9] hugetlb: add corrupted hugepage counter
Date: Tue, 10 Aug 2010 18:27:44 +0900
Message-Id: <1281432464-14833-10-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds "HugePages_Crpt:" line in /proc/meminfo like below:

 # cat /proc/meminfo |grep -e Huge -e Corrupt
 HardwareCorrupted:  6144 kB
 HugePages_Total:       8
 HugePages_Free:        5
 HugePages_Rsvd:        0
 HugePages_Surp:        0
 HugePages_Crpt:        3
 Hugepagesize:       2048 kB

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 include/linux/hugetlb.h |    5 +++++
 mm/hugetlb.c            |   19 +++++++++++++++++++
 mm/memory-failure.c     |    2 ++
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git linux-mce-hwpoison/include/linux/hugetlb.h linux-mce-hwpoison/include/linux/hugetlb.h
index 2b7de04..c7b4dae 100644
--- linux-mce-hwpoison/include/linux/hugetlb.h
+++ linux-mce-hwpoison/include/linux/hugetlb.h
@@ -45,6 +45,8 @@ int hugetlb_reserve_pages(struct inode *inode, long from, long to,
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
 void __isolate_hwpoisoned_huge_page(struct page *page);
 void isolate_hwpoisoned_huge_page(struct page *page);
+void increment_corrupted_huge_page(struct page *page);
+void decrement_corrupted_huge_page(struct page *page);
 void copy_huge_page(struct page *dst, struct page *src);
 
 extern unsigned long hugepages_treat_as_movable;
@@ -105,6 +107,8 @@ static inline void hugetlb_report_meminfo(struct seq_file *m)
 #define huge_pte_offset(mm, address)	0
 #define __isolate_hwpoisoned_huge_page(page)	0
 #define isolate_hwpoisoned_huge_page(page)	0
+#define increment_corrupted_huge_page(page)	0
+#define decrement_corrupted_huge_page(page)	0
 #define copy_huge_page(dst, src)	NULL
 
 #define hugetlb_change_protection(vma, address, end, newprot)
@@ -220,6 +224,7 @@ struct hstate {
 	unsigned long resv_huge_pages;
 	unsigned long surplus_huge_pages;
 	unsigned long nr_overcommit_huge_pages;
+	unsigned long corrupted_huge_pages;
 	struct list_head hugepage_freelists[MAX_NUMNODES];
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
diff --git linux-mce-hwpoison/mm/hugetlb.c linux-mce-hwpoison/mm/hugetlb.c
index 2a61a8f..122790b 100644
--- linux-mce-hwpoison/mm/hugetlb.c
+++ linux-mce-hwpoison/mm/hugetlb.c
@@ -2040,11 +2040,13 @@ void hugetlb_report_meminfo(struct seq_file *m)
 			"HugePages_Free:    %5lu\n"
 			"HugePages_Rsvd:    %5lu\n"
 			"HugePages_Surp:    %5lu\n"
+			"HugePages_Crpt:    %5lu\n"
 			"Hugepagesize:   %8lu kB\n",
 			h->nr_huge_pages,
 			h->free_huge_pages,
 			h->resv_huge_pages,
 			h->surplus_huge_pages,
+			h->corrupted_huge_pages,
 			1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
 }
 
@@ -2980,6 +2982,23 @@ void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
 	hugetlb_acct_memory(h, -(chg - freed));
 }
 
+void increment_corrupted_huge_page(struct page *hpage)
+{
+	struct hstate *h = page_hstate(hpage);
+	spin_lock(&hugetlb_lock);
+	h->corrupted_huge_pages++;
+	spin_unlock(&hugetlb_lock);
+}
+
+void decrement_corrupted_huge_page(struct page *hpage)
+{
+	struct hstate *h = page_hstate(hpage);
+	spin_lock(&hugetlb_lock);
+	BUG_ON(!h->corrupted_huge_pages);
+	h->corrupted_huge_pages--;
+	spin_unlock(&hugetlb_lock);
+}
+
 /*
  * This function is called from memory failure code.
  * Assume the caller holds page lock of the head page.
diff --git linux-mce-hwpoison/mm/memory-failure.c linux-mce-hwpoison/mm/memory-failure.c
index 1f54901..1e9794d 100644
--- linux-mce-hwpoison/mm/memory-failure.c
+++ linux-mce-hwpoison/mm/memory-failure.c
@@ -938,6 +938,7 @@ static void set_page_hwpoison_huge_page(struct page *hpage)
 	int nr_pages = 1 << compound_order(hpage);
 	for (i = 0; i < nr_pages; i++)
 		SetPageHWPoison(hpage + i);
+	increment_corrupted_huge_page(hpage);
 }
 
 static void clear_page_hwpoison_huge_page(struct page *hpage)
@@ -946,6 +947,7 @@ static void clear_page_hwpoison_huge_page(struct page *hpage)
 	int nr_pages = 1 << compound_order(hpage);
 	for (i = 0; i < nr_pages; i++)
 		ClearPageHWPoison(hpage + i);
+	decrement_corrupted_huge_page(hpage);
 }
 
 int __memory_failure(unsigned long pfn, int trapno, int flags)
-- 
1.7.2.1

