Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab2ALHiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 02:38:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:30021 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2ALHi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 02:38:29 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-fc-4f0e8df4c2b3
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, lars@metafoo.de, patches@linaro.org
Subject: [PATCH v2 2/2] ARM: Exynos: Use lcd power control driver for lcd panel
Date: Thu, 12 Jan 2012 13:13:31 +0530
Message-id: <1326354211-27064-3-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1326354211-27064-1-git-send-email-thomas.abraham@linaro.org>
References: <1326354211-27064-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hydis hv070wsa lcd panel used with the Origen board uses a gpio
for reset and the Vcc supply to the panel can be controlled using
a voltage regulator. Switch to using the lcd power control driver
for controlling the power to the lcd panel.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 arch/arm/mach-exynos/mach-origen.c |   29 ++++++-----------------------
 1 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
index 23fc5cb..f12b7e2 100644
--- a/arch/arm/mach-exynos/mach-origen.c
+++ b/arch/arm/mach-exynos/mach-origen.c
@@ -25,7 +25,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
 
-#include <video/platform_lcd.h>
+#include <video/lcd_pwrctrl.h>
 
 #include <plat/regs-serial.h>
 #include <plat/regs-fb-v4.h>
@@ -127,7 +127,7 @@ static struct regulator_consumer_supply __initdata buck3_consumer[] = {
 	REGULATOR_SUPPLY("vdd_g3d", "mali_drm"), /* G3D */
 };
 static struct regulator_consumer_supply __initdata buck7_consumer[] = {
-	REGULATOR_SUPPLY("vcc", "platform-lcd"), /* LCD */
+	REGULATOR_SUPPLY("vcc-lcd", "lcd-pwrctrl.0"), /* LCD */
 };
 
 static struct regulator_init_data __initdata max8997_ldo1_data = {
@@ -382,7 +382,7 @@ static struct regulator_init_data __initdata max8997_buck7_data = {
 		.name		= "VDD_LCD_3.3V",
 		.min_uV		= 3300000,
 		.max_uV		= 3300000,
-		.boot_on	= 1,
+		.boot_on	= 0,
 		.apply_uV	= 1,
 		.valid_ops_mask	= REGULATOR_CHANGE_STATUS,
 		.state_mem	= {
@@ -554,29 +554,12 @@ static struct platform_device origen_device_gpiokeys = {
 	},
 };
 
-static void lcd_hv070wsa_set_power(struct plat_lcd_data *pd, unsigned int power)
-{
-	int ret;
-
-	if (power)
-		ret = gpio_request_one(EXYNOS4_GPE3(4),
-					GPIOF_OUT_INIT_HIGH, "GPE3_4");
-	else
-		ret = gpio_request_one(EXYNOS4_GPE3(4),
-					GPIOF_OUT_INIT_LOW, "GPE3_4");
-
-	gpio_free(EXYNOS4_GPE3(4));
-
-	if (ret)
-		pr_err("failed to request gpio for LCD power: %d\n", ret);
-}
-
-static struct plat_lcd_data origen_lcd_hv070wsa_data = {
-	.set_power = lcd_hv070wsa_set_power,
+static struct lcd_pwrctrl_data origen_lcd_hv070wsa_data = {
+	.gpio	= EXYNOS4_GPE3(4),
 };
 
 static struct platform_device origen_lcd_hv070wsa = {
-	.name			= "platform-lcd",
+	.name			= "lcd-pwrctrl",
 	.dev.parent		= &s5p_device_fimd0.dev,
 	.dev.platform_data	= &origen_lcd_hv070wsa_data,
 };
-- 
1.6.6.rc2

