Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934105Ab2J3Qy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:54:58 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59273 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934021Ab2J3Qy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:54:56 -0400
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
Subject: [PATCH tip/core/rcu 7/7] rcu: Instrument synchronize_rcu_expedited() for debugfs tracing
Date: Tue, 30 Oct 2012 09:54:36 -0700
Message-Id: <1351616076-25617-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616076-25617-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030165415.GA25438@linux.vnet.ibm.com>
 <1351616076-25617-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-9360-0000-0000-00000C36936C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

This commit adds the counters to rcu_state and updates them in
synchronize_rcu_expedited() to provide the data needed for debugfs
tracing.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   18 +++++++++++++++---
 kernel/rcutree.h |    9 +++++++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3c72e5e..b966d56 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2321,6 +2321,7 @@ void synchronize_sched_expedited(void)
 			 (ulong)atomic_long_read(&rsp->expedited_done) +
 			 ULONG_MAX / 8)) {
 		synchronize_sched();
+		atomic_long_inc(&rsp->expedited_wrap);
 		return;
 	}
 
@@ -2341,11 +2342,14 @@ void synchronize_sched_expedited(void)
 			     synchronize_sched_expedited_cpu_stop,
 			     NULL) == -EAGAIN) {
 		put_online_cpus();
+		atomic_long_inc(&rsp->expedited_tryfail);
 
 		/* Check to see if someone else did our work for us. */
 		s = atomic_long_read(&rsp->expedited_done);
 		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
-			smp_mb(); /* ensure test happens before caller kfree */
+			/* ensure test happens before caller kfree */
+			smp_mb__before_atomic_inc(); /* ^^^ */
+			atomic_long_inc(&rsp->expedited_workdone1);
 			return;
 		}
 
@@ -2354,13 +2358,16 @@ void synchronize_sched_expedited(void)
 			udelay(trycount * num_online_cpus());
 		} else {
 			synchronize_sched();
+			atomic_long_inc(&rsp->expedited_normal);
 			return;
 		}
 
 		/* Recheck to see if someone else did our work for us. */
 		s = atomic_long_read(&rsp->expedited_done);
 		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
-			smp_mb(); /* ensure test happens before caller kfree */
+			/* ensure test happens before caller kfree */
+			smp_mb__before_atomic_inc(); /* ^^^ */
+			atomic_long_inc(&rsp->expedited_workdone2);
 			return;
 		}
 
@@ -2375,6 +2382,7 @@ void synchronize_sched_expedited(void)
 		snap = atomic_long_read(&rsp->expedited_start);
 		smp_mb(); /* ensure read is before try_stop_cpus(). */
 	}
+	atomic_long_inc(&rsp->expedited_stoppedcpus);
 
 	/*
 	 * Everyone up to our most recent fetch is covered by our grace
@@ -2383,12 +2391,16 @@ void synchronize_sched_expedited(void)
 	 * than we did already did their update.
 	 */
 	do {
+		atomic_long_inc(&rsp->expedited_done_tries);
 		s = atomic_long_read(&rsp->expedited_done);
 		if (ULONG_CMP_GE((ulong)s, (ulong)snap)) {
-			smp_mb(); /* ensure test happens before caller kfree */
+			/* ensure test happens before caller kfree */
+			smp_mb__before_atomic_inc(); /* ^^^ */
+			atomic_long_inc(&rsp->expedited_done_lost);
 			break;
 		}
 	} while (atomic_long_cmpxchg(&rsp->expedited_done, s, snap) != s);
+	atomic_long_inc(&rsp->expedited_done_exit);
 
 	put_online_cpus();
 }
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 88f3d9d..d274af3 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -406,6 +406,15 @@ struct rcu_state {
 
 	atomic_long_t expedited_start;		/* Starting ticket. */
 	atomic_long_t expedited_done;		/* Done ticket. */
+	atomic_long_t expedited_wrap;		/* # near-wrap incidents. */
+	atomic_long_t expedited_tryfail;	/* # acquisition failures. */
+	atomic_long_t expedited_workdone1;	/* # done by others #1. */
+	atomic_long_t expedited_workdone2;	/* # done by others #2. */
+	atomic_long_t expedited_normal;		/* # fallbacks to normal. */
+	atomic_long_t expedited_stoppedcpus;	/* # successful stop_cpus. */
+	atomic_long_t expedited_done_tries;	/* # tries to update _done. */
+	atomic_long_t expedited_done_lost;	/* # times beaten to _done. */
+	atomic_long_t expedited_done_exit;	/* # times exited _done loop. */
 
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
-- 
1.7.8

