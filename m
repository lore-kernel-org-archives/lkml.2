Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab1DBFxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 01:53:43 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:46850
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560Ab1DBFxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 01:53:41 -0400
X-SpamScore: -5
X-BigFish: VS-5(z6c9Mzzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Zhang Jiejing <jiejing.zhang@freescale.com>
To: <linux-kernel@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
        <gregkh@suse.de>, <rjw@sisk.pl>
CC: <kzjeef@gmail.com>
Subject: [PATCH] PM: add time sensitive debug function to suspend/resume
Date: Sat, 2 Apr 2011 13:56:07 +0800
Message-ID: <1301723767-16394-1-git-send-email-jiejing.zhang@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 There was some driver is slow on suspend/resume,
 but some embeded system like eReader,Cellphone
 are time sensitive,this commit will report the slow
 driver on suspend/resume, the default value is 500us(0.5ms)

 Also, the threshold can be change by modify
 '/sys/power/device_suspend_time_threshold' to change the threshold,
 it is in microsecond.
 The output is like:

 PM: device platform:soc-audio.2 suspend too slow, takes          606.696 msecs
 PM: device platform:mxc_sdc_fb.1 suspend too slow, takes         7.708 msecs

Signed-off-by: Zhang Jiejing <jiejing.zhang@freescale.com>
---
 drivers/base/power/main.c  |   41 +++++++++++++++++++++++++++++++++++++++--
 drivers/base/power/power.h |    3 +++
 kernel/power/Kconfig       |   15 +++++++++++++++
 kernel/power/main.c        |   32 ++++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 8340497..b6bf8f1 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -178,6 +178,40 @@ static void initcall_debug_report(struct device *dev, ktime_t calltime,
 	}
 }
 
+#ifdef CONFIG_SUSPEND_DEVICE_TIME_DEBUG
+static void suspend_time_debug_start(ktime_t *start)
+{
+	*start = ktime_get();
+}
+
+static void suspend_time_debug_report(const char *name, struct device *dev,
+				      ktime_t starttime)
+{
+	ktime_t rettime;
+	s64 usecs64;
+	int usecs;
+
+	if (!dev->driver)
+		return;
+
+	rettime = ktime_get();
+	usecs64 = ktime_to_us(ktime_sub(rettime, starttime));
+	usecs = usecs64;
+	if (usecs == 0)
+		usecs = 1;
+
+	if (device_suspend_time_threshold
+	    && usecs > device_suspend_time_threshold)
+		pr_info("PM: device %s:%s %s too slow, it takes \t %ld.%03ld mses\n",
+			dev->bus->name, dev_name(dev), name,
+			usecs / USEC_PER_MSEC, usecs % USEC_PER_MSEC);
+}
+#else
+static void suspend_time_debug_start(ktime_t *start) {}
+static void suspend_time_debug_report(const char *name, struct device *dev,
+				      ktime_t starttime) {}
+#endif /* CONFIG_SUSPEND_DEVICE_TIME_DEBUG */
+
 /**
  * dpm_wait - Wait for a PM operation to complete.
  * @dev: Device to wait for.
@@ -214,7 +248,7 @@ static int pm_op(struct device *dev,
 		 pm_message_t state)
 {
 	int error = 0;
-	ktime_t calltime;
+	ktime_t calltime, starttime;
 
 	calltime = initcall_debug_start(dev);
 
@@ -222,13 +256,17 @@ static int pm_op(struct device *dev,
 #ifdef CONFIG_SUSPEND
 	case PM_EVENT_SUSPEND:
 		if (ops->suspend) {
+			suspend_time_debug_start(&starttime);
 			error = ops->suspend(dev);
+			suspend_time_debug_report("suspend", dev, starttime);
 			suspend_report_result(ops->suspend, error);
 		}
 		break;
 	case PM_EVENT_RESUME:
 		if (ops->resume) {
+			suspend_time_debug_start(&starttime);
 			error = ops->resume(dev);
+			suspend_time_debug_report("resume", dev, starttime);
 			suspend_report_result(ops->resume, error);
 		}
 		break;
@@ -405,7 +443,6 @@ static void dpm_show_time(ktime_t starttime, pm_message_t state, char *info)
 		info ?: "", info ? " " : "", pm_verb(state.event),
 		usecs / USEC_PER_MSEC, usecs % USEC_PER_MSEC);
 }
-
 /*------------------------- Resume routines -------------------------*/
 
 /**
diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index 698dde7..4100713 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -18,6 +18,9 @@ extern int pm_async_enabled;
 /* drivers/base/power/main.c */
 extern struct list_head dpm_list;	/* The active device list */
 
+/* driver/base/power/main.c */
+extern int device_suspend_time_threshold;
+
 static inline struct device *to_device(struct list_head *entry)
 {
 	return container_of(entry, struct device, power.entry);
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 2657299..82120f4 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -81,6 +81,21 @@ config PM_TRACE_RTC
 	CAUTION: this option will cause your machine's real-time clock to be
 	set to an invalid time after a resume.
 
+config SUSPEND_DEVICE_TIME_DEBUG
+        bool "Warnning device suspend/resume takes too much time"
+	depends on SUSPEND && PM_DEBUG
+	default n
+	---help---
+	This option will enable a timing function to check device
+        suspend time consumption, If the device takes more time that
+        the threshold(default 0.5 ms), it will print the device and
+        bus name on the console.  You can change the threshold
+        on-the-fly by modify /sys/power/time_threshold the time unit
+        is in microsecond.
+
+	This options only for debug proprose, If in doubt, say N.
+
+
 config PM_SLEEP_SMP
 	bool
 	depends on SMP
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 7b5db6a..90eee97 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -300,12 +300,44 @@ power_attr(pm_trace_dev_match);
 
 #endif /* CONFIG_PM_TRACE */
 
+#ifdef CONFIG_SUSPEND_DEVICE_TIME_DEBUG
+/*
+ * threshold of device suspend time consumption in microsecond(0.5ms), the
+ * driver suspend/resume time longer than this threshold will be
+ * print to console, 0 to disable */
+int device_suspend_time_threshold = 500;
+
+static ssize_t
+device_suspend_time_threshold_show(struct kobject *kobj,
+				   struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", device_suspend_time_threshold);
+}
+
+static ssize_t
+device_suspend_time_threshold_store(struct kobject *kobj,
+				    struct kobj_attribute *attr,
+				    const char *buf, size_t n)
+{
+	int val;
+	if (sscanf(buf, "%d", &val) > 0) {
+		device_suspend_time_threshold = val;
+		return n;
+	}
+	return -EINVAL;
+}
+power_attr(device_suspend_time_threshold);
+#endif
+
 static struct attribute * g[] = {
 	&state_attr.attr,
 #ifdef CONFIG_PM_TRACE
 	&pm_trace_attr.attr,
 	&pm_trace_dev_match_attr.attr,
 #endif
+#ifdef CONFIG_SUSPEND_DEVICE_TIME_DEBUG
+	&device_suspend_time_threshold_attr.attr,
+#endif
 #ifdef CONFIG_PM_SLEEP
 	&pm_async_attr.attr,
 	&wakeup_count_attr.attr,
-- 
1.7.0.4


