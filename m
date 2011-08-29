Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1H2JLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 05:11:17 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:60299 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382Ab1H2JK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 05:10:56 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Cc: Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>, Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/4 v5] drivers: create a pin control subsystem v5
Date: Mon, 29 Aug 2011 11:10:01 +0200
Message-ID: <1314609001-28052-1-git-send-email-linus.walleij@stericsson.com>
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

Currently it handled pinmuxing, i.e. assign electronic functions
to groups of pins of pins on primarily PGA and BGA type of chip
packages and common in embedded systems.

The plan is to also handle other I/O pin control aspects such as
biasing, driving, input properties such as schmitt-triggering,
load capacitance etc within this subsystem.

This is being done to depopulate the arch/arm/* directory of such
custom drivers and try to abstract the infrastructure they all
need. See the Documentation/pinmux.txt file that is part of this
patch for more details.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Joe Perches <joe@perches.com>
Cc: Russell King <linux@arm.linux.org.uk>
Tested-by: Barry Song <21cnbao@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v4->v5:

- Defined a "position" for each function, so the pin controller now
  tracks a function in a certain position, and the pinmux maps define
  what position you want the function in. (Feedback from Stephen
  Warren and Sascha Hauer).

- Since we now need to request a combined function+position from
  the machine mapping table that connect mux settings to drivers,
  it was extended with a position field and a name field. The
  name field is now used if you e.g. need to switch between two
  mux map settings at runtime.

- Switched from a class device to using struct bus_type for this
  subsystem. Verified sysfs functionality: seems to work fine.
  (Feedback from Arnd Bergmann and Greg Kroah-Hartman)

- Define a per pincontroller list of GPIO ranges from the GPIO
  pin space that can be handled by the pin controller. These can
  be added one by one at runtime. (Feedback from Barry Song)

- Expanded documentation of regulator_[get|enable|disable|put]
  semantics.

- Fixed a number of review comments from Barry Song. (Thanks!)
---
 Documentation/ABI/testing/sysfs-class-pinmux |   11 +
 Documentation/pinctrl.txt                    |  714 +++++++++++++++++++++++
 MAINTAINERS                                  |    5 +
 drivers/Kconfig                              |    4 +
 drivers/Makefile                             |    2 +
 drivers/pinctrl/Kconfig                      |   29 +
 drivers/pinctrl/Makefile                     |    6 +
 drivers/pinctrl/core.c                       |  539 +++++++++++++++++
 drivers/pinctrl/core.h                       |   24 +
 drivers/pinctrl/pinmux.c                     |  811 ++++++++++++++++++++++++++
 drivers/pinctrl/pinmux.h                     |    4 +
 include/linux/pinctrl/machine.h              |   74 +++
 include/linux/pinctrl/pinctrl.h              |  143 +++++
 include/linux/pinctrl/pinmux.h               |  135 +++++
 14 files changed, 2501 insertions(+), 0 deletions(-)
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
index 0000000..76c003a
--- /dev/null
+++ b/Documentation/pinctrl.txt
@@ -0,0 +1,714 @@
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
+  identify three pinmux functions, two for spi and one for i2c.
+
+- FUNCTIONS are assumed to be enumerable from zero in a one-dimensional array.
+  In this case the array could be something like: { spi0, i2c0, mmc0 }
+  for the three available functions.
+
+- POSITIONS are applicable to each function, so if spi0 can appear on three
+  different sets of pins, say {0, 1}, {4, 5} and {12, 13} these three
+  positions are numbered 0, 1, 2.
+
+- FUNCTIONS + POSITION determine a certain function for a certain set of pins.
+  The knowledge of the functions and positions and it's machine-specific
+  particulars is kept inside the pinmux driver, from the outside only the
+  enumerators are known, and the driver core can request the name of a function
+  with a certain selector (>= 0) or the list of pins belonging to a certain
+  function selector + position.
+
+- FUNCTIONS with POSITIONs on a certain PIN CONTROLLER are MAPPED to a certain
+  device by the board file, device tree or similar machine setup configuration
+  mechanism, similar to how regulators are connected to devices, usually by
+  name. Defining a pin controller, function and position thus uniquely identify
+  the set of pins to be used by a certain device.
+
+  In the example case we can define that this particular machine shall
+  use device spi0 with pinmux function fspi0 position 0 and i2c0 on function
+  fi2c0  position 1, on the primary pin controller, we get quadruple mappings
+  like these:
+  { {spi0, pinctrl0, fspi0, 0}, {i2c0, pinctrl0, fi2c0, 1} }
+
+- FUNCTIONS on a certain POSITION on a certain PIN CONTROLLER are provided
+  on a first-come first-serve basis, so if some other device mux setting or
+  GPIO pin request has already taken your physical pin, you will be denied the
+  use of it. To get (activate) a new setting, the old one has to be put
+  (deactivated) first.
+
+Sometimes the documentation and hardware registers will be oriented around
+pads (or "fingers") rather than pins - these are the soldering surfaces on the
+silicon inside the package, and may or may not match the actual number of
+pins/balls underneath the capsule. Pick some enumeration that makes sense to
+you. Define enumerators only for the pins you can control if that makes sense.
+
+Assumptions:
+
+We assume that the number possible function maps to pins is limited by the
+hardware. I.e. we assume that there is no system where any function can be
+mapped to any pin, like in a phone exchange. So the available pins groups for
+a certain function will be limited to a few choices (say up to eight or so),
+not hundreds or any amount of choices. This is the characteristic we have found
+by inspecting available pinmux hardware.
+
+
+Pinmux drivers
+==============
+
+It is the responsibility of the pinmux driver to determine whether or not
+the requested function can actually be enabled, and in that case poke the
+hardware so that this happens.
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
+A simple driver for the above example will work by setting bits 0, 1, 2, 3 or 4
+into some register named MUX to select a certain function on a certain position
+would works something like this:
+
+#include <linux/pinctrl/pinmux.h>
+
+struct foo_pmx_position {
+	unsigned pos;
+	const unsigned int *pins;
+	const unsigned num_pins;
+	u8 regbit;
+}
+
+struct foo_pmx_func {
+	char *name;
+	struct positions*;
+	unsigned num_positions;
+};
+
+static unsigned int spi0_0_pins[] = { 0, 8, 16, 24 };
+static unsigned int spi0_1_pins[] = { 38, 46, 54, 62 };
+
+static struct foo_pmx_position spi0_positions[] = {
+       {
+		.pos = 0,
+		.pins = spi0_0_pins,
+		.num_pins = ARRAY_SIZE(spi0_1_pins),
+		.regbit = 0x01,
+       },
+       {
+		.pos = 1,
+		.pins = spi0_1_pins,
+		.num_pins = ARRAY_SIZE(spi0_1_pins),
+		.regbit = 0x02,
+       },
+};
+
+static unsigned int i2c0_pins[] = { 24, 25 };
+
+static struct foo_pmx_position i2c0_positions[] = {
+       {
+		.pos = 0,
+		.pins = i2c0_pins,
+		.num_pins = ARRAY_SIZE(spi0_1_pins),
+		.regbit = 0x04,
+       },
+};
+
+static unsigned int mmc0_1_pins[] = { 56, 57 };
+static unsigned int mmc0_2_pins[] = { 56, 57, 58, 59 };
+static unsigned int mmc0_3_pins[] = { 56, 57, 58, 59, 60, 61, 62, 63 };
+
+static struct foo_pmx_position mmc0_positions[] = {
+       {
+		.pos = 0,
+		.pins = mmc0_1_pins,
+		.num_pins = ARRAY_SIZE(mmc0_1_pins),
+		.regbit = 0x08,
+       },
+       {
+		.pos = 1,
+		.pins = mmc0_2_pins,
+		.num_pins = ARRAY_SIZE(mmc0_2_pins),
+		.regbit = 0x10,
+       },
+       {
+		.pos = 2,
+		.pins = mmc0_3_pins,
+		.num_pins = ARRAY_SIZE(mmc0_3_pins),
+		.regbit = 0x20,
+       },
+};
+
+static struct foo_pmx_func myfuncs[] = {
+	{
+		.name = "spi0",
+		.positions = spi0_positions,
+		.num_positions = ARRAY_SIZE(spi0_positions),
+	},
+	{
+		.name = "i2c0",
+		.positions = i2c0_positions,
+		.num_positions = ARRAY_SIZE(i2c0_positions),
+	},
+	{
+		.name = "mmc0",
+		.positions = mmc0_positions,
+		.num_positions = ARRAY_SIZE(mmc0_positions),
+	},
+};
+
+int foo_list_funcs(struct pinctrl_dev *pctldev, unsigned selector)
+{
+	if (selector >= ARRAY_SIZE(myfuncs))
+		return -EINVAL;
+	return 0;
+}
+
+int foo_list_positions(struct pinctrl_dev *pctldev, unsigned selector,
+    			unsigned position)
+{
+	if (selector >= ARRAY_SIZE(myfuncs))
+		return -EINVAL;
+	if (position >= myfuncs[selector].num_positions)
+		return -EINVAL;
+	return 0;
+}
+
+const char *foo_get_fname(struct pinctrl_dev *pctldev, unsigned selector)
+{
+	return myfuncs[selector].name;
+}
+
+static int foo_get_pins(struct pinctrl_dev *pctldev, unsigned selector,
+       	   		unsigned position, unsigned ** const pins,
+			unsigned * const num_pins)
+{
+	*pins = myfuncs[selector].positions[position].pins;
+	*num_pins = myfuncs[selector].positions[position].num_pins;
+	return 0;
+}
+
+int foo_enable(struct pinctrl_dev *pctldev, unsigned selector,
+    		unsigned position)
+{
+	u8 regbit = myfuncs[selector].positions[position].regbit;
+
+	writeb((readb(MUX)|regbit), MUX)
+	return 0;
+}
+
+int foo_disable(struct pinctrl_dev *pctldev, unsigned selector,
+    		unsigned position)
+{
+	u8 regbit = myfuncs[selector].positions[position].regbit;
+
+	writeb((readb(MUX) & ~(regbit)), MUX)
+	return 0;
+}
+
+struct pinmux_ops pmxops = {
+	.list_functions = foo_list_funcs,
+	.list_positions = foo_list_positions,
+	.get_function_name = foo_get_fname,
+	.get_function_pins = foo_get_pins,
+	.enable = foo_enable,
+	.disable = foo_disable,
+};
+
+/* Pinmux operations are handled by some pin controller */
+static struct pinctrl_desc foo_desc = {
+	...
+	.pmxops = pmxops,
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
+The above functions except .list_positions are mandatory to implement for
+a pinmux driver. For hardware where each function can only exist in one
+position, you can omit this functions, and position 0 will be passed to all
+calls.
+
+
+Pinmux interaction with the GPIO subsystem
+==========================================
+
+The function list could become long, especially if you can convert every
+individual pin into a GPIO pin independent of any other pins, then your
+function array can become 64 entries for each GPIO setting and then the
+device functions. For this reason there is an additional function you
+can implement to enable only GPIO on an individual pin: pinmux_request_gpio()
+and pinmux_free_gpio().
+
+These functions use the .gpio_base and .gpio_pins members of the pin
+controller as described above for the pin controller, to look up the target
+pin controller.
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
+		.position = 1,
+		.dev_name = "foo-spi.0",
+	},
+	{
+		.ctrl_dev_name = "pinctrl.0",
+		.function = "i2c0",
+		.position = 0,
+		.dev_name = "foo-i2c.0",
+	},
+	{
+		.ctrl_dev_name = "pinctrl.0",
+		.function = "mmc0",
+		.position = 1,
+		.dev_name = "foo-mmc.0",
+	},
+};
+
+As you can see we may have several pin controllers on the system and thus
+we need to specify which one of them that contain the functions we wish
+to map. The map can also use struct device * directly, so there is no
+inherent need to use strings to specify .dev_name or .ctrl_dev_name, these
+are for the situation where you do not have a handle to the struct device *,
+for example if they are not yet instantiated or cumbersome to obtain.
+
+Since the above construct is pretty common there is a helper macro to make
+it even more compact which assumes you want to use pinctrl.0 and position
+0 for mapping, for example:
+
+static struct pinmux_map pmx_mapping[] = {
+       PINMUX_MAP_PRIMARY("i2c0", "foo-i2c.0"),
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
+Runtime pinmuxing
+=================
+
+It is possible to mux a certain function in and out at runtime, say to move
+an SPI port from one set of pins to another set of pins. Say for example for
+spi0 in the example above, we expose two different positions in the mapping
+to achieve this:
+
+static struct pinmux_map pmx_mapping[] = {
+	{
+		.name = "spi0-pos-A",
+		.ctrl_dev_name = "pinctrl.0",
+		.function = "spi0",
+		.position = 0,
+		.dev_name = "foo-spi.0",
+	},
+	{
+		.name = "spi0-pos-B",
+		.ctrl_dev_name = "pinctrl.0",
+		.function = "spi0",
+		.position = 1,
+		.dev_name = "foo-spi.0",
+	},
+	...
+};
+
+This snippet first muxes the function in position A, enables it, disables
+and releases it, and muxes it in on position B:
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
index 1d445f5..8c422d6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5001,6 +5001,11 @@ L:	linux-mtd@lists.infradead.org
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
index 0000000..adb0be0
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
+	  multiplexing.
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
index 0000000..762e9e8
--- /dev/null
+++ b/drivers/pinctrl/core.c
@@ -0,0 +1,539 @@
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
+/**
+ * Looks up a pin control device matching a certain pinmux map
+ */
+struct pinctrl_dev *get_pctrldev_for_pinmux_map(struct pinmux_map const *map)
+{
+	struct pinctrl_dev *pctldev = NULL;
+	bool found = false;
+
+	mutex_lock(&pinctrldev_list_mutex);
+	list_for_each_entry(pctldev, &pinctrldev_list, node) {
+		if (map->ctrl_dev &&  &pctldev->dev == map->ctrl_dev) {
+			/* Matched on device */
+			found = true;
+			break;
+		}
+
+		if (map->ctrl_dev_name &&
+		    !strcmp(dev_name(&pctldev->dev), map->ctrl_dev_name)) {
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
+	spin_lock(&pctldev->gpio_ranges_lock);
+	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
+		/* Check if we're in the valid range */
+		if (gpio >= range->base &&
+		    gpio < range->base + range->npins) {
+			spin_unlock(&pctldev->gpio_ranges_lock);
+			return range;
+		}
+	}
+	spin_unlock(&pctldev->gpio_ranges_lock);
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
+	spin_lock(&pctldev->gpio_ranges_lock);
+	list_add(&range->node, &pctldev->gpio_ranges);
+	spin_unlock(&pctldev->gpio_ranges_lock);
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+static int pinctrl_pins_show(struct seq_file *s, void *what)
+{
+	struct pinctrl_dev *pctldev = s->private;
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
+		seq_printf(s, "pin %d (%s)\n", pin,
+			   desc->name ? desc->name : "unnamed");
+	}
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
+	spin_lock(&pctldev->gpio_ranges_lock);
+	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
+		seq_printf(s, "%u: %s [%u - %u]\n", range->id, range->name,
+			   range->base, (range->base + range->npins - 1));
+	}
+	spin_unlock(&pctldev->gpio_ranges_lock);
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
+		if (ret)
+			return ERR_PTR(ret);
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
+	spin_lock_init(&pctldev->gpio_ranges_lock);
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
+	mutex_lock(&pinctrldev_list_mutex);
+	list_del(&pctldev->node);
+	device_unregister(&pctldev->dev);
+	mutex_unlock(&pinctrldev_list_mutex);
+	/* Destroy descriptor tree */
+	pinctrl_free_pindescs(pctldev, pctldev->desc->pins,
+			      pctldev->desc->npins);
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
index 0000000..283007c
--- /dev/null
+++ b/drivers/pinctrl/core.h
@@ -0,0 +1,24 @@
+/**
+ * struct pin_desc - pin descriptor for each physical pin in the arch
+ * @pctldev: corresponding pin control device
+ * @name: a name for the pin, e.g. the name of the pin/pad/finger on a
+ *	datasheet or such
+ * @mux_requested: whether the pin is already requested by pinmux or not
+ * @mux_function: a named muxing function for the pin that will be passed to
+ *	subdrivers and shown in debugfs etc
+ */
+struct pin_desc {
+	struct pinctrl_dev *pctldev;
+	char	name[16];
+	/* These fields only added when supporting pinmux drivers */
+#ifdef CONFIG_PINMUX
+	bool	mux_requested;
+	char	mux_function[16];
+#endif
+};
+
+struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, int pin);
+struct pinctrl_dev *get_pctrldev_for_pinmux_map(struct pinmux_map const *map);
+int pinctrl_get_device_gpio_range(unsigned gpio,
+				  struct pinctrl_dev **outdev,
+				  struct pinctrl_gpio_range **outrange);
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
new file mode 100644
index 0000000..310d344
--- /dev/null
+++ b/drivers/pinctrl/pinmux.c
@@ -0,0 +1,811 @@
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
+/* Global list of pinmuxes */
+static DEFINE_MUTEX(pinmux_list_mutex);
+static LIST_HEAD(pinmux_list);
+
+/**
+ * struct pinmux - per-device pinmux state holder
+ * @node: global list node - only for internal use
+ * @dev: the device using this pinmux
+ * @map: corresponding pinmux map active for this pinmux setting
+ * @usecount: the number of active users of this mux setting, used to keep
+ *	track of nested use cases
+ * @pins: an array of discrete physical pins used in this mapping, taken
+ *	from the global pin enumeration space (copied from pinmux map)
+ * @num_pins: the number of pins in this mapping array, i.e. the number of
+ *	elements in .pins so we can iterate over that array (copied from
+ *	pinmux map)
+ * @pctldev: pin control device handling this pinmux
+ * @pmxdev_selector: the function selector for the pinmux device handling
+ *	this pinmux
+ * @pmxdev_position: the function position for the pinmux device and
+ *	selector handling this pinmux
+ * @mutex: a lock for the pinmux state holder
+ */
+struct pinmux {
+	struct list_head node;
+	struct device *dev;
+	struct pinmux_map const *map;
+	unsigned usecount;
+	struct pinctrl_dev *pctldev;
+	unsigned pmxdev_selector;
+	unsigned pmxdev_position;
+	struct mutex mutex;
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
+	const struct pinmux_ops *ops;
+	int status = -EINVAL;
+
+	pr_debug("request pin %d for %s\n", pin, function);
+
+	if (!pin_is_valid(pctldev, pin)) {
+		pr_err("pin is invalid\n");
+		return -EINVAL;
+	}
+
+	if (!function) {
+		pr_err("no function name given\n");
+		return -EINVAL;
+	}
+
+	desc = pin_desc_get(pctldev, pin);
+	if (desc == NULL) {
+		pr_err("pin is not registered so it cannot be requested\n");
+		goto out;
+	}
+	if (desc->mux_requested) {
+		pr_err("pin already requested\n");
+		goto out;
+	}
+	ops = pctldev->desc->pmxops;
+
+	/* Let each pin increase references to this module */
+	if (!try_module_get(pctldev->owner)) {
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
+		status = ops->gpio_request_enable(pctldev, gpio_range, pin);
+	else if (ops->request)
+		status = ops->request(pctldev, pin);
+	else
+		status = 0;
+
+	if (status) {
+		pr_err("->request on device %s failed "
+		       "for pin %d\n",
+		       pctldev->desc->name, pin);
+		goto out;
+	}
+
+	desc->mux_requested = true;
+	strncpy(desc->mux_function, function, sizeof(desc->mux_function));
+
+out:
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
+static void pin_free(struct pinctrl_dev *pctldev, int pin)
+{
+	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	struct pin_desc *desc;
+
+	desc = pin_desc_get(pctldev, pin);
+	if (desc == NULL) {
+		pr_err("pin is not registered so it cannot be freed\n");
+		return;
+	}
+
+	if (ops->free)
+		ops->free(pctldev, pin);
+
+	desc->mux_requested = false;
+	desc->mux_function[0] = '\0';
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
+
+		if (!maps[i].dev && !maps[i].dev_name)
+			pr_debug("add anonymous function %s with no device\n",
+				 maps[i].function);
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
+ * @pctldev: the device to take the pins on
+ * @selector: the function selector to acquire the pins for
+ * @position: the function position to acquire the pins for
+ */
+static int acquire_pins(struct pinctrl_dev *pctldev, unsigned selector,
+			unsigned position)
+{
+	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	unsigned *pins;
+	unsigned num_pins;
+	const char *func = ops->get_function_name(pctldev, selector);
+	int ret;
+	int i;
+
+	ret = ops->get_function_pins(pctldev, selector, position,
+				     &pins, &num_pins);
+	if (ret)
+		return ret;
+
+	/* Try to allocate all pins in this pinmux map, one by one */
+	for (i = 0; i < num_pins; i++) {
+		ret = pin_request(pctldev, pins[i], func, false, NULL);
+		if (ret) {
+			pr_err("could not get pin %d for function %s "
+			       "on device %s - conflicting mux mappings?\n",
+			       pins[i], func ? : "(undefined)",
+			       pctldev->desc->name);
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
+ * @selector: the function selector to free the pins for
+ * @position: the function position to release the pins for
+ */
+static void release_pins(struct pinctrl_dev *pctldev, unsigned selector,
+			 unsigned position)
+{
+	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	unsigned *pins;
+	unsigned num_pins;
+	int ret;
+	int i;
+
+	ret = ops->get_function_pins(pctldev, selector, position,
+				     &pins, &num_pins);
+	if (ret) {
+		dev_err(&pctldev->dev, "could not get pins to release for "
+			"selector %d, position %d\n",
+			selector, position);
+		return;
+	}
+	for (i = 0; i < num_pins; i++)
+		pin_free(pctldev, pins[i]);
+}
+
+/**
+ * pinmux_check_position() - check that the pinmux driver can supply the
+ * function in a certain position
+ * @pctldev: device to check the position for
+ * @selector: the selector to check the position for
+ * @position: the position to check
+ */
+static int pinmux_check_position(struct pinctrl_dev *pctldev,
+				 unsigned selector, unsigned position)
+{
+	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	unsigned posit = 0;
+
+	/*
+	 * If the driver does not support different positions for the
+	 * functions, we only support position 0.
+	 */
+	if (!ops->list_positions) {
+		if (position != 0)
+			return -EINVAL;
+		return 0;
+	}
+
+	/* Else check that we support this position */
+	while (ops->list_positions(pctldev, selector, posit) >= 0) {
+		if (posit == position)
+			return 0;
+		posit++;
+	}
+
+	pr_err("%s does not support pinmux position %d for function %s\n",
+	       pctldev_get_name(pctldev), position,
+	       ops->get_function_name(pctldev, selector));
+	return -EINVAL;
+}
+
+/**
+ * pinmux_search_function() - search the pinmux driver for an applicable
+ * function in a specific position, returns the applicable selector if
+ * found
+ * @pctldev: device to check for function and position
+ * @map: function map containing the function and position to look for
+ */
+static int pinmux_search_function(struct pinctrl_dev *pctldev,
+				  struct pinmux_map const *map)
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
+			/* Found the function, check position */
+			ret = pinmux_check_position(pctldev, selector,
+						    map->position);
+			if (ret < 0)
+				return ret;
+			return selector;
+		}
+		selector++;
+	}
+
+	pr_err("%s does not support function %s\n",
+	       pctldev_get_name(pctldev), map->function);
+	return -EINVAL;
+}
+
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
+	bool found_map = false;
+	int ret = -ENODEV;
+
+	/* We must have dev or ID or both */
+	if (!dev && !name)
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&pinmux_list_mutex);
+
+	if (dev)
+		devname = dev_name(dev);
+
+	/* Iterate over the pinmux maps to locate the right one */
+	list_for_each_entry(pmx, &pinmux_list, node) {
+		map = pmx->map;
+
+		/*
+		 * First, try to find the pctldev given in the map
+		 */
+		pctldev = get_pctrldev_for_pinmux_map(map);
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
+		pr_debug("found pctldev %s to handle function %s",
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
+		if (!map->dev_name && (name != NULL)) {
+			found_map = true;
+			break;
+		}
+
+		/* If the mapping has a device set up it must match */
+		if (map->dev_name &&
+		    (!devname || !strcmp(map->dev_name, devname))) {
+			/* MATCH! */
+			found_map = true;
+			break;
+		}
+	}
+
+	mutex_unlock(&pinmux_list_mutex);
+
+	if (!found_map) {
+		pr_err("could not find mux map for device %s, ID %s\n",
+		       devname ? devname : "(anonymous)",
+		       name ? name : "(undefined)");
+		goto out;
+	}
+
+	/* Make sure that noone else is using this pinmux */
+	mutex_lock(&pmx->mutex);
+	if (pmx->dev) {
+		if (pmx->dev != dev) {
+			mutex_unlock(&pmx->mutex);
+			pr_err("mapping already in use device %s, ID %s\n",
+			       devname ? devname : "(anonymous)",
+			       name ? name : "(undefined)");
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
+	/* Now go into the driver and try to locate function @position */
+	ret = pinmux_search_function(pctldev, map);
+	if (ret < 0)
+		goto out;
+	else {
+		/* Found function @position */
+		unsigned selector = ret;
+
+		ret = acquire_pins(pctldev, selector, map->position);
+		if (ret)
+			goto out;
+		/* Found it! */
+		mutex_lock(&pmx->mutex);
+		pmx->dev = dev;
+		pmx->pctldev = pctldev;
+		pmx->pmxdev_selector = selector;
+		pmx->pmxdev_position = map->position;
+		mutex_unlock(&pmx->mutex);
+		ret = 0;
+		goto out;
+	}
+
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
+		pr_warn("releasing pinmux with active users!\n");
+	/* Release all pins taken on pinmux_get() */
+	release_pins(pmx->pctldev, pmx->pmxdev_selector, pmx->pmxdev_position);
+	pmx->dev = NULL;
+	pmx->pctldev = NULL;
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
+		struct pinctrl_dev *pctldev = pmx->pctldev;
+		const struct pinmux_ops *ops = pctldev->desc->pmxops;
+
+		ret = ops->enable(pctldev, pmx->pmxdev_selector,
+				  pmx->pmxdev_position);
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
+		struct pinctrl_dev *pctldev = pmx->pctldev;
+		const struct pinmux_ops *ops = pctldev->desc->pmxops;
+
+		ops->disable(pctldev, pmx->pmxdev_selector,
+			     pmx->pmxdev_position);
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
+	struct pinctrl_dev *pctldev;
+	const struct pinmux_ops *ops;
+	int ret = 0;
+
+	if (pmx == NULL)
+		return -ENODEV;
+
+	pctldev = pmx->pctldev;
+	ops = pctldev->desc->pmxops;
+
+	/* This operation is not mandatory to implement */
+	if (ops->config) {
+		mutex_lock(&pmx->mutex);
+		ret = ops->config(pctldev, pmx->pmxdev_selector, param, data);
+		mutex_unlock(&pmx->mutex);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinmux_config);
+
+int pinmux_check_ops(const struct pinmux_ops *ops)
+{
+	/* Check that we implement required operations */
+	if (!ops->list_functions ||
+	    !ops->get_function_name ||
+	    !ops->enable ||
+	    !ops->disable)
+		return -EINVAL;
+
+	return 0;
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+/* Called from pincontrol core */
+static int pinmux_functions_show(struct seq_file *s, void *what)
+{
+	struct pinctrl_dev *pctldev = s->private;
+	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	unsigned selector = 0;
+
+	while (ops->list_functions(pctldev, selector) >= 0) {
+		unsigned *pins;
+		unsigned num_pins;
+		const char *func = ops->get_function_name(pctldev, selector);
+		unsigned position = 0;
+		int ret;
+		int i;
+
+		while (ops->list_positions(pctldev, selector, position) >= 0) {
+			ret = ops->get_function_pins(pctldev, selector,
+						     position,
+						     &pins, &num_pins);
+
+			if (ret)
+				seq_printf(s, "%s [ERROR GETTING PINS]\n",
+					   func);
+
+			else {
+				seq_printf(s, "function: %s, position: %d pins = [ ",
+					   func, position);
+				for (i = 0; i < num_pins; i++)
+					seq_printf(s, "%d ", pins[i]);
+				seq_puts(s, "]\n");
+			}
+			position++;
+		}
+
+		selector++;
+
+	}
+
+	return 0;
+}
+
+static int pinmux_show(struct seq_file *s, void *what)
+{
+	struct pinmux *pmx;
+	const struct pinmux_map *map;
+
+	seq_puts(s, "System pinmuxes and their maps:\n");
+	list_for_each_entry(pmx, &pinmux_list, node) {
+		map = pmx->map;
+
+		seq_printf(s, "device: %s function: %s (%u), "
+			   "pos %u users: %u map-> %s\n",
+			   pmx->pctldev ? pctldev_get_name(pmx->pctldev) : "(no controller)",
+			   map->function,
+			   pmx->pmxdev_selector,
+			   map->position,
+			   pmx->usecount,
+			   pmx->dev ? dev_name(pmx->dev) : "(no device)");
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
+	if (pctldev == NULL) {
+		seq_puts(s, "device is gone\n");
+		return 0;
+	}
+
+	if (pctldev->desc == NULL) {
+		seq_puts(s, "device is lacking descriptor\n");
+		return 0;
+	}
+
+	seq_puts(s, "Pinmux settings per pin\n");
+	seq_puts(s, "Format: pin (name): pinmuxfunction [driver specifics]\n");
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
+		else {
+			seq_printf(s, "pin %d (%s): %s", pin,
+				   desc->name ? desc->name : "unnamed",
+				   desc->mux_requested ? desc->mux_function : "UNCLAIMED");
+
+			if (pctldev->desc->pmxops->dbg_show)
+				pctldev->desc->pmxops->dbg_show(pctldev, s, pin);
+		}
+		seq_puts(s, "\n");
+	}
+
+	return 0;
+}
+
+static int pinmux_functions_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinmux_functions_show, inode->i_private);
+}
+
+static int pinmux_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinmux_show, NULL);
+}
+
+static int pinmux_pins_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinmux_pins_show, inode->i_private);
+}
+
+static const struct file_operations pinmux_functions_ops = {
+	.open		= pinmux_functions_open,
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
+static const struct file_operations pinmux_pins_ops = {
+	.open		= pinmux_pins_open,
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
+}
+
+void pinmux_init_debugfs(struct dentry *subsys_root)
+{
+	debugfs_create_file("pinmuxes", S_IFREG | S_IRUGO,
+			    subsys_root, NULL, &pinmux_ops);
+}
+
+#endif /* CONFIG_DEBUG_FS */
diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
new file mode 100644
index 0000000..ab672ef
--- /dev/null
+++ b/drivers/pinctrl/pinmux.h
@@ -0,0 +1,4 @@
+int pinmux_check_ops(const struct pinmux_ops *ops);
+void pinmux_init_device_debugfs(struct dentry *devroot,
+				struct pinctrl_dev *pctldev);
+void pinmux_init_debugfs(struct dentry *subsys_root);
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
new file mode 100644
index 0000000..6da2471
--- /dev/null
+++ b/include/linux/pinctrl/machine.h
@@ -0,0 +1,74 @@
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
+ *	the name must be the same as in your struct device*
+ * @function: a function in the driver to use for this mapping, the driver
+ *	will lookup the function referenced by this ID on the specified
+ *	pin control device
+ * @position: sometimes a function has several possible positions in the
+ *	pin space, so this parameter accepts a certain position enumerator.
+ *	If for example a certain port can be mapped in three different
+ *	locations this could be 0, 1 or 2
+ * @dev: the device using this specific mapping, may be NULL if you provide
+ *	.dev_name instead (this is more common)
+ * @dev_name: the name of the device using this specific mapping, the name
+ *	must be the same as in your struct device*
+ */
+struct pinmux_map {
+	const char *name;
+	struct device *ctrl_dev;
+	const char *ctrl_dev_name;
+	const char *function;
+	unsigned position;
+	struct device *dev;
+	const char *dev_name;
+};
+
+/*
+ * Convenience macro to set a simple map from a certain pin controller and a
+ * certain function to a named device
+ */
+#define PINMUX_MAP(a, b, c) \
+	{ .ctrl_dev_name = a, .function = b, .dev_name = c }
+/*
+ * Convenience macro to map a function onto the primary device pinctrl device
+ * this is especially helpful on systems that have only one pin controller
+ * or need to set up a lot of mappings on the primary controller.
+ */
+#define PINMUX_MAP_PRIMARY(a, b) \
+	{ .ctrl_dev_name = "pinctrl.0", .function = a, .dev_name = b }
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
index 0000000..0294e39
--- /dev/null
+++ b/include/linux/pinctrl/pinctrl.h
@@ -0,0 +1,143 @@
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
+
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
+ * @name: a name for the chip in this range
+ * @id: an ID number for the chip in this range
+ * @base: base offset of the GPIO range
+ * @npins: number of pins in the GPIO range, including the base number
+ * @gc: an optional pointer to a gpio_chip
+ * @node: list node for internal use
+ */
+struct pinctrl_gpio_range {
+	const char name[16];
+	unsigned int id;
+	unsigned int base;
+	unsigned int npins;
+	struct gpio_chip *gc;
+	struct list_head node;
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
+ * @pmxops: pinmux operation vtable, if you support pinmuxing in your driver
+ * @owner: module providing the pin controller, used for refcounting
+ */
+struct pinctrl_desc {
+	const char *name;
+	struct pinctrl_pin_desc const *pins;
+	unsigned int npins;
+	unsigned int maxpin;
+	struct pinmux_ops *pmxops;
+	struct module *owner;
+};
+
+/**
+ * struct pinctrl_dev - pin control class device
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
+ * @node: node to include this pin controller in the global pin controller list
+ *
+ * This should be dereferenced and used by the pin controller core ONLY
+ */
+struct pinctrl_dev {
+	struct pinctrl_desc *desc;
+	struct radix_tree_root pin_desc_tree;
+	spinlock_t pin_desc_tree_lock;
+	struct list_head gpio_ranges;
+	spinlock_t gpio_ranges_lock;
+	struct device dev;
+	struct module *owner;
+	void *driver_data;
+	struct list_head node;
+};
+
+/* These should only be used from drivers */
+static inline const char *pctldev_get_name(struct pinctrl_dev *pctldev)
+{
+	/* We're not allowed to register devices without name */
+	return pctldev->desc->name;
+}
+
+static inline void *pctldev_get_drvdata(struct pinctrl_dev *pctldev)
+{
+	return pctldev->driver_data;
+}
+
+/* External interface to pin controller */
+extern struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
+				struct device *dev, void *driver_data);
+extern void pinctrl_unregister(struct pinctrl_dev *pctldev);
+extern bool pin_is_valid(struct pinctrl_dev *pctldev, int pin);
+extern void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
+				   struct pinctrl_gpio_range *range);
+#else
+
+struct pinctrl_dev;
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
index 0000000..2583cc7
--- /dev/null
+++ b/include/linux/pinctrl/pinmux.h
@@ -0,0 +1,135 @@
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
+ * @list_positions: list the number of selectable positions for a certain
+ *	function selector, the core will begin on 0 and call this repeatedly
+ *	as long as it returns >= 0 to enumerate positions
+ * @get_function_name: return the function name of the muxing selector,
+ *	called by the core to figure out which mux setting it shall map a
+ *	certain device to
+ * @get_function_pins: return an array of pins corresponding to a certain
+ *	function selector and position in @pins, and the size of the array
+ *	in @num_pins
+ * @enable: enable a certain muxing function on a certain position. The driver
+ *	does not need to figure out whether enabling this function conflicts
+ *	some other use of the pins, such collisions are handled by the pinmux
+ *	subsystem
+ * @disable: disable a certain muxing selector on a certain position.
+ * @config: custom configuration function for a certain muxing selector -
+ *	this works a bit like an ioctl() and can pass in and return arbitrary
+ *	configuration data to the pinmux. Currently we do not pass in the
+ *	position to this call, refactor if need be
+ * @gpio_request_enable: requests and enables GPIO on a certain pin.
+ *	Implement this only if you can mux every pin individually as GPIO. The
+ *	affected GPIO range is passed along with an offset into that
+ *	specific GPIO range - function selectors and positions are orthogonal
+ *	to this, the core will however make sure the pins do not collide
+ * @dbg_show: optional debugfs display hook that will provide per-device
+ *	info for a certain pin in debugfs
+ */
+struct pinmux_ops {
+	int (*request) (struct pinctrl_dev *pctldev, unsigned offset);
+	int (*free) (struct pinctrl_dev *pctldev, unsigned offset);
+	int (*list_functions) (struct pinctrl_dev *pctldev, unsigned selector);
+	int (*list_positions) (struct pinctrl_dev *pctldev, unsigned selector,
+			       unsigned position);
+	const char *(*get_function_name) (struct pinctrl_dev *pctldev,
+					  unsigned selector);
+	int (*get_function_pins) (struct pinctrl_dev *pctldev,
+				  unsigned selector, unsigned position,
+				  unsigned ** const pins,
+				  unsigned * const num_pins);
+	int (*enable) (struct pinctrl_dev *pctldev, unsigned selector,
+		       unsigned position);
+	void (*disable) (struct pinctrl_dev *pctldev, unsigned selector,
+			 unsigned position);
+	int (*config) (struct pinctrl_dev *pctldev, unsigned selector,
+		       u16 param, unsigned long *data);
+	int (*gpio_request_enable) (struct pinctrl_dev *pctldev,
+				    struct pinctrl_gpio_range *range,
+				    unsigned offset);
+	void (*dbg_show) (struct pinctrl_dev *pctldev, struct seq_file *s,
+			  unsigned offset);
+};
+
+/* External interface to pinmux */
+extern int pinmux_request_gpio(unsigned gpio);
+extern void pinmux_free_gpio(unsigned gpio);
+extern struct pinmux *pinmux_get(struct device *dev, const char *name);
+extern void pinmux_put(struct pinmux *pmx);
+extern int pinmux_enable(struct pinmux *pmx);
+extern void pinmux_disable(struct pinmux *pmx);
+extern int pinmux_config(struct pinmux *pmx, u16 param, unsigned long *data);
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
+static inline struct pinmux *pinmux_get(struct device *dev, const char *name)
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
+#endif /* __LINUX_PINCTRL_PINMUX_H */
-- 
1.7.3.2

