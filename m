Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab2CSIIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:08:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:39057 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755430Ab2CSIHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:07:18 -0400
X-IronPort-AV: E=Sophos;i="4.73,611,1325433600"; 
   d="scan'208";a="4567344"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH 4/4 V2] add srcu torture test
Date: Mon, 19 Mar 2012 16:12:14 +0800
Message-Id: <1332144734-9375-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1332144734-9375-1-git-send-email-laijs@cn.fujitsu.com>
References: <1332144734-9375-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-19 16:05:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-19 16:05:09,
	Serialize complete at 2012-03-19 16:05:09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add srcu_torture_deferred_free() for srcu_ops, it uses new call_srcu().
Rename the original srcu_ops to srcu_sync_ops.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/rcutorture.c |   44 ++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 54e5724..40d24d0 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -623,6 +623,11 @@ static int srcu_torture_completed(void)
 	return srcu_batches_completed(&srcu_ctl);
 }
 
+static void srcu_torture_deferred_free(struct rcu_torture *rp)
+{
+	call_srcu(&srcu_ctl, &rp->rtort_rcu, rcu_torture_cb);
+}
+
 static void srcu_torture_synchronize(void)
 {
 	synchronize_srcu(&srcu_ctl);
@@ -652,7 +657,7 @@ static struct rcu_torture_ops srcu_ops = {
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock,
 	.completed	= srcu_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
+	.deferred_free	= srcu_torture_deferred_free,
 	.sync		= srcu_torture_synchronize,
 	.call		= NULL,
 	.cb_barrier	= NULL,
@@ -660,6 +665,21 @@ static struct rcu_torture_ops srcu_ops = {
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
@@ -677,7 +697,7 @@ static struct rcu_torture_ops srcu_raw_ops = {
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock_raw,
 	.completed	= srcu_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
+	.deferred_free	= srcu_torture_deferred_free,
 	.sync		= srcu_torture_synchronize,
 	.call		= NULL,
 	.cb_barrier	= NULL,
@@ -685,6 +705,21 @@ static struct rcu_torture_ops srcu_raw_ops = {
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
@@ -1673,7 +1708,7 @@ static int rcu_torture_barrier_init(void)
 	for (i = 0; i < n_barrier_cbs; i++) {
 		init_waitqueue_head(&barrier_cbs_wq[i]);
 		barrier_cbs_tasks[i] = kthread_run(rcu_torture_barrier_cbs,
-						   (void *)i,
+						   (void *)(long)i,
 						   "rcu_torture_barrier_cbs");
 		if (IS_ERR(barrier_cbs_tasks[i])) {
 			ret = PTR_ERR(barrier_cbs_tasks[i]);
@@ -1857,7 +1892,8 @@ rcu_torture_init(void)
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

