Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab1BBWBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:01:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:50632 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab1BBWBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:01:08 -0500
Date: Wed, 2 Feb 2011 22:00:37 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134418.808714587@linutronix.de>
References: <20110201134418.808714587@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Remove useless res field from k_clock
Message-ID: <tip-ebaac757acae0431e2c79c00e09f1debdabbddd7@git.kernel.org>
Git-Commit-ID: ebaac757acae0431e2c79c00e09f1debdabbddd7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 22:00:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ebaac757acae0431e2c79c00e09f1debdabbddd7
Gitweb:     http://git.kernel.org/tip/ebaac757acae0431e2c79c00e09f1debdabbddd7
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:51:56 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:15 +0100

posix-timers: Remove useless res field from k_clock

The res member of kclock is only used by mmtimer.c, but even there it
contains redundant information. Remove the field and fixup mmtimer.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134418.808714587@linutronix.de>
---
 drivers/char/mmtimer.c       |    5 ++---
 include/linux/posix-timers.h |    1 -
 kernel/posix-timers.c        |    2 --
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index 141ffae..ff41eb3 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -768,12 +768,11 @@ static int sgi_timer_set(struct k_itimer *timr, int flags,
 static int sgi_clock_getres(const clockid_t which_clock, struct timespec *tp)
 {
 	tp->tv_sec = 0;
-	tp->tv_nsec = sgi_clock.res;
+	tp->tv_nsec = sgi_clock_period;
 	return 0;
 }
 
 static struct k_clock sgi_clock = {
-	.res = 0,
 	.clock_set	= sgi_clock_set,
 	.clock_get	= sgi_clock_get,
 	.clock_getres	= sgi_clock_getres,
@@ -840,7 +839,7 @@ static int __init mmtimer_init(void)
 			(unsigned long) node);
 	}
 
-	sgi_clock_period = sgi_clock.res = NSEC_PER_SEC / sn_rtc_cycles_per_second;
+	sgi_clock_period = NSEC_PER_SEC / sn_rtc_cycles_per_second;
 	register_posix_clock(CLOCK_SGI_CYCLE, &sgi_clock);
 
 	printk(KERN_INFO "%s: v%s, %ld MHz\n", MMTIMER_DESC, MMTIMER_VERSION,
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 4aaf0c5..ef574d1 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -67,7 +67,6 @@ struct k_itimer {
 };
 
 struct k_clock {
-	int res;		/* in nanoseconds */
 	int (*clock_getres) (const clockid_t which_clock, struct timespec *tp);
 	int (*clock_set) (const clockid_t which_clock,
 			  const struct timespec *tp);
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 748497f..f9142a9 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -204,8 +204,6 @@ static inline int invalid_clockid(const clockid_t which_clock)
 		return 1;
 	if (posix_clocks[which_clock].clock_getres != NULL)
 		return 0;
-	if (posix_clocks[which_clock].res != 0)
-		return 0;
 	return 1;
 }
 
