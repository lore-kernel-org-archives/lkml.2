Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1HOPxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:53:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38331 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab1HOPxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:07 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 08/32] nohz: Move nohz load balancer selection into idle logic
Date: Mon, 15 Aug 2011 17:52:05 +0200
Message-Id: <1313423549-27093-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want the nohz load balancer to be an idle CPU, thus
move that selection to strict dyntick idle logic.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 kernel/time/tick-sched.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index bca1519..de1b629 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -380,8 +380,6 @@ static void tick_nohz_stop_sched_tick(ktime_t now)
 		 * the scheduler tick in nohz_restart_sched_tick.
 		 */
 		if (!ts->tick_stopped) {
-			select_nohz_load_balancer(1);
-
 			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 		}
@@ -434,6 +432,7 @@ static void __tick_nohz_enter_idle(struct tick_sched *ts, int cpu)
 
 	if (!was_stopped && ts->tick_stopped) {
 		ts->idle_jiffies = ts->last_jiffies;
+		select_nohz_load_balancer(1);
 		rcu_enter_nohz();
 	}
 }
@@ -501,7 +500,6 @@ static void tick_nohz_restart_sched_tick(ktime_t now, struct tick_sched *ts)
 	int cpu = smp_processor_id();
 
 	/* Update jiffies first */
-	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
 	cpumask_clear_cpu(cpu, nohz_cpu_mask);
 
@@ -552,6 +550,7 @@ void tick_nohz_exit_idle(void)
 
 	if (ts->tick_stopped) {
 		rcu_exit_nohz();
+		select_nohz_load_balancer(0);
 		tick_nohz_restart_sched_tick(now, ts);
 		tick_nohz_account_idle_ticks(ts);
 	}
-- 
1.7.5.4

