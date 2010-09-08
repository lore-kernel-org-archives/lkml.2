Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab0IHM3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 08:29:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:33878 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836Ab0IHM3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 08:29:47 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org
Cc: peterz@infradead.org, Sven-Thorsten Dietrich <sdietrich@novell.com>,
        Michael Galbraith <MGalbraith@novell.com>,
        Jan Blunck <jblunck@suse.de>
Subject: [RFC 2/4] ftrace: Add events for tracing tick start and stop
Date: Wed,  8 Sep 2010 14:29:22 +0200
Message-Id: <1283948964-6418-3-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1283948964-6418-1-git-send-email-jblunck@suse.de>
References: <1283948964-6418-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace the starting and stopping of the scheduler tick. The traces look like
this:

<idle>-0     [000] 187573.495750: sched_tick_stop: idle=1, expires=6876704000000
<idle>-0     [000] 187573.629998: sched_tick_stop: idle=0, expires=6876704000000
<idle>-0     [000] 187573.764273: sched_tick_stop: idle=0, expires=6876704000000
<idle>-0     [000] 187573.898508: sched_tick_stop: idle=0, expires=6876704000000
<idle>-0     [000] 187574.009284: sched_tick_start: now=6876232761127

In this trace you can see how tick_nohz_stop_sched_tick() is called from
the idle thread (idle=1) and later through irq_exit() (idle=0).

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 include/trace/events/sched.h |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/time/tick-sched.c     |   21 ++++++++++++++++-----
 2 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index b9e1dd6..36385b6 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -380,6 +380,46 @@ TRACE_EVENT(sched_stat_runtime,
 			(unsigned long long)__entry->vruntime)
 );
 
+TRACE_EVENT(sched_tick_start,
+
+	TP_PROTO(ktime_t *now),
+
+	TP_ARGS(now),
+
+	TP_STRUCT__entry(
+		__field(s64, tv64)
+		),
+
+	TP_fast_assign(
+		__entry->tv64 = now->tv64;
+		),
+	TP_printk("now=%ld",
+		(long)__entry->tv64)
+
+);
+
+TRACE_EVENT(sched_tick_stop,
+
+	TP_PROTO(ktime_t *expires, int idle),
+
+	TP_ARGS(expires, idle),
+
+	TP_STRUCT__entry(
+		__field(s64, tv64)
+		__field(int, idle)
+		),
+
+	TP_fast_assign(
+		__entry->tv64 = expires->tv64;
+		__entry->idle = idle;
+		),
+	TP_printk("idle=%d, expires=%ld%s",
+		__entry->idle,
+		(long)__entry->tv64,
+		(__entry->tv64 == KTIME_MAX) ? " (KTIME_MAX)" : "" )
+
+);
+
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 813993b..81b7398 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -22,6 +22,8 @@
 #include <linux/tick.h>
 #include <linux/module.h>
 
+#include <trace/events/sched.h>
+
 #include <asm/irq_regs.h>
 
 #include "tick-internal.h"
@@ -428,9 +430,11 @@ void tick_nohz_stop_sched_tick(int inidle)
 		 * If the expiration time == KTIME_MAX, then
 		 * in this case we simply stop the tick timer.
 		 */
-		 if (unlikely(expires.tv64 == KTIME_MAX)) {
-			if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
+		if (unlikely(expires.tv64 == KTIME_MAX)) {
+			if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
+				trace_sched_tick_stop(&expires, inidle);
 				hrtimer_cancel(&ts->sched_timer);
+			}
 			goto out;
 		}
 
@@ -438,10 +442,15 @@ void tick_nohz_stop_sched_tick(int inidle)
 			hrtimer_start(&ts->sched_timer, expires,
 				      HRTIMER_MODE_ABS_PINNED);
 			/* Check, if the timer was already in the past */
-			if (hrtimer_active(&ts->sched_timer))
-				goto out;
-		} else if (!tick_program_event(expires, 0))
+			if (hrtimer_active(&ts->sched_timer)) {
+				trace_sched_tick_stop(&expires, inidle);
 				goto out;
+			}
+		} else if (!tick_program_event(expires, 0)) {
+			trace_sched_tick_stop(&expires, inidle);
+			goto out;
+		}
+
 		/*
 		 * We are past the event already. So we crossed a
 		 * jiffie boundary. Update jiffies and raise the
@@ -495,6 +504,8 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 		tick_do_update_jiffies64(now);
 		now = ktime_get();
 	}
+
+	trace_sched_tick_start(&now);
 }
 
 /**
-- 
1.6.4.2

