Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab1J1FmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 01:42:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12533 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1J1FmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 01:42:14 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-e9-4eaa40a64fdb
From: Chanho Park <chanho61.park@samsung.com>
To: linus.walleij@linaro.org, swarren@nvidia.com, Barry.Song@csr.com,
        Rongjun.Ying@csr.com
Cc: linux-kernel@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCHv2] drivers: pinctrl: add a pin_base for sparse gpio-ranges
Date: Fri, 28 Oct 2011 14:41:44 +0900
Message-id: <1319780504-23816-1-git-send-email-chanho61.park@samsung.com>
X-Mailer: git-send-email 1.7.5.4
X-OriginalArrivalTime: 28 Oct 2011 05:41:46.0320 (UTC)
 FILETIME=[47D9DD00:01CC9534]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables mapping a base offset of gpio ranges with
a pin offset even if does'nt matched. A "base" of pinctrl_gpio_range
means a start offset of gpio. However, we cannot convert gpio to pin
number for sparse gpio ranges just only using a gpio base offset.
We can convert a gpio to real pin number using a new pin_base
(which means a base pin offset of requested gpio range).
If the pin_base is not specified explicitly, the controller sybsystem
makes to equal with gpio's base offset. Now, a pinctrl subsystem passes
the pin number to the driver instead a offset.

For example, let's assume below two gpio ranges in the system.

static struct pinctrl_gpio_range gpio_range_a = {
    .name = "chip a",
    .id = 0,
    .base = 32,
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

{
    struct pinctrl_dev *pctl;
    ...
    pinctrl_add_gpio_range(pctl, &gpio_range_a);
    pinctrl_add_gpio_range(pctl, &gpio_range_b);
}

We can calucalate a exact pin ranges even if doesn't matched with gpio ranges.

chip a:
    gpio-range : [32 .. 47]
    pin-range  : [32 .. 47]
chip b:
    gpio-range : [48 .. 55]
    pin-range  : [64 .. 71]

Changelog v1->v2:
 - Update documentation about gpio parts.
 - A pin_base makes to equal with gpio's base if not specified explicitly.
 - Modify a offset calculation of sirf's driver.
 - Modify a parameter name of gpio_request_enable.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/pinctrl.txt       |   41 ++++++++++++++++----------------------
 drivers/pinctrl/core.c          |    4 +++
 drivers/pinctrl/pinmux-sirf.c   |    4 +-
 drivers/pinctrl/pinmux.c        |    4 +-
 include/linux/pinctrl/pinctrl.h |    3 ++
 include/linux/pinctrl/pinmux.h  |    2 +-
 6 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 328adb7..5733a6c 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -273,6 +273,7 @@ static struct pinctrl_gpio_range gpio_range_a = {
 	.name = "chip b",
 	.id = 0,
 	.base = 48,
+	.pin_base = 64,
 	.npins = 8,
 	.gc = &chip_b;
 };
@@ -286,11 +287,19 @@ static struct pinctrl_gpio_range gpio_range_a = {
 }
 
 So this complex system has one pin controller handling two different
-GPIO chips. Chip a has 16 pins and chip b has 8 pins. They are mapped in
-the global GPIO pin space at:
-
-chip a: [32 .. 47]
-chip b: [48 .. 55]
+GPIO chips. Chip a has 16 pins and chip b has 8 pins. The chip b has
+pin_base(which means a start pin number of the gpio_range), the pin range
+of the chip b starts from 64. We can convert a gpio number to actual pin
+number using this "pin_base". If "pin_base" is not specified explicitly like
+chip a, the pin_base of the chip is equal to a gpio base.
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
@@ -300,28 +309,12 @@ will be called on that specific pin controller.
 
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
 
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index a13354e..4d9fc44 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -261,11 +261,15 @@ int pinctrl_get_device_gpio_range(unsigned gpio,
  *
  * This adds a range of GPIOs to be handled by a certain pin controller. Call
  * this to register handled ranges after registering your pin controller.
+ * If a pin_base offset is not specified explicitly,
+ * it is equal to a gpio base offset.
  */
 void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 			    struct pinctrl_gpio_range *range)
 {
 	mutex_lock(&pctldev->gpio_ranges_lock);
+	if (!range->pin_base)
+		range->pin_base = range->base;
 	list_add(&range->node, &pctldev->gpio_ranges);
 	mutex_unlock(&pctldev->gpio_ranges_lock);
 }
diff --git a/drivers/pinctrl/pinmux-sirf.c b/drivers/pinctrl/pinmux-sirf.c
index ba73523..3dade7a 100644
--- a/drivers/pinctrl/pinmux-sirf.c
+++ b/drivers/pinctrl/pinmux-sirf.c
@@ -1056,7 +1056,7 @@ static int sirfsoc_pinmux_get_groups(struct pinctrl_dev *pctldev, unsigned selec
 }
 
 static int sirfsoc_pinmux_request_gpio(struct pinctrl_dev *pmxdev,
-	struct pinctrl_gpio_range *range, unsigned offset)
+	struct pinctrl_gpio_range *range, unsigned pin)
 {
 	struct sirfsoc_pmx *spmx;
 
@@ -1067,7 +1067,7 @@ static int sirfsoc_pinmux_request_gpio(struct pinctrl_dev *pmxdev,
 	spmx = pinctrl_dev_get_drvdata(pmxdev);
 
 	muxval = readl(spmx->gpio_virtbase + SIRFSOC_GPIO_PAD_EN(group));
-	muxval = muxval | (1 << offset);
+	muxval = muxval | (1 << (pin - range->pin_base));
 	writel(muxval, spmx->gpio_virtbase + SIRFSOC_GPIO_PAD_EN(group));
 
 	return 0;
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 5c4b782..d1384da 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -225,7 +225,7 @@ int pinmux_request_gpio(unsigned gpio)
 		return -EINVAL;
 
 	/* Convert to the pin controllers number space */
-	pin = gpio - range->base;
+	pin = gpio - range->base + range->pin_base;
 
 	/* Conjure some name stating what chip and pin this is taken by */
 	snprintf(gpiostr, 15, "%s:%d", range->name, gpio);
@@ -258,7 +258,7 @@ void pinmux_free_gpio(unsigned gpio)
 		return;
 
 	/* Convert to the pin controllers number space */
-	pin = gpio - range->base;
+	pin = gpio - range->base + range->pin_base;
 
 	pin_free(pctldev, pin, true);
 }
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 90dd28b..7afd099 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -127,6 +127,8 @@ struct pinctrl_pin_desc {
  * @name: a name for the chip in this range
  * @id: an ID number for the chip in this range
  * @base: base offset of the GPIO range
+ * @pin_base: base pin number of the GPIO range
+ *            (If not specified, it's equal to @base)
  * @npins: number of pins in the GPIO range, including the base number
  * @gc: an optional pointer to a gpio_chip
  */
@@ -135,6 +137,7 @@ struct pinctrl_gpio_range {
 	const char *name;
 	unsigned int id;
 	unsigned int base;
+	unsigned int pin_base;
 	unsigned int npins;
 	struct gpio_chip *gc;
 };
diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
index 3c430e7..9dd5c90 100644
--- a/include/linux/pinctrl/pinmux.h
+++ b/include/linux/pinctrl/pinmux.h
@@ -72,7 +72,7 @@ struct pinmux_ops {
 			 unsigned group_selector);
 	int (*gpio_request_enable) (struct pinctrl_dev *pctldev,
 				    struct pinctrl_gpio_range *range,
-				    unsigned offset);
+				    unsigned pin);
 };
 
 /* External interface to pinmux */
-- 
1.7.5.4

