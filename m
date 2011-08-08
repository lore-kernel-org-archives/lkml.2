Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab1HHIup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 04:50:45 -0400
Received: from mail0.scram.de ([78.47.204.202]:51716 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab1HHIun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 04:50:43 -0400
Authentication-Results: localhost; dkim=pass (1024-bit key)
	header.i=@scram.de; dkim-asp=signed
X-Spam-Flag: NO
X-Spam-Score: -4.377
Authentication-Results: amavis.colab.de (amavisd-new); dkim=pass
	header.i=@scram.de
From: Jochen Friedrich <jochen@scram.de>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        bryan.wu@canonical.com, kristoffer.ericson@gmail.com
Cc: linux-kernel@vger.kernel.org, Jochen Friedrich <jochen@scram.de>
Subject: [PATCH 3.2 3/4] ARM: simpad: add GPIO based device definitions.
Date: Mon,  8 Aug 2011 10:49:38 +0200
Message-Id: <1312793379-6020-4-git-send-email-jochen@scram.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1312793379-6020-1-git-send-email-jochen@scram.de>
References: <1312793379-6020-1-git-send-email-jochen@scram.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register keyboard, polled keyboard and I2C platform
devices based on GPIOs.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/arm/mach-sa1100/simpad.c |   67 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 66 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-sa1100/simpad.c b/arch/arm/mach-sa1100/simpad.c
index c3c66b0..9f0eefd 100644
--- a/arch/arm/mach-sa1100/simpad.c
+++ b/arch/arm/mach-sa1100/simpad.c
@@ -29,6 +29,9 @@
 
 #include <linux/serial_core.h>
 #include <linux/ioport.h>
+#include <linux/input.h>
+#include <linux/gpio_keys.h>
+#include <linux/i2c-gpio.h>
 
 #include "generic.h"
 
@@ -249,6 +252,65 @@ static void simpad_power_off(void)
 
 }
 
+/*
+ * gpio_keys
+*/
+
+static struct gpio_keys_button simpad_button_table[] = {
+	{ KEY_POWER, IRQ_GPIO_POWER_BUTTON, 1, "power button" },
+};
+
+static struct gpio_keys_platform_data simpad_keys_data = {
+	.buttons = simpad_button_table,
+	.nbuttons = ARRAY_SIZE(simpad_button_table),
+};
+
+static struct platform_device simpad_keys = {
+	.name = "gpio-keys",
+	.dev = {
+		.platform_data = &simpad_keys_data,
+	},
+};
+
+static struct gpio_keys_button simpad_polled_button_table[] = {
+	{ KEY_PROG1, SIMPAD_UCB1X00_GPIO_PROG1, 1, "prog1 button" },
+	{ KEY_PROG2, SIMPAD_UCB1X00_GPIO_PROG2, 1, "prog2 button" },
+	{ KEY_UP,    SIMPAD_UCB1X00_GPIO_UP,    1, "up button" },
+	{ KEY_DOWN,  SIMPAD_UCB1X00_GPIO_DOWN,  1, "down button" },
+	{ KEY_LEFT,  SIMPAD_UCB1X00_GPIO_LEFT,  1, "left button" },
+	{ KEY_RIGHT, SIMPAD_UCB1X00_GPIO_RIGHT, 1, "right button" },
+};
+
+static struct gpio_keys_platform_data simpad_polled_keys_data = {
+	.buttons = simpad_polled_button_table,
+	.nbuttons = ARRAY_SIZE(simpad_polled_button_table),
+	.poll_interval = 50,
+};
+
+static struct platform_device simpad_polled_keys = {
+	.name = "gpio-keys-polled",
+	.dev = {
+		.platform_data = &simpad_polled_keys_data,
+	},
+};
+
+/*
+ * i2c
+ */
+static struct i2c_gpio_platform_data simpad_i2c_data = {
+	.sda_pin = GPIO_GPIO21,
+	.scl_pin = GPIO_GPIO25,
+	.udelay = 10,
+	.timeout = HZ,
+};
+
+static struct platform_device simpad_i2c = {
+	.name = "i2c-gpio",
+	.id = 0,
+	.dev = {
+		.platform_data = &simpad_i2c_data,
+	},
+};
 
 /*
  * MediaQ Video Device
@@ -259,7 +321,10 @@ static struct platform_device simpad_mq200fb = {
 };
 
 static struct platform_device *devices[] __initdata = {
-	&simpad_mq200fb
+	&simpad_keys,
+	&simpad_polled_keys,
+	&simpad_mq200fb,
+	&simpad_i2c,
 };
 
 
-- 
1.7.5.4

