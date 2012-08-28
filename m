Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2H1LsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:48:12 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:36798 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab2H1LsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:48:09 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com, sameo@linux.intel.com,
        peter.ujfalusi@ti.com, s-guiriec@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 2/6] mfd: palmas switch to linear domain in all cases
Date: Tue, 28 Aug 2012 13:47:36 +0200
Message-Id: <1346154460-20031-3-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
References: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swith the palmas to linear domain in all cases so in future DT and non
DT cases will work the same.

With this change we can not use regmap_get_virq internally so no need
to supply IRQ resources to children so remove those definitions.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/mfd/palmas.c |   64 +-------------------------------------------------
 1 file changed, 1 insertion(+), 63 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 5ffd330..3d33623 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -24,60 +24,6 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/palmas.h>
 
-static const struct resource gpadc_resource[] = {
-	{
-		.name = "EOC_SW",
-		.start = PALMAS_GPADC_EOC_SW_IRQ,
-		.end = PALMAS_GPADC_EOC_SW_IRQ,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-static const struct resource usb_resource[] = {
-	{
-		.name = "ID",
-		.start = PALMAS_ID_OTG_IRQ,
-		.end = PALMAS_ID_OTG_IRQ,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.name = "ID_WAKEUP",
-		.start = PALMAS_ID_IRQ,
-		.end = PALMAS_ID_IRQ,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.name = "VBUS",
-		.start = PALMAS_VBUS_OTG_IRQ,
-		.end = PALMAS_VBUS_OTG_IRQ,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.name = "VBUS_WAKEUP",
-		.start = PALMAS_VBUS_IRQ,
-		.end = PALMAS_VBUS_IRQ,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static const struct resource rtc_resource[] = {
-	{
-		.name = "RTC_ALARM",
-		.start = PALMAS_RTC_ALARM_IRQ,
-		.end = PALMAS_RTC_ALARM_IRQ,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static const struct resource pwron_resource[] = {
-	{
-		.name = "PWRON_BUTTON",
-		.start = PALMAS_PWRON_IRQ,
-		.end = PALMAS_PWRON_IRQ,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
 enum palmas_ids {
 	PALMAS_PMIC_ID,
 	PALMAS_GPIO_ID,
@@ -111,20 +57,14 @@ static const struct mfd_cell palmas_children[] = {
 	},
 	{
 		.name = "palmas-rtc",
-		.num_resources = ARRAY_SIZE(rtc_resource),
-		.resources = rtc_resource,
 		.id = PALMAS_RTC_ID,
 	},
 	{
 		.name = "palmas-pwrbutton",
-		.num_resources = ARRAY_SIZE(pwron_resource),
-		.resources = pwron_resource,
 		.id = PALMAS_PWRBUTTON_ID,
 	},
 	{
 		.name = "palmas-gpadc",
-		.num_resources = ARRAY_SIZE(gpadc_resource),
-		.resources = gpadc_resource,
 		.id = PALMAS_GPADC_ID,
 	},
 	{
@@ -141,8 +81,6 @@ static const struct mfd_cell palmas_children[] = {
 	},
 	{
 		.name = "palmas-usb",
-		.num_resources = ARRAY_SIZE(usb_resource),
-		.resources = usb_resource,
 		.id = PALMAS_USB_ID,
 	}
 };
@@ -364,7 +302,7 @@ static int __devinit palmas_i2c_probe(struct i2c_client *i2c,
 	regmap_write(palmas->regmap[slave], addr, reg);
 
 	ret = regmap_add_irq_chip(palmas->regmap[slave], palmas->irq,
-			IRQF_ONESHOT | IRQF_TRIGGER_LOW, -1, &palmas_irq_chip,
+			IRQF_ONESHOT | IRQF_TRIGGER_LOW, 0, &palmas_irq_chip,
 			&palmas->irq_data);
 	if (ret < 0)
 		goto err;
-- 
1.7.9.5

