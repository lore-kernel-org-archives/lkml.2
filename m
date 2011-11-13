Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1KMXUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 18:20:43 -0500
Received: from www.linutronix.de ([62.245.132.108]:45147 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab1KMXTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 18:19:50 -0500
Message-Id: <20111113231341.739343874@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 13 Nov 2011 23:19:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [patch 5/7] timekeeping: Move common updates to a function
References: <20111113230921.728083714@linutronix.de>
Content-Disposition: inline; filename=timekeeping-collapse-copied-code.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

Index: linux-2.6-tip/kernel/time/timekeeping.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/timekeeping.c
+++ linux-2.6-tip/kernel/time/timekeeping.c
@@ -170,14 +170,23 @@ static struct timespec raw_time;
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
+static void timekeeping_update(bool clearntp)
+{
+	if (clearntp) {
+		timekeeper.ntp_error = 0;
+		ntp_clear();
+	}
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+			timekeeper.mult);
+}
+
 /* must hold xtime_lock */
 void timekeeping_leap_insert(int leapsecond)
 {
 	write_seqcount_begin(&xtime_seq);
 	xtime.tv_sec += leapsecond;
 	wall_to_monotonic.tv_sec -= leapsecond;
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-			timekeeper.mult);
+	timekeeping_update(false);
 	write_seqcount_end(&xtime_seq);
 }
 
@@ -375,12 +384,7 @@ int do_settimeofday(const struct timespe
 
 	xtime = *tv;
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
-
+	timekeeping_update(true);
 	write_seqcount_end(&xtime_seq);
 	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 
@@ -414,12 +418,7 @@ int timekeeping_inject_offset(struct tim
 	xtime = timespec_add(xtime, *ts);
 	wall_to_monotonic = timespec_sub(wall_to_monotonic, *ts);
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
-
+	timekeeping_update(true);
 	write_seqcount_end(&xtime_seq);
 	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 
@@ -651,11 +650,7 @@ void timekeeping_inject_sleeptime(struct
 
 	__timekeeping_inject_sleeptime(delta);
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
-
+	timekeeping_update(true);
 	write_seqcount_end(&xtime_seq);
 	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 


