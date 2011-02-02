Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1BBV5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:57:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:50476 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab1BBV5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:57:39 -0500
Date: Wed, 2 Feb 2011 21:57:01 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134418.034175556@linutronix.de>
References: <20110201134418.034175556@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Convert clock_nanosleep to clockid_to_kclock()
Message-ID: <tip-a5cd2880106cb2c79b3fe24f1c53dadba6a542a0@git.kernel.org>
Git-Commit-ID: a5cd2880106cb2c79b3fe24f1c53dadba6a542a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 21:57:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5cd2880106cb2c79b3fe24f1c53dadba6a542a0
Gitweb:     http://git.kernel.org/tip/a5cd2880106cb2c79b3fe24f1c53dadba6a542a0
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:51:11 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:13 +0100

posix-timers: Convert clock_nanosleep to clockid_to_kclock()

Use the new kclock decoding function in clock_nanosleep and cleanup all
kclocks which use the default functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134418.034175556@linutronix.de>
---
 drivers/char/mmtimer.c       |    1 -
 include/linux/posix-timers.h |    2 --
 kernel/posix-timers.c        |   26 +++++++-------------------
 3 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index fd51cd8..262d104 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -768,7 +768,6 @@ static struct k_clock sgi_clock = {
 	.clock_set	= sgi_clock_set,
 	.clock_get	= sgi_clock_get,
 	.timer_create	= sgi_timer_create,
-	.nsleep		= do_posix_clock_nonanosleep,
 	.timer_set	= sgi_timer_set,
 	.timer_del	= sgi_timer_del,
 	.timer_get	= sgi_timer_get
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 1330ff3..cd6da06 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -90,8 +90,6 @@ extern struct k_clock clock_posix_cpu;
 void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
 
 /* error handlers for timer_create, nanosleep and settime */
-int do_posix_clock_nonanosleep(const clockid_t, int flags, struct timespec *,
-			       struct timespec __user *);
 int do_posix_clock_nosettime(const clockid_t, const struct timespec *tp);
 
 /* function to call to trigger timer event */
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 14b0a70..ee69b21 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -216,12 +216,6 @@ static int no_timer_create(struct k_itimer *new_timer)
 	return -EOPNOTSUPP;
 }
 
-static int no_nsleep(const clockid_t which_clock, int flags,
-		     struct timespec *tsave, struct timespec __user *rmtp)
-{
-	return -EOPNOTSUPP;
-}
-
 /*
  * Return nonzero if we know a priori this clockid_t value is bogus.
  */
@@ -282,32 +276,31 @@ static __init int init_posix_timers(void)
 {
 	struct k_clock clock_realtime = {
 		.clock_getres	= hrtimer_get_res,
+		.nsleep		= common_nsleep,
 	};
 	struct k_clock clock_monotonic = {
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_ktime_get_ts,
 		.clock_set	= do_posix_clock_nosettime,
+		.nsleep		= common_nsleep,
 	};
 	struct k_clock clock_monotonic_raw = {
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_get_monotonic_raw,
 		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= no_timer_create,
-		.nsleep		= no_nsleep,
 	};
 	struct k_clock clock_realtime_coarse = {
 		.clock_getres	= posix_get_coarse_res,
 		.clock_get	= posix_get_realtime_coarse,
 		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= no_timer_create,
-		.nsleep		= no_nsleep,
 	};
 	struct k_clock clock_monotonic_coarse = {
 		.clock_getres	= posix_get_coarse_res,
 		.clock_get	= posix_get_monotonic_coarse,
 		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= no_timer_create,
-		.nsleep		= no_nsleep,
 	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
@@ -952,13 +945,6 @@ int do_posix_clock_nosettime(const clockid_t clockid, const struct timespec *tp)
 }
 EXPORT_SYMBOL_GPL(do_posix_clock_nosettime);
 
-int do_posix_clock_nonanosleep(const clockid_t clock, int flags,
-			       struct timespec *t, struct timespec __user *r)
-{
-	return -ENANOSLEEP_NOTSUP;
-}
-EXPORT_SYMBOL_GPL(do_posix_clock_nonanosleep);
-
 SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
 		const struct timespec __user *, tp)
 {
@@ -1023,10 +1009,13 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 		const struct timespec __user *, rqtp,
 		struct timespec __user *, rmtp)
 {
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec t;
 
-	if (invalid_clockid(which_clock))
+	if (!kc)
 		return -EINVAL;
+	if (!kc->nsleep)
+		return -ENANOSLEEP_NOTSUP;
 
 	if (copy_from_user(&t, rqtp, sizeof (struct timespec)))
 		return -EFAULT;
@@ -1034,8 +1023,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 	if (!timespec_valid(&t))
 		return -EINVAL;
 
-	return CLOCK_DISPATCH(which_clock, nsleep,
-			      (which_clock, flags, &t, rmtp));
+	return kc->nsleep(which_clock, flags, &t, rmtp);
 }
 
 /*
