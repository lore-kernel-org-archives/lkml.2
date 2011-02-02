Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab1BBWBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:01:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:50659 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab1BBWBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:01:50 -0500
Date: Wed, 2 Feb 2011 22:01:22 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134419.001863714@linutronix.de>
References: <20110201134419.001863714@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Convert timer_settime() to clockid_to_kclock()
Message-ID: <tip-27722df16ef143017db55ac7baac1703a68017ff@git.kernel.org>
Git-Commit-ID: 27722df16ef143017db55ac7baac1703a68017ff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 22:01:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27722df16ef143017db55ac7baac1703a68017ff
Gitweb:     http://git.kernel.org/tip/27722df16ef143017db55ac7baac1703a68017ff
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:52:01 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:16 +0100

posix-timers: Convert timer_settime() to clockid_to_kclock()

Set the common function for CLOCK_MONOTONIC and CLOCK_REALTIME kclocks
and use the new decoding function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134419.001863714@linutronix.de>
---
 kernel/posix-timers.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4f71382..a4dbfe7 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -252,6 +252,7 @@ static __init int init_posix_timers(void)
 		.nsleep		= common_nsleep,
 		.nsleep_restart	= hrtimer_nanosleep_restart,
 		.timer_create	= common_timer_create,
+		.timer_set	= common_timer_set,
 	};
 	struct k_clock clock_monotonic = {
 		.clock_getres	= hrtimer_get_res,
@@ -259,6 +260,7 @@ static __init int init_posix_timers(void)
 		.nsleep		= common_nsleep,
 		.nsleep_restart	= hrtimer_nanosleep_restart,
 		.timer_create	= common_timer_create,
+		.timer_set	= common_timer_set,
 	};
 	struct k_clock clock_monotonic_raw = {
 		.clock_getres	= hrtimer_get_res,
@@ -814,6 +816,7 @@ SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
 	int error = 0;
 	unsigned long flag;
 	struct itimerspec *rtn = old_setting ? &old_spec : NULL;
+	struct k_clock *kc;
 
 	if (!new_setting)
 		return -EINVAL;
@@ -829,8 +832,11 @@ retry:
 	if (!timr)
 		return -EINVAL;
 
-	error = CLOCK_DISPATCH(timr->it_clock, timer_set,
-			       (timr, flags, &new_spec, rtn));
+	kc = clockid_to_kclock(timr->it_clock);
+	if (WARN_ON_ONCE(!kc || !kc->timer_set))
+		error = -EINVAL;
+	else
+		error = kc->timer_set(timr, flags, &new_spec, rtn);
 
 	unlock_timer(timr, flag);
 	if (error == TIMER_RETRY) {
