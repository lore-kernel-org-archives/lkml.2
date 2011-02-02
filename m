Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1BBWCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:02:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:50042 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab1BBWC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:02:27 -0500
Date: Wed, 2 Feb 2011 22:02:10 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134419.198999420@linutronix.de>
References: <20110201134419.198999420@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Convert timer_delete() to clockid_to_kclock()
Message-ID: <tip-6761c6702e2c647582e1829abe8cf90794f61d9d@git.kernel.org>
Git-Commit-ID: 6761c6702e2c647582e1829abe8cf90794f61d9d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 22:02:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6761c6702e2c647582e1829abe8cf90794f61d9d
Gitweb:     http://git.kernel.org/tip/6761c6702e2c647582e1829abe8cf90794f61d9d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:52:07 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:17 +0100

posix-timers: Convert timer_delete() to clockid_to_kclock()

Set the common function for CLOCK_MONOTONIC and CLOCK_REALTIME kclocks
and use the new decoding function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134419.198999420@linutronix.de>
---
 kernel/posix-timers.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index c1e2636..ade7dec 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -254,6 +254,7 @@ static __init int init_posix_timers(void)
 		.timer_create	= common_timer_create,
 		.timer_set	= common_timer_set,
 		.timer_get	= common_timer_get,
+		.timer_del	= common_timer_del,
 	};
 	struct k_clock clock_monotonic = {
 		.clock_getres	= hrtimer_get_res,
@@ -263,6 +264,7 @@ static __init int init_posix_timers(void)
 		.timer_create	= common_timer_create,
 		.timer_set	= common_timer_set,
 		.timer_get	= common_timer_get,
+		.timer_del	= common_timer_del,
 	};
 	struct k_clock clock_monotonic_raw = {
 		.clock_getres	= hrtimer_get_res,
@@ -859,7 +861,7 @@ retry:
 	return error;
 }
 
-static inline int common_timer_del(struct k_itimer *timer)
+static int common_timer_del(struct k_itimer *timer)
 {
 	timer->it.real.interval.tv64 = 0;
 
@@ -870,7 +872,11 @@ static inline int common_timer_del(struct k_itimer *timer)
 
 static inline int timer_delete_hook(struct k_itimer *timer)
 {
-	return CLOCK_DISPATCH(timer->it_clock, timer_del, (timer));
+	struct k_clock *kc = clockid_to_kclock(timer->it_clock);
+
+	if (WARN_ON_ONCE(!kc || !kc->timer_del))
+		return -EINVAL;
+	return kc->timer_del(timer);
 }
 
 /* Delete a POSIX.1b interval timer. */
