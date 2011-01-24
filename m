Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1AXW0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:26:39 -0500
Received: from mail160.messagelabs.com ([216.82.253.99]:9410 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1AXW0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:26:38 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1295907989!10064642!15
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.32]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ep93xx: default multiplexed gpio ports to gpio mode
Date: Mon, 24 Jan 2011 15:25:54 -0700
User-Agent: KMail/1.9.9
CC: Ryan Mallon <ryan@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201101241525.55050.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EP93xx C and D GPIO ports are multiplexed with the Keypad Interface
peripheral.  At power-up they default into non-GPIO mode with the Key
Matrix controller enabled so these ports are unusable for GPIO.  Note
that the Keypad Interface peripheral is only available in the EP9307,
EP9312, and EP9315 processor variants.

The keypad support will clear the DeviceConfig bits appropriately to
enable the Keypad Interface when the driver is loaded.  And, when the
driver is unloaded it will set the bits to return the ports to GPIO mode.

To make these ports available for GPIO after power-up on all EP93xx
processor variants, set the KEYS and GONK bits in the DeviceConfig
register.

Similarly, the E, G, and H ports are multiplexed with the IDE Interface
peripheral.  At power-up these also default into non-GPIO mode.  Note
that the IDE peripheral is only available in the EP9312 and EP9315
processor variants.

Since an IDE driver is not even available in mainline, set the EONIDE,
GONIDE, and HONIDE bits in the DeviceConfig register so that these
ports will be available for GPIO use after power-up.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>

---

diff --git a/arch/arm/mach-ep93xx/gpio.c b/arch/arm/mach-ep93xx/gpio.c
index f3dc76f..bec34b8 100644
--- a/arch/arm/mach-ep93xx/gpio.c
+++ b/arch/arm/mach-ep93xx/gpio.c
@@ -427,6 +427,13 @@ void __init ep93xx_gpio_init(void)
 {
 	int i;
 
+	/* Set Ports C, D, E, G, and H for GPIO use */
+	ep93xx_devcfg_set_bits(EP93XX_SYSCON_DEVCFG_KEYS |
+				 EP93XX_SYSCON_DEVCFG_GONK |
+				 EP93XX_SYSCON_DEVCFG_EONIDE |
+				 EP93XX_SYSCON_DEVCFG_GONIDE |
+				 EP93XX_SYSCON_DEVCFG_HONIDE);
+
 	for (i = 0; i < ARRAY_SIZE(ep93xx_gpio_banks); i++)
 		gpiochip_add(&ep93xx_gpio_banks[i].chip);
 }
