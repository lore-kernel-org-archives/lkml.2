Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157Ab1EANbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:31:31 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38395 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757047Ab1EANWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 26/86] rcu: remove useless ->boosted_this_gp field
Date: Sun,  1 May 2011 06:21:06 -0700
Message-Id: <1304256126-26015-26-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The ->boosted_this_gp field is a holdover from an earlier design that
was to carry out multiple boost operations in parallel.  It is not required
by the current design, which boosts one task at a time.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny_plugin.h |   35 ++++-------------------------------
 1 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 0bc9f73..2b8d529 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -100,7 +100,6 @@ struct rcu_preempt_ctrlblk {
 	u8 completed;		/* Last grace period completed. */
 				/*  If all three are equal, RCU is idle. */
 #ifdef CONFIG_RCU_BOOST
-	s8 boosted_this_gp;	/* Has boosting already happened? */
 	unsigned long boost_time; /* When to start boosting (jiffies) */
 #endif /* #ifdef CONFIG_RCU_BOOST */
 #ifdef CONFIG_RCU_TRACE
@@ -112,7 +111,6 @@ struct rcu_preempt_ctrlblk {
 	unsigned long n_normal_balk_blkd_tasks;
 	unsigned long n_normal_balk_gp_tasks;
 	unsigned long n_normal_balk_boost_tasks;
-	unsigned long n_normal_balk_boosted;
 	unsigned long n_normal_balk_notyet;
 	unsigned long n_normal_balk_nos;
 	unsigned long n_exp_balk_blkd_tasks;
@@ -219,36 +217,19 @@ static void show_tiny_preempt_stats(struct seq_file *m)
 		   "N."[!rcu_preempt_ctrlblk.gp_tasks],
 		   "E."[!rcu_preempt_ctrlblk.exp_tasks]);
 #ifdef CONFIG_RCU_BOOST
-	seq_printf(m, "             ttb=%c btg=",
-		   "B."[!rcu_preempt_ctrlblk.boost_tasks]);
-	switch (rcu_preempt_ctrlblk.boosted_this_gp) {
-	case -1:
-		seq_puts(m, "exp");
-		break;
-	case 0:
-		seq_puts(m, "no");
-		break;
-	case 1:
-		seq_puts(m, "begun");
-		break;
-	case 2:
-		seq_puts(m, "done");
-		break;
-	default:
-		seq_printf(m, "?%d?", rcu_preempt_ctrlblk.boosted_this_gp);
-	}
-	seq_printf(m, " ntb=%lu neb=%lu nnb=%lu j=%04x bt=%04x\n",
+	seq_printf(m, "%sttb=%c ntb=%lu neb=%lu nnb=%lu j=%04x bt=%04x\n",
+		   "             ",
+		   "B."[!rcu_preempt_ctrlblk.boost_tasks],
 		   rcu_preempt_ctrlblk.n_tasks_boosted,
 		   rcu_preempt_ctrlblk.n_exp_boosts,
 		   rcu_preempt_ctrlblk.n_normal_boosts,
 		   (int)(jiffies & 0xffff),
 		   (int)(rcu_preempt_ctrlblk.boost_time & 0xffff));
-	seq_printf(m, "             %s: nt=%lu gt=%lu bt=%lu b=%lu ny=%lu nos=%lu\n",
+	seq_printf(m, "             %s: nt=%lu gt=%lu bt=%lu ny=%lu nos=%lu\n",
 		   "normal balk",
 		   rcu_preempt_ctrlblk.n_normal_balk_blkd_tasks,
 		   rcu_preempt_ctrlblk.n_normal_balk_gp_tasks,
 		   rcu_preempt_ctrlblk.n_normal_balk_boost_tasks,
-		   rcu_preempt_ctrlblk.n_normal_balk_boosted,
 		   rcu_preempt_ctrlblk.n_normal_balk_notyet,
 		   rcu_preempt_ctrlblk.n_normal_balk_nos);
 	seq_printf(m, "             exp balk: bt=%lu nos=%lu\n",
@@ -277,7 +258,6 @@ static int rcu_boost(void)
 	if (rcu_preempt_ctrlblk.boost_tasks == NULL)
 		return 0;  /* Nothing to boost. */
 	raw_local_irq_save(flags);
-	rcu_preempt_ctrlblk.boosted_this_gp++;
 	t = container_of(rcu_preempt_ctrlblk.boost_tasks, struct task_struct,
 			 rcu_node_entry);
 	np = rcu_next_node_entry(t);
@@ -287,7 +267,6 @@ static int rcu_boost(void)
 	raw_local_irq_restore(flags);
 	rt_mutex_lock(&mtx);
 	RCU_TRACE(rcu_preempt_ctrlblk.n_tasks_boosted++);
-	rcu_preempt_ctrlblk.boosted_this_gp++;
 	rt_mutex_unlock(&mtx);
 	return rcu_preempt_ctrlblk.boost_tasks != NULL;
 }
@@ -310,7 +289,6 @@ static int rcu_initiate_boost(void)
 	}
 	if (rcu_preempt_ctrlblk.gp_tasks != NULL &&
 	    rcu_preempt_ctrlblk.boost_tasks == NULL &&
-	    rcu_preempt_ctrlblk.boosted_this_gp == 0 &&
 	    ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time)) {
 		rcu_preempt_ctrlblk.boost_tasks = rcu_preempt_ctrlblk.gp_tasks;
 		invoke_rcu_kthread();
@@ -331,7 +309,6 @@ static void rcu_initiate_expedited_boost(void)
 	if (!list_empty(&rcu_preempt_ctrlblk.blkd_tasks)) {
 		rcu_preempt_ctrlblk.boost_tasks =
 			rcu_preempt_ctrlblk.blkd_tasks.next;
-		rcu_preempt_ctrlblk.boosted_this_gp = -1;
 		invoke_rcu_kthread();
 		RCU_TRACE(rcu_preempt_ctrlblk.n_exp_boosts++);
 	} else
@@ -347,8 +324,6 @@ static void rcu_initiate_expedited_boost(void)
 static void rcu_preempt_boost_start_gp(void)
 {
 	rcu_preempt_ctrlblk.boost_time = jiffies + RCU_BOOST_DELAY_JIFFIES;
-	if (rcu_preempt_ctrlblk.boosted_this_gp > 0)
-		rcu_preempt_ctrlblk.boosted_this_gp = 0;
 }
 
 #else /* #ifdef CONFIG_RCU_BOOST */
@@ -934,8 +909,6 @@ static void rcu_initiate_boost_trace(void)
 		rcu_preempt_ctrlblk.n_normal_balk_gp_tasks++;
 	else if (rcu_preempt_ctrlblk.boost_tasks != NULL)
 		rcu_preempt_ctrlblk.n_normal_balk_boost_tasks++;
-	else if (rcu_preempt_ctrlblk.boosted_this_gp != 0)
-		rcu_preempt_ctrlblk.n_normal_balk_boosted++;
 	else if (!ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time))
 		rcu_preempt_ctrlblk.n_normal_balk_notyet++;
 	else
-- 
1.7.3.2

