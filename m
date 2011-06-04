Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1FDDht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 23:37:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35284 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1FDDhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 23:37:48 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=VUDIEJBJquMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=YGFnJ5G85GF5oUsSMfcA:9 a=rD5FMbv_CLih_J9HK78A:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH] mm: Fix wrong kunmap_atomic() pointer
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Jun 2011 23:37:45 -0400
Message-ID: <1307158665.3667.86.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running a ktest.pl test, I hit the following bug on x86_32:

/bin/sh: line 41------------[ cut here ]------------
: /proc/meminfo:WARNING: at /home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/mm/highmem_32.c:81 __kunmap_atomic+0x64/0xc1()
 No such file orHardware name:         
 directory
/binModules linked in:/sh: line 42: [:
Pid: 93, comm: sh Not tainted 2.6.39-test+ #1
Call Trace:
 [<c04450da>] warn_slowpath_common+0x7c/0x91
 [<c042f5df>] ? __kunmap_atomic+0x64/0xc1
 [<c042f5df>] ? __kunmap_atomic+0x64/0xc1^M
 [<c0445111>] warn_slowpath_null+0x22/0x24
 [<c042f5df>] __kunmap_atomic+0x64/0xc1
 [<c04d4a22>] unmap_vmas+0x43a/0x4e0
 [<c04d9065>] exit_mmap+0x91/0xd2
 [<c0443057>] mmput+0x43/0xad
 [<c0448358>] exit_mm+0x111/0x119
 [<c044855f>] do_exit+0x1ff/0x5fa
 too many argume [<c0454ea2>] ? set_current_blocked+0x3c/0x40
 [<c0454f24>] ? sigprocmask+0x7e/0x8e
 [<c0448b55>] do_group_exit+0x65/0x88
 [<c0448b90>] sys_exit_group+0x18/0x1c
 [<c0c3915f>] sysenter_do_call+0x12/0x38
---[ end trace 8055f74ea3c0eb62 ]---^M

Running a ktest.pl git bisect, found the culprit commit:

e303297e6 mm: extended batches for generic mmu_gather

But although this was the commit triggering the bug, it was not the one
originally responsible for the bug. That was:

d16dfc55 mm: mmu_gather rework

The code in zap_pte_range() has something that looks like the following:

	pte =  pte_offset_map_lock(mm, pmd, addr, &ptl);
	do {
		[...]
	} while (pte++, addr += PAGE_SIZE, addr != end);
	pte_unmap_unlock(pte - 1, ptl);

The pte starts off pointing at the first element in the page table
directory that was returned by the pte_offset_map_lock(). When it's done
with the page, pte will be pointing to anything between the next entry
and the first entry of the next page inclusive. By doing a pte - 1, this
puts the pte back onto the original page, which is all that
pte_unmap_unlock() needs.

In most archs (64 bit), this is not an issue as the pte is ignored in
the pte_unmap_unlock(). But on 32 bit archs, where things may be
kmapped, it is essential that the pte passed to pte_unmap_unlock()
resides on the same page that was given by pte_offest_map_lock().

The problem came in d16dfc55 where it introduced a "break;" from the
while loop. This alone did not seem to easily trigger the bug. But the
modifications made by e303297e6 caused that "break;" to be hit on the
first iteration, before the pte++.

The pte not being incremented will now cause pte_unmap_unlock(pte - 1)
to be pointing to the previous page. This will cause the wrong page to
be unmapped, and also trigger the warning above.

The simple solution is to just save the pointer given by
pte_offset_map_lock() and use it in the unlock.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/mm/memory.c b/mm/memory.c
index 6953d39..922dcd6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1112,11 +1112,13 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	int force_flush = 0;
 	int rss[NR_MM_COUNTERS];
 	spinlock_t *ptl;
+	pte_t *start_pte;
 	pte_t *pte;
 
 again:
 	init_rss_vec(rss);
-	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	start_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	pte = start_pte;
 	arch_enter_lazy_mmu_mode();
 	do {
 		pte_t ptent = *pte;
@@ -1196,7 +1198,7 @@ again:
 
 	add_mm_rss_vec(mm, rss);
 	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(pte - 1, ptl);
+	pte_unmap_unlock(start_pte, ptl);
 
 	/*
 	 * mmu_gather ran out of room to batch pages, we break out of


