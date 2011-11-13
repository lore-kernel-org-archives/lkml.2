Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1KMXT6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 18:19:58 -0500
Received: from www.linutronix.de ([62.245.132.108]:45156 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab1KMXTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 18:19:51 -0500
Message-Id: <20111113231341.883550391@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 13 Nov 2011 23:19:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [patch 7/7] timekeeping: Reduce seqcount section to update
 timekeeper/xtime
References: <20111113230921.728083714@linutronix.de>
Content-Disposition: inline;
 filename=timekeeping-reduce-seqcnt-section-more.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The calculation of the timekeeping values is now decoupled from
timekeeper/xtime which are used by the readers. So we can confine the
seqcount section to the mere update of the reader side data.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/time/timekeeping.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/timekeeping.c
+++ linux-2.6-tip/kernel/time/timekeeping.c
@@ -986,7 +986,10 @@ static void update_wall_time(void)
 		xtime_calc.tv_sec++;
 		second_overflow();
 	}
+}
 
+static void update_timekeeper(void)
+{
 	timekeeper = tk_calc;
 	xtime = xtime_calc;
 
@@ -1126,10 +1129,13 @@ struct timespec get_monotonic_coarse(voi
  */
 void do_timer(unsigned long ticks)
 {
+	update_wall_time();
+
 	write_seqcount_begin(&xtime_seq);
 	jiffies_64 += ticks;
-	update_wall_time();
+	update_timekeeper();
 	write_seqcount_end(&xtime_seq);
+
 	calc_global_load(ticks);
 }
 


