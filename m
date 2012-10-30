Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023Ab2J3RAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:00:45 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33907 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab2J3RAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:00:43 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/7] rcu: Avoid counter wrap in synchronize_sched_expedited()
Date: Tue, 30 Oct 2012 09:54:34 -0700
Message-Id: <1351616076-25617-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616076-25617-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030165415.GA25438@linux.vnet.ibm.com>
 <1351616076-25617-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-1976-0000-0000-000012DB53C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

There is a counter scheme similar to ticket locking that
synchronize_sched_expedited() uses to service multiple concurrent
callers with the same expedited grace period.  Upon entry, a
sync_sched_expedited_started variable is atomically incremented,
and upon completion of a expedited grace period a separate
sync_sched_expedited_done variable is atomically incremented.

However, if a synchronize_sched_expedited() is delayed while
in try_stop_cpus(), concurrent invocations will increment the
sync_sched_expedited_started counter, which will eventually overflow.
If the original synchronize_sched_expedited() resumes execution just
as the counter overflows, a concurrent invocation could incorrectly
conclude that an expedited grace period elapsed in zero time, which
would be bad.  One could rely on counter size to prevent this from
happening in practice, but the goal is to formally validate this
code, so it needs to be fixed anyway.

This commit therefore checks the gap between the two counters before
incrementing sync_sched_expedited_started, and if the gap is too
large, does a normal grace period instead.  Overflow is thus only
possible if there are more than about 3.5 billion threads on 32-bit
systems, which can be excluded until such time as task_struct fits
into a single byte and 4G/4G patches are accepted into mainline.
It is also easy to encode this limitation into mechanical theorem
provers.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   62 ++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 8914886..6789055 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2249,8 +2249,8 @@ void synchronize_rcu_bh(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
-static atomic_t sync_sched_expedited_started = ATOMIC_INIT(0);
-static atomic_t sync_sched_expedited_done = ATOMIC_INIT(0);
+static atomic_long_t sync_sched_expedited_started = ATOMIC_LONG_INIT(0);
+static atomic_long_t sync_sched_expedited_done = ATOMIC_LONG_INIT(0);
 
 static int synchronize_sched_expedited_cpu_stop(void *data)
 {
@@ -2308,10 +2308,30 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
  */
 void synchronize_sched_expedited(void)
 {
-	int firstsnap, s, snap, trycount = 0;
+	long firstsnap, s, snap;
+	int trycount = 0;
 
-	/* Note that atomic_inc_return() implies full memory barrier. */
-	firstsnap = snap = atomic_inc_return(&sync_sched_expedited_started);
+	/*
+	 * If we are in danger of counter wrap, just do synchronize_sched().
+	 * By allowing sync_sched_expedited_started to advance no more than
+	 * ULONG_MAX/8 ahead of sync_sched_expedited_done, we are ensuring
+	 * that more than 3.5 billion CPUs would be required to force a
+	 * counter wrap on a 32-bit system.  Quite a few more CPUs would of
+	 * course be required on a 64-bit system.
+	 */
+	if (ULONG_CMP_GE((ulong)atomic_read(&sync_sched_expedited_started),
+			 (ulong)atomic_read(&sync_sched_expedited_done) +
+			 ULONG_MAX / 8)) {
+		synchronize_sched();
+		return;
+	}
+
+	/*
+	 * Take a ticket.  Note that atomic_inc_return() implies a
+	 * full memory barrier.
+	 */
+	snap = atomic_long_inc_return(&sync_sched_expedited_started);
+	firstsnap = snap;
 	get_online_cpus();
 	WARN_ON_ONCE(cpu_is_offline(raw_smp_processor_id()));
 
@@ -2324,6 +2344,13 @@ void synchronize_sched_expedited(void)
 			     NULL) == -EAGAIN) {
 		put_online_cpus();
 
+		/* Check to see if someone else did our work for us. */
+		s = atomic_long_read(&sync_sched_expedited_done);
+		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
+			smp_mb(); /* ensure test happens before caller kfree */
+			return;
+		}
+
 		/* No joy, try again later.  Or just synchronize_sched(). */
 		if (trycount++ < 10) {
 			udelay(trycount * num_online_cpus());
@@ -2332,23 +2359,22 @@ void synchronize_sched_expedited(void)
 			return;
 		}
 
-		/* Check to see if someone else did our work for us. */
-		s = atomic_read(&sync_sched_expedited_done);
-		if (UINT_CMP_GE((unsigned)s, (unsigned)firstsnap)) {
+		/* Recheck to see if someone else did our work for us. */
+		s = atomic_long_read(&sync_sched_expedited_done);
+		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
 			smp_mb(); /* ensure test happens before caller kfree */
 			return;
 		}
 
 		/*
 		 * Refetching sync_sched_expedited_started allows later
-		 * callers to piggyback on our grace period.  We subtract
-		 * 1 to get the same token that the last incrementer got.
-		 * We retry after they started, so our grace period works
-		 * for them, and they started after our first try, so their
-		 * grace period works for us.
+		 * callers to piggyback on our grace period.  We retry
+		 * after they started, so our grace period works for them,
+		 * and they started after our first try, so their grace
+		 * period works for us.
 		 */
 		get_online_cpus();
-		snap = atomic_read(&sync_sched_expedited_started);
+		snap = atomic_long_read(&sync_sched_expedited_started);
 		smp_mb(); /* ensure read is before try_stop_cpus(). */
 	}
 
@@ -2356,15 +2382,15 @@ void synchronize_sched_expedited(void)
 	 * Everyone up to our most recent fetch is covered by our grace
 	 * period.  Update the counter, but only if our work is still
 	 * relevant -- which it won't be if someone who started later
-	 * than we did beat us to the punch.
+	 * than we did already did their update.
 	 */
 	do {
-		s = atomic_read(&sync_sched_expedited_done);
-		if (UINT_CMP_GE((unsigned)s, (unsigned)snap)) {
+		s = atomic_long_read(&sync_sched_expedited_done);
+		if (ULONG_CMP_GE((ulong)s, (ulong)snap)) {
 			smp_mb(); /* ensure test happens before caller kfree */
 			break;
 		}
-	} while (atomic_cmpxchg(&sync_sched_expedited_done, s, snap) != s);
+	} while (atomic_long_cmpxchg(&sync_sched_expedited_done, s, snap) != s);
 
 	put_online_cpus();
 }
-- 
1.7.8

