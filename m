Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1BBWFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:05:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:50154 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab1BBWFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:05:16 -0500
Date: Wed, 2 Feb 2011 22:04:56 GMT
From: tip-bot for Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, richardcochran@gmail.com, tglx@linutronix.de,
        richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, richardcochran@gmail.com, tglx@linutronix.de,
        richard.cochran@omicron.at
In-Reply-To: <20110201134419.869804645@linutronix.de>
References: <20110201134419.869804645@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Introduce a syscall for clock tuning.
Message-ID: <tip-f1f1d5ebd10ffa4242bce7a90a56a222d6b7bc77@git.kernel.org>
Git-Commit-ID: f1f1d5ebd10ffa4242bce7a90a56a222d6b7bc77
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 22:04:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1f1d5ebd10ffa4242bce7a90a56a222d6b7bc77
Gitweb:     http://git.kernel.org/tip/f1f1d5ebd10ffa4242bce7a90a56a222d6b7bc77
Author:     Richard Cochran <richardcochran@gmail.com>
AuthorDate: Tue, 1 Feb 2011 13:52:26 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:19 +0100

posix-timers: Introduce a syscall for clock tuning.

A new syscall is introduced that allows tuning of a POSIX clock. The
new call, clock_adjtime, takes two parameters, the clock ID and a
pointer to a struct timex. Any ADJTIMEX(2) operation may be requested
via this system call, but various POSIX clocks may or may not support
tuning.

[ tglx: Adapted to the posix-timer cleanup series. Avoid copy_to_user
  	in the error case ]

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Acked-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20110201134419.869804645@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/posix-timers.h |    2 ++
 include/linux/syscalls.h     |    2 ++
 kernel/compat.c              |   23 +++++++++++++++++++++++
 kernel/posix-timers.c        |   30 ++++++++++++++++++++++++++++++
 4 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 8206255..79a1cea 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -4,6 +4,7 @@
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/sched.h>
+#include <linux/timex.h>
 
 union cpu_time_count {
 	cputime_t cpu;
@@ -71,6 +72,7 @@ struct k_clock {
 	int (*clock_set) (const clockid_t which_clock,
 			  const struct timespec *tp);
 	int (*clock_get) (const clockid_t which_clock, struct timespec * tp);
+	int (*clock_adj) (const clockid_t which_clock, struct timex *tx);
 	int (*timer_create) (struct k_itimer *timer);
 	int (*nsleep) (const clockid_t which_clock, int flags,
 		       struct timespec *, struct timespec __user *);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 18cd068..bfacab9 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -311,6 +311,8 @@ asmlinkage long sys_clock_settime(clockid_t which_clock,
 				const struct timespec __user *tp);
 asmlinkage long sys_clock_gettime(clockid_t which_clock,
 				struct timespec __user *tp);
+asmlinkage long sys_clock_adjtime(clockid_t which_clock,
+				struct timex __user *tx);
 asmlinkage long sys_clock_getres(clockid_t which_clock,
 				struct timespec __user *tp);
 asmlinkage long sys_clock_nanosleep(clockid_t which_clock, int flags,
diff --git a/kernel/compat.c b/kernel/compat.c
index 449e853..38b1d2c 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -675,6 +675,29 @@ long compat_sys_clock_gettime(clockid_t which_clock,
 	return err;
 }
 
+long compat_sys_clock_adjtime(clockid_t which_clock,
+		struct compat_timex __user *utp)
+{
+	struct timex txc;
+	mm_segment_t oldfs;
+	int err, ret;
+
+	err = compat_get_timex(&txc, utp);
+	if (err)
+		return err;
+
+	oldfs = get_fs();
+	set_fs(KERNEL_DS);
+	ret = sys_clock_adjtime(which_clock, (struct timex __user *) &txc);
+	set_fs(oldfs);
+
+	err = compat_put_timex(utp, &txc);
+	if (err)
+		return err;
+
+	return ret;
+}
+
 long compat_sys_clock_getres(clockid_t which_clock,
 		struct compat_timespec __user *tp)
 {
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index a3fdfd4..5a5a4f1 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -170,6 +170,12 @@ static int posix_clock_realtime_set(const clockid_t which_clock,
 	return do_sys_settimeofday(tp, NULL);
 }
 
+static int posix_clock_realtime_adj(const clockid_t which_clock,
+				    struct timex *t)
+{
+	return do_adjtimex(t);
+}
+
 /*
  * Get monotonic time for posix timers
  */
@@ -216,6 +222,7 @@ static __init int init_posix_timers(void)
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_clock_realtime_get,
 		.clock_set	= posix_clock_realtime_set,
+		.clock_adj	= posix_clock_realtime_adj,
 		.nsleep		= common_nsleep,
 		.nsleep_restart	= hrtimer_nanosleep_restart,
 		.timer_create	= common_timer_create,
@@ -948,6 +955,29 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 	return error;
 }
 
+SYSCALL_DEFINE2(clock_adjtime, const clockid_t, which_clock,
+		struct timex __user *, utx)
+{
+	struct k_clock *kc = clockid_to_kclock(which_clock);
+	struct timex ktx;
+	int err;
+
+	if (!kc)
+		return -EINVAL;
+	if (!kc->clock_adj)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&ktx, utx, sizeof(ktx)))
+		return -EFAULT;
+
+	err = kc->clock_adj(which_clock, &ktx);
+
+	if (!err && copy_to_user(utx, &ktx, sizeof(ktx)))
+		return -EFAULT;
+
+	return err;
+}
+
 SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
 		struct timespec __user *, tp)
 {
