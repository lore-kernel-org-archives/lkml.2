Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052Ab2J3QjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:39:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47749 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934037Ab2J3QjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:39:19 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/4] rcutorture: Use DEFINE_STATIC_SRCU()
Date: Tue, 30 Oct 2012 09:38:10 -0700
Message-Id: <1351615090-24398-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351615090-24398-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030163650.GA23518@linux.vnet.ibm.com>
 <1351615090-24398-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-7182-0000-0000-000002FD9FD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Use DEFINE_STATIC_SRCU() to simplify the rcutorture.c SRCU test code.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |   41 ++++++-----------------------------------
 1 files changed, 6 insertions(+), 35 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index aaa7b9f..f401972 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -339,7 +339,6 @@ rcu_stutter_wait(char *title)
 
 struct rcu_torture_ops {
 	void (*init)(void);
-	void (*cleanup)(void);
 	int (*readlock)(void);
 	void (*read_delay)(struct rcu_random_state *rrsp);
 	void (*readunlock)(int idx);
@@ -431,7 +430,6 @@ static void rcu_torture_deferred_free(struct rcu_torture *p)
 
 static struct rcu_torture_ops rcu_ops = {
 	.init		= NULL,
-	.cleanup	= NULL,
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,
 	.readunlock	= rcu_torture_read_unlock,
@@ -475,7 +473,6 @@ static void rcu_sync_torture_init(void)
 
 static struct rcu_torture_ops rcu_sync_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,
 	.readunlock	= rcu_torture_read_unlock,
@@ -493,7 +490,6 @@ static struct rcu_torture_ops rcu_sync_ops = {
 
 static struct rcu_torture_ops rcu_expedited_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_torture_read_unlock,
@@ -536,7 +532,6 @@ static void rcu_bh_torture_deferred_free(struct rcu_torture *p)
 
 static struct rcu_torture_ops rcu_bh_ops = {
 	.init		= NULL,
-	.cleanup	= NULL,
 	.readlock	= rcu_bh_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_bh_torture_read_unlock,
@@ -553,7 +548,6 @@ static struct rcu_torture_ops rcu_bh_ops = {
 
 static struct rcu_torture_ops rcu_bh_sync_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= rcu_bh_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_bh_torture_read_unlock,
@@ -570,7 +564,6 @@ static struct rcu_torture_ops rcu_bh_sync_ops = {
 
 static struct rcu_torture_ops rcu_bh_expedited_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= rcu_bh_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_bh_torture_read_unlock,
@@ -589,19 +582,7 @@ static struct rcu_torture_ops rcu_bh_expedited_ops = {
  * Definitions for srcu torture testing.
  */
 
-static struct srcu_struct srcu_ctl;
-
-static void srcu_torture_init(void)
-{
-	init_srcu_struct(&srcu_ctl);
-	rcu_sync_torture_init();
-}
-
-static void srcu_torture_cleanup(void)
-{
-	synchronize_srcu(&srcu_ctl);
-	cleanup_srcu_struct(&srcu_ctl);
-}
+DEFINE_STATIC_SRCU(srcu_ctl);
 
 static int srcu_torture_read_lock(void) __acquires(&srcu_ctl)
 {
@@ -672,8 +653,7 @@ static int srcu_torture_stats(char *page)
 }
 
 static struct rcu_torture_ops srcu_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock,
@@ -687,8 +667,7 @@ static struct rcu_torture_ops srcu_ops = {
 };
 
 static struct rcu_torture_ops srcu_sync_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock,
@@ -712,8 +691,7 @@ static void srcu_torture_read_unlock_raw(int idx) __releases(&srcu_ctl)
 }
 
 static struct rcu_torture_ops srcu_raw_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock_raw,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock_raw,
@@ -727,8 +705,7 @@ static struct rcu_torture_ops srcu_raw_ops = {
 };
 
 static struct rcu_torture_ops srcu_raw_sync_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock_raw,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock_raw,
@@ -747,8 +724,7 @@ static void srcu_torture_synchronize_expedited(void)
 }
 
 static struct rcu_torture_ops srcu_expedited_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock,
@@ -783,7 +759,6 @@ static void rcu_sched_torture_deferred_free(struct rcu_torture *p)
 
 static struct rcu_torture_ops sched_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
@@ -799,7 +774,6 @@ static struct rcu_torture_ops sched_ops = {
 
 static struct rcu_torture_ops sched_sync_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
@@ -814,7 +788,6 @@ static struct rcu_torture_ops sched_sync_ops = {
 
 static struct rcu_torture_ops sched_expedited_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
@@ -1936,8 +1909,6 @@ rcu_torture_cleanup(void)
 
 	rcu_torture_stats_print();  /* -After- the stats thread is stopped! */
 
-	if (cur_ops->cleanup)
-		cur_ops->cleanup();
 	if (atomic_read(&n_rcu_torture_error) || n_rcu_torture_barrier_error)
 		rcu_torture_print_module_parms(cur_ops, "End of test: FAILURE");
 	else if (n_online_successes != n_online_attempts ||
-- 
1.7.8

