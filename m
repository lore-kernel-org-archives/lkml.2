Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2KKMXL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:23:11 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:44305 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825Ab2KKMXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:23:09 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] RFC: pinctrl: grab default handler with bus notifiers
Date: Sun, 11 Nov 2012 13:22:19 +0100
Message-ID: <1352636539-6318-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This makes the pinctrl subsystem auto-grab the pinctrl handle and
set the "default" (PINCTRL_STATE_DEFAULT) state for every device
that is present on the platform or AMBA (PrimeCell) bus right
before probe. This will account for the lion's share of embedded
silicon devcies. The behaviour is achieved using bus notifiers
on the platform and AMBA (PrimeCell) busses.

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

struct pinctrl	*p;

p = devm_pinctrl_get_select_default(&dev);
if (IS_ERR(p)) {
   if (PTR_ERR(p) == -EPROBE_DEFER)
	return -EPROBE_DEFER;
	dev_warn(&dev, "no pinctrl handle\n");
}

The discussion began with the addition of such boilerplate
to the omap4 keypad driver:
http://marc.info/?l=linux-input&m=135091157719300&w=2

Notice that the patch disregards deferral as per above:
if the pin controller returns -EPROBE_DEFER, there is no
way to send that back to the device core using notifiers,
so in cases where the probe ordering is to be controlled,
drivers still need to add the above pin control handling
code. So this mechanism will basically be optimistic, and
to be really sure that you don't have a deferred probe
on your pins, you still need to explicitly request the
pins.

This patch alone does not solve the entire dilemma faced:
whether code should be distributed into the drivers or
if it should be centralized to e.g. a PM domain. But it
solves the immediate issue of the addition of boilerplate
to a lot of drivers that just want to grab the default
state. As mentioned, they can later explicitly retrieve
the handle and set different states, and this could as
well be done by e.g. PM domains as it is only related
to a certain struct device * pointer.

Another solution that was discussed was whether to move
the default pinctrl handle and state grab to the device
core as an optional field in struct device itself, but
I'd like to first propose this less intrusive mechanism.

CC: Felipe Balbi <balbi@ti.com>
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
 Documentation/pinctrl.txt | 24 +++++++++++++++++--
 drivers/pinctrl/core.c    | 60 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index da40efb..b6c27b1 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -972,6 +972,19 @@ pinmux core.
 Pin control requests from drivers
 =================================
 
+When a device driver is about to probe on the platform or AMBA (PrimeCell)
+bus, the pinctrl core will automatically attempt to issue
+pinctrl_get_select_default() on these devices using the bus notification
+mechanism. This way driver writers do not need to add any of the
+boilerplate code of the type found below. However when doing fine-grained
+state selection and not using the "default" state, you may have to do
+some device driver handling of the pinctrl handles and states.
+
+So if you just want to put the pins for a certain platform or AMBA device
+into the default state and be done with it, there is nothing you need to
+do besides providing the proper mapping table. The device core will take
+care of the rest.
+
 Generally it is discouraged to let individual drivers get and enable pin
 control. So if possible, handle the pin control in platform code or some other
 place where you have access to all the affected struct device * pointers. In
@@ -1097,8 +1110,8 @@ situations that can be electrically unpleasant, you will certainly want to
 mux in and bias pins in a certain way before the GPIO subsystems starts to
 deal with them.
 
-The above can be hidden: using pinctrl hogs, the pin control driver may be
-setting up the config and muxing for the pins when it is probing,
+The above can be hidden: using device notifiers, the pinctrl core may be
+setting up the config and muxing for the pins when the device is probing,
 nevertheless orthogonal to the GPIO subsystem.
 
 But there are also situations where it makes sense for the GPIO subsystem
@@ -1144,6 +1157,13 @@ PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-foo", NULL /* group */, "power_func")
 
 This gives the exact same result as the above construction.
 
+This should not be used for any kind of device which is represented in
+the device model. For platform and AMBA (PrimeCell) devices, such as found
+in many SoC:s, the pinctrl core will listen to notifications from these
+buses and attempt to do pinctrl_get_select_default() for these devices
+right before their device drivers are probed, so hogging these will just
+make the model look strange.
+
 
 Runtime pinmuxing
 =================
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 71db586..bdb2300 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -26,6 +26,9 @@
 #include <linux/pinctrl/consumer.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/machine.h>
+#include <linux/notifier.h>
+#include <linux/platform_device.h>
+#include <linux/amba/bus.h>
 #include "core.h"
 #include "devicetree.h"
 #include "pinmux.h"
@@ -684,9 +687,16 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev)
 	if (WARN_ON(!dev))
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * See if somebody else (such as the pinctrl core, using the
+	 * notifiers) has already obtained a handle to the pinctrl for
+	 * this device. In that case, return another pointer to it.
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
@@ -1026,6 +1036,52 @@ void pinctrl_unregister_map(struct pinctrl_map const *map)
 	}
 }
 
+static int pinctrl_device_notify(struct notifier_block *nb,
+				 unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct pinctrl *p;
+
+	switch (action) {
+	case BUS_NOTIFY_BIND_DRIVER:
+		/*
+		 * Hog pins right before a driver is about to be bound to
+		 * the device
+		 */
+		p = devm_pinctrl_get_select_default(dev);
+		if (IS_ERR_OR_NULL(p)) {
+			dev_dbg(dev, "no pinctrl handle or default state\n");
+			return 0;
+		}
+		dev_dbg(dev, "pinctrl core obtained default pinctrl\n");
+		break;
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		break;
+	}
+
+	return 0;
+}
+
+static struct notifier_block pinctrl_device_nb = {
+	.notifier_call = pinctrl_device_notify,
+};
+
+static int __init pinctrl_notifiers_init(void)
+{
+	bus_register_notifier(&platform_bus_type, &pinctrl_device_nb);
+#ifdef CONFIG_ARM_AMBA
+	bus_register_notifier(&amba_bustype, &pinctrl_device_nb);
+#endif
+	return 0;
+}
+
+/*
+ * The AMBA bus registers in the postcore_initcall() so we need to
+ * register our notifiers right after that so we can fetch pins for
+ * e.g. TTY drivers that will be registered in the arch_initcall() next.
+ */
+postcore_initcall_sync(pinctrl_notifiers_init);
+
 #ifdef CONFIG_DEBUG_FS
 
 static int pinctrl_pins_show(struct seq_file *s, void *what)
-- 
1.7.11.3

