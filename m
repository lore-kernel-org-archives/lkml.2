Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2GTMsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:48:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:61739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab2GTMss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:48:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181316821"
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
Subject: [PATCH, RFC 2/6] mm: make clear_huge_page tolerate non aligned address
Date: Fri, 20 Jul 2012 15:50:18 +0300
Message-Id: <1342788622-10290-3-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1342788622-10290-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1342788622-10290-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

hugetlb does not necessarily pass in an aligned address, so the
low level address computation is wrong.

This will fix architectures that actually use the address for flushing
the cleared address (very few, like xtensa/sparc/...?)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/memory.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 2466d12..c356ead 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3975,16 +3975,17 @@ void clear_huge_page(struct page *page,
 		     unsigned long addr, unsigned int pages_per_huge_page)
 {
 	int i;
+	unsigned long haddr = addr & HPAGE_PMD_MASK;
 
 	if (unlikely(pages_per_huge_page > MAX_ORDER_NR_PAGES)) {
-		clear_gigantic_page(page, addr, pages_per_huge_page);
+		clear_gigantic_page(page, haddr, pages_per_huge_page);
 		return;
 	}
 
 	might_sleep();
 	for (i = 0; i < pages_per_huge_page; i++) {
 		cond_resched();
-		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
+		clear_user_highpage(page + i, haddr + i * PAGE_SIZE);
 	}
 }
 
-- 
1.7.7.6

