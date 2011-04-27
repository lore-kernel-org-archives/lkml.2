Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1D0Kpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:45:44 -0400
Received: from smtp.nokia.com ([147.243.128.26]:64362 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757839Ab1D0Ko6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:44:58 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 4/4] timerfd: add cancellation
Date: Wed, 27 Apr 2011 13:43:43 +0300
Message-Id: <1303901023-11568-4-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303901023-11568-1-git-send-email-virtuoso@slind.org>
References: <alpine.LFD.2.00.1103102040190.2787@localhost6.localdomain6>
 <1303901023-11568-1-git-send-email-virtuoso@slind.org>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements conditional cancellation for timerfd timers.
Similarly to clock_nanosleep, users who want to be woken up when
system time changes have to use TFD_CANCEL_ON_CLOCK_SET flag and
monotonic vs realtime offset, obtained from clock_rtoffset system
call, in otmr.it_interval to timerfd_settime() call. This is only
supported for absolute timers (TFD_TIMER_ABSTIME).

If the provided monotonic offset is still effective, poll on the
timerfd will sleep until either the requested time comes or somebody
changes the system time, in which case the system call will return
POLLHUP. If the monotonic offset has changed by the time of calling
timerfd_settime(), it will return ECANCELLED straight away. This
seems more straightforward than returning POLLIN from poll and only
returning error from read.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: John Stultz <johnstul@us.ibm.com>
CC: Chris Friesen <chris.friesen@genband.com>
CC: Kay Sievers <kay.sievers@vrfy.org>
CC: Kirill A. Shutemov <kirill@shutemov.name>
CC: linux-kernel@vger.kernel.org
---
 fs/timerfd.c            |   40 +++++++++++++++++++++++++++++++++++++++-
 include/linux/timerfd.h |    3 ++-
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 8c4fc14..1955552 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -59,6 +59,16 @@ static ktime_t timerfd_get_remaining(struct timerfd_ctx *ctx)
 	return remaining.tv64 < 0 ? ktime_set(0, 0): remaining;
 }
 
+static void timerfd_canceller(struct hrtimer *timer)
+{
+	struct timerfd_ctx *ctx = container_of(timer, struct timerfd_ctx, tmr);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
+	wake_up_locked(&ctx->wqh);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+}
+
 static void timerfd_setup(struct timerfd_ctx *ctx, int flags,
 			  const struct itimerspec *ktmr)
 {
@@ -99,6 +109,8 @@ static unsigned int timerfd_poll(struct file *file, poll_table *wait)
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	if (ctx->ticks)
 		events |= POLLIN;
+	if (ctx->tmr.cancel.cancelled)
+		events |= POLLHUP;
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return events;
@@ -117,7 +129,15 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 	if (file->f_flags & O_NONBLOCK)
 		res = -EAGAIN;
 	else
-		res = wait_event_interruptible_locked_irq(ctx->wqh, ctx->ticks);
+		res = wait_event_interruptible_locked_irq(ctx->wqh, ctx->ticks
+						 || ctx->tmr.cancel.cancelled);
+
+	/* if the timer is being cancelled, don't rearm it */
+	if (ctx->tmr.cancel.cancelled) {
+		spin_unlock_irq(&ctx->wqh.lock);
+		return -ECANCELED;
+	}
+
 	if (ctx->ticks) {
 		ticks = ctx->ticks;
 		if (ctx->expired && ctx->tintv.tv64) {
@@ -197,6 +217,7 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 		struct itimerspec __user *, otmr)
 {
 	struct file *file;
+	struct timespec offset;
 	struct timerfd_ctx *ctx;
 	struct itimerspec ktmr, kotmr;
 
@@ -208,6 +229,14 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 	    !timespec_valid(&ktmr.it_interval))
 		return -EINVAL;
 
+	if (flags & TFD_CANCEL_ON_CLOCK_SET) {
+		if (!otmr || !(flags & TFD_TIMER_ABSTIME))
+			return -EINVAL;
+		if (copy_from_user(&kotmr, otmr, sizeof(kotmr)))
+			return -EFAULT;
+		offset = kotmr.it_interval;
+	}
+
 	file = timerfd_fget(ufd);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
@@ -242,6 +271,15 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 	 */
 	timerfd_setup(ctx, flags, &ktmr);
 
+	if ((flags & TFD_CANCEL_ON_CLOCK_SET) &&
+	    hrtimer_set_cancel_on_clock_set(&ctx->tmr, &offset,
+					    timerfd_canceller)) {
+		hrtimer_cancel(&ctx->tmr);
+		spin_unlock_irq(&ctx->wqh.lock);
+		fput(file);
+		return -ECANCELED;
+	}
+
 	spin_unlock_irq(&ctx->wqh.lock);
 	fput(file);
 	if (otmr && copy_to_user(otmr, &kotmr, sizeof(kotmr)))
diff --git a/include/linux/timerfd.h b/include/linux/timerfd.h
index 2d07929..f4cd638 100644
--- a/include/linux/timerfd.h
+++ b/include/linux/timerfd.h
@@ -19,6 +19,7 @@
  * shared O_* flags.
  */
 #define TFD_TIMER_ABSTIME (1 << 0)
+#define TFD_CANCEL_ON_CLOCK_SET (1 << 1)
 #define TFD_CLOEXEC O_CLOEXEC
 #define TFD_NONBLOCK O_NONBLOCK
 
@@ -26,6 +27,6 @@
 /* Flags for timerfd_create.  */
 #define TFD_CREATE_FLAGS TFD_SHARED_FCNTL_FLAGS
 /* Flags for timerfd_settime.  */
-#define TFD_SETTIME_FLAGS TFD_TIMER_ABSTIME
+#define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_CANCEL_ON_CLOCK_SET)
 
 #endif /* _LINUX_TIMERFD_H */
-- 
1.7.4.1

