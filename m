Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1GLTDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 15:03:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64204 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab1GLTDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 15:03:05 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=YgLnIgvRxaAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=JcUboQTwl3GirjIH0HwA:9 a=hBDNgFEv8QGArHrTfUkA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110712190302.751355888@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 12 Jul 2011 14:51:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 3/3] ftrace: Add extend-notrace-debug to see what is not traced
References: <20110712185131.698851699@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Add-extend-notrace-debug-to-see-what-is-not-t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Enabling extend-notrace causes functions not to be traced if it
is determined that its calling function is not traced. To be able
to debug this, the option extend-notrace-debug is added. It only
takes affect when extend-notrace is enabled.

When extend-notrace-debug is enabled, the functions traced when
extend-notrace is enabled is only the functions that would have
not been traced. In other words, extend-notrace-debug causes extend-notrace
to do the inverse of what it usually does. This allows the user
to see what functions may be missing when they enable extend-notrace.

It does not enable "notrace" functions themselves. It only traces
the functions that would have normally been traced if extend-notrace
was not enabled, but were skipped because of extend-notrace.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c           |    1 +
 kernel/trace/trace.h           |    1 +
 kernel/trace/trace_functions.c |   21 ++++++++++++++++-----
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dc8b945..3294549 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -425,6 +425,7 @@ static const char *trace_options[] = {
 	"record-cmd",
 	"overwrite",
 	"extend-notrace",
+	"extend-notrace-debug",
 	NULL
 };
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index bbef5a5..739eaf2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -618,6 +618,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_RECORD_CMD		= 0x100000,
 	TRACE_ITER_OVERWRITE		= 0x200000,
 	TRACE_ITER_EXTEND_NOTRACE	= 0x400000,
+	TRACE_ITER_DEBUG_EXTEND_NOTRACE	= 0x800000,
 };
 
 /*
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 73cf336..ff6c793 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -70,7 +70,7 @@ void trace_extend_notrace(int enable)
 /* 64 words depth to reset stack */
 #define STACK_OFFSET	(THREAD_SIZE - (64 * BITS_PER_LONG/8))
 
-static inline int skip_notrace(unsigned long ip, unsigned long parent_ip)
+static int __skip_notrace(unsigned long ip, unsigned long parent_ip)
 {
 	unsigned long offset;
 	unsigned long size;
@@ -79,10 +79,6 @@ static inline int skip_notrace(unsigned long ip, unsigned long parent_ip)
 	int curr_ret;
 	int i;
 
-	/* Optimize for this case to be off */
-	if (likely(!(trace_flags & TRACE_ITER_EXTEND_NOTRACE)))
-		return 0;
-
 	/*
 	 * We always trace NMIs, and do not update anything.
 	 * This code requires interrupts disabled.
@@ -189,6 +185,21 @@ static inline int skip_notrace(unsigned long ip, unsigned long parent_ip)
 	return 0;
 }
 
+static inline int skip_notrace(unsigned long ip, unsigned long parent_ip)
+{
+	int ret;
+
+	/* Optimize for this case to be off */
+	if (likely(!(trace_flags & TRACE_ITER_EXTEND_NOTRACE)))
+		return 0;
+
+	ret = __skip_notrace(ip, parent_ip);
+
+	if (trace_flags & TRACE_ITER_DEBUG_EXTEND_NOTRACE)
+		return !ret;
+	return ret;
+}
+
 static void
 function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
 {
-- 
1.7.5.4


