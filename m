Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0IWAwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 20:52:09 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47627 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600Ab0IWAvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:51:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/8] rcu: performance fixes to TINY_PREEMPT_RCU callback checking
Date: Wed, 22 Sep 2010 17:50:47 -0700
Message-Id: <1285203053-22068-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100923005033.GA22006@linux.vnet.ibm.com>
References: <20100923005033.GA22006@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit tightens up checks in rcu_preempt_check_callbacks() to avoid
unnecessary special handling at rcu_read_unlock() time.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny_plugin.h |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index c5bea11..6ceca4f 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -72,7 +72,7 @@ static void rcu_report_exp_done(void);
 /*
  * Return true if the CPU has not yet responded to the current grace period.
  */
-static int rcu_cpu_cur_gp(void)
+static int rcu_cpu_blocking_cur_gp(void)
 {
 	return rcu_preempt_ctrlblk.gpcpu != rcu_preempt_ctrlblk.gpnum;
 }
@@ -229,7 +229,7 @@ void rcu_preempt_note_context_switch(void)
 		 * cannot end.
 		 */
 		list_add(&t->rcu_node_entry, &rcu_preempt_ctrlblk.blkd_tasks);
-		if (rcu_cpu_cur_gp())
+		if (rcu_cpu_blocking_cur_gp())
 			rcu_preempt_ctrlblk.gp_tasks = &t->rcu_node_entry;
 	}
 
@@ -368,12 +368,16 @@ static void rcu_preempt_check_callbacks(void)
 {
 	struct task_struct *t = current;
 
-	if (!rcu_preempt_running_reader() && rcu_preempt_gp_in_progress())
+	if (rcu_preempt_gp_in_progress() &&
+	    (!rcu_preempt_running_reader() ||
+	     !rcu_cpu_blocking_cur_gp()))
 		rcu_preempt_cpu_qs();
 	if (&rcu_preempt_ctrlblk.rcb.rcucblist !=
 	    rcu_preempt_ctrlblk.rcb.donetail)
 		raise_softirq(RCU_SOFTIRQ);
-	if (rcu_preempt_gp_in_progress() && rcu_preempt_running_reader())
+	if (rcu_preempt_gp_in_progress() &&
+	    rcu_cpu_blocking_cur_gp() &&
+	    rcu_preempt_running_reader())
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
 }
 
-- 
1.7.0.6

