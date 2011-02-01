Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab1BANzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:55:10 -0500
Received: from www.tglx.de ([62.245.132.106]:47290 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757159Ab1BANwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:12 -0500
Message-Id: <20110201134418.808714587@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:51:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 14/28] posix-timers: Remove useless res field from k_clock
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=posix-timers-remove-unused-res-field.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The res member of kclock is only used by mmtimer.c, but even there it
contains redundant information. Remove the field and fixup mmtimer.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 drivers/char/mmtimer.c       |    5 ++---
 include/linux/posix-timers.h |    1 -
 kernel/posix-timers.c        |    2 --
 3 files changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/drivers/char/mmtimer.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/mmtimer.c
+++ linux-2.6-tip/drivers/char/mmtimer.c
@@ -768,12 +768,11 @@ static int sgi_timer_set(struct k_itimer
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
Index: linux-2.6-tip/include/linux/posix-timers.h
===================================================================
--- linux-2.6-tip.orig/include/linux/posix-timers.h
+++ linux-2.6-tip/include/linux/posix-timers.h
@@ -67,7 +67,6 @@ struct k_itimer {
 };
 
 struct k_clock {
-	int res;		/* in nanoseconds */
 	int (*clock_getres) (const clockid_t which_clock, struct timespec *tp);
 	int (*clock_set) (const clockid_t which_clock,
 			  const struct timespec *tp);
Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -204,8 +204,6 @@ static inline int invalid_clockid(const 
 		return 1;
 	if (posix_clocks[which_clock].clock_getres != NULL)
 		return 0;
-	if (posix_clocks[which_clock].res != 0)
-		return 0;
 	return 1;
 }
 


