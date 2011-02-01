Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab1BANxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:53:13 -0500
Received: from www.tglx.de ([62.245.132.106]:47477 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab1BANxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:53:09 -0500
Message-Id: <20110201134419.869804645@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:52:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>, Rodolfo Giometti <giometti@linux.it>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [patch 25/28] posix clocks: Introduce a syscall for clock tuning.
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=posix-clocks-introduce-a-syscall-for-clock-tuning.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>

A new syscall is introduced that allows tuning of a POSIX clock. The
new call, clock_adjtime, takes two parameters, the clock ID and a
pointer to a struct timex. Any ADJTIMEX(2) operation may be requested
via this system call, but various POSIX clocks may or may not support
tuning.

[ tglx: Adapted to the posix-timer cleanup series. Avoid copy_to_user
  	in the error case ]

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Miller <davem@davemloft.net>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodolfo Giometti <giometti@linux.it>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Russell King <linux@arm.linux.org.uk>
LKML-Reference: <2d5e2f3e6f388aa1848d40406646aab2e26a906f.1296124770.git.richard.cochran@omicron.at>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/posix-timers.h |    2 ++
 include/linux/syscalls.h     |    2 ++
 kernel/compat.c              |   23 +++++++++++++++++++++++
 kernel/posix-timers.c        |   30 ++++++++++++++++++++++++++++++
 4 files changed, 57 insertions(+)

Index: linux-2.6-tip/include/linux/posix-timers.h
===================================================================
--- linux-2.6-tip.orig/include/linux/posix-timers.h
+++ linux-2.6-tip/include/linux/posix-timers.h
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
Index: linux-2.6-tip/include/linux/syscalls.h
===================================================================
--- linux-2.6-tip.orig/include/linux/syscalls.h
+++ linux-2.6-tip/include/linux/syscalls.h
@@ -311,6 +311,8 @@ asmlinkage long sys_clock_settime(clocki
 				const struct timespec __user *tp);
 asmlinkage long sys_clock_gettime(clockid_t which_clock,
 				struct timespec __user *tp);
+asmlinkage long sys_clock_adjtime(clockid_t which_clock,
+				struct timex __user *tx);
 asmlinkage long sys_clock_getres(clockid_t which_clock,
 				struct timespec __user *tp);
 asmlinkage long sys_clock_nanosleep(clockid_t which_clock, int flags,
Index: linux-2.6-tip/kernel/compat.c
===================================================================
--- linux-2.6-tip.orig/kernel/compat.c
+++ linux-2.6-tip/kernel/compat.c
@@ -675,6 +675,29 @@ long compat_sys_clock_gettime(clockid_t 
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
Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -170,6 +170,12 @@ static inline int posix_clock_realtime_s
 	return do_sys_settimeofday(tp, NULL);
 }
 
+static inline int posix_clock_realtime_adj(const clockid_t which_clock,
+					   struct timex *t)
+{
+	return do_adjtimex(t);
+}
+
 /*
  * Get monotonic time for posix timers
  */
@@ -216,6 +222,7 @@ static __init int init_posix_timers(void
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_clock_realtime_get,
 		.clock_set	= posix_clock_realtime_set,
+		.clock_adj	= posix_clock_realtime_adj,
 		.nsleep		= common_nsleep,
 		.nsleep_restart	= hrtimer_nanosleep_restart,
 		.timer_create	= common_timer_create,
@@ -930,6 +937,29 @@ SYSCALL_DEFINE2(clock_gettime, const clo
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


