Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288Ab1D0NOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:14:53 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:45045 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759161Ab1D0NOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:14:49 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 09/10] gpio/nomadik-gpio: factor out state cast function
Date: Wed, 27 Apr 2011 15:14:27 +0200
Message-ID: <1303910067-3571-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This factors out the container_of() magic to dereference the
state struct from the gpio_chip into an inline function and adds
a dummy config function.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/nomadik-gpio.c  |   34 ++++++++++++++++++++++------------
 include/linux/gpio/nomadik.h |    2 ++
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/nomadik-gpio.c b/drivers/gpio/nomadik-gpio.c
index b30b6a2..b8d5bae 100644
--- a/drivers/gpio/nomadik-gpio.c
+++ b/drivers/gpio/nomadik-gpio.c
@@ -67,6 +67,14 @@ static DEFINE_SPINLOCK(nmk_gpio_slpm_lock);
 
 #define NUM_BANKS ARRAY_SIZE(nmk_gpio_chips)
 
+static inline struct nmk_gpio_chip *to_nmk_chip(struct gpio_chip *chip)
+{
+	struct nmk_gpio_chip *nmk_chip =
+		container_of(chip, struct nmk_gpio_chip, chip);
+
+	return nmk_chip;
+}
+
 static void __nmk_gpio_set_mode(struct nmk_gpio_chip *nmk_chip,
 				unsigned offset, int gpio_mode)
 {
@@ -512,6 +520,13 @@ int nmk_gpio_get_mode(int gpio)
 }
 EXPORT_SYMBOL(nmk_gpio_get_mode);
 
+static int nmk_gpio_config(struct gpio_chip *chip, unsigned offset,
+			   u16 param, unsigned long *data)
+{
+	struct nmk_gpio_chip *nmk_chip = to_nmk_chip(chip);
+
+	return 0;
+}
 
 /* IRQ functions */
 static inline int nmk_gpio_get_bitmask(int gpio)
@@ -804,8 +819,7 @@ static int nmk_gpio_init_irq(struct nmk_gpio_chip *nmk_chip)
 /* I/O Functions */
 static int nmk_gpio_make_input(struct gpio_chip *chip, unsigned offset)
 {
-	struct nmk_gpio_chip *nmk_chip =
-		container_of(chip, struct nmk_gpio_chip, chip);
+	struct nmk_gpio_chip *nmk_chip = to_nmk_chip(chip);
 
 	clk_enable(nmk_chip->clk);
 
@@ -818,8 +832,7 @@ static int nmk_gpio_make_input(struct gpio_chip *chip, unsigned offset)
 
 static int nmk_gpio_get_input(struct gpio_chip *chip, unsigned offset)
 {
-	struct nmk_gpio_chip *nmk_chip =
-		container_of(chip, struct nmk_gpio_chip, chip);
+	struct nmk_gpio_chip *nmk_chip = to_nmk_chip(chip);
 	u32 bit = 1 << offset;
 	int value;
 
@@ -835,8 +848,7 @@ static int nmk_gpio_get_input(struct gpio_chip *chip, unsigned offset)
 static void nmk_gpio_set_output(struct gpio_chip *chip, unsigned offset,
 				int val)
 {
-	struct nmk_gpio_chip *nmk_chip =
-		container_of(chip, struct nmk_gpio_chip, chip);
+	struct nmk_gpio_chip *nmk_chip = to_nmk_chip(chip);
 
 	clk_enable(nmk_chip->clk);
 
@@ -848,8 +860,7 @@ static void nmk_gpio_set_output(struct gpio_chip *chip, unsigned offset,
 static int nmk_gpio_make_output(struct gpio_chip *chip, unsigned offset,
 				int val)
 {
-	struct nmk_gpio_chip *nmk_chip =
-		container_of(chip, struct nmk_gpio_chip, chip);
+	struct nmk_gpio_chip *nmk_chip = to_nmk_chip(chip);
 
 	clk_enable(nmk_chip->clk);
 
@@ -862,8 +873,7 @@ static int nmk_gpio_make_output(struct gpio_chip *chip, unsigned offset,
 
 static int nmk_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	struct nmk_gpio_chip *nmk_chip =
-		container_of(chip, struct nmk_gpio_chip, chip);
+	struct nmk_gpio_chip *nmk_chip = to_nmk_chip(chip);
 
 	return NOMADIK_GPIO_TO_IRQ(nmk_chip->chip.base) + offset;
 }
@@ -878,8 +888,7 @@ static void nmk_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 	unsigned		i;
 	unsigned		gpio = chip->base;
 	int			is_out;
-	struct nmk_gpio_chip *nmk_chip =
-		container_of(chip, struct nmk_gpio_chip, chip);
+	struct nmk_gpio_chip *nmk_chip = to_nmk_chip(chip);
 	const char *modes[] = {
 		[NMK_GPIO_ALT_GPIO]	= "gpio",
 		[NMK_GPIO_ALT_A]	= "altA",
@@ -947,6 +956,7 @@ static struct gpio_chip nmk_gpio_template = {
 	.get			= nmk_gpio_get_input,
 	.direction_output	= nmk_gpio_make_output,
 	.set			= nmk_gpio_set_output,
+	.config			= nmk_gpio_config,
 	.to_irq			= nmk_gpio_to_irq,
 	.dbg_show		= nmk_gpio_dbg_show,
 	.can_sleep		= 0,
diff --git a/include/linux/gpio/nomadik.h b/include/linux/gpio/nomadik.h
index cc956d1..c16ee56 100644
--- a/include/linux/gpio/nomadik.h
+++ b/include/linux/gpio/nomadik.h
@@ -12,6 +12,8 @@
 #ifndef __GPIO_NOMADIK_H
 #define __GPIO_NOMADIK_H
 
+#include <linux/gpio.h>
+
 /*
  * "nmk_gpio" and "NMK_GPIO" stand for "Nomadik GPIO", leaving
  * the "gpio" namespace for generic and cross-machine functions
-- 
1.7.3.2

