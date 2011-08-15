Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1HOPxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:53:01 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38331 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab1HOPw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:52:59 -0400
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
Subject: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to idle enter/exit APIs
Date: Mon, 15 Aug 2011 17:52:02 +0200
Message-Id: <1313423549-27093-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prepare for nohz / idle logic split, pull out the rcu dynticks
idle mode switching to strict idle entry/exit areas.

So we make the dyntick mode possible without always involving rcu
extended quiescent state.

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
 kernel/time/tick-sched.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index df6bb4c..8937d4a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -385,7 +385,6 @@ static void tick_nohz_stop_sched_tick(ktime_t now)
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
-			rcu_enter_nohz();
 		}
 
 		ts->idle_sleeps++;
@@ -429,9 +428,13 @@ out:
 static void __tick_nohz_enter_idle(struct tick_sched *ts, int cpu)
 {
 	ktime_t now;
+	int was_stopped = ts->tick_stopped;
 
 	now = tick_nohz_start_idle(cpu, ts);
 	tick_nohz_stop_sched_tick(now);
+
+	if (!was_stopped && ts->tick_stopped)
+		rcu_enter_nohz();
 }
 
 void tick_nohz_enter_idle(void)
@@ -499,8 +502,6 @@ static void tick_nohz_restart_sched_tick(ktime_t now, struct tick_sched *ts)
 	unsigned long ticks;
 #endif
 
-	rcu_exit_nohz();
-
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
@@ -547,8 +548,10 @@ void tick_nohz_exit_idle(void)
 	tick_nohz_stop_idle(smp_processor_id(), now);
 	ts->inidle = 0;
 
-	if (ts->tick_stopped)
+	if (ts->tick_stopped) {
+		rcu_exit_nohz();
 		tick_nohz_restart_sched_tick(now, ts);
+	}
 
 	local_irq_enable();
 }
-- 
1.7.5.4

