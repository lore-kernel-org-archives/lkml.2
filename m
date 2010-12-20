Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab0LTPYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:24:43 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:63472 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab0LTPYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:24:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iBdjLoBjom6IvB2Tzev8Dc0cvfC+jHyUnq3Uzg5q0YX/0hsaEylkfs5Rr4VJa8Z90c
         tkNdiyFIfw3J7MfijgddHd+ybYWZgIEKp69ympQpIPXNSTaJDkv9boulmLUt5lR1Ak5c
         UHZlAASAo2iEBQ2SO8mAHS+4OEulRv8VyaFY0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [RFC PATCH 03/15] nohz_task: Make tick stop and restart callable outside idle
Date: Mon, 20 Dec 2010 16:24:10 +0100
Message-Id: <1292858662-5650-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the nohz tick restart and stop APIs callable outside idle
and from interrupts.

Don't reenable interrupts unconditionally and only enter/exit
rcu quiescent state if we are in idle.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 kernel/time/tick-sched.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3e216e0..e706fa8 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -405,12 +405,14 @@ void tick_nohz_stop_sched_tick(int inidle)
 		 * the scheduler tick in nohz_restart_sched_tick.
 		 */
 		if (!ts->tick_stopped) {
-			select_nohz_load_balancer(1);
+			if (!current->pid)
+				select_nohz_load_balancer(1);
 
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
-			rcu_enter_nohz();
+			if (!current->pid)
+				rcu_enter_nohz();
 		}
 
 		ts->idle_sleeps++;
@@ -500,12 +502,14 @@ void tick_nohz_restart_sched_tick(void)
 {
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	unsigned long flags;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	unsigned long ticks;
 #endif
 	ktime_t now;
 
-	local_irq_disable();
+	local_irq_save(flags);
+
 	if (ts->idle_active || (ts->inidle && ts->tick_stopped))
 		now = ktime_get();
 
@@ -514,13 +518,14 @@ void tick_nohz_restart_sched_tick(void)
 
 	if (!ts->inidle || !ts->tick_stopped) {
 		ts->inidle = 0;
-		local_irq_enable();
+		local_irq_restore(flags);
 		return;
 	}
 
 	ts->inidle = 0;
 
-	rcu_exit_nohz();
+	if (!current->pid)
+		rcu_exit_nohz();
 
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
@@ -550,7 +555,7 @@ void tick_nohz_restart_sched_tick(void)
 
 	tick_nohz_restart(ts, now);
 
-	local_irq_enable();
+	local_irq_restore(flags);
 }
 
 static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
-- 
1.7.3.2

