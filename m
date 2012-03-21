Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031130Ab2CUOAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:00:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61813 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031108Ab2CUOAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:00:17 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: [PATCH 27/32] nohz: Don't restart the tick before scheduling to idle
Date: Wed, 21 Mar 2012 14:58:33 +0100
Message-Id: <1332338318-5958-29-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we were running adaptive tickless but then we schedule out and
enter the idle task, we don't need to restart the tick because
tick_nohz_idle_enter() is going to be called right away.

The only thing we need to do is to save the jiffies such that
when we later restart the tick we can account the CPU time spent
while idle was tickless.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zen Lin <zen@openhuawei.org>
---
 kernel/time/tick-sched.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6706a7d..4b9bdfb 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1027,14 +1027,18 @@ void tick_nohz_pre_schedule(void)
 void tick_nohz_post_schedule(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	unsigned long flags;
 
-	/*
-	 * No need to disable irqs here. The worst that can happen
-	 * is an irq that comes and restart the tick before us.
-	 * tick_nohz_restart_sched_tick() is irq safe.
-	 */
-	if (ts->tick_stopped)
-		tick_nohz_restart_sched_tick();
+	local_irq_save(flags);
+	if (ts->tick_stopped) {
+		if (is_idle_task(current)) {
+			ts->saved_jiffies = jiffies;
+			ts->saved_jiffies_whence = JIFFIES_SAVED_IDLE;
+		} else {
+			tick_nohz_restart_sched_tick();
+		}
+	}
+	local_irq_restore(flags);
 }
 
 void tick_nohz_flush_current_times(bool restart_tick)
-- 
1.7.5.4

