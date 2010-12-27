Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab0L0XlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 18:41:01 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53631 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab0L0XlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 18:41:00 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richard.cochran@omicron.at>
Subject: [PATCH 1/3] time: Introduce timekeeping_inject_offset
Date: Mon, 27 Dec 2010 15:40:42 -0800
Message-Id: <1293493244-17583-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
References: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a kernel-internal timekeeping interface to add or subtract
a fixed amount from CLOCK_REALTIME. This makes it so kernel users or
interfaces trying to do so do not have to read the time, then add an
offset and then call settimeofday(), which adds some extra error in
comparision to just simply adding the offset in the kernel timekeeping
core.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Richard Cochran <richard.cochran@omicron.at>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/time.h      |    1 +
 kernel/time/timekeeping.c |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 9f15ac7..b402134 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -166,6 +166,7 @@ extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
 extern void update_wall_time(void);
 extern void timekeeping_leap_insert(int leapsecond);
+extern int timekeeping_inject_offset(struct timespec *ts);
 
 struct tms;
 extern void do_sys_times(struct tms *);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 49010d8..77e79b3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -340,6 +340,42 @@ int do_settimeofday(struct timespec *tv)
 
 EXPORT_SYMBOL(do_settimeofday);
 
+
+/**
+ * timekeeping_inject_offset - Adds or subtracts from the current time.
+ * @tv:		pointer to the timespec variable containing the offset
+ *
+ * Adds or subtracts an offset value from the current time.
+ */
+int timekeeping_inject_offset(struct timespec *ts)
+{
+	unsigned long flags;
+
+	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
+		return -EINVAL;
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
+	timekeeping_forward_now();
+
+	xtime = timespec_add(xtime, *ts);
+	wall_to_monotonic = timespec_sub(wall_to_monotonic, *ts);
+
+	timekeeper.ntp_error = 0;
+	ntp_clear();
+
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+				timekeeper.mult);
+
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	/* signal hrtimers about time change */
+	clock_was_set();
+
+	return 0;
+}
+EXPORT_SYMBOL(timekeeping_inject_offset);
+
 /**
  * change_clocksource - Swaps clocksources if a new one is available
  *
-- 
1.7.3.2.146.gca209

