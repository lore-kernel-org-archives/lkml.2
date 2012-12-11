Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2LKNli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:41:38 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:37817 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104Ab2LKNlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:41:36 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] drivers/pinctrl: grab default handles from device core
Date: Tue, 11 Dec 2012 14:40:46 +0100
Message-ID: <1355233246-16694-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This makes the device core auto-grab the pinctrl handle and set
the "default" (PINCTRL_STATE_DEFAULT) state for every device
that is present in the device model right before probe. This will
account for the lion's share of embedded silicon devcies.

A modification of the semantics for pinctrl_get() is also done:
previously if the pinctrl handle for a certain device was already
taken, the pinctrl core would return an error. Now, since the
core may have already default-grabbed the handle and set its
state to "default", if the handle was already taken, this will
be disregarded and the located, previously instanitated handle
will be returned to the caller.

This way all code in drivers explicitly requesting their pinctrl
handlers will still be functional, and drivers that want to
explicitly retrieve and switch their handles can still do that.
But if the desired functionality is just boilerplate of this
type in the probe() function:

struct pinctrl  *p;

p = devm_pinctrl_get_select_default(&dev);
if (IS_ERR(p)) {
   if (PTR_ERR(p) == -EPROBE_DEFER)
        return -EPROBE_DEFER;
        dev_warn(&dev, "no pinctrl handle\n");
}

The discussion began with the addition of such boilerplate
to the omap4 keypad driver:
http://marc.info/?l=linux-input&m=135091157719300&w=2

A previous approach using notifiers was discussed:
http://marc.info/?l=linux-kernel&m=135263661110528&w=2
This failed because it could not handle deferred probes.

This patch alone does not solve the entire dilemma faced:
whether code should be distributed into the drivers or
if it should be centralized to e.g. a PM domain. But it
solves the immediate issue of the addition of boilerplate
to a lot of drivers that just want to grab the default
state. As mentioned, they can later explicitly retrieve
the handle and set different states, and this could as
well be done by e.g. PM domains as it is only related
to a certain struct device * pointer.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Mitch Bradley <wmb@firmworks.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Rickard Andersson <rickard.andersson@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt       | 24 +++++++++++++--
 drivers/base/Makefile           |  1 +
 drivers/base/dd.c               |  7 +++++
 drivers/base/pinctrl.c          | 66 +++++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/core.c          | 11 +++++--
 include/linux/device.h          |  7 +++++
 include/linux/pinctrl/devinfo.h | 45 ++++++++++++++++++++++++++++
 7 files changed, 156 insertions(+), 5 deletions(-)
 create mode 100644 drivers/base/pinctrl.c
 create mode 100644 include/linux/pinctrl/devinfo.h

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index da40efb..68836e5 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -972,6 +972,18 @@ pinmux core.
 Pin control requests from drivers
 =================================
 
+When a device driver is about to probe the device core will automatically
+attempt to issue pinctrl_get_select_default() on these devices.
+This way driver writers do not need to add any of the boilerplate code
+of the type found below. However when doing fine-grained state selection
+and not using the "default" state, you may have to do some device driver
+handling of the pinctrl handles and states.
+
+So if you just want to put the pins for a certain device into the default
+state and be done with it, there is nothing you need to do besides
+providing the proper mapping table. The device core will take care of
+the rest.
+
 Generally it is discouraged to let individual drivers get and enable pin
 control. So if possible, handle the pin control in platform code or some other
 place where you have access to all the affected struct device * pointers. In
@@ -1097,9 +1109,9 @@ situations that can be electrically unpleasant, you will certainly want to
 mux in and bias pins in a certain way before the GPIO subsystems starts to
 deal with them.
 
-The above can be hidden: using pinctrl hogs, the pin control driver may be
-setting up the config and muxing for the pins when it is probing,
-nevertheless orthogonal to the GPIO subsystem.
+The above can be hidden: using the device core, the pinctrl core may be
+setting up the config and muxing for the pins right before the device is
+probing, nevertheless orthogonal to the GPIO subsystem.
 
 But there are also situations where it makes sense for the GPIO subsystem
 to communicate directly with with the pinctrl subsystem, using the latter
@@ -1144,6 +1156,12 @@ PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-foo", NULL /* group */, "power_func")
 
 This gives the exact same result as the above construction.
 
+This should not be used for any kind of device which is represented in
+the device model, as the pinctrl core will attempt to do the equal of
+pinctrl_get_select_default() for these devices right before their device
+drivers are probed, so hogging these will just make the model look
+strange. Instead put in proper map entries.
+
 
 Runtime pinmuxing
 =================
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 5aa2d70..4e22ce3 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -21,6 +21,7 @@ endif
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 obj-$(CONFIG_REGMAP)	+= regmap/
 obj-$(CONFIG_SOC_BUS) += soc.o
+obj-$(CONFIG_PINCTRL) += pinctrl.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index e3bbed8..65631015 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -24,6 +24,7 @@
 #include <linux/wait.h>
 #include <linux/async.h>
 #include <linux/pm_runtime.h>
+#include <linux/pinctrl/devinfo.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -269,6 +270,12 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	WARN_ON(!list_empty(&dev->devres_head));
 
 	dev->driver = drv;
+
+	/* If using pinctrl, bind pins now before probing */
+	ret = pinctrl_bind_pins(dev);
+	if (ret)
+		goto probe_failed;
+
 	if (driver_sysfs_add(dev)) {
 		printk(KERN_ERR "%s: driver_sysfs_add(%s) failed\n",
 			__func__, dev_name(dev));
diff --git a/drivers/base/pinctrl.c b/drivers/base/pinctrl.c
new file mode 100644
index 0000000..c38a428
--- /dev/null
+++ b/drivers/base/pinctrl.c
@@ -0,0 +1,66 @@
+/*
+ * Driver core interface to the pinctrl subsystem.
+ *
+ * Copyright (C) 2012 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * Based on bits of regulator core, gpio core and clk core
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/device.h>
+#include <linux/pinctrl/devinfo.h>
+#include <linux/pinctrl/consumer.h>
+
+/**
+ * pinctrl_bind_pins() - called by the device core before probe
+ * @dev: the device that is just about to probe
+ */
+int pinctrl_bind_pins(struct device *dev)
+{
+	struct dev_pin_info *dpi = &dev->pins;
+	int ret;
+
+	/*
+	 * Check if we already have a pinctrl handle, as we may arrive here
+	 * after a deferral in the state selection below
+	 */
+	if (!dpi->p) {
+		dpi->p = devm_pinctrl_get(dev);
+		if (IS_ERR_OR_NULL(dpi->p)) {
+			int ret = PTR_ERR(dpi->p);
+
+			dev_dbg(dev, "no pinctrl handle\n");
+			/* Only return deferrals */
+			if (ret == -EPROBE_DEFER)
+				return ret;
+			return 0;
+		}
+	}
+
+	/*
+	 * We may have looked up the state earlier as well.
+	 */
+	if (!dpi->default_state) {
+		dpi->default_state = pinctrl_lookup_state(dpi->p,
+						PINCTRL_STATE_DEFAULT);
+		if (IS_ERR(dpi->default_state)) {
+			dev_dbg(dev, "no default pinctrl state\n");
+			return 0;
+		}
+	}
+
+	ret = pinctrl_select_state(dpi->p, dpi->default_state);
+	if (ret) {
+		dev_dbg(dev, "failed to activate default pinctrl state\n");
+
+		/* Only return deferrals */
+		if (ret == -EPROBE_DEFER)
+			return ret;
+		return 0;
+	}
+
+	return 0;
+}
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 55d67bf..44c9623 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -716,9 +716,16 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev)
 	if (WARN_ON(!dev))
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * See if somebody else (such as the device core) has already
+	 * obtained a handle to the pinctrl for this device. In that case,
+	 * return another pointer to it.
+	 */
 	p = find_pinctrl(dev);
-	if (p != NULL)
-		return ERR_PTR(-EBUSY);
+	if (p != NULL) {
+		dev_dbg(dev, "obtain a copy of previously claimed pinctrl\n");
+		return p;
+	}
 
 	return create_pinctrl(dev);
 }
diff --git a/include/linux/device.h b/include/linux/device.h
index 86ef6ab..dc399ab 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -21,6 +21,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
+#include <linux/pinctrl/devinfo.h>
 #include <linux/pm.h>
 #include <linux/atomic.h>
 #include <linux/ratelimit.h>
@@ -605,6 +606,8 @@ struct device_dma_parameters {
  * @pm_domain:	Provide callbacks that are executed during system suspend,
  * 		hibernation, system resume and during runtime PM transitions
  * 		along with subsystem-level and driver-level callbacks.
+ * @pins:	For device pin management.
+ *		See Documentation/pinctrl.txt for details.
  * @numa_node:	NUMA node this device is close to.
  * @dma_mask:	Dma mask (if dma'ble device).
  * @coherent_dma_mask: Like dma_mask, but for alloc_coherent mapping as not all
@@ -656,6 +659,10 @@ struct device {
 	struct dev_pm_info	power;
 	struct dev_pm_domain	*pm_domain;
 
+#ifdef CONFIG_PINCTRL
+	struct dev_pin_info	pins;
+#endif
+
 #ifdef CONFIG_NUMA
 	int		numa_node;	/* NUMA node this device is close to */
 #endif
diff --git a/include/linux/pinctrl/devinfo.h b/include/linux/pinctrl/devinfo.h
new file mode 100644
index 0000000..6e5f8a9
--- /dev/null
+++ b/include/linux/pinctrl/devinfo.h
@@ -0,0 +1,45 @@
+/*
+ * Per-device information from the pin control system.
+ * This is the stuff that get included into the device
+ * core.
+ *
+ * Copyright (C) 2012 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * This interface is used in the core to keep track of pins.
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef PINCTRL_DEVINFO_H
+#define PINCTRL_DEVINFO_H
+
+#ifdef CONFIG_PINCTRL
+
+/* The device core acts as a consumer toward pinctrl */
+#include <linux/pinctrl/consumer.h>
+
+/**
+ * struct dev_pin_info - pin state container for devices
+ * @p: pinctrl handle for the containing device
+ * @default_state: the default state for the handle, if found
+ */
+struct dev_pin_info {
+	struct pinctrl *p;
+	struct pinctrl_state *default_state;
+};
+
+extern int pinctrl_bind_pins(struct device *dev);
+
+#else
+
+/* Stubs if we're not using pinctrl */
+
+static inline int pinctrl_bind_pins(struct device *dev)
+{
+	return 0;
+}
+
+#endif /* CONFIG_PINCTRL */
+#endif /* PINCTRL_DEVINFO_H */
-- 
1.7.11.3

