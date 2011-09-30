Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab1I3Ucs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:32:48 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56625 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab1I3Ucc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:32:32 -0400
Subject: [RFCv2][PATCH 4/4] show page size in /proc/$pid/numa_maps
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 30 Sep 2011 13:32:23 -0700
References: <20110930203219.60D507CB@kernel>
In-Reply-To: <20110930203219.60D507CB@kernel>
Message-Id: <20110930203223.D2196A31@kernel>
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

The following patch adds a pagesize= field.  Note that this only
shows the kernel's notion of page size.  For transparent
hugepages, it still shows the base page size.  Here's some real
output.  Note the anon_hugepage in there.

# cat /proc/`pidof memknobs`/numa_maps
00400000 default file=/root/memknobs pagesize=4KiB dirty=3 active=2 N0=3
00602000 default file=/root/memknobs pagesize=4KiB anon=1 dirty=1 N0=1
00603000 default file=/root/memknobs pagesize=4KiB anon=1 dirty=1 N0=1
00604000 default heap pagesize=4KiB anon=6 dirty=6 N0=6
7f6766216000 default file=/lib/libc-2.9.so pagesize=4KiB mapped=98 mapmax=25 active=97 N0=98
7f676637e000 default file=/lib/libc-2.9.so
7f676657e000 default file=/lib/libc-2.9.so pagesize=4KiB anon=4 dirty=4 N0=4
7f6766582000 default file=/lib/libc-2.9.so pagesize=4KiB anon=1 dirty=1 N0=1
7f6766583000 default pagesize=4KiB anon=3 dirty=3 N0=3
7f6766588000 default file=/lib/ld-2.9.so pagesize=4KiB mapped=25 mapmax=24 N0=25
7f676679d000 default pagesize=4KiB anon=2 dirty=2 N0=2
7f67667a3000 default pagesize=4KiB anon=4 dirty=4 N0=4
7f67667a7000 default file=/lib/ld-2.9.so pagesize=4KiB anon=1 dirty=1 N0=1
7f67667a8000 default file=/lib/ld-2.9.so pagesize=4KiB anon=1 dirty=1 N0=1
7f6766800000 default file=/anon_hugepage\040(deleted) pagesize=2MiB anon=10 dirty=10 N0=10
7fff5b948000 default stack pagesize=4KiB anon=2 dirty=2 N0=2
7fff5b96d000 default

Signed-off-by: Dave Haneen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/proc/task_mmu.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/proc/task_mmu.c~show-page-size fs/proc/task_mmu.c
--- linux-2.6.git/fs/proc/task_mmu.c~show-page-size	2011-09-30 13:27:55.973467993 -0700
+++ linux-2.6.git-dave/fs/proc/task_mmu.c	2011-09-30 13:27:55.981467979 -0700
@@ -1044,6 +1044,11 @@ static int show_numa_map(struct seq_file
 	if (!md->pages)
 		goto out;
 
+	/* Only interesting for hugetlbfs pages.
+	 * Transparent hugepages are still pagesize=4k */
+	seq_puts(m, " pagesize=");
+	seq_print_pow2(m, vma_kernel_pagesize(vma));
+
 	if (md->anon)
 		seq_printf(m, " anon=%lu", md->anon);
 
_
