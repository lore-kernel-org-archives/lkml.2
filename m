Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0C2Crx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:47:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64957 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755845Ab0C2Crv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:47:51 -0400
Message-ID: <4BB014DF.9030905@cn.fujitsu.com>
Date: Mon, 29 Mar 2010 10:47:59 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: don't call rcu_preempt_note_context_switch() in rcu_check_callbacks()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Even though in user mode or idle mode, rcu_check_callbacks() is not
context switch, so we don't call rcu_preempt_note_context_switch()
in rcu_check_callbacks().

Though there is no harm that calls rcu_preempt_note_context_switch()
in rcu_check_callbacks(), but it is waste.

rcu_check_callbacks()
  rcu_sched_qs()
    rcu_preempt_note_context_switch()
       Now, ->rcu_read_lock_nesting == 0, so we just calls
       rcu_preempt_qs(), but, rcu_preempt_check_callbacks()
       will call it again and set the ->rcu_read_unlock_special
       correct again.

So let rcu_preempt_check_callbacks() handle things for us.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3ec8160..c7847ba 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -95,7 +95,7 @@ static int rcu_gp_in_progress(struct rcu_state *rsp)
  * how many quiescent states passed, just if there was at least
  * one since the start of the grace period, this just sets a flag.
  */
-void rcu_sched_qs(int cpu)
+static void __rcu_sched_qs(int cpu)
 {
 	struct rcu_data *rdp;
 
@@ -103,6 +103,11 @@ void rcu_sched_qs(int cpu)
 	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
+}
+
+void rcu_sched_qs(int cpu)
+{
+	__rcu_sched_qs(cpu);
 	rcu_preempt_note_context_switch(cpu);
 }
 
@@ -1138,12 +1143,12 @@ void rcu_check_callbacks(int cpu, int user)
 		 * a quiescent state, so note it.
 		 *
 		 * No memory barrier is required here because both
-		 * rcu_sched_qs() and rcu_bh_qs() reference only CPU-local
+		 * __rcu_sched_qs() and rcu_bh_qs() reference only CPU-local
 		 * variables that other CPUs neither access nor modify,
 		 * at least not while the corresponding CPU is online.
 		 */
 
-		rcu_sched_qs(cpu);
+		__rcu_sched_qs(cpu);
 		rcu_bh_qs(cpu);
 
 	} else if (!in_softirq()) {

