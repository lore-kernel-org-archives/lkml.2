Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0L0XlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 18:41:09 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57197 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab0L0XlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 18:41:06 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] ntp: Change ADJ_SETOFFSET implementation to use timekeeping_inject_offset
Date: Mon, 27 Dec 2010 15:40:44 -0800
Message-Id: <1293493244-17583-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
References: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleans up the ADJ_SETOFFSET implementation to use
timekeeping_inject_offset which greatly simplifies the code.

CC: Richard Cochran <richard.cochran@omicron.at>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/ntp.c |   25 ++++++-------------------
 1 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index e9e3915..18d7a0f 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -454,7 +454,6 @@ static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts
 int do_adjtimex(struct timex *txc)
 {
 	struct timespec ts;
-	ktime_t delta, kt;
 	int result;
 
 	/* Validate the data before disabling interrupts */
@@ -484,32 +483,20 @@ int do_adjtimex(struct timex *txc)
 	}
 
 	if (txc->modes & ADJ_SETOFFSET) {
+		struct timespec delta;
 		/* Validate the delta value. */
 		if (txc->time.tv_sec && txc->time.tv_usec < 0)
 			return -EINVAL;
 
-		if (txc->modes & ADJ_NANO) {
-			struct timespec tmp;
-			tmp.tv_sec  = txc->time.tv_sec;
-			tmp.tv_nsec = txc->time.tv_usec;
-			delta = timespec_to_ktime(tmp);
-		} else
-			delta = timeval_to_ktime(txc->time);
-
-		/* Adding the delta should be an "atomic" operation. */
-		local_irq_disable();
+		delta.tv_sec  = txc->time.tv_sec;
+		delta.tv_nsec = txc->time.tv_usec;
+		if (!(txc->modes & ADJ_NANO))
+			delta.tv_nsec *= 1000;
+		timekeeping_inject_offset(&delta);
 	}
 
 	getnstimeofday(&ts);
 
-	if (txc->modes & ADJ_SETOFFSET) {
-		kt = timespec_to_ktime(ts);
-		kt = ktime_add(kt, delta);
-		ts = ktime_to_timespec(kt);
-		do_settimeofday(&ts);
-		local_irq_enable();
-	}
-
 	write_seqlock_irq(&xtime_lock);
 
 	if (txc->modes & ADJ_ADJTIME) {
-- 
1.7.3.2.146.gca209

