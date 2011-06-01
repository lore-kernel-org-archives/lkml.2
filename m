Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1FAGIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:08:02 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47976 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab1FAGHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:07:55 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=83=C2=B8nnev=C3=83=C2=A5g?= 
	<arve@android.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] time: Avoid accumulating time drift in suspend/resume
Date: Tue, 31 May 2011 23:07:48 -0700
Message-Id: <1306908469-15275-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1306908469-15275-1-git-send-email-john.stultz@linaro.org>
References: <1306908469-15275-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the read_persistent_clock interface is usually backed by
only a second granular interface, each time we read from the persistent
clock for suspend/resume, we introduce a half second (on average) of error.

In order to avoid this error accumulating as the system is suspended
over and over, this patch measures the time delta between the persistent
clock and the system CLOCK_REALTIME.

If the delta is less then 2 seconds from the last suspend, we compensate
by using the previous time delta (keeping it close). If it is larger
then 2 seconds, we assume the clock was set or has been changed, so we
do no correction and update the delta.

Note: If NTP is running, ths could seem to "fight" with the NTP corrected
time, where as if the system time was off by 1 second, and NTP slewed the
value in, a suspend/resume cycle could undo this correction, by trying to
restore the previous offset from the persistent clock.  However, without
this patch, since each read could cause almost a full second worth of
error, its possible to get almost 2 seconds of error just from the
suspend/resume cycle alone, so this about equal to any offset added by
the compensation.

Further on systems that suspend/resume frequently, this should keep time
closer then NTP could compensate for if the errors were allowed to
accumulate.

Credits to Arve HjÃ¸nnevÃ¥g for suggesting this solution.

CC: Arve HjÃ¸nnevÃ¥g <arve@android.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 342408c..7665fea 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -686,12 +686,34 @@ static void timekeeping_resume(void)
 static int timekeeping_suspend(void)
 {
 	unsigned long flags;
+	struct timespec		delta, delta_delta;
+	static struct timespec	old_delta;
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 	timekeeping_forward_now();
 	timekeeping_suspended = 1;
+
+	/*
+	 * To avoid drift caused by repeated suspend/resumes,
+	 * which each can add ~1 second drift error,
+	 * try to compensate so the difference in system time
+	 * and persistent_clock time stays close to constant.
+	 */
+	delta = timespec_sub(xtime, timekeeping_suspend_time);
+	delta_delta = timespec_sub(delta, old_delta);
+	if (abs(delta_delta.tv_sec)  >= 2) {
+		/*
+		 * if delta_delta is too large, assume time correction
+		 * has occured and set old_delta to the current delta.
+		 */
+		old_delta = delta;
+	} else {
+		/* Otherwise try to adjust old_system to compensate */
+		timekeeping_suspend_time =
+			timespec_add(timekeeping_suspend_time, delta_delta);
+	}
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
-- 
1.7.3.2.146.gca209

