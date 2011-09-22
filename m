Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab1IVWMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:12:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab1IVWKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:32 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Ym3AP53ZtgIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=ZTsbKecoXV8ulAn1bFYA:9 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221029.136544796@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>
Subject: [PATCH 17/21] tracing: Add a counter clock for those that do not trust clocks
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0017-tracing-Add-a-counter-clock-for-those-that-do-not-tr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When debugging tight race conditions, it can be helpful to have a
synchronized tracing method. Although in most cases the global clock
provides this functionality, if timings is not the issue, it is more
comforting to know that the order of events really happened in a precise
order.

Instead of using a clock, add a "counter" that is simply an incrementing
atomic 64bit counter that orders the events as they are perceived to
happen.

The trace_clock_counter() is added from the attempt by Peter Zijlstra
trying to convert the trace_clock_global() to it. I took Peter's counter
code and made trace_clock_counter() instead, and added it to the choice
of clocks. Just echo counter > /debug/tracing/trace_clock to activate
it.

Requested-by: Thomas Gleixner <tglx@linutronix.de>
Requested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/trace_clock.h |    1 +
 kernel/trace/trace.c        |    1 +
 kernel/trace/trace_clock.c  |   12 ++++++++++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
index 7a81303..4eb4902 100644
--- a/include/linux/trace_clock.h
+++ b/include/linux/trace_clock.h
@@ -15,5 +15,6 @@
 extern u64 notrace trace_clock_local(void);
 extern u64 notrace trace_clock(void);
 extern u64 notrace trace_clock_global(void);
+extern u64 notrace trace_clock_counter(void);
 
 #endif /* _LINUX_TRACE_CLOCK_H */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b419070..4b8df0d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -435,6 +435,7 @@ static struct {
 } trace_clocks[] = {
 	{ trace_clock_local,	"local" },
 	{ trace_clock_global,	"global" },
+	{ trace_clock_counter,	"counter" },
 };
 
 int trace_clock_id;
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 6302747..3947835 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -113,3 +113,15 @@ u64 notrace trace_clock_global(void)
 
 	return now;
 }
+
+static atomic64_t trace_counter;
+
+/*
+ * trace_clock_counter(): simply an atomic counter.
+ * Use the trace_counter "counter" for cases where you do not care
+ * about timings, but are interested in strict ordering.
+ */
+u64 notrace trace_clock_counter(void)
+{
+	return atomic64_add_return(1, &trace_counter);
+}
-- 
1.7.5.4


