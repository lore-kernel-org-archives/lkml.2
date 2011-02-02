Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1BBV5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:57:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:50478 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab1BBV5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:57:40 -0500
Date: Wed, 2 Feb 2011 21:57:26 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134418.131263211@linutronix.de>
References: <20110201134418.131263211@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Convert clock_nanosleep_restart to clockid_to_kclock()
Message-ID: <tip-59bd5bc24aa69f6c62da1e242c16f09f667def96@git.kernel.org>
Git-Commit-ID: 59bd5bc24aa69f6c62da1e242c16f09f667def96
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 21:57:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59bd5bc24aa69f6c62da1e242c16f09f667def96
Gitweb:     http://git.kernel.org/tip/59bd5bc24aa69f6c62da1e242c16f09f667def96
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:51:17 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:13 +0100

posix-timers: Convert clock_nanosleep_restart to clockid_to_kclock()

Use the new kclock decoding function in clock_nanosleep_restart.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134418.131263211@linutronix.de>
---
 kernel/posix-timers.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index ee69b21..4dd86d1 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -277,12 +277,14 @@ static __init int init_posix_timers(void)
 	struct k_clock clock_realtime = {
 		.clock_getres	= hrtimer_get_res,
 		.nsleep		= common_nsleep,
+		.nsleep_restart	= hrtimer_nanosleep_restart,
 	};
 	struct k_clock clock_monotonic = {
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_ktime_get_ts,
 		.clock_set	= do_posix_clock_nosettime,
 		.nsleep		= common_nsleep,
+		.nsleep_restart	= hrtimer_nanosleep_restart,
 	};
 	struct k_clock clock_monotonic_raw = {
 		.clock_getres	= hrtimer_get_res,
@@ -1027,22 +1029,16 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 }
 
 /*
- * nanosleep_restart for monotonic and realtime clocks
- */
-static int common_nsleep_restart(struct restart_block *restart_block)
-{
-	return hrtimer_nanosleep_restart(restart_block);
-}
-
-/*
  * This will restart clock_nanosleep. This is required only by
  * compat_clock_nanosleep_restart for now.
  */
-long
-clock_nanosleep_restart(struct restart_block *restart_block)
+long clock_nanosleep_restart(struct restart_block *restart_block)
 {
 	clockid_t which_clock = restart_block->arg0;
+	struct k_clock *kc = clockid_to_kclock(which_clock);
+
+	if (WARN_ON_ONCE(!kc || !kc->nsleep_restart))
+		return -EINVAL;
 
-	return CLOCK_DISPATCH(which_clock, nsleep_restart,
-			      (restart_block));
+	return kc->nsleep_restart(restart_block);
 }
