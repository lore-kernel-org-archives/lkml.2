Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2JAKoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:44:30 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60089 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2JAKoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:44:14 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 7/7] ARM: ux500: Remove platform specific device registration when DT is enabled
Date: Mon,  1 Oct 2012 11:43:48 +0100
Message-Id: <1349088228-8582-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349088228-8582-1-git-send-email-lee.jones@linaro.org>
References: <1349088228-8582-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most devices have now been successfully DT:ed and each supported
platform has its own Device Tree source file. Hence the majority
of the platform specific device registration calls can now be
successfully removed.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |   29 +----------------------------
 1 file changed, 1 insertion(+), 28 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 38e53b2..5dd4a59 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -793,8 +793,6 @@ static const struct of_device_id u8500_local_bus_nodes[] = {
 static void __init u8500_init_machine(void)
 {
 	struct device *parent = NULL;
-	int i2c0_devs;
-	int i;
 
 	/* Pinmaps must be in place before devices register */
 	if (of_machine_is_compatible("st-ericsson,mop500"))
@@ -804,37 +802,12 @@ static void __init u8500_init_machine(void)
 	else if (of_machine_is_compatible("st-ericsson,hrefv60+"))
 		hrefv60_pinmaps_init();
 
+	/* TODO: Export SoC, USB, cpu-freq and DMA40 */
 	parent = u8500_of_init_devices();
 
-	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
-		mop500_platform_devs[i]->dev.parent = parent;
-
 	/* automatically probe child nodes of db8500 device */
 	of_platform_populate(NULL, u8500_local_bus_nodes, u8500_auxdata_lookup, parent);
 
-	if (of_machine_is_compatible("st-ericsson,mop500")) {
-		mop500_gpio_keys[0].gpio = GPIO_PROX_SENSOR;
-
-		platform_add_devices(mop500_platform_devs,
-				ARRAY_SIZE(mop500_platform_devs));
-
-		mop500_audio_init(parent);
-		i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
-		i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
-		i2c_register_board_info(2, mop500_i2c2_devices,
-					ARRAY_SIZE(mop500_i2c2_devices));
-
-	} else if (of_machine_is_compatible("st-ericsson,hrefv60+")) {
-		/*
-		 * The HREFv60 board removed a GPIO expander and routed
-		 * all these GPIO pins to the internal GPIO controller
-		 * instead.
-		 */
-		mop500_gpio_keys[0].gpio = HREFV60_PROX_SENSE_GPIO;
-		platform_add_devices(mop500_platform_devs,
-				ARRAY_SIZE(mop500_platform_devs));
-	}
-
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
 }
-- 
1.7.9.5

