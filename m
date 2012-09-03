Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2ICNdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 09:33:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60133 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2ICNdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 09:33:43 -0400
Date: Mon, 3 Sep 2012 14:33:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH] ARM: ux500: Provide SMSC911x fixed-regulator when not
 booting DT
Message-ID: <20120903133333.GE31163@gmail.com>
References: <1345809612-30992-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345809612-30992-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Lee Jones <lee.jones@linaro.org>
Date:   Fri Aug 24 12:40:58 2012 +0100

    ARM: ux500: Provide SMSC911x fixed-regulator when not booting DT
    
    The SMSC911x Ethernet chip requires a fixed-regulator in order to
    function correctly. We have previously provided a means to obtain
    this during a Device Tree boot, however nothing has been put into
    place when booting with a non-DT kernel. This patch aims to change
    that.
    
    Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 52426a4..2a1e388 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -13,6 +13,21 @@
 #include <linux/regulator/ab8500.h>
 #include "board-mop500-regulators.h"
 
+static struct regulator_consumer_supply gpio_en_3v3_consumers[] = {
+       REGULATOR_SUPPLY("vdd33a", "smsc911x.0"),
+};
+
+struct regulator_init_data gpio_en_3v3_regulator = {
+       .constraints = {
+               .name = "EN-3V3",
+               .min_uV = 3300000,
+               .max_uV = 3300000,
+               .valid_ops_mask = REGULATOR_CHANGE_STATUS,
+       },
+       .num_consumer_supplies = ARRAY_SIZE(gpio_en_3v3_consumers),
+       .consumer_supplies = gpio_en_3v3_consumers,
+};
+
 /*
  * TPS61052 regulator
  */
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
index 9499215..78a0642 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -18,5 +18,6 @@ extern struct ab8500_regulator_reg_init
 ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS];
 extern struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS];
 extern struct regulator_init_data tps61052_regulator;
+extern struct regulator_init_data gpio_en_3v3_regulator;
 
 #endif
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index b2be36f..9dfad19 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -23,6 +23,7 @@
 #include <linux/spi/spi.h>
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/regulator/ab8500.h>
+#include <linux/regulator/fixed.h>
 #include <linux/mfd/tc3589x.h>
 #include <linux/mfd/tps6105x.h>
 #include <linux/mfd/abx500/ab8500-gpio.h>
@@ -75,6 +76,23 @@ static struct platform_device snowball_led_dev = {
        },
 };
 
+static struct fixed_voltage_config snowball_gpio_en_3v3_data = {
+       .supply_name            = "EN-3V3",
+       .gpio                   = SNOWBALL_EN_3V3_ETH_GPIO,
+       .microvolts             = 3300000,
+       .enable_high            = 1,
+       .init_data              = &gpio_en_3v3_regulator,
+       .startup_delay          = 5000, /* 1200us */
+};
+
+static struct platform_device snowball_gpio_en_3v3_regulator_dev = {
+       .name   = "reg-fixed-voltage",
+       .id     = 1,
+       .dev    = {
+               .platform_data  = &snowball_gpio_en_3v3_data,
+       },
+};
+
 static struct ab8500_gpio_platform_data ab8500_gpio_pdata = {
        .gpio_base              = MOP500_AB8500_PIN_GPIO(1),
        .irq_base               = MOP500_AB8500_VIR_GPIO_IRQ_BASE,
@@ -585,6 +603,7 @@ static struct platform_device *snowball_platform_devs[] __initdata = {
        &snowball_led_dev,
        &snowball_key_dev,
        &snowball_sbnet_dev,
+       &snowball_gpio_en_3v3_regulator_dev,
 };
 
 static void __init mop500_init_machine(void)
