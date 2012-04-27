Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745Ab2D0IOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:14:40 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64908 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315Ab2D0IM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:12:59 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC V1 1/5] Add functions to convert continuous timescales to UTC.
Date: Fri, 27 Apr 2012 10:12:40 +0200
Message-Id: <ab3102e23721f82df9841af9584c6c4b12501869.1335510125.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <cover.1335510125.git.richardcochran@gmail.com>
References: <cover.1335510125.git.richardcochran@gmail.com>
In-Reply-To: <cover.1335510125.git.richardcochran@gmail.com>
References: <cover.1335510125.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a pair of inline helper functions to convert from
one timescale to the other, around a given leap second threshold.
Also, it adds an academic compile time option to support deleting
leap seconds.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 kernel/time/Kconfig   |   12 ++++++
 kernel/time/utc-tai.h |   99 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+), 0 deletions(-)
 create mode 100644 kernel/time/utc-tai.h

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index a20dc8a..1569aef 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -26,6 +26,18 @@ config HIGH_RES_TIMERS
 	  hardware is not capable then this option only increases
 	  the size of the kernel image.
 
+config DELETE_LEAP_SECONDS
+	bool "Support deletion of leap seconds"
+	default y
+	help
+	  This option enables support for leap second deletion via the
+	  STA_DEL control bit in the NTP adjtimex system call.
+
+	  Historically, leap seconds have only ever been inserted,
+	  never deleted. Saying no here results in a slightly smaller
+	  kernel image. If you believe that Earth's rotational speed
+	  might one day increase, then say yes here.
+
 config GENERIC_CLOCKEVENTS_BUILD
 	bool
 	default y
diff --git a/kernel/time/utc-tai.h b/kernel/time/utc-tai.h
new file mode 100644
index 0000000..ffc3ae9
--- /dev/null
+++ b/kernel/time/utc-tai.h
@@ -0,0 +1,99 @@
+/*
+ * linux/kernel/time/utc-tai.h
+ *
+ * Converts between TAI and UTC by applying the offset correction.
+ *
+ * Copyright (C) 2012 Richard Cochran <richardcochran@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#ifndef __LINUX_KERNEL_TIME_UTC_TAI_H
+#define __LINUX_KERNEL_TIME_UTC_TAI_H
+
+#include <linux/types.h>
+
+static inline time_t __tai_to_utc(time_t tai, time_t next, int offset)
+{
+	time_t utc = tai - offset;
+
+	if (unlikely(tai >= next))
+		utc--;
+
+	return utc;
+}
+
+static inline time_t __utc_to_tai(time_t utc, time_t next, int offset)
+{
+	time_t leapsec = next - offset;
+	time_t result = utc + offset;
+
+	if (unlikely(utc >= leapsec))
+		result++;
+
+	return result;
+}
+
+#ifdef CONFIG_DELETE_LEAP_SECONDS
+
+static inline time_t tai_to_utc(time_t tai, time_t next, int offset, int insert)
+{
+	if (likely(insert))
+		return __tai_to_utc(tai, next, offset);
+
+	if (unlikely(tai > next))
+		return tai - offset + 1;
+
+	return tai - offset;
+}
+
+static inline time_t utc_to_tai(time_t utc, time_t next, int offset, int insert)
+{
+	time_t leapsec, result;
+
+	if (likely(insert))
+		return __utc_to_tai(utc, next, offset);
+
+	leapsec = next - offset + 1;
+
+	if (unlikely(utc > leapsec))
+		result = utc + offset - 1;
+	else if (utc < leapsec)
+		result = utc + offset;
+	else {
+		/*
+		 * Ouch, this time never existed.
+		 */
+		result = next;
+	}
+
+	return result;
+}
+
+#else /*CONFIG_DELETE_LEAP_SECONDS*/
+
+static inline time_t tai_to_utc(time_t tai, time_t next, int offset, int insert)
+{
+	return __tai_to_utc(tai, next, offset);
+}
+
+static inline time_t utc_to_tai(time_t utc, time_t next, int offset, int insert)
+{
+	return __utc_to_tai(utc, next, offset);
+}
+
+#endif /*!CONFIG_DELETE_LEAP_SECONDS*/
+
+#endif
-- 
1.7.2.5

