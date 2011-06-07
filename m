Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab1FGXzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:55:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64435 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1FGXzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:55:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sjMP9lu6C/wYSJnju4GnUVqjLtCFoOHFqR90owTJsKdSLaMH+cqvoO5fpPrptPJaRe
         fguee0rqzp+chMokDAnmJaUz431wRPBLcC4JvigKJSoXGQvQkqZalm4Rvvq7AwC7beRs
         675RYoNXTSaGM3eUxNbmkRGTiJ1HoDhEqRfO8=
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        johnstul@us.ibm.com, rostedt@goodmis.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/6] trace: add tracepoints to timekeeping code - xtime changes
Date: Tue,  7 Jun 2011 17:55:03 -0600
Message-Id: <1307490903-24600-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace points in timekeeping.c where xtime is modified by a user
or ntp.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/trace/events/timekeeping.h |   43 ++++++++++++++++++++++++++++++++++++
 kernel/time/timekeeping.c          |    8 ++++++
 2 files changed, 51 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/timekeeping.h

diff --git a/include/trace/events/timekeeping.h b/include/trace/events/timekeeping.h
new file mode 100644
index 0000000..3d5d083
--- /dev/null
+++ b/include/trace/events/timekeeping.h
@@ -0,0 +1,43 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM timekeeping
+
+#if !defined(_TRACE_TIMEKEEP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TIMEKEEP_H
+
+#include <linux/tracepoint.h>
+#include <linux/time.h>
+
+DECLARE_EVENT_CLASS(tod_template,
+
+	TP_PROTO(const struct timespec *tv),
+
+	TP_ARGS(tv),
+
+	TP_STRUCT__entry(
+		__field( __kernel_time_t,	tv_sec)
+		__field( long,			tv_nsec)
+	),
+
+	TP_fast_assign(
+		__entry->tv_sec  = tv->tv_sec;
+		__entry->tv_nsec = tv->tv_nsec;
+	),
+
+	TP_printk("tv_sec=%ld tv_nsec=%ld", __entry->tv_sec, __entry->tv_nsec)
+);
+
+DEFINE_EVENT(tod_template, settimeofday,
+	TP_PROTO(const struct timespec *tv),
+	TP_ARGS(tv));
+
+DEFINE_EVENT(tod_template, timekeeping_inject_offset,
+	TP_PROTO(const struct timespec *tv),
+	TP_ARGS(tv));
+
+DEFINE_EVENT(tod_template, timekeeping_inject_sleeptime,
+	TP_PROTO(const struct timespec *tv),
+	TP_ARGS(tv));
+#endif /*  _TRACE_TIMEKEEP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 342408c..fda1af1 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -21,6 +21,9 @@
 #include <linux/tick.h>
 #include <linux/stop_machine.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/timekeeping.h>
+
 /* Structure holding internal timekeeping values. */
 struct timekeeper {
 	/* Current clocksource used for timekeeping. */
@@ -361,6 +364,8 @@ int do_settimeofday(const struct timespec *tv)
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
+	trace_settimeofday(tv);
+
 	write_seqlock_irqsave(&xtime_lock, flags);
 
 	timekeeping_forward_now();
@@ -406,6 +411,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 	timekeeping_forward_now();
 
 	xtime = timespec_add(xtime, *ts);
+	trace_timekeeping_inject_offset(&xtime);
+
 	wall_to_monotonic = timespec_sub(wall_to_monotonic, *ts);
 
 	timekeeper.ntp_error = 0;
@@ -605,6 +612,7 @@ static struct timespec timekeeping_suspend_time;
 static void __timekeeping_inject_sleeptime(struct timespec *delta)
 {
 	xtime = timespec_add(xtime, *delta);
+	trace_timekeeping_inject_sleeptime(&xtime);
 	wall_to_monotonic = timespec_sub(wall_to_monotonic, *delta);
 	total_sleep_time = timespec_add(total_sleep_time, *delta);
 }
-- 
1.7.5.2

