Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab2J2JLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:11:47 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42668 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757712Ab2J2JKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:10:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, Huang Ying <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 3/7] ACPI / PM: Move runtime remote wakeup setup routine to device_pm.c
Date: Mon, 29 Oct 2012 10:10 +0100
Message-ID: <3012440.C3kk0QhS7O@vostro.rjw.lan>
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

The ACPI function for setting up devices to do runtime remote
wakeup is now located in drivers/acpi/sleep.c, but
drivers/acpi/device_pm.c is a more logical place for it, so move it
there.

No functional changes should result from this modification.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   39 +++++++++++++++++++++++++++++++++++++++
 drivers/acpi/sleep.c     |   39 ---------------------------------------
 2 files changed, 39 insertions(+), 39 deletions(-)

Index: linux/drivers/acpi/device_pm.c
===================================================================
--- linux.orig/drivers/acpi/device_pm.c
+++ linux/drivers/acpi/device_pm.c
@@ -26,6 +26,7 @@
 #include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/pm_qos.h>
+#include <linux/pm_runtime.h>
 
 #include <acpi/acpi.h>
 #include <acpi/acpi_bus.h>
@@ -196,3 +197,41 @@ int acpi_device_power_state(struct devic
 	return d_max;
 }
 EXPORT_SYMBOL_GPL(acpi_device_power_state);
+
+#ifdef CONFIG_PM_RUNTIME
+/**
+ * acpi_pm_device_run_wake - Enable/disable remote wakeup for given device.
+ * @phys_dev: Device to enable/disable the platform to wake up.
+ * @enable: Whether to enable or disable the wakeup functionality.
+ *
+ * Find the ACPI device object corresponding to @phys_dev and try to
+ * enable/disable the GPE associated with it, so that it can generate
+ * wakeup signals for the device in response to external (remote) events.
+ */
+int acpi_pm_device_run_wake(struct device *phys_dev, bool enable)
+{
+	struct acpi_device *dev;
+	acpi_handle handle;
+
+	if (!device_run_wake(phys_dev))
+		return -EINVAL;
+
+	handle = DEVICE_ACPI_HANDLE(phys_dev);
+	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &dev))) {
+		dev_dbg(phys_dev, "ACPI handle has no context in %s!\n",
+			__func__);
+		return -ENODEV;
+	}
+
+	if (enable) {
+		acpi_enable_wakeup_device_power(dev, ACPI_STATE_S0);
+		acpi_enable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
+	} else {
+		acpi_disable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
+		acpi_disable_wakeup_device_power(dev);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(acpi_pm_device_run_wake);
+#endif /* CONFIG_PM_RUNTIME */
Index: linux/drivers/acpi/sleep.c
===================================================================
--- linux.orig/drivers/acpi/sleep.c
+++ linux/drivers/acpi/sleep.c
@@ -18,7 +18,6 @@
 #include <linux/reboot.h>
 #include <linux/acpi.h>
 #include <linux/module.h>
-#include <linux/pm_runtime.h>
 
 #include <asm/io.h>
 
@@ -723,44 +722,6 @@ int acpi_pm_device_sleep_state(struct de
 EXPORT_SYMBOL(acpi_pm_device_sleep_state);
 #endif /* CONFIG_PM */
 
-#ifdef CONFIG_PM_RUNTIME
-/**
- * acpi_pm_device_run_wake - Enable/disable remote wakeup for given device.
- * @phys_dev: Device to enable/disable the platform to wake up.
- * @enable: Whether to enable or disable the wakeup functionality.
- *
- * Find the ACPI device object corresponding to @phys_dev and try to
- * enable/disable the GPE associated with it, so that it can generate
- * wakeup signals for the device in response to external (remote) events.
- */
-int acpi_pm_device_run_wake(struct device *phys_dev, bool enable)
-{
-	struct acpi_device *dev;
-	acpi_handle handle;
-
-	if (!device_run_wake(phys_dev))
-		return -EINVAL;
-
-	handle = DEVICE_ACPI_HANDLE(phys_dev);
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &dev))) {
-		dev_dbg(phys_dev, "ACPI handle has no context in %s!\n",
-			__func__);
-		return -ENODEV;
-	}
-
-	if (enable) {
-		acpi_enable_wakeup_device_power(dev, ACPI_STATE_S0);
-		acpi_enable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
-	} else {
-		acpi_disable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
-		acpi_disable_wakeup_device_power(dev);
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(acpi_pm_device_run_wake);
-#endif /* CONFIG_PM_RUNTIME */
-
 #ifdef CONFIG_PM_SLEEP
 /**
  * acpi_pm_device_sleep_wake - Enable or disable device to wake up the system.

