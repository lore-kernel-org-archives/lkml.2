Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab1DGMzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:55:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65289 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab1DGMzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:55:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rOCU43fd4NfQP6t15qxTEhffx6sBsa5oGaXLnMePlJPlGHeJSQfNQei5WfBegDDftc
         9KDUAbSff3ZfD3wVBhu/5+0idQMy84riguwg73NXLsa0EVcIdq/RilKePMuFvQzBcaS5
         QR2NccdA2kF/AtGPjfl+sOrnePiLKE+yCFzLc=
From: Jiejing Zhang <kzjeef@gmail.com>
To: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Zhang Jiejing <jiejing.zhang@freescale.com>
Subject: [RESEND PATCH] PM: add a config that give warnning if driver take too long on suspend/resume.
Date: Thu,  7 Apr 2011 20:54:54 +0800
Message-Id: <1302180894-16468-1-git-send-email-kzjeef@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Jiejing <jiejing.zhang@freescale.com>

This patch add function to check each device's suspend time
consumption. If any driver takes more time that the threshold (default
0.5 ms), it will print a warnning message including the device and bus
name on the console.  You can change the threshold on-the-fly by
modify file '/sys/power/device_suspend_time_threshold' to adjust this
value,the unit is in microsecond.

The output is like:
PM: device (bus)   :(device name) suspend/resume too slow, takes (time) msencs.
PM: device platform:soc-audio.2 suspend too slow, takes          606.696 msecs
PM: device platform:mxc_sdc_fb.1 suspend too slow, takes         7.708 msecs

Signed-off-by: Zhang Jiejing <jiejing.zhang@freescale.com>
---
 drivers/base/power/main.c  |   40 +++++++++++++++++++++++++++++++++++++++-
 drivers/base/power/power.h |    3 +++
 kernel/power/Kconfig       |   15 +++++++++++++++
 kernel/power/main.c        |   32 ++++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 052dc53..000243c 100644
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
diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index f2a25f1..72d5963 100644
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
index 4603f08..9b82c4b 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -87,6 +87,21 @@ config PM_SLEEP
 	def_bool y
 	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
 
+config SUSPEND_DEVICE_TIME_DEBUG
+        bool "Warnning device suspend/resume takes too much time"
+	depends on SUSPEND && PM_DEBUG
+	default n
+	---help---
+
+	This option will enable a timing function to check each device
+        suspend time consumption, If the device takes more time that
+        the threshold (default 0.5 ms), it will print the device and
+        bus name on the console.  You can change the threshold
+        on-the-fly by modify "/sys/power/device_suspend_time_threshold"
+        the unit is in microsecond.
+
+	This options only for debug proprose, If in doubt, say N.
+
 config PM_SLEEP_SMP
 	def_bool y
 	depends on SMP
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 8eaba5f..d2e734f 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -297,12 +297,44 @@ power_attr(pm_trace_dev_match);
 
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
1.7.1

