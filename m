Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab1EJXkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:40:10 -0400
Received: from mail.df.lth.se ([194.47.250.12]:58746 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab1EJXkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:40:07 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] drivers: create a pinmux subsystem v2
Date: Wed, 11 May 2011 01:39:43 +0200
Message-Id: <1305070783-23193-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This creates a subsystem for handling of pinmux devices. These are
devices that enable and disable groups of pins on primarily PGA and
BGA type of chip packages and common in embedded systems.

This is being done to depopulate the arch/arm/* directory of such
custom drivers and try to abstract the infrastructure they all
need. See the Documentation/pinmux.txt file that is part of this
patch for more details.

Cc: Stephen Warren <swarren@nvidia.com>
Cc: Joe Perches <joe@perches.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Various minor fixes from Joe's and Stephens review comments
- Added a pinmux_config() that can invoke custom configuration
  with arbitrary data passed in or out to/from the pinmux driver
---
 Documentation/ABI/testing/sysfs-class-pinmux |   11 +
 Documentation/pinmux.txt                     |  307 ++++++++++
 MAINTAINERS                                  |    5 +
 drivers/Kconfig                              |    4 +
 drivers/Makefile                             |    2 +
 drivers/pinmux/Kconfig                       |   26 +
 drivers/pinmux/Makefile                      |    5 +
 drivers/pinmux/core.c                        |  770 ++++++++++++++++++++++++++
 include/linux/pinmux.h                       |  235 ++++++++
 9 files changed, 1365 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-pinmux
 create mode 100644 Documentation/pinmux.txt
 create mode 100644 drivers/pinmux/Kconfig
 create mode 100644 drivers/pinmux/Makefile
 create mode 100644 drivers/pinmux/core.c
 create mode 100644 include/linux/pinmux.h

diff --git a/Documentation/ABI/testing/sysfs-class-pinmux b/Documentation/ABI/testing/sysfs-class-pinmux
new file mode 100644
index 0000000..f2a0ba8
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-pinmux
@@ -0,0 +1,11 @@
+What:		/sys/class/pinmux/.../name
+Date:		May 2011
+KernelVersion:	2.6.40
+Contact:	Linus Walleij <linus.walleij@linaro.org>
+Description:
+		Each pinmux directory will contain a field called
+		name. This holds a string identifying the pinmux for
+		display purposes.
+
+		NOTE: this will be empty if no suitable name is provided
+		by platform or pinmux drivers.
diff --git a/Documentation/pinmux.txt b/Documentation/pinmux.txt
new file mode 100644
index 0000000..d1a5436
--- /dev/null
+++ b/Documentation/pinmux.txt
@@ -0,0 +1,307 @@
+PINMUX interfaces
+
+This document outlines the pin muliplexer (pinmux) subsystem in Linux
+
+These calls use the pinmux_* naming prefix.  No other calls should use that
+prefix.
+
+
+What is pinmuxing?
+==================
+
+Pinmux, also known as padmux, ballmux or alternate functions, is a way for
+chip vendors producing some kind of electrical packages to use a certain
+physical bin (ball, pad, finger, etc) for multiple mutually exclusive
+functions, depending on the application. By "application" in this context
+we mean a way of soldering or wiring the package into an electronic system.
+
+Here is an example of a PGA (Pin Grid Array) chip seen from underneath:
+
+        A   B   C   D   E   F   G   H
+      +---+
+   8  | o | o   o   o   o   o   o   o
+      |   |
+   7  | o | o   o   o   o   o   o   o
+      |   |
+   6  | o | o   o   o   o   o   o   o
+      +---+---+
+   5  | o | o | o   o   o   o   o   o
+      +---+---+               +---+
+   4    o   o   o   o   o   o | o | o
+                              |   |
+   3    o   o   o   o   o   o | o | o
+                              |   |
+   2    o   o   o   o   o   o | o | o
+                              |   |
+   1    o   o   o   o   o   o | o | o
+                              +---+
+
+This is not tetris. The game to think of is chess. Not all PGA/BGA packages
+are chessboard-like, big ones have "holes" in some arrangement according to
+different design patterns, but we're using this as a simple example. Of the
+pins you see some will be taken by things like a few VCC and GND to feed power
+to the chip, and quite a few will be taken by large ports like an external
+memory interface. The remaining pins will often be subject to pin multiplexing.
+
+In this 8x8 BGA package the pins { A8, A7, A6, A5 } can be used as an SPI port
+(these are four pins: CLK, RXD, TXD, FRM). In that case, pin B5 can be used as
+some general-purpose GPIO pin. However, in another setting, pins { A5, B5 } can
+be used as an I2C port (these are just two pins: SCL, SDA). Needless to say,
+we cannot use the SPI port and I2C port at the same time. However in the inside
+of the package the silicon performing the SPI logic can alternatively be routed
+out on pins { G4, G3, G2, G1 }.
+
+This way the silicon blocks present inside the chip can be multiplexed "muxed"
+out on different pin ranges. Often contemporary SoC (systems on chip) will
+contain several I2C, SPI, SDIO/MMC, etc silicon blocks that can be routed to
+different pins by pinmux settings.
+
+Since general-purpose I/O pins (GPIO) are typically always in shortage, it is
+common to be able to use almost any pin as a GPIO pin if it is not currently
+in use by some other I/O port.
+
+
+Pinmux conventions
+==================
+
+The purpose of the pinmux subsystem is to abstract and provide pinmux settings
+to the devices you choose to instantiate in your machine configuration. It is
+inspired by the clk, GPIO and regulator subsystems, so devices will request
+their mux setting, but it's also possible to request a single pin for e.g.
+GPIO.
+
+Definitions:
+
+- PINS are equal to pads or finger or whatever packaging output you want to mux
+  and these are denoted by unsigned integers in the range 0..MAX_INT. Every
+  pin on your system (or atleast every pin that can be muxed) should have a
+  unique number. The numberspace can span several chips if you have more chips
+  on your system that can be subject to muxing. The example 8x8 array above
+  will have pin numbers 0 thru 63 assigned to its physical pins.
+
+- FUNCTIONS can be switched in and out by a driver residing with the pinmux
+  subsystem in the drivers/pinmux/* directory of the kernel. The pinmux driver
+  knows the possible functions. In the example above you can identify three
+  pinmux functions, two for spi and one for i2c.
+
+- FUNCTIONS are assumed to be enumerable from zero in a one-dimensional array.
+  In this case the array could be something like: { spi0-0, spi0-1, i2c0-0 }
+  for the three available settings. The knowledge of this one-dimensional array
+  and it's machine-specific particulars is kept inside the pinmux driver,
+  from the outside only these enumerators are known, and the driver core
+  can request the name or the list of pins belonging to a certain enumerator.
+
+- FUNCTIONS are MAPPED to a certain device by the board file, device tree or
+  similar machine setup configuration mechanism, similar to how regulators are
+  connected to devices, usually by name. In the example case we can define
+  that this particular machine shall use device spi0 with pinmux setting
+  spi0-1 and i2c0 on i2c0-1, something like the two-tuple:
+  { {spi0, spi0-1}, {i2c0, i2c0-1} }
+
+- FUNCTIONS are provided on a first-come first-serve basis, so if some other
+  device mux setting or GPIO pin request has already taken your physical pin,
+  you will be denied the use of it. To get (activate) a new setting, the old
+  one has to be put (deactivated) first.
+
+Sometimes the documentation and hardware registers will be oriented around
+pads (or "fingers") rather than pins - these are the soldering surfaces on the
+silicon inside the package, and may or may not match the actual number of
+pins/balls underneath the capsule. Pick some enumeration that makes sense to
+you. Define enumerators only for the pins you can control if that makes sense.
+
+
+Pinmux drivers
+==============
+
+The driver will for all calls be provided an offset pin number into its own
+pin range. If you have 2 chips with 8x8 pins, the first chips pins will have
+numbers 0 thru 63 and the second one pins 64 thru 127, but the driver for the
+second chip will be passed numbers in the range 0 thru 63 anyway, base offset
+subtracted.
+
+Pinmux drivers are required to supply a few callback functions, some are
+optional. Usually the enable() and disable() functions are implemented,
+writing values into some certain registers to activate a certain mux setting
+for a certain pin.
+
+A simple driver for the above example will work by setting bits 0, 1 or 2
+into some register mamed MUX, so it enumerates its available settings and
+their pin assignments, and expose them like this:
+
+struct foo_pmx_func {
+	char *name;
+	const unsigned int *pins;
+	const unsigned num_pins;
+};
+
+static unsigned int spi0_0_pins[] = { 0, 8, 16, 24 };
+static unsigned int i2c0_pins[] = { 24, 25 };
+static unsigned int spi0_1_pins[] = { 38, 46, 54, 62 };
+
+static struct foo_pmx_func myfuncs[] = {
+	{
+		.name = "spi0-0",
+		.pins = spi0_0_pins,
+		.num_pins = ARRAY_SIZE(spi0_1_pins),
+	},
+	{
+		.name = "i2c0",
+		.pins = i2c0_pins,
+		.num_pins = ARRAY_SIZE(i2c0_pins),
+	},
+	{
+		.name = "spi0-1",
+		.pins = spi0_1_pins,
+		.num_pins = ARRAY_SIZE(spi0_1_pins),
+	},
+};
+
+int foo_list(struct pinmux_dev *pmxdev, unsigned selector)
+{
+	if (selector >= ARRAY_SIZE(myfuncs))
+		return -EINVAL;
+	return 0;
+}
+
+const char *foo_get_fname(struct pinmux_dev *pmxdev, unsigned selector)
+{
+	if (selector >= ARRAY_SIZE(myfuncs))
+		return NULL;
+	return myfuncs[selector].name;
+}
+
+static int foo_get_pins(struct pinmux_dev *pmxdev, unsigned selector,
+	   		unsigned ** const pins, unsigned * const num_pins)
+{
+	if (selector >= ARRAY_SIZE(myfuncs))
+		return -EINVAL;
+	*pins = myfuncs[selector].pins;
+	*num_pins = myfuncs[selector].num_pins;
+	return 0;
+}
+
+
+int foo_enable(struct pinmux_dev *pmxdev, unsigned selector)
+{
+	if (selector < ARRAY_SIZE(myfuncs))
+		write((read(MUX)|(1<<selector)), MUX)
+		return 0;
+	}
+	return -EINVAL;
+}
+
+int foo_disable(struct pinmux_dev *pmxdev, unsigned selector)
+{
+	if (selector < ARRAY_SIZE(myfuncs))
+		write((read(MUX) & ~(1<<selector)), MUX)
+		return 0;
+	}
+	return -EINVAL;
+}
+
+struct pinmux_ops ops = {
+	.list_functions = foo_list,
+	.get_function_name = foo_get_fname,
+	.get_function_pins = foo_get_pins,
+	.enable = foo_enable,
+	.disable = foo_disable,
+};
+
+Now the able reader will say: "wait - the driver needs to make sure it
+can set this and that bit at the same time, because else it will collide
+and wreak havoc in my electronics, and make sure noone else is using the
+other setting that it's incompatible with".
+
+In the example activating muxing 0 and 1 at the same time setting bits
+0 and 1, uses one pin in common so they would collide.
+
+The beauty of the pinmux subsystem is that since it keeps track of all
+pins and who is using them, it will already have denied an impossible
+request like that, so the driver does not need to worry about such
+things - when it gets a selector passed in, the pinmux subsystem makes
+sure no other device or GPIO assignment is already using the selected
+pins.
+
+The above functions are mandatory to implement for a pinmux driver.
+
+The function list can become long, especially if you can convert every
+individual pin into a GPIO pin independent of any other pins, then your
+function array can become 64 entries for each GPIO setting and then the
+device functions. For this reason there is an additional function you
+can implement to enable only GPIO on an individual pin: gpio_enable().
+
+
+Board/machine configuration
+===========================
+
+Boards and machines define how a certain complete running system is put
+together, including how GPIOs and devices are muxed, how regulators are
+constrained and how the clock tree looks. Of course pinmux settings are also
+part of this.
+
+A pinmux config for a machine looks pretty much like a simple regulator
+configuration, so for the example array above we want to enable i2c and
+spi on the second function mapping:
+
+static struct pinmux_map pmx_mapping[] = {
+	{
+		.function = "spi0-1",
+		.dev_name = "foo-spi.0",
+	},
+	{
+		.function = "i2c0",
+		.dev_name = "foo-i2c.0",
+	},
+};
+
+Since the above construct is pretty common there is a helper macro to make
+it even more compact:
+
+static struct pinmux_map pmx_mapping[] = {
+       PINMUX_MAP("spi0-1", "foo-spi.0"),
+       PINMUX_MAP("i2c0", "foo-i2c.0"),
+};
+
+The dev_name here matches to the unique device name that can be used to look
+up the device struct (just like with clockdev or regulators). The function name
+must match a function provided by the pinmux driver handling this pin range.
+You register this pinmux mapping to the pinmux subsystem by simply:
+
+       ret = pinmux_register_mappings(&pmx_mapping, ARRAY_SIZE(pmx_mapping));
+
+
+Pinmux requests from drivers
+============================
+
+A driver may request a certain mux to be activated, usually just the default
+mux like this:
+
+foo_probe()
+{
+	/* Allocate a state holder named "state" etc */
+	struct pinmux pmx;
+
+	pmx = pinmux_get(&device, NULL);
+	if IS_ERR(pmx)
+		return PTR_ERR(pmx);
+	pinmux_enable(pmx);
+
+	state->pmx = pmx;
+}
+
+foo_remove()
+{
+	pinmux_disable(state->pmx);
+	pinmux_put(state->pmx);
+}
+
+If you want a specific mux setting and not just the first one found for this
+device you can specify a specific mux setting, for example in the above example
+the second i2c0 setting: pinmux_get(&device, "spi0-2");
+
+This get/enable/disable/put sequence can just as well be handled by bus drivers
+if you don't want each and every driver to handle it and you know the
+arrangement on your bus.
+
+The pins are allocated for your device when you issue the pinmux_get() call,
+after this you should be able to see this in the debugfs listing of all pins.
diff --git a/MAINTAINERS b/MAINTAINERS
index 1380312..3eacca8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4899,6 +4899,11 @@ L:	linux-mtd@lists.infradead.org
 S:	Maintained
 F:	drivers/mtd/devices/phram.c
 
+PINMUX SUBSYSTEM
+M:	Linus Walleij <linus.walleij@linaro.org>
+S:	Maintained
+F:	drivers/pinmux/
+
 PKTCDVD DRIVER
 M:	Peter Osterlund <petero2@telia.com>
 S:	Maintained
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 177c7d1..28d13b3 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -54,6 +54,10 @@ source "drivers/spi/Kconfig"
 
 source "drivers/pps/Kconfig"
 
+# pinmux before gpio - gpio drivers may need it
+
+source "drivers/pinmux/Kconfig"
+
 source "drivers/gpio/Kconfig"
 
 source "drivers/w1/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 3f135b6..cb7ae50 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -5,6 +5,8 @@
 # Rewritten to use lists instead of if-statements.
 #
 
+# GPIO must come after pinmux as gpios may need to mux pins
+obj-y				+= pinmux/
 obj-y				+= gpio/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
diff --git a/drivers/pinmux/Kconfig b/drivers/pinmux/Kconfig
new file mode 100644
index 0000000..3073ccc
--- /dev/null
+++ b/drivers/pinmux/Kconfig
@@ -0,0 +1,26 @@
+#
+# PINMUX infrastructure and drivers
+#
+
+config MACH_HAS_PINMUX
+       bool
+
+menuconfig PINMUX
+	bool "PINMUX Support"
+	default y if MACH_HAS_PINMUX
+	depends on SYSFS && EXPERIMENTAL
+	help
+	  This enables the PINMUX subsystem for multiplexing pins
+	  on primarily PGA and BGA packages for systems on chip.
+
+	  If unsure, say N.
+
+if PINMUX
+
+config DEBUG_PINMUX
+	bool "Debug PINMUX calls"
+	depends on DEBUG_KERNEL
+	help
+	  Say Y here to add some extra checks and diagnostics to PINMUX calls.
+
+endif
diff --git a/drivers/pinmux/Makefile b/drivers/pinmux/Makefile
new file mode 100644
index 0000000..c0ea542
--- /dev/null
+++ b/drivers/pinmux/Makefile
@@ -0,0 +1,5 @@
+# generic pinmux support
+
+ccflags-$(CONFIG_DEBUG_PINMUX)	+= -DDEBUG
+
+obj-$(CONFIG_PINMUX)		+= core.o
diff --git a/drivers/pinmux/core.c b/drivers/pinmux/core.c
new file mode 100644
index 0000000..4ab8555
--- /dev/null
+++ b/drivers/pinmux/core.c
@@ -0,0 +1,770 @@
+/*
+ * Core driver for the pinmux subsystem
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * Based on bits of regulator core, gpio core and clk core
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/sysfs.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/pinmux.h>
+
+/* Global list of pinmuxes */
+static DEFINE_MUTEX(pinmux_list_mutex);
+static LIST_HEAD(pinmux_list);
+
+/* Global list of pinmux devices */
+static DEFINE_MUTEX(pinmuxdev_list_mutex);
+static LIST_HEAD(pinmuxdev_list);
+
+/**
+ * struct pin_desc - pin descriptor for each physical pin in the arch
+ * @pmxdev: corresponding pinmux device
+ * @requested: whether the pin is already requested or not
+ * @function: a named muxing function for the pin that will be passed to
+ *	subdrivers and shown in debugfs etc
+ */
+struct pin_desc {
+	struct pinmux_dev *pmxdev;
+	bool	requested;
+	char	function[16];
+};
+/* Plobal array of descriptors, one for each physical pin */
+static DEFINE_SPINLOCK(pin_desc_lock);
+static struct pin_desc pin_desc[MACH_NR_PINS];
+
+/**
+ * struct pinmux - per-device pinmux state holder
+ * @node: global list node - only for internal use
+ * @dev: the device using this pinmux
+ * @pmxdev: the pinmux device controlling this pinmux
+ * @map: corresponding pinmux map active for this pinmux setting
+ * @usecount: the number of active users of this mux setting, used to keep
+ *	track of nested use cases
+ * @pins: an array of discrete physical pins used in this mapping, taken
+ *	from the global pin enumeration space (copied from pinmux map)
+ * @num_pins: the number of pins in this mapping array, i.e. the number of
+ *	elements in .pins so we can iterate over that array (copied from
+ *	pinmux map)
+ * @pmxdev: pinmux device handling this pinmux
+ * @pmxdev_selector: the selector for the pinmux device handling this pinmux
+ * @mutex: a lock for the pinmux state holder
+ */
+struct pinmux {
+	struct list_head node;
+	struct device *dev;
+	struct pinmux_map const *map;
+	unsigned usecount;
+	struct pinmux_dev *pmxdev;
+	unsigned pmxdev_selector;
+	struct mutex mutex;
+};
+
+static ssize_t pinmux_name_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct pinmux_dev *pmxdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", pmxdev_get_name(pmxdev));
+}
+
+static struct device_attribute pinmux_dev_attrs[] = {
+	__ATTR(name, 0444, pinmux_name_show, NULL),
+	__ATTR_NULL,
+};
+
+static void pinmux_dev_release(struct device *dev)
+{
+	struct pinmux_dev *pmxdev = dev_get_drvdata(dev);
+	kfree(pmxdev);
+}
+
+static struct class pinmux_class = {
+	.name = "pinmux",
+	.dev_release = pinmux_dev_release,
+	.dev_attrs = pinmux_dev_attrs,
+};
+
+/**
+ * pin_request() - request a single pin to be muxed in, typically for GPIO
+ * @pin: the pin number in the global pin space
+ * @function: a functional name to give to this pin, passed to the driver
+ *	so it knows what function to mux in, e.g. the string "gpioNN"
+ *	means that you want to mux in the pin for use as GPIO number NN
+ * @gpio: if this request concerns a single GPIO pin
+ */
+static int pin_request(int pin, const char *function, bool gpio)
+{
+	struct pin_desc *desc;
+	struct pinmux_dev *pmxdev;
+	const struct pinmux_ops *ops;
+	int status = -EINVAL;
+	unsigned long flags;
+
+	pr_debug("request pin %d for %s\n", pin, function);
+	if (!pin_is_valid(pin)) {
+		pr_err("pin is invalid\n");
+		return -EINVAL;
+	}
+
+	if (!function) {
+		pr_err("no function name given\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&pin_desc_lock, flags);
+	desc = &pin_desc[pin];
+	pmxdev = desc->pmxdev;
+	if (desc->requested) {
+		pr_err("pin already requested\n");
+		goto out;
+	}
+	if (!pmxdev) {
+		pr_warn("no pinmux device is handling pin %d\n", pin);
+		goto out;
+	}
+	ops = pmxdev->desc->ops;
+
+	/* Let each pin increase references to this module */
+	if (!try_module_get(pmxdev->owner)) {
+		pr_err("could not increase module refcount for pin %d\n", pin);
+		status = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * If there is no kind of request function for the pin we just assume
+	 * we got it by default and proceed.
+	 */
+	if (gpio && ops->gpio_request_enable)
+		/* This requests and enables a single GPIO pin */
+		status = ops->gpio_request_enable(pmxdev,
+						  pin - pmxdev->desc->base);
+	else if (ops->request)
+		status = ops->request(pmxdev,
+				      pin - pmxdev->desc->base);
+	else
+		status = 0;
+
+	if (status) {
+		pr_err("->request on device %s failed "
+		       "for pin %d (offset %d)\n",
+		       pmxdev->desc->name, pin,
+		       pin - pmxdev->desc->base);
+		goto out;
+	}
+
+	desc->requested = true;
+	strncpy(desc->function, function, 16);
+	desc->function[15] = '\0';
+
+out:
+	spin_unlock_irqrestore(&pin_desc_lock, flags);
+	if (status)
+		pr_err("pin-%d (%s) status %d\n",
+		       pin, function ? : "?", status);
+
+	return status;
+}
+
+/**
+ * pin_free() - release a single muxed in pin so something else can be muxed in
+ *	instead
+ * @pin: the pin to free
+ */
+static void pin_free(int pin)
+{
+	struct pin_desc *desc;
+	struct pinmux_dev *pmxdev;
+	unsigned long flags;
+
+	if (!pin_is_valid(pin))
+		return;
+
+	spin_lock_irqsave(&pin_desc_lock, flags);
+	desc = &pin_desc[pin];
+	pmxdev = desc->pmxdev;
+	if (pmxdev) {
+		const struct pinmux_ops *ops = pmxdev->desc->ops;
+
+		if (ops->free)
+			ops->free(pmxdev, pin - pmxdev->desc->base);
+	}
+	desc->requested = false;
+	desc->function[0] = '\0';
+	module_put(pmxdev->owner);
+	spin_unlock_irqrestore(&pin_desc_lock, flags);
+}
+
+/**
+ * pinmux_request_gpio() - request a single pin to be muxed in to be used
+ *	as a GPIO pin
+ * @pin: the pin to mux in as GPIO
+ * @gpio: the corresponding GPIO pin number
+ */
+int pinmux_request_gpio(int pin, unsigned gpio)
+{
+	char gpiostr[16];
+
+	snprintf(gpiostr, 15, "gpio%d", gpio);
+	return pin_request(pin, gpiostr, true);
+}
+EXPORT_SYMBOL_GPL(pinmux_request_gpio);
+
+/**
+ * pinmux_free_gpio() - free a single pin, currently muxed in to be used
+ *	as a GPIO pin
+ * @pin: the pin to mux out from GPIO
+ */
+void pinmux_free_gpio(int pin)
+{
+	return pin_free(pin);
+}
+EXPORT_SYMBOL_GPL(pinmux_free_gpio);
+
+int pinmux_register_mappings(struct pinmux_map const *maps, unsigned num_maps)
+{
+	int ret = 0;
+	int i;
+
+	pr_debug("add %d functions\n", num_maps);
+	for (i = 0; i < num_maps; i++) {
+		struct pinmux *pmx;
+
+		/* Sanity check the mapping */
+		if (!maps[i].function) {
+			pr_err("failed to register map %d - no function ID given\n", i);
+			ret = -EINVAL;
+			goto out;
+		}
+		if (!maps[i].dev && !maps[i].dev_name) {
+			pr_err("failed to register map %d - no device or device name given\n", i);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		/*
+		 * create the state cookie holder struct pinmux for each
+		 * mapping, this is what consumers will get when requesting
+		 * a pinmux handle with pinmux_get()
+		 */
+		pmx = kzalloc(sizeof(struct pinmux), GFP_KERNEL);
+		if (pmx == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		mutex_init(&pmx->mutex);
+		pmx->map = &maps[i];
+
+		/* Add the pinmux */
+		mutex_lock(&pinmux_list_mutex);
+		list_add(&pmx->node, &pinmux_list);
+		mutex_unlock(&pinmux_list_mutex);
+		pr_debug("add function %s\n", maps[i].function);
+	}
+
+out:
+	return ret;
+}
+
+/**
+ * acquire_pins() - acquire all the pins for a certain funcion on a certain
+ *	pinmux device
+ * @pmxdev: the device to take the function on
+ * @selector: the selector to acquire the pins for
+ */
+int acquire_pins(struct pinmux_dev *pmxdev, unsigned selector)
+{
+	const struct pinmux_ops *ops = pmxdev->desc->ops;
+	unsigned *pins;
+	unsigned num_pins;
+	const char *func = ops->get_function_name(pmxdev, selector);
+	int ret;
+	int i;
+
+	ret = ops->get_function_pins(pmxdev, selector, &pins, &num_pins);
+	if (ret)
+		return ret;
+
+	/* Try to allocate all pins in this pinmux map, one by one */
+	for (i = 0; i < num_pins; i++) {
+		ret = pin_request(pins[i], func, false);
+		if (ret) {
+			pr_err("could not get pin %d for function %s "
+			       "on device %s - conflicting mux mappings?\n",
+			       pins[i], func ? : "(undefined)",
+			       pmxdev->desc->name);
+			/* On error release all taken pins */
+			i--; /* this pin just failed */
+			for (; i >= 0; i--)
+				pin_free(pins[i]);
+			return -ENODEV;
+		}
+	}
+	return 0;
+}
+
+/**
+ * pinmux_get() - retrieves the pinmux for a certain device
+ * @dev: the device to get the pinmux for
+ * @func: an optional mux name or NULL, the name is only needed
+ *	if a single device has multiple pinmux settings (i.e. if the
+ *	same device can be muxed out on different sets of pins) or if
+ *	you need an anonymous pinmux (not tied to any specific device)
+ */
+struct pinmux *pinmux_get(struct device *dev, const char *func)
+{
+	struct pinmux_map const *map = NULL;
+	struct pinmux_dev *pmxdev = NULL;
+	const char *devname = NULL;
+	struct pinmux *pmx;
+	bool found = false;
+	int ret = -ENODEV;
+
+	/* We must have dev or ID or both */
+	if (!dev && !func)
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&pinmux_list_mutex);
+
+	if (dev)
+		devname = dev_name(dev);
+
+	/* Locate the pinmux map */
+	list_for_each_entry(pmx, &pinmux_list, node) {
+		map = pmx->map;
+
+		/* If an function is given, it MUST match */
+		if ((func != NULL) && strcmp(map->function, func))
+			continue;
+
+		/* If the mapping has a device set up it must match */
+		if (map->dev_name &&
+		    (!devname || !strcmp(map->dev_name, devname))) {
+			/* MATCH! */
+			found = true;
+			break;
+		}
+	}
+
+	mutex_unlock(&pinmux_list_mutex);
+
+	if (!found) {
+		pr_err("could not find mux map for device %s, ID %s\n",
+		       devname ? : "(anonymous)", func ? : "(undefined)");
+		goto out;
+	}
+
+	/* Make sure that noone else is using this function mapping */
+	mutex_lock(&pmx->mutex);
+	if (pmx->dev) {
+		if (pmx->dev != dev) {
+			mutex_unlock(&pmx->mutex);
+			pr_err("mapping already in use device %s, ID %s\n",
+			       devname ? : "(anonymous)", func ? : "(undefined)");
+			goto out;
+		} else {
+			/* We already fetched this and requested pins */
+			mutex_unlock(&pmx->mutex);
+			ret = 0;
+			goto out;
+		}
+	}
+	mutex_unlock(&pmx->mutex);
+
+
+	/*
+	 * Iterate over the drivers so see which ones that may handle this
+	 * specific muxing. NOTE: there can be only one as of now.
+	 */
+	list_for_each_entry(pmxdev, &pinmuxdev_list, node) {
+		const struct pinmux_ops *ops = pmxdev->desc->ops;
+		unsigned selector = 0;
+
+		/* See if this pmxdev has this function */
+		while (ops->list_functions(pmxdev, selector) >= 0) {
+			const char *fname = ops->get_function_name(pmxdev,
+								   selector);
+
+			if (!strcmp(map->function, fname)) {
+				ret = acquire_pins(pmxdev, selector);
+				if (ret)
+					goto out;
+				/* Found it! */
+				mutex_lock(&pmx->mutex);
+				pmx->dev = dev;
+				pmx->pmxdev = pmxdev;
+				pmx->pmxdev_selector = selector;
+				mutex_unlock(&pmx->mutex);
+				ret = 0;
+				goto out;
+			}
+			selector++;
+		}
+	}
+	/* We couldn't find the driver for this pinmux */
+	ret = -ENODEV;
+
+out:
+	if (ret)
+		pmx = ERR_PTR(ret);
+
+	return pmx;
+}
+EXPORT_SYMBOL_GPL(pinmux_get);
+
+/**
+ * pinmux_put() - release a previously claimed pinmux
+ * @pmx: a pinmux previously claimed by pinmux_get()
+ */
+void pinmux_put(struct pinmux *pmx)
+{
+	if (pmx == NULL)
+		return;
+	mutex_lock(&pmx->mutex);
+	if (pmx->usecount)
+		pr_warn("pinmux: releasing pinmux with active users!\n");
+	pmx->dev = NULL;
+	pmx->pmxdev = NULL;
+	pmx->pmxdev_selector = 0;
+	mutex_unlock(&pmx->mutex);
+}
+EXPORT_SYMBOL_GPL(pinmux_put);
+
+/**
+ * pinmux_enable() - enable a certain pinmux setting
+ * @pmx: the pinmux to enable, previously claimed by pinmux_get()
+ */
+int pinmux_enable(struct pinmux *pmx)
+{
+	int ret = 0;
+
+	if (pmx == NULL)
+		return -EINVAL;
+	mutex_lock(&pmx->mutex);
+	if (pmx->usecount++ == 0) {
+		struct pinmux_dev *pmxdev = pmx->pmxdev;
+		const struct pinmux_ops *ops = pmxdev->desc->ops;
+
+		ret = ops->enable(pmxdev, pmx->pmxdev_selector);
+		if (ret)
+			pmx->usecount--;
+	}
+	mutex_unlock(&pmx->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pinmux_enable);
+
+/**
+ * pinmux_disable() - disable a certain pinmux setting
+ * @pmx: the pinmux to disable, previously claimed by pinmux_get()
+ */
+void pinmux_disable(struct pinmux *pmx)
+{
+	if (pmx == NULL)
+		return;
+
+	mutex_lock(&pmx->mutex);
+	if (--pmx->usecount == 0) {
+		struct pinmux_dev *pmxdev = pmx->pmxdev;
+		const struct pinmux_ops *ops = pmxdev->desc->ops;
+
+		ops->disable(pmxdev, pmx->pmxdev_selector);
+	}
+	mutex_unlock(&pmx->mutex);
+}
+EXPORT_SYMBOL_GPL(pinmux_disable);
+
+/**
+ * pinmux_config() - configure a certain pinmux setting
+ * @pmx: the pinmux setting to configure
+ * @param: the parameter to configure
+ * @data: extra data to be passed to the configuration, also works as a
+ *	pointer to data returned from the function on success
+ */
+int pinmux_config(struct pinmux *pmx, u16 param, unsigned long *data)
+{
+	struct pinmux_dev *pmxdev;
+	const struct pinmux_ops *ops;
+	int ret = 0;
+
+	if (pmx == NULL)
+		return -ENODEV;
+
+	pmxdev = pmx->pmxdev;
+	ops = pmxdev->desc->ops;
+
+	/* This operation is not mandatory to implement */
+	if (ops->config) {
+		mutex_lock(&pmx->mutex);
+		ret = ops->config(pmxdev, pmx->pmxdev_selector, param, data);
+		mutex_unlock(&pmx->mutex);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinmux_config);
+
+/**
+ * pinmux_register() - register a pinmux device
+ * @pmxdesc: descriptor for this pinmux
+ * @dev: parent device for this pinmux
+ * @driver_data: private pinmux data for this pinmux
+ */
+struct pinmux_dev *pinmux_register(struct pinmux_desc *pmxdesc,
+				   struct device *dev, void *driver_data)
+{
+	static atomic_t pinmux_no = ATOMIC_INIT(0);
+	struct pinmux_dev *pmxdev;
+	int ret;
+	int i;
+
+	if (pmxdesc == NULL)
+		return ERR_PTR(-EINVAL);
+	if (pmxdesc->name == NULL || pmxdesc->ops == NULL)
+		return ERR_PTR(-EINVAL);
+	/* These functions are mandatory */
+	if (!pmxdesc->ops->list_functions ||
+	    !pmxdesc->ops->get_function_name ||
+	    !pmxdesc->ops->enable ||
+	    !pmxdesc->ops->disable)
+		return ERR_PTR(-EINVAL);
+
+	pmxdev = kzalloc(sizeof(struct pinmux_dev), GFP_KERNEL);
+	if (pmxdev == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_lock(&pinmuxdev_list_mutex);
+	pmxdev->owner = pmxdesc->owner;
+	pmxdev->desc = pmxdesc;
+	pmxdev->driver_data = driver_data;
+
+	/* Register device with sysfs */
+	pmxdev->dev.class = &pinmux_class;
+	pmxdev->dev.parent = dev;
+	dev_set_name(&pmxdev->dev, "pinmux.%d",
+		     atomic_inc_return(&pinmux_no) - 1);
+	ret = device_register(&pmxdev->dev);
+	if (ret != 0) {
+		put_device(&pmxdev->dev);
+		kfree(pmxdev);
+		goto out;
+	}
+	dev_set_drvdata(&pmxdev->dev, pmxdev);
+
+	/* Put self as handler of the indicated pin range */
+	for (i = pmxdesc->base; i < (pmxdesc->base + pmxdesc->npins); i++) {
+		struct pin_desc *pindesc;
+
+		if (!pin_is_valid(i)) {
+			dev_err(&pmxdev->dev, "tried to register invalid pin %d\n", i);
+			continue;
+		}
+
+		pindesc = &pin_desc[i];
+		if (pindesc->requested) {
+			dev_err(&pmxdev->dev, "tried to register already requested pin %d\n", i);
+			continue;
+		}
+		pindesc->pmxdev = pmxdev;
+	}
+
+	list_add(&pmxdev->node, &pinmuxdev_list);
+out:
+	mutex_unlock(&pinmuxdev_list_mutex);
+
+	return pmxdev;
+}
+EXPORT_SYMBOL_GPL(pinmux_register);
+
+/**
+ * pinmux_unregister() - unregister pinmux
+ * @pmxdev: pinmux to unregister
+ *
+ * Called by pinmux drivers to unregister a pinmux.
+ */
+void pinmux_unregister(struct pinmux_dev *pmxdev)
+{
+	if (pmxdev == NULL)
+		return;
+
+	mutex_lock(&pinmuxdev_list_mutex);
+	list_del(&pmxdev->node);
+	device_unregister(&pmxdev->dev);
+	mutex_unlock(&pinmuxdev_list_mutex);
+}
+EXPORT_SYMBOL_GPL(pinmux_unregister);
+
+#ifdef CONFIG_DEBUG_FS
+
+static int pinmux_devices_show(struct seq_file *s, void *what)
+{
+	struct pinmux_dev *pmxdev;
+
+	seq_puts(s, "Available pinmux settings per pinmux device:\n");
+	list_for_each_entry(pmxdev, &pinmuxdev_list, node) {
+		const struct pinmux_ops *ops = pmxdev->desc->ops;
+		unsigned selector = 0;
+
+		seq_printf(s, "Device %s:\n", pmxdev->desc->name);
+		while (ops->list_functions(pmxdev, selector) >= 0) {
+			unsigned *pins;
+			unsigned num_pins;
+			const char *func = ops->get_function_name(pmxdev,
+								  selector);
+			int ret;
+			int i;
+
+			ret = ops->get_function_pins(pmxdev, selector,
+						     &pins, &num_pins);
+
+			if (ret)
+				seq_printf(s, "%s [ERROR GETTING PINS]\n",
+					   func);
+
+			else {
+				seq_printf(s, "function: %s, pins = [ ", func);
+				for (i = 0; i < num_pins; i++)
+					seq_printf(s, "%d ", pins[i]);
+				seq_puts(s, "]\n");
+			}
+
+			selector++;
+
+		}
+	}
+
+	return 0;
+}
+
+static int pinmux_maps_show(struct seq_file *s, void *what)
+{
+	struct pinmux *pmx;
+	const struct pinmux_map *map;
+
+	seq_puts(s, "Pinmux maps:\n");
+	list_for_each_entry(pmx, &pinmux_list, node) {
+		map = pmx->map;
+
+		seq_printf(s, "map: %s -> %s\n", map->function,
+			   pmx->dev ? dev_name(pmx->dev) : "(unassigned)");
+	}
+
+	return 0;
+}
+
+static int pinmux_pins_show(struct seq_file *s, void *what)
+{
+	unsigned pin;
+
+	seq_puts(s, "Pinmux functions per pin:\n");
+	spin_lock(&pin_desc_lock);
+	for (pin = 0; pin_is_valid(pin); pin++) {
+		struct pin_desc *desc = &pin_desc[pin];
+		struct pinmux_dev *pmxdev = desc->pmxdev;
+
+		seq_printf(s, "pin %d: %s", pin,
+			   desc->requested ? desc->function : "(unclaimed)");
+
+		if (pmxdev && pmxdev->desc->ops->dbg_show)
+			pmxdev->desc->ops->dbg_show(pmxdev, s,
+						    pin - pmxdev->desc->base);
+
+		seq_puts(s, "\n");
+	}
+	spin_unlock(&pin_desc_lock);
+
+	return 0;
+}
+
+static int pinmux_devices_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinmux_devices_show, NULL);
+}
+
+static int pinmux_maps_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinmux_maps_show, NULL);
+}
+
+static int pinmux_pins_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinmux_pins_show, NULL);
+}
+
+static const struct file_operations pinmux_devices_ops = {
+	.open		= pinmux_devices_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations pinmux_maps_ops = {
+	.open		= pinmux_maps_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations pinmux_pins_ops = {
+	.open		= pinmux_pins_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static struct dentry *debugfs_root;
+
+static void pinmux_init_debugfs(void)
+{
+	debugfs_root = debugfs_create_dir("pinmux", NULL);
+	if (IS_ERR(debugfs_root) || !debugfs_root) {
+		pr_warn("failed to create debugfs directory\n");
+		debugfs_root = NULL;
+		return;
+	}
+
+	debugfs_create_file("devices", S_IFREG | S_IRUGO,
+			    debugfs_root, NULL, &pinmux_devices_ops);
+	debugfs_create_file("maps", S_IFREG | S_IRUGO,
+			    debugfs_root, NULL, &pinmux_maps_ops);
+	debugfs_create_file("pins", S_IFREG | S_IRUGO,
+			    debugfs_root, NULL, &pinmux_pins_ops);
+}
+
+#else /* CONFIG_DEBUG_FS */
+
+static void pinmux_init_debugfs(void)
+{
+}
+
+#endif
+
+static int __init pinmux_init(void)
+{
+	int ret;
+
+	ret = class_register(&pinmux_class);
+	pr_info("subsystem handles up to %d pins\n", MACH_NR_PINS);
+
+	pinmux_init_debugfs();
+	return ret;
+}
+
+/* init early since many drivers really need to initialized pinmux early */
+core_initcall(pinmux_init);
diff --git a/include/linux/pinmux.h b/include/linux/pinmux.h
new file mode 100644
index 0000000..088fbfd
--- /dev/null
+++ b/include/linux/pinmux.h
@@ -0,0 +1,235 @@
+/*
+ * Interface the pinmux subsystem
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * Based on bits of regulator core, gpio core and clk core
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#ifndef __LINUX_PINMUX_H
+#define __LINUX_PINMUX_H
+
+#include <linux/list.h>
+#include <linux/seq_file.h>
+
+struct pinmux;
+
+/**
+ * struct pinmux_map - boards/machines shall provide this map for devices
+ * @function: a functional name for this mapping so it can be passed down
+ *	to the driver to invoke that function and be referenced by this ID
+ *	in e.g. pinmux_get()
+ * @dev: the device using this specific mapping, may be NULL if you provide
+ *	.dev_name instead (this is more common)
+ * @dev_name: the name of the device using this specific mapping, the name
+ *	must be the same that will return your struct device*
+ */
+struct pinmux_map {
+	const char *function;
+	struct device *dev;
+	const char *dev_name;
+};
+
+/* Convenience macro to set a simple map from a function to a named device */
+#define PINMUX_MAP(a, b) { .function = a, .dev_name = b }
+
+#ifdef CONFIG_PINMUX
+
+/*
+ * Reach down an pick up MACH_NR_PINS if the machine claims it supports the
+ * pinmux API.
+ */
+#ifdef CONFIG_MACH_HAS_PINMUX
+#include <mach/pinmux.h>
+#endif
+
+/*
+ * The pin number is a global pin number space, nominally the arch shall define
+ * the number of pins in *total* across all chips in the arch/system.
+ *
+ * Example: if your arch has two chips with 64 pins each, you have
+ * 2*64 = 128 MACH_NR_PINS.
+ *
+ * This number space works the same way as the GPIO number space - a unique
+ * number is identifying a unique physical pin on the arch and the arch get to
+ * stack them up in order. No two pins on the arch shall have the same number.
+ * The pinmux subsystem will internally convert the global number into an
+ * offset to the range handled by a specific mux driver.
+ */
+#ifndef MACH_NR_PINS
+#define MACH_NR_PINS	256
+#endif
+
+/*
+ * Valid pin numbers are nonnegative and < MACH_NR_PINS. Invalid numbers can
+ * be used to indicate no-such-pin.
+ */
+static inline int pin_is_valid(int pin)
+{
+	return pin >= 0 && pin < MACH_NR_PINS;
+}
+
+struct pinmux_dev;
+
+/**
+ * struct pinmux_ops - pinmux operations, to be implemented by drivers
+ * @request: called by the core to see if a certain pin can be muxed in
+ *	and made available in a certain mux setting The driver is allowed
+ *	to answer "no" by returning a negative error code
+ * @list_functions: list the number of selectable named functions available
+ *	in this pinmux driver, the core will begin on 0 and call this
+ *	repeatedly as long as it returns >= 0 to enumerate mux settings
+ * @get_function_name: return the function name of the muxing selector,
+ *	called by the core to figure out which mux setting it shall map a
+ *	certain device to
+ * @get_function_pins: return an array of pins corresponding to a certain
+ *	function selector in @pins, and the size of the array in @num_pins
+ * @enable: enable a certain muxing enumerator. The driver does not need to
+ *	figure out whether enabling this function conflicts some other use
+ *	of the pins, such collisions are handled by the pinmux subsystem
+ * @disable: disable a certain muxing enumerator
+ * @config: custom configuration function for a certain muxing enumerator -
+ *	this works a bit like an ioctl() and can pass in and return arbitrary
+ *	configuration data to the pinmux
+ * @gpio_request_enable: requests and enables GPIO on a certain pin.
+ *	Implement this only if you can mux every pin individually as GPIO. If
+ *	your gpio assignments are grouped, so you cannot control the GPIO
+ *	muxing of every indvidual pin.
+ * @dbg_show: optional debugfs display hook that will provide per-device
+ *	info for a certain pin in debugfs
+ */
+struct pinmux_ops {
+	int (*request) (struct pinmux_dev *pmxdev, unsigned offset);
+	int (*free) (struct pinmux_dev *pmxdev, unsigned offset);
+	int (*list_functions) (struct pinmux_dev *pmxdev, unsigned selector);
+	const char *(*get_function_name) (struct pinmux_dev *pmxdev,
+					unsigned selector);
+	int (*get_function_pins) (struct pinmux_dev *pmxdev, unsigned selector,
+			unsigned ** const pins, unsigned * const num_pins);
+	int (*enable) (struct pinmux_dev *pmxdev, unsigned selector);
+	void (*disable) (struct pinmux_dev *pmxdev, unsigned selector);
+	int (*config) (struct pinmux_dev *pmxdev, unsigned selector,
+		       u16 param, unsigned long *data);
+	int (*gpio_request_enable) (struct pinmux_dev *pmxdev, unsigned offset);
+	void (*dbg_show) (struct pinmux_dev *pmxdev, struct seq_file *s,
+			  unsigned offset);
+};
+
+/**
+ * struct pinmux_desc - pinmux descriptor, register this to pinmux subsystem
+ * @name: name for the pinmux
+ * @ops: pinmux operation table
+ * @owner: module providing the pinmux, used for refcounting
+ * @base: the number of the first pin handled by this pinmux, in the global
+ *	pin space, subtracted from a given pin to get the offset into the range
+ *	of a certain pinmux
+ * @npins: the number of pins handled by this pinmux - note that
+ *	this is the number of possible pin settings, if your driver handles
+ *	8 pins that each can be muxed in 3 different ways, you reserve 24
+ *	pins in the global pin space and set this to 24
+ */
+struct pinmux_desc {
+	const char *name;
+	struct pinmux_ops *ops;
+	struct module *owner;
+	int base;
+	int npins;
+};
+
+/**
+ * struct pinmux_dev - pinmux class device
+ * @desc: the descriptor supplied when initializing this pinmux
+ * @node: node to include this pinmux in the global pinmux list
+ * @dev: the device entry for this pinmux
+ * @owner: module providing the pinmux, used for refcounting
+ * @driver_data: driver data for drivers registering to the subsystem
+ *
+ * This should be dereferenced and used by the pinmux core ONLY
+ */
+struct pinmux_dev {
+	struct pinmux_desc *desc;
+	struct list_head node;
+	struct device dev;
+	struct module *owner;
+	void *driver_data;
+};
+
+
+/* These should only be used from drives */
+static inline const char *pmxdev_get_name(struct pinmux_dev *pmxdev)
+{
+	/* We're not allowed to register devices without name */
+	return pmxdev->desc->name;
+}
+
+static inline void *pmxdev_get_drvdata(struct pinmux_dev *pmxdev)
+{
+	return pmxdev->driver_data;
+}
+
+/* External interface to pinmux */
+extern int pinmux_request_gpio(int pin, unsigned gpio);
+extern void pinmux_free_gpio(int pin);
+extern int pinmux_register_mappings(struct pinmux_map const *map,
+				    unsigned num_maps);
+extern struct pinmux *pinmux_get(struct device *dev, const char *func);
+extern void pinmux_put(struct pinmux *pmx);
+extern int pinmux_enable(struct pinmux *pmx);
+extern void pinmux_disable(struct pinmux *pmx);
+extern int pinmux_config(struct pinmux *pmx, u16 param, unsigned long *data);
+extern struct pinmux_dev *pinmux_register(struct pinmux_desc *pmxdesc,
+				struct device *dev, void *driver_data);
+extern void pinmux_unregister(struct pinmux_dev *pmxdev);
+
+#else /* !CONFIG_PINMUX */
+
+static inline int pin_is_valid(int pin)
+{
+	return pin >= 0;
+}
+
+static inline int pinmux_request_gpio(int pin, unsigned gpio)
+{
+	return 0;
+}
+
+static inline void pinmux_free_gpio(int pin)
+{
+}
+
+static inline int pinmux_register_mappings(struct pinmux_map const *map,
+					   unsigned num_maps)
+{
+	return 0;
+}
+
+static inline struct pinmux *pimux_get(struct device *dev, const char *func)
+{
+	return NULL;
+}
+
+static inline void pinmux_put(struct pinmux *pmx)
+{
+}
+
+static inline int pinmux_enable(struct pinmux *pmx)
+{
+	return 0;
+}
+
+static inline void pinmux_disable(struct pinmux *pmx)
+{
+}
+
+static inline int pinmux_config(struct pinmux *pmx, u16 param,
+				unsigned long *data)
+{
+	return 0;
+}
+
+#endif /* CONFIG_PINMUX */
+
+#endif /* __LINUX_PINMUX_H */
-- 
1.7.5.1

