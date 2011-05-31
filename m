Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab1EaQhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:37:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51508 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab1EaQhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:37:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Bh9PE1vQTJoVqwKZc9hCn/DvfmV1RggumHQrdK9K1CmW69c3DlM8KM4csMYPmYiV1z
         Mw0rc4SNw1IDeuC3XSxUQI98xT7SzslJWPt/vVszauCEVPMYJjDK31EaPx8YJANVIfMK
         yBLxHa9Sf1O9qXGtiC9gObkyHB/AQxE1VHJA4=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Subject: [PATCH] rtc-mpc5121: add support for RTC on MPC5200
Date: Tue, 31 May 2011 20:37:32 +0400
Message-Id: <1306859852-10634-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MPC5200B contains a bit limited version of RTC from MPC5121. Add support
for RTC on that CPUs.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/rtc/Kconfig       |    4 +-
 drivers/rtc/rtc-mpc5121.c |   81 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 75 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index f822e13..bbef21d 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1006,10 +1006,10 @@ config RTC_DRV_MC13XXX
 
 config RTC_DRV_MPC5121
 	tristate "Freescale MPC5121 built-in RTC"
-	depends on PPC_MPC512x && RTC_CLASS
+	depends on PPC_MPC512x || PPC_MPC52xx
 	help
 	  If you say yes here you will get support for the
-	  built-in RTC MPC5121.
+	  built-in RTC on MPC5121 or on MPC5200.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-mpc5121.
diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index 09ccd8d..da60915 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2007, Domen Puncer <domen.puncer@telargo.com>
  * Copyright 2008, Freescale Semiconductor, Inc. All rights reserved.
+ * Copyright 2011, Dmitry Eremin-Solenikov
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -145,6 +146,55 @@ static int mpc5121_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return 0;
 }
 
+static int mpc5200_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct mpc5121_rtc_data *rtc = dev_get_drvdata(dev);
+	struct mpc5121_rtc_regs __iomem *regs = rtc->regs;
+	int tmp;
+
+	tm->tm_sec = in_8(&regs->second);
+	tm->tm_min = in_8(&regs->minute);
+
+	/* 12 hour format? */
+	if (in_8(&regs->hour) & 0x20)
+		tm->tm_hour = (in_8(&regs->hour) >> 1) +
+			(in_8(&regs->hour) & 1 ? 12 : 0);
+	else
+		tm->tm_hour = in_8(&regs->hour);
+
+	tmp = in_8(&regs->wday_mday);
+	tm->tm_mday = tmp & 0x1f;
+	tm->tm_mon = in_8(&regs->month) - 1;
+	tm->tm_year = in_be16(&regs->year) - 1900;
+	tm->tm_wday = (tmp >> 5) % 7;
+	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
+	tm->tm_isdst = 0;
+
+	return 0;
+}
+
+static int mpc5200_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct mpc5121_rtc_data *rtc = dev_get_drvdata(dev);
+	struct mpc5121_rtc_regs __iomem *regs = rtc->regs;
+
+	mpc5121_rtc_update_smh(regs, tm);
+
+	/* date */
+	out_8(&regs->month_set, tm->tm_mon + 1);
+	out_8(&regs->weekday_set, tm->tm_wday ? tm->tm_wday : 7);
+	out_8(&regs->date_set, tm->tm_mday);
+	out_be16(&regs->year_set, tm->tm_year + 1900);
+
+	/* set date sequence */
+	out_8(&regs->set_date, 0x1);
+	out_8(&regs->set_date, 0x3);
+	out_8(&regs->set_date, 0x1);
+	out_8(&regs->set_date, 0x0);
+
+	return 0;
+}
+
 static int mpc5121_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct mpc5121_rtc_data *rtc = dev_get_drvdata(dev);
@@ -248,11 +298,18 @@ static const struct rtc_class_ops mpc5121_rtc_ops = {
 	.alarm_irq_enable = mpc5121_rtc_alarm_irq_enable,
 };
 
+static const struct rtc_class_ops mpc5200_rtc_ops = {
+	.read_time = mpc5200_rtc_read_time,
+	.set_time = mpc5200_rtc_set_time,
+	.read_alarm = mpc5121_rtc_read_alarm,
+	.set_alarm = mpc5121_rtc_set_alarm,
+	.alarm_irq_enable = mpc5121_rtc_alarm_irq_enable,
+};
+
 static int __devinit mpc5121_rtc_probe(struct platform_device *op)
 {
 	struct mpc5121_rtc_data *rtc;
 	int err = 0;
-	u32 ka;
 
 	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
@@ -287,15 +344,22 @@ static int __devinit mpc5121_rtc_probe(struct platform_device *op)
 		goto out_dispose2;
 	}
 
-	ka = in_be32(&rtc->regs->keep_alive);
-	if (ka & 0x02) {
-		dev_warn(&op->dev,
-			"mpc5121-rtc: Battery or oscillator failure!\n");
-		out_be32(&rtc->regs->keep_alive, ka);
+	if (of_device_is_compatible(op->dev.of_node, "fsl,mpc5121-rtc")) {
+		u32 ka;
+		ka = in_be32(&rtc->regs->keep_alive);
+		if (ka & 0x02) {
+			dev_warn(&op->dev,
+				"mpc5121-rtc: Battery or oscillator failure!\n");
+			out_be32(&rtc->regs->keep_alive, ka);
+		}
+
+		rtc->rtc = rtc_device_register("mpc5121-rtc", &op->dev,
+						&mpc5121_rtc_ops, THIS_MODULE);
+	} else {
+		rtc->rtc = rtc_device_register("mpc5200-rtc", &op->dev,
+						&mpc5200_rtc_ops, THIS_MODULE);
 	}
 
-	rtc->rtc = rtc_device_register("mpc5121-rtc", &op->dev,
-					&mpc5121_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		err = PTR_ERR(rtc->rtc);
 		goto out_free_irq;
@@ -340,6 +404,7 @@ static int __devexit mpc5121_rtc_remove(struct platform_device *op)
 
 static struct of_device_id mpc5121_rtc_match[] __devinitdata = {
 	{ .compatible = "fsl,mpc5121-rtc", },
+	{ .compatible = "fsl,mpc5200-rtc", },
 	{},
 };
 
-- 
1.7.4.4

