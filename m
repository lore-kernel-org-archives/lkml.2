Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1BVByI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 20:54:08 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48448 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab1BVByF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 20:54:05 -0500
Subject: [PATCH 5/5] have smaps show transparent huge pages
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, akpm@osdl.org,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 21 Feb 2011 17:53:45 -0800
References: <20110222015338.309727CA@kernel>
In-Reply-To: <20110222015338.309727CA@kernel>
Message-Id: <20110222015345.BF949720@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that the mere act of _looking_ at /proc/$pid/smaps will not
destroy transparent huge pages, tell how much of the VMA is
actually mapped with them.

This way, we can make sure that we're getting THPs where we
expect to see them.

v3 - * changed HPAGE_SIZE to HPAGE_PMD_SIZE, probably more correct
       and also has a nice BUG() in case there was a .config mishap
     * remove direct reference to ->page_table_lock, and used the
       passed-in ptl pointer insteadl

Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/proc/task_mmu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/proc/task_mmu.c~teach-smaps-thp fs/proc/task_mmu.c
--- linux-2.6.git/fs/proc/task_mmu.c~teach-smaps-thp	2011-02-21 15:07:55.707591741 -0800
+++ linux-2.6.git-dave/fs/proc/task_mmu.c	2011-02-21 15:07:55.803594580 -0800
@@ -331,6 +331,7 @@ struct mem_size_stats {
 	unsigned long private_dirty;
 	unsigned long referenced;
 	unsigned long anonymous;
+	unsigned long anonymous_thp;
 	unsigned long swap;
 	u64 pss;
 };
@@ -396,6 +397,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 			smaps_pte_entry(*(pte_t *)pmd, addr,
 					HPAGE_PMD_SIZE, walk);
 			spin_unlock(&walk->mm->page_table_lock);
+			mss->anonymous_thp += HPAGE_PMD_SIZE;
 			return 0;
 		}
 	} else {
@@ -444,6 +446,7 @@ static int show_smap(struct seq_file *m,
 		   "Private_Dirty:  %8lu kB\n"
 		   "Referenced:     %8lu kB\n"
 		   "Anonymous:      %8lu kB\n"
+		   "AnonHugePages:  %8lu kB\n"
 		   "Swap:           %8lu kB\n"
 		   "KernelPageSize: %8lu kB\n"
 		   "MMUPageSize:    %8lu kB\n"
@@ -457,6 +460,7 @@ static int show_smap(struct seq_file *m,
 		   mss.private_dirty >> 10,
 		   mss.referenced >> 10,
 		   mss.anonymous >> 10,
+		   mss.anonymous_thp >> 10,
 		   mss.swap >> 10,
 		   vma_kernel_pagesize(vma) >> 10,
 		   vma_mmu_pagesize(vma) >> 10,
diff -puN include/linux/huge_mm.h~teach-smaps-thp include/linux/huge_mm.h
diff -puN mm/memory-failure.c~teach-smaps-thp mm/memory-failure.c
diff -puN mm/huge_memory.c~teach-smaps-thp mm/huge_memory.c
_
