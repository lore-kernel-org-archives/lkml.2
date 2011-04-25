Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab1DYUl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:41:56 -0400
Received: from 1wt.eu ([62.212.114.60]:34344 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284Ab1DYUYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:54 -0400
Message-Id: <20110425200237.599188976@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Aaro Koskinen <aaro.koskinen@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 106/173] procfs: fix /proc/<pid>/maps heap check
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -244,8 +244,8 @@ static void show_map_vma(struct seq_file
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


