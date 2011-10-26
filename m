Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab1JZEW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 00:22:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39122 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab1JZEWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 00:22:25 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-14-4ea78affed0d
From: Chanho Park <chanho61.park@samsung.com>
To: linus.walleij@linaro.org, swarren@nvidia.com, Baohua.Song@csr.com,
        linux-kernel@vger.kernel.org
Cc: Chanho Park <chanho61.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] drivers: pinctrl: add a pin_base for sparse gpio-ranges
Date: Wed, 26 Oct 2011 13:22:23 +0900
Message-id: <1319602943-17946-1-git-send-email-chanho61.park@samsung.com>
X-Mailer: git-send-email 1.7.5.4
X-OriginalArrivalTime: 26 Oct 2011 04:22:11.0936 (UTC)
 FILETIME=[D5452E00:01CC9396]
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

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/pinctrl.txt       |   42 ++++++++------------------------------
 drivers/pinctrl/pinmux-sirf.c   |    4 +++
 drivers/pinctrl/pinmux-u300.c   |    1 +
 drivers/pinctrl/pinmux.c        |    4 +-
 include/linux/pinctrl/pinctrl.h |    2 +
 5 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 328adb7..41244e4 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -265,14 +265,16 @@ static struct pinctrl_gpio_range gpio_range_a = {
 	.name = "chip a",
 	.id = 0,
 	.base = 32,
+	.pin_base = 32,
 	.npins = 16,
 	.gc = &chip_a;
 };
 
-static struct pinctrl_gpio_range gpio_range_a = {
+static struct pinctrl_gpio_range gpio_range_b = {
 	.name = "chip b",
 	.id = 0,
 	.base = 48,
+	.pin_base = 64,
 	.npins = 8,
 	.gc = &chip_b;
 };
@@ -289,38 +291,12 @@ So this complex system has one pin controller handling two different
 GPIO chips. Chip a has 16 pins and chip b has 8 pins. They are mapped in
 the global GPIO pin space at:
 
-chip a: [32 .. 47]
-chip b: [48 .. 55]
-
-When GPIO-specific functions in the pin control subsystem are called, these
-ranges will be used to look up the apropriate pin controller by inspecting
-and matching the pin to the pin ranges across all controllers. When a
-pin controller handling the matching range is found, GPIO-specific functions
-will be called on that specific pin controller.
-
-For all functionalities dealing with pin biasing, pin muxing etc, the pin
-controller subsystem will subtract the range's .base offset from the passed
-in gpio pin number, and pass that on to the pin control driver, so the driver
-will get an offset into its handled number range. Further it is also passed
-the range ID value, so that the pin controller knows which range it should
-deal with.
-
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
+chip a:
+	gpio-range : [32 .. 47]
+	pin-range  : [32 .. 47]
+chip b:
+	gpio-range : [48 .. 55]
+	pin-range  : [64 .. 71]
 
 PINMUX interfaces
 =================
diff --git a/drivers/pinctrl/pinmux-sirf.c b/drivers/pinctrl/pinmux-sirf.c
index ba73523..c9c277f 100644
--- a/drivers/pinctrl/pinmux-sirf.c
+++ b/drivers/pinctrl/pinmux-sirf.c
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
index 90dd28b..7768e44 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -127,6 +127,7 @@ struct pinctrl_pin_desc {
  * @name: a name for the chip in this range
  * @id: an ID number for the chip in this range
  * @base: base offset of the GPIO range
+ * @pin_base: base pin offset of the GPIO range
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
-- 
1.7.5.4

