Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab2CFJxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:53:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:1755 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965162Ab2CFJxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:53:21 -0500
X-IronPort-AV: E=Sophos;i="4.73,539,1325433600"; 
   d="scan'208";a="4464396"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH 6/6] add srcu torture test
Date: Tue, 6 Mar 2012 17:57:38 +0800
Message-Id: <1331027858-7648-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-06 17:51:17,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-06 17:51:24,
	Serialize complete at 2012-03-06 17:51:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add srcu_torture_deferred_free() for srcu_ops, it uses new call_srcu().
Rename the original srcu_ops to srcu_sync_ops.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/rcutorture.c |   68 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 54e5724..9197981 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -148,7 +148,10 @@ static struct task_struct *barrier_task;
 #define RCU_TORTURE_PIPE_LEN 10
 
 struct rcu_torture {
-	struct rcu_head rtort_rcu;
+	union {
+		struct rcu_head rtort_rcu;
+		struct srcu_head rtort_srcu;
+	};
 	int rtort_pipe_count;
 	struct list_head rtort_free;
 	int rtort_mbtest;
@@ -388,10 +391,9 @@ static int rcu_torture_completed(void)
 }
 
 static void
-rcu_torture_cb(struct rcu_head *p)
+__rcu_torture_cb(struct rcu_torture *rp)
 {
 	int i;
-	struct rcu_torture *rp = container_of(p, struct rcu_torture, rtort_rcu);
 
 	if (fullstop != FULLSTOP_DONTSTOP) {
 		/* Test is ending, just drop callbacks on the floor. */
@@ -409,6 +411,14 @@ rcu_torture_cb(struct rcu_head *p)
 		cur_ops->deferred_free(rp);
 }
 
+static void
+rcu_torture_cb(struct rcu_head *p)
+{
+	struct rcu_torture *rp = container_of(p, struct rcu_torture, rtort_rcu);
+
+	__rcu_torture_cb(rp);
+}
+
 static int rcu_no_completed(void)
 {
 	return 0;
@@ -623,6 +633,19 @@ static int srcu_torture_completed(void)
 	return srcu_batches_completed(&srcu_ctl);
 }
 
+static void
+srcu_torture_cb(struct srcu_head *p)
+{
+	struct rcu_torture *rp = container_of(p, struct rcu_torture, rtort_srcu);
+
+	__rcu_torture_cb(rp);
+}
+
+static void srcu_torture_deferred_free(struct rcu_torture *rp)
+{
+	call_srcu(&srcu_ctl, &rp->rtort_srcu, srcu_torture_cb);
+}
+
 static void srcu_torture_synchronize(void)
 {
 	synchronize_srcu(&srcu_ctl);
@@ -652,7 +675,7 @@ static struct rcu_torture_ops srcu_ops = {
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock,
 	.completed	= srcu_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
+	.deferred_free	= srcu_torture_deferred_free,
 	.sync		= srcu_torture_synchronize,
 	.call		= NULL,
 	.cb_barrier	= NULL,
@@ -660,6 +683,21 @@ static struct rcu_torture_ops srcu_ops = {
 	.name		= "srcu"
 };
 
+static struct rcu_torture_ops srcu_sync_ops = {
+	.init		= srcu_torture_init,
+	.cleanup	= srcu_torture_cleanup,
+	.readlock	= srcu_torture_read_lock,
+	.read_delay	= srcu_read_delay,
+	.readunlock	= srcu_torture_read_unlock,
+	.completed	= srcu_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= srcu_torture_synchronize,
+	.call		= NULL,
+	.cb_barrier	= NULL,
+	.stats		= srcu_torture_stats,
+	.name		= "srcu_sync"
+};
+
 static int srcu_torture_read_lock_raw(void) __acquires(&srcu_ctl)
 {
 	return srcu_read_lock_raw(&srcu_ctl);
@@ -677,7 +715,7 @@ static struct rcu_torture_ops srcu_raw_ops = {
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock_raw,
 	.completed	= srcu_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
+	.deferred_free	= srcu_torture_deferred_free,
 	.sync		= srcu_torture_synchronize,
 	.call		= NULL,
 	.cb_barrier	= NULL,
@@ -685,6 +723,21 @@ static struct rcu_torture_ops srcu_raw_ops = {
 	.name		= "srcu_raw"
 };
 
+static struct rcu_torture_ops srcu_raw_sync_ops = {
+	.init		= srcu_torture_init,
+	.cleanup	= srcu_torture_cleanup,
+	.readlock	= srcu_torture_read_lock_raw,
+	.read_delay	= srcu_read_delay,
+	.readunlock	= srcu_torture_read_unlock_raw,
+	.completed	= srcu_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= srcu_torture_synchronize,
+	.call		= NULL,
+	.cb_barrier	= NULL,
+	.stats		= srcu_torture_stats,
+	.name		= "srcu_raw_sync"
+};
+
 static void srcu_torture_synchronize_expedited(void)
 {
 	synchronize_srcu_expedited(&srcu_ctl);
@@ -1673,7 +1726,7 @@ static int rcu_torture_barrier_init(void)
 	for (i = 0; i < n_barrier_cbs; i++) {
 		init_waitqueue_head(&barrier_cbs_wq[i]);
 		barrier_cbs_tasks[i] = kthread_run(rcu_torture_barrier_cbs,
-						   (void *)i,
+						   (void *)(long)i,
 						   "rcu_torture_barrier_cbs");
 		if (IS_ERR(barrier_cbs_tasks[i])) {
 			ret = PTR_ERR(barrier_cbs_tasks[i]);
@@ -1857,7 +1910,8 @@ rcu_torture_init(void)
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_expedited_ops,
 		  &rcu_bh_ops, &rcu_bh_sync_ops, &rcu_bh_expedited_ops,
-		  &srcu_ops, &srcu_raw_ops, &srcu_expedited_ops,
+		  &srcu_ops, &srcu_sync_ops, &srcu_raw_ops,
+		  &srcu_raw_sync_ops, &srcu_expedited_ops,
 		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
 
 	mutex_lock(&fullstop_mutex);
-- 
1.7.4.4

