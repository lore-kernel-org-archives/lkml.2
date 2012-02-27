Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2B0H4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 02:56:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63599 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab2B0H4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 02:56:35 -0500
Message-ID: <4F4B3840.6000504@cn.fujitsu.com>
Date: Mon, 27 Feb 2012 16:01:04 +0800
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
Subject: [PATCH 2/2 RFC] srcu: implement Peter's checking algorithm
References: <20120213020951.GA12138@linux.vnet.ibm.com> <4F41F315.1040900@cn.fujitsu.com> <20120220174418.GI2470@linux.vnet.ibm.com> <4F42EF53.6060400@cn.fujitsu.com> <20120221015037.GE2384@linux.vnet.ibm.com> <4F435966.9020106@cn.fujitsu.com> <20120221172442.GG2375@linux.vnet.ibm.com> <4F44B580.6040003@cn.fujitsu.com> <4F4744E9.1060109@cn.fujitsu.com> <20120224200109.GH2399@linux.vnet.ibm.com>
In-Reply-To: <20120224200109.GH2399@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-27 15:54:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-27 15:54:47,
	Serialize complete at 2012-02-27 15:54:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 40724998e2d121c2b5a5bd75114625cfd9d4f9a9 Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Mon, 27 Feb 2012 14:22:47 +0800
Subject: [PATCH 2/2] srcu: implement Peter's checking algorithm

This patch implement the algorithm as Peter's:
https://lkml.org/lkml/2012/2/1/119

o	Make the checking lock-free and we can perform parallel checking,
	Although almost parallel checking makes no sense, but we need it
	when 1) the original checking task is preempted for long, 2)
	sychronize_srcu_expedited(), 3) avoid lock(see next)

o	Since it is lock-free, we save a mutex in state machine for
	call_srcu().

o	Remove the SRCU_REF_MASK and remove the coupling with the flipping.
	(so we can remove the preempt_disable() in future, but use
	 __this_cpu_inc() instead.)

o	reduce a smp_mb(), simplify the comments and make the smp_mb() pairs
	more intuitive.

Inspired-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/srcu.h |    7 +--
 kernel/srcu.c        |  137 ++++++++++++++++++++-----------------------------
 2 files changed, 57 insertions(+), 87 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 5b49d41..15354db 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -32,18 +32,13 @@
 
 struct srcu_struct_array {
 	unsigned long c[2];
+	unsigned long seq[2];
 };
 
-/* Bit definitions for field ->c above and ->snap below. */
-#define SRCU_USAGE_BITS		1
-#define SRCU_REF_MASK		(ULONG_MAX >> SRCU_USAGE_BITS)
-#define SRCU_USAGE_COUNT	(SRCU_REF_MASK + 1)
-
 struct srcu_struct {
 	unsigned completed;
 	struct srcu_struct_array __percpu *per_cpu_ref;
 	struct mutex mutex;
-	unsigned long snap[NR_CPUS];
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 47ee35d..376b583 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -73,10 +73,25 @@ EXPORT_SYMBOL_GPL(init_srcu_struct);
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /*
+ * Returns approximate total sequence of readers on the specified rank
+ * of per-CPU counters.
+ */
+static unsigned long srcu_readers_seq_idx(struct srcu_struct *sp, int idx)
+{
+	int cpu;
+	unsigned long sum = 0;
+	unsigned long t;
+
+	for_each_possible_cpu(cpu) {
+		t = ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, cpu)->seq[idx]);
+		sum += t;
+	}
+	return sum;
+}
+
+/*
  * Returns approximate number of readers active on the specified rank
- * of per-CPU counters.  Also snapshots each counter's value in the
- * corresponding element of sp->snap[] for later use validating
- * the sum.
+ * of per-CPU counters.
  */
 static unsigned long srcu_readers_active_idx(struct srcu_struct *sp, int idx)
 {
@@ -87,26 +102,36 @@ static unsigned long srcu_readers_active_idx(struct srcu_struct *sp, int idx)
 	for_each_possible_cpu(cpu) {
 		t = ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, cpu)->c[idx]);
 		sum += t;
-		sp->snap[cpu] = t;
 	}
-	return sum & SRCU_REF_MASK;
+	return sum;
 }
 
-/*
- * To be called from the update side after an index flip.  Returns true
- * if the modulo sum of the counters is stably zero, false if there is
- * some possibility of non-zero.
- */
 static bool srcu_readers_active_idx_check(struct srcu_struct *sp, int idx)
 {
 	int cpu;
+	unsigned long seq;
+
+	seq = srcu_readers_seq_idx(sp, idx);
+
+	/*
+	 * smp_mb() A pairs with smp_mb() B for critical section.
+	 * It ensures that the SRCU read-side critical section whose
+	 * read-lock is not seen by the following srcu_readers_active_idx()
+	 * will see any updates that before the current task performed before.
+	 * (So we don't need to care these readers this time)
+	 *
+	 * Also, if we see the increment of the seq, we must see the
+	 * increment of the active counter in the following
+	 * srcu_readers_active_idx().
+	 */
+	smp_mb(); /* A */
 
 	/*
 	 * Note that srcu_readers_active_idx() can incorrectly return
 	 * zero even though there is a pre-existing reader throughout.
 	 * To see this, suppose that task A is in a very long SRCU
 	 * read-side critical section that started on CPU 0, and that
-	 * no other reader exists, so that the modulo sum of the counters
+	 * no other reader exists, so that the sum of the counters
 	 * is equal to one.  Then suppose that task B starts executing
 	 * srcu_readers_active_idx(), summing up to CPU 1, and then that
 	 * task C starts reading on CPU 0, so that its increment is not
@@ -122,53 +147,26 @@ static bool srcu_readers_active_idx_check(struct srcu_struct *sp, int idx)
 		return false;
 
 	/*
-	 * Since the caller recently flipped ->completed, we can see at
-	 * most one increment of each CPU's counter from this point
-	 * forward.  The reason for this is that the reader CPU must have
-	 * fetched the index before srcu_readers_active_idx checked
-	 * that CPU's counter, but not yet incremented its counter.
-	 * Its eventual counter increment will follow the read in
-	 * srcu_readers_active_idx(), and that increment is immediately
-	 * followed by smp_mb() B.  Because smp_mb() D is between
-	 * the ->completed flip and srcu_readers_active_idx()'s read,
-	 * that CPU's subsequent load of ->completed must see the new
-	 * value, and therefore increment the counter in the other rank.
-	 */
-	smp_mb(); /* A */
-
-	/*
-	 * Now, we check the ->snap array that srcu_readers_active_idx()
-	 * filled in from the per-CPU counter values. Since
-	 * __srcu_read_lock() increments the upper bits of the per-CPU
-	 * counter, an increment/decrement pair will change the value
-	 * of the counter.  Since there is only one possible increment,
-	 * the only way to wrap the counter is to have a huge number of
-	 * counter decrements, which requires a huge number of tasks and
-	 * huge SRCU read-side critical-section nesting levels, even on
-	 * 32-bit systems.
-	 *
-	 * All of the ways of confusing the readings require that the scan
-	 * in srcu_readers_active_idx() see the read-side task's decrement,
-	 * but not its increment.  However, between that decrement and
-	 * increment are smb_mb() B and C.  Either or both of these pair
-	 * with smp_mb() A above to ensure that the scan below will see
-	 * the read-side tasks's increment, thus noting a difference in
-	 * the counter values between the two passes.
+	 * Validation step, smp_mb() D pairs with smp_mb() C. If the above
+	 * srcu_readers_active_idx() see a decrement of the active counter
+	 * in srcu_read_unlock(), it should see one of these for corresponding
+	 * srcu_read_lock():
+	 * 	See the increment of the active counter,
+	 * 	Failed to see the increment of the active counter.
+	 * The second one can cause srcu_readers_active_idx() incorrectly
+	 * return zero, but it means the above srcu_readers_seq_idx() does not
+	 * see the increment of the seq(ref: comments of smp_mb() A),
+	 * and the following srcu_readers_seq_idx() sees the increment of
+	 * the seq. The seq is changed.
 	 *
-	 * Therefore, if srcu_readers_active_idx() returned zero, and
-	 * none of the counters changed, we know that the zero was the
-	 * correct sum.
-	 *
-	 * Of course, it is possible that a task might be delayed
-	 * for a very long time in __srcu_read_lock() after fetching
-	 * the index but before incrementing its counter.  This
-	 * possibility will be dealt with in __synchronize_srcu().
+	 * This smp_mb() D pairs with smp_mb() C for critical section.
+	 * then any of the current task's subsequent code will happen after
+	 * that SRCU read-side critical section whose read-unlock is seen in
+	 * srcu_readers_active_idx().
 	 */
-	for_each_possible_cpu(cpu)
-		if (sp->snap[cpu] !=
-		    ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, cpu)->c[idx]))
-			return false;  /* False zero reading! */
-	return true;
+	smp_mb(); /* D */
+
+	return srcu_readers_seq_idx(sp, idx) == seq;
 }
 
 /**
@@ -216,9 +214,9 @@ int __srcu_read_lock(struct srcu_struct *sp)
 	preempt_disable();
 	idx = rcu_dereference_index_check(sp->completed,
 					  rcu_read_lock_sched_held()) & 0x1;
-	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) +=
-		SRCU_USAGE_COUNT + 1;
+	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 1;
 	smp_mb(); /* B */  /* Avoid leaking the critical section. */
+	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->seq[idx]) += 1;
 	preempt_enable();
 	return idx;
 }
@@ -258,17 +256,6 @@ static void wait_idx(struct srcu_struct *sp, int idx, bool expedited)
 	int trycount = 0;
 
 	/*
-	 * If a reader fetches the index before the ->completed increment,
-	 * but increments its counter after srcu_readers_active_idx_check()
-	 * sums it, then smp_mb() D will pair with __srcu_read_lock()'s
-	 * smp_mb() B to ensure that the SRCU read-side critical section
-	 * will see any updates that the current task performed before its
-	 * call to synchronize_srcu(), or to synchronize_srcu_expedited(),
-	 * as the case may be.
-	 */
-	smp_mb(); /* D */
-
-	/*
 	 * SRCU read-side critical sections are normally short, so wait
 	 * a small amount of time before possibly blocking.
 	 */
@@ -281,18 +268,6 @@ static void wait_idx(struct srcu_struct *sp, int idx, bool expedited)
 				schedule_timeout_interruptible(1);
 		}
 	}
-
-	/*
-	 * The following smp_mb() E pairs with srcu_read_unlock()'s
-	 * smp_mb C to ensure that if srcu_readers_active_idx_check()
-	 * sees srcu_read_unlock()'s counter decrement, then any
-	 * of the current task's subsequent code will happen after
-	 * that SRCU read-side critical section.
-	 *
-	 * It also ensures the order between the above waiting and
-	 * the next flipping.
-	 */
-	smp_mb(); /* E */
 }
 
 static void srcu_flip(struct srcu_struct *sp)
-- 
1.7.4.4

