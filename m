Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab2J2JKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:10:19 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42647 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab2J2JKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:10:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, Huang Ying <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 7/7] ACPI / PM: Provide ACPI PM callback routines for subsystems
Date: Mon, 29 Oct 2012 10:13:41 +0100
Message-ID: <4259109.0f0Y65qBuZ@vostro.rjw.lan>
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

Some bus types don't support power management natively, but generally
there may be device nodes in ACPI tables corresponding to the devices
whose bus types they are (under ACPI 5 those bus types may be SPI,
I2C and platform).  If that is the case, standard ACPI power
management may be applied to those devices, although currently the
kernel has no means for that.

For this reason, provide a set of routines that may be used as power
management callbacks for such devices.  This may be done in three
different ways.

 (1) Device drivers handling the devices in question may run
     acpi_dev_pm_attach() in their .probe() routines, which (on
     success) will cause the devices to be added to the general ACPI
     PM domain and ACPI power management will be used for them going
     forward.  Then, acpi_dev_pm_detach() may be used to remove the
     devices from the general ACPI PM domain if ACPI power management
     is not necessary for them any more.

 (2) The devices' subsystems may use acpi_subsys_runtime_suspend(),
     acpi_subsys_runtime_resume(), acpi_subsys_prepare(),
     acpi_subsys_suspend_late(), acpi_subsys_resume_early() as their
     power management callbacks in the same way as the general ACPI
     PM domain does that.

 (3) The devices' drivers may execute acpi_dev_suspend_late(),
     acpi_dev_resume_early(), acpi_dev_runtime_suspend(),
     acpi_dev_runtime_resume() from their power management callbacks
     as appropriate, if that's absolutely necessary, but it is not
     recommended to do that, because such drivers may not work
     without ACPI support as a result.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |  314 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h     |   34 +++++
 2 files changed, 348 insertions(+)

Index: linux/drivers/acpi/device_pm.c
===================================================================
--- linux.orig/drivers/acpi/device_pm.c
+++ linux/drivers/acpi/device_pm.c
@@ -225,6 +225,22 @@ EXPORT_SYMBOL(acpi_pm_device_sleep_state
 
 #ifdef CONFIG_PM_RUNTIME
 /**
+ * acpi_wakeup_device - Wakeup notification handler for ACPI devices.
+ * @handle: ACPI handle of the device the notification is for.
+ * @event: Type of the signaled event.
+ * @context: Device corresponding to @handle.
+ */
+static void acpi_wakeup_device(acpi_handle handle, u32 event, void *context)
+{
+	struct device *dev = context;
+
+	if (event == ACPI_NOTIFY_DEVICE_WAKE && dev) {
+		pm_wakeup_event(dev, 0);
+		pm_runtime_resume(dev);
+	}
+}
+
+/**
  * __acpi_device_run_wake - Enable/disable runtime remote wakeup for device.
  * @adev: ACPI device to enable/disable the remote wakeup for.
  * @enable: Whether to enable or disable the wakeup functionality.
@@ -329,3 +345,301 @@ int acpi_pm_device_sleep_wake(struct dev
 	return error;
 }
 #endif /* CONFIG_PM_SLEEP */
+
+/**
+ * acpi_dev_pm_get_node - Get ACPI device node for the given physical device.
+ * @dev: Device to get the ACPI node for.
+ */
+static struct acpi_device *acpi_dev_pm_get_node(struct device *dev)
+{
+	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
+	struct acpi_device *adev;
+
+	return handle && ACPI_SUCCESS(acpi_bus_get_device(handle, &adev)) ?
+		adev : NULL;
+}
+
+/**
+ * acpi_dev_pm_low_power - Put ACPI device into a low-power state.
+ * @dev: Device to put into a low-power state.
+ * @adev: ACPI device node corresponding to @dev.
+ * @system_state: System state to choose the device state for.
+ */
+static int acpi_dev_pm_low_power(struct device *dev, struct acpi_device *adev,
+				 u32 system_state)
+{
+	int power_state;
+
+	if (!acpi_device_power_manageable(adev))
+		return 0;
+
+	power_state = acpi_device_power_state(dev, adev, system_state,
+					      ACPI_STATE_D3, NULL);
+	if (power_state < ACPI_STATE_D0 || power_state > ACPI_STATE_D3)
+		return -EIO;
+
+	return acpi_device_set_power(adev, power_state);
+}
+
+/**
+ * acpi_dev_pm_full_power - Put ACPI device into the full-power state.
+ * @adev: ACPI device node to put into the full-power state.
+ */
+static int acpi_dev_pm_full_power(struct acpi_device *adev)
+{
+	return acpi_device_power_manageable(adev) ?
+		acpi_device_set_power(adev, ACPI_STATE_D0) : 0;
+}
+
+#ifdef CONFIG_PM_RUNTIME
+/**
+ * acpi_dev_runtime_suspend - Put device into a low-power state using ACPI.
+ * @dev: Device to put into a low-power state.
+ *
+ * Put the given device into a runtime low-power state using the standard ACPI
+ * mechanism.  Set up remote wakeup if desired, choose the state to put the
+ * device into (this checks if remote wakeup is expected to work too), and set
+ * the power state of the device.
+ */
+int acpi_dev_runtime_suspend(struct device *dev)
+{
+	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+	bool remote_wakeup;
+	int error;
+
+	if (!adev)
+		return 0;
+
+	remote_wakeup = dev_pm_qos_flags(dev, PM_QOS_FLAG_REMOTE_WAKEUP) >
+				PM_QOS_FLAGS_NONE;
+	error = __acpi_device_run_wake(adev, remote_wakeup);
+	if (remote_wakeup && error)
+		return -EAGAIN;
+
+	error = acpi_dev_pm_low_power(dev, adev, ACPI_STATE_S0);
+	if (error)
+		__acpi_device_run_wake(adev, false);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_runtime_suspend);
+
+/**
+ * acpi_dev_runtime_resume - Put device into the full-power state using ACPI.
+ * @dev: Device to put into the full-power state.
+ *
+ * Put the given device into the full-power state using the standard ACPI
+ * mechanism at run time.  Set the power state of the device to ACPI D0 and
+ * disable remote wakeup.
+ */
+int acpi_dev_runtime_resume(struct device *dev)
+{
+	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+	int error;
+
+	if (!adev)
+		return 0;
+
+	error = acpi_dev_pm_full_power(adev);
+	__acpi_device_run_wake(adev, false);
+	return error;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_runtime_resume);
+
+/**
+ * acpi_subsys_runtime_suspend - Suspend device using ACPI.
+ * @dev: Device to suspend.
+ *
+ * Carry out the generic runtime suspend procedure for @dev and use ACPI to put
+ * it into a runtime low-power state.
+ */
+int acpi_subsys_runtime_suspend(struct device *dev)
+{
+	int ret = pm_generic_runtime_suspend(dev);
+	return ret ? ret : acpi_dev_runtime_suspend(dev);
+}
+EXPORT_SYMBOL_GPL(acpi_subsys_runtime_suspend);
+
+/**
+ * acpi_subsys_runtime_resume - Resume device using ACPI.
+ * @dev: Device to Resume.
+ *
+ * Use ACPI to put the given device into the full-power state and carry out the
+ * generic runtime resume procedure for it.
+ */
+int acpi_subsys_runtime_resume(struct device *dev)
+{
+	int ret = acpi_dev_runtime_resume(dev);
+	return ret ? ret : pm_generic_runtime_resume(dev);
+}
+EXPORT_SYMBOL_GPL(acpi_subsys_runtime_resume);
+#endif /* CONFIG_PM_RUNTIME */
+
+#ifdef CONFIG_PM_SLEEP
+/**
+ * acpi_dev_suspend_late - Put device into a low-power state using ACPI.
+ * @dev: Device to put into a low-power state.
+ *
+ * Put the given device into a low-power state during system transition to a
+ * sleep state using the standard ACPI mechanism.  Set up system wakeup if
+ * desired, choose the state to put the device into (this checks if system
+ * wakeup is expected to work too), and set the power state of the device.
+ */
+int acpi_dev_suspend_late(struct device *dev)
+{
+	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+	u32 target_state;
+	bool wakeup;
+	int error;
+
+	if (!adev)
+		return 0;
+
+	target_state = acpi_target_system_state();
+	wakeup = device_may_wakeup(dev);
+	error = __acpi_device_sleep_wake(adev, target_state, wakeup);
+	if (wakeup && error)
+		return error;
+
+	error = acpi_dev_pm_low_power(dev, adev, target_state);
+	if (error)
+		__acpi_device_sleep_wake(adev, ACPI_STATE_UNKNOWN, false);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_suspend_late);
+
+/**
+ * acpi_dev_resume_early - Put device into the full-power state using ACPI.
+ * @dev: Device to put into the full-power state.
+ *
+ * Put the given device into the full-power state using the standard ACPI
+ * mechanism during system transition to the working state.  Set the power
+ * state of the device to ACPI D0 and disable remote wakeup.
+ */
+int acpi_dev_resume_early(struct device *dev)
+{
+	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+	int error;
+
+	if (!adev)
+		return 0;
+
+	error = acpi_dev_pm_full_power(adev);
+	__acpi_device_sleep_wake(adev, ACPI_STATE_UNKNOWN, false);
+	return error;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_resume_early);
+
+/**
+ * acpi_subsys_prepare - Prepare device for system transition to a sleep state.
+ * @dev: Device to prepare.
+ */
+int acpi_subsys_prepare(struct device *dev)
+{
+	/*
+	 * Follow PCI and resume devices suspended at run time before running
+	 * their system suspend callbacks.
+	 */
+	pm_runtime_resume(dev);
+	return pm_generic_prepare(dev);
+}
+EXPORT_SYMBOL_GPL(acpi_subsys_prepare);
+
+/**
+ * acpi_subsys_suspend_late - Suspend device using ACPI.
+ * @dev: Device to suspend.
+ *
+ * Carry out the generic late suspend procedure for @dev and use ACPI to put
+ * it into a low-power state during system transition into a sleep state.
+ */
+int acpi_subsys_suspend_late(struct device *dev)
+{
+	int ret = pm_generic_suspend_late(dev);
+	return ret ? ret : acpi_dev_suspend_late(dev);
+}
+EXPORT_SYMBOL_GPL(acpi_subsys_suspend_late);
+
+/**
+ * acpi_subsys_resume_early - Resume device using ACPI.
+ * @dev: Device to Resume.
+ *
+ * Use ACPI to put the given device into the full-power state and carry out the
+ * generic early resume procedure for it during system transition into the
+ * working state.
+ */
+int acpi_subsys_resume_early(struct device *dev)
+{
+	int ret = acpi_dev_runtime_resume(dev);
+	return ret ? ret : pm_generic_resume_early(dev);
+}
+EXPORT_SYMBOL_GPL(acpi_subsys_resume_early);
+#endif /* CONFIG_PM_SLEEP */
+
+static struct dev_pm_domain acpi_general_pm_domain = {
+	.ops = {
+#ifdef CONFIG_PM_RUNTIME
+		.runtime_suspend = acpi_subsys_runtime_suspend,
+		.runtime_resume = acpi_subsys_runtime_resume,
+		.runtime_idle = pm_generic_runtime_idle,
+#endif
+#ifdef CONFIG_PM_SLEEP
+		.prepare = acpi_subsys_prepare,
+		.suspend_late = acpi_subsys_suspend_late,
+		.resume_early = acpi_subsys_resume_early,
+		.poweroff_late = acpi_subsys_suspend_late,
+		.restore_early = acpi_subsys_resume_early,
+#endif
+	},
+};
+
+/**
+ * acpi_dev_pm_attach - Prepare device for ACPI power management.
+ * @dev: Device to prepare.
+ *
+ * If @dev has a valid ACPI handle that has a valid struct acpi_device object
+ * attached to it, install a wakeup notification handler for the device and
+ * add it to the general ACPI PM domain.
+ *
+ * This assumes that the @dev's bus type uses generic power management callbacks
+ * (or doesn't use any power management callbacks at all).
+ *
+ * Callers must ensure proper synchronization of this function with power
+ * management callbacks.
+ */
+int acpi_dev_pm_attach(struct device *dev)
+{
+	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+
+	if (!adev)
+		return -ENODEV;
+
+	if (dev->pm_domain)
+		return -EEXIST;
+
+	acpi_add_pm_notifier(adev, acpi_wakeup_device, dev);
+	dev->pm_domain = &acpi_general_pm_domain;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_pm_attach);
+
+/**
+ * acpi_dev_pm_detach - Remove ACPI power management from the device.
+ * @dev: Device to take care of.
+ *
+ * Remove the device from the general ACPI PM domain and remove its wakeup
+ * notifier.
+ *
+ * Callers must ensure proper synchronization of this function with power
+ * management callbacks.
+ */
+void acpi_dev_pm_detach(struct device *dev)
+{
+	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+
+	if (adev && dev->pm_domain == &acpi_general_pm_domain) {
+		dev->pm_domain = NULL;
+		acpi_remove_pm_notifier(adev, acpi_wakeup_device);
+	}
+}
+EXPORT_SYMBOL_GPL(acpi_dev_pm_detach);
Index: linux/include/linux/acpi.h
===================================================================
--- linux.orig/include/linux/acpi.h
+++ linux/include/linux/acpi.h
@@ -434,4 +434,38 @@ acpi_status acpi_os_prepare_sleep(u8 sle
 #define acpi_os_set_prepare_sleep(func, pm1a_ctrl, pm1b_ctrl) do { } while (0)
 #endif
 
+#if defined(CONFIG_ACPI) && defined(CONFIG_PM_RUNTIME)
+int acpi_dev_runtime_suspend(struct device *dev);
+int acpi_dev_runtime_resume(struct device *dev);
+int acpi_subsys_runtime_suspend(struct device *dev);
+int acpi_subsys_runtime_resume(struct device *dev);
+#else
+static inline int acpi_dev_runtime_suspend(struct device *dev) { return 0; }
+static inline int acpi_dev_runtime_resume(struct device *dev) { return 0; }
+static inline int acpi_subsys_runtime_suspend(struct device *dev) { return 0; }
+static inline int acpi_subsys_runtime_resume(struct device *dev) { return 0; }
+#endif
+
+#ifdef CONFIG_ACPI_SLEEP
+int acpi_dev_suspend_late(struct device *dev);
+int acpi_dev_resume_early(struct device *dev);
+int acpi_subsys_prepare(struct device *dev);
+int acpi_subsys_suspend_late(struct device *dev);
+int acpi_subsys_resume_early(struct device *dev);
+#else
+static inline int acpi_dev_suspend_late(struct device *dev) { return 0; }
+static inline int acpi_dev_resume_early(struct device *dev) { return 0; }
+static inline int acpi_subsys_prepare(struct device *dev) { return 0; }
+static inline int acpi_subsys_suspend_late(struct device *dev) { return 0; }
+static inline int acpi_subsys_resume_early(struct device *dev) { return 0; }
+#endif
+
+#if defined(CONFIG_ACPI) && defined(CONFIG_PM)
+int acpi_dev_pm_attach(struct device *dev);
+int acpi_dev_pm_detach(struct device *dev);
+#else
+static inline int acpi_dev_pm_attach(struct device *dev) { return -ENODEV; }
+static inline void acpi_dev_pm_detach(struct device *dev) {}
+#endif
+
 #endif	/*_LINUX_ACPI_H*/

