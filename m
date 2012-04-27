Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780Ab2D0INS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:13:18 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40798 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759691Ab2D0INI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:13:08 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC V1 4/5] timekeeping: Offer an interface to manipulate leap seconds.
Date: Fri, 27 Apr 2012 10:12:43 +0200
Message-Id: <52e139c98370c405288cbbb4ac76c435dc36731f.1335510125.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <cover.1335510125.git.richardcochran@gmail.com>
References: <cover.1335510125.git.richardcochran@gmail.com>
In-Reply-To: <cover.1335510125.git.richardcochran@gmail.com>
References: <cover.1335510125.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new internal interface to be used by the NTP code in
order to set the next leap second event. Also, it adds a kernel command
line option that can be used to dial the TAI - UTC offset at boot.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 kernel/time/leap-seconds.h |   23 ++++++
 kernel/time/timekeeping.c  |  175 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 198 insertions(+), 0 deletions(-)
 create mode 100644 kernel/time/leap-seconds.h

diff --git a/kernel/time/leap-seconds.h b/kernel/time/leap-seconds.h
new file mode 100644
index 0000000..d13923e8
--- /dev/null
+++ b/kernel/time/leap-seconds.h
@@ -0,0 +1,23 @@
+/*
+ * linux/kernel/time/leap-seconds.h
+ *
+ * Functional interface to the timekeeper code,
+ * for use by the NTP code.
+ *
+ */
+#ifndef __LINUX_KERNEL_TIME_LEAP_SECONDS_H
+#define __LINUX_KERNEL_TIME_LEAP_SECONDS_H
+
+#include <linux/time.h>
+
+int timekeeper_gettod_status(struct timespec *ts, int *offset);
+
+void timekeeper_delete_leap_second(void);
+
+void timekeeper_finish_leap_second(void);
+
+void timekeeper_insert_leap_second(void);
+
+void timekeeper_tai_offset(int offset);
+
+#endif
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6e46cac..7941258 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -21,6 +21,9 @@
 #include <linux/tick.h>
 #include <linux/stop_machine.h>
 
+#include "leap-seconds.h"
+#include "utc-tai.h"
+
 /* Structure holding internal timekeeping values. */
 struct timekeeper {
 	/* Current clocksource used for timekeeping. */
@@ -50,6 +53,16 @@ struct timekeeper {
 
 	/* The current time */
 	struct timespec xtime;
+	/* The Kernel Time Scale (KTS) value of the next leap second. */
+	time_t next_leapsecond;
+	/* The current difference KTS - UTC. */
+	int kts_utc_offset;
+	/* The current difference TAI - KTS. */
+	int tai_kts_offset;
+#ifdef CONFIG_DELETE_LEAP_SECONDS
+	/* Remembers whether to insert or to delete. */
+	int insert_leapsecond;
+#endif
 	/*
 	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
 	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
@@ -87,6 +100,30 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 int __read_mostly timekeeping_suspended;
 
 
+static int __init tai_offset_setup(char *str)
+{
+	get_option(&str, &timekeeper.kts_utc_offset);
+	return 1;
+}
+__setup("tai_offset=", tai_offset_setup);
+
+#ifdef CONFIG_DELETE_LEAP_SECONDS
+#define tk_insert timekeeper.insert_leapsecond
+#else
+#define tk_insert 1
+#endif
+
+/**
+ * timekeeper_utc_sec - returns current time in the UTC timescale
+ *
+ * Callers must use timekeeper.lock for reading.
+ */
+static inline time_t timekeeper_utc_sec(void)
+{
+	return tai_to_utc(timekeeper.xtime.tv_sec,
+			  timekeeper.next_leapsecond,
+			  timekeeper.kts_utc_offset, tk_insert);
+}
 
 /**
  * timekeeper_setup_internals - Set up internals to use clocksource clock.
@@ -455,6 +492,144 @@ static int change_clocksource(void *data)
 }
 
 /**
+ * timekeeper_gettod_status - Get the current time, TAI offset,
+ *                            and leap second status.
+ */
+int timekeeper_gettod_status(struct timespec *ts, int *offset)
+{
+	int code = TIME_OK, insert, ku_off, tk_off;
+	unsigned long seq;
+	time_t diff, next;
+	s64 nsecs;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqbegin(&timekeeper.lock);
+		next   = timekeeper.next_leapsecond;
+		ku_off = timekeeper.kts_utc_offset;
+		tk_off = timekeeper.tai_kts_offset;
+		*ts    = timekeeper.xtime;
+		nsecs  = timekeeping_get_ns();
+		nsecs += arch_gettimeoffset();
+		insert = tk_insert;
+
+	} while (read_seqretry(&timekeeper.lock, seq));
+
+	timespec_add_ns(ts, nsecs);
+
+	diff = next - ts->tv_sec;
+	ts->tv_sec = tai_to_utc(ts->tv_sec, next, ku_off, insert);
+
+	if (!diff) {
+		code = TIME_OOP;
+		ku_off += insert ? 1 : 0;
+	} else if (diff < 0) {
+		code = TIME_WAIT;
+		ku_off += insert ? 1 : -1;
+	} else if (diff < 86400) {
+		code = insert ? TIME_INS : TIME_DEL;
+	}
+
+	*offset = ku_off + tk_off;
+	return code;
+}
+
+/**
+ * utc_next_midnight - Return the UTC time of the next zero hour.
+ *
+ * Callers must use timekeeper.lock.
+ */
+static time_t utc_next_midnight(void)
+{
+	time_t days, now, zero;
+
+	now = timekeeper_utc_sec();
+	days = now / 86400;
+	zero = (1 + days) * 86400;
+
+	return zero;
+}
+
+/**
+ * timekeeper_delete_leap_second - Delete a leap second today.
+ */
+void timekeeper_delete_leap_second(void)
+{
+#ifdef CONFIG_DELETE_LEAP_SECONDS
+	time_t leap;
+	unsigned long flags;
+
+	write_seqlock_irqsave(&timekeeper.lock, flags);
+
+	leap = utc_next_midnight() - 1;
+	timekeeper.next_leapsecond = leap + timekeeper.kts_utc_offset;
+	timekeeper.insert_leapsecond = 0;
+
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+#endif
+}
+
+/**
+ * timekeeper_finish_leap_second - Advance the leap second threshold.
+ */
+void timekeeper_finish_leap_second(void)
+{
+	unsigned long flags;
+	write_seqlock_irqsave(&timekeeper.lock, flags);
+
+	if (timekeeper.xtime.tv_sec <= timekeeper.next_leapsecond)
+		goto out;
+
+	timekeeper.next_leapsecond = LONG_MAX;
+
+	if (tk_insert)
+		timekeeper.kts_utc_offset++;
+	else
+		timekeeper.kts_utc_offset--;
+out:
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+}
+
+/**
+ * timekeeper_insert_leap_second - Add a leap second today.
+ */
+void timekeeper_insert_leap_second(void)
+{
+	time_t leap;
+	unsigned long flags;
+
+	write_seqlock_irqsave(&timekeeper.lock, flags);
+
+	leap = utc_next_midnight();
+	timekeeper.next_leapsecond = leap + timekeeper.kts_utc_offset;
+#ifdef CONFIG_DELETE_LEAP_SECONDS
+	timekeeper.insert_leapsecond = 1;
+#endif
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+}
+
+/**
+ * timekeeper_tai_offset - Set the TAI - UTC offset.
+ *
+ * If the current offset is wrong, then we fix it by resetting the TAI
+ * clock and keeping the UTC time continuous. The rationale is that if
+ * a machine boots and gets an approximately correct UTC time from a
+ * RTC and later discovers the current TAI offset from the network,
+ * then the UTC users will not experience a jump in time.
+ */
+void timekeeper_tai_offset(int offset)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&timekeeper.lock, flags);
+
+	timekeeper.tai_kts_offset = offset - timekeeper.kts_utc_offset;
+
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+}
+
+/**
  * timekeeping_notify - Install a new clock source
  * @clock:		pointer to the clock source
  *
-- 
1.7.2.5

