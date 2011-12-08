Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab1LHUn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 15:43:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:43274 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab1LHUn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 15:43:27 -0500
Date: Thu, 8 Dec 2011 21:43:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer fixes for 3.2
Message-ID: <alpine.LFD.2.02.1112082140520.3020@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

Thanks,

	tglx

------------------>
Thomas Gleixner (2):
      ptp: Fix clock_getres() implementation
      alarmtimers: Fix time comparison


 drivers/ptp/ptp_clock.c  |    4 +++-
 kernel/time/alarmtimer.c |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index cf3f999..10451a1 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -101,7 +101,9 @@ static s32 scaled_ppm_to_ppb(long ppm)
 
 static int ptp_clock_getres(struct posix_clock *pc, struct timespec *tp)
 {
-	return 1; /* always round timer functions to one nanosecond */
+	tp->tv_sec = 0;
+	tp->tv_nsec = 1;
+	return 0;
 }
 
 static int ptp_clock_settime(struct posix_clock *pc, const struct timespec *tp)
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index c436e79..8a46f5d 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -195,7 +195,7 @@ static enum hrtimer_restart alarmtimer_fired(struct hrtimer *timer)
 		struct alarm *alarm;
 		ktime_t expired = next->expires;
 
-		if (expired.tv64 >= now.tv64)
+		if (expired.tv64 > now.tv64)
 			break;
 
 		alarm = container_of(next, struct alarm, node);
