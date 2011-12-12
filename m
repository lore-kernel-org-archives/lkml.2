Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab1LLSmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:42:40 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37406 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab1LLSmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:42:09 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, dg77.kim@samsung.com, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, Jason.Wortham@maxim-ic.com,
        bruce.e.robertson@intel.com, Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH v3 5/5] x86-mrst: Add battery fuel guage platform data
Date: Mon, 12 Dec 2011 10:39:33 -0800
Message-Id: <1323715173-26974-6-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323715173-26974-1-git-send-email-dirk.brandewie@gmail.com>
References: <1323715173-26974-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Add platform data to configure the MAX17042 at POR.  The accuracy of
the MAX17042 is improved by initializing the fuel gauge with the
battery characterization data.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/platform/mrst/mrst.c |   53 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index b1489a0..bb6aafa 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -22,6 +22,8 @@
 #include <linux/i2c.h>
 #include <linux/i2c/pca953x.h>
 #include <linux/gpio_keys.h>
+#include <linux/power_supply.h>
+#include <linux/power/max17042_battery.h>
 #include <linux/input.h>
 #include <linux/platform_device.h>
 #include <linux/irq.h>
@@ -484,6 +486,56 @@ static void __init *max7315_platform_data(void *info)
 	return max7315;
 }
 
+#define	NTC_47K_TGAIN	0xE4E4
+#define	NTC_47K_TOFF	0x2F1D
+
+static void *max17042_platform_data(void *info)
+{
+	struct i2c_board_info *i2c_info = (struct i2c_board_info *)info;
+	static struct max17042_platform_data platform_data;
+	struct i2c_board_info *i2c_info = (struct i2c_board_info *)info;
+	int intr;
+	static struct max17042_config_data config_data = {
+		.tgain = NTC_47K_TGAIN,
+		.toff = NTC_47K_TOFF,
+		.config = 0x2210,
+		.learn_cfg = 0x0076,
+		.filter_cfg = 0x87A4,
+		.relax_cfg = 0x506B,
+		.rcomp0 = 0x0092,
+		.tcompc0 = 0x0B19,
+		.empty_tempco = 0x2D51,
+		.kempty0 = 0x0D83,
+		.fullcap = 14727,
+		.design_cap = 14727,
+		.fullcapnom = 14727,
+		.cell_technology = POWER_SUPPLY_TECHNOLOGY_LION,
+		.cell_char_tbl = {
+	/* Data to be written from 0x80h */
+	0xABB0, 0xB2B0, 0xBB10, 0xBBB0, 0xBC10, 0xBC70, 0xBD00, 0xBD70,
+	0xBDC0, 0xBE10, 0xC010, 0xC130, 0xC4A0, 0xC9C0, 0xCD10, 0xD090,
+	/* Data to be written from 0x90h */
+	0x0620, 0x0420, 0x1900, 0x3600, 0x3DA0, 0x2CA0, 0x3C20, 0x3500,
+	0x3500, 0x0440, 0x1240, 0x0DF0, 0x08F0, 0x0870, 0x07F0, 0x07F0,
+	/* Data to be written from 0xA0h */
+	0x0100, 0x0100, 0x0100, 0x0100, 0x0100, 0x0100, 0x0100, 0x0100,
+	0x0100, 0x0100, 0x0100, 0x0100, 0x0100, 0x0100, 0x0100, 0x0100,
+		},
+	};
+
+	intr = get_gpio_by_name("max17042");
+
+	if (intr != -1)
+		i2c_info->irq = intr + MRST_IRQ_OFFSET;
+
+	strcpy(i2c_info->type, "max17042");
+	platform_data.enable_por_init = 1;
+	platform_data.config_data = &config_data;
+	platform_data.enable_current_sense = 1;
+
+	return &platform_data;
+}
+
 static void __init *emc1403_platform_data(void *info)
 {
 	static short intr2nd_pdata;
@@ -649,6 +701,7 @@ static const struct devs_id __initconst device_ids[] = {
 	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data},
 	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},
 	{"i2c_max7315_2", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},
+	{"max17042", SFI_DEV_TYPE_I2C, 0, &max17042_platform_data},
 	{"emc1403", SFI_DEV_TYPE_I2C, 1, &emc1403_platform_data},
 	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data},
 	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data},
-- 
1.7.7.3

