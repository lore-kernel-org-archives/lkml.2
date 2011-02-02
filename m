Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab1BBV7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:59:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:50570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab1BBV7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:59:49 -0500
Date: Wed, 2 Feb 2011 21:59:33 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134418.611097203@linutronix.de>
References: <20110201134418.611097203@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Convert clock_gettime() to clockid_to_kclock()
Message-ID: <tip-42285777631aa0654fbb6442057b3e176445c6c5@git.kernel.org>
Git-Commit-ID: 42285777631aa0654fbb6442057b3e176445c6c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 21:59:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42285777631aa0654fbb6442057b3e176445c6c5
Gitweb:     http://git.kernel.org/tip/42285777631aa0654fbb6442057b3e176445c6c5
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:51:50 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:14 +0100

posix-timers: Convert clock_gettime() to clockid_to_kclock()

Use the new kclock decoding mechanism and rename the misnomed
common_clock_get() to posix_clock_realtime_get().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134418.611097203@linutronix.de>
---
 kernel/posix-timers.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 49f358c..d9e5edf 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -190,15 +190,6 @@ static inline int common_clock_getres(const clockid_t which_clock,
 	return 0;
 }
 
-/*
- * Get real time for posix timers
- */
-static int common_clock_get(clockid_t which_clock, struct timespec *tp)
-{
-	ktime_get_real_ts(tp);
-	return 0;
-}
-
 static int common_timer_create(struct k_itimer *new_timer)
 {
 	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
@@ -226,6 +217,13 @@ static inline int invalid_clockid(const clockid_t which_clock)
 	return 1;
 }
 
+/* Get clock_realtime */
+static int posix_clock_realtime_get(clockid_t which_clock, struct timespec *tp)
+{
+	ktime_get_real_ts(tp);
+	return 0;
+}
+
 /* Set clock_realtime */
 static int posix_clock_realtime_set(const clockid_t which_clock,
 				    const struct timespec *tp)
@@ -277,6 +275,7 @@ static __init int init_posix_timers(void)
 {
 	struct k_clock clock_realtime = {
 		.clock_getres	= hrtimer_get_res,
+		.clock_get	= posix_clock_realtime_get,
 		.clock_set	= posix_clock_realtime_set,
 		.nsleep		= common_nsleep,
 		.nsleep_restart	= hrtimer_nanosleep_restart,
@@ -956,18 +955,21 @@ SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
 SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 		struct timespec __user *,tp)
 {
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec kernel_tp;
 	int error;
 
-	if (invalid_clockid(which_clock))
+	if (!kc)
 		return -EINVAL;
-	error = CLOCK_DISPATCH(which_clock, clock_get,
-			       (which_clock, &kernel_tp));
+	if (!kc->clock_get)
+		return -EOPNOTSUPP;
+
+	error = kc->clock_get(which_clock, &kernel_tp);
+
 	if (!error && copy_to_user(tp, &kernel_tp, sizeof (kernel_tp)))
 		error = -EFAULT;
 
 	return error;
-
 }
 
 SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
