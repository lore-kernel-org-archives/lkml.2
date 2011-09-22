Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1IVWKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:10:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab1IVWKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:37 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=JTJjGMz_lYAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=5sU7d8Blh2ELxk-3s9YA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221029.678324653@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 19/21] tracing: Account for preempt off in preempt_schedule()
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0019-tracing-Account-for-preempt-off-in-preempt_schedule.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The preempt_schedule() uses the preempt_disable_notrace() version
because it can cause infinite recursion by the function tracer as
the function tracer uses preempt_enable_notrace() which may call
back into the preempt_schedule() code as the NEED_RESCHED is still
set and the PREEMPT_ACTIVE has not been set yet.

See commit: d1f74e20b5b064a130cd0743a256c2d3cfe84010 that made this
change.

The preemptoff and preemptirqsoff latency tracers require the first
and last preempt count modifiers to enable tracing. But this skips
the checks. Since we can not convert them back to the non notrace
version, we can use the idle() hooks for the latency tracers here.
That is, the start/stop_critical_timings() works well to manually
start and stop the latency tracer for preempt off timings.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ccacdbd..4b096cc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4435,7 +4435,16 @@ asmlinkage void __sched notrace preempt_schedule(void)
 
 	do {
 		add_preempt_count_notrace(PREEMPT_ACTIVE);
+		/*
+		 * The add/subtract must not be traced by the function
+		 * tracer. But we still want to account for the
+		 * preempt off latency tracer. Since the _notrace versions
+		 * of add/subtract skip the accounting for latency tracer
+		 * we must force it manually.
+		 */
+		start_critical_timings();
 		schedule();
+		stop_critical_timings();
 		sub_preempt_count_notrace(PREEMPT_ACTIVE);
 
 		/*
-- 
1.7.5.4


