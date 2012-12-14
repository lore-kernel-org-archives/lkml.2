Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab2LNXTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:19:48 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:38401 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab2LNXTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:19:46 -0500
Date: Fri, 14 Dec 2012 16:19:33 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2] NTP: Add a CONFIG_RTC_SYSTOHC configuration
Message-ID: <20121214231933.GA15796@obsidianresearch.com>
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
implement update_persistent_clock and makes extensive use of the class
RTC system.

When enabled CONFIG_RTC_SYSTOHC will provide a generic
rtc_update_persistent_clock that stores the current time in the RTC and
is intended complement the existing CONFIG_RTC_HCTOSYS option that loads
the RTC at boot.

Like with RTC_HCTOSYS the platform's update_persistent_clock is used
first, if it works. Platforms with mixed class RTC and non-RTC drivers
need to return ENODEV when class RTC should be used. Such an update for
PPC is included in this patch.

Long term, implementations of update_persistent_clock should migrate to
proper class RTC drivers and use CONFIG_RTC_SYSTOHC instead.

Tested on ARM kirkwood and PPC405

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 arch/powerpc/kernel/time.c |    2 +-
 drivers/rtc/Kconfig        |    9 +++++++++
 drivers/rtc/Makefile       |    1 +
 drivers/rtc/systohc.c      |   44 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/time.h       |    1 +
 kernel/time/ntp.c          |   15 +++++++++++----
 6 files changed, 67 insertions(+), 5 deletions(-)
 create mode 100644 drivers/rtc/systohc.c

v2 updates:
 - Be very careful to return ENODEV from rtc_update_persistent_clock,
   we don't want to loop on the fast retry path of sync_cmos_clock
   if there is no RTC set support available
 - Call the platform update_persistent_clock first. Only try
   the RTC version if it is compiled out, or explicitly returns ENODEV
 - Added 'depends on RTC_SYSTOHC = y' to KConfig
 - Don't fast rety in sync_cmos_clock if ENODEV is returned
 - Update PPC to return ENODEV if there is no mach specific function
   available in ppc_md. This will give rtc_update_persistent_clock
   a chance.
 - Use rtc_set_time not mms since rtc_hctosys assumes UTC.

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index ce4cb77..bc844a8 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -667,7 +667,7 @@ int update_persistent_clock(struct timespec now)
 	struct rtc_time tm;
 
 	if (!ppc_md.set_rtc_time)
-		return 0;
+		return -ENODEV;
 
 	to_tm(now.tv_sec + 1 + timezone_offset, &tm);
 	tm.tm_year -= 1900;
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 19c03ab..7b3702b 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -28,6 +28,7 @@ config RTC_HCTOSYS
 config RTC_HCTOSYS_DEVICE
 	string "RTC used to set the system time"
 	depends on RTC_HCTOSYS = y
+	depends on RTC_SYSTOHC = y
 	default "rtc0"
 	help
 	  The RTC device that will be used to (re)initialize the system
@@ -48,6 +49,14 @@ config RTC_HCTOSYS_DEVICE
 	  sleep states. Do not specify an RTC here unless it stays powered
 	  during all this system's supported sleep states.
 
+config RTC_SYSTOHC
+	bool "Set the RTC time based on NTP synchronization"
+	default y
+	help
+	  If you say yes here, the system time (wall clock) will be stored
+          in the RTC specified by RTC_HCTOSYS_DEVICE approximately every 11
+  	  minutes if userspace reports synchronized NTP status.
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
index 0000000..a625740
--- /dev/null
+++ b/drivers/rtc/systohc.c
@@ -0,0 +1,44 @@
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ */
+#include <linux/rtc.h>
+#include <linux/time.h>
+
+/**
+ * rtc_update_persistent_clock - Save NTP synchronized time to the RTC
+ * @now: Current time of day
+ *
+ * Replacement for the NTP platform function update_persistent_clock
+ * that stores time for later retrieval by rtc_hctosys
+ *
+ * Returns 0 on successful RTC update, -ENODEV if a RTC update is not
+ * possible at all, and various other -errno for specific temporary failure
+ * cases.
+ *
+ * If temporary failure is indicated the caller should try again 'soon'
+ */
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
+		/* rtc_hctosys exclusively uses UTC, so we call set_time here,
+		 * not set_mmss. */
+		if (rtc->ops && (rtc->ops->set_time && rtc->ops->set_mmss))
+			err = rtc_set_time(rtc, &tm);
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
index 24174b4..0c5d1a1 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -483,8 +483,7 @@ out:
 	return leap;
 }
 
-#ifdef CONFIG_GENERIC_CMOS_UPDATE
-
+#if defined(CONFIG_GENERIC_CMOS_UPDATE) || defined(CONFIG_RTC_SYSTOHC)
 static void sync_cmos_clock(struct work_struct *work);
 
 static DECLARE_DELAYED_WORK(sync_cmos_work, sync_cmos_clock);
@@ -510,14 +509,22 @@ static void sync_cmos_clock(struct work_struct *work)
 	}
 
 	getnstimeofday(&now);
-	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
+	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2) {
+		fail = -ENODEV;
+#ifdef CONFIG_GENERIC_CMOS_UPDATE
 		fail = update_persistent_clock(now);
+#endif
+#ifdef CONFIG_RTC_SYSTOHC
+		if (fail == -ENODEV)
+			fail = rtc_update_persistent_clock(now);
+#endif
+	}
 
 	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec - (TICK_NSEC / 2);
 	if (next.tv_nsec <= 0)
 		next.tv_nsec += NSEC_PER_SEC;
 
-	if (!fail)
+	if (!fail || fail == -ENODEV)
 		next.tv_sec = 659;
 	else
 		next.tv_sec = 0;
-- 
1.7.5.4

