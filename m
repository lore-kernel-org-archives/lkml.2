Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab0HXTGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:06:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36863 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab0HXTGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:06:35 -0400
Date: Tue, 24 Aug 2010 21:06:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100824190620.GA7636@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arjan van de Ven (1):
      tracing: Fix timer tracing

Peter Zijlstra (1):
      watchdog: Don't throttle the watchdog


 include/trace/events/timer.h |    8 ++++++--
 kernel/watchdog.c            |    3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index c624126..425bcfe 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -81,14 +81,16 @@ TRACE_EVENT(timer_expire_entry,
 	TP_STRUCT__entry(
 		__field( void *,	timer	)
 		__field( unsigned long,	now	)
+		__field( void *,	function)
 	),
 
 	TP_fast_assign(
 		__entry->timer		= timer;
 		__entry->now		= jiffies;
+		__entry->function	= timer->function;
 	),
 
-	TP_printk("timer=%p now=%lu", __entry->timer, __entry->now)
+	TP_printk("timer=%p function=%pf now=%lu", __entry->timer, __entry->function,__entry->now)
 );
 
 /**
@@ -200,14 +202,16 @@ TRACE_EVENT(hrtimer_expire_entry,
 	TP_STRUCT__entry(
 		__field( void *,	hrtimer	)
 		__field( s64,		now	)
+		__field( void *,	function)
 	),
 
 	TP_fast_assign(
 		__entry->hrtimer	= hrtimer;
 		__entry->now		= now->tv64;
+		__entry->function	= hrtimer->function;
 	),
 
-	TP_printk("hrtimer=%p now=%llu", __entry->hrtimer,
+	TP_printk("hrtimer=%p function=%pf now=%llu", __entry->hrtimer, __entry->function,
 		  (unsigned long long)ktime_to_ns((ktime_t) { .tv64 = __entry->now }))
  );
 
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 613bc1f..0d53c8e 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -206,6 +206,9 @@ void watchdog_overflow_callback(struct perf_event *event, int nmi,
 		 struct perf_sample_data *data,
 		 struct pt_regs *regs)
 {
+	/* Ensure the watchdog never gets throttled */
+	event->hw.interrupts = 0;
+
 	if (__get_cpu_var(watchdog_nmi_touch) == true) {
 		__get_cpu_var(watchdog_nmi_touch) = false;
 		return;
