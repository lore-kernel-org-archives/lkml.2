Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab2FOS6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:58:36 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:53930 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab2FOS6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:58:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/6] rcu: Fix bug in rcu_barrier() torture test
Date: Fri, 15 Jun 2012 11:57:52 -0700
Message-Id: <1339786674-25265-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615185725.GA25163@linux.vnet.ibm.com>
 <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061518-7408-0000-0000-000005E403A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The child threads in the rcu_torture_barrier_cbs() are improperly
synchronized, which can cause the rcu_barrier() tests to hang.  The
failure mode is as follows:

1.	CPU 0 running in rcu_torture_barrier() sets barrier_cbs_count
    	to n_barrier_cbs.

2.	CPU 1 running in rcu_torture_barrier_cbs() wakes up, posts
    	its RCU callback, and atomically decrements barrier_cbs_count.
    	Because barrier_cbs_count is not zero, it does not do the wake_up().

3.	CPU 2 running in rcu_torture_barrier_cbs() wakes up, but
    	finds that barrier_cbs_count is not equal to n_barrier_cbs,
    	and so returns to sleep.

4.	The value of barrier_cbs_count therefore never reaches zero,
    	which causes the test to hang.

This commit therefore uses a phase variable to coordinate the test,
preventing this scenario from occurring.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 7b6935e..08d8537 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -206,6 +206,7 @@ static unsigned long boost_starttime;	/* jiffies of next boost test start. */
 DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
 					/*  and boost task create/destroy. */
 static atomic_t barrier_cbs_count;	/* Barrier callbacks registered. */
+static bool barrier_phase;		/* Test phase. */
 static atomic_t barrier_cbs_invoked;	/* Barrier callbacks invoked. */
 static wait_queue_head_t *barrier_cbs_wq; /* Coordinate barrier testing. */
 static DECLARE_WAIT_QUEUE_HEAD(barrier_wq);
@@ -1642,6 +1643,7 @@ void rcu_torture_barrier_cbf(struct rcu_head *rcu)
 static int rcu_torture_barrier_cbs(void *arg)
 {
 	long myid = (long)arg;
+	bool lastphase = 0;
 	struct rcu_head rcu;
 
 	init_rcu_head_on_stack(&rcu);
@@ -1649,9 +1651,11 @@ static int rcu_torture_barrier_cbs(void *arg)
 	set_user_nice(current, 19);
 	do {
 		wait_event(barrier_cbs_wq[myid],
-			   atomic_read(&barrier_cbs_count) == n_barrier_cbs ||
+			   barrier_phase != lastphase ||
 			   kthread_should_stop() ||
 			   fullstop != FULLSTOP_DONTSTOP);
+		lastphase = barrier_phase;
+		smp_mb();
 		if (kthread_should_stop() || fullstop != FULLSTOP_DONTSTOP)
 			break;
 		cur_ops->call(&rcu, rcu_torture_barrier_cbf);
@@ -1676,7 +1680,8 @@ static int rcu_torture_barrier(void *arg)
 	do {
 		atomic_set(&barrier_cbs_invoked, 0);
 		atomic_set(&barrier_cbs_count, n_barrier_cbs);
-		/* wake_up() path contains the required barriers. */
+		smp_mb();
+		barrier_phase = !barrier_phase;
 		for (i = 0; i < n_barrier_cbs; i++)
 			wake_up(&barrier_cbs_wq[i]);
 		wait_event(barrier_wq,
-- 
1.7.8

