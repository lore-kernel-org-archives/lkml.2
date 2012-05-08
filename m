Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab2EHWbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:31:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59590 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab2EHWbQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:31:16 -0400
Message-ID: <1336516260.8226.61.camel@twins>
Subject: Re: linux-next oops in __lock_acquire for process_one_work
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 09 May 2012 00:31:00 +0200
In-Reply-To: <alpine.LSU.2.00.1205081106160.4071@eggly.anvils>
References: <alpine.LSU.2.00.1205070951170.1544@eggly.anvils>
	 <20120507175743.GC19417@google.com> <1336482202.16236.29.camel@twins>
	 <20120508165819.GB10687@google.com>
	 <alpine.LSU.2.00.1205081106160.4071@eggly.anvils>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 11:11 -0700, Hugh Dickins wrote:
> Please send me the version of patch you'd like to put in
> (lest I make it up myself and you don't like the result).

something like so?

---
 include/linux/lockdep.h |   17 +++++++++++++++++
 kernel/timer.c          |    4 +++-
 kernel/workqueue.c      |    4 +++-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index d36619e..968c3e2 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -157,6 +157,23 @@ struct lockdep_map {
 #endif
 };
 
+static inline void lockdep_copy_map(struct lockdep_map *to struct lockdep_map *from)
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
index a297ffc..6aa7ad8 100644
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
index 5abf42f..7d77d1f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1810,7 +1810,9 @@ __acquires(&gcwq->lock)
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

