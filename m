Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab1EKR3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:29:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52596 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1EKR3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:29:34 -0400
X-AuditID: cbfee61a-b7c84ae000006ee6-bd-4dca1c222ad3
Date: Wed, 11 May 2011 14:18:25 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [RFC PATCH v3 2/2] PM / Core: partial resume/suspend API for
 suspend_again users.
In-reply-to: <1305091105-27173-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        Len Brown <len.brown@intel.com>
Message-id: <1305091105-27173-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1305091105-27173-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 11 May 2011 05:18:26.0036 (UTC)
 FILETIME=[DAFDFB40:01CC0F9A]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API, suspend_again, is supposed to be used by platforms when the
platforms want to execute some code while suspended (wakeup by an alarm
or periodic ticks, run code, suspend again). Because suspend_again is
not called when every device is resumed, but is called right after
suspend_enter() is called, the suspend_again callback should include
device resume and suspend features.

This patch provides two APIs: dpm_partial_resume and
dpm_partial_suspend. They are supposed to be used in suspend_again to
actiavte required devices.

A usage example is:

/* Devices required to run "monitor_something()". */
static device *devs[] = {
	&console_serial,
	&device_x,
	&device_y,
	...
};

bool example_suspend_again(void)
{
	int error, monitor_result;

	if (!wakeup_reason_is_polling())
		return false;

	dpm_partial_resume(PMSG_RESUME, devs, ARRAY_SIZE(devs));
	resume_console();

	monitor_result = monitor_something();

	suspend_console();
	error = dpm_partial_suspend(PMSG_SUSPEND, devs, ARRAY_SIZE(devs));

	if (error || monitor_result == ERROR)
		return false;

	return true;
}

Tested at Exynos4-NURI.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/base/power/main.c |  154 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pm.h        |    4 +
 2 files changed, 158 insertions(+), 0 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 052dc53..71dc693 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1082,3 +1082,157 @@ int device_pm_wait_for_dev(struct device *subordinate, struct device *dev)
 	return async_error;
 }
 EXPORT_SYMBOL_GPL(device_pm_wait_for_dev);
+
+/**
+ * __dpm_partial_resume - Execute "resume" callbacks for the listed devices.
+ * @state: PM transition being carried out.
+ * @devs: Array of pointers for the devices being resumed
+ * @size: The size of devs array.
+ */
+static void __dpm_partial_resume(pm_message_t state, struct device **devs,
+				 int size)
+{
+	int i;
+	struct device *dev;
+
+	for (i = 0; i < size; i++) {
+		int error;
+
+		dev = devs[i];
+		get_device(dev);
+
+		error = device_resume(dev, state, false);
+		if (error)
+			pm_dev_err(dev, state, "", error);
+
+		put_device(dev);
+	}
+}
+
+/**
+ * __dpm_partial_complete - Complete a PM transition for the listed devices.
+ * @state: PM transition being carried out.
+ * @devs: Array of pointers for the devices being resumed
+ * @size: The size of devs array.
+ */
+static void __dpm_partial_complete(pm_message_t state, struct device **devs,
+				   int size)
+{
+	int i;
+	struct device *dev;
+
+	for (i = 0; i < size; i++) {
+		dev = devs[i];
+
+		get_device(dev);
+		dev->power.in_suspend = false;
+
+		device_complete(dev, state);
+
+		put_device(dev);
+	}
+}
+
+/**
+ * dpm_partial_resume - Execute "resume" callbacks and complete system
+ *			transaction for the chosen devices only.
+ * @state: PM transition being carried out.
+ * @devs: Array of pointers for the devices being resumed
+ * @size: The size of devs array.
+ *
+ * Execute "resume" callbacks for the listed devices and complete the PM
+ * transition of them.
+ *
+ * Because the only a part of devices will be resumed, asynchronous resume
+ * is dropped.
+ */
+void dpm_partial_resume(pm_message_t state, struct device **devs, int size)
+{
+	/* Partial dpm_resume */
+	__dpm_partial_resume(state, devs, size);
+
+	/* Partial dpm_complete */
+	__dpm_partial_complete(state, devs, size);
+}
+EXPORT_SYMBOL_GPL(dpm_partial_resume);
+
+/**
+ * dpm_partial_suspend - Prepare the given devices for PM transition and
+ *			suspend them.
+ * @state: PM transition being carried out.
+ * @devs: Array of pointers for the devices being suspended
+ * @size: The size of devs array.
+ *
+ * Prepare the given devices for system PM transition and execute "suspend"
+ * callbacks for them.
+ *
+ * The devs array is iterated in the reversed order to use the same devs
+ * array with dpm_partial_resume().
+ */
+int dpm_partial_suspend(pm_message_t state, struct device **devs, int size)
+{
+	int error = 0, i;
+	struct device *dev;
+
+	/* Partial dpm_prepare */
+	for (i = size - 1; i >= 0; i--) {
+		dev = devs[i];
+
+		get_device(dev);
+
+		pm_runtime_get_noresume(dev);
+		if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
+			pm_wakeup_event(dev, 0);
+
+		pm_runtime_put_sync(dev);
+		error = pm_wakeup_pending() ?
+				-EBUSY : device_prepare(dev, state);
+
+		if (error) {
+			if (error == -EAGAIN) {
+				put_device(dev);
+				error = 0;
+				i++; /* Try Again */
+				continue;
+			}
+			printk(KERN_INFO "PM: Device %s not prepared "
+				"for power transition: code %d\n",
+				dev_name(dev), error);
+			put_device(dev);
+			break;
+		}
+		dev->power.in_suspend = true;
+		put_device(dev);
+	}
+
+	if (error)
+		goto err_prepare;
+
+	/* Partial dpm_suspend */
+	for (i = size - 1; i >= 0; i--) {
+		dev = devs[i];
+
+		get_device(dev);
+
+		/* Synchronous suspend. The list shouldn't be long */
+		error = __device_suspend(dev, pm_transition, false);
+
+		if (error) {
+			pm_dev_err(dev, state, "", error);
+			put_device(dev);
+			break;
+		}
+		put_device(dev);
+	}
+
+	if (!error)
+		return 0;
+
+	__dpm_partial_resume(PMSG_RESUME, devs + i + 1, size - i - 1);
+	i = -1;
+err_prepare:
+	__dpm_partial_complete(PMSG_RESUME, devs + i + 1, size - i - 1);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(dpm_partial_suspend);
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 512e091..b407762 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -540,10 +540,14 @@ static inline int sysdev_resume(void) { return 0; }
 extern void device_pm_lock(void);
 extern void dpm_resume_noirq(pm_message_t state);
 extern void dpm_resume_end(pm_message_t state);
+extern void dpm_partial_resume(pm_message_t state, struct device **devs,
+			       int size);
 
 extern void device_pm_unlock(void);
 extern int dpm_suspend_noirq(pm_message_t state);
 extern int dpm_suspend_start(pm_message_t state);
+extern int dpm_partial_suspend(pm_message_t state, struct device **devs,
+			       int size);
 
 extern void __suspend_report_result(const char *function, void *fn, int ret);
 
-- 
1.7.4.1

