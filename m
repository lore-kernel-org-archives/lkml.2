Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab2GRWnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:43:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24417 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2GRWj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:39:58 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=AbCFUN1qUT4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=D_SbEOMbAAAA:8 a=-9lkxPPxzbn_rGzBKkcA:9 a=7KbvKZvEaC0A:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120718223957.057787171@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 18 Jul 2012 18:39:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 02/12] Latency histograms: Adjust timer, if already elapsed when programmed
References: <20120718223910.898476857@goodmis.org>
Content-Disposition: inline; filename=0002-Latency-histograms-Adjust-timer-if-already-elapsed-w.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Emde <C.Emde@osadl.org>

Nothing prevents a programmer from calling clock_nanosleep() with an
already elapsed wakeup time in absolute time mode or with a too small
delay in relative time mode. Such timers cannot wake up in time and,
thus, should be corrected when entered into the missed timers latency
histogram (CONFIG_MISSED_TIMERS_HIST).

This patch marks such timers and uses a corrected expiration time.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/hrtimer.h |    3 +++
 kernel/hrtimer.c        |   16 ++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 0e37086..7408760 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
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
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index bb07742..363965f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1021,6 +1021,17 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
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
-- 
1.7.10.4


