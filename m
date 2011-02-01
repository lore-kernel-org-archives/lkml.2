Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab1BAAe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 19:34:56 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:38313 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab1BAAeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 19:34:07 -0500
Subject: [RFC][PATCH 6/6] have smaps show transparent huge pages
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 31 Jan 2011 16:34:05 -0800
References: <20110201003357.D6F0BE0D@kernel>
In-Reply-To: <20110201003357.D6F0BE0D@kernel>
Message-Id: <20110201003405.FC58B813@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that the mere act of _looking_ at /proc/$pid/smaps will not
destroy transparent huge pages, tell how much of the VMA is
actually mapped with them.

This way, we can make sure that we're getting THPs where we
expect to see them.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/proc/task_mmu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/proc/task_mmu.c~teach-smaps-thp fs/proc/task_mmu.c
--- linux-2.6.git/fs/proc/task_mmu.c~teach-smaps-thp	2011-01-31 16:25:15.948685305 -0800
+++ linux-2.6.git-dave/fs/proc/task_mmu.c	2011-01-31 16:25:34.600671992 -0800
@@ -331,6 +331,7 @@ struct mem_size_stats {
 	unsigned long private_dirty;
 	unsigned long referenced;
 	unsigned long anonymous;
+	unsigned long anonymous_thp;
 	unsigned long swap;
 	u64 pss;
 };
@@ -394,6 +395,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 			spin_lock(&walk->mm->page_table_lock);
 			goto normal_ptes;
 		}
+		mss->anonymous_thp += HPAGE_SIZE;
 		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_SIZE, walk);
 		return 0;
 	}
@@ -438,6 +440,7 @@ static int show_smap(struct seq_file *m,
 		   "Private_Dirty:  %8lu kB\n"
 		   "Referenced:     %8lu kB\n"
 		   "Anonymous:      %8lu kB\n"
+		   "AnonHugePages:  %8lu kB\n"
 		   "Swap:           %8lu kB\n"
 		   "KernelPageSize: %8lu kB\n"
 		   "MMUPageSize:    %8lu kB\n"
@@ -451,6 +454,7 @@ static int show_smap(struct seq_file *m,
 		   mss.private_dirty >> 10,
 		   mss.referenced >> 10,
 		   mss.anonymous >> 10,
+		   mss.anonymous_thp >> 10,
 		   mss.swap >> 10,
 		   vma_kernel_pagesize(vma) >> 10,
 		   vma_mmu_pagesize(vma) >> 10,
_
