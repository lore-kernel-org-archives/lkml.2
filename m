Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab2J2JKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:10:22 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42656 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab2J2JKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:10:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, Huang Ying <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 6/7] ACPI / PM: Move device PM functions related to sleep states
Date: Mon, 29 Oct 2012 10:12:50 +0100
Message-ID: <1456107.KxymqUQLId@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1766582.8gdQKXoi0K@vostro.rjw.lan>
References: <1766582.8gdQKXoi0K@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Introduce helper function returning the target sleep state of the
system and use it to move the remaining device power management
functions from sleep.c to device_pm.c.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   54 ++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/sleep.c     |   63 ++++-------------------------------------------
 include/acpi/acpi_bus.h  |    1 
 3 files changed, 61 insertions(+), 57 deletions(-)

Index: linux/drivers/acpi/sleep.c
===================================================================
--- linux.orig/drivers/acpi/sleep.c
+++ linux/drivers/acpi/sleep.c
@@ -80,6 +80,12 @@ static int acpi_sleep_prepare(u32 acpi_s
 
 #ifdef CONFIG_ACPI_SLEEP
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
+
+u32 acpi_target_system_state(void)
+{
+	return acpi_target_sleep_state;
+}
+
 static bool pwr_btn_event_pending;
 
 /*
@@ -695,63 +701,6 @@ int acpi_suspend(u32 acpi_state)
 	return -EINVAL;
 }
 
-#ifdef CONFIG_PM
-/**
- * acpi_pm_device_sleep_state - Get preferred power state of ACPI device.
- * @dev: Device whose preferred target power state to return.
- * @d_min_p: Location to store the upper limit of the allowed states range.
- * @d_max_in: Deepest low-power state to take into consideration.
- * Return value: Preferred power state of the device on success, -ENODEV
- * (if there's no 'struct acpi_device' for @dev) or -EINVAL on failure
- *
- * The caller must ensure that @dev is valid before using this function.
- */
-int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p, int d_max_in)
-{
-	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
-	struct acpi_device *adev;
-
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
-		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
-		return -ENODEV;
-	}
-
-	return acpi_device_power_state(dev, adev, acpi_target_sleep_state,
-				       d_max_in, d_min_p);
-}
-EXPORT_SYMBOL(acpi_pm_device_sleep_state);
-#endif /* CONFIG_PM */
-
-#ifdef CONFIG_PM_SLEEP
-/**
- * acpi_pm_device_sleep_wake - Enable or disable device to wake up the system.
- * @dev: Device to enable/desible to wake up the system from sleep states.
- * @enable: Whether to enable or disable @dev to wake up the system.
- */
-int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
-{
-	acpi_handle handle;
-	struct acpi_device *adev;
-	int error;
-
-	if (!device_can_wakeup(dev))
-		return -EINVAL;
-
-	handle = DEVICE_ACPI_HANDLE(dev);
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
-		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
-		return -ENODEV;
-	}
-
-	error = __acpi_device_sleep_wake(adev, acpi_target_sleep_state, enable);
-	if (!error)
-		dev_info(dev, "System wakeup %s by ACPI\n",
-				enable ? "enabled" : "disabled");
-
-	return error;
-}
-#endif  /* CONFIG_PM_SLEEP */
-
 static void acpi_power_off_prepare(void)
 {
 	/* Prepare to power off the system */
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -416,6 +416,7 @@ int acpi_enable_wakeup_device_power(stru
 int acpi_disable_wakeup_device_power(struct acpi_device *dev);
 
 #ifdef CONFIG_PM
+u32 acpi_target_system_state(void);
 acpi_status acpi_add_pm_notifier(struct acpi_device *adev,
 				 acpi_notify_handler handler, void *context);
 acpi_status acpi_remove_pm_notifier(struct acpi_device *adev,
Index: linux/drivers/acpi/device_pm.c
===================================================================
--- linux.orig/drivers/acpi/device_pm.c
+++ linux/drivers/acpi/device_pm.c
@@ -198,6 +198,31 @@ int acpi_device_power_state(struct devic
 }
 EXPORT_SYMBOL_GPL(acpi_device_power_state);
 
+/**
+ * acpi_pm_device_sleep_state - Get preferred power state of ACPI device.
+ * @dev: Device whose preferred target power state to return.
+ * @d_min_p: Location to store the upper limit of the allowed states range.
+ * @d_max_in: Deepest low-power state to take into consideration.
+ * Return value: Preferred power state of the device on success, -ENODEV
+ * (if there's no 'struct acpi_device' for @dev) or -EINVAL on failure
+ *
+ * The caller must ensure that @dev is valid before using this function.
+ */
+int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p, int d_max_in)
+{
+	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
+	struct acpi_device *adev;
+
+	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
+		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
+		return -ENODEV;
+	}
+
+	return acpi_device_power_state(dev, adev, acpi_target_system_state(),
+				       d_max_in, d_min_p);
+}
+EXPORT_SYMBOL(acpi_pm_device_sleep_state);
+
 #ifdef CONFIG_PM_RUNTIME
 /**
  * __acpi_device_run_wake - Enable/disable runtime remote wakeup for device.
@@ -274,4 +299,33 @@ int __acpi_device_sleep_wake(struct acpi
 		acpi_enable_wakeup_device_power(adev, target_state) :
 		acpi_disable_wakeup_device_power(adev);
 }
+
+/**
+ * acpi_pm_device_sleep_wake - Enable or disable device to wake up the system.
+ * @dev: Device to enable/desible to wake up the system from sleep states.
+ * @enable: Whether to enable or disable @dev to wake up the system.
+ */
+int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
+{
+	acpi_handle handle;
+	struct acpi_device *adev;
+	int error;
+
+	if (!device_can_wakeup(dev))
+		return -EINVAL;
+
+	handle = DEVICE_ACPI_HANDLE(dev);
+	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
+		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
+		return -ENODEV;
+	}
+
+	error = __acpi_device_sleep_wake(adev, acpi_target_system_state(),
+					 enable);
+	if (!error)
+		dev_info(dev, "System wakeup %s by ACPI\n",
+				enable ? "enabled" : "disabled");
+
+	return error;
+}
 #endif /* CONFIG_PM_SLEEP */

