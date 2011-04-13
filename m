Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab1DMO4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:56:13 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:41509 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab1DMO4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:56:07 -0400
X-ASG-Debug-ID: 1302706567-082e4b870001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 08/13] mfd: use platform_data in max8925
Subject: [PATCH 08/13] mfd: use platform_data in max8925
Date: Wed, 13 Apr 2011 22:50:59 +0800
X-ASG-Orig-Subj: [PATCH 08/13] mfd: use platform_data in max8925
Message-Id: <1302706264-25815-9-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1302706264-25815-8-git-send-email-haojian.zhuang@marvell.com>
References: <2011041301>
 <1302706264-25815-1-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-2-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-3-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-4-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-5-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-6-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-7-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-8-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1302706567
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use platform_data to pass parameters to client driver.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/mfd/max8925-core.c  |  467 +++++++++++++++++++++++++------------------
 include/linux/mfd/max8925.h |    9 +-
 2 files changed, 274 insertions(+), 202 deletions(-)

diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index 58cc5fd..044801c 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -17,169 +17,141 @@
 #include <linux/platform_device.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/max8925.h>
+#include <linux/regulator/machine.h>
 
-static struct resource backlight_resources[] = {
-	{
-		.name	= "max8925-backlight",
-		.start	= MAX8925_WLED_MODE_CNTL,
-		.end	= MAX8925_WLED_CNTL,
-		.flags	= IORESOURCE_IO,
-	},
+static struct resource bk_resources[] __devinitdata = {
+	{0, 0, "max8925-backlight", IORESOURCE_IO,},
 };
 
-static struct mfd_cell backlight_devs[] = {
-	{
-		.name		= "max8925-backlight",
-		.num_resources	= 1,
-		.resources	= &backlight_resources[0],
-		.id		= -1,
-	},
+static struct resource touch_resources[] __devinitdata = {
+	{MAX8925_IRQ_TSC_STICK,  MAX8925_IRQ_TSC_STICK,  "touch stick",
+	 IORESOURCE_IRQ,},
+	{MAX8925_IRQ_TSC_NSTICK, MAX8925_IRQ_TSC_NSTICK, "touch nstick",
+	 IORESOURCE_IRQ,},
 };
 
-static struct resource touch_resources[] = {
-	{
-		.name	= "max8925-tsc",
-		.start	= MAX8925_TSC_IRQ,
-		.end	= MAX8925_ADC_RES_END,
-		.flags	= IORESOURCE_IO,
-	},
+static struct resource power_resources[] __devinitdata = {
+	{MAX8925_IRQ_VCHG_DC_OVP,    MAX8925_IRQ_VCHG_DC_OVP,		\
+	 "dc overvoltage",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_DC_F,      MAX8925_IRQ_VCHG_DC_F,		\
+	 "dc falling",		IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_DC_R,      MAX8925_IRQ_VCHG_DC_R,		\
+	 "dc rising",		IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_USB_OVP,   MAX8925_IRQ_VCHG_USB_OVP,		\
+	 "usb overvoltage",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_USB_F,     MAX8925_IRQ_VCHG_USB_F,		\
+	 "usb falling",		IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_USB_R,     MAX8925_IRQ_VCHG_USB_R,		\
+	 "usb rising",		IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_THM_OK_R,  MAX8925_IRQ_VCHG_THM_OK_R,		\
+	 "bat temp valid",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_THM_OK_F,  MAX8925_IRQ_VCHG_THM_OK_F,		\
+	 "bat temp invalid",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_SYSLOW_F, MAX8925_IRQ_VCHG_SYSLOW_F,		\
+	 "VSYSLOW falling",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_SYSLOW_R, MAX8925_IRQ_VCHG_SYSLOW_R,		\
+	 "VSYSLOW rising", IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_RST,       MAX8925_IRQ_VCHG_RST,		\
+	 "charger restart",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_DONE,      MAX8925_IRQ_VCHG_DONE,		\
+	 "charger done",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_TOPOFF,    MAX8925_IRQ_VCHG_TOPOFF,		\
+	 "charger topoff",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_TMR_FAULT, MAX8925_IRQ_VCHG_TMR_FAULT,	\
+	 "charger expire",	IORESOURCE_IRQ,},
 };
 
-static struct mfd_cell touch_devs[] = {
-	{
-		.name		= "max8925-touch",
-		.num_resources	= 1,
-		.resources	= &touch_resources[0],
-		.id		= -1,
-	},
+static struct resource rtc_resources[] __devinitdata = {
+	{MAX8925_IRQ_RTC_ALARM0, MAX8925_IRQ_RTC_ALARM0, "rtc-alarm0",
+	 IORESOURCE_IRQ,},
+	{MAX8925_IRQ_RTC_ALARM1, MAX8925_IRQ_RTC_ALARM1, "rtc-alarm1",
+	 IORESOURCE_IRQ,},
 };
 
-static struct resource power_supply_resources[] = {
-	{
-		.name	= "max8925-power",
-		.start	= MAX8925_CHG_IRQ1,
-		.end	= MAX8925_CHG_IRQ1_MASK,
-		.flags	= IORESOURCE_IO,
-	},
+static struct resource onkey_resources[] __devinitdata = {
+	{MAX8925_IRQ_GPM_SW_R, MAX8925_IRQ_GPM_SW_R, "onkey R",
+	 IORESOURCE_IRQ,},
+	{MAX8925_IRQ_GPM_SW_F, MAX8925_IRQ_GPM_SW_F, "onkey F",
+	 IORESOURCE_IRQ,},
 };
 
-static struct mfd_cell power_devs[] = {
-	{
-		.name		= "max8925-power",
-		.num_resources	= 1,
-		.resources	= &power_supply_resources[0],
-		.id		= -1,
-	},
+static struct resource regulator_resources[] __devinitdata = {
+	{MAX8925_ID_SD1,   MAX8925_ID_SD1,   "SD1",   IORESOURCE_IO,},
+	{MAX8925_ID_SD2,   MAX8925_ID_SD2,   "SD2",   IORESOURCE_IO,},
+	{MAX8925_ID_SD3,   MAX8925_ID_SD3,   "SD3",   IORESOURCE_IO,},
+	{MAX8925_ID_LDO1,  MAX8925_ID_LDO1,  "LDO01", IORESOURCE_IO,},
+	{MAX8925_ID_LDO2,  MAX8925_ID_LDO2,  "LDO02", IORESOURCE_IO,},
+	{MAX8925_ID_LDO3,  MAX8925_ID_LDO3,  "LDO03", IORESOURCE_IO,},
+	{MAX8925_ID_LDO4,  MAX8925_ID_LDO4,  "LDO04", IORESOURCE_IO,},
+	{MAX8925_ID_LDO5,  MAX8925_ID_LDO5,  "LDO05", IORESOURCE_IO,},
+	{MAX8925_ID_LDO6,  MAX8925_ID_LDO6,  "LDO06", IORESOURCE_IO,},
+	{MAX8925_ID_LDO7,  MAX8925_ID_LDO7,  "LDO07", IORESOURCE_IO,},
+	{MAX8925_ID_LDO8,  MAX8925_ID_LDO8,  "LDO08", IORESOURCE_IO,},
+	{MAX8925_ID_LDO9,  MAX8925_ID_LDO9,  "LDO09", IORESOURCE_IO,},
+	{MAX8925_ID_LDO10, MAX8925_ID_LDO10, "LDO10", IORESOURCE_IO,},
+	{MAX8925_ID_LDO11, MAX8925_ID_LDO11, "LDO11", IORESOURCE_IO,},
+	{MAX8925_ID_LDO12, MAX8925_ID_LDO12, "LDO12", IORESOURCE_IO,},
+	{MAX8925_ID_LDO13, MAX8925_ID_LDO13, "LDO13", IORESOURCE_IO,},
+	{MAX8925_ID_LDO14, MAX8925_ID_LDO14, "LDO14", IORESOURCE_IO,},
+	{MAX8925_ID_LDO15, MAX8925_ID_LDO15, "LDO15", IORESOURCE_IO,},
+	{MAX8925_ID_LDO16, MAX8925_ID_LDO16, "LDO16", IORESOURCE_IO,},
+	{MAX8925_ID_LDO17, MAX8925_ID_LDO17, "LDO17", IORESOURCE_IO,},
+	{MAX8925_ID_LDO18, MAX8925_ID_LDO18, "LDO18", IORESOURCE_IO,},
+	{MAX8925_ID_LDO19, MAX8925_ID_LDO19, "LDO19", IORESOURCE_IO,},
+	{MAX8925_ID_LDO20, MAX8925_ID_LDO20, "LDO20", IORESOURCE_IO,},
 };
 
-static struct resource rtc_resources[] = {
-	{
-		.name	= "max8925-rtc",
-		.start	= MAX8925_RTC_IRQ,
-		.end	= MAX8925_RTC_IRQ_MASK,
-		.flags	= IORESOURCE_IO,
-	},
+static struct mfd_cell bk_devs[] = {
+	{"max8925-backlight", -1,},
 };
 
-static struct mfd_cell rtc_devs[] = {
-	{
-		.name		= "max8925-rtc",
-		.num_resources	= 1,
-		.resources	= &rtc_resources[0],
-		.id		= -1,
-	},
+static struct mfd_cell touch_devs[] = {
+	{"max8925-touch", -1,},
 };
 
-static struct resource onkey_resources[] = {
-	{
-		.name	= "max8925-onkey",
-		.start	= MAX8925_IRQ_GPM_SW_R,
-		.end	= MAX8925_IRQ_GPM_SW_R,
-		.flags	= IORESOURCE_IRQ,
-	}, {
-		.name	= "max8925-onkey",
-		.start	= MAX8925_IRQ_GPM_SW_F,
-		.end	= MAX8925_IRQ_GPM_SW_F,
-		.flags	= IORESOURCE_IRQ,
-	},
+static struct mfd_cell power_devs[] = {
+	{"max8925-power", -1,},
 };
 
-static struct mfd_cell onkey_devs[] = {
-	{
-		.name		= "max8925-onkey",
-		.num_resources	= 2,
-		.resources	= &onkey_resources[0],
-		.id		= -1,
-	},
+static struct mfd_cell rtc_devs[] = {
+	{"max8925-rtc", -1,},
 };
 
-#define MAX8925_REG_RESOURCE(_start, _end)	\
-{						\
-	.start	= MAX8925_##_start,		\
-	.end	= MAX8925_##_end,		\
-	.flags	= IORESOURCE_IO,		\
-}
-
-static struct resource regulator_resources[] = {
-	MAX8925_REG_RESOURCE(SDCTL1, SDCTL1),
-	MAX8925_REG_RESOURCE(SDCTL2, SDCTL2),
-	MAX8925_REG_RESOURCE(SDCTL3, SDCTL3),
-	MAX8925_REG_RESOURCE(LDOCTL1, LDOCTL1),
-	MAX8925_REG_RESOURCE(LDOCTL2, LDOCTL2),
-	MAX8925_REG_RESOURCE(LDOCTL3, LDOCTL3),
-	MAX8925_REG_RESOURCE(LDOCTL4, LDOCTL4),
-	MAX8925_REG_RESOURCE(LDOCTL5, LDOCTL5),
-	MAX8925_REG_RESOURCE(LDOCTL6, LDOCTL6),
-	MAX8925_REG_RESOURCE(LDOCTL7, LDOCTL7),
-	MAX8925_REG_RESOURCE(LDOCTL8, LDOCTL8),
-	MAX8925_REG_RESOURCE(LDOCTL9, LDOCTL9),
-	MAX8925_REG_RESOURCE(LDOCTL10, LDOCTL10),
-	MAX8925_REG_RESOURCE(LDOCTL11, LDOCTL11),
-	MAX8925_REG_RESOURCE(LDOCTL12, LDOCTL12),
-	MAX8925_REG_RESOURCE(LDOCTL13, LDOCTL13),
-	MAX8925_REG_RESOURCE(LDOCTL14, LDOCTL14),
-	MAX8925_REG_RESOURCE(LDOCTL15, LDOCTL15),
-	MAX8925_REG_RESOURCE(LDOCTL16, LDOCTL16),
-	MAX8925_REG_RESOURCE(LDOCTL17, LDOCTL17),
-	MAX8925_REG_RESOURCE(LDOCTL18, LDOCTL18),
-	MAX8925_REG_RESOURCE(LDOCTL19, LDOCTL19),
-	MAX8925_REG_RESOURCE(LDOCTL20, LDOCTL20),
+static struct mfd_cell onkey_devs[] = {
+	{"max8925-onkey", -1,},
 };
 
-#define MAX8925_REG_DEVS(_id)						\
-{									\
-	.name		= "max8925-regulator",				\
-	.num_resources	= 1,						\
-	.resources	= &regulator_resources[MAX8925_ID_##_id],	\
-	.id		= MAX8925_ID_##_id,				\
-}
-
 static struct mfd_cell regulator_devs[] = {
-	MAX8925_REG_DEVS(SD1),
-	MAX8925_REG_DEVS(SD2),
-	MAX8925_REG_DEVS(SD3),
-	MAX8925_REG_DEVS(LDO1),
-	MAX8925_REG_DEVS(LDO2),
-	MAX8925_REG_DEVS(LDO3),
-	MAX8925_REG_DEVS(LDO4),
-	MAX8925_REG_DEVS(LDO5),
-	MAX8925_REG_DEVS(LDO6),
-	MAX8925_REG_DEVS(LDO7),
-	MAX8925_REG_DEVS(LDO8),
-	MAX8925_REG_DEVS(LDO9),
-	MAX8925_REG_DEVS(LDO10),
-	MAX8925_REG_DEVS(LDO11),
-	MAX8925_REG_DEVS(LDO12),
-	MAX8925_REG_DEVS(LDO13),
-	MAX8925_REG_DEVS(LDO14),
-	MAX8925_REG_DEVS(LDO15),
-	MAX8925_REG_DEVS(LDO16),
-	MAX8925_REG_DEVS(LDO17),
-	MAX8925_REG_DEVS(LDO18),
-	MAX8925_REG_DEVS(LDO19),
-	MAX8925_REG_DEVS(LDO20),
+	{"max8925-regulator", 0,},
+	{"max8925-regulator", 1,},
+	{"max8925-regulator", 2,},
+	{"max8925-regulator", 3,},
+	{"max8925-regulator", 4,},
+	{"max8925-regulator", 5,},
+	{"max8925-regulator", 6,},
+	{"max8925-regulator", 7,},
+	{"max8925-regulator", 8,},
+	{"max8925-regulator", 9,},
+	{"max8925-regulator", 10,},
+	{"max8925-regulator", 11,},
+	{"max8925-regulator", 12,},
+	{"max8925-regulator", 13,},
+	{"max8925-regulator", 14,},
+	{"max8925-regulator", 15,},
+	{"max8925-regulator", 16,},
+	{"max8925-regulator", 17,},
+	{"max8925-regulator", 18,},
+	{"max8925-regulator", 19,},
+	{"max8925-regulator", 20,},
+	{"max8925-regulator", 21,},
+	{"max8925-regulator", 22,},
 };
 
+static struct max8925_backlight_pdata bk_pdata;
+static struct max8925_touch_pdata touch_pdata;
+static struct max8925_power_pdata power_pdata;
+static struct regulator_init_data regulator_pdata[ARRAY_SIZE(regulator_devs)];
+
 enum {
 	FLAGS_ADC = 1,	/* register in ADC component */
 	FLAGS_RTC,	/* register in RTC component */
@@ -588,6 +560,159 @@ tsc_irq:
 	return 0;
 }
 
+static void __devinit device_bk_init(struct max8925_chip *chip,
+				     struct i2c_client *i2c,
+				     struct max8925_platform_data *pdata)
+{
+	int ret;
+
+	if ((pdata == NULL) || (pdata->backlight == NULL))
+		return;
+
+	memcpy(&bk_pdata, pdata->backlight,
+		sizeof(struct max8925_backlight_pdata));
+	bk_devs[0].platform_data = &bk_pdata;
+	bk_devs[0].pdata_size = sizeof(bk_pdata);
+
+	bk_devs[0].num_resources = 1;
+	bk_devs[0].resources = &bk_resources[0];
+	ret = mfd_add_devices(chip->dev, 0, &bk_devs[0], 1,
+			      &bk_resources[0], 0);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add backlight subdev\n");
+}
+
+static void __devinit device_rtc_init(struct max8925_chip *chip,
+				      struct i2c_client *i2c,
+				      struct max8925_platform_data *pdata)
+{
+	int ret;
+
+	rtc_devs[0].num_resources = ARRAY_SIZE(rtc_resources);
+	rtc_devs[0].resources = &rtc_resources[0];
+	ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0], 1,
+			      &rtc_resources[0], chip->irq_base);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add rtc subdev\n");
+}
+
+static void __devinit device_touch_init(struct max8925_chip *chip,
+					struct i2c_client *i2c,
+					struct max8925_platform_data *pdata)
+{
+	int ret;
+
+	if ((pdata == NULL) || (pdata->touch == NULL))
+		return;
+
+	memcpy(&touch_pdata, pdata->touch,
+		sizeof(struct max8925_touch_pdata));
+	touch_devs[0].platform_data = &touch_pdata;
+	touch_devs[0].pdata_size = sizeof(touch_pdata);
+	touch_devs[0].num_resources = ARRAY_SIZE(touch_resources);
+	touch_devs[0].resources = &touch_resources[0];
+	ret = mfd_add_devices(chip->dev, 0, &touch_devs[0],
+			      ARRAY_SIZE(touch_devs),
+			      &touch_resources[0], chip->irq_base);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add touch subdev\n");
+}
+
+static void __devinit device_power_init(struct max8925_chip *chip,
+					struct i2c_client *i2c,
+					struct max8925_platform_data *pdata)
+{
+	int ret;
+
+	if ((pdata == NULL) || (pdata->power == NULL))
+		return;
+
+	memcpy(&power_pdata, pdata->power,
+		sizeof(struct max8925_power_pdata));
+	power_devs[0].platform_data = &power_pdata;
+	power_devs[0].pdata_size = sizeof(power_pdata);
+	power_devs[0].num_resources = ARRAY_SIZE(power_resources);
+	power_devs[0].resources = &power_resources[0];
+	ret = mfd_add_devices(chip->dev, 0, &power_devs[0],
+				ARRAY_SIZE(power_devs),
+				&power_resources[0], chip->irq_base);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add power supply subdev\n");
+}
+
+static void __devinit device_onkey_init(struct max8925_chip *chip,
+					struct i2c_client *i2c,
+					struct max8925_platform_data *pdata)
+{
+	int ret;
+
+	onkey_devs[0].num_resources = ARRAY_SIZE(onkey_resources);
+	onkey_devs[0].resources = &onkey_resources[0];
+	ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
+			      ARRAY_SIZE(onkey_devs),
+			      &onkey_resources[0], chip->irq_base);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add onkey subdev\n");
+}
+
+static void __devinit device_regulator_init(struct max8925_chip *chip,
+					struct i2c_client *i2c,
+					struct max8925_platform_data *pdata)
+{
+	struct regulator_init_data *initdata;
+	int ret, i, j;
+
+	if ((pdata == NULL) || (pdata->regulator == NULL))
+		return;
+
+	if (pdata->num_regulators > ARRAY_SIZE(regulator_devs))
+		pdata->num_regulators = ARRAY_SIZE(regulator_devs);
+
+	for (i = 0, j = -1; i < pdata->num_regulators; i++) {
+		initdata = &pdata->regulator[i];
+		if (strstr(initdata->constraints.name, "SD")) {
+			sscanf(initdata->constraints.name, "SD%d", &j);
+			/* SD1 ~ SD3 */
+			if ((j < 1) || (j > 3)) {
+				dev_err(chip->dev, "Failed to add constraint "
+					"(%s)\n", initdata->constraints.name);
+				goto out;
+			}
+			j = (j - 1) + MAX8925_ID_SD1;
+		}
+		if (strstr(initdata->constraints.name, "LDO")) {
+			sscanf(initdata->constraints.name, "LDO%d", &j);
+			/* LDO01 ~ LDO20 */
+			if ((j < 1) || (j > 20)) {
+				dev_err(chip->dev, "Failed to add constraint "
+					"(%s)\n", initdata->constraints.name);
+				goto out;
+			}
+			j = (j - 1) + MAX8925_ID_LDO1;
+		}
+		if (j == -1) {
+			dev_err(chip->dev, "Failed to add constraint (%s)\n",
+				initdata->constraints.name);
+			goto out;
+		}
+		memcpy(&regulator_pdata[i], &pdata->regulator[i],
+			sizeof(struct regulator_init_data));
+		regulator_devs[i].platform_data = &regulator_pdata[i];
+		regulator_devs[i].pdata_size = sizeof(regulator_pdata[i]);
+		regulator_devs[i].num_resources = 1;
+		regulator_devs[i].resources = &regulator_resources[j];
+
+		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[i], 1,
+				      &regulator_resources[j], 0);
+		if (ret < 0) {
+			dev_err(chip->dev, "Failed to add regulator subdev\n");
+			goto out;
+		}
+	}
+out:
+	return;
+}
+
 int __devinit max8925_device_init(struct max8925_chip *chip,
 				  struct max8925_platform_data *pdata)
 {
@@ -604,75 +729,21 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 		do {
 			ret = max8925_reg_read(chip->adc, MAX8925_TSC_IRQ);
 		} while (ret & MAX8925_NREF_OK);
-		/* enaable ADC scheduler, interval is 1 second */
+		/* enable ADC scheduler, interval is 1 second */
 		max8925_set_bits(chip->adc, MAX8925_ADC_SCHED, 3, 2);
 	}
 
 	/* enable Momentary Power Loss */
 	max8925_set_bits(chip->rtc, MAX8925_MPL_CNTL, 1 << 4, 1 << 4);
 
-	ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0],
-			      ARRAY_SIZE(rtc_devs),
-			      &rtc_resources[0], 0);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to add rtc subdev\n");
-		goto out;
-	}
-
-	ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
-			      ARRAY_SIZE(onkey_devs),
-			      &onkey_resources[0], 0);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to add onkey subdev\n");
-		goto out_dev;
-	}
-
-	if (pdata && pdata->regulator[0]) {
-		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[0],
-				      ARRAY_SIZE(regulator_devs),
-				      &regulator_resources[0], 0);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add regulator subdev\n");
-			goto out_dev;
-		}
-	}
-
-	if (pdata && pdata->backlight) {
-		ret = mfd_add_devices(chip->dev, 0, &backlight_devs[0],
-				      ARRAY_SIZE(backlight_devs),
-				      &backlight_resources[0], 0);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add backlight subdev\n");
-			goto out_dev;
-		}
-	}
-
-	if (pdata && pdata->power) {
-		ret = mfd_add_devices(chip->dev, 0, &power_devs[0],
-					ARRAY_SIZE(power_devs),
-					&power_supply_resources[0], 0);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add power supply "
-				"subdev\n");
-			goto out_dev;
-		}
-	}
-
-	if (pdata && pdata->touch) {
-		ret = mfd_add_devices(chip->dev, 0, &touch_devs[0],
-				      ARRAY_SIZE(touch_devs),
-				      &touch_resources[0], 0);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add touch subdev\n");
-			goto out_dev;
-		}
-	}
+	device_bk_init(chip, chip->i2c, pdata);
+	device_rtc_init(chip, chip->rtc, pdata);
+	device_touch_init(chip, chip->adc, pdata);
+	device_power_init(chip, chip->adc, pdata);
+	device_onkey_init(chip, chip->i2c, pdata);
+	device_regulator_init(chip, chip->i2c, pdata);
 
 	return 0;
-out_dev:
-	mfd_remove_devices(chip->dev);
-out:
-	return ret;
 }
 
 void __devexit max8925_device_exit(struct max8925_chip *chip)
diff --git a/include/linux/mfd/max8925.h b/include/linux/mfd/max8925.h
index 5259dfe..51578e2 100644
--- a/include/linux/mfd/max8925.h
+++ b/include/linux/mfd/max8925.h
@@ -209,9 +209,9 @@ struct max8925_chip {
 };
 
 struct max8925_backlight_pdata {
-	int	lxw_scl;	/* 0/1 -- 0.8Ohm/0.4Ohm */
-	int	lxw_freq;	/* 700KHz ~ 1400KHz */
-	int	dual_string;	/* 0/1 -- single/dual string */
+	int		lxw_scl;	/* 0/1 -- 0.8Ohm/0.4Ohm */
+	int		lxw_freq;	/* 700KHz ~ 1400KHz */
+	int		dual_string;	/* 0/1 -- single/dual string */
 };
 
 struct max8925_touch_pdata {
@@ -233,10 +233,11 @@ struct max8925_platform_data {
 	struct max8925_backlight_pdata	*backlight;
 	struct max8925_touch_pdata	*touch;
 	struct max8925_power_pdata	*power;
-	struct regulator_init_data	*regulator[MAX8925_MAX_REGULATOR];
+	struct regulator_init_data	*regulator;
 
 	int		irq_base;
 	int		tsc_irq;
+	int		num_regulators;
 };
 
 extern int max8925_reg_read(struct i2c_client *, int);
-- 
1.5.6.5

