Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab2JSXMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 19:12:07 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55925 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127Ab2JSXMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 19:12:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] ACPI / PM: Fix device PM kernedoc comments and #ifdefs
Date: Sat, 20 Oct 2012 01:15:50 +0200
Message-ID: <4768434.2rQpsxG0uT@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The kerneldoc comments for acpi_pm_device_sleep_state(),
acpi_pm_device_run_wake(), and acpi_pm_device_sleep_wake() are
outdated and/or don't follow the common kerneldoc patters, so
fix them.

Additionally, notice that acpi_pm_device_run_wake() should be under
CONFIG_PM_RUNTIME rather than under CONFIG_PM_SLEEP, so fix that too.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/sleep.c    |   51 +++++++++++++++++++++---------------------------
 include/acpi/acpi_bus.h |    8 +++++--
 2 files changed, 29 insertions(+), 30 deletions(-)

Index: linux-pm/drivers/acpi/sleep.c
===================================================================
--- linux-pm.orig/drivers/acpi/sleep.c
+++ linux-pm/drivers/acpi/sleep.c
@@ -699,28 +699,21 @@ int acpi_suspend(u32 acpi_state)
 
 #ifdef CONFIG_PM
 /**
- *	acpi_pm_device_sleep_state - return preferred power state of ACPI device
- *		in the system sleep state given by %acpi_target_sleep_state
- *	@dev: device to examine; its driver model wakeup flags control
- *		whether it should be able to wake up the system
- *	@d_min_p: used to store the upper limit of allowed states range
- *	@d_max_in: specify the lowest allowed states
- *	Return value: preferred power state of the device on success, -ENODEV
- *	(ie. if there's no 'struct acpi_device' for @dev) or -EINVAL on failure
+ * acpi_pm_device_sleep_state - Get preferred power state of ACPI device.
+ * @dev: Device whose preferred target power state to return.
+ * @d_min_p: Location to store the upper limit of the allowed states range.
+ * @d_max_in: Deepest low-power state to take into consideration.
+ * Return value: Preferred power state of the device on success, -ENODEV
+ * (if there's no 'struct acpi_device' for @dev) or -EINVAL on failure
  *
- *	Find the lowest power (highest number) ACPI device power state that
- *	device @dev can be in while the system is in the sleep state represented
- *	by %acpi_target_sleep_state.  If @wake is nonzero, the device should be
- *	able to wake up the system from this sleep state.  If @d_min_p is set,
- *	the highest power (lowest number) device power state of @dev allowed
- *	in this system sleep state is stored at the location pointed to by it.
+ * Find the lowest power (highest number) ACPI device power state that the
+ * device can be in while the system is in the sleep state represented
+ * by %acpi_target_sleep_state.  If @d_min_p is set, the highest power (lowest
+ * number) device power state that @dev can be in for the given system sleep
+ * state is stored at the location pointed to by it.
  *
- *	The caller must ensure that @dev is valid before using this function.
- *	The caller is also responsible for figuring out if the device is
- *	supposed to be able to wake up the system and passing this information
- *	via @wake.
+ * The caller must ensure that @dev is valid before using this function.
  */
-
 int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p, int d_max_in)
 {
 	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
@@ -812,14 +805,15 @@ int acpi_pm_device_sleep_state(struct de
 EXPORT_SYMBOL(acpi_pm_device_sleep_state);
 #endif /* CONFIG_PM */
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM_RUNTIME
 /**
- * acpi_pm_device_run_wake - Enable/disable wake-up for given device.
- * @phys_dev: Device to enable/disable the platform to wake-up the system for.
- * @enable: Whether enable or disable the wake-up functionality.
+ * acpi_pm_device_run_wake - Enable/disable remote wakeup for given device.
+ * @phys_dev: Device to enable/disable the platform to wake up.
+ * @enable: Whether enable or disable the wakeup functionality.
  *
  * Find the ACPI device object corresponding to @pci_dev and try to
- * enable/disable the GPE associated with it.
+ * enable/disable the GPE associated with it, so that it can generate
+ * wakeup signals for the device in response to external (remote) events.
  */
 int acpi_pm_device_run_wake(struct device *phys_dev, bool enable)
 {
@@ -847,12 +841,13 @@ int acpi_pm_device_run_wake(struct devic
 	return 0;
 }
 EXPORT_SYMBOL(acpi_pm_device_run_wake);
+#endif /* CONFIG_PM_RUNTIME */
 
+#ifdef CONFIG_PM_SLEEP
 /**
- *	acpi_pm_device_sleep_wake - enable or disable the system wake-up
- *                                  capability of given device
- *	@dev: device to handle
- *	@enable: 'true' - enable, 'false' - disable the wake-up capability
+ * acpi_pm_device_sleep_wake - Enable or disable device to wake up the system.
+ * @dev: Device to enable/desible to wake up the system from sleep states.
+ * @enable: Whether enable or disable @dev to wake up the system.
  */
 int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
 {
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -425,14 +425,18 @@ static inline int acpi_pm_device_sleep_s
 }
 #endif
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM_RUNTIME
 int acpi_pm_device_run_wake(struct device *, bool);
-int acpi_pm_device_sleep_wake(struct device *, bool);
 #else
 static inline int acpi_pm_device_run_wake(struct device *dev, bool enable)
 {
 	return -ENODEV;
 }
+#endif
+
+#ifdef CONFIG_PM_SLEEP
+int acpi_pm_device_sleep_wake(struct device *, bool);
+#else
 static inline int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
 {
 	return -ENODEV;

