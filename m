Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab0EXIU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 04:20:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52309 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755987Ab0EXIU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 04:20:57 -0400
Message-ID: <4BFA3773.3060200@cn.fujitsu.com>
Date: Mon, 24 May 2010 16:23:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 3/8] tracing: Convert some timer events to DEFINE_EVENT
References: <4BFA3728.3000701@cn.fujitsu.com>
In-Reply-To: <4BFA3728.3000701@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DECLARE_EVENT_CLASS, and save ~2.3K:

   text    data     bss     dec     hex filename
7018823 2031888 7251132 16301843         f8bf13 vmlinux.o.orig
7016727 2031696 7251132 16299555         f8b623 vmlinux.o

5 events are converted:

  timer_class:   timer_init, timer_expire_exit, timer_cancel
  hrtimer_class: hrtimer_init, hrtimer_cancel

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.6.3

