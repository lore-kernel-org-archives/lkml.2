Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab2GOI7K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 04:59:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab2GOI7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 04:59:06 -0400
Date: Sun, 15 Jul 2012 01:58:50 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-1f4f948706bcec1b51bf6492bf04057d2e21e273@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, prarit@redhat.com
Reply-To: john.stultz@linaro.org, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        richardcochran@gmail.com, tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <1342156917-25092-6-git-send-email-john.stultz@linaro.org>
References: <1342156917-25092-6-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Refactor accumulation of nsecs to secs
Git-Commit-ID: 1f4f948706bcec1b51bf6492bf04057d2e21e273
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 15 Jul 2012 01:58:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f4f948706bcec1b51bf6492bf04057d2e21e273
Gitweb:     http://git.kernel.org/tip/1f4f948706bcec1b51bf6492bf04057d2e21e273
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Fri, 13 Jul 2012 01:21:54 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 15 Jul 2012 10:39:06 +0200

time: Refactor accumulation of nsecs to secs

We do the exact same logic moving nsecs to secs in the
timekeeper in multiple places, so condense this into a
single function.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1342156917-25092-6-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |   54 ++++++++++++++++++++++++++------------------
 1 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index b98d9bd..cb4a433ba 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -991,6 +991,35 @@ static void timekeeping_adjust(s64 offset)
 
 
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
@@ -1001,7 +1030,6 @@ static void timekeeping_adjust(s64 offset)
  */
 static cycle_t logarithmic_accumulation(cycle_t offset, u32 shift)
 {
-	u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
 	u64 raw_nsecs;
 
 	/* If the offset is smaller than a shifted interval, do nothing */
@@ -1013,16 +1041,8 @@ static cycle_t logarithmic_accumulation(cycle_t offset, u32 shift)
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
@@ -1132,17 +1152,7 @@ static void update_wall_time(void)
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
 
