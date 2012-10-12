Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946027Ab2JLRM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:12:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41138 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1945987Ab2JLRMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:12:23 -0400
X-IronPort-AV: E=Sophos;i="4.80,578,1344182400"; 
   d="scan'208";a="5990995"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Josh Triplett <josh@freedesktop.org>
Subject: [PATCH 4/4] rcutorture: use DEFINE_STATIC_SRCU()
Date: Sat, 13 Oct 2012 01:14:17 +0800
Message-Id: <1350062057-2439-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1350062057-2439-1-git-send-email-laijs@cn.fujitsu.com>
References: <1350062057-2439-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/13 01:12:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/13 01:12:06,
	Serialize complete at 2012/10/13 01:12:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use DEFINE_STATIC_SRCU() to simplify the rcutorture.c

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/rcutorture.c |   41 ++++++-----------------------------------
 1 files changed, 6 insertions(+), 35 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 25b1503..7939edf 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -332,7 +332,6 @@ rcu_stutter_wait(char *title)
 
 struct rcu_torture_ops {
 	void (*init)(void);
-	void (*cleanup)(void);
 	int (*readlock)(void);
 	void (*read_delay)(struct rcu_random_state *rrsp);
 	void (*readunlock)(int idx);
@@ -424,7 +423,6 @@ static void rcu_torture_deferred_free(struct rcu_torture *p)
 
 static struct rcu_torture_ops rcu_ops = {
 	.init		= NULL,
-	.cleanup	= NULL,
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,
 	.readunlock	= rcu_torture_read_unlock,
@@ -468,7 +466,6 @@ static void rcu_sync_torture_init(void)
 
 static struct rcu_torture_ops rcu_sync_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,
 	.readunlock	= rcu_torture_read_unlock,
@@ -486,7 +483,6 @@ static struct rcu_torture_ops rcu_sync_ops = {
 
 static struct rcu_torture_ops rcu_expedited_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_torture_read_unlock,
@@ -529,7 +525,6 @@ static void rcu_bh_torture_deferred_free(struct rcu_torture *p)
 
 static struct rcu_torture_ops rcu_bh_ops = {
 	.init		= NULL,
-	.cleanup	= NULL,
 	.readlock	= rcu_bh_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_bh_torture_read_unlock,
@@ -546,7 +541,6 @@ static struct rcu_torture_ops rcu_bh_ops = {
 
 static struct rcu_torture_ops rcu_bh_sync_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= rcu_bh_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_bh_torture_read_unlock,
@@ -563,7 +557,6 @@ static struct rcu_torture_ops rcu_bh_sync_ops = {
 
 static struct rcu_torture_ops rcu_bh_expedited_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= rcu_bh_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_bh_torture_read_unlock,
@@ -582,19 +575,7 @@ static struct rcu_torture_ops rcu_bh_expedited_ops = {
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
@@ -665,8 +646,7 @@ static int srcu_torture_stats(char *page)
 }
 
 static struct rcu_torture_ops srcu_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock,
@@ -680,8 +660,7 @@ static struct rcu_torture_ops srcu_ops = {
 };
 
 static struct rcu_torture_ops srcu_sync_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock,
@@ -705,8 +684,7 @@ static void srcu_torture_read_unlock_raw(int idx) __releases(&srcu_ctl)
 }
 
 static struct rcu_torture_ops srcu_raw_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock_raw,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock_raw,
@@ -720,8 +698,7 @@ static struct rcu_torture_ops srcu_raw_ops = {
 };
 
 static struct rcu_torture_ops srcu_raw_sync_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock_raw,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock_raw,
@@ -740,8 +717,7 @@ static void srcu_torture_synchronize_expedited(void)
 }
 
 static struct rcu_torture_ops srcu_expedited_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock,
@@ -776,7 +752,6 @@ static void rcu_sched_torture_deferred_free(struct rcu_torture *p)
 
 static struct rcu_torture_ops sched_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
@@ -792,7 +767,6 @@ static struct rcu_torture_ops sched_ops = {
 
 static struct rcu_torture_ops sched_sync_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
@@ -807,7 +781,6 @@ static struct rcu_torture_ops sched_sync_ops = {
 
 static struct rcu_torture_ops sched_expedited_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
@@ -1903,8 +1876,6 @@ rcu_torture_cleanup(void)
 
 	rcu_torture_stats_print();  /* -After- the stats thread is stopped! */
 
-	if (cur_ops->cleanup)
-		cur_ops->cleanup();
 	if (atomic_read(&n_rcu_torture_error) || n_rcu_torture_barrier_error)
 		rcu_torture_print_module_parms(cur_ops, "End of test: FAILURE");
 	else if (n_online_successes != n_online_attempts ||
-- 
1.7.7.6

