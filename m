Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab0F2JWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:22:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:39147 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625Ab0F2JWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:22:43 -0400
Date: Tue, 29 Jun 2010 09:22:19 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4BFA3773.3060200@cn.fujitsu.com>
References: <4BFA3773.3060200@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Convert some timer events to DEFINE_EVENT
Message-ID: <tip-363d0f6490f319d0dd69b7ec7503c5f6cbab36d9@git.kernel.org>
Git-Commit-ID: 363d0f6490f319d0dd69b7ec7503c5f6cbab36d9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 09:22:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  363d0f6490f319d0dd69b7ec7503c5f6cbab36d9
Gitweb:     http://git.kernel.org/tip/363d0f6490f319d0dd69b7ec7503c5f6cbab36d9
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 24 May 2010 16:23:15 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 28 Jun 2010 17:12:48 -0400

tracing: Convert some timer events to DEFINE_EVENT

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
