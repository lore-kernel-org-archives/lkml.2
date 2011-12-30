Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab1L3Gg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 01:36:57 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:59496 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751131Ab1L3Ggy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 01:36:54 -0500
From: Tao Ma <tm@tao.ma>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: do not drain pagevecs for mlock
Date: Fri, 30 Dec 2011 14:36:01 +0800
Message-Id: <1325226961-4271-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In our test of mlock, we have found some severe performance regression
in it. Some more investigations show that mlocked is blocked heavily
by lur_add_drain_all which calls schedule_on_each_cpu and flush the work
queue which is very slower if we have several cpus.

So we have tried 2 ways to solve it:
1. Add a per cpu counter for all the pagevecs so that we don't schedule
   and flush the lru_drain work if the cpu doesn't have any pagevecs(I
   have finished the codes already).
2. Remove the lru_add_drain_all.

The first one has some problems since in our product system, all the cpus
are busy, so I guess there is very little chance for a cpu to have 0 pagevecs
except that you run several consecutive mlocks.

>From the commit log which added this function(8891d6da), it seems that we
don't have to call it. So the 2nd one seems to be both easy and workable and
comes this patch.

Thanks
Tao

>From 8cdf7f7ed236367e85151db65ae06f781aca7d77 Mon Sep 17 00:00:00 2001
From: Tao Ma <boyu.mt@taobao.com>
Date: Fri, 30 Dec 2011 14:20:08 +0800
Subject: [PATCH] mm: do not drain pagevecs for mlock

In 8891d6da, lru_add_drain_all is added to mlock to flush all the per
cpu pagevecs. It makes this system call runs much slower than the
predecessor(For a 16 core Xeon E5620, it is around 20 times). And the
the more cores we have, the more the performance penalty because of the
nasty call to schedule_on_each_cpu.

>From the commit log of 8891d6da we can see that "it isn't must.  but it
reduce the failure of moving to unevictable list.  its failure can rescue
in vmscan later." Christoph Lameter removes the call in mlockall(ML_FUTURE),
So this patch just removes all the call from mlock/mlockall.

Without this patch:
time ./test_mlock -c 100000

real    0m20.566s
user    0m0.074s
sys     0m12.759s

With this patch:
time ./test_mlock -c 100000

real	0m1.675s
user	0m0.049s
sys	0m1.622s

Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 mm/mlock.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 4f4f53b..bb5fc42 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -487,8 +487,6 @@ SYSCALL_DEFINE2(mlock, unsigned long, start, size_t, len)
 	if (!can_do_mlock())
 		return -EPERM;
 
-	lru_add_drain_all();	/* flush pagevec */
-
 	down_write(&current->mm->mmap_sem);
 	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
 	start &= PAGE_MASK;
@@ -557,9 +555,6 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	if (!can_do_mlock())
 		goto out;
 
-	if (flags & MCL_CURRENT)
-		lru_add_drain_all();	/* flush pagevec */
-
 	down_write(&current->mm->mmap_sem);
 
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
-- 
1.7.4.1

