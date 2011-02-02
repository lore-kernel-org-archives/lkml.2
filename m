Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab1BBWAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:00:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:50607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab1BBWAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:00:33 -0500
Date: Wed, 2 Feb 2011 22:00:16 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134418.709802797@linutronix.de>
References: <20110201134418.709802797@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Convert clock_getres() to clockid_to_kclock()
Message-ID: <tip-e5e542eea9075dd008993c2ee80b2cc9f31fc494@git.kernel.org>
Git-Commit-ID: e5e542eea9075dd008993c2ee80b2cc9f31fc494
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 22:00:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5e542eea9075dd008993c2ee80b2cc9f31fc494
Gitweb:     http://git.kernel.org/tip/e5e542eea9075dd008993c2ee80b2cc9f31fc494
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:51:53 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:15 +0100

posix-timers: Convert clock_getres() to clockid_to_kclock()

Use the new kclock decoding. Fixup the fallout in mmtimer.c

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134418.709802797@linutronix.de>
---
 drivers/char/mmtimer.c |   10 ++++++++++
 kernel/posix-timers.c  |   17 ++++-------------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index 262d104..141ffae 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -53,6 +53,8 @@ MODULE_LICENSE("GPL");
 
 #define RTC_BITS 55 /* 55 bits for this implementation */
 
+static struct k_clock sgi_clock;
+
 extern unsigned long sn_rtc_cycles_per_second;
 
 #define RTC_COUNTER_ADDR        ((long *)LOCAL_MMR_ADDR(SH_RTC))
@@ -763,10 +765,18 @@ static int sgi_timer_set(struct k_itimer *timr, int flags,
 	return err;
 }
 
+static int sgi_clock_getres(const clockid_t which_clock, struct timespec *tp)
+{
+	tp->tv_sec = 0;
+	tp->tv_nsec = sgi_clock.res;
+	return 0;
+}
+
 static struct k_clock sgi_clock = {
 	.res = 0,
 	.clock_set	= sgi_clock_set,
 	.clock_get	= sgi_clock_get,
+	.clock_getres	= sgi_clock_getres,
 	.timer_create	= sgi_timer_create,
 	.timer_set	= sgi_timer_set,
 	.timer_del	= sgi_timer_del,
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 7f66143..748497f 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -182,14 +182,6 @@ static inline void unlock_timer(struct k_itimer *timr, unsigned long flags)
  * the function pointer CALL in struct k_clock.
  */
 
-static inline int common_clock_getres(const clockid_t which_clock,
-				      struct timespec *tp)
-{
-	tp->tv_sec = 0;
-	tp->tv_nsec = posix_clocks[which_clock].res;
-	return 0;
-}
-
 static int common_timer_create(struct k_itimer *new_timer)
 {
 	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
@@ -984,18 +976,17 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
 		struct timespec __user *, tp)
 {
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec rtn_tp;
 	int error;
 
-	if (invalid_clockid(which_clock))
+	if (!kc)
 		return -EINVAL;
 
-	error = CLOCK_DISPATCH(which_clock, clock_getres,
-			       (which_clock, &rtn_tp));
+	error = kc->clock_getres(which_clock, &rtn_tp);
 
-	if (!error && tp && copy_to_user(tp, &rtn_tp, sizeof (rtn_tp))) {
+	if (!error && tp && copy_to_user(tp, &rtn_tp, sizeof (rtn_tp)))
 		error = -EFAULT;
-	}
 
 	return error;
 }
