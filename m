Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1I1MEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:04:40 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:48434 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134Ab1I1MEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:04:37 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Stijn Devriendt <highguy@gmail.com>
Subject: [PATCH] drivers: create a pin control subsystem v8
Date: Wed, 28 Sep 2011 14:03:39 +0200
Message-ID: <1317211419-18472-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This creates a subsystem for handling of pin control devices.
These are devices that control different aspects of package
pins.

Currently it handles pinmuxing, i.e. assigning electronic
functions to groups of pins on primarily PGA and BGA type of
chip packages which are common in embedded systems.

The plan is to also handle other I/O pin control aspects
such as biasing, driving, input properties such as
schmitt-triggering, load capacitance etc within this
subsystem, to remove a lot of ARM arch code as well as
feature-creepy GPIO drivers which are implementing the same
thing over and over again.

This is being done to depopulate the arch/arm/* directory
of such custom drivers and try to abstract the infrastructure
they all need. See the Documentation/pinctrl.txt file that is
part of this patch for more details.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Stijn Devriendt <highguy@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Russell King <linux@arm.linux.org.uk>
Tested-by: Barry Song <21cnbao@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v7->v8:

- Delete the leftover pinmux_config() function from the
  <linux/pinctrl/pinmux.h> header.
- Fix a race condition found by Stijn Devriendt in pin_request()
---
 Documentation/ABI/testing/sysfs-class-pinmux |   11 +
 Documentation/pinctrl.txt                    |  951 +++++++++++++++++++++
 MAINTAINERS                                  |    5 +
 drivers/Kconfig                              |    4 +
 drivers/Makefile                             |    2 +
 drivers/pinctrl/Kconfig                      |   29 +
 drivers/pinctrl/Makefile                     |    6 +
 drivers/pinctrl/core.c                       |  632 ++++++++++++++
 drivers/pinctrl/core.h                       |   73 ++
 drivers/pinctrl/pinmux.c                     | 1179 ++++++++++++++++++++++++++
 drivers/pinctrl/pinmux.h                     |   47 +
 include/linux/pinctrl/machine.h              |  107 +++
 include/linux/pinctrl/pinctrl.h              |  133 +++
 include/linux/pinctrl/pinmux.h               |  117 +++
 14 files changed, 3296 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-pinmux
 create mode 100644 Documentation/pinctrl.txt
 create mode 100644 drivers/pinctrl/Kconfig
 create mode 100644 drivers/pinctrl/Makefile
 create mode 100644 drivers/pinctrl/core.c
 create mode 100644 drivers/pinctrl/core.h
 create mode 100644 drivers/pinctrl/pinmux.c
 create mode 100644 drivers/pinctrl/pinmux.h
 create mode 100644 include/linux/pinctrl/machine.h
 create mode 100644 include/linux/pinctrl/pinctrl.h
 create mode 100644 include/linux/pinctrl/pinmux.h

diff --git a/Documentation/ABI/testing/sysfs-class-pinmux b/Documentation/ABI/testing/sysfs-class-pinmux
new file mode 100644
index 0000000..c2ea843
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-pinmux
@@ -0,0 +1,11 @@
+What:		/sys/class/pinmux/.../name
+Date:		May 2011
+KernelVersion:	3.1
+Contact:	Linus Walleij <linus.walleij@linaro.org>
+Description:
+		Each pinmux directory will contain a field called
+		name. This holds a string identifying the pinmux for
+		display purposes.
+
+		NOTE: this will be empty if no suitable name is provided
+		by platform or pinmux drivers.
diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
new file mode 100644
index 0000000..2915fea
--- /dev/null
+++ b/Documentation/pinctrl.txt
@@ -0,0 +1,951 @@
+PINCTRL (PIN CONTROL) subsystem
+This document outlines the pin control subsystem in Linux
+
+This subsystem deals with:
+
+- Enumerating and naming controllable pins
+
+- Multiplexing of pins, pads, fingers (etc) see below for details
+
+The intention is to also deal with:
+
+- Software-controlled biasing and driving mode specific pins, such as
+  pull-up/down, open drain etc, load capacitance configuration when controlled
+  by software, etc.
+
+
+Top-level interface
+===================
+
+Definition of PIN CONTROLLER:
+
+- A pin controller is a piece of hardware, usually a set of registers, that
+  can control PINs. It may be able to multiplex, bias, set load capacitance,
+  set drive strength etc for individual pins or groups of pins.
+
+Definition of PIN:
+
+- PINS are equal to pads, fingers, balls or whatever packaging input or
+  output line you want to control and these are denoted by unsigned integers
+  in the range 0..maxpin. This numberspace is local to each PIN CONTROLLER, so
+  there may be several such number spaces in a system. This pin space may
+  be sparse - i.e. there may be gaps in the space with numbers where no
+  pin exists.
+
+When a PIN CONTROLLER is instatiated, it will register a descriptor to the
+pin control framework, and this descriptor contains an array of pin descriptors
+describing the pins handled by this specific pin controller.
+
+Here is an example of a PGA (Pin Grid Array) chip seen from underneath:
+
+        A   B   C   D   E   F   G   H
+
+   8    o   o   o   o   o   o   o   o
+
+   7    o   o   o   o   o   o   o   o
+
+   6    o   o   o   o   o   o   o   o
+
+   5    o   o   o   o   o   o   o   o
+
+   4    o   o   o   o   o   o   o   o
+
+   3    o   o   o   o   o   o   o   o
+
+   2    o   o   o   o   o   o   o   o
+
+   1    o   o   o   o   o   o   o   o
+
+To register a pin controller and name all the pins on this package we can do
+this in our driver:
+
+#include <linux/pinctrl/pinctrl.h>
+
+const struct pinctrl_pin_desc __refdata foo_pins[] = {
+      PINCTRL_PIN(0, "A1"),
+      PINCTRL_PIN(1, "A2"),
+      PINCTRL_PIN(2, "A3"),
+      ...
+      PINCTRL_PIN(61, "H6"),
+      PINCTRL_PIN(62, "H7"),
+      PINCTRL_PIN(63, "H8"),
+};
+
+static struct pinctrl_desc foo_desc = {
+	.name = "foo",
+	.pins = foo_pins,
+	.npins = ARRAY_SIZE(foo_pins),
+	.maxpin = 63,
+	.owner = THIS_MODULE,
+};
+
+int __init foo_probe(void)
+{
+	struct pinctrl_dev *pctl;
+
+	pctl = pinctrl_register(&foo_desc, <PARENT>, NULL);
+	if (IS_ERR(pctl))
+		pr_err("could not register foo pin driver\n");
+}
+
+Pins usually have fancier names than this. You can find these in the dataheet
+for your chip. Notice that the core pinctrl.h file provides a fancy macro
+called PINCTRL_PIN() to create the struct entries. As you can see I enumerated
+the pins from 0 in the upper left corner to 63 in the lower right corner,
+this enumeration was arbitrarily chosen, in practice you need to think
+through your numbering system so that it matches the layout of registers
+and such things in your driver, or the code may become complicated. You must
+also consider matching of offsets to the GPIO ranges that may be handled by
+the pin controller.
+
+For a padring with 467 pads, as opposed to actual pins, I used an enumeration
+like this, walking around the edge of the chip, which seems to be industry
+standard too (all these pads had names, too):
+
+
+     0 ..... 104
+   466        105
+     .        .
+     .        .
+   358        224
+    357 .... 225
+
+
+Pin groups
+==========
+
+Many controllers need to deal with groups of pins, so the pin controller
+subsystem has a mechanism for enumerating groups of pins and retrieving the
+actual enumerated pins that are part of a certain group.
+
+For example, say that we have a group of pins dealing with an SPI interface
+on { 0, 8, 16, 24 }, and a group of pins dealing with an I2C interface on pins
+on { 24, 25 }.
+
+These two groups are presented to the pin control subsystem by implementing
+some generic pinctrl_ops like this:
+
+#include <linux/pinctrl/pinctrl.h>
+
+struct foo_group {
+	const char *name;
+	const unsigned int *pins;
+	const unsigned num_pins;
+};
+
+static unsigned int spi0_pins[] = { 0, 8, 16, 24 };
+static unsigned int i2c0_pins[] = { 24, 25 };
+
+static const struct foo_group foo_groups[] = {
+	{
+		.name = "spi0_grp",
+		.pins = spi0_pins,
+		.num_pins = ARRAY_SIZE(spi0_pins),
+	},
+	{
+		.name = "i2c0_grp",
+		.pins = i2c0_pins,
+		.num_pins = ARRAY_SIZE(i2c0_pins),
+	},
+};
+
+
+static int foo_list_groups(struct pinctrl_dev *pctldev, unsigned selector)
+{
+	if (selector >= ARRAY_SIZE(foo_groups))
+		return -EINVAL;
+	return 0;
+}
+
+static const char *foo_get_group_name(struct pinctrl_dev *pctldev,
+				       unsigned selector)
+{
+	return foo_groups[selector].name;
+}
+
+static int foo_get_group_pins(struct pinctrl_dev *pctldev, unsigned selector,
+			       unsigned ** const pins,
+			       unsigned * const num_pins)
+{
+	*pins = (unsigned *) foo_groups[selector].pins;
+	*num_pins = foo_groups[selector].num_pins;
+	return 0;
+}
+
+static struct pinctrl_ops foo_pctrl_ops = {
+	.list_groups = foo_list_groups,
+	.get_group_name = foo_get_group_name,
+	.get_group_pins = foo_get_group_pins,
+};
+
+
+static struct pinctrl_desc foo_desc = {
+       ...
+       .pctlops = &foo_pctrl_ops,
+};
+
+The pin control subsystem will call the .list_groups() function repeatedly
+beginning on 0 until it returns non-zero to determine legal selectors, then
+it will call the other functions to retrieve the name and pins of the group.
+Maintaining the data structure of the groups is up to the driver, this is
+just a simple example - in practice you may need more entries in your group
+structure, for example specific register ranges associated with each group
+and so on.
+
+
+Interaction with the GPIO subsystem
+===================================
+
+The GPIO drivers may want to perform operations of various types on the same
+physical pins that are also registered as GPIO pins.
+
+Since the pin controller subsystem have its pinspace local to the pin
+controller we need a mapping so that the pin control subsystem can figure out
+which pin controller handles control of a certain GPIO pin. Since a single
+pin controller may be muxing several GPIO ranges (typically SoCs that have
+one set of pins but internally several GPIO silicon blocks, each modeled as
+a struct gpio_chip) any number of GPIO ranges can be added to a pin controller
+instance like this:
+
+struct gpio_chip chip_a;
+struct gpio_chip chip_b;
+
+static struct pinctrl_gpio_range gpio_range_a = {
+	.name = "chip a",
+	.id = 0,
+	.base = 32,
+	.npins = 16,
+	.gc = &chip_a;
+};
+
+static struct pinctrl_gpio_range gpio_range_a = {
+	.name = "chip b",
+	.id = 0,
+	.base = 48,
+	.npins = 8,
+	.gc = &chip_b;
+};
+
+
+{
+	struct pinctrl_dev *pctl;
+	...
+	pinctrl_add_gpio_range(pctl, &gpio_range_a);
+	pinctrl_add_gpio_range(pctl, &gpio_range_b);
+}
+
+So this complex system has one pin controller handling two different
+GPIO chips. Chip a has 16 pins and chip b has 8 pins. They are mapped in
+the global GPIO pin space at:
+
+chip a: [32 .. 47]
+chip b: [48 .. 55]
+
+When GPIO-specific functions in the pin control subsystem are called, these
+ranges will be used to look up the apropriate pin controller by inspecting
+and matching the pin to the pin ranges across all controllers. When a
+pin controller handling the matching range is found, GPIO-specific functions
+will be called on that specific pin controller.
+
+For all functionalities dealing with pin biasing, pin muxing etc, the pin
+controller subsystem will subtract the range's .base offset from the passed
+in gpio pin number, and pass that on to the pin control driver, so the driver
+will get an offset into its handled number range. Further it is also passed
+the range ID value, so that the pin controller knows which range it should
+deal with.
+
+For example: if a user issues pinctrl_gpio_set_foo(50), the pin control
+subsystem will find that the second range on this pin controller matches,
+subtract the base 48 and call the
+pinctrl_driver_gpio_set_foo(pinctrl, range, 2) where the latter function has
+this signature:
+
+int pinctrl_driver_gpio_set_foo(struct pinctrl_dev *pctldev,
+    struct pinctrl_gpio_range *rangeid,
+    unsigned offset);
+
+Now the driver knows that we want to do some GPIO-specific operation on the
+second GPIO range handled by "chip b", at offset 2 in that specific range.
+
+(If the GPIO subsystem is ever refactored to use a local per-GPIO controller
+pin space, this mapping will need to be augmented accordingly.)
+
+
+PINMUX interfaces
+=================
+
+These calls use the pinmux_* naming prefix.  No other calls should use that
+prefix.
+
+
+What is pinmuxing?
+==================
+
+PINMUX, also known as padmux, ballmux, alternate functions or mission modes
+is a way for chip vendors producing some kind of electrical packages to use
+a certain physical pin (ball, pad, finger, etc) for multiple mutually exclusive
+functions, depending on the application. By "application" in this context
+we usually mean a way of soldering or wiring the package into an electronic
+system, even though the framework makes it possible to also change the function
+at runtime.
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
+      +-------+-------+-------+---+---+
+   1  | o   o | o   o | o   o | o | o |
+      +-------+-------+-------+---+---+
+
+This is not tetris. The game to think of is chess. Not all PGA/BGA packages
+are chessboard-like, big ones have "holes" in some arrangement according to
+different design patterns, but we're using this as a simple example. Of the
+pins you see some will be taken by things like a few VCC and GND to feed power
+to the chip, and quite a few will be taken by large ports like an external
+memory interface. The remaining pins will often be subject to pin multiplexing.
+
+The example 8x8 PGA package above will have pin numbers 0 thru 63 assigned to
+its physical pins. It will name the pins { A1, A2, A3 ... H6, H7, H8 } using
+pinctrl_register_pins_[sparse|dense]() and a suitable data set as shown
+earlier.
+
+In this 8x8 BGA package the pins { A8, A7, A6, A5 } can be used as an SPI port
+(these are four pins: CLK, RXD, TXD, FRM). In that case, pin B5 can be used as
+some general-purpose GPIO pin. However, in another setting, pins { A5, B5 } can
+be used as an I2C port (these are just two pins: SCL, SDA). Needless to say,
+we cannot use the SPI port and I2C port at the same time. However in the inside
+of the package the silicon performing the SPI logic can alternatively be routed
+out on pins { G4, G3, G2, G1 }.
+
+On the botton row at { A1, B1, C1, D1, E1, F1, G1, H1 } we have something
+special - it's an external MMC bus that can be 2, 4 or 8 bits wide, and it will
+consume 2, 4 or 8 pins respectively, so either { A1, B1 } are taken or
+{ A1, B1, C1, D1 } or all of them. If we use all 8 bits, we cannot use the SPI
+port on pins { G4, G3, G2, G1 } of course.
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
+The purpose of the pinmux functionality in the pin controller subsystem is to
+abstract and provide pinmux settings to the devices you choose to instantiate
+in your machine configuration. It is inspired by the clk, GPIO and regulator
+subsystems, so devices will request their mux setting, but it's also possible
+to request a single pin for e.g. GPIO.
+
+Definitions:
+
+- FUNCTIONS can be switched in and out by a driver residing with the pin
+  control subsystem in the drivers/pinctrl/* directory of the kernel. The
+  pin control driver knows the possible functions. In the example above you can
+  identify three pinmux functions, one for spi, one for i2c and one for mmc.
+
+- FUNCTIONS are assumed to be enumerable from zero in a one-dimensional array.
+  In this case the array could be something like: { spi0, i2c0, mmc0 }
+  for the three available functions.
+
+- FUNCTIONS have PIN GROUPS as defined on the generic level - so a certain
+  function is *always* associated with a certain set of pin groups, could
+  be just a single one, but could also be many. In the example above the
+  function i2c is associated with the pins { A5, B5 }, enumerated as
+  { 24, 25 } in the controller pin space.
+
+  The Function spi is associated with pin groups { A8, A7, A6, A5 }
+  and { G4, G3, G2, G1 }, which are enumerated as { 0, 8, 16, 24 } and
+  { 38, 46, 54, 62 } respectively.
+
+  Group names must be unique per pin controller, no two groups on the same
+  controller may have the same name.
+
+- The combination of a FUNCTION and a PIN GROUP determine a certain function
+  for a certain set of pins. The knowledge of the functions and pin groups
+  and their machine-specific particulars are kept inside the pinmux driver,
+  from the outside only the enumerators are known, and the driver core can:
+
+  - Request the name of a function with a certain selector (>= 0)
+  - A list of groups associated with a certain function
+  - Request that a certain group in that list to be activated for a certain
+    function
+
+  As already described above, pin groups are in turn self-descriptive, so
+  the core will retrieve the actual pin range in a certain group from the
+  driver.
+
+- FUNCTIONS and GROUPS on a certain PIN CONTROLLER are MAPPED to a certain
+  device by the board file, device tree or similar machine setup configuration
+  mechanism, similar to how regulators are connected to devices, usually by
+  name. Defining a pin controller, function and group thus uniquely identify
+  the set of pins to be used by a certain device. (If only one possible group
+  of pins is available for the function, no group name need to be supplied -
+  the core will simply select the first and only group available.)
+
+  In the example case we can define that this particular machine shall
+  use device spi0 with pinmux function fspi0 group gspi0 and i2c0 on function
+  fi2c0 group gi2c0, on the primary pin controller, we get mappings
+  like these:
+
+  {
+    {"map-spi0", spi0, pinctrl0, fspi0, gspi0},
+    {"map-i2c0", i2c0, pinctrl0, fi2c0, gi2c0}
+  }
+
+  Every map must be assigned a symbolic name, pin controller and function.
+  The group is not compulsory - if it is omitted the first group presented by
+  the driver as applicable for the function will be selected, which is
+  useful for simple cases.
+
+  The device name is present in map entries tied to specific devices. Maps
+  without device names are referred to as SYSTEM pinmuxes, such as can be taken
+  by the machine implementation on boot and not tied to any specific device.
+
+  It is possible to map several groups to the same combination of device,
+  pin controller and function. This is for cases where a certain function on
+  a certain pin controller may use different sets of pins in different
+  configurations.
+
+- PINS for a certain FUNCTION using a certain PIN GROUP on a certain
+  PIN CONTROLLER are provided on a first-come first-serve basis, so if some
+  other device mux setting or GPIO pin request has already taken your physical
+  pin, you will be denied the use of it. To get (activate) a new setting, the
+  old one has to be put (deactivated) first.
+
+Sometimes the documentation and hardware registers will be oriented around
+pads (or "fingers") rather than pins - these are the soldering surfaces on the
+silicon inside the package, and may or may not match the actual number of
+pins/balls underneath the capsule. Pick some enumeration that makes sense to
+you. Define enumerators only for the pins you can control if that makes sense.
+
+Assumptions:
+
+We assume that the number possible function maps to pin groups is limited by
+the hardware. I.e. we assume that there is no system where any function can be
+mapped to any pin, like in a phone exchange. So the available pins groups for
+a certain function will be limited to a few choices (say up to eight or so),
+not hundreds or any amount of choices. This is the characteristic we have found
+by inspecting available pinmux hardware, and a necessary assumption since we
+expect pinmux drivers to present *all* possible function vs pin group mappings
+to the subsystem.
+
+
+Pinmux drivers
+==============
+
+The pinmux core takes care of preventing conflicts on pins and calling
+the pin controller driver to execute different settings.
+
+It is the responsibility of the pinmux driver to impose further restrictions
+(say for example infer electronic limitations due to load etc) to determine
+whether or not the requested function can actually be allowed, and in case it
+is possible to perform the requested mux setting, poke the hardware so that
+this happens.
+
+Pinmux drivers are required to supply a few callback functions, some are
+optional. Usually the enable() and disable() functions are implemented,
+writing values into some certain registers to activate a certain mux setting
+for a certain pin.
+
+A simple driver for the above example will work by setting bits 0, 1, 2, 3 or 4
+into some register named MUX to select a certain function with a certain
+group of pins would work something like this:
+
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+
+struct foo_group {
+	const char *name;
+	const unsigned int *pins;
+	const unsigned num_pins;
+};
+
+static const unsigned spi0_0_pins[] = { 0, 8, 16, 24 };
+static const unsigned spi0_1_pins[] = { 38, 46, 54, 62 };
+static const unsigned i2c0_pins[] = { 24, 25 };
+static const unsigned mmc0_1_pins[] = { 56, 57 };
+static const unsigned mmc0_2_pins[] = { 58, 59 };
+static const unsigned mmc0_3_pins[] = { 60, 61, 62, 63 };
+
+static const struct foo_group foo_groups[] = {
+	{
+		.name = "spi0_0_grp",
+		.pins = spi0_0_pins,
+		.num_pins = ARRAY_SIZE(spi0_0_pins),
+	},
+	{
+		.name = "spi0_1_grp",
+		.pins = spi0_1_pins,
+		.num_pins = ARRAY_SIZE(spi0_1_pins),
+	},
+	{
+		.name = "i2c0_grp",
+		.pins = i2c0_pins,
+		.num_pins = ARRAY_SIZE(i2c0_pins),
+	},
+	{
+		.name = "mmc0_1_grp",
+		.pins = mmc0_1_pins,
+		.num_pins = ARRAY_SIZE(mmc0_1_pins),
+	},
+	{
+		.name = "mmc0_2_grp",
+		.pins = mmc0_2_pins,
+		.num_pins = ARRAY_SIZE(mmc0_2_pins),
+	},
+	{
+		.name = "mmc0_3_grp",
+		.pins = mmc0_3_pins,
+		.num_pins = ARRAY_SIZE(mmc0_3_pins),
+	},
+};
+
+
+static int foo_list_groups(struct pinctrl_dev *pctldev, unsigned selector)
+{
+	if (selector >= ARRAY_SIZE(foo_groups))
+		return -EINVAL;
+	return 0;
+}
+
+static const char *foo_get_group_name(struct pinctrl_dev *pctldev,
+				       unsigned selector)
+{
+	return foo_groups[selector].name;
+}
+
+static int foo_get_group_pins(struct pinctrl_dev *pctldev, unsigned selector,
+			       unsigned ** const pins,
+			       unsigned * const num_pins)
+{
+	*pins = (unsigned *) foo_groups[selector].pins;
+	*num_pins = foo_groups[selector].num_pins;
+	return 0;
+}
+
+static struct pinctrl_ops foo_pctrl_ops = {
+	.list_groups = foo_list_groups,
+	.get_group_name = foo_get_group_name,
+	.get_group_pins = foo_get_group_pins,
+};
+
+struct foo_pmx_func {
+	const char *name;
+	const char * const *groups;
+	const unsigned num_groups;
+};
+
+static const char * const spi0_groups[] = { "spi0_1_grp" };
+static const char * const i2c0_groups[] = { "i2c0_grp" };
+static const char * const mmc0_groups[] = { "mmc0_1_grp", "mmc0_2_grp",
+					"mmc0_3_grp" };
+
+static const struct foo_pmx_func foo_functions[] = {
+	{
+		.name = "spi0",
+		.groups = spi0_groups,
+		.num_groups = ARRAY_SIZE(spi0_groups),
+	},
+	{
+		.name = "i2c0",
+		.groups = i2c0_groups,
+		.num_groups = ARRAY_SIZE(i2c0_groups),
+	},
+	{
+		.name = "mmc0",
+		.groups = mmc0_groups,
+		.num_groups = ARRAY_SIZE(mmc0_groups),
+	},
+};
+
+int foo_list_funcs(struct pinctrl_dev *pctldev, unsigned selector)
+{
+	if (selector >= ARRAY_SIZE(foo_functions))
+		return -EINVAL;
+	return 0;
+}
+
+const char *foo_get_fname(struct pinctrl_dev *pctldev, unsigned selector)
+{
+	return myfuncs[selector].name;
+}
+
+static int foo_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
+			  const char * const **groups,
+			  unsigned * const num_groups)
+{
+	*groups = foo_functions[selector].groups;
+	*num_groups = foo_functions[selector].num_groups;
+	return 0;
+}
+
+int foo_enable(struct pinctrl_dev *pctldev, unsigned selector,
+		unsigned group)
+{
+	u8 regbit = (1 << group);
+
+	writeb((readb(MUX)|regbit), MUX)
+	return 0;
+}
+
+int foo_disable(struct pinctrl_dev *pctldev, unsigned selector,
+		unsigned group)
+{
+	u8 regbit = (1 << group);
+
+	writeb((readb(MUX) & ~(regbit)), MUX)
+	return 0;
+}
+
+struct pinmux_ops foo_pmxops = {
+	.list_functions = foo_list_funcs,
+	.get_function_name = foo_get_fname,
+	.get_function_groups = foo_get_groups,
+	.enable = foo_enable,
+	.disable = foo_disable,
+};
+
+/* Pinmux operations are handled by some pin controller */
+static struct pinctrl_desc foo_desc = {
+	...
+	.pctlops = &foo_pctrl_ops,
+	.pmxops = &foo_pmxops,
+};
+
+In the example activating muxing 0 and 1 at the same time setting bits
+0 and 1, uses one pin in common so they would collide.
+
+The beauty of the pinmux subsystem is that since it keeps track of all
+pins and who is using them, it will already have denied an impossible
+request like that, so the driver does not need to worry about such
+things - when it gets a selector passed in, the pinmux subsystem makes
+sure no other device or GPIO assignment is already using the selected
+pins. Thus bits 0 and 1 in the control register will never be set at the
+same time.
+
+All the above functions are mandatory to implement for a pinmux driver.
+
+
+Pinmux interaction with the GPIO subsystem
+==========================================
+
+The function list could become long, especially if you can convert every
+individual pin into a GPIO pin independent of any other pins, and then try
+the approach to define every pin as a function.
+
+In this case, the function array would become 64 entries for each GPIO
+setting and then the device functions.
+
+For this reason there is an additional function a pinmux driver can implement
+to enable only GPIO on an individual pin: .gpio_request_enable(). The same
+.free() function as for other functions is assumed to be usable also for
+GPIO pins.
+
+This function will pass in the affected GPIO range identified by the pin
+controller core, so you know which GPIO pins are being affected by the request
+operation.
+
+Alternatively it is fully allowed to use named functions for each GPIO
+pin, the pinmux_request_gpio() will attempt to obtain the function "gpioN"
+where "N" is the global GPIO pin number if no special GPIO-handler is
+registered.
+
+
+Pinmux board/machine configuration
+==================================
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
+#include <linux/pinctrl/machine.h>
+
+static struct pinmux_map pmx_mapping[] = {
+	{
+		.ctrl_dev_name = "pinctrl.0",
+		.function = "spi0",
+		.dev_name = "foo-spi.0",
+	},
+	{
+		.ctrl_dev_name = "pinctrl.0",
+		.function = "i2c0",
+		.dev_name = "foo-i2c.0",
+	},
+	{
+		.ctrl_dev_name = "pinctrl.0",
+		.function = "mmc0",
+		.dev_name = "foo-mmc.0",
+	},
+};
+
+The dev_name here matches to the unique device name that can be used to look
+up the device struct (just like with clockdev or regulators). The function name
+must match a function provided by the pinmux driver handling this pin range.
+
+As you can see we may have several pin controllers on the system and thus
+we need to specify which one of them that contain the functions we wish
+to map. The map can also use struct device * directly, so there is no
+inherent need to use strings to specify .dev_name or .ctrl_dev_name, these
+are for the situation where you do not have a handle to the struct device *,
+for example if they are not yet instantiated or cumbersome to obtain.
+
+You register this pinmux mapping to the pinmux subsystem by simply:
+
+       ret = pinmux_register_mappings(&pmx_mapping, ARRAY_SIZE(pmx_mapping));
+
+Since the above construct is pretty common there is a helper macro to make
+it even more compact which assumes you want to use pinctrl.0 and position
+0 for mapping, for example:
+
+static struct pinmux_map pmx_mapping[] = {
+       PINMUX_MAP_PRIMARY("I2CMAP", "i2c0", "foo-i2c.0"),
+};
+
+
+Complex mappings
+================
+
+As it is possible to map a function to different groups of pins an optional
+.group can be specified like this:
+
+...
+{
+	.name = "spi0-pos-A",
+	.ctrl_dev_name = "pinctrl.0",
+	.function = "spi0",
+	.group = "spi0_0_grp",
+	.dev_name = "foo-spi.0",
+},
+{
+	.name = "spi0-pos-B",
+	.ctrl_dev_name = "pinctrl.0",
+	.function = "spi0",
+	.group = "spi0_1_grp",
+	.dev_name = "foo-spi.0",
+},
+...
+
+This example mapping is used to switch between two positions for spi0 at
+runtime, as described further below under the heading "Runtime pinmuxing".
+
+Further it is possible to match several groups of pins to the same function
+for a single device, say for example in the mmc0 example above, where you can
+additively expand the mmc0 bus from 2 to 4 to 8 pins. If we want to use all
+three groups for a total of 2+2+4 = 8 pins (for an 8-bit MMC bus as is the
+case), we define a mapping like this:
+
+...
+{
+	.name "2bit"
+	.ctrl_dev_name = "pinctrl.0",
+	.function = "mmc0",
+	.group = "mmc0_0_grp",
+	.dev_name = "foo-mmc.0",
+},
+{
+	.name "4bit"
+	.ctrl_dev_name = "pinctrl.0",
+	.function = "mmc0",
+	.group = "mmc0_0_grp",
+	.dev_name = "foo-mmc.0",
+},
+{
+	.name "4bit"
+	.ctrl_dev_name = "pinctrl.0",
+	.function = "mmc0",
+	.group = "mmc0_1_grp",
+	.dev_name = "foo-mmc.0",
+},
+{
+	.name "8bit"
+	.ctrl_dev_name = "pinctrl.0",
+	.function = "mmc0",
+	.group = "mmc0_0_grp",
+	.dev_name = "foo-mmc.0",
+},
+{
+	.name "8bit"
+	.ctrl_dev_name = "pinctrl.0",
+	.function = "mmc0",
+	.group = "mmc0_1_grp",
+	.dev_name = "foo-mmc.0",
+},
+{
+	.name "8bit"
+	.ctrl_dev_name = "pinctrl.0",
+	.function = "mmc0",
+	.group = "mmc0_2_grp",
+	.dev_name = "foo-mmc.0",
+},
+...
+
+The result of grabbing this mapping from the device with something like
+this (see next paragraph):
+
+	pmx = pinmux_get(&device, "8bit");
+
+Will be that you activate all the three bottom records in the mapping at
+once. Since they share the same name, pin controller device, funcion and
+device, and since we allow multiple groups to match to a single device, they
+all get selected, and they all get enabled and disable simultaneously by the
+pinmux core.
+
+
+Pinmux requests from drivers
+============================
+
+Generally it is discouraged to let individual drivers get and enable pinmuxes.
+So if possible, handle the pinmuxes in platform code or some other place where
+you have access to all the affected struct device * pointers. In some cases
+where a driver needs to switch between different mux mappings at runtime
+this is not possible.
+
+A driver may request a certain mux to be activated, usually just the default
+mux like this:
+
+#include <linux/pinctrl/pinmux.h>
+
+struct foo_state {
+       struct pinmux *pmx;
+       ...
+};
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
+If you want to grab a specific mux mapping and not just the first one found for
+this device you can specify a specific mapping name, for example in the above
+example the second i2c0 setting: pinmux_get(&device, "spi0-pos-B");
+
+This get/enable/disable/put sequence can just as well be handled by bus drivers
+if you don't want each and every driver to handle it and you know the
+arrangement on your bus.
+
+The semantics of the get/enable respective disable/put is as follows:
+
+- pinmux_get() is called in process context to reserve the pins affected with
+  a certain mapping and set up the pinmux core and the driver. It will allocate
+  a struct from the kernel memory to hold the pinmux state.
+
+- pinmux_enable()/pinmux_disable() is quick and can be called from fastpath
+  (irq context) when you quickly want to set up/tear down the hardware muxing
+  when running a device driver. Usually it will just poke some values into a
+  register.
+
+- pinmux_disable() is called in process context to tear down the pin requests
+  and release the state holder struct for the mux setting.
+
+Usually the pinmux core handled the get/put pair and call out to the device
+drivers bookkeeping operations, like checking available functions and the
+associated pins, whereas the enable/disable pass on to the pin controller
+driver which takes care of activating and/or deactivating the mux setting by
+quickly poking some registers.
+
+The pins are allocated for your device when you issue the pinmux_get() call,
+after this you should be able to see this in the debugfs listing of all pins.
+
+
+System pinmux hogging
+=====================
+
+A system pinmux map entry, i.e. a pinmux setting that does not have a device
+associated with it, can be hogged by the core when the pin controller is
+registered. This means that the core will attempt to call regulator_get() and
+regulator_enable() on it immediately after the pin control device has been
+registered.
+
+This is enabled by simply setting the .hog_on_boot field in the map to true,
+like this:
+
+{
+	.name "POWERMAP"
+	.ctrl_dev_name = "pinctrl.0",
+	.function = "power_func",
+	.hog_on_boot = true,
+},
+
+Since it may be common to request the core to hog a few always-applicable
+mux settings on the primary pin controller, there is a convenience macro for
+this:
+
+PINMUX_MAP_PRIMARY_SYS_HOG("POWERMAP", "power_func")
+
+This gives the exact same result as the above construction.
+
+
+Runtime pinmuxing
+=================
+
+It is possible to mux a certain function in and out at runtime, say to move
+an SPI port from one set of pins to another set of pins. Say for example for
+spi0 in the example above, we expose two different groups of pins for the same
+function, but with different named in the mapping as described under
+"Advanced mapping" above. So we have two mappings named "spi0-pos-A" and
+"spi0-pos-B".
+
+This snippet first muxes the function in the pins defined by group A, enables
+it, disables and releases it, and muxes it in on the pins defined by group B:
+
+foo_switch()
+{
+	struct pinmux pmx;
+
+	/* Enable on position A */
+	pmx = pinmux_get(&device, "spi0-pos-A");
+	if IS_ERR(pmx)
+		return PTR_ERR(pmx);
+	pinmux_enable(pmx);
+
+	/* This releases the pins again */
+	pinmux_disable(pmx);
+	pinmux_put(pmx);
+
+	/* Enable on position B */
+	pmx = pinmux_get(&device, "spi0-pos-B");
+	if IS_ERR(pmx)
+		return PTR_ERR(pmx);
+	pinmux_enable(pmx);
+	...
+}
+
+The above has to be done from process context.
diff --git a/MAINTAINERS b/MAINTAINERS
index ae8820e..d9212b7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5010,6 +5010,11 @@ L:	linux-mtd@lists.infradead.org
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
index 95b9e7e..40d3e16 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -56,6 +56,10 @@ source "drivers/pps/Kconfig"
 
 source "drivers/ptp/Kconfig"
 
+# pinctrl before gpio - gpio drivers may need it
+
+source "drivers/pinctrl/Kconfig"
+
 source "drivers/gpio/Kconfig"
 
 source "drivers/w1/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 7fa433a..e7afb3a 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -5,6 +5,8 @@
 # Rewritten to use lists instead of if-statements.
 #
 
+# GPIO must come after pinctrl as gpios may need to mux pins etc
+obj-y				+= pinctrl/
 obj-y				+= gpio/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
new file mode 100644
index 0000000..7fa0fe0
--- /dev/null
+++ b/drivers/pinctrl/Kconfig
@@ -0,0 +1,29 @@
+#
+# PINCTRL infrastructure and drivers
+#
+
+menuconfig PINCTRL
+	bool "PINCTRL Support"
+	depends on SYSFS && EXPERIMENTAL
+	help
+	  This enables the PINCTRL subsystem for controlling pins
+	  on chip packages, for example multiplexing pins on primarily
+	  PGA and BGA packages for systems on chip.
+
+	  If unsure, say N.
+
+if PINCTRL
+
+config PINMUX
+	bool "Support pinmux controllers"
+	help
+	  Say Y here if you want the pincontrol subsystem to handle pin
+	  multiplexing drivers.
+
+config DEBUG_PINCTRL
+	bool "Debug PINCTRL calls"
+	depends on DEBUG_KERNEL
+	help
+	  Say Y here to add some extra checks and diagnostics to PINCTRL calls.
+
+endif
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
new file mode 100644
index 0000000..596ce9f
--- /dev/null
+++ b/drivers/pinctrl/Makefile
@@ -0,0 +1,6 @@
+# generic pinmux support
+
+ccflags-$(CONFIG_DEBUG_PINMUX)	+= -DDEBUG
+
+obj-$(CONFIG_PINCTRL)		+= core.o
+obj-$(CONFIG_PINMUX)		+= pinmux.o
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
new file mode 100644
index 0000000..4229628
--- /dev/null
+++ b/drivers/pinctrl/core.c
@@ -0,0 +1,632 @@
+/*
+ * Core driver for the pin control subsystem
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * Based on bits of regulator core, gpio core and clk core
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#define pr_fmt(fmt) "pinctrl core: " fmt
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/radix-tree.h>
+#include <linux/err.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/sysfs.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/machine.h>
+#include "core.h"
+#include "pinmux.h"
+
+/* Global list of pin control devices */
+static DEFINE_MUTEX(pinctrldev_list_mutex);
+static LIST_HEAD(pinctrldev_list);
+
+/* sysfs interaction */
+static ssize_t pinctrl_name_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct pinctrl_dev *pctldev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", pctldev_get_name(pctldev));
+}
+
+static void pinctrl_dev_release(struct device *dev)
+{
+	struct pinctrl_dev *pctldev = dev_get_drvdata(dev);
+	kfree(pctldev);
+}
+
+static DEVICE_ATTR(name, S_IRUGO, pinctrl_name_show, NULL);
+
+static struct attribute *pinctrl_dev_attrs[] = {
+	&dev_attr_name.attr,
+	NULL
+};
+
+static struct attribute_group pinctrl_dev_attr_group = {
+	.attrs = pinctrl_dev_attrs,
+};
+
+static const struct attribute_group *pinctrl_dev_attr_groups[] = {
+	&pinctrl_dev_attr_group,
+	NULL
+};
+
+static struct bus_type pinctrl_bus = {
+	.name = "pinctrl",
+};
+
+static struct device_type pinctrl_type = {
+	.groups = pinctrl_dev_attr_groups,
+	.release = pinctrl_dev_release,
+};
+
+const char *pctldev_get_name(struct pinctrl_dev *pctldev)
+{
+	/* We're not allowed to register devices without name */
+	return pctldev->desc->name;
+}
+EXPORT_SYMBOL_GPL(pctldev_get_name);
+
+void *pctldev_get_drvdata(struct pinctrl_dev *pctldev)
+{
+	return pctldev->driver_data;
+}
+EXPORT_SYMBOL_GPL(pctldev_get_drvdata);
+
+/**
+ * Looks up a pin control device matching a certain device name or
+ * pure device pointer.
+ */
+struct pinctrl_dev *get_pctldev_from_dev(struct device *dev,
+					 const char *devname)
+{
+	struct pinctrl_dev *pctldev = NULL;
+	bool found = false;
+
+	mutex_lock(&pinctrldev_list_mutex);
+	list_for_each_entry(pctldev, &pinctrldev_list, node) {
+		if (dev &&  &pctldev->dev == dev) {
+			/* Matched on device pointer */
+			found = true;
+			break;
+		}
+
+		if (devname &&
+		    !strcmp(dev_name(&pctldev->dev), devname)) {
+			/* Matched on device name */
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&pinctrldev_list_mutex);
+
+	if (found)
+		return pctldev;
+
+	return NULL;
+}
+
+struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, int pin)
+{
+	struct pin_desc *pindesc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pctldev->pin_desc_tree_lock, flags);
+	pindesc = radix_tree_lookup(&pctldev->pin_desc_tree, pin);
+	spin_unlock_irqrestore(&pctldev->pin_desc_tree_lock, flags);
+
+	return pindesc;
+}
+
+/**
+ * Tell us whether a certain pin exist on a certain pin controller
+ * or not. Pin lists may be sparse, so some pins may not exist.
+ * @pctldev: the pin control device to check the pin on
+ * @pin: pin to check, use the local pin controller index number
+ */
+bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
+{
+	struct pin_desc *pindesc;
+
+	if (pin < 0)
+		return false;
+
+	pindesc = pin_desc_get(pctldev, pin);
+	if (pindesc == NULL)
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(pin_is_valid);
+
+/* Deletes a range of pin descriptors */
+static void pinctrl_free_pindescs(struct pinctrl_dev *pctldev,
+				  const struct pinctrl_pin_desc *pins,
+				  unsigned num_pins)
+{
+	int i;
+
+	spin_lock(&pctldev->pin_desc_tree_lock);
+	for (i = 0; i < num_pins; i++) {
+		struct pin_desc *pindesc;
+
+		pindesc = radix_tree_lookup(&pctldev->pin_desc_tree,
+					    pins[i].number);
+		if (pindesc != NULL) {
+			radix_tree_delete(&pctldev->pin_desc_tree,
+					  pins[i].number);
+		}
+		kfree(pindesc);
+	}
+	spin_unlock(&pctldev->pin_desc_tree_lock);
+}
+
+static int pinctrl_register_one_pin(struct pinctrl_dev *pctldev,
+				    unsigned number, const char *name)
+{
+	struct pin_desc *pindesc;
+
+	pindesc = pin_desc_get(pctldev, number);
+	if (pindesc != NULL) {
+		pr_err("pin %d already registered on %s\n", number,
+		       pctldev->desc->name);
+		return -EINVAL;
+	}
+
+	pindesc = kzalloc(sizeof(*pindesc), GFP_KERNEL);
+	if (pindesc == NULL)
+		return -ENOMEM;
+	spin_lock_init(&pindesc->lock);
+
+	/* Set owner */
+	pindesc->pctldev = pctldev;
+
+	/* Copy optional basic pin info */
+	if (name)
+		strlcpy(pindesc->name, name, sizeof(pindesc->name));
+
+	spin_lock(&pctldev->pin_desc_tree_lock);
+	radix_tree_insert(&pctldev->pin_desc_tree, number, pindesc);
+	spin_unlock(&pctldev->pin_desc_tree_lock);
+	pr_debug("registered pin %d (%s) on %s\n",
+		 number, name ? name : "(unnamed)", pctldev->desc->name);
+	return 0;
+}
+
+static int pinctrl_register_pins(struct pinctrl_dev *pctldev,
+				 struct pinctrl_pin_desc const *pins,
+				 unsigned num_descs)
+{
+	unsigned i;
+	int ret = 0;
+
+	for (i = 0; i < num_descs; i++) {
+		ret = pinctrl_register_one_pin(pctldev,
+					       pins[i].number, pins[i].name);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * pinctrl_match_gpio_range() - check if a certain GPIO pin is in the range of
+ * a certain pin controller, return the range or NULL
+ */
+static struct pinctrl_gpio_range *
+pinctrl_match_gpio_range(struct pinctrl_dev *pctldev, unsigned gpio)
+{
+	struct pinctrl_gpio_range *range = NULL;
+
+	/* Loop over the ranges */
+	mutex_lock(&pctldev->gpio_ranges_lock);
+	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
+		/* Check if we're in the valid range */
+		if (gpio >= range->base &&
+		    gpio < range->base + range->npins) {
+			mutex_unlock(&pctldev->gpio_ranges_lock);
+			return range;
+		}
+	}
+	mutex_unlock(&pctldev->gpio_ranges_lock);
+
+	return NULL;
+}
+
+/**
+ * pinctrl_get_device_gpio_range() - find the pin controller handling a certain
+ * pin from the pinspace in the GPIO subsystem, return the device and the
+ * matching GPIO range. Returns negative if the GPIO range could not be found
+ * in any device
+ * @gpio: the pin to locate the pin controller for
+ * @outdev: the pin control device if found
+ * @outrange: the GPIO range if found
+ */
+int pinctrl_get_device_gpio_range(unsigned gpio,
+				struct pinctrl_dev **outdev,
+				struct pinctrl_gpio_range **outrange)
+{
+	struct pinctrl_dev *pctldev = NULL;
+
+	/* Loop over the pin controllers */
+	mutex_lock(&pinctrldev_list_mutex);
+	list_for_each_entry(pctldev, &pinctrldev_list, node) {
+		struct pinctrl_gpio_range *range;
+
+		range = pinctrl_match_gpio_range(pctldev, gpio);
+		if (range != NULL) {
+			*outdev = pctldev;
+			*outrange = range;
+			return 0;
+		}
+	}
+	mutex_unlock(&pinctrldev_list_mutex);
+
+	return -EINVAL;
+}
+
+/**
+ * pinctrl_add_gpio_range() - this adds a range of GPIOs to be handled
+ * by a certain pin controller. Call this to register handled ranges after
+ * registering your pin controller.
+ * @pctldev: pin controller device to add the range to
+ * @range: the GPIO range to add
+ */
+void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
+			    struct pinctrl_gpio_range *range)
+{
+	mutex_lock(&pctldev->gpio_ranges_lock);
+	list_add(&range->node, &pctldev->gpio_ranges);
+	mutex_unlock(&pctldev->gpio_ranges_lock);
+}
+
+/**
+ * pinctrl_remove_gpio_range() - removes a range of GPIOs fro a pin controller
+ * @pctldev: pin controller device to remove the range from
+ * @range: the GPIO range to remove
+ */
+void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
+			       struct pinctrl_gpio_range *range)
+{
+	mutex_lock(&pctldev->gpio_ranges_lock);
+	list_del(&range->node);
+	mutex_unlock(&pctldev->gpio_ranges_lock);
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+static int pinctrl_pins_show(struct seq_file *s, void *what)
+{
+	struct pinctrl_dev *pctldev = s->private;
+	const struct pinctrl_ops *ops = pctldev->desc->pctlops;
+	unsigned pin;
+
+	seq_printf(s, "registered pins: %d\n", pctldev->desc->npins);
+	seq_printf(s, "max pin number: %d\n", pctldev->desc->maxpin);
+
+	/* The highest pin number need to be included in the loop, thus <= */
+	for (pin = 0; pin <= pctldev->desc->maxpin; pin++) {
+		struct pin_desc *desc;
+
+		desc = pin_desc_get(pctldev, pin);
+		/* Pin space may be sparse */
+		if (desc == NULL)
+			continue;
+
+		seq_printf(s, "pin %d (%s) ", pin,
+			   desc->name ? desc->name : "unnamed");
+
+		/* Driver-specific info per pin */
+		if (ops->pin_dbg_show)
+			ops->pin_dbg_show(pctldev, s, pin);
+
+		seq_puts(s, "\n");
+	}
+
+	return 0;
+}
+
+static int pinctrl_groups_show(struct seq_file *s, void *what)
+{
+	struct pinctrl_dev *pctldev = s->private;
+	const struct pinctrl_ops *ops = pctldev->desc->pctlops;
+	unsigned selector = 0;
+
+	/* No grouping */
+	if (!ops)
+		return 0;
+
+	seq_puts(s, "registered pin groups:\n");
+	while (ops->list_groups(pctldev, selector) >= 0) {
+		unsigned *pins;
+		unsigned num_pins;
+		const char *gname = ops->get_group_name(pctldev, selector);
+		int ret;
+		int i;
+
+		ret = ops->get_group_pins(pctldev, selector,
+					  &pins, &num_pins);
+		if (ret)
+			seq_printf(s, "%s [ERROR GETTING PINS]\n",
+				   gname);
+		else {
+			seq_printf(s, "group: %s, pins = [ ", gname);
+			for (i = 0; i < num_pins; i++)
+				seq_printf(s, "%d ", pins[i]);
+			seq_puts(s, "]\n");
+		}
+		selector++;
+	}
+
+
+	return 0;
+}
+
+static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
+{
+	struct pinctrl_dev *pctldev = s->private;
+	struct pinctrl_gpio_range *range = NULL;
+
+	seq_puts(s, "GPIO ranges handled:\n");
+
+	/* Loop over the ranges */
+	mutex_lock(&pctldev->gpio_ranges_lock);
+	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
+		seq_printf(s, "%u: %s [%u - %u]\n", range->id, range->name,
+			   range->base, (range->base + range->npins - 1));
+	}
+	mutex_unlock(&pctldev->gpio_ranges_lock);
+
+	return 0;
+}
+
+static int pinctrl_devices_show(struct seq_file *s, void *what)
+{
+	struct pinctrl_dev *pctldev;
+
+	seq_puts(s, "name [pinmux]\n");
+	mutex_lock(&pinctrldev_list_mutex);
+	list_for_each_entry(pctldev, &pinctrldev_list, node) {
+		seq_printf(s, "%s ", pctldev->desc->name);
+		if (pctldev->desc->pmxops)
+			seq_puts(s, "yes");
+		else
+			seq_puts(s, "no");
+		seq_puts(s, "\n");
+	}
+	mutex_unlock(&pinctrldev_list_mutex);
+
+	return 0;
+}
+
+static int pinctrl_pins_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinctrl_pins_show, inode->i_private);
+}
+
+static int pinctrl_groups_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinctrl_groups_show, inode->i_private);
+}
+
+static int pinctrl_gpioranges_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinctrl_gpioranges_show, inode->i_private);
+}
+
+static int pinctrl_devices_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinctrl_devices_show, NULL);
+}
+
+static const struct file_operations pinctrl_pins_ops = {
+	.open		= pinctrl_pins_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations pinctrl_groups_ops = {
+	.open		= pinctrl_groups_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations pinctrl_gpioranges_ops = {
+	.open		= pinctrl_gpioranges_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations pinctrl_devices_ops = {
+	.open		= pinctrl_devices_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static struct dentry *debugfs_root;
+
+static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
+{
+	static struct dentry *device_root;
+
+	device_root = debugfs_create_dir(dev_name(&pctldev->dev),
+					 debugfs_root);
+	if (IS_ERR(device_root) || !device_root) {
+		pr_warn("failed to create debugfs directory for %s\n",
+			dev_name(&pctldev->dev));
+		return;
+	}
+	debugfs_create_file("pins", S_IFREG | S_IRUGO,
+			    device_root, pctldev, &pinctrl_pins_ops);
+	debugfs_create_file("pingroups", S_IFREG | S_IRUGO,
+			    device_root, pctldev, &pinctrl_groups_ops);
+	debugfs_create_file("gpio-ranges", S_IFREG | S_IRUGO,
+			    device_root, pctldev, &pinctrl_gpioranges_ops);
+	pinmux_init_device_debugfs(device_root, pctldev);
+}
+
+static void pinctrl_init_debugfs(void)
+{
+	debugfs_root = debugfs_create_dir("pinctrl", NULL);
+	if (IS_ERR(debugfs_root) || !debugfs_root) {
+		pr_warn("failed to create debugfs directory\n");
+		debugfs_root = NULL;
+		return;
+	}
+
+	debugfs_create_file("pinctrl-devices", S_IFREG | S_IRUGO,
+			    debugfs_root, NULL, &pinctrl_devices_ops);
+	pinmux_init_debugfs(debugfs_root);
+}
+
+#else /* CONFIG_DEBUG_FS */
+
+static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
+{
+}
+
+static void pinctrl_init_debugfs(void)
+{
+}
+
+#endif
+
+/**
+ * pinctrl_register() - register a pin controller device
+ * @pctldesc: descriptor for this pin controller
+ * @dev: parent device for this pin controller
+ * @driver_data: private pin controller data for this pin controller
+ */
+struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
+				    struct device *dev, void *driver_data)
+{
+	static atomic_t pinmux_no = ATOMIC_INIT(0);
+	struct pinctrl_dev *pctldev;
+	int ret;
+
+	if (pctldesc == NULL)
+		return ERR_PTR(-EINVAL);
+	if (pctldesc->name == NULL)
+		return ERR_PTR(-EINVAL);
+
+	/* If we're implementing pinmuxing, check the ops for sanity */
+	if (pctldesc->pmxops) {
+		ret = pinmux_check_ops(pctldesc->pmxops);
+		if (ret) {
+			pr_err("%s pinmux ops lacks necessary functions\n",
+			       pctldesc->name);
+			return ERR_PTR(ret);
+		}
+	}
+
+	pctldev = kzalloc(sizeof(struct pinctrl_dev), GFP_KERNEL);
+	if (pctldev == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	/* Initialize pin control device struct */
+	pctldev->owner = pctldesc->owner;
+	pctldev->desc = pctldesc;
+	pctldev->driver_data = driver_data;
+	INIT_RADIX_TREE(&pctldev->pin_desc_tree, GFP_KERNEL);
+	spin_lock_init(&pctldev->pin_desc_tree_lock);
+	INIT_LIST_HEAD(&pctldev->gpio_ranges);
+	mutex_init(&pctldev->gpio_ranges_lock);
+
+	/* Register device with sysfs */
+	pctldev->dev.parent = dev;
+	pctldev->dev.bus = &pinctrl_bus;
+	pctldev->dev.type = &pinctrl_type;
+	dev_set_name(&pctldev->dev, "pinctrl.%d",
+		     atomic_inc_return(&pinmux_no) - 1);
+	ret = device_register(&pctldev->dev);
+	if (ret != 0) {
+		pr_err("error in device registration\n");
+		put_device(&pctldev->dev);
+		kfree(pctldev);
+		goto out_err;
+	}
+	dev_set_drvdata(&pctldev->dev, pctldev);
+
+	/* Register all the pins */
+	pr_debug("try to register %d pins on %s...\n",
+		 pctldesc->npins, pctldesc->name);
+	ret = pinctrl_register_pins(pctldev, pctldesc->pins, pctldesc->npins);
+	if (ret) {
+		pr_err("error during pin registration\n");
+		pinctrl_free_pindescs(pctldev, pctldesc->pins,
+				      pctldesc->npins);
+		goto out_err;
+	}
+
+	pinctrl_init_device_debugfs(pctldev);
+	mutex_lock(&pinctrldev_list_mutex);
+	list_add(&pctldev->node, &pinctrldev_list);
+	mutex_unlock(&pinctrldev_list_mutex);
+	pinmux_hog_maps(pctldev);
+	return pctldev;
+
+out_err:
+	put_device(&pctldev->dev);
+	kfree(pctldev);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(pinctrl_register);
+
+/**
+ * pinctrl_unregister() - unregister pinmux
+ * @pctldev: pin controller to unregister
+ *
+ * Called by pinmux drivers to unregister a pinmux.
+ */
+void pinctrl_unregister(struct pinctrl_dev *pctldev)
+{
+	if (pctldev == NULL)
+		return;
+
+	pinmux_unhog_maps(pctldev);
+	/* TODO: check that no pinmuxes are still active? */
+	mutex_lock(&pinctrldev_list_mutex);
+	list_del(&pctldev->node);
+	mutex_unlock(&pinctrldev_list_mutex);
+	device_unregister(&pctldev->dev);
+	/* Destroy descriptor tree */
+	pinctrl_free_pindescs(pctldev, pctldev->desc->pins,
+			      pctldev->desc->npins);
+	kfree(pctldev);
+}
+EXPORT_SYMBOL_GPL(pinctrl_unregister);
+
+static int __init pinctrl_init(void)
+{
+	int ret;
+
+	ret = bus_register(&pinctrl_bus);
+	if (ret) {
+		pr_crit("could not register pinctrl bus\n");
+		return ret;
+	}
+
+	pr_info("initialized pinctrl subsystem\n");
+	pinctrl_init_debugfs();
+	return 0;
+}
+
+/* init early since many drivers really need to initialized pinmux early */
+core_initcall(pinctrl_init);
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
new file mode 100644
index 0000000..698221e
--- /dev/null
+++ b/drivers/pinctrl/core.h
@@ -0,0 +1,73 @@
+/*
+ * Core private header for the pin control subsystem
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+/**
+ * struct pinctrl_dev - pin control class device
+ * @node: node to include this pin controller in the global pin controller list
+ * @desc: the pin controller descriptor supplied when initializing this pin
+ *	controller
+ * @pin_desc_tree: each pin descriptor for this pin controller is stored in
+ *	this radix tree
+ * @pin_desc_tree_lock: lock for the descriptor tree
+ * @gpio_ranges: a list of GPIO ranges that is handled by this pin controller,
+ *	ranges are added to this list at runtime
+ * @gpio_ranges_lock: lock for the GPIO ranges list
+ * @dev: the device entry for this pin controller
+ * @owner: module providing the pin controller, used for refcounting
+ * @driver_data: driver data for drivers registering to the pin controller
+ *	subsystem
+ * @pinmux_hogs_lock: lock for the pinmux hog list
+ * @pinmux_hogs: list of pinmux maps hogged by this device
+ */
+struct pinctrl_dev {
+	struct list_head node;
+	struct pinctrl_desc *desc;
+	struct radix_tree_root pin_desc_tree;
+	spinlock_t pin_desc_tree_lock;
+	struct list_head gpio_ranges;
+	struct mutex gpio_ranges_lock;
+	struct device dev;
+	struct module *owner;
+	void *driver_data;
+#ifdef CONFIG_PINMUX
+	struct mutex pinmux_hogs_lock;
+	struct list_head pinmux_hogs;
+#endif
+};
+
+/**
+ * struct pin_desc - pin descriptor for each physical pin in the arch
+ * @pctldev: corresponding pin control device
+ * @name: a name for the pin, e.g. the name of the pin/pad/finger on a
+ *	datasheet or such
+ * @lock: a lock to protect the descriptor structure
+ * @mux_requested: whether the pin is already requested by pinmux or not
+ * @mux_function: a named muxing function for the pin that will be passed to
+ *	subdrivers and shown in debugfs etc
+ */
+struct pin_desc {
+	struct pinctrl_dev *pctldev;
+	char	name[16];
+	spinlock_t lock;
+	/* These fields only added when supporting pinmux drivers */
+#ifdef CONFIG_PINMUX
+	bool	mux_requested;
+	char	mux_function[16];
+#endif
+};
+
+const char *pctldev_get_devname(struct pinctrl_dev *pctldev);
+struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, int pin);
+struct pinctrl_dev *get_pctldev_from_dev(struct device *dev,
+					 const char *dev_name);
+int pinctrl_get_device_gpio_range(unsigned gpio,
+				  struct pinctrl_dev **outdev,
+				  struct pinctrl_gpio_range **outrange);
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
new file mode 100644
index 0000000..37803f0
--- /dev/null
+++ b/drivers/pinctrl/pinmux.c
@@ -0,0 +1,1179 @@
+/*
+ * Core driver for the pin muxing portions of the pin control subsystem
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * Based on bits of regulator core, gpio core and clk core
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#define pr_fmt(fmt) "pinmux core: " fmt
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/radix-tree.h>
+#include <linux/err.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/sysfs.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/pinctrl/pinmux.h>
+#include "core.h"
+
+/* List of pinmuxes */
+static DEFINE_MUTEX(pinmux_list_mutex);
+static LIST_HEAD(pinmux_list);
+
+/* List of pinmux hogs */
+static DEFINE_MUTEX(pinmux_hoglist_mutex);
+static LIST_HEAD(pinmux_hoglist);
+
+/* Global pinmux maps, we allow one set only */
+static struct pinmux_map const *pinmux_maps;
+static unsigned pinmux_maps_num;
+
+/**
+ * struct pinmux_group - group list item for pinmux groups
+ * @node: pinmux group list node
+ * @group_selector: the group selector for this group
+ */
+struct pinmux_group {
+	struct list_head node;
+	unsigned group_selector;
+};
+
+/**
+ * struct pinmux - per-device pinmux state holder
+ * @node: global list node
+ * @dev: the device using this pinmux
+ * @usecount: the number of active users of this mux setting, used to keep
+ *	track of nested use cases
+ * @pins: an array of discrete physical pins used in this mapping, taken
+ *	from the global pin enumeration space (copied from pinmux map)
+ * @num_pins: the number of pins in this mapping array, i.e. the number of
+ *	elements in .pins so we can iterate over that array (copied from
+ *	pinmux map)
+ * @pctldev: pin control device handling this pinmux
+ * @func_selector: the function selector for the pinmux device handling
+ *	this pinmux
+ * @groups: the group selectors for the pinmux device and
+ *	selector combination handling this pinmux, this is a list that
+ *	will be traversed on all pinmux operations such as
+ *	get/put/enable/disable
+ * @mutex: a lock for the pinmux state holder
+ */
+struct pinmux {
+	struct list_head node;
+	struct device *dev;
+	unsigned usecount;
+	struct pinctrl_dev *pctldev;
+	unsigned func_selector;
+	struct list_head groups;
+	struct mutex mutex;
+};
+
+/**
+ * struct pinmux_hog - a list item to stash mux hogs
+ * @node: pinmux hog list node
+ * @map: map entry responsible for this hogging
+ * @pmx: the pinmux hogged by this item
+ */
+struct pinmux_hog {
+	struct list_head node;
+	struct pinmux_map const *map;
+	struct pinmux *pmx;
+};
+
+/**
+ * pin_request() - request a single pin to be muxed in, typically for GPIO
+ * @pin: the pin number in the global pin space
+ * @function: a functional name to give to this pin, passed to the driver
+ *	so it knows what function to mux in, e.g. the string "gpioNN"
+ *	means that you want to mux in the pin for use as GPIO number NN
+ * @gpio: if this request concerns a single GPIO pin
+ * @gpio_range: the range matching the GPIO pin if this is a request for a
+ *	single GPIO pin
+ */
+static int pin_request(struct pinctrl_dev *pctldev,
+		       int pin, const char *function, bool gpio,
+		       struct pinctrl_gpio_range *gpio_range)
+{
+	struct pin_desc *desc;
+	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	int status = -EINVAL;
+
+	dev_dbg(&pctldev->dev, "request pin %d for %s\n", pin, function);
+
+	if (!pin_is_valid(pctldev, pin)) {
+		dev_err(&pctldev->dev, "pin is invalid\n");
+		return -EINVAL;
+	}
+
+	if (!function) {
+		dev_err(&pctldev->dev, "no function name given\n");
+		return -EINVAL;
+	}
+
+	desc = pin_desc_get(pctldev, pin);
+	if (desc == NULL) {
+		dev_err(&pctldev->dev,
+			"pin is not registered so it cannot be requested\n");
+		goto out;
+	}
+
+	spin_lock(&desc->lock);
+	if (desc->mux_requested) {
+		spin_unlock(&desc->lock);
+		dev_err(&pctldev->dev,
+			"pin already requested\n");
+		goto out;
+	}
+	desc->mux_requested = true;
+	strncpy(desc->mux_function, function, sizeof(desc->mux_function));
+	spin_unlock(&desc->lock);
+
+	/* Let each pin increase references to this module */
+	if (!try_module_get(pctldev->owner)) {
+		dev_err(&pctldev->dev,
+			"could not increase module refcount for pin %d\n",
+			pin);
+		status = -EINVAL;
+		goto out_free_pin;
+	}
+
+	/*
+	 * If there is no kind of request function for the pin we just assume
+	 * we got it by default and proceed.
+	 */
+	if (gpio && ops->gpio_request_enable)
+		/* This requests and enables a single GPIO pin */
+		status = ops->gpio_request_enable(pctldev, gpio_range, pin);
+	else if (ops->request)
+		status = ops->request(pctldev, pin);
+	else
+		status = 0;
+
+	if (status)
+		dev_err(&pctldev->dev, "->request on device %s failed "
+		       "for pin %d\n",
+		       pctldev->desc->name, pin);
+out_free_pin:
+	if (status) {
+		spin_lock(&desc->lock);
+		desc->mux_requested = false;
+		desc->mux_function[0] = '\0';
+		spin_unlock(&desc->lock);
+	}
+out:
+	if (status)
+		dev_err(&pctldev->dev, "pin-%d (%s) status %d\n",
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
+static void pin_free(struct pinctrl_dev *pctldev, int pin)
+{
+	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	struct pin_desc *desc;
+
+	desc = pin_desc_get(pctldev, pin);
+	if (desc == NULL) {
+		dev_err(&pctldev->dev,
+			"pin is not registered so it cannot be freed\n");
+		return;
+	}
+
+	if (ops->free)
+		ops->free(pctldev, pin);
+
+	spin_lock(&desc->lock);
+	desc->mux_requested = false;
+	desc->mux_function[0] = '\0';
+	spin_unlock(&desc->lock);
+	module_put(pctldev->owner);
+}
+
+/**
+ * pinmux_request_gpio() - request a single pin to be muxed in to be used
+ *	as a GPIO pin
+ * @gpio: the GPIO pin number from the GPIO subsystem number space
+ */
+int pinmux_request_gpio(unsigned gpio)
+{
+	char gpiostr[16];
+	struct pinctrl_dev *pctldev;
+	struct pinctrl_gpio_range *range;
+	int ret;
+	int pin;
+
+	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
+	if (ret)
+		return -EINVAL;
+
+	/* Convert to the pin controllers number space */
+	pin = gpio - range->base;
+
+	/* Conjure some name stating what chip and pin this is taken by */
+	snprintf(gpiostr, 15, "%s:%d", range->name, gpio);
+
+	return pin_request(pctldev, pin, gpiostr, true, range);
+}
+EXPORT_SYMBOL_GPL(pinmux_request_gpio);
+
+/**
+ * pinmux_free_gpio() - free a single pin, currently muxed in to be used
+ *	as a GPIO pin
+ * @gpio: the GPIO pin number from the GPIO subsystem number space
+ */
+void pinmux_free_gpio(unsigned gpio)
+{
+	struct pinctrl_dev *pctldev;
+	struct pinctrl_gpio_range *range;
+	int ret;
+	int pin;
+
+	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
+	if (ret)
+		return;
+
+	/* Convert to the pin controllers number space */
+	pin = gpio - range->base;
+
+	pin_free(pctldev, pin);
+}
+EXPORT_SYMBOL_GPL(pinmux_free_gpio);
+
+/**
+ * pinmux_register_mappings() - register a set of pinmux mappings
+ * @maps: the pinmux mappings table to register
+ * @num_maps: the number of maps in the mapping table
+ *
+ * Only call this once during initialization of your machine, the function is
+ * tagged as __init and won't be callable after init has completed. The map
+ * passed into this function will be owned by the pinmux core and cannot be
+ * free:d.
+ */
+int __init
+pinmux_register_mappings(struct pinmux_map const *maps, unsigned num_maps)
+{
+	int i;
+
+	if (pinmux_maps != NULL) {
+		pr_err("pinmux mappings already registered, you can only "
+		       "register one set of maps\n");
+		return -EINVAL;
+	}
+
+	pr_debug("add %d pinmux maps\n", num_maps);
+	for (i = 0; i < num_maps; i++) {
+		/* Sanity check the mapping */
+		if (!maps[i].name) {
+			pr_err("failed to register map %d: "
+			       "no map name given\n", i);
+			return -EINVAL;
+		}
+		if (!maps[i].ctrl_dev && !maps[i].ctrl_dev_name) {
+			pr_err("failed to register map %s (%d): "
+			       "no pin control device given\n",
+			       maps[i].name, i);
+			return -EINVAL;
+		}
+		if (!maps[i].function) {
+			pr_err("failed to register map %s (%d): "
+			       "no function ID given\n", maps[i].name, i);
+			return -EINVAL;
+		}
+
+		if (!maps[i].dev && !maps[i].dev_name)
+			pr_debug("add system map %s function %s with no device\n",
+				 maps[i].name,
+				 maps[i].function);
+		else
+			pr_debug("register map %s, function %s\n",
+				 maps[i].name,
+				 maps[i].function);
+	}
+
+	pinmux_maps = maps;
+	pinmux_maps_num = num_maps;
+
+	return 0;
+}
+
+/**
+ * acquire_pins() - acquire all the pins for a certain funcion on a certain
+ *	pinmux device
+ * @pctldev: the device to take the pins on
+ * @func_selector: the function selector to acquire the pins for
+ * @group_selector: the group selector containing the pins to acquire
+ */
+static int acquire_pins(struct pinctrl_dev *pctldev,
+			unsigned func_selector,
+			unsigned group_selector)
+{
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
+	const char *func = pmxops->get_function_name(pctldev,
+						     func_selector);
+	unsigned *pins;
+	unsigned num_pins;
+	int ret;
+	int i;
+
+	ret = pctlops->get_group_pins(pctldev, group_selector,
+				      &pins, &num_pins);
+	if (ret)
+		return ret;
+
+	dev_dbg(&pctldev->dev, "requesting the %u pins from group %u\n",
+		num_pins, group_selector);
+
+	/* Try to allocate all pins in this group, one by one */
+	for (i = 0; i < num_pins; i++) {
+		ret = pin_request(pctldev, pins[i], func, false, NULL);
+		if (ret) {
+			dev_err(&pctldev->dev,
+				"could not get pin %d for function %s "
+				"on device %s - conflicting mux mappings?\n",
+				pins[i], func ? : "(undefined)",
+				pctldev_get_name(pctldev));
+			/* On error release all taken pins */
+			i--; /* this pin just failed */
+			for (; i >= 0; i--)
+				pin_free(pctldev, pins[i]);
+			return -ENODEV;
+		}
+	}
+	return 0;
+}
+
+/**
+ * release_pins() - release pins taken by earlier acquirement
+ * @pctldev: the device to free the pinx on
+ * @group_selector: the group selector containing the pins to free
+ */
+static void release_pins(struct pinctrl_dev *pctldev,
+			 unsigned group_selector)
+{
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	unsigned *pins;
+	unsigned num_pins;
+	int ret;
+	int i;
+
+	ret = pctlops->get_group_pins(pctldev, group_selector,
+				      &pins, &num_pins);
+	if (ret) {
+		dev_err(&pctldev->dev, "could not get pins to release for "
+			"group selector %d\n",
+			group_selector);
+		return;
+	}
+	for (i = 0; i < num_pins; i++)
+		pin_free(pctldev, pins[i]);
+}
+
+/**
+ * pinmux_get_group_selector() - returns the group selector for a certain
+ * group name
+ * @pctldev: the pin controller handling the group
+ * @pin_group: the pin group to look up
+ */
+static int pinmux_get_group_selector(struct pinctrl_dev *pctldev,
+				     const char *pin_group)
+{
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	unsigned group_selector = 0;
+
+	while (pctlops->list_groups(pctldev, group_selector) >= 0) {
+		const char *gname = pctlops->get_group_name(pctldev,
+							    group_selector);
+		if (!strcmp(gname, pin_group)) {
+			dev_dbg(&pctldev->dev,
+				"found group selector %u for %s\n",
+				group_selector,
+				pin_group);
+			return group_selector;
+		}
+
+		group_selector++;
+	}
+
+	dev_err(&pctldev->dev, "does not have pin group %s\n",
+		pin_group);
+
+	return -EINVAL;
+}
+
+/**
+ * pinmux_check_pin_group() - check that the pinmux driver can supply the
+ * selected pin group for a certain function, returns the group selector if
+ * the group and function selector will work fine together, else returns
+ * negative
+ * @pctldev: device to check the pin group vs function for
+ * @func_selector: the function selector to check the pin group for, we have
+ *	already looked this up in the calling function
+ * @pin_group: the pin group to match to the function
+ */
+static int pinmux_check_pin_group(struct pinctrl_dev *pctldev,
+				  unsigned func_selector,
+				  const char *pin_group)
+{
+	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	int ret;
+
+	/*
+	 * If the driver does not support different pin groups for the
+	 * functions, we only support group 0, and assume this exists.
+	 */
+	if (!pctlops || !pctlops->list_groups)
+		return 0;
+
+	/*
+	 * Passing NULL (no specific group) will select the first and
+	 * hopefully only group of pins available for this function.
+	 */
+	if (!pin_group) {
+		char const * const *groups;
+		unsigned num_groups;
+
+		ret = pmxops->get_function_groups(pctldev, func_selector,
+						  &groups, &num_groups);
+		if (ret)
+			return ret;
+		if (num_groups < 1)
+			return -EINVAL;
+		ret = pinmux_get_group_selector(pctldev, groups[0]);
+		if (ret < 0) {
+			dev_err(&pctldev->dev,
+				"function %s wants group %s but the pin "
+				"controller does not seem to have that group\n",
+				pmxops->get_function_name(pctldev, func_selector),
+				groups[0]);
+			return ret;
+		}
+
+		if (num_groups > 1)
+			dev_dbg(&pctldev->dev,
+				"function %s support more than one group, "
+				"default-selecting first group %s (%d)\n",
+				pmxops->get_function_name(pctldev, func_selector),
+				groups[0],
+				ret);
+
+		return ret;
+	}
+
+	dev_dbg(&pctldev->dev,
+		"check if we have pin group %s on controller %s\n",
+		pin_group, pctldev_get_name(pctldev));
+
+	ret = pinmux_get_group_selector(pctldev, pin_group);
+	if (ret < 0) {
+		dev_dbg(&pctldev->dev,
+			"%s does not support pin group %s with function %s\n",
+			pctldev_get_name(pctldev),
+			pin_group,
+			pmxops->get_function_name(pctldev, func_selector));
+	}
+	return ret;
+}
+
+/**
+ * pinmux_search_function() - search the pinmux driver for an applicable
+ * function with a specific pin group, returns 0 if these can be mapped
+ * negative otherwise
+ * @pctldev: device to check for function and position
+ * @map: function map containing the function and position to look for
+ * @func_selector: returns the applicable function selector if found
+ * @group_selector: returns the applicable group selector if found
+ */
+static int pinmux_search_function(struct pinctrl_dev *pctldev,
+				  struct pinmux_map const *map,
+				  unsigned *func_selector,
+				  unsigned *group_selector)
+{
+	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	unsigned selector = 0;
+
+	/* See if this pctldev has this function */
+	while (ops->list_functions(pctldev, selector) >= 0) {
+		const char *fname = ops->get_function_name(pctldev,
+							   selector);
+		int ret;
+
+		if (!strcmp(map->function, fname)) {
+			/* Found the function, check pin group */
+			ret = pinmux_check_pin_group(pctldev, selector,
+						     map->group);
+			if (ret < 0)
+				return ret;
+
+			/* This function and group selector can be used */
+			*func_selector = selector;
+			*group_selector = ret;
+			return 0;
+
+		}
+		selector++;
+	}
+
+	pr_err("%s does not support function %s\n",
+	       pctldev_get_name(pctldev), map->function);
+	return -EINVAL;
+}
+
+/**
+ * pinmux_enable_muxmap() - enable a map entry for a certain pinmux
+ */
+static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
+				struct pinmux *pmx,
+				struct device *dev,
+				const char *devname,
+				struct pinmux_map const *map)
+{
+	unsigned func_selector;
+	unsigned group_selector;
+	struct pinmux_group *grp;
+	int ret;
+
+	/*
+	 * Note that we're not locking the pinmux mutex here, because
+	 * this is only called at pinmux initialization time when it
+	 * has not been added to any list and thus is not reachable
+	 * by anyone else.
+	 */
+
+	if (pmx->pctldev && pmx->pctldev != pctldev) {
+		dev_err(&pctldev->dev,
+			"different pin control devices given for device %s, "
+			"function %s\n",
+			devname,
+			map->function);
+		return -EINVAL;
+	}
+	pmx->dev = dev;
+	pmx->pctldev = pctldev;
+
+	/* Now go into the driver and try to match a function and group */
+	ret = pinmux_search_function(pctldev, map, &func_selector,
+				     &group_selector);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * If the function selector is already set, it needs to be identical,
+	 * we support several groups with one function but not several
+	 * functions with one or several groups in the same pinmux.
+	 */
+	if (pmx->func_selector != UINT_MAX &&
+	    pmx->func_selector != func_selector) {
+		dev_err(&pctldev->dev,
+			"dual function defines in the map for device %s\n",
+		       devname);
+		return -EINVAL;
+	}
+	pmx->func_selector = func_selector;
+
+	/* Now add this group selector, we may have many of them */
+	grp = kmalloc(sizeof(struct pinmux_group), GFP_KERNEL);
+	if (!grp)
+		return -ENOMEM;
+	grp->group_selector = group_selector;
+	ret = acquire_pins(pctldev, func_selector, group_selector);
+	if (ret) {
+		kfree(grp);
+		return ret;
+	}
+	list_add(&grp->node, &pmx->groups);
+
+	return 0;
+}
+
+static void pinmux_free_groups(struct pinmux *pmx)
+{
+	struct list_head *node, *tmp;
+
+	list_for_each_safe(node, tmp, &pmx->groups) {
+		struct pinmux_group *grp =
+			list_entry(node, struct pinmux_group, node);
+		/* Release all pins taken by this group */
+		release_pins(pmx->pctldev, grp->group_selector);
+		list_del(node);
+		kfree(grp);
+	}
+}
+
+/**
+ * pinmux_get() - retrieves the pinmux for a certain device
+ * @dev: the device to get the pinmux for
+ * @name: an optional specific mux mapping name or NULL, the name is only
+ *	needed if you want to have more than one mapping per device, or if you
+ *	need an anonymous pinmux (not tied to any specific device)
+ */
+struct pinmux *pinmux_get(struct device *dev, const char *name)
+{
+
+	struct pinmux_map const *map = NULL;
+	struct pinctrl_dev *pctldev = NULL;
+	const char *devname = NULL;
+	struct pinmux *pmx;
+	bool found_map;
+	unsigned num_maps = 0;
+	int ret = -ENODEV;
+	int i;
+
+	/* We must have dev or ID or both */
+	if (!dev && !name)
+		return ERR_PTR(-EINVAL);
+
+	if (dev)
+		devname = dev_name(dev);
+
+	pr_debug("get mux %s for device %s\n", name,
+		 devname ? devname : "(none)");
+
+	/*
+	 * create the state cookie holder struct pinmux for each
+	 * mapping, this is what consumers will get when requesting
+	 * a pinmux handle with pinmux_get()
+	 */
+	pmx = kzalloc(sizeof(struct pinmux), GFP_KERNEL);
+	if (pmx == NULL)
+		return ERR_PTR(-ENOMEM);
+	mutex_init(&pmx->mutex);
+	pmx->func_selector = UINT_MAX;
+	INIT_LIST_HEAD(&pmx->groups);
+
+	/* Iterate over the pinmux maps to locate the right ones */
+	for (i = 0; i < pinmux_maps_num; i++) {
+		map = &pinmux_maps[i];
+		found_map = false;
+
+		/*
+		 * First, try to find the pctldev given in the map
+		 */
+		pctldev = get_pctldev_from_dev(map->ctrl_dev,
+					       map->ctrl_dev_name);
+		if (!pctldev) {
+			const char *devname = NULL;
+
+			if (map->ctrl_dev)
+				devname = dev_name(map->ctrl_dev);
+			else if (map->ctrl_dev_name)
+				devname = map->ctrl_dev_name;
+
+			pr_warning("could not find a pinctrl device for pinmux "
+				   "function %s, fishy, they shall all have one\n",
+				   map->function);
+			pr_warning("given pinctrl device name: %s",
+				   devname ? devname : "UNDEFINED");
+
+			/* Continue to check the other mappings anyway... */
+			continue;
+		}
+
+		pr_debug("in map, found pctldev %s to handle function %s",
+			 dev_name(&pctldev->dev), map->function);
+
+
+		/*
+		 * If we're looking for a specific named map, this must match,
+		 * else we loop and look for the next.
+		 */
+		if (name != NULL) {
+			if (map->name == NULL)
+				continue;
+			if (strcmp(map->name, name))
+				continue;
+		}
+
+		/*
+		 * This is for the case where no device name is given, we
+		 * already know that the function name matches from above
+		 * code.
+		 */
+		if (!map->dev_name && (name != NULL))
+			found_map = true;
+
+		/* If the mapping has a device set up it must match */
+		if (map->dev_name &&
+		    (!devname || !strcmp(map->dev_name, devname)))
+			/* MATCH! */
+			found_map = true;
+
+		/* If this map is applicable, then apply it */
+		if (found_map) {
+			ret = pinmux_enable_muxmap(pctldev, pmx, dev,
+						   devname, map);
+			if (ret) {
+				pinmux_free_groups(pmx);
+				kfree(pmx);
+				return ERR_PTR(ret);
+			}
+			num_maps++;
+		}
+	}
+
+
+	/* We should have atleast one map, right */
+	if (!num_maps) {
+		pr_err("could not find any mux maps for device %s, ID %s\n",
+		       devname ? devname : "(anonymous)",
+		       name ? name : "(undefined)");
+		kfree(pmx);
+		return ERR_PTR(-EINVAL);
+	}
+
+	pr_debug("found %u mux maps for device %s, UD %s\n",
+		 num_maps,
+		 devname ? devname : "(anonymous)",
+		 name ? name : "(undefined)");
+
+	/* Add the pinmux to the global list */
+	mutex_lock(&pinmux_list_mutex);
+	list_add(&pmx->node, &pinmux_list);
+	mutex_unlock(&pinmux_list_mutex);
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
+
+	mutex_lock(&pmx->mutex);
+	if (pmx->usecount)
+		pr_warn("releasing pinmux with active users!\n");
+	/* Free the groups and all acquired pins */
+	pinmux_free_groups(pmx);
+	mutex_unlock(&pmx->mutex);
+
+	/* Remove from list */
+	mutex_lock(&pinmux_list_mutex);
+	list_del(&pmx->node);
+	mutex_unlock(&pinmux_list_mutex);
+
+	kfree(pmx);
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
+		struct pinctrl_dev *pctldev = pmx->pctldev;
+		const struct pinmux_ops *ops = pctldev->desc->pmxops;
+		struct pinmux_group *grp;
+
+		list_for_each_entry(grp, &pmx->groups, node) {
+			ret = ops->enable(pctldev, pmx->func_selector,
+					  grp->group_selector);
+			if (ret) {
+				/*
+				 * TODO: call disable() on all groups we called
+				 * enable() on to this point?
+				 */
+				pmx->usecount--;
+				break;
+			}
+		}
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
+		struct pinctrl_dev *pctldev = pmx->pctldev;
+		const struct pinmux_ops *ops = pctldev->desc->pmxops;
+		struct pinmux_group *grp;
+
+		list_for_each_entry(grp, &pmx->groups, node) {
+			ops->disable(pctldev, pmx->func_selector,
+				     grp->group_selector);
+		}
+	}
+	mutex_unlock(&pmx->mutex);
+}
+EXPORT_SYMBOL_GPL(pinmux_disable);
+
+int pinmux_check_ops(const struct pinmux_ops *ops)
+{
+	/* Check that we implement required operations */
+	if (!ops->list_functions ||
+	    !ops->get_function_name ||
+	    !ops->get_function_groups ||
+	    !ops->enable ||
+	    !ops->disable)
+		return -EINVAL;
+
+	return 0;
+}
+
+/* Hog a single map entry and add to the hoglist */
+static int pinmux_hog_map(struct pinctrl_dev *pctldev,
+			  struct pinmux_map const *map)
+{
+	struct pinmux_hog *hog;
+	struct pinmux *pmx;
+	int ret;
+
+	if (map->dev || map->dev_name) {
+		/*
+		 * TODO: the day we have device tree support, we can
+		 * traverse the device tree and hog to specific device nodes
+		 * without any problems, so then we can hog pinmuxes for
+		 * all devices that just want a static pin mux at this point.
+		 */
+		dev_err(&pctldev->dev, "map %s wants to hog a non-system "
+			"pinmux, this is not going to work\n", map->name);
+		return -EINVAL;
+	}
+
+	hog = kzalloc(sizeof(struct pinmux_hog), GFP_KERNEL);
+	if (!hog)
+		return -ENOMEM;
+
+	pmx = pinmux_get(NULL, map->name);
+	if (IS_ERR(pmx)) {
+		kfree(hog);
+		dev_err(&pctldev->dev,
+			"could not get the %s pinmux mapping for hogging\n",
+			map->name);
+		return PTR_ERR(pmx);
+	}
+
+	ret = pinmux_enable(pmx);
+	if (ret) {
+		pinmux_put(pmx);
+		kfree(hog);
+		dev_err(&pctldev->dev,
+			"could not enable the %s pinmux mapping for hogging\n",
+			map->name);
+		return ret;
+	}
+
+	hog->map = map;
+	hog->pmx = pmx;
+
+	dev_info(&pctldev->dev, "hogged map %s, function %s\n", map->name,
+		 map->function);
+	mutex_lock(&pctldev->pinmux_hogs_lock);
+	list_add(&hog->node, &pctldev->pinmux_hogs);
+	mutex_unlock(&pctldev->pinmux_hogs_lock);
+
+	return 0;
+}
+
+/**
+ * pinmux_hog_maps() - hog specific map entries on controller device
+ * @pctldev: the pin control device to hog entries on
+ *
+ * When the pin controllers are registered, there may be some specific pinmux
+ * map entries that need to be hogged, i.e. get+enabled until the system shuts
+ * down.
+ */
+int pinmux_hog_maps(struct pinctrl_dev *pctldev)
+{
+	struct device *dev = &pctldev->dev;
+	const char *devname = dev_name(dev);
+	int ret;
+	int i;
+
+	INIT_LIST_HEAD(&pctldev->pinmux_hogs);
+	mutex_init(&pctldev->pinmux_hogs_lock);
+
+	for (i = 0; i < pinmux_maps_num; i++) {
+		struct pinmux_map const *map = &pinmux_maps[i];
+
+		if (((map->ctrl_dev == dev) ||
+		     !strcmp(map->ctrl_dev_name, devname)) &&
+		    map->hog_on_boot) {
+			/* OK time to hog! */
+			ret = pinmux_hog_map(pctldev, map);
+			if (ret)
+				return ret;
+		}
+	}
+	return 0;
+}
+
+/**
+ * pinmux_hog_maps() - unhog specific map entries on controller device
+ * @pctldev: the pin control device to unhog entries on
+ */
+void pinmux_unhog_maps(struct pinctrl_dev *pctldev)
+{
+	struct list_head *node, *tmp;
+
+	mutex_lock(&pctldev->pinmux_hogs_lock);
+	list_for_each_safe(node, tmp, &pctldev->pinmux_hogs) {
+		struct pinmux_hog *hog =
+			list_entry(node, struct pinmux_hog, node);
+		pinmux_disable(hog->pmx);
+		pinmux_put(hog->pmx);
+		list_del(node);
+		kfree(hog);
+	}
+	mutex_unlock(&pctldev->pinmux_hogs_lock);
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+/* Called from pincontrol core */
+static int pinmux_functions_show(struct seq_file *s, void *what)
+{
+	struct pinctrl_dev *pctldev = s->private;
+	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
+	unsigned func_selector = 0;
+
+	while (pmxops->list_functions(pctldev, func_selector) >= 0) {
+		const char *func = pmxops->get_function_name(pctldev,
+							  func_selector);
+		const char * const *groups;
+		unsigned num_groups;
+		int ret;
+		int i;
+
+		ret = pmxops->get_function_groups(pctldev, func_selector,
+						  &groups, &num_groups);
+		if (ret)
+			seq_printf(s, "function %s: COULD NOT GET GROUPS\n",
+				   func);
+
+		seq_printf(s, "function: %s, groups = [ ", func);
+		for (i = 0; i < num_groups; i++)
+			seq_printf(s, "%s ", groups[i]);
+		seq_puts(s, "]\n");
+
+		func_selector++;
+
+	}
+
+	return 0;
+}
+
+static int pinmux_pins_show(struct seq_file *s, void *what)
+{
+	struct pinctrl_dev *pctldev = s->private;
+	unsigned pin;
+
+	seq_puts(s, "Pinmux settings per pin\n");
+	seq_puts(s, "Format: pin (name): pinmuxfunction\n");
+
+	/* The highest pin number need to be included in the loop, thus <= */
+	for (pin = 0; pin <= pctldev->desc->maxpin; pin++) {
+
+		struct pin_desc *desc;
+
+		desc = pin_desc_get(pctldev, pin);
+		/* Pin space may be sparse */
+		if (desc == NULL)
+			continue;
+
+		seq_printf(s, "pin %d (%s): %s\n", pin,
+			   desc->name ? desc->name : "unnamed",
+			   desc->mux_requested ? desc->mux_function : "UNCLAIMED");
+	}
+
+	return 0;
+}
+
+static int pinmux_hogs_show(struct seq_file *s, void *what)
+{
+	struct pinctrl_dev *pctldev = s->private;
+	struct pinmux_hog *hog;
+
+	seq_puts(s, "Pinmux map hogs held by device\n");
+
+	list_for_each_entry(hog, &pctldev->pinmux_hogs, node)
+		seq_printf(s, "%s\n", hog->map->name);
+
+	return 0;
+}
+
+static int pinmux_show(struct seq_file *s, void *what)
+{
+	struct pinmux *pmx;
+
+	seq_puts(s, "Requested pinmuxes and their maps:\n");
+	list_for_each_entry(pmx, &pinmux_list, node) {
+		struct pinctrl_dev *pctldev = pmx->pctldev;
+		const struct pinmux_ops *pmxops;
+		const struct pinctrl_ops *pctlops;
+		struct pinmux_group *grp;
+
+		if (!pctldev) {
+			seq_puts(s, "NO PIN CONTROLLER DEVICE\n");
+			continue;
+		}
+
+		pmxops = pctldev->desc->pmxops;
+		pctlops = pctldev->desc->pctlops;
+
+		seq_printf(s, "device: %s function: %s (%u),",
+			   pctldev_get_name(pmx->pctldev),
+			   pmxops->get_function_name(pctldev, pmx->func_selector),
+			   pmx->func_selector);
+
+		seq_printf(s, " groups: [");
+		list_for_each_entry(grp, &pmx->groups, node) {
+			seq_printf(s, " %s (%u)",
+				   pctlops->get_group_name(pctldev, grp->group_selector),
+				   grp->group_selector);
+		}
+		seq_printf(s, " ]");
+
+		seq_printf(s, " users: %u map-> %s\n",
+			   pmx->usecount,
+			   pmx->dev ? dev_name(pmx->dev) : "(system)");
+	}
+
+	return 0;
+}
+
+static int pinmux_maps_show(struct seq_file *s, void *what)
+{
+	int i;
+
+	seq_puts(s, "Pinmux maps:\n");
+
+	for (i = 0; i < pinmux_maps_num; i++) {
+		struct pinmux_map const *map = &pinmux_maps[i];
+
+		seq_printf(s, "%s:\n", map->name);
+		if (map->dev || map->dev_name)
+			seq_printf(s, "  device: %s\n",
+				   map->dev ? dev_name(map->dev) :
+				   map->dev_name);
+		else
+			seq_printf(s, "  SYSTEM MUX\n");
+		seq_printf(s, "  controlling device %s\n",
+			   map->ctrl_dev ? dev_name(map->ctrl_dev) :
+			   map->ctrl_dev_name);
+		seq_printf(s, "  function: %s\n", map->function);
+		seq_printf(s, "  group: %s\n", map->group ? map->group :
+			   "(default)");
+	}
+	return 0;
+}
+
+static int pinmux_functions_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinmux_functions_show, inode->i_private);
+}
+
+static int pinmux_pins_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinmux_pins_show, inode->i_private);
+}
+
+static int pinmux_hogs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinmux_hogs_show, inode->i_private);
+}
+
+static int pinmux_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinmux_show, NULL);
+}
+
+static int pinmux_maps_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinmux_maps_show, NULL);
+}
+
+static const struct file_operations pinmux_functions_ops = {
+	.open		= pinmux_functions_open,
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
+static const struct file_operations pinmux_hogs_ops = {
+	.open		= pinmux_hogs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations pinmux_ops = {
+	.open		= pinmux_open,
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
+void pinmux_init_device_debugfs(struct dentry *devroot,
+			 struct pinctrl_dev *pctldev)
+{
+	debugfs_create_file("pinmux-functions", S_IFREG | S_IRUGO,
+			    devroot, pctldev, &pinmux_functions_ops);
+	debugfs_create_file("pinmux-pins", S_IFREG | S_IRUGO,
+			    devroot, pctldev, &pinmux_pins_ops);
+	debugfs_create_file("pinmux-hogs", S_IFREG | S_IRUGO,
+			    devroot, pctldev, &pinmux_hogs_ops);
+}
+
+void pinmux_init_debugfs(struct dentry *subsys_root)
+{
+	debugfs_create_file("pinmuxes", S_IFREG | S_IRUGO,
+			    subsys_root, NULL, &pinmux_ops);
+	debugfs_create_file("pinmux-maps", S_IFREG | S_IRUGO,
+			    subsys_root, NULL, &pinmux_maps_ops);
+}
+
+#endif /* CONFIG_DEBUG_FS */
diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
new file mode 100644
index 0000000..844500b
--- /dev/null
+++ b/drivers/pinctrl/pinmux.h
@@ -0,0 +1,47 @@
+/*
+ * Internal interface between the core pin control system and the
+ * pinmux portions
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * Based on bits of regulator core, gpio core and clk core
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#ifdef CONFIG_PINMUX
+
+int pinmux_check_ops(const struct pinmux_ops *ops);
+void pinmux_init_device_debugfs(struct dentry *devroot,
+				struct pinctrl_dev *pctldev);
+void pinmux_init_debugfs(struct dentry *subsys_root);
+int pinmux_hog_maps(struct pinctrl_dev *pctldev);
+void pinmux_unhog_maps(struct pinctrl_dev *pctldev);
+
+#else
+
+static inline int pinmux_check_ops(const struct pinmux_ops *ops)
+{
+	return 0;
+}
+
+static inline void pinmux_init_device_debugfs(struct dentry *devroot,
+					      struct pinctrl_dev *pctldev)
+{
+}
+
+static inline void pinmux_init_debugfs(struct dentry *subsys_root)
+{
+}
+
+static inline int pinmux_hog_maps(struct pinctrl_dev *pctldev)
+{
+	return 0;
+}
+
+static inline void pinmux_unhog_maps(struct pinctrl_dev *pctldev)
+{
+}
+
+#endif
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
new file mode 100644
index 0000000..2cd4033
--- /dev/null
+++ b/include/linux/pinctrl/machine.h
@@ -0,0 +1,107 @@
+/*
+ * Machine interface for the pinctrl subsystem.
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * Based on bits of regulator core, gpio core and clk core
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#ifndef __LINUX_PINMUX_MACHINE_H
+#define __LINUX_PINMUX_MACHINE_H
+
+/**
+ * struct pinmux_map - boards/machines shall provide this map for devices
+ * @name: the name of this specific map entry for the particular machine.
+ *	This is the second parameter passed to pinmux_get() when you want
+ *	to have several mappings to the same device
+ * @ctrl_dev: the pin control device to be used by this mapping, may be NULL
+ *	if you provide .ctrl_dev_name instead (this is more common)
+ * @ctrl_dev_name: the name of the device controlling this specific mapping,
+ *	the name must be the same as in your struct device*, may be NULL if
+ *	you provide .ctrl_dev instead
+ * @function: a function in the driver to use for this mapping, the driver
+ *	will lookup the function referenced by this ID on the specified
+ *	pin control device
+ * @group: sometimes a function can map to different pin groups, so this
+ *	selects a certain specific pin group to activate for the function, if
+ *	left as NULL, the first applicable group will be used
+ * @dev: the device using this specific mapping, may be NULL if you provide
+ *	.dev_name instead (this is more common)
+ * @dev_name: the name of the device using this specific mapping, the name
+ *	must be the same as in your struct device*, may be NULL if you
+ *	provide .dev instead
+ * @hog_on_boot: if this is set to true, the regulator subsystem will itself
+ *	hog the mappings as the pinmux device drivers are attched, so this is
+ *	typically used with system maps (mux mappings without an assigned
+ *	device) that you want to get hogged and enabled by default as soon as
+ *	a pinmux device supporting it is registered. These maps will not be
+ *	disabled and put until the system shuts down.
+ */
+struct pinmux_map {
+	const char *name;
+	struct device *ctrl_dev;
+	const char *ctrl_dev_name;
+	const char *function;
+	const char *group;
+	struct device *dev;
+	const char *dev_name;
+	const bool hog_on_boot;
+};
+
+/*
+ * Convenience macro to set a simple map from a certain pin controller and a
+ * certain function to a named device
+ */
+#define PINMUX_MAP(a, b, c, d) \
+	{ .name = a, .ctrl_dev_name = b, .function = c, .dev_name = d }
+
+/*
+ * Convenience macro to map a system function onto a certain pinctrl device.
+ * System functions are not assigned to a particular device.
+ */
+#define PINMUX_MAP_SYS(a, b, c) \
+	{ .name = a, .ctrl_dev_name = b, .function = c }
+
+/*
+ * Convenience macro to map a function onto the primary device pinctrl device
+ * this is especially helpful on systems that have only one pin controller
+ * or need to set up a lot of mappings on the primary controller.
+ */
+#define PINMUX_MAP_PRIMARY(a, b, c) \
+	{ .name = a, .ctrl_dev_name = "pinctrl.0", .function = b, \
+	  .dev_name = c }
+
+/*
+ * Convenience macro to map a system function onto the primary pinctrl device.
+ * System functions are not assigned to a particular device.
+ */
+#define PINMUX_MAP_PRIMARY_SYS(a, b) \
+	{ .name = a, .ctrl_dev_name = "pinctrl.0", .function = b }
+
+/*
+ * Convenience macro to map a system function onto the primary pinctrl device,
+ * to be hogged by the pinmux core until the system shuts down.
+ */
+#define PINMUX_MAP_PRIMARY_SYS_HOG(a, b) \
+	{ .name = a, .ctrl_dev_name = "pinctrl.0", .function = b, \
+	  .hog_on_boot = true }
+
+
+#ifdef CONFIG_PINMUX
+
+extern int pinmux_register_mappings(struct pinmux_map const *map,
+				unsigned num_maps);
+
+#else
+
+static inline int pinmux_register_mappings(struct pinmux_map const *map,
+					   unsigned num_maps)
+{
+	return 0;
+}
+
+#endif /* !CONFIG_PINCTRL */
+#endif
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
new file mode 100644
index 0000000..1e6f67e
--- /dev/null
+++ b/include/linux/pinctrl/pinctrl.h
@@ -0,0 +1,133 @@
+/*
+ * Interface the pinctrl subsystem
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * This interface is used in the core to keep track of pins.
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#ifndef __LINUX_PINCTRL_PINCTRL_H
+#define __LINUX_PINCTRL_PINCTRL_H
+
+#ifdef CONFIG_PINCTRL
+
+#include <linux/radix-tree.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/seq_file.h>
+
+struct pinctrl_dev;
+struct pinmux_ops;
+struct gpio_chip;
+
+/**
+ * struct pinctrl_pin_desc - boards/machines provide information on their
+ * pins, pads or other muxable units in this struct
+ * @number: unique pin number from the global pin number space
+ * @name: a name for this pin
+ */
+struct pinctrl_pin_desc {
+	unsigned number;
+	const char *name;
+};
+
+/* Convenience macro to define a single named or anonymous pin descriptor */
+#define PINCTRL_PIN(a, b) { .number = a, .name = b }
+#define PINCTRL_PIN_ANON(a) { .number = a }
+
+/**
+ * struct pinctrl_gpio_range - each pin controller can provide subranges of
+ * the GPIO number space to be handled by the controller
+ * @node: list node for internal use
+ * @name: a name for the chip in this range
+ * @id: an ID number for the chip in this range
+ * @base: base offset of the GPIO range
+ * @npins: number of pins in the GPIO range, including the base number
+ * @gc: an optional pointer to a gpio_chip
+ */
+struct pinctrl_gpio_range {
+	struct list_head node;
+	const char *name;
+	unsigned int id;
+	unsigned int base;
+	unsigned int npins;
+	struct gpio_chip *gc;
+};
+
+/**
+ * struct pinctrl_ops - global pin control operations, to be implemented by
+ * pin controller drivers.
+ * @list_groups: list the number of selectable named groups available
+ *	in this pinmux driver, the core will begin on 0 and call this
+ *	repeatedly as long as it returns >= 0 to enumerate the groups
+ * @get_group_name: return the group name of the pin group
+ * @get_group_pins: return an array of pins corresponding to a certain
+ *	group selector @pins, and the size of the array in @num_pins
+ * @pin_dbg_show: optional debugfs display hook that will provide per-device
+ *	info for a certain pin in debugfs
+ */
+struct pinctrl_ops {
+	int (*list_groups) (struct pinctrl_dev *pctldev, unsigned selector);
+	const char *(*get_group_name) (struct pinctrl_dev *pctldev,
+				       unsigned selector);
+	int (*get_group_pins) (struct pinctrl_dev *pctldev,
+			       unsigned selector,
+			       unsigned ** const pins,
+			       unsigned * const num_pins);
+	void (*pin_dbg_show) (struct pinctrl_dev *pctldev, struct seq_file *s,
+			  unsigned offset);
+};
+
+/**
+ * struct pinctrl_desc - pin controller descriptor, register this to pin
+ * control subsystem
+ * @name: name for the pin controller
+ * @pins: an array of pin descriptors describing all the pins handled by
+ *	this pin controller
+ * @npins: number of descriptors in the array, usually just ARRAY_SIZE()
+ *	of the pins field above
+ * @maxpin: since pin spaces may be sparse, there can he "holes" in the
+ *	pin range, this attribute gives the maximum pin number in the
+ *	total range. This should not be lower than npins for example,
+ *	but may be equal to npins if you have no holes in the pin range.
+ * @pctlops: pin control operation vtable, to support global concepts like
+ *	grouping of pins, this is optional.
+ * @pmxops: pinmux operation vtable, if you support pinmuxing in your driver
+ * @owner: module providing the pin controller, used for refcounting
+ */
+struct pinctrl_desc {
+	const char *name;
+	struct pinctrl_pin_desc const *pins;
+	unsigned int npins;
+	unsigned int maxpin;
+	struct pinctrl_ops *pctlops;
+	struct pinmux_ops *pmxops;
+	struct module *owner;
+};
+
+/* External interface to pin controller */
+extern struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
+				struct device *dev, void *driver_data);
+extern void pinctrl_unregister(struct pinctrl_dev *pctldev);
+extern bool pin_is_valid(struct pinctrl_dev *pctldev, int pin);
+extern void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
+				struct pinctrl_gpio_range *range);
+extern void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
+				struct pinctrl_gpio_range *range);
+extern const char *pctldev_get_name(struct pinctrl_dev *pctldev);
+extern void *pctldev_get_drvdata(struct pinctrl_dev *pctldev);
+#else
+
+
+/* Sufficiently stupid default function when pinctrl is not in use */
+static inline bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
+{
+	return pin >= 0;
+}
+
+#endif /* !CONFIG_PINCTRL */
+
+#endif /* __LINUX_PINCTRL_PINCTRL_H */
diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
new file mode 100644
index 0000000..3c430e7
--- /dev/null
+++ b/include/linux/pinctrl/pinmux.h
@@ -0,0 +1,117 @@
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
+#ifndef __LINUX_PINCTRL_PINMUX_H
+#define __LINUX_PINCTRL_PINMUX_H
+
+#include <linux/list.h>
+#include <linux/seq_file.h>
+#include "pinctrl.h"
+
+/* This struct is private to the core and should be regarded as a cookie */
+struct pinmux;
+
+#ifdef CONFIG_PINMUX
+
+struct pinctrl_dev;
+
+/**
+ * struct pinmux_ops - pinmux operations, to be implemented by pin controller
+ * drivers that support pinmuxing
+ * @request: called by the core to see if a certain pin can be made available
+ *	available for muxing. This is called by the core to acquire the pins
+ *	before selecting any actual mux setting across a function. The driver
+ *	is allowed to answer "no" by returning a negative error code
+ * @free: the reverse function of the request() callback, frees a pin after
+ *	being requested
+ * @list_functions: list the number of selectable named functions available
+ *	in this pinmux driver, the core will begin on 0 and call this
+ *	repeatedly as long as it returns >= 0 to enumerate mux settings
+ * @get_function_name: return the function name of the muxing selector,
+ *	called by the core to figure out which mux setting it shall map a
+ *	certain device to
+ * @get_function_groups: return an array of groups names (in turn
+ *	referencing pins) connected to a certain function selector. The group
+ *	name can be used with the generic @pinctrl_ops to retrieve the
+ *	actual pins affected. The applicable groups will be returned in
+ *	@groups and the number of groups in @num_groups
+ * @enable: enable a certain muxing function with a certain pin group. The
+ *	driver does not need to figure out whether enabling this function
+ *	conflicts some other use of the pins in that group, such collisions
+ *	are handled by the pinmux subsystem. The @func_selector selects a
+ *	certain function whereas @group_selector selects a certain set of pins
+ *	to be used. On simple controllers the latter argument may be ignored
+ * @disable: disable a certain muxing selector with a certain pin group
+ * @gpio_request_enable: requests and enables GPIO on a certain pin.
+ *	Implement this only if you can mux every pin individually as GPIO. The
+ *	affected GPIO range is passed along with an offset into that
+ *	specific GPIO range - function selectors and pin groups are orthogonal
+ *	to this, the core will however make sure the pins do not collide
+ */
+struct pinmux_ops {
+	int (*request) (struct pinctrl_dev *pctldev, unsigned offset);
+	int (*free) (struct pinctrl_dev *pctldev, unsigned offset);
+	int (*list_functions) (struct pinctrl_dev *pctldev, unsigned selector);
+	const char *(*get_function_name) (struct pinctrl_dev *pctldev,
+					  unsigned selector);
+	int (*get_function_groups) (struct pinctrl_dev *pctldev,
+				  unsigned selector,
+				  const char * const **groups,
+				  unsigned * const num_groups);
+	int (*enable) (struct pinctrl_dev *pctldev, unsigned func_selector,
+		       unsigned group_selector);
+	void (*disable) (struct pinctrl_dev *pctldev, unsigned func_selector,
+			 unsigned group_selector);
+	int (*gpio_request_enable) (struct pinctrl_dev *pctldev,
+				    struct pinctrl_gpio_range *range,
+				    unsigned offset);
+};
+
+/* External interface to pinmux */
+extern int pinmux_request_gpio(unsigned gpio);
+extern void pinmux_free_gpio(unsigned gpio);
+extern struct pinmux * __must_check pinmux_get(struct device *dev, const char *name);
+extern void pinmux_put(struct pinmux *pmx);
+extern int pinmux_enable(struct pinmux *pmx);
+extern void pinmux_disable(struct pinmux *pmx);
+
+#else /* !CONFIG_PINMUX */
+
+static inline int pinmux_request_gpio(unsigned gpio)
+{
+	return 0;
+}
+
+static inline void pinmux_free_gpio(unsigned gpio)
+{
+}
+
+static inline struct pinmux * __must_check pinmux_get(struct device *dev, const char *name)
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
+#endif /* CONFIG_PINMUX */
+
+#endif /* __LINUX_PINCTRL_PINMUX_H */
-- 
1.7.3.2

