Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab2K0JVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:21:47 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33930 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544Ab2K0JVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:21:43 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 2/4] Input: RMI4 - move sensor driver and F01 handler into the core
Date: Tue, 27 Nov 2012 01:21:36 -0800
Message-Id: <1354008098-26346-2-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354008098-26346-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1354008098-26346-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in having the sensor driver and F01 handler separate
from the RMI core since it is not useful without them and having them
all together simplifies initialization among other things.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/Kconfig      | 23 ++++++-----------------
 drivers/input/rmi4/Makefile     | 10 +++++++---
 drivers/input/rmi4/rmi_bus.c    | 41 ++++++++++++++++++++++++++++++++---------
 drivers/input/rmi4/rmi_driver.c | 36 ++++++++++++++----------------------
 drivers/input/rmi4/rmi_driver.h |  6 ++++++
 drivers/input/rmi4/rmi_f01.c    | 22 +++-------------------
 6 files changed, 68 insertions(+), 70 deletions(-)

diff --git a/drivers/input/rmi4/Kconfig b/drivers/input/rmi4/Kconfig
index 41cbbee..d0c7b6e 100644
--- a/drivers/input/rmi4/Kconfig
+++ b/drivers/input/rmi4/Kconfig
@@ -1,8 +1,8 @@
 #
 # RMI4 configuration
 #
-config RMI4_BUS
-	bool "Synaptics RMI4 bus support"
+config RMI4_CORE
+	tristate "Synaptics RMI4 bus support"
 	help
 	  Say Y here if you want to support the Synaptics RMI4 bus.  This is
 	  required for all RMI4 device support.
@@ -13,7 +13,7 @@ config RMI4_BUS
 
 config RMI4_DEBUG
 	bool "RMI4 Debugging"
-	depends on RMI4_BUS
+	depends on RMI4_CORE
 	select DEBUG_FS
 	help
 	  Say Y here to enable debug feature in the RMI4 driver.
@@ -26,8 +26,8 @@ config RMI4_DEBUG
 	  If unsure, say N.
 
 config RMI4_I2C
-	bool "RMI4 I2C Support"
-	depends on RMI4_BUS && I2C
+	tristate "RMI4 I2C Support"
+	depends on RMI4_CORE && I2C
 	help
 	  Say Y here if you want to support RMI4 devices connected to an I2C
 	  bus.
@@ -36,20 +36,9 @@ config RMI4_I2C
 
 	  This feature is not currently available as a loadable module.
 
-config RMI4_GENERIC
-	bool "RMI4 Generic driver"
-	depends on RMI4_BUS
-	help
-	  Say Y here if you want to support generic RMI4 devices.
-
-	  This is pretty much required if you want to do anything useful with
-	  your RMI device.
-
-	  This feature is not currently available as a loadable module.
-
 config RMI4_F11
 	tristate "RMI4 Function 11 (2D pointing)"
-	depends on RMI4_BUS && RMI4_GENERIC
+	depends on RMI4_CORE
 	help
 	  Say Y here if you want to add support for RMI4 function 11.
 
diff --git a/drivers/input/rmi4/Makefile b/drivers/input/rmi4/Makefile
index 8882c3d..5c6bad5 100644
--- a/drivers/input/rmi4/Makefile
+++ b/drivers/input/rmi4/Makefile
@@ -1,8 +1,12 @@
-obj-$(CONFIG_RMI4_BUS) += rmi_bus.o
-obj-$(CONFIG_RMI4_I2C) += rmi_i2c.o
-obj-$(CONFIG_RMI4_GENERIC) += rmi_driver.o rmi_f01.o
+obj-$(CONFIG_RMI4_CORE) += rmi_core.o
+rmi_core-y := rmi_bus.o rmi_driver.o rmi_f01.o
+
+# Function drivers
 obj-$(CONFIG_RMI4_F11) += rmi_f11.o
 
+# Transports
+obj-$(CONFIG_RMI4_I2C) += rmi_i2c.o
+
 ccflags-$(CONFIG_RMI4_DEBUG) += -DDEBUG
 
 ifeq ($(KERNELRELEASE),)
diff --git a/drivers/input/rmi4/rmi_bus.c b/drivers/input/rmi4/rmi_bus.c
index a912349..47cf0d5 100644
--- a/drivers/input/rmi4/rmi_bus.c
+++ b/drivers/input/rmi4/rmi_bus.c
@@ -206,6 +206,27 @@ static int __init rmi_bus_init(void)
 
 	mutex_init(&rmi_bus_mutex);
 
+	error = bus_register(&rmi_bus_type);
+	if (error) {
+		pr_err("%s: error registering the RMI bus: %d\n",
+			__func__, error);
+		return error;
+	}
+
+	error = rmi_register_f01_handler();
+	if (error) {
+		pr_err("%s: error registering the RMI F01 handler: %d\n",
+			__func__, error);
+		goto err_unregister_bus;
+	}
+
+	error = rmi_register_sensor_driver();
+	if (error) {
+		pr_err("%s: error registering the RMI sensor driver: %d\n",
+			__func__, error);
+		goto err_unregister_f01;
+	}
+
 	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
 		rmi_debugfs_root = debugfs_create_dir(rmi_bus_type.name, NULL);
 		if (!rmi_debugfs_root)
@@ -218,24 +239,26 @@ static int __init rmi_bus_init(void)
 		}
 	}
 
-	error = bus_register(&rmi_bus_type);
-	if (error < 0) {
-		pr_err("%s: error registering the RMI bus: %d\n", __func__,
-		       error);
-		return error;
-	}
-	pr_debug("%s: successfully registered RMI bus.\n", __func__);
-
 	return 0;
+
+err_unregister_f01:
+	rmi_unregister_f01_handler();
+err_unregister_bus:
+	bus_unregister(&rmi_bus_type);
+	return error;
 }
 
 static void __exit rmi_bus_exit(void)
 {
-	/* We should only ever get here if all drivers are unloaded, so
+	/*
+	 * We should only ever get here if all drivers are unloaded, so
 	 * all we have to do at this point is unregister ourselves.
 	 */
 	if (IS_ENABLED(CONFIG_RMI4_DEBUG) && rmi_debugfs_root)
 		debugfs_remove(rmi_debugfs_root);
+
+	rmi_unregister_sensor_driver();
+	rmi_unregister_f01_handler();
 	bus_unregister(&rmi_bus_type);
 }
 
diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
index e8a4b52..6b6ac0c 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -1608,7 +1608,7 @@ static int __devinit rmi_driver_probe(struct device *dev)
 static UNIVERSAL_DEV_PM_OPS(rmi_driver_pm, rmi_driver_suspend,
 			    rmi_driver_resume, NULL);
 
-static struct rmi_driver sensor_driver = {
+static struct rmi_driver rmi_sensor_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
 		.name = "rmi_generic",
@@ -1624,38 +1624,30 @@ static struct rmi_driver sensor_driver = {
 	.set_input_params = rmi_driver_set_input_params,
 };
 
-static int __init rmi_driver_init(void)
+int __init rmi_register_sensor_driver(void)
 {
-	int retval;
+	int error;
 
-	retval = driver_register(&sensor_driver.driver);
-	if (retval) {
+	error = driver_register(&rmi_sensor_driver.driver);
+	if (error) {
 		pr_err("%s: driver register failed, code=%d.\n", __func__,
-		       retval);
-		return retval;
+		       error);
+		return error;
 	}
 
 	/* Ask the bus to let us know when drivers are bound to devices. */
-	retval = bus_register_notifier(&rmi_bus_type, &rmi_bus_notifier);
-	if (retval) {
+	error = bus_register_notifier(&rmi_bus_type, &rmi_bus_notifier);
+	if (error) {
 		pr_err("%s: failed to register bus notifier, code=%d.\n",
-		       __func__, retval);
-		return retval;
+		       __func__, error);
+		return error;
 	}
 
-	return retval;
+	return 0;
 }
 
-static void __exit rmi_driver_exit(void)
+void __exit rmi_unregister_sensor_driver(void)
 {
 	bus_unregister_notifier(&rmi_bus_type, &rmi_bus_notifier);
-	driver_unregister(&sensor_driver.driver);
+	driver_unregister(&rmi_sensor_driver.driver);
 }
-
-module_init(rmi_driver_init);
-module_exit(rmi_driver_exit);
-
-MODULE_AUTHOR("Christopher Heiny <cheiny@synaptics.com");
-MODULE_DESCRIPTION("RMI generic driver");
-MODULE_LICENSE("GPL");
-MODULE_VERSION(RMI_DRIVER_VERSION);
diff --git a/drivers/input/rmi4/rmi_driver.h b/drivers/input/rmi4/rmi_driver.h
index 1fc4676..e71ffdc 100644
--- a/drivers/input/rmi4/rmi_driver.h
+++ b/drivers/input/rmi4/rmi_driver.h
@@ -136,4 +136,10 @@ extern void rmi4_fw_update(struct rmi_device *rmi_dev,
 #define rmi4_fw_update(rmi_dev, f01_pdt, f34_pdt)
 #endif
 
+int rmi_register_sensor_driver(void);
+void rmi_unregister_sensor_driver(void);
+
+int rmi_register_f01_handler(void);
+void rmi_unregister_f01_handler(void);
+
 #endif
diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
index 5e6bef6..41ac5f0 100644
--- a/drivers/input/rmi4/rmi_f01.c
+++ b/drivers/input/rmi4/rmi_f01.c
@@ -1265,28 +1265,12 @@ static struct rmi_function_handler function_handler = {
 #endif  /* CONFIG_PM */
 };
 
-static int __init rmi_f01_module_init(void)
+int __init rmi_register_f01_handler(void)
 {
-	int error;
-
-	error = driver_register(&function_handler.driver);
-	if (error < 0) {
-		pr_err("%s: register failed!\n", __func__);
-		return error;
-	}
-
-	return 0;
+	return driver_register(&function_handler.driver);
 }
 
-static void __exit rmi_f01_module_exit(void)
+void __exit rmi_unregister_f01_handler(void)
 {
 	driver_unregister(&function_handler.driver);
 }
-
-module_init(rmi_f01_module_init);
-module_exit(rmi_f01_module_exit);
-
-MODULE_AUTHOR("Christopher Heiny <cheiny@synaptics.com>");
-MODULE_DESCRIPTION("RMI F01 module");
-MODULE_LICENSE("GPL");
-MODULE_VERSION(RMI_DRIVER_VERSION);
-- 
1.7.11.7

