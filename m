Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0L0XlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 18:41:05 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38780 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab0L0XlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 18:41:01 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Richard Cochran <richardcochran@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richard.cochran@omicron.at>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 2/3] ntp: add ADJ_SETOFFSET mode bit
Date: Mon, 27 Dec 2010 15:40:43 -0800
Message-Id: <1293493244-17583-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
References: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>

This patch adds a new mode bit into the timex structure. When set, the bit
instructs the kernel to add the given time value to the current time.

CC: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timex.h |    3 ++-
 kernel/time/ntp.c     |   26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index 32d852f..82d4b24 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -73,7 +73,7 @@ struct timex {
 	long tolerance;		/* clock frequency tolerance (ppm)
 				 * (read only)
 				 */
-	struct timeval time;	/* (read only) */
+	struct timeval time;	/* (read only, except for ADJ_SETOFFSET) */
 	long tick;		/* (modified) usecs between clock ticks */
 
 	long ppsfreq;           /* pps frequency (scaled ppm) (ro) */
@@ -101,6 +101,7 @@ struct timex {
 #define ADJ_ESTERROR		0x0008	/* estimated time error */
 #define ADJ_STATUS		0x0010	/* clock status */
 #define ADJ_TIMECONST		0x0020	/* pll time constant */
+#define ADJ_SETOFFSET		0x0040  /* add 'time' to current time */
 #define ADJ_TAI			0x0080	/* set TAI offset */
 #define ADJ_MICRO		0x1000	/* select microsecond resolution */
 #define ADJ_NANO		0x2000	/* select nanosecond resolution */
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index d232189..e9e3915 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -454,6 +454,7 @@ static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts
 int do_adjtimex(struct timex *txc)
 {
 	struct timespec ts;
+	ktime_t delta, kt;
 	int result;
 
 	/* Validate the data before disabling interrupts */
@@ -482,8 +483,33 @@ int do_adjtimex(struct timex *txc)
 			hrtimer_cancel(&leap_timer);
 	}
 
+	if (txc->modes & ADJ_SETOFFSET) {
+		/* Validate the delta value. */
+		if (txc->time.tv_sec && txc->time.tv_usec < 0)
+			return -EINVAL;
+
+		if (txc->modes & ADJ_NANO) {
+			struct timespec tmp;
+			tmp.tv_sec  = txc->time.tv_sec;
+			tmp.tv_nsec = txc->time.tv_usec;
+			delta = timespec_to_ktime(tmp);
+		} else
+			delta = timeval_to_ktime(txc->time);
+
+		/* Adding the delta should be an "atomic" operation. */
+		local_irq_disable();
+	}
+
 	getnstimeofday(&ts);
 
+	if (txc->modes & ADJ_SETOFFSET) {
+		kt = timespec_to_ktime(ts);
+		kt = ktime_add(kt, delta);
+		ts = ktime_to_timespec(kt);
+		do_settimeofday(&ts);
+		local_irq_enable();
+	}
+
 	write_seqlock_irq(&xtime_lock);
 
 	if (txc->modes & ADJ_ADJTIME) {
-- 
1.7.3.2.146.gca209

