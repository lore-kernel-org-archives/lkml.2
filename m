Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2AQMtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:49:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57135 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab2AQMto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:49:44 -0500
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH 1/3] hrtimers: teach usleep_range() to return how many usecs was slept
Date: Tue, 17 Jan 2012 16:50:27 +0400
Message-Id: <1326804627-17660-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teach usleep_range() to return how many usecs was actually spent in
sleep. The rationale beyond this is to convert jiffies-based time-bound
wait-for-hardware loops from using msleep() to usleep_range().

Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 fs/eventpoll.c          |    2 +-
 fs/select.c             |    2 +-
 include/linux/delay.h   |    2 +-
 include/linux/hrtimer.h |    9 ++++++---
 ipc/mqueue.c            |    2 +-
 kernel/hrtimer.c        |   28 ++++++++++++++++++++++++----
 kernel/timer.c          |   11 ++++++-----
 7 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index aabdfc3..7a957fd 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1349,7 +1349,7 @@ fetch_events:
 			}
 
 			spin_unlock_irqrestore(&ep->lock, flags);
-			if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
+			if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS, NULL))
 				timed_out = 1;
 
 			spin_lock_irqsave(&ep->lock, flags);
diff --git a/fs/select.c b/fs/select.c
index d33418f..eceb573 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -236,7 +236,7 @@ int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
 
 	set_current_state(state);
 	if (!pwq->triggered)
-		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
+		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS, NULL);
 	__set_current_state(TASK_RUNNING);
 
 	/*
diff --git a/include/linux/delay.h b/include/linux/delay.h
index a6ecb34..e512a50 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -45,7 +45,7 @@ extern unsigned long lpj_fine;
 void calibrate_delay(void);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
-void usleep_range(unsigned long min, unsigned long max);
+unsigned long usleep_range(unsigned long min, unsigned long max);
 
 static inline void ssleep(unsigned int seconds)
 {
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index fd0dc30..661dd25 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -128,6 +128,7 @@ struct hrtimer {
 struct hrtimer_sleeper {
 	struct hrtimer timer;
 	struct task_struct *task;
+	ktime_t elapsed;
 };
 
 /**
@@ -429,9 +430,11 @@ extern void hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
 				 struct task_struct *tsk);
 
 extern int schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
-						const enum hrtimer_mode mode);
-extern int schedule_hrtimeout_range_clock(ktime_t *expires,
-		unsigned long delta, const enum hrtimer_mode mode, int clock);
+				    const enum hrtimer_mode mode,
+				    unsigned long *elapsed);
+extern int schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
+					  const enum hrtimer_mode mode, int clock,
+					  unsigned long *elapsed);
 extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode);
 
 /* Soft interrupt function to run the hrtimer queues: */
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 9b7c8ab..578cce7 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -450,7 +450,7 @@ static int wq_sleep(struct mqueue_inode_info *info, int sr,
 
 		spin_unlock(&info->lock);
 		time = schedule_hrtimeout_range_clock(timeout, 0,
-			HRTIMER_MODE_ABS, CLOCK_REALTIME);
+		        HRTIMER_MODE_ABS, CLOCK_REALTIME, NULL);
 
 		while (ewp->state == STATE_PENDING)
 			cpu_relax();
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ae34bf5..75c9c5c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1475,6 +1475,12 @@ static enum hrtimer_restart hrtimer_wakeup(struct hrtimer *timer)
 	struct hrtimer_sleeper *t =
 		container_of(timer, struct hrtimer_sleeper, timer);
 	struct task_struct *task = t->task;
+	struct hrtimer_clock_base *base;
+	unsigned long flags;
+
+	base = lock_hrtimer_base(timer, &flags);
+	t->elapsed = ktime_sub(base->get_time(), t->elapsed);
+	unlock_hrtimer_base(timer, &flags);
 
 	t->task = NULL;
 	if (task)
@@ -1485,6 +1491,13 @@ static enum hrtimer_restart hrtimer_wakeup(struct hrtimer *timer)
 
 void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, struct task_struct *task)
 {
+	struct hrtimer_clock_base *base;
+	unsigned long flags;
+
+	base = lock_hrtimer_base(&sl->timer, &flags);
+	sl->elapsed = base->get_time();
+	unlock_hrtimer_base(&sl->timer, &flags);
+
 	sl->timer.function = hrtimer_wakeup;
 	sl->task = task;
 }
@@ -1750,10 +1763,13 @@ void __init hrtimers_init(void)
  * @delta:	slack in expires timeout (ktime_t)
  * @mode:	timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
  * @clock:	timer clock, CLOCK_MONOTONIC or CLOCK_REALTIME
+ * @elapsed:	pointer to unsigned long variable where to store
+ * 		the time actually slept in timeout (usecs)
  */
 int __sched
 schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
-			       const enum hrtimer_mode mode, int clock)
+			       const enum hrtimer_mode mode, int clock,
+			       unsigned long *elapsed)
 {
 	struct hrtimer_sleeper t;
 
@@ -1787,6 +1803,8 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
 	if (likely(t.task))
 		schedule();
 
+	if (elapsed)
+		*elapsed = ktime_to_us(t.elapsed);
 	hrtimer_cancel(&t.timer);
 	destroy_hrtimer_on_stack(&t.timer);
 
@@ -1800,6 +1818,8 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
  * @expires:	timeout value (ktime_t)
  * @delta:	slack in expires timeout (ktime_t)
  * @mode:	timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
+ * @elapsed:	pointer to unsigned long variable where to store
+ *		the time actually slept in timeout (usecs)
  *
  * Make the current task sleep until the given expiry time has
  * elapsed. The routine will return immediately unless
@@ -1824,10 +1844,10 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
  * Returns 0 when the timer has expired otherwise -EINTR
  */
 int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
-				     const enum hrtimer_mode mode)
+				     const enum hrtimer_mode mode, unsigned long *elapsed)
 {
 	return schedule_hrtimeout_range_clock(expires, delta, mode,
-					      CLOCK_MONOTONIC);
+					      CLOCK_MONOTONIC, elapsed);
 }
 EXPORT_SYMBOL_GPL(schedule_hrtimeout_range);
 
@@ -1856,6 +1876,6 @@ EXPORT_SYMBOL_GPL(schedule_hrtimeout_range);
 int __sched schedule_hrtimeout(ktime_t *expires,
 			       const enum hrtimer_mode mode)
 {
-	return schedule_hrtimeout_range(expires, 0, mode);
+	return schedule_hrtimeout_range(expires, 0, mode, NULL);
 }
 EXPORT_SYMBOL_GPL(schedule_hrtimeout);
diff --git a/kernel/timer.c b/kernel/timer.c
index a297ffc..2a52040 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1819,14 +1819,15 @@ unsigned long msleep_interruptible(unsigned int msecs)
 
 EXPORT_SYMBOL(msleep_interruptible);
 
-static int __sched do_usleep_range(unsigned long min, unsigned long max)
+static unsigned long __sched do_usleep_range(unsigned long min, unsigned long max)
 {
 	ktime_t kmin;
-	unsigned long delta;
+	unsigned long elapsed, delta;
 
 	kmin = ktime_set(0, min * NSEC_PER_USEC);
 	delta = (max - min) * NSEC_PER_USEC;
-	return schedule_hrtimeout_range(&kmin, delta, HRTIMER_MODE_REL);
+	return schedule_hrtimeout_range(&kmin, delta, HRTIMER_MODE_REL,
+					&elapsed) ? 0 : elapsed;
 }
 
 /**
@@ -1834,9 +1835,9 @@ static int __sched do_usleep_range(unsigned long min, unsigned long max)
  * @min: Minimum time in usecs to sleep
  * @max: Maximum time in usecs to sleep
  */
-void usleep_range(unsigned long min, unsigned long max)
+unsigned long usleep_range(unsigned long min, unsigned long max)
 {
 	__set_current_state(TASK_UNINTERRUPTIBLE);
-	do_usleep_range(min, max);
+	return do_usleep_range(min, max);
 }
 EXPORT_SYMBOL(usleep_range);
-- 
1.7.7.5

