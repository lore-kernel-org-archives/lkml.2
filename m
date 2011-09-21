Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab1IUWNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 18:13:43 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52102 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab1IUWNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 18:13:39 -0400
Subject: [RFC][PATCH] show page size in /proc/$pid/numa_maps
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 21 Sep 2011 15:13:29 -0700
Message-Id: <20110921221329.5B7EE5C5@kernel>
x-cbid: 11092122-8974-0000-0000-00000053D170
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The output of /proc/$pid/numa_maps is in terms of number of pages
like anon=22 or dirty=54.  Here's some output:

7f4680000000 default file=/hugetlb/bigfile anon=50 dirty=50 N0=50
7f7659600000 default file=/anon_hugepage\040(deleted) anon=50 dirty=50 N0=50
7fff8d425000 default stack anon=50 dirty=50 N0=50

Looks like we have a stack and a couple of anonymous hugetlbfs
areas page which both use the same amount of memory.  They don't.

The 'bigfile' uses 1GB pages and takes up ~50GB of space.  The
anon_hugepage uses 2MB pages and takes up ~100MB of space while
the stack uses normal 4k pages.  You can go over to smaps to
figure out what the page size _really_ is with KernelPageSize
or MMUPageSize.  But, I think this is a pretty nasty and
counterintuitive interface as it stands.

The following patch adds a pagemult= field.  It is placed only
in cases where the VMA's page size differs from the base kernel
page size.  I'm calling it pagemult to emphasize that it is
indended to modify the statistics output rather than _really_
show the page size that the kernel or MMU is using.

Signed-off-by: Dave Haneen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/proc/task_mmu.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/proc/task_mmu.c~show-page-size fs/proc/task_mmu.c
--- linux-2.6.git/fs/proc/task_mmu.c~show-page-size	2011-09-21 15:05:49.846739432 -0700
+++ linux-2.6.git-dave/fs/proc/task_mmu.c	2011-09-21 15:10:26.798329158 -0700
@@ -1007,6 +1007,7 @@ static int show_numa_map(struct seq_file
 	struct mm_struct *mm = vma->vm_mm;
 	struct mm_walk walk = {};
 	struct mempolicy *pol;
+	unsigned long pagesize_multiplier;
 	int n;
 	char buffer[50];
 
@@ -1044,6 +1045,12 @@ static int show_numa_map(struct seq_file
 	if (!md->pages)
 		goto out;
 
+	/* This will only really do something for hugetlbfs pages.
+	 * Transparent hugepages are still pagemult=1 */
+	pagesize_multiplier = vma_kernel_pagesize(vma) / PAGE_SIZE;
+	if (pagesize_multiplier > 1)
+		seq_printf(m, " pagemult=%lu", pagesize_multiplier);
+
 	if (md->anon)
 		seq_printf(m, " anon=%lu", md->anon);
 
_

