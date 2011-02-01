Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab1BANw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:52:57 -0500
Received: from www.tglx.de ([62.245.132.106]:47421 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936Ab1BANwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:55 -0500
Message-Id: <20110201134419.679485268@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:52:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 23/28] ntp: Add ADJ_SETOFFSET mode bit
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline; filename=ntp-add-adj_setoffset-mode-bit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>

This patch adds a new mode bit into the timex structure. When set, the bit
instructs the kernel to add the given time value to the current time.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Cc: John Stultz <john.stultz@linaro.org>
LKML-Reference: <2f7ed6bce83c23e4b7e4530794f0aa175df31a39.1296124770.git.richard.cochran@omicron.at>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timex.h |    3 ++-
 kernel/time/ntp.c     |   11 +++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/include/linux/timex.h
===================================================================
--- linux-2.6-tip.orig/include/linux/timex.h
+++ linux-2.6-tip/include/linux/timex.h
@@ -73,7 +73,7 @@ struct timex {
 	long tolerance;		/* clock frequency tolerance (ppm)
 				 * (read only)
 				 */
-	struct timeval time;	/* (read only) */
+	struct timeval time;	/* (read only, except for ADJ_SETOFFSET) */
 	long tick;		/* (modified) usecs between clock ticks */
 
 	long ppsfreq;           /* pps frequency (scaled ppm) (ro) */
@@ -102,6 +102,7 @@ struct timex {
 #define ADJ_STATUS		0x0010	/* clock status */
 #define ADJ_TIMECONST		0x0020	/* pll time constant */
 #define ADJ_TAI			0x0080	/* set TAI offset */
+#define ADJ_SETOFFSET		0x0100  /* add 'time' to current time */
 #define ADJ_MICRO		0x1000	/* select microsecond resolution */
 #define ADJ_NANO		0x2000	/* select nanosecond resolution */
 #define ADJ_TICK		0x4000	/* tick value */
Index: linux-2.6-tip/kernel/time/ntp.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/ntp.c
+++ linux-2.6-tip/kernel/time/ntp.c
@@ -648,6 +648,17 @@ int do_adjtimex(struct timex *txc)
 			hrtimer_cancel(&leap_timer);
 	}
 
+	if (txc->modes & ADJ_SETOFFSET) {
+		struct timespec delta;
+		if ((unsigned long)txc->time.tv_usec >= NSEC_PER_SEC)
+			return -EINVAL;
+		delta.tv_sec  = txc->time.tv_sec;
+		delta.tv_nsec = txc->time.tv_usec;
+		if (!(txc->modes & ADJ_NANO))
+			delta.tv_nsec *= 1000;
+		timekeeping_inject_offset(&delta);
+	}
+
 	getnstimeofday(&ts);
 
 	write_seqlock_irq(&xtime_lock);


