Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab1D0Ko7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:44:59 -0400
Received: from smtp.nokia.com ([147.243.128.26]:64300 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758054Ab1D0Ko4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:44:56 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 3/4] hrtimer: add nanosleep cancellation
Date: Wed, 27 Apr 2011 13:43:42 +0300
Message-Id: <1303901023-11568-3-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303901023-11568-1-git-send-email-virtuoso@slind.org>
References: <alpine.LFD.2.00.1103102040190.2787@localhost6.localdomain6>
 <1303901023-11568-1-git-send-email-virtuoso@slind.org>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements conditional cancellation for clock_nanosleep
system call. Users who want to be notified of the time changes while
they are sleeping should use TIMER_CANCEL_ON_CLOCK_SET flag and
provide the wall_to_monotonic value they have obtained earlier with
clock_rtoffset call, in rmtp argument. This is only supported for
TIMER_ABSTIME sleepers.

If the provided monotonic offset is still effective, the caller will
sleep until either the requested time comes or somebody changes the
system time, in which case the system call will return ECANCELED. If
the offset has changed by the time of calling clock_nanosleep(), it
will return ECANCELLED straight away.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: John Stultz <johnstul@us.ibm.com>
CC: Chris Friesen <chris.friesen@genband.com>
CC: Kay Sievers <kay.sievers@vrfy.org>
CC: Kirill A. Shutemov <kirill@shutemov.name>
CC: linux-kernel@vger.kernel.org
---
 include/linux/hrtimer.h |    1 +
 include/linux/time.h    |    1 +
 kernel/compat.c         |    2 +-
 kernel/hrtimer.c        |   38 ++++++++++++++++++++++++++++++++++++--
 kernel/posix-timers.c   |    1 +
 5 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index a34b8c6..bf0b8d3 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -444,6 +444,7 @@ static inline u64 hrtimer_forward_now(struct hrtimer *timer,
 extern long hrtimer_nanosleep(struct timespec *rqtp,
 			      struct timespec __user *rmtp,
 			      const enum hrtimer_mode mode,
+			      int cancel_on_clock_set,
 			      const clockid_t clockid);
 extern long hrtimer_nanosleep_restart(struct restart_block *restart_block);
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 8994853..33ff9f3 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -310,5 +310,6 @@ struct itimerval {
  * The various flags for setting POSIX.1b interval timers:
  */
 #define TIMER_ABSTIME			0x01
+#define TIMER_CANCEL_ON_CLOCK_SET	0x02
 
 #endif
diff --git a/kernel/compat.c b/kernel/compat.c
index 38b1d2c..863b3e1 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -199,7 +199,7 @@ asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
 	set_fs(KERNEL_DS);
 	ret = hrtimer_nanosleep(&tu,
 				rmtp ? (struct timespec __user *)&rmt : NULL,
-				HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+				HRTIMER_MODE_REL, 0, CLOCK_MONOTONIC);
 	set_fs(oldfs);
 
 	if (ret) {
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 1463164..0a495c9 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1537,6 +1537,11 @@ static enum hrtimer_restart hrtimer_wakeup(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
+static void nanosleeper_cancel(struct hrtimer *timer)
+{
+	hrtimer_wakeup(timer);
+}
+
 void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, struct task_struct *task)
 {
 	sl->timer.function = hrtimer_wakeup;
@@ -1583,6 +1588,20 @@ static int update_rmtp(struct hrtimer *timer, struct timespec __user *rmtp)
 	return 1;
 }
 
+static int nanosleep_set_cancel_on_clock_set(struct hrtimer_sleeper *t,
+			   struct timespec __user *rmtp)
+{
+	struct timespec offset;
+
+	if (!rmtp)
+		return -EINVAL;
+	if (copy_from_user(&offset, rmtp, sizeof(offset)))
+		return -EFAULT;
+
+	return hrtimer_set_cancel_on_clock_set(&t->timer, &offset,
+					       nanosleeper_cancel);
+}
+
 long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 {
 	struct hrtimer_sleeper t;
@@ -1611,19 +1630,30 @@ out:
 }
 
 long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
-		       const enum hrtimer_mode mode, const clockid_t clockid)
+		       const enum hrtimer_mode mode, int cancel_on_clock_set,
+		       const clockid_t clockid)
 {
 	struct restart_block *restart;
 	struct hrtimer_sleeper t;
 	int ret = 0;
 	unsigned long slack;
 
+	if (cancel_on_clock_set && mode != HRTIMER_MODE_ABS)
+		return -EINVAL;
+
 	slack = current->timer_slack_ns;
 	if (rt_task(current))
 		slack = 0;
 
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
 	hrtimer_set_expires_range_ns(&t.timer, timespec_to_ktime(*rqtp), slack);
+
+	if (cancel_on_clock_set) {
+		ret = nanosleep_set_cancel_on_clock_set(&t, rmtp);
+		if (ret)
+			goto out;
+	}
+
 	if (do_nanosleep(&t, mode))
 		goto out;
 
@@ -1647,6 +1677,9 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 
 	ret = -ERESTART_RESTARTBLOCK;
 out:
+	if (t.timer.cancel.cancelled)
+		ret = -ECANCELED;
+
 	destroy_hrtimer_on_stack(&t.timer);
 	return ret;
 }
@@ -1662,7 +1695,8 @@ SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
 	if (!timespec_valid(&tu))
 		return -EINVAL;
 
-	return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+	return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, 0,
+				 CLOCK_MONOTONIC);
 }
 
 /*
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 2512708..4791c04 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -1040,6 +1040,7 @@ static int common_nsleep(const clockid_t which_clock, int flags,
 {
 	return hrtimer_nanosleep(tsave, rmtp, flags & TIMER_ABSTIME ?
 				 HRTIMER_MODE_ABS : HRTIMER_MODE_REL,
+				 !!(flags & TIMER_CANCEL_ON_CLOCK_SET),
 				 which_clock);
 }
 
-- 
1.7.4.1

