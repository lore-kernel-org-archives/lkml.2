Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab2L0CHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:07:04 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:58354 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2L0CHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:07:01 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: [PATCH 13/32] wait: Add wait_event_hrtimeout()
Date: Wed, 26 Dec 2012 17:59:51 -0800
Message-Id: <1356573611-18590-15-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1356573611-18590-1-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Analagous to wait_event_timeout() and friends, this adds
wait_event_hrtimeout() and wait_event_interruptible_hrtimeout().

Note that unlike the versions that use regular timers, these don't
return the amount of time remaining when they return - instead, they
return 0 or -ETIME if they timed out.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 include/linux/wait.h | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 168dfe1..3088723 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -330,6 +330,92 @@ do {									\
 	__ret;								\
 })
 
+#define __wait_event_hrtimeout(wq, condition, timeout, state)		\
+({									\
+	int __ret = 0;							\
+	DEFINE_WAIT(__wait);						\
+	struct hrtimer_sleeper __t;					\
+									\
+	hrtimer_init_on_stack(&__t.timer, CLOCK_MONOTONIC,		\
+			      HRTIMER_MODE_REL);			\
+	hrtimer_init_sleeper(&__t, current);				\
+	if ((timeout).tv64 != KTIME_MAX)				\
+		hrtimer_start_range_ns(&__t.timer, timeout,		\
+				       current->timer_slack_ns,		\
+				       HRTIMER_MODE_REL);		\
+									\
+	for (;;) {							\
+		prepare_to_wait(&wq, &__wait, state);			\
+		if (condition)						\
+			break;						\
+		if (state == TASK_INTERRUPTIBLE &&			\
+		    signal_pending(current)) {				\
+			__ret = -ERESTARTSYS;				\
+			break;						\
+		}							\
+		if (!__t.task) {					\
+			__ret = -ETIME;					\
+			break;						\
+		}							\
+		schedule();						\
+	}								\
+									\
+	hrtimer_cancel(&__t.timer);					\
+	destroy_hrtimer_on_stack(&__t.timer);				\
+	finish_wait(&wq, &__wait);					\
+	__ret;								\
+})
+
+/**
+ * wait_event_hrtimeout - sleep until a condition gets true or a timeout elapses
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true or a signal is received.
+ * The @condition is checked each time the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function returns 0 if @condition became true, or -ETIME if the timeout
+ * elapsed.
+ */
+#define wait_event_hrtimeout(wq, condition, timeout)			\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__ret = __wait_event_hrtimeout(wq, condition, timeout,	\
+					       TASK_UNINTERRUPTIBLE);	\
+	__ret;								\
+})
+
+/**
+ * wait_event_interruptible_hrtimeout - sleep until a condition gets true or a timeout elapses
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or a signal is received.
+ * The @condition is checked each time the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function returns 0 if @condition became true, -ERESTARTSYS if it was
+ * interrupted by a signal, or -ETIME if the timeout elapsed.
+ */
+#define wait_event_interruptible_hrtimeout(wq, condition, timeout)	\
+({									\
+	long __ret = 0;							\
+	if (!(condition))						\
+		__ret = __wait_event_hrtimeout(wq, condition, timeout,	\
+					       TASK_INTERRUPTIBLE);	\
+	__ret;								\
+})
+
 #define __wait_event_interruptible_exclusive(wq, condition, ret)	\
 do {									\
 	DEFINE_WAIT(__wait);						\
-- 
1.7.12

