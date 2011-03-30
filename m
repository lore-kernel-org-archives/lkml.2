Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965175Ab1C3VJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:9067 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965153Ab1C3VJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133923"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: aaro.koskinen@nokia.com, ak@linux.intel.com,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [228/275] procfs: fix /proc/<pid>/maps heap check
Message-Id: <20110330210753.C33003E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Aaro Koskinen <aaro.koskinen@nokia.com>

commit 0db0c01b53a1a421513f91573241aabafb87802a upstream.

The current code fails to print the "[heap]" marking if the heap is split
into multiple mappings.

Fix the check so that the marking is displayed in all possible cases:
	1. vma matches exactly the heap
	2. the heap vma is merged e.g. with bss
	3. the heap vma is splitted e.g. due to locked pages

Test cases. In all cases, the process should have mapping(s) with
[heap] marking:

	(1) vma matches exactly the heap

	#include <stdio.h>
	#include <unistd.h>
	#include <sys/types.h>

	int main (void)
	{
		if (sbrk(4096) != (void *)-1) {
			printf("check /proc/%d/maps\n", (int)getpid());
			while (1)
				sleep(1);
		}
		return 0;
	}

	# ./test1
	check /proc/553/maps
	[1] + Stopped                    ./test1
	# cat /proc/553/maps | head -4
	00008000-00009000 r-xp 00000000 01:00 3113640    /test1
	00010000-00011000 rw-p 00000000 01:00 3113640    /test1
	00011000-00012000 rw-p 00000000 00:00 0          [heap]
	4006f000-40070000 rw-p 00000000 00:00 0

	(2) the heap vma is merged

	#include <stdio.h>
	#include <unistd.h>
	#include <sys/types.h>

	char foo[4096] = "foo";
	char bar[4096];

	int main (void)
	{
		if (sbrk(4096) != (void *)-1) {
			printf("check /proc/%d/maps\n", (int)getpid());
			while (1)
				sleep(1);
		}
		return 0;
	}

	# ./test2
	check /proc/556/maps
	[2] + Stopped                    ./test2
	# cat /proc/556/maps | head -4
	00008000-00009000 r-xp 00000000 01:00 3116312    /test2
	00010000-00012000 rw-p 00000000 01:00 3116312    /test2
	00012000-00014000 rw-p 00000000 00:00 0          [heap]
	4004a000-4004b000 rw-p 00000000 00:00 0

	(3) the heap vma is splitted (this fails without the patch)

	#include <stdio.h>
	#include <unistd.h>
	#include <sys/mman.h>
	#include <sys/types.h>

	int main (void)
	{
		if ((sbrk(4096) != (void *)-1) && !mlockall(MCL_FUTURE) &&
		    (sbrk(4096) != (void *)-1)) {
			printf("check /proc/%d/maps\n", (int)getpid());
			while (1)
				sleep(1);
		}
		return 0;
	}

	# ./test3
	check /proc/559/maps
	[1] + Stopped                    ./test3
	# cat /proc/559/maps|head -4
	00008000-00009000 r-xp 00000000 01:00 3119108    /test3
	00010000-00011000 rw-p 00000000 01:00 3119108    /test3
	00011000-00012000 rw-p 00000000 00:00 0          [heap]
	00012000-00013000 rw-p 00000000 00:00 0          [heap]

It looks like the bug has been there forever, and since it only results in
some information missing from a procfile, it does not fulfil the -stable
"critical issue" criteria.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/fs/proc/task_mmu.c
===================================================================
--- linux-2.6.35.y.orig/fs/proc/task_mmu.c	2011-03-29 22:50:24.508631304 -0700
+++ linux-2.6.35.y/fs/proc/task_mmu.c	2011-03-29 23:03:02.979223940 -0700
@@ -248,8 +248,8 @@
 		const char *name = arch_vma_name(vma);
 		if (!name) {
 			if (mm) {
-				if (vma->vm_start <= mm->start_brk &&
-						vma->vm_end >= mm->brk) {
+				if (vma->vm_start <= mm->brk &&
+						vma->vm_end >= mm->start_brk) {
 					name = "[heap]";
 				} else if (vma->vm_start <= mm->start_stack &&
 					   vma->vm_end >= mm->start_stack) {
