Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab1KKJsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 04:48:24 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23985 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab1KKJsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 04:48:22 -0500
X-AuditID: cbfee61b-b7b7fae000005864-b3-4ebcef638980
From: Chanho Park <chanho61.park@samsung.com>
To: linus.walleij@linaro.org, swarren@nvidia.com, Baohua.Song@csr.com
Cc: linux-kernel@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCHv3] pinctrl: add a pin_base for sparse gpio-ranges
Date: Fri, 11 Nov 2011 18:47:58 +0900
Message-id: <1321004878-17534-1-git-send-email-chanho61.park@samsung.com>
X-Mailer: git-send-email 1.7.5.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables mapping a base offset of gpio ranges with
a pin offset even if does'nt matched. A base of pinctrl_gpio_range
means a base offset of gpio. However, we cannot convert gpio to pin
number for sparse gpio ranges just only using a gpio base offset.
We can convert a gpio to real pin number(even if not matched) using
a new pin_base which means a base pin offset of requested gpio range.
Now, the pin control subsystem passes the pin base offset to the
pinmux driver.

For example, let's assume below two gpio ranges in the system.

static struct pinctrl_gpio_range gpio_range_a = {
    .name = "chip a",
    .id = 0,
    .base = 32,
    .pin_base = 32,
    .npins = 16,
    .gc = &chip_a;
};

static struct pinctrl_gpio_range gpio_range_b = {
    .name = "chip b",
    .id = 0,
    .base = 48,
    .pin_base = 64,
    .npins = 8,
    .gc = &chip_b;
};

We can calucalate a exact pin ranges even if doesn't matched with gpio ranges.

chip a:
    gpio-range : [32 .. 47]
    pin-range  : [32 .. 47]
chip b:
    gpio-range : [48 .. 55]
    pin-range  : [64 .. 71]

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changelog v2->v3:
 - Assign a pin_base explicitly(From Stepthen's advice)
 - Revert a parameter name of the gpio_request_enable to "offset".

Changelog v1->v2:
 - Update documentation about gpio parts.
 - A pin_base makes to equal with gpio's base if not specified explicitly.
 - Modify a offset calculation of sirf's driver.
 - Modify a parameter name of gpio_request_enable.
---
 Documentation/pinctrl.txt       |   44 +++++++++++++++++---------------------
 drivers/pinctrl/pinmux-sirf.c   |    6 ++++-
 drivers/pinctrl/pinmux-u300.c   |    1 +
 drivers/pinctrl/pinmux.c        |    4 +-
 include/linux/pinctrl/pinctrl.h |    2 +
 include/linux/pinctrl/pinmux.h  |    2 +-
 6 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index a05e23b..a067841 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -265,6 +265,7 @@ static struct pinctrl_gpio_range gpio_range_a = {
 	.name = "chip a",
 	.id = 0,
 	.base = 32,
+	.pin_base = 32,
 	.npins = 16,
 	.gc = &chip_a;
 };
@@ -273,6 +274,7 @@ static struct pinctrl_gpio_range gpio_range_a = {
 	.name = "chip b",
 	.id = 0,
 	.base = 48,
+	.pin_base = 64,
 	.npins = 8,
 	.gc = &chip_b;
 };
@@ -286,11 +288,21 @@ static struct pinctrl_gpio_range gpio_range_a = {
 }
 
 So this complex system has one pin controller handling two different
-GPIO chips. Chip a has 16 pins and chip b has 8 pins. They are mapped in
-the global GPIO pin space at:
-
-chip a: [32 .. 47]
-chip b: [48 .. 55]
+GPIO chips. "chip a" has 16 pins and "chip b" has 8 pins. The "chip a" and
+"chip b" have pin_base(which means a start pin number of the gpio_range).
+The gpio_range of the "chip a" starts from the beginning of 32 and actual
+pin_range also starts from 32. However, the "chip b" has different starting
+offset of the gpio_range and pin_range. The gpio_range of "chip b" starts
+from the beginning of 48. However, the pin_range of "chip b" starts from 64.
+We can convert a gpio number to actual pin number using this "pin_base".
+They are mapped in the global GPIO pin space at:
+
+chip a:
+ - gpio range : [32 .. 47]
+ - pin range  : [32 .. 47]
+chip b:
+ - gpio range : [48 .. 55]
+ - pin range  : [64 .. 71]
 
 When GPIO-specific functions in the pin control subsystem are called, these
 ranges will be used to look up the apropriate pin controller by inspecting
@@ -300,28 +312,12 @@ will be called on that specific pin controller.
 
 For all functionalities dealing with pin biasing, pin muxing etc, the pin
 controller subsystem will subtract the range's .base offset from the passed
-in gpio pin number, and pass that on to the pin control driver, so the driver
-will get an offset into its handled number range. Further it is also passed
+in gpio number, and add the ranges's .pin_base offset to retrive a pin number.
+After that, the subsystem passes it on to the pin control driver, so the driver
+will get an pin number into its handled number range. Further it is also passed
 the range ID value, so that the pin controller knows which range it should
 deal with.
 
-For example: if a user issues pinctrl_gpio_set_foo(50), the pin control
-subsystem will find that the second range on this pin controller matches,
-subtract the base 48 and call the
-pinctrl_driver_gpio_set_foo(pinctrl, range, 2) where the latter function has
-this signature:
-
-int pinctrl_driver_gpio_set_foo(struct pinctrl_dev *pctldev,
-    struct pinctrl_gpio_range *rangeid,
-    unsigned offset);
-
-Now the driver knows that we want to do some GPIO-specific operation on the
-second GPIO range handled by "chip b", at offset 2 in that specific range.
-
-(If the GPIO subsystem is ever refactored to use a local per-GPIO controller
-pin space, this mapping will need to be augmented accordingly.)
-
-
 PINMUX interfaces
 =================
 
diff --git a/drivers/pinctrl/pinmux-sirf.c b/drivers/pinctrl/pinmux-sirf.c
index d76cae6..c3ade82 100644
--- a/drivers/pinctrl/pinmux-sirf.c
+++ b/drivers/pinctrl/pinmux-sirf.c
@@ -1067,7 +1067,7 @@ static int sirfsoc_pinmux_request_gpio(struct pinctrl_dev *pmxdev,
 	spmx = pinctrl_dev_get_drvdata(pmxdev);
 
 	muxval = readl(spmx->gpio_virtbase + SIRFSOC_GPIO_PAD_EN(group));
-	muxval = muxval | (1 << offset);
+	muxval = muxval | (1 << (offset - range->pin_base));
 	writel(muxval, spmx->gpio_virtbase + SIRFSOC_GPIO_PAD_EN(group));
 
 	return 0;
@@ -1100,21 +1100,25 @@ static struct pinctrl_gpio_range sirfsoc_gpio_ranges[] = {
 		.name = "sirfsoc-gpio*",
 		.id = 0,
 		.base = 0,
+		.pin_base = 0,
 		.npins = 32,
 	}, {
 		.name = "sirfsoc-gpio*",
 		.id = 1,
 		.base = 32,
+		.pin_base = 32,
 		.npins = 32,
 	}, {
 		.name = "sirfsoc-gpio*",
 		.id = 2,
 		.base = 64,
+		.pin_base = 64,
 		.npins = 32,
 	}, {
 		.name = "sirfsoc-gpio*",
 		.id = 3,
 		.base = 96,
+		.pin_base = 96,
 		.npins = 19,
 	},
 };
diff --git a/drivers/pinctrl/pinmux-u300.c b/drivers/pinctrl/pinmux-u300.c
index 4858a64..dab0cfe 100644
--- a/drivers/pinctrl/pinmux-u300.c
+++ b/drivers/pinctrl/pinmux-u300.c
@@ -1023,6 +1023,7 @@ static struct pinctrl_gpio_range u300_gpio_range = {
 	.name = "COH901*",
 	.id = 0,
 	.base = 0,
+	.pin_base = 0,
 	.npins = 64,
 };
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 6738162..eb16912 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -233,7 +233,7 @@ int pinmux_request_gpio(unsigned gpio)
 		return -EINVAL;
 
 	/* Convert to the pin controllers number space */
-	pin = gpio - range->base;
+	pin = gpio - range->base + range->pin_base;
 
 	/* Conjure some name stating what chip and pin this is taken by */
 	snprintf(gpiostr, 15, "%s:%d", range->name, gpio);
@@ -267,7 +267,7 @@ void pinmux_free_gpio(unsigned gpio)
 		return;
 
 	/* Convert to the pin controllers number space */
-	pin = gpio - range->base;
+	pin = gpio - range->base + range->pin_base;
 
 	func = pin_free(pctldev, pin, range);
 	kfree(func);
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 90dd28b..0cd2faa 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -127,6 +127,7 @@ struct pinctrl_pin_desc {
  * @name: a name for the chip in this range
  * @id: an ID number for the chip in this range
  * @base: base offset of the GPIO range
+ * @pin_base: base pin number of the GPIO range
  * @npins: number of pins in the GPIO range, including the base number
  * @gc: an optional pointer to a gpio_chip
  */
@@ -135,6 +136,7 @@ struct pinctrl_gpio_range {
 	const char *name;
 	unsigned int id;
 	unsigned int base;
+	unsigned int pin_base;
 	unsigned int npins;
 	struct gpio_chip *gc;
 };
diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
index 350e32a..bb7a979 100644
--- a/include/linux/pinctrl/pinmux.h
+++ b/include/linux/pinctrl/pinmux.h
@@ -52,7 +52,7 @@ struct pinctrl_dev;
  * @disable: disable a certain muxing selector with a certain pin group
  * @gpio_request_enable: requests and enables GPIO on a certain pin.
  *	Implement this only if you can mux every pin individually as GPIO. The
- *	affected GPIO range is passed along with an offset into that
+ *	affected GPIO range is passed along with an offset(pin number) into that
  *	specific GPIO range - function selectors and pin groups are orthogonal
  *	to this, the core will however make sure the pins do not collide
  */
-- 
1.7.5.4

