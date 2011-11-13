Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab1KMXTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 18:19:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:45133 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab1KMXTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 18:19:49 -0500
Message-Id: <20111113231341.531749654@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 13 Nov 2011 23:19:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [patch 2/7] ntp: Shorten xtime seqcount sections
References: <20111113230921.728083714@linutronix.de>
Content-Disposition: inline; filename=xtime-ntp-shorten-seqcount-sections.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only need to bump the seqcount for the actual leap seconds
injection.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/ntp.c         |    8 --------
 kernel/time/timekeeping.c |    2 ++
 2 files changed, 2 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c
+++ linux-2.6/kernel/time/ntp.c
@@ -359,7 +359,6 @@ static enum hrtimer_restart ntp_leap_sec
 	enum hrtimer_restart res = HRTIMER_NORESTART;
 
 	raw_spin_lock(&xtime_lock);
-	write_seqcount_begin(&xtime_seq);
 
 	switch (time_state) {
 	case TIME_OK:
@@ -389,7 +388,6 @@ static enum hrtimer_restart ntp_leap_sec
 		break;
 	}
 
-	write_seqcount_end(&xtime_seq);
 	raw_spin_unlock(&xtime_lock);
 
 	return res;
@@ -666,7 +664,6 @@ int do_adjtimex(struct timex *txc)
 	getnstimeofday(&ts);
 
 	raw_spin_lock_irq(&xtime_lock);
-	write_seqcount_begin(&xtime_seq);
 
 	if (txc->modes & ADJ_ADJTIME) {
 		long save_adjust = time_adjust;
@@ -708,7 +705,6 @@ int do_adjtimex(struct timex *txc)
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
-	write_seqcount_end(&xtime_seq);
 	raw_spin_unlock_irq(&xtime_lock);
 
 	txc->time.tv_sec = ts.tv_sec;
@@ -908,7 +904,6 @@ void hardpps(const struct timespec *phas
 	pts_norm = pps_normalize_ts(*phase_ts);
 
 	raw_spin_lock_irqsave(&xtime_lock, flags);
-	write_seqcount_begin(&xtime_seq);
 
 	/* clear the error bits, they will be set again if needed */
 	time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
@@ -921,7 +916,6 @@ void hardpps(const struct timespec *phas
 	 * just start the frequency interval */
 	if (unlikely(pps_fbase.tv_sec == 0)) {
 		pps_fbase = *raw_ts;
-		write_seqcount_end(&xtime_seq);
 		raw_spin_unlock_irqrestore(&xtime_lock, flags);
 		return;
 	}
@@ -937,7 +931,6 @@ void hardpps(const struct timespec *phas
 		time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
 		pps_fbase = *raw_ts;
-		write_seqcount_end(&xtime_seq);
 		raw_spin_unlock_irqrestore(&xtime_lock, flags);
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
 		return;
@@ -955,7 +948,6 @@ void hardpps(const struct timespec *phas
 
 	hardpps_update_phase(pts_norm.nsec);
 
-	write_seqcount_end(&xtime_seq);
 	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 }
 EXPORT_SYMBOL(hardpps);
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -173,10 +173,12 @@ int __read_mostly timekeeping_suspended;
 /* must hold xtime_lock */
 void timekeeping_leap_insert(int leapsecond)
 {
+	write_seqcount_begin(&xtime_seq);
 	xtime.tv_sec += leapsecond;
 	wall_to_monotonic.tv_sec -= leapsecond;
 	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
 			timekeeper.mult);
+	write_seqcount_end(&xtime_seq);
 }
 
 /**


