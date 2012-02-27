Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab2B0H4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 02:56:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61173 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab2B0H4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 02:56:34 -0500
Message-ID: <4F4B383C.1000804@cn.fujitsu.com>
Date: Mon, 27 Feb 2012 16:01:00 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH 1/2 RFC] srcu: change the comments of the wait algorithm
References: <20120213020951.GA12138@linux.vnet.ibm.com> <4F41F315.1040900@cn.fujitsu.com> <20120220174418.GI2470@linux.vnet.ibm.com> <4F42EF53.6060400@cn.fujitsu.com> <20120221015037.GE2384@linux.vnet.ibm.com> <4F435966.9020106@cn.fujitsu.com> <20120221172442.GG2375@linux.vnet.ibm.com> <4F44B580.6040003@cn.fujitsu.com> <4F4744E9.1060109@cn.fujitsu.com> <20120224200109.GH2399@linux.vnet.ibm.com>
In-Reply-To: <20120224200109.GH2399@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-27 15:54:38,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-27 15:54:44,
	Serialize complete at 2012-02-27 15:54:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, ALL

The call_srcu() will be sent soon(may be in 2 days). I found something is not
good in current sruc when I implement it, so I do more prepare for it.

The second patch is inspired Peter. I had decided to use per-cpu machine,
the the snap array makes me unhappy. If a machine is sleeping/preempted
while checking, the other machine can't not check the same srcu_struct.
It is nothing big, but it also blocks the sychronize_srcu_expedited().
I hope sychronize_srcu_expedited() can't be blocked when it try to do its
fast-checking. So I try to find non-block checking algorithm, and I find
Peter's.

The most things in these two patches are comments, so I bring a lot
troubles to Paul because my poor English.

Thanks,
Lai

>From 77af819872ddab065d3a46758471b80f31b30e5e Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Mon, 27 Feb 2012 10:52:00 +0800
Subject: [PATCH 1/2] srcu: change the comments of the wait algorithm

The original comments does not describe the essential of the wait algorithm
well.

The safe of srcu-protected data and srcu critical section is provided by
wait_idx(), not the flipping.

The two index of the active counter array and the flipping are just used to keep
the wait_idx() from starvation.
(the flip also provides "only one srcu_read_lock() at most after flip
for every cpu", this coupling will be remove in future(next patch))

The code will be split as pieces between every machine-states for call_srcu(),
It is very hard to provide the exactly semantics as original comments,
So I have to consider the exactly what the algorithm, and I change this
comments.

The code is not changed, but it is refactored a little.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/srcu.c |   75 +++++++++++++++++++++++++++++----------------------------
 1 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index b6b9ea2..47ee35d 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -249,6 +249,10 @@ EXPORT_SYMBOL_GPL(__srcu_read_unlock);
  */
 #define SYNCHRONIZE_SRCU_READER_DELAY 5
 
+/*
+ * Wait until all the readers(which starts before this wait_idx()
+ * with the specified idx) complete.
+ */
 static void wait_idx(struct srcu_struct *sp, int idx, bool expedited)
 {
 	int trycount = 0;
@@ -291,24 +295,9 @@ static void wait_idx(struct srcu_struct *sp, int idx, bool expedited)
 	smp_mb(); /* E */
 }
 
-/*
- * Flip the readers' index by incrementing ->completed, then wait
- * until there are no more readers using the counters referenced by
- * the old index value.  (Recall that the index is the bottom bit
- * of ->completed.)
- *
- * Of course, it is possible that a reader might be delayed for the
- * full duration of flip_idx_and_wait() between fetching the
- * index and incrementing its counter.  This possibility is handled
- * by the next __synchronize_srcu() invoking wait_idx() for such readers
- * before starting a new grace period.
- */
-static void flip_idx_and_wait(struct srcu_struct *sp, bool expedited)
+static void srcu_flip(struct srcu_struct *sp)
 {
-	int idx;
-
-	idx = sp->completed++ & 0x1;
-	wait_idx(sp, idx, expedited);
+	sp->completed++;
 }
 
 /*
@@ -316,6 +305,8 @@ static void flip_idx_and_wait(struct srcu_struct *sp, bool expedited)
  */
 static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
 {
+	int busy_idx;
+
 	rcu_lockdep_assert(!lock_is_held(&sp->dep_map) &&
 			   !lock_is_held(&rcu_bh_lock_map) &&
 			   !lock_is_held(&rcu_lock_map) &&
@@ -323,8 +314,31 @@ static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
 			   "Illegal synchronize_srcu() in same-type SRCU (or RCU) read-side critical section");
 
 	mutex_lock(&sp->mutex);
+	busy_idx = sp->completed & 0X1UL;
 
 	/*
+	 * There are some readers start with idx=0, and some others start
+	 * with idx=1. So two wait_idx()s are enough for synchronize:
+	 * __synchronize_srcu() {
+	 * 	wait_idx(sp, 0, expedited);
+	 * 	wait_idx(sp, 1, expedited);
+	 * }
+	 * When it returns, all started readers have complete.
+	 *
+	 * But synchronizer may be starved by the readers, example,
+	 * if sp->complete & 0x1L == 1, wait_idx(sp, 1, expedited)
+	 * may not returns if there are continuous readers start
+	 * with idx=1.
+	 *
+	 * So we need to flip the busy index to keep synchronizer
+	 * from starvation.
+	 */
+
+	/*
+	 * The above comments assume we have readers with all the
+	 * 2 idx. It does have this probability, some readers may
+	 * hold the reader lock with idx=1-busy_idx:
+	 *
 	 * Suppose that during the previous grace period, a reader
 	 * picked up the old value of the index, but did not increment
 	 * its counter until after the previous instance of
@@ -333,31 +347,18 @@ static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
 	 * not start until after the grace period started, so the grace
 	 * period was not obligated to wait for that reader.
 	 *
-	 * However, the current SRCU grace period does have to wait for
-	 * that reader.  This is handled by invoking wait_idx() on the
-	 * non-active set of counters (hence sp->completed - 1).  Once
-	 * wait_idx() returns, we know that all readers that picked up
-	 * the old value of ->completed and that already incremented their
-	 * counter will have completed.
-	 *
-	 * But what about readers that picked up the old value of
-	 * ->completed, but -still- have not managed to increment their
-	 * counter?  We do not need to wait for those readers, because
-	 * they will have started their SRCU read-side critical section
-	 * after the current grace period starts.
-	 *
-	 * Because it is unlikely that readers will be preempted between
-	 * fetching ->completed and incrementing their counter, wait_idx()
+	 * Because this probability is not high, wait_idx()
 	 * will normally not need to wait.
 	 */
-	wait_idx(sp, (sp->completed - 1) & 0x1, expedited);
+	wait_idx(sp, 1 - busy_idx, expedited);
+
+	/* flip the index to ensure the return of the next wait_idx() */
+	srcu_flip(sp);
 
 	/*
-	 * Now that wait_idx() has waited for the really old readers,
-	 * invoke flip_idx_and_wait() to flip the counter and wait
-	 * for current SRCU readers.
+	 * Now that wait_idx() has waited for the really old readers.
 	 */
-	flip_idx_and_wait(sp, expedited);
+	wait_idx(sp, busy_idx, expedited);
 
 	mutex_unlock(&sp->mutex);
 }
-- 
1.7.4.4

