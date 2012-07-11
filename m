Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030390Ab2GKWHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:07:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:35495 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2GKWFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:05:19 -0400
Message-Id: <20120711215611.727482885@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 11 Jul 2012 22:05:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        RT-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <cbe@osadl.org>
Subject: [patch RT 2/7] Latency histograms: Adjust timer,
 if already elapsed when programmed
References: <20120711214552.036760674@linutronix.de>
Content-Disposition: inline;
 filename=latency-histograms-adjust-timer-if-already-elapsed-when-programmed.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing prevents a programmer from calling clock_nanosleep() with an
already elapsed wakeup time in absolute time mode or with a too small
delay in relative time mode. Such timers cannot wake up in time and,
thus, should be corrected when entered into the missed timers latency
histogram (CONFIG_MISSED_TIMERS_HIST).

This patch marks such timers and uses a corrected expiration time. 

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/hrtimer.h |    3 +++
 kernel/hrtimer.c        |   16 ++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

Index: linux-3.4.2-rt10-64+/include/linux/hrtimer.h
===================================================================
--- linux-3.4.2-rt10-64+.orig/include/linux/hrtimer.h
+++ linux-3.4.2-rt10-64+/include/linux/hrtimer.h
@@ -113,6 +113,9 @@ struct hrtimer {
 	unsigned long			state;
 	struct list_head		cb_entry;
 	int				irqsafe;
+#ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
+	ktime_t 			praecox;
+#endif
 #ifdef CONFIG_TIMER_STATS
 	int				start_pid;
 	void				*start_site;
Index: linux-3.4.2-rt10-64+/kernel/hrtimer.c
===================================================================
--- linux-3.4.2-rt10-64+.orig/kernel/hrtimer.c
+++ linux-3.4.2-rt10-64+/kernel/hrtimer.c
@@ -1021,6 +1021,17 @@ int __hrtimer_start_range_ns(struct hrti
 #endif
 	}
 
+#ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
+	{
+		ktime_t now = new_base->get_time();
+
+		if (ktime_to_ns(tim) < ktime_to_ns(now))
+			timer->praecox = now;
+		else
+			timer->praecox = ktime_set(0, 0);
+	}
+#endif
+
 	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
 
 	timer_stats_hrtimer_set_start_info(timer);
@@ -1458,8 +1469,9 @@ retry:
 			timer = container_of(node, struct hrtimer, node);
 
 			trace_hrtimer_interrupt(raw_smp_processor_id(),
-			    ktime_to_ns(ktime_sub(
-				hrtimer_get_expires(timer), basenow)),
+			    ktime_to_ns(ktime_sub(ktime_to_ns(timer->praecox) ?
+				timer->praecox : hrtimer_get_expires(timer),
+				basenow)),
 			    current,
 			    timer->function == hrtimer_wakeup ?
 			    container_of(timer, struct hrtimer_sleeper,





