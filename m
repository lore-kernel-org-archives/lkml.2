Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031242Ab2EROKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:10:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54267 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031229Ab2EROKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:10:17 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC V2 4/6] time: introduce leap second functional interface
Date: Fri, 18 May 2012 16:09:56 +0200
Message-Id: <eee0b50afdea829c727d6210afb8299a4cf30981.1337348892.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <cover.1337348892.git.richardcochran@gmail.com>
References: <cover.1337348892.git.richardcochran@gmail.com>
In-Reply-To: <cover.1337348892.git.richardcochran@gmail.com>
References: <cover.1337348892.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new private leap second interface for use by the NTP
code. In addition to methods for starting and ending leap seconds, the
interface provides a way to get the correct UTC time of day even during
a leap second.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 kernel/time/leap-seconds.h |   21 +++++++
 kernel/time/timekeeping.c  |  129 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 150 insertions(+), 0 deletions(-)
 create mode 100644 kernel/time/leap-seconds.h

diff --git a/kernel/time/leap-seconds.h b/kernel/time/leap-seconds.h
new file mode 100644
index 0000000..3dea7b0
--- /dev/null
+++ b/kernel/time/leap-seconds.h
@@ -0,0 +1,21 @@
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
+int timekeeping_gettod_status(struct timespec *ts, time_t *offset);
+
+void timekeeping_delete_leap_second(void);
+
+void timekeeping_finish_leap_second(void);
+
+void timekeeping_insert_leap_second(void);
+
+#endif
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ac04de4..eab03fb 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -21,6 +21,8 @@
 #include <linux/tick.h>
 #include <linux/stop_machine.h>
 
+#include "leap-seconds.h"
+
 /* Structure holding internal timekeeping values. */
 struct timekeeper {
 	/* Current clocksource used for timekeeping. */
@@ -1290,3 +1292,130 @@ void xtime_update(unsigned long ticks)
 	do_timer(ticks);
 	write_sequnlock(&xtime_lock);
 }
+
+/**
+ * zero_hour - Returns the time of the next zero hour.
+ */
+static time_t zero_hour(time_t now)
+{
+	time_t days = now / 86400;
+	time_t zero = (1 + days) * 86400;
+	return zero;
+}
+
+/**
+ * timekeeping_delete_leap_second - Delete a leap second today.
+ */
+void timekeeping_delete_leap_second(void)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&timekeeper.lock, flags);
+
+	if (timekeeper.leap_state == LEAP_IDLE) {
+		timekeeper.utc_epoch = zero_hour(timekeeper.xtime.tv_sec);
+		timekeeper.leap_state = LEAP_DEL_PENDING;
+	}
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+}
+
+/**
+ * timekeeping_finish_leap_second - Advance the leap second threshold.
+ */
+void timekeeping_finish_leap_second(void)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&timekeeper.lock, flags);
+
+	if (timekeeper.leap_state == LEAP_INS_DONE ||
+	    timekeeper.leap_state == LEAP_DEL_DONE) {
+		timekeeper.utc_epoch = LONG_MAX;
+		timekeeper.leap_state = LEAP_IDLE;
+	}
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+}
+
+/**
+ * timekeeping_insert_leap_second - Add a leap second today.
+ */
+void timekeeping_insert_leap_second(void)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&timekeeper.lock, flags);
+
+	if (timekeeper.leap_state == LEAP_IDLE) {
+		timekeeper.utc_epoch = zero_hour(timekeeper.xtime.tv_sec);
+		timekeeper.leap_state = LEAP_INS_PENDING;
+	}
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+}
+
+/**
+ * timekeeping_gettod_status - Get the current time, TAI offset,
+ *                             and leap second status.
+ */
+int timekeeping_gettod_status(struct timespec *ts, time_t *offset)
+{
+	int code = TIME_OK, leap_state;
+	time_t diff, epoch, taioff;
+	unsigned long seq;
+	s64 nsecs;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqbegin(&timekeeper.lock);
+		*ts = timekeeper.xtime;
+		nsecs = timekeeping_get_ns();
+		nsecs += arch_gettimeoffset();
+		taioff = timekeeper.tai_offset;
+		epoch = timekeeper.utc_epoch;
+		leap_state = timekeeper.leap_state;
+	} while (read_seqretry(&timekeeper.lock, seq));
+
+	timespec_add_ns(ts, nsecs);
+
+	switch (leap_state) {
+	case LEAP_IDLE:
+		break;
+
+	case LEAP_INS_PENDING:
+		diff = epoch - ts->tv_sec;
+		if (diff > 0) {
+			code = TIME_INS;
+		} else {
+			code = diff ? TIME_WAIT : TIME_OOP;
+			ts->tv_sec--;
+			taioff++;
+		}
+		break;
+
+	case LEAP_INS_DONE:
+		diff = epoch - ts->tv_sec;
+		if (diff > 0)
+			code = TIME_OOP;
+		else
+			code = TIME_WAIT;
+		break;
+
+	case LEAP_DEL_PENDING:
+		diff = epoch - ts->tv_sec;
+		if (diff < 2) {
+			code = TIME_WAIT;
+			ts->tv_sec++;
+			taioff--;
+		} else {
+			code = TIME_DEL;
+		}
+		break;
+
+	case LEAP_DEL_DONE:
+		code = TIME_WAIT;
+		break;
+	}
+
+	*offset = taioff;
+	return code;
+}
-- 
1.7.2.5

