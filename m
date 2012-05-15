Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965037Ab2EOPLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:11:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64723 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965010Ab2EOPLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:11:02 -0400
Date: Tue, 15 May 2012 08:10:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] lockdep: fix oops in processing workqueue
Message-ID: <20120515151048.GA6119@google.com>
References: <1336482202.16236.29.camel@twins>
 <20120508165819.GB10687@google.com>
 <alpine.LSU.2.00.1205081106160.4071@eggly.anvils>
 <1336516260.8226.61.camel@twins>
 <alpine.LSU.2.00.1205081553250.4497@eggly.anvils>
 <20120509092536.GC8585@gmail.com>
 <alpine.LSU.2.00.1205091219590.20881@eggly.anvils>
 <alpine.LSU.2.00.1205101049460.17714@eggly.anvils>
 <20120514212753.GM2366@google.com>
 <1337080288.27694.38.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337080288.27694.38.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4d82a1debbffec129cc387aafa8f40b7bbab3297 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 15 May 2012 08:06:19 -0700

Under memory load, on x86_64, with lockdep enabled, the workqueue's
process_one_work() has been seen to oops in __lock_acquire(), barfing
on a 0xffffffff00000000 pointer in the lockdep_map's class_cache[].

Because it's permissible to free a work_struct from its callout function,
the map used is an onstack copy of the map given in the work_struct: and
that copy is made without any locking.

Surprisingly, gcc (4.5.1 in Hugh's case) uses "rep movsl" rather than
"rep movsq" for that structure copy: which might race with a workqueue
user's wait_on_work() doing lock_map_acquire() on the source of the
copy, putting a pointer into the class_cache[], but only in time for
the top half of that pointer to be copied to the destination map.

Boom when process_one_work() subsequently does lock_map_acquire()
on its onstack copy of the lockdep_map.

Fix this, and a similar instance in call_timer_fn(), with a
lockdep_copy_map() function which additionally NULLs the class_cache[].

Note: this oops was actually seen on 3.4-next, where flush_work() newly
does the racing lock_map_acquire(); but Tejun points out that 3.4 and
earlier are already vulnerable to the same through wait_on_work().

* Patch orginally from Peter.  Hugh modified it a bit and wrote the
  description.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Reported-by: Hugh Dickins <hughd@google.com>
LKML-Reference: <alpine.LSU.2.00.1205070951170.1544@eggly.anvils>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to wq/for-3.5 with the function decl broken in traditional
way.

Thanks.

 include/linux/lockdep.h |   18 ++++++++++++++++++
 kernel/timer.c          |    4 +++-
 kernel/workqueue.c      |    4 +++-
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index d36619e..00e4637 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -157,6 +157,24 @@ struct lockdep_map {
 #endif
 };
 
+static inline void lockdep_copy_map(struct lockdep_map *to,
+				    struct lockdep_map *from)
+{
+	int i;
+
+	*to = *from;
+	/*
+	 * Since the class cache can be modified concurrently we could observe
+	 * half pointers (64bit arch using 32bit copy insns). Therefore clear
+	 * the caches and take the performance hit.
+	 *
+	 * XXX it doesn't work well with lockdep_set_class_and_subclass(), since
+	 *     that relies on cache abuse.
+	 */
+	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
+		to->class_cache[i] = NULL;
+}
+
 /*
  * Every lock has a list of other locks that were taken after it.
  * We only grow the list, never remove from it:
diff --git a/kernel/timer.c b/kernel/timer.c
index a297ffc..b123852 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1102,7 +1102,9 @@ static void call_timer_fn(struct timer_list *timer, void (*fn)(unsigned long),
 	 * warnings as well as problems when looking into
 	 * timer->lockdep_map, make a copy and use that here.
 	 */
-	struct lockdep_map lockdep_map = timer->lockdep_map;
+	struct lockdep_map lockdep_map;
+
+	lockdep_copy_map(&lockdep_map, &timer->lockdep_map);
 #endif
 	/*
 	 * Couple the lock chain with the lock chain at
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c36c86c..9a3128d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1818,7 +1818,9 @@ __acquires(&gcwq->lock)
 	 * lock freed" warnings as well as problems when looking into
 	 * work->lockdep_map, make a copy and use that here.
 	 */
-	struct lockdep_map lockdep_map = work->lockdep_map;
+	struct lockdep_map lockdep_map;
+
+	lockdep_copy_map(&lockdep_map, &work->lockdep_map);
 #endif
 	/*
 	 * A single work shouldn't be executed concurrently by
-- 
1.7.7.3

