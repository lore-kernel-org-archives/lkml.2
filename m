Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2IQWGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:06:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52915 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829Ab2IQWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:05:22 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Tony Luck <tony.luck@intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/6][RFC] time: Move timekeeper structure to timekeeper_internal.h for vsyscall changes
Date: Mon, 17 Sep 2012 18:04:56 -0400
Message-Id: <1347919501-64534-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
x-cbid: 12091722-1976-0000-0000-0000117577AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're going to need to access the timekeeper in update_vsyscall,
so make the structure available for those who need it.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Turner <pjt@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timekeeper_internal.h |   68 +++++++++++++++++++++++++++++++++++
 kernel/time/timekeeping.c           |   56 +----------------------------
 2 files changed, 69 insertions(+), 55 deletions(-)
 create mode 100644 include/linux/timekeeper_internal.h

diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
new file mode 100644
index 0000000..8ba43fa
--- /dev/null
+++ b/include/linux/timekeeper_internal.h
@@ -0,0 +1,68 @@
+/*
+ * You SHOULD NOT be including this unless you're vsyscall
+ * handling code or timekeeping internal code!
+ */
+
+#ifndef _LINUX_TIMEKEEPER_INTERNAL_H
+#define _LINUX_TIMEKEEPER_INTERNAL_H
+
+#include <linux/clocksource.h>
+#include <linux/jiffies.h>
+#include <linux/time.h>
+
+/* Structure holding internal timekeeping values. */
+struct timekeeper {
+	/* Current clocksource used for timekeeping. */
+	struct clocksource	*clock;
+	/* NTP adjusted clock multiplier */
+	u32			mult;
+	/* The shift value of the current clocksource. */
+	u32			shift;
+	/* Number of clock cycles in one NTP interval. */
+	cycle_t			cycle_interval;
+	/* Number of clock shifted nano seconds in one NTP interval. */
+	u64			xtime_interval;
+	/* shifted nano seconds left over when rounding cycle_interval */
+	s64			xtime_remainder;
+	/* Raw nano seconds accumulated per NTP interval. */
+	u32			raw_interval;
+
+	/* Current CLOCK_REALTIME time in seconds */
+	u64			xtime_sec;
+	/* Clock shifted nano seconds */
+	u64			xtime_nsec;
+
+	/* Difference between accumulated time and NTP time in ntp
+	 * shifted nano seconds. */
+	s64			ntp_error;
+	/* Shift conversion between clock shifted nano seconds and
+	 * ntp shifted nano seconds. */
+	u32			ntp_error_shift;
+
+	/*
+	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
+	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
+	 * at zero at system boot time, so wall_to_monotonic will be negative,
+	 * however, we will ALWAYS keep the tv_nsec part positive so we can use
+	 * the usual normalization.
+	 *
+	 * wall_to_monotonic is moved after resume from suspend for the
+	 * monotonic time not to jump. We need to add total_sleep_time to
+	 * wall_to_monotonic to get the real boot based time offset.
+	 *
+	 * - wall_to_monotonic is no longer the boot time, getboottime must be
+	 * used instead.
+	 */
+	struct timespec		wall_to_monotonic;
+	/* Offset clock monotonic -> clock realtime */
+	ktime_t			offs_real;
+	/* time spent in suspend */
+	struct timespec		total_sleep_time;
+	/* Offset clock monotonic -> clock boottime */
+	ktime_t			offs_boot;
+	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
+	struct timespec		raw_time;
+	/* Seqlock for all timekeeper values */
+	seqlock_t		lock;
+};
+#endif /* _LINUX_TIMEKEEPER_INTERNAL_H */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 34e5eac..61f5fba 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -8,6 +8,7 @@
  *
  */
 
+#include <linux/timekeeper_internal.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/percpu.h>
@@ -21,61 +22,6 @@
 #include <linux/tick.h>
 #include <linux/stop_machine.h>
 
-/* Structure holding internal timekeeping values. */
-struct timekeeper {
-	/* Current clocksource used for timekeeping. */
-	struct clocksource	*clock;
-	/* NTP adjusted clock multiplier */
-	u32			mult;
-	/* The shift value of the current clocksource. */
-	u32			shift;
-	/* Number of clock cycles in one NTP interval. */
-	cycle_t			cycle_interval;
-	/* Number of clock shifted nano seconds in one NTP interval. */
-	u64			xtime_interval;
-	/* shifted nano seconds left over when rounding cycle_interval */
-	s64			xtime_remainder;
-	/* Raw nano seconds accumulated per NTP interval. */
-	u32			raw_interval;
-
-	/* Current CLOCK_REALTIME time in seconds */
-	u64			xtime_sec;
-	/* Clock shifted nano seconds */
-	u64			xtime_nsec;
-
-	/* Difference between accumulated time and NTP time in ntp
-	 * shifted nano seconds. */
-	s64			ntp_error;
-	/* Shift conversion between clock shifted nano seconds and
-	 * ntp shifted nano seconds. */
-	u32			ntp_error_shift;
-
-	/*
-	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
-	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
-	 * at zero at system boot time, so wall_to_monotonic will be negative,
-	 * however, we will ALWAYS keep the tv_nsec part positive so we can use
-	 * the usual normalization.
-	 *
-	 * wall_to_monotonic is moved after resume from suspend for the
-	 * monotonic time not to jump. We need to add total_sleep_time to
-	 * wall_to_monotonic to get the real boot based time offset.
-	 *
-	 * - wall_to_monotonic is no longer the boot time, getboottime must be
-	 * used instead.
-	 */
-	struct timespec		wall_to_monotonic;
-	/* Offset clock monotonic -> clock realtime */
-	ktime_t			offs_real;
-	/* time spent in suspend */
-	struct timespec		total_sleep_time;
-	/* Offset clock monotonic -> clock boottime */
-	ktime_t			offs_boot;
-	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
-	struct timespec		raw_time;
-	/* Seqlock for all timekeeper values */
-	seqlock_t		lock;
-};
 
 static struct timekeeper timekeeper;
 
-- 
1.7.9.5

