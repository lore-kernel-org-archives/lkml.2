Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab2GMFXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:23:30 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51492 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab2GMFW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:22:29 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/8] time: Refactor accumulation of nsecs to secs
Date: Fri, 13 Jul 2012 01:21:54 -0400
Message-Id: <1342156917-25092-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071305-7282-0000-0000-00000AE1D572
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do the exact same logic moving nsecs to secs in the
timekeeper in multiple places, so condense this into a
single function.

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Richard Cochran <richardcochran@gmail.com>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   54 +++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 80d0c78..5ffb2b6 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -995,6 +995,35 @@ static void timekeeping_adjust(s64 offset)
 
 
 /**
+ * accumulate_nsecs_to_secs - Accumulates nsecs into secs
+ *
+ * Helper function that accumulates a the nsecs greater then a second
+ * from the xtime_nsec field to the xtime_secs field.
+ * It also calls into the NTP code to handle leapsecond processing.
+ *
+ */
+static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
+{
+	u64 nsecps = (u64)NSEC_PER_SEC << tk->shift;
+
+	while (tk->xtime_nsec >= nsecps) {
+		int leap;
+
+		tk->xtime_nsec -= nsecps;
+		tk->xtime_sec++;
+
+		/* Figure out if its a leap sec and apply if needed */
+		leap = second_overflow(tk->xtime_sec);
+		tk->xtime_sec += leap;
+		tk->wall_to_monotonic.tv_sec -= leap;
+		if (leap)
+			clock_was_set_delayed();
+
+	}
+}
+
+
+/**
  * logarithmic_accumulation - shifted accumulation of cycles
  *
  * This functions accumulates a shifted interval of cycles into
@@ -1005,7 +1034,6 @@ static void timekeeping_adjust(s64 offset)
  */
 static cycle_t logarithmic_accumulation(cycle_t offset, u32 shift)
 {
-	u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
 	u64 raw_nsecs;
 
 	/* If the offset is smaller than a shifted interval, do nothing */
@@ -1017,16 +1045,8 @@ static cycle_t logarithmic_accumulation(cycle_t offset, u32 shift)
 	timekeeper.clock->cycle_last += timekeeper.cycle_interval << shift;
 
 	timekeeper.xtime_nsec += timekeeper.xtime_interval << shift;
-	while (timekeeper.xtime_nsec >= nsecps) {
-		int leap;
-		timekeeper.xtime_nsec -= nsecps;
-		timekeeper.xtime_sec++;
-		leap = second_overflow(timekeeper.xtime_sec);
-		timekeeper.xtime_sec += leap;
-		timekeeper.wall_to_monotonic.tv_sec -= leap;
-		if (leap)
-			clock_was_set_delayed();
-	}
+
+	accumulate_nsecs_to_secs(&timekeeper);
 
 	/* Accumulate raw time */
 	raw_nsecs = timekeeper.raw_interval << shift;
@@ -1136,17 +1156,7 @@ static void update_wall_time(void)
 	 * Finally, make sure that after the rounding
 	 * xtime_nsec isn't larger than NSEC_PER_SEC
 	 */
-	if (unlikely(timekeeper.xtime_nsec >=
-			((u64)NSEC_PER_SEC << timekeeper.shift))) {
-		int leap;
-		timekeeper.xtime_nsec -= (u64)NSEC_PER_SEC << timekeeper.shift;
-		timekeeper.xtime_sec++;
-		leap = second_overflow(timekeeper.xtime_sec);
-		timekeeper.xtime_sec += leap;
-		timekeeper.wall_to_monotonic.tv_sec -= leap;
-		if (leap)
-			clock_was_set_delayed();
-	}
+	accumulate_nsecs_to_secs(&timekeeper);
 
 	timekeeping_update(false);
 
-- 
1.7.9.5

