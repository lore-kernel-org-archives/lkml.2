Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab2LLF45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 00:56:57 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:53235 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab2LLF44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 00:56:56 -0500
Date: Tue, 11 Dec 2012 22:56:43 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Alessandro Zummo <a.zummo@towertech.it>, John Stultz <johnstul@us.ibm.com>,
        homas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] NTP: Add a CONFIG_RTC_SYSTOHC configuration
Message-ID: <20121212055643.GA18078@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this option is to allow ARM/etc systems that rely on the
class RTC subsystem to have the same kind of automatic NTP based
synchronization that we have on PC platforms. Today ARM does not
implement update_persistent_clock and makes extensive use of the
class RTC system.

When enabled CONFIG_RTC_SYSTOHC will provide a generic
rtc_update_persistent_clock that stores the current time in the RTC
and is intended complement the existing CONFIG_RTC_HCTOSYS option that
loads the RTC at boot.

The option also overrides the call to any platform update_persistent_clock
so that the RTC subsystem completely and generically replaces this
functionality.

Tested on ARM kirkwood and PPC405

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/rtc/Kconfig   |    8 ++++++++
 drivers/rtc/Makefile  |    1 +
 drivers/rtc/systohc.c |   30 ++++++++++++++++++++++++++++++
 include/linux/time.h  |    1 +
 kernel/time/ntp.c     |   12 ++++++++++--
 5 files changed, 50 insertions(+), 2 deletions(-)
 create mode 100644 drivers/rtc/systohc.c

I saw on Google an older version of a similar patch to this, but I
couldn't find any indication what happened to it. So here is a
slightly different take, tested on 3.7.

I've been running basically this idea buried in PPC platform specific
code since 2.6.16..

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 19c03ab..30a866a 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -48,6 +48,14 @@ config RTC_HCTOSYS_DEVICE
 	  sleep states. Do not specify an RTC here unless it stays powered
 	  during all this system's supported sleep states.
 
+config RTC_SYSTOHC
+	bool "Set the RTC time based on NTP synchronization"
+	default y
+	help
+	  If you say yes here, the system time (wall clock) will be stored
+          in the RTC specified by RTC_HCTOSYS_DEVICE approximately every 11
+  	  minutes if the NTP status is synchronized.
+
 config RTC_DEBUG
 	bool "RTC debug support"
 	help
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 56297f0..69d11f1 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -6,6 +6,7 @@ ccflags-$(CONFIG_RTC_DEBUG)	:= -DDEBUG
 
 obj-$(CONFIG_RTC_LIB)		+= rtc-lib.o
 obj-$(CONFIG_RTC_HCTOSYS)	+= hctosys.o
+obj-$(CONFIG_RTC_SYSTOHC)	+= systohc.o
 obj-$(CONFIG_RTC_CLASS)		+= rtc-core.o
 rtc-core-y			:= class.o interface.o
 
diff --git a/drivers/rtc/systohc.c b/drivers/rtc/systohc.c
new file mode 100644
index 0000000..0536cae
--- /dev/null
+++ b/drivers/rtc/systohc.c
@@ -0,0 +1,30 @@
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ */
+#include <linux/rtc.h>
+#include <linux/time.h>
+
+/* Replacement for the NTP platform function 'update_persistent_clock'
+ * that does the opposite of rtc_hctosys.c */
+int rtc_update_persistent_clock(struct timespec now)
+{
+	struct rtc_device *rtc;
+	struct rtc_time tm;
+	int err = -ENODEV;
+
+	if (now.tv_nsec < (NSEC_PER_SEC >> 1))
+		rtc_time_to_tm(now.tv_sec, &tm);
+	else
+		rtc_time_to_tm(now.tv_sec + 1, &tm);
+
+	rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
+	if (rtc) {
+		err = rtc_set_mmss(rtc, now.tv_sec);
+		rtc_class_close(rtc);
+	}
+
+	return err;
+}
diff --git a/include/linux/time.h b/include/linux/time.h
index 4d358e9..d668f9c 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -118,6 +118,7 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
 extern int update_persistent_clock(struct timespec now);
+extern int rtc_update_persistent_clock(struct timespec now);
 void timekeeping_init(void);
 extern int timekeeping_suspended;
 
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 24174b4..f79ab16 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -483,7 +483,15 @@ out:
 	return leap;
 }
 
-#ifdef CONFIG_GENERIC_CMOS_UPDATE
+#if defined(CONFIG_GENERIC_CMOS_UPDATE) || defined(CONFIG_RTC_SYSTOHC)
+
+/* Only do one, if using CONFIG_RTC_SYSTOHC then the platform function
+ * might be mapped to the RTC code already. */
+#ifdef CONFIG_RTC_SYSTOHC
+#define __update_persistent_clock rtc_update_persistent_clock
+#else
+#define __update_persistent_clock update_persistent_clock
+#endif
 
 static void sync_cmos_clock(struct work_struct *work);
 
@@ -511,7 +519,7 @@ static void sync_cmos_clock(struct work_struct *work)
 
 	getnstimeofday(&now);
 	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
-		fail = update_persistent_clock(now);
+		fail = __update_persistent_clock(now);
 
 	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec - (TICK_NSEC / 2);
 	if (next.tv_nsec <= 0)
-- 
1.7.5.4

