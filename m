Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2LTSeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:34:10 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:58577 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2LTSdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:33:40 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 07/24] nohz: Assign timekeeping duty to a non-full-nohz CPU
Date: Thu, 20 Dec 2012 19:32:54 +0100
Message-Id: <1356028391-14427-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way the full nohz CPUs can safely run with the tick
stopped with a guarantee that somebody else is taking
care of the jiffies and gtod progression.

NOTE: this doesn't handle CPU hotplug. Also we could use something
more elaborated wrt. powersaving if we have more than one non full-nohz
CPU running. But let's use this KISS solution for now.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c |    3 ++-
 kernel/time/tick-common.c    |    5 ++++-
 kernel/time/tick-sched.c     |    7 ++++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f113755..596c547 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -537,7 +537,8 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 		bc->event_handler = tick_handle_oneshot_broadcast;
 
 		/* Take the do_timer update */
-		tick_do_timer_cpu = cpu;
+		if (!tick_nohz_full_cpu(cpu))
+			tick_do_timer_cpu = cpu;
 
 		/*
 		 * We must be careful here. There might be other CPUs
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index b1600a6..83f2bd9 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -163,7 +163,10 @@ static void tick_setup_device(struct tick_device *td,
 		 * this cpu:
 		 */
 		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
-			tick_do_timer_cpu = cpu;
+			if (!tick_nohz_full_cpu(cpu))
+				tick_do_timer_cpu = cpu;
+			else
+				tick_do_timer_cpu = TICK_DO_TIMER_NONE;
 			tick_next_period = ktime_get();
 			tick_period = ktime_set(0, NSEC_PER_SEC / HZ);
 		}
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index fac9ba4..4a68b50 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -112,7 +112,8 @@ static void tick_sched_do_timer(ktime_t now)
 	 * this duty, then the jiffies update is still serialized by
 	 * jiffies_lock.
 	 */
-	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
+	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)
+	    && !tick_nohz_full_cpu(cpu))
 		tick_do_timer_cpu = cpu;
 #endif
 
@@ -512,6 +513,10 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 		return false;
 	}
 
+	/* If there are full nohz CPUs around, we need to keep the timekeeping duty */
+	if (have_full_nohz_mask && tick_do_timer_cpu == cpu)
+		return false;
+
 	return true;
 }
 
-- 
1.7.5.4

