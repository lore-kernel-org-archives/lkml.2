Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab1BBWCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:02:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:50039 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab1BBWCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:02:22 -0500
Date: Wed, 2 Feb 2011 22:01:44 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134419.101243181@linutronix.de>
References: <20110201134419.101243181@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Convert timer_gettime() to clockid_to_kclock()
Message-ID: <tip-a7319fa253a549c4c6528fb550ae6e72a9c83811@git.kernel.org>
Git-Commit-ID: a7319fa253a549c4c6528fb550ae6e72a9c83811
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 22:01:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7319fa253a549c4c6528fb550ae6e72a9c83811
Gitweb:     http://git.kernel.org/tip/a7319fa253a549c4c6528fb550ae6e72a9c83811
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:52:04 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:16 +0100

posix-timers: Convert timer_gettime() to clockid_to_kclock()

Set the common function for CLOCK_MONOTONIC and CLOCK_REALTIME kclocks
and use the new decoding function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134419.101243181@linutronix.de>
---
 kernel/posix-timers.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index a4dbfe7..c1e2636 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -253,6 +253,7 @@ static __init int init_posix_timers(void)
 		.nsleep_restart	= hrtimer_nanosleep_restart,
 		.timer_create	= common_timer_create,
 		.timer_set	= common_timer_set,
+		.timer_get	= common_timer_get,
 	};
 	struct k_clock clock_monotonic = {
 		.clock_getres	= hrtimer_get_res,
@@ -261,6 +262,7 @@ static __init int init_posix_timers(void)
 		.nsleep_restart	= hrtimer_nanosleep_restart,
 		.timer_create	= common_timer_create,
 		.timer_set	= common_timer_set,
+		.timer_get	= common_timer_get,
 	};
 	struct k_clock clock_monotonic_raw = {
 		.clock_getres	= hrtimer_get_res,
@@ -712,22 +714,28 @@ common_timer_get(struct k_itimer *timr, struct itimerspec *cur_setting)
 SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
 		struct itimerspec __user *, setting)
 {
-	struct k_itimer *timr;
 	struct itimerspec cur_setting;
+	struct k_itimer *timr;
+	struct k_clock *kc;
 	unsigned long flags;
+	int ret = 0;
 
 	timr = lock_timer(timer_id, &flags);
 	if (!timr)
 		return -EINVAL;
 
-	CLOCK_DISPATCH(timr->it_clock, timer_get, (timr, &cur_setting));
+	kc = clockid_to_kclock(timr->it_clock);
+	if (WARN_ON_ONCE(!kc || !kc->timer_get))
+		ret = -EINVAL;
+	else
+		kc->timer_get(timr, &cur_setting);
 
 	unlock_timer(timr, flags);
 
-	if (copy_to_user(setting, &cur_setting, sizeof (cur_setting)))
+	if (!ret && copy_to_user(setting, &cur_setting, sizeof (cur_setting)))
 		return -EFAULT;
 
-	return 0;
+	return ret;
 }
 
 /*
