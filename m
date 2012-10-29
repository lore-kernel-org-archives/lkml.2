Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab2J2JMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:12:09 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42664 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab2J2JKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:10:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, Huang Ying <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 4/7] ACPI / PM: Split device wakeup management routines
Date: Mon, 29 Oct 2012 10:10:40 +0100
Message-ID: <2088336.KkOjtfWa5k@vostro.rjw.lan>
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

Two device wakeup management routines in device_pm.c and sleep.c,
acpi_pm_device_run_wake() and acpi_pm_device_sleep_wake(), take a
device pointer argument and use it to obtain the ACPI handle of the
corresponding ACPI namespace node.  That handle is then used to get
the address of the struct acpi_device object corresponding to the
struct device passed as the argument.

Unfortunately, that last operation may be costly, because it involves
taking the global ACPI namespace mutex, so it shouldn't be carried
out too often.  However, the callers of those routines usually call
them in a row with acpi_pm_device_sleep_state() which also takes that
mutex for the same reason, so it would be more efficient if they ran
acpi_bus_get_device() themselves to obtain a pointer to the struct
acpi_device object in question and then passed that pointer to the
appropriate PM routines.

To make that possible, split each of the PM routines mentioned above
in two parts, one taking a struct acpi_device pointer argument and
the other implementing the current interface for compatibility.

Additionally, change acpi_pm_device_run_wake() to actually return
an error code if there is an error while setting up runtime remote
wakeup for the device.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   74 ++++++++++++++++++++++++++++++++++++-----------
 drivers/acpi/sleep.c     |    8 +----
 include/acpi/acpi_bus.h  |   11 ++++++
 3 files changed, 71 insertions(+), 22 deletions(-)

Index: linux/drivers/acpi/device_pm.c
===================================================================
--- linux.orig/drivers/acpi/device_pm.c
+++ linux/drivers/acpi/device_pm.c
@@ -200,38 +200,78 @@ EXPORT_SYMBOL_GPL(acpi_device_power_stat
 
 #ifdef CONFIG_PM_RUNTIME
 /**
- * acpi_pm_device_run_wake - Enable/disable remote wakeup for given device.
- * @phys_dev: Device to enable/disable the platform to wake up.
+ * __acpi_device_run_wake - Enable/disable runtime remote wakeup for device.
+ * @adev: ACPI device to enable/disable the remote wakeup for.
  * @enable: Whether to enable or disable the wakeup functionality.
  *
- * Find the ACPI device object corresponding to @phys_dev and try to
- * enable/disable the GPE associated with it, so that it can generate
- * wakeup signals for the device in response to external (remote) events.
+ * Enable/disable the GPE associated with @adev so that it can generate
+ * wakeup signals for the device in response to external (remote) events and
+ * enable/disable device wakeup power.
+ *
+ * Callers must ensure that @adev is a valid ACPI device node before executing
+ * this function.
+ */
+int __acpi_device_run_wake(struct acpi_device *adev, bool enable)
+{
+	struct acpi_device_wakeup *wakeup = &adev->wakeup;
+
+	if (enable) {
+		acpi_status res;
+		int error;
+
+		error = acpi_enable_wakeup_device_power(adev, ACPI_STATE_S0);
+		if (error)
+			return error;
+
+		res = acpi_enable_gpe(wakeup->gpe_device, wakeup->gpe_number);
+		if (ACPI_FAILURE(res)) {
+			acpi_disable_wakeup_device_power(adev);
+			return -EIO;
+		}
+	} else {
+		acpi_disable_gpe(wakeup->gpe_device, wakeup->gpe_number);
+		acpi_disable_wakeup_device_power(adev);
+	}
+	return 0;
+}
+
+/**
+ * acpi_pm_device_run_wake - Enable/disable remote wakeup for given device.
+ * @dev: Device to enable/disable the platform to wake up.
+ * @enable: Whether to enable or disable the wakeup functionality.
  */
 int acpi_pm_device_run_wake(struct device *phys_dev, bool enable)
 {
-	struct acpi_device *dev;
+	struct acpi_device *adev;
 	acpi_handle handle;
 
 	if (!device_run_wake(phys_dev))
 		return -EINVAL;
 
 	handle = DEVICE_ACPI_HANDLE(phys_dev);
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &dev))) {
-		dev_dbg(phys_dev, "ACPI handle has no context in %s!\n",
+	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
+		dev_dbg(phys_dev, "ACPI handle without context in %s!\n",
 			__func__);
 		return -ENODEV;
 	}
 
-	if (enable) {
-		acpi_enable_wakeup_device_power(dev, ACPI_STATE_S0);
-		acpi_enable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
-	} else {
-		acpi_disable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
-		acpi_disable_wakeup_device_power(dev);
-	}
-
-	return 0;
+	return __acpi_device_run_wake(adev, enable);
 }
 EXPORT_SYMBOL(acpi_pm_device_run_wake);
 #endif /* CONFIG_PM_RUNTIME */
+
+ #ifdef CONFIG_PM_SLEEP
+/**
+ * __acpi_device_sleep_wake - Enable or disable device to wake up the system.
+ * @dev: Device to enable/desible to wake up the system.
+ * @target_state: System state the device is supposed to wake up from.
+ * @enable: Whether to enable or disable @dev to wake up the system.
+ */
+int __acpi_device_sleep_wake(struct acpi_device *adev, u32 target_state,
+			     bool enable)
+{
+	return enable ?
+		acpi_enable_wakeup_device_power(adev, target_state) :
+		acpi_disable_wakeup_device_power(adev);
+}
+#endif /* CONFIG_PM_SLEEP */
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -454,8 +454,13 @@ static inline int acpi_pm_device_sleep_s
 #endif
 
 #ifdef CONFIG_PM_RUNTIME
+int __acpi_device_run_wake(struct acpi_device *, bool);
 int acpi_pm_device_run_wake(struct device *, bool);
 #else
+static inline int __acpi_device_run_wake(struct acpi_device *adev, bool en)
+{
+	return -ENODEV;
+}
 static inline int acpi_pm_device_run_wake(struct device *dev, bool enable)
 {
 	return -ENODEV;
@@ -463,8 +468,14 @@ static inline int acpi_pm_device_run_wak
 #endif
 
 #ifdef CONFIG_PM_SLEEP
+int __acpi_device_sleep_wake(struct acpi_device *, u32, bool);
 int acpi_pm_device_sleep_wake(struct device *, bool);
 #else
+static inline int __acpi_device_sleep_wake(struct acpi_device *adev,
+					   u32 target_state, bool enable)
+{
+	return -ENODEV;
+}
 static inline int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
 {
 	return -ENODEV;
Index: linux/drivers/acpi/sleep.c
===================================================================
--- linux.orig/drivers/acpi/sleep.c
+++ linux/drivers/acpi/sleep.c
@@ -739,15 +739,13 @@ int acpi_pm_device_sleep_wake(struct dev
 
 	handle = DEVICE_ACPI_HANDLE(dev);
 	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
-		dev_dbg(dev, "ACPI handle has no context in %s!\n", __func__);
+		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
 		return -ENODEV;
 	}
 
-	error = enable ?
-		acpi_enable_wakeup_device_power(adev, acpi_target_sleep_state) :
-		acpi_disable_wakeup_device_power(adev);
+	error = __acpi_device_sleep_wake(adev, acpi_target_sleep_state, enable);
 	if (!error)
-		dev_info(dev, "wake-up capability %s by ACPI\n",
+		dev_info(dev, "System wakeup %s by ACPI\n",
 				enable ? "enabled" : "disabled");
 
 	return error;

