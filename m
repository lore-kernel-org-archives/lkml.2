Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab2GTMtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:49:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:23890 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab2GTMtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:49:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="174742096"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: linux-mm@kvack.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Alex Shi <alex.shu@intel.com>,
        Jan Beulich <jbeulich@novell.com>,
        Robert Richter <robert.richter@amd.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH, RFC 5/6] mm: make clear_huge_page cache clear only around the fault address
Date: Fri, 20 Jul 2012 15:50:21 +0300
Message-Id: <1342788622-10290-6-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1342788622-10290-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1342788622-10290-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Clearing a 2MB huge page will typically blow away several levels
of CPU caches. To avoid this only cache clear the 4K area
around the fault address and use a cache avoiding clears
for the rest of the 2MB area.

TBD add numbers

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/memory.c |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index c356ead..b4740cf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3957,18 +3957,35 @@ EXPORT_SYMBOL(might_fault);
 #endif
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
+
+#ifndef ARCH_HAS_USER_NOCACHE
+#define ARCH_HAS_USER_NOCACHE 0
+#endif
+
+#if ARCH_HAS_USER_NOCACHE == 0
+#define clear_user_highpage_nocache clear_user_highpage
+#endif
+
 static void clear_gigantic_page(struct page *page,
 				unsigned long addr,
 				unsigned int pages_per_huge_page)
 {
 	int i;
 	struct page *p = page;
+	unsigned long vaddr;
+	unsigned long haddr = addr & HPAGE_PMD_MASK;
+	int target = (addr - haddr) >> PAGE_SHIFT;
 
 	might_sleep();
+	vaddr = haddr;
 	for (i = 0; i < pages_per_huge_page;
 	     i++, p = mem_map_next(p, page, i)) {
 		cond_resched();
-		clear_user_highpage(p, addr + i * PAGE_SIZE);
+		vaddr = haddr + i*PAGE_SIZE;
+		if (!ARCH_HAS_USER_NOCACHE  || i == target)
+			clear_user_highpage(p, vaddr);
+		else
+			clear_user_highpage_nocache(p, vaddr);
 	}
 }
 void clear_huge_page(struct page *page,
@@ -3976,16 +3993,23 @@ void clear_huge_page(struct page *page,
 {
 	int i;
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
+	unsigned long vaddr;
+	int target = (addr - haddr) >> PAGE_SHIFT;
 
 	if (unlikely(pages_per_huge_page > MAX_ORDER_NR_PAGES)) {
-		clear_gigantic_page(page, haddr, pages_per_huge_page);
+		clear_gigantic_page(page, addr, pages_per_huge_page);
 		return;
 	}
 
 	might_sleep();
+	vaddr = haddr;
 	for (i = 0; i < pages_per_huge_page; i++) {
 		cond_resched();
-		clear_user_highpage(page + i, haddr + i * PAGE_SIZE);
+		vaddr = haddr + i*PAGE_SIZE;
+		if (!ARCH_HAS_USER_NOCACHE || i == target)
+			clear_user_highpage(page + i, vaddr);
+		else
+			clear_user_highpage_nocache(page + i, vaddr);
 	}
 }
 
-- 
1.7.7.6

