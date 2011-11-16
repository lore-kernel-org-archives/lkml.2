Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1KPS4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:56:17 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:54252 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab1KPS4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:56:15 -0500
From: Thomas Weber <weber@corscience.de>
To: tony@atomide.com
Cc: Thomas Weber <weber@corscience.de>,
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-omap@vger.kernel.org (open list:OMAP SUPPORT),
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT),
        linux-kernel@vger.kernel.org (open list),
        uwe.kleine-koenig@pengutronix.de
Subject: [PATCHv2] ARM: OMAP: hsmmc: Fix mux for non-OMAP pins
Date: Wed, 16 Nov 2011 19:56:12 +0100
Message-Id: <1321469772-801-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Devkit8000 uses a TWL4030 pin for card detection.
Thats why the error:
_omap_mux_init_gpio: Could not set gpio192
occurs.

This patch checks that the pin is on OMAP before
calling omap_mux_init_gpio.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
Changelog:
v2: Remove backslash at end of line

 arch/arm/mach-omap2/hsmmc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/hsmmc.c b/arch/arm/mach-omap2/hsmmc.c
index f4a1020..c3aea79 100644
--- a/arch/arm/mach-omap2/hsmmc.c
+++ b/arch/arm/mach-omap2/hsmmc.c
@@ -200,10 +200,12 @@ static int nop_mmc_set_power(struct device *dev, int slot, int power_on,
 static inline void omap_hsmmc_mux(struct omap_mmc_platform_data *mmc_controller,
 			int controller_nr)
 {
-	if (gpio_is_valid(mmc_controller->slots[0].switch_pin))
+	if (gpio_is_valid(mmc_controller->slots[0].switch_pin) &&
+		(mmc_controller->slots[0].switch_pin < OMAP_MAX_GPIO_LINES))
 		omap_mux_init_gpio(mmc_controller->slots[0].switch_pin,
 					OMAP_PIN_INPUT_PULLUP);
-	if (gpio_is_valid(mmc_controller->slots[0].gpio_wp))
+	if (gpio_is_valid(mmc_controller->slots[0].gpio_wp) &&
+		(mmc_controller->slots[0].gpio_wp < OMAP_MAX_GPIO_LINES))
 		omap_mux_init_gpio(mmc_controller->slots[0].gpio_wp,
 					OMAP_PIN_INPUT_PULLUP);
 	if (cpu_is_omap34xx()) {
-- 
1.7.7.3

