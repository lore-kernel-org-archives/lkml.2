Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0F2DKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 23:10:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab0F2DKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 23:10:46 -0400
X-Authority-Analysis: v=1.1 cv=4GK1Slht3WUdSXXcSOu+TCe3GQnvEFDsQSvVHKX2gdo= c=1 sm=0 a=u9PH3OwKA1oA:10 a=yQWWgrYGNuUA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=1uYMXvUWzqrHaGpRq8sA:9 a=O0Duwt1hk9UVHV5i46gA:7 a=SSbqU3xKtcxf36IyRKLYSpQVhXwA:4 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100629031043.366916240@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 28 Jun 2010 23:08:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/9] tracing: Convert some timer events to DEFINE_EVENT
References: <20100629030836.222433712@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Convert-some-timer-events-to-DEFINE_EVENT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Use DECLARE_EVENT_CLASS, and save ~2.3K:

   text    data     bss     dec     hex filename
7018823 2031888 7251132 16301843         f8bf13 vmlinux.o.orig
7016727 2031696 7251132 16299555         f8b623 vmlinux.o

5 events are converted:

  timer_class:   timer_init, timer_expire_exit, timer_cancel
  hrtimer_class: hrtimer_init, hrtimer_cancel

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4BFA3773.3060200@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/timer.h |   80 +++++++++++++++++-------------------------
 1 files changed, 32 insertions(+), 48 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 9496b96..c624126 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -8,11 +8,7 @@
 #include <linux/hrtimer.h>
 #include <linux/timer.h>
 
-/**
- * timer_init - called when the timer is initialized
- * @timer:	pointer to struct timer_list
- */
-TRACE_EVENT(timer_init,
+DECLARE_EVENT_CLASS(timer_class,
 
 	TP_PROTO(struct timer_list *timer),
 
@@ -30,6 +26,17 @@ TRACE_EVENT(timer_init,
 );
 
 /**
+ * timer_init - called when the timer is initialized
+ * @timer:	pointer to struct timer_list
+ */
+DEFINE_EVENT(timer_class, timer_init,
+
+	TP_PROTO(struct timer_list *timer),
+
+	TP_ARGS(timer)
+);
+
+/**
  * timer_start - called when the timer is started
  * @timer:	pointer to struct timer_list
  * @expires:	the timers expiry time
@@ -94,42 +101,22 @@ TRACE_EVENT(timer_expire_entry,
  * NOTE: Do NOT derefernce timer in TP_fast_assign. The pointer might
  * be invalid. We solely track the pointer.
  */
-TRACE_EVENT(timer_expire_exit,
+DEFINE_EVENT(timer_class, timer_expire_exit,
 
 	TP_PROTO(struct timer_list *timer),
 
-	TP_ARGS(timer),
-
-	TP_STRUCT__entry(
-		__field(void *,	timer	)
-	),
-
-	TP_fast_assign(
-		__entry->timer	= timer;
-	),
-
-	TP_printk("timer=%p", __entry->timer)
+	TP_ARGS(timer)
 );
 
 /**
  * timer_cancel - called when the timer is canceled
  * @timer:	pointer to struct timer_list
  */
-TRACE_EVENT(timer_cancel,
+DEFINE_EVENT(timer_class, timer_cancel,
 
 	TP_PROTO(struct timer_list *timer),
 
-	TP_ARGS(timer),
-
-	TP_STRUCT__entry(
-		__field( void *,	timer	)
-	),
-
-	TP_fast_assign(
-		__entry->timer	= timer;
-	),
-
-	TP_printk("timer=%p", __entry->timer)
+	TP_ARGS(timer)
 );
 
 /**
@@ -224,14 +211,7 @@ TRACE_EVENT(hrtimer_expire_entry,
 		  (unsigned long long)ktime_to_ns((ktime_t) { .tv64 = __entry->now }))
  );
 
-/**
- * hrtimer_expire_exit - called immediately after the hrtimer callback returns
- * @timer:	pointer to struct hrtimer
- *
- * When used in combination with the hrtimer_expire_entry tracepoint we can
- * determine the runtime of the callback function.
- */
-TRACE_EVENT(hrtimer_expire_exit,
+DECLARE_EVENT_CLASS(hrtimer_class,
 
 	TP_PROTO(struct hrtimer *hrtimer),
 
@@ -249,24 +229,28 @@ TRACE_EVENT(hrtimer_expire_exit,
 );
 
 /**
- * hrtimer_cancel - called when the hrtimer is canceled
- * @hrtimer:	pointer to struct hrtimer
+ * hrtimer_expire_exit - called immediately after the hrtimer callback returns
+ * @timer:	pointer to struct hrtimer
+ *
+ * When used in combination with the hrtimer_expire_entry tracepoint we can
+ * determine the runtime of the callback function.
  */
-TRACE_EVENT(hrtimer_cancel,
+DEFINE_EVENT(hrtimer_class, hrtimer_expire_exit,
 
 	TP_PROTO(struct hrtimer *hrtimer),
 
-	TP_ARGS(hrtimer),
+	TP_ARGS(hrtimer)
+);
 
-	TP_STRUCT__entry(
-		__field( void *,	hrtimer	)
-	),
+/**
+ * hrtimer_cancel - called when the hrtimer is canceled
+ * @hrtimer:	pointer to struct hrtimer
+ */
+DEFINE_EVENT(hrtimer_class, hrtimer_cancel,
 
-	TP_fast_assign(
-		__entry->hrtimer	= hrtimer;
-	),
+	TP_PROTO(struct hrtimer *hrtimer),
 
-	TP_printk("hrtimer=%p", __entry->hrtimer)
+	TP_ARGS(hrtimer)
 );
 
 /**
-- 
1.7.1


