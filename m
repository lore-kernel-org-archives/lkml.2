Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab0CSWlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 18:41:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55208 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab0CSWlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 18:41:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org, Jean Delvare <khali@linux-fr.org>
Subject: [PATCH] i2c: Fix bus-level power management callbacks
Date: Fri, 19 Mar 2010 23:44:08 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linux I2C <linux-i2c@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>
References: <201003132204.30905.rjw@sisk.pl>
In-Reply-To: <201003132204.30905.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003192344.09000.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 March 2010, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> There are three issues with the i2c's power management callbacks at
> the moment.  First, they don't include any hibernate callbacks,
> although they should at least include the .restore() callback
> (there's no guarantee that the driver will be in memory before
> loading the image kernel and we must restore the pre-hibernation
> state of the device).  Second, the "legacy" callbacks are not going
> to be invoked by the PM core since the bus type's pm object is not
> NULL.  Finally, the system power transition (ie. suspend/resume)
> callbacks don't check if the device hasn't been already suspended
> at run time, in which case they should skip suspending it and
> handle it in a special way during resume.  Also, it looks like the
> i2c bus type itself doesn't need any power management handling beyond
> that provided by the generic subsystem-level PM callbacks.
> 
> For these reasons, remove the power management callbacks defined by
> the i2c bus type and make it use the generic subsystem-level power
> management callbacks.

I assume the lack of responses except for the Alan's one means the patch
wasn't correct, so below is one that I think is better.  It fixes all of the
issues described above without breaking backwards compatibility.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: i2c: Fix bus-level power management callbacks

There are three issues with the i2c bus type's power management
callbacks at the moment.  First, they don't include any hibernate
callbacks, although they should at least include the .restore()
callback (there's no guarantee that the driver will be present in
memory before loading the image kernel and we must restore the
pre-hibernation state of the device).  Second, the "legacy"
callbacks are not going to be invoked by the PM core since the bus
type's pm object is not NULL.  Finally, the system sleep PM
(ie. suspend/resume) callbacks don't check if the device has been
already suspended at run time, in which case they should skip
suspending it.  Also, it looks like the i2c bus type can use the
generic subsystem-level runtime PM callbacks.

For these reasons, rework the system sleep PM callbacks provided by
the i2c bus type to handle hibernation correctly and to invoke the
"legacy" callbacks for drivers that provide them.  In addition to
that make the i2c bus type use the generic subsystem-level runtime
PM callbacks.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/i2c/i2c-core.c     |  168 ++++++++++++++++++++++++++-------------------
 include/linux/pm_runtime.h |    7 +
 2 files changed, 105 insertions(+), 70 deletions(-)

Index: linux-2.6/drivers/i2c/i2c-core.c
===================================================================
--- linux-2.6.orig/drivers/i2c/i2c-core.c
+++ linux-2.6/drivers/i2c/i2c-core.c
@@ -156,107 +156,131 @@ static void i2c_device_shutdown(struct d
 		driver->shutdown(client);
 }
 
-#ifdef CONFIG_SUSPEND
-static int i2c_device_pm_suspend(struct device *dev)
+static int i2c_legacy_suspend(struct device *dev, pm_message_t mesg)
 {
-	const struct dev_pm_ops *pm;
+	struct i2c_client *client = i2c_verify_client(dev);
+	struct i2c_driver *driver;
 
-	if (!dev->driver)
+	if (!client || !dev->driver)
 		return 0;
-	pm = dev->driver->pm;
-	if (!pm || !pm->suspend)
+	driver = to_i2c_driver(dev->driver);
+	if (!driver->suspend)
 		return 0;
-	return pm->suspend(dev);
+	return driver->suspend(client, mesg);
 }
 
-static int i2c_device_pm_resume(struct device *dev)
+static int i2c_legacy_resume(struct device *dev)
 {
-	const struct dev_pm_ops *pm;
+	struct i2c_client *client = i2c_verify_client(dev);
+	struct i2c_driver *driver;
 
-	if (!dev->driver)
+	if (!client || !dev->driver)
 		return 0;
-	pm = dev->driver->pm;
-	if (!pm || !pm->resume)
+	driver = to_i2c_driver(dev->driver);
+	if (!driver->resume)
 		return 0;
-	return pm->resume(dev);
+	return driver->resume(client);
 }
-#else
-#define i2c_device_pm_suspend	NULL
-#define i2c_device_pm_resume	NULL
-#endif
 
-#ifdef CONFIG_PM_RUNTIME
-static int i2c_device_runtime_suspend(struct device *dev)
+#ifdef CONFIG_PM_SLEEP
+static int i2c_device_pm_suspend(struct device *dev)
 {
-	const struct dev_pm_ops *pm;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
-	if (!dev->driver)
-		return 0;
-	pm = dev->driver->pm;
-	if (!pm || !pm->runtime_suspend)
+	if (pm_runtime_suspended(dev))
 		return 0;
-	return pm->runtime_suspend(dev);
-}
 
-static int i2c_device_runtime_resume(struct device *dev)
-{
-	const struct dev_pm_ops *pm;
+	if (pm)
+		return pm->suspend ? pm->suspend(dev) : 0;
 
-	if (!dev->driver)
-		return 0;
-	pm = dev->driver->pm;
-	if (!pm || !pm->runtime_resume)
-		return 0;
-	return pm->runtime_resume(dev);
+	return i2c_legacy_suspend(dev, PMSG_SUSPEND);
 }
 
-static int i2c_device_runtime_idle(struct device *dev)
+static int i2c_device_pm_resume(struct device *dev)
 {
-	const struct dev_pm_ops *pm = NULL;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int ret;
 
-	if (dev->driver)
-		pm = dev->driver->pm;
-	if (pm && pm->runtime_idle) {
-		ret = pm->runtime_idle(dev);
-		if (ret)
-			return ret;
+	if (pm)
+		ret = pm->resume ? pm->resume(dev) : 0;
+	else
+		ret = i2c_legacy_resume(dev);
+
+	if (!ret) {
+		pm_runtime_disable(dev);
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
 	}
 
-	return pm_runtime_suspend(dev);
-}
-#else
-#define i2c_device_runtime_suspend	NULL
-#define i2c_device_runtime_resume	NULL
-#define i2c_device_runtime_idle		NULL
-#endif
+	return ret;
+}
 
-static int i2c_device_suspend(struct device *dev, pm_message_t mesg)
+static int i2c_device_pm_freeze(struct device *dev)
 {
-	struct i2c_client *client = i2c_verify_client(dev);
-	struct i2c_driver *driver;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
-	if (!client || !dev->driver)
+	if (pm_runtime_suspended(dev))
 		return 0;
-	driver = to_i2c_driver(dev->driver);
-	if (!driver->suspend)
-		return 0;
-	return driver->suspend(client, mesg);
+
+	if (pm)
+		return pm->freeze ? pm->freeze(dev) : 0;
+
+	return i2c_legacy_suspend(dev, PMSG_FREEZE);
 }
 
-static int i2c_device_resume(struct device *dev)
+static int i2c_device_pm_thaw(struct device *dev)
 {
-	struct i2c_client *client = i2c_verify_client(dev);
-	struct i2c_driver *driver;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
-	if (!client || !dev->driver)
+	if (pm_runtime_suspended(dev))
 		return 0;
-	driver = to_i2c_driver(dev->driver);
-	if (!driver->resume)
+
+	if (pm)
+		return pm->thaw ? pm->thaw(dev) : 0;
+
+	return i2c_legacy_resume(dev);
+}
+
+static int i2c_device_pm_poweroff(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+
+	if (pm_runtime_suspended(dev))
 		return 0;
-	return driver->resume(client);
+
+	if (pm)
+		return pm->poweroff ? pm->poweroff(dev) : 0;
+
+	return i2c_legacy_suspend(dev, PMSG_HIBERNATE);
 }
 
+static int i2c_device_pm_restore(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	int ret;
+
+	if (pm)
+		ret = pm->restore ? pm->restore(dev) : 0;
+	else
+		ret = i2c_legacy_resume(dev);
+
+	if (!ret) {
+		pm_runtime_disable(dev);
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return ret;
+}
+#else /* !CONFIG_PM_SLEEP */
+#define i2c_device_pm_suspend	NULL
+#define i2c_device_pm_resume	NULL
+#define i2c_device_pm_freeze	NULL
+#define i2c_device_pm_thaw	NULL
+#define i2c_device_pm_poweroff	NULL
+#define i2c_device_pm_restore	NULL
+#endif /* !CONFIG_PM_SLEEP */
+
 static void i2c_client_dev_release(struct device *dev)
 {
 	kfree(to_i2c_client(dev));
@@ -298,9 +322,15 @@ static const struct attribute_group *i2c
 static const struct dev_pm_ops i2c_device_pm_ops = {
 	.suspend = i2c_device_pm_suspend,
 	.resume = i2c_device_pm_resume,
-	.runtime_suspend = i2c_device_runtime_suspend,
-	.runtime_resume = i2c_device_runtime_resume,
-	.runtime_idle = i2c_device_runtime_idle,
+	.freeze = i2c_device_pm_freeze,
+	.thaw = i2c_device_pm_thaw,
+	.poweroff = i2c_device_pm_poweroff,
+	.restore = i2c_device_pm_restore,
+	SET_RUNTIME_PM_OPS(
+		pm_generic_runtime_suspend,
+		pm_generic_runtime_resume,
+		pm_generic_runtime_idle
+	)
 };
 
 struct bus_type i2c_bus_type = {
@@ -309,8 +339,6 @@ struct bus_type i2c_bus_type = {
 	.probe		= i2c_device_probe,
 	.remove		= i2c_device_remove,
 	.shutdown	= i2c_device_shutdown,
-	.suspend	= i2c_device_suspend,
-	.resume		= i2c_device_resume,
 	.pm		= &i2c_device_pm_ops,
 };
 EXPORT_SYMBOL_GPL(i2c_bus_type);
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- linux-2.6.orig/include/linux/pm_runtime.h
+++ linux-2.6/include/linux/pm_runtime.h
@@ -30,6 +30,9 @@ extern void pm_runtime_enable(struct dev
 extern void __pm_runtime_disable(struct device *dev, bool check_resume);
 extern void pm_runtime_allow(struct device *dev);
 extern void pm_runtime_forbid(struct device *dev);
+extern int pm_generic_runtime_idle(struct device *dev);
+extern int pm_generic_runtime_suspend(struct device *dev);
+extern int pm_generic_runtime_resume(struct device *dev);
 
 static inline bool pm_children_suspended(struct device *dev)
 {
@@ -96,6 +99,10 @@ static inline bool device_run_wake(struc
 static inline void device_set_run_wake(struct device *dev, bool enable) {}
 static inline bool pm_runtime_suspended(struct device *dev) { return false; }
 
+static inline int pm_generic_runtime_idle(struct device *dev) { return 0; }
+static inline int pm_generic_runtime_suspend(struct device *dev) { return 0; }
+static inline int pm_generic_runtime_resume(struct device *dev) { return 0; }
+
 #endif /* !CONFIG_PM_RUNTIME */
 
 static inline int pm_runtime_get(struct device *dev)
