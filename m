Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab2IBFtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 01:49:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62276 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2IBFtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 01:49:16 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 4/4] timerfd: Add support for deferrable timers
Date: Sat,  1 Sep 2012 22:45:22 -0700
Message-Id: <1346564722-14408-4-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <20120902054335.GA12741@lizard>
References: <20120902054335.GA12741@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a userland-side API for generic deferrable timers,
per linux/timer.h:

 * A deferrable timer will work normally when the system is busy, but
 * will not cause a CPU to come out of idle just to service it; instead,
 * the timer will be serviced when the CPU eventually wakes up with a
 * subsequent non-deferrable timer.

These timers are crucial for power saving, i.e. periodic tasks that want
to work in background when the system is under use, but don't want to
cause wakeups themselves.

The deferred timers are somewhat orthogonal to high-res external timers,
since the deferred timer is tied to the system load, not just to some
external decrementer source.

So, currently, the implementation has a HZ precision, and the maximum
interval is jiffies resolution (i.e. with HZ=1000, on 32 bit that would
be around max 49 days).  Of course we can implement longer timeouts by
rearming the timer, although it probably  wouldn't make much sense in
real world, so we keep it simple and just return E2BIG if we don't like
the interval.

Note that the code is still using time calculation that is done by the
hrtimer routines, so we pretty much reuse everything except for the
timer events themselves (i.e. we use calculation results of
hrtimer_forward_now() and hrtimer_expires_remaining(), but never start
the hrtimer). So the code path is pretty much the same for both hrtimers
and deferrable timers.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/timerfd.c            | 65 ++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/timerfd.h |  4 ++-
 2 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 222db32..d608a57 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -18,6 +18,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/time.h>
+#include <linux/timer.h>
 #include <linux/hrtimer.h>
 #include <linux/anon_inodes.h>
 #include <linux/timerfd.h>
@@ -26,6 +27,8 @@
 
 struct timerfd_ctx {
 	struct hrtimer tmr;
+	struct timer_list dtmr;
+	bool deferrable;
 	ktime_t tintv;
 	ktime_t moffs;
 	wait_queue_head_t wqh;
@@ -63,6 +66,11 @@ static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
 	return HRTIMER_NORESTART;
 }
 
+static void timerfd_dtmrproc(unsigned long data)
+{
+	timerfd_expire((struct timerfd_ctx *)data);
+}
+
 /*
  * Called when the clock was set to cancel the timers in the cancel
  * list. This will wake up processes waiting on these timers. The
@@ -131,6 +139,30 @@ static ktime_t timerfd_get_remaining(struct timerfd_ctx *ctx)
 	return remaining.tv64 < 0 ? ktime_set(0, 0): remaining;
 }
 
+static bool timerfd_deferrable_valid(ktime_t intv)
+{
+	ktime_t max;
+
+	jiffies_to_ktime(MAX_JIFFY_OFFSET, &max);
+	if (intv.tv64 > max.tv64)
+		return 0;
+	return 1;
+}
+
+static int timerfd_setup_deferrable(struct timerfd_ctx *ctx)
+{
+	ktime_t rem = timerfd_get_remaining(ctx);
+
+	if (ctx->clockid != CLOCK_MONOTONIC)
+		return -EINVAL;
+	if (!timerfd_deferrable_valid(ctx->tintv) ||
+			!timerfd_deferrable_valid(rem))
+		return -E2BIG;
+
+	mod_timer(&ctx->dtmr, jiffies + ktime_to_jiffies(&rem) + 1);
+	return 0;
+}
+
 static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
 			 const struct itimerspec *ktmr)
 {
@@ -148,8 +180,18 @@ static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
 	hrtimer_init(&ctx->tmr, clockid, htmode);
 	hrtimer_set_expires(&ctx->tmr, texp);
 	ctx->tmr.function = timerfd_tmrproc;
+	ctx->dtmr.function = timerfd_dtmrproc;
+	ctx->dtmr.data = (unsigned long)ctx;
 	if (texp.tv64 != 0) {
-		hrtimer_start(&ctx->tmr, texp, htmode);
+		if (ctx->deferrable) {
+			int ret;
+
+			ret = timerfd_setup_deferrable(ctx);
+			if (ret)
+				return ret;
+		} else {
+			hrtimer_start(&ctx->tmr, texp, htmode);
+		}
 		if (timerfd_canceled(ctx))
 			return -ECANCELED;
 	}
@@ -162,6 +204,7 @@ static int timerfd_release(struct inode *inode, struct file *file)
 
 	timerfd_remove_cancel(ctx);
 	hrtimer_cancel(&ctx->tmr);
+	del_timer_sync(&ctx->dtmr);
 	kfree_rcu(ctx, rcu);
 	return 0;
 }
@@ -186,7 +229,12 @@ static u64 timerfd_rearm(struct timerfd_ctx *ctx)
 {
 	u64 orun = hrtimer_forward_now(&ctx->tmr, ctx->tintv) - 1;
 
-	hrtimer_restart(&ctx->tmr);
+	if (ctx->deferrable)
+		mod_timer(&ctx->dtmr, jiffies +
+			  ktime_to_jiffies(&ctx->tintv) + 1);
+	else
+		hrtimer_restart(&ctx->tmr);
+
 	return orun;
 }
 
@@ -280,6 +328,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 	init_waitqueue_head(&ctx->wqh);
 	ctx->clockid = clockid;
 	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
+	init_timer_deferrable(&ctx->dtmr);
 	ctx->moffs = ktime_get_monotonic_offset();
 
 	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
@@ -319,13 +368,23 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 	 * it to the new values.
 	 */
 	for (;;) {
+		int canceled;
+
 		spin_lock_irq(&ctx->wqh.lock);
-		if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
+		if (ctx->deferrable)
+			canceled = try_to_del_timer_sync(&ctx->dtmr);
+		else
+			canceled = hrtimer_try_to_cancel(&ctx->tmr);
+
+		if (canceled >= 0)
 			break;
 		spin_unlock_irq(&ctx->wqh.lock);
 		cpu_relax();
 	}
 
+	/* Must set a new value after we cancel the previous timer. */
+	ctx->deferrable = flags & TFD_TIMER_DEFERRABLE;
+
 	/*
 	 * If the timer is expired and it's periodic, we need to advance it
 	 * because the caller may want to know the previous expiration time.
diff --git a/include/linux/timerfd.h b/include/linux/timerfd.h
index d3b57fa..33d9842 100644
--- a/include/linux/timerfd.h
+++ b/include/linux/timerfd.h
@@ -20,6 +20,7 @@
  */
 #define TFD_TIMER_ABSTIME (1 << 0)
 #define TFD_TIMER_CANCEL_ON_SET (1 << 1)
+#define TFD_TIMER_DEFERRABLE (1 << 2)
 #define TFD_CLOEXEC O_CLOEXEC
 #define TFD_NONBLOCK O_NONBLOCK
 
@@ -27,6 +28,7 @@
 /* Flags for timerfd_create.  */
 #define TFD_CREATE_FLAGS TFD_SHARED_FCNTL_FLAGS
 /* Flags for timerfd_settime.  */
-#define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCEL_ON_SET)
+#define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCEL_ON_SET | \
+			   TFD_TIMER_DEFERRABLE)
 
 #endif /* _LINUX_TIMERFD_H */
-- 
1.7.11.5

