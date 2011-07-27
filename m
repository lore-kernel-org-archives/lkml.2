Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab1G0HIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 03:08:19 -0400
Received: from smtp-out.google.com ([74.125.121.67]:33359 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1G0HIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 03:08:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=R7yDafXzjKt9bvPAjphaGD1uiuJUq9HBp6zuX0hh6zJqOk+PT5epbcQnLouJ7XdWN
	BcPDmXwRf0/klIAYAHlvQ==
From: Todd Poynor <toddpoynor@google.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Todd Poynor <toddpoynor@google.com>
Subject: [PATCH 2/2] rtc: twl: Fix registration vs. init order
Date: Wed, 27 Jul 2011 00:07:21 -0700
Message-Id: <1311750441-5559-2-git-send-email-toddpoynor@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1311750441-5559-1-git-send-email-toddpoynor@google.com>
References: <1311750441-5559-1-git-send-email-toddpoynor@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only register as an RTC device after the hardware has been
successfully initialized.  The RTC class driver will call
back to this driver to read a pending alarm, and other
drivers watching for new devices on the RTC class may
read the RTC time upon registration.  Such access might
occur while the RTC is stopped, prior to clearing
pending alarms, etc.

The new ordering also avoids leaving the platform
device drvdata set to an unregistered struct rtc_device *
on probe errors.

Signed-off-by: Todd Poynor <toddpoynor@google.com>
---
 drivers/rtc/rtc-twl.c |   52 ++++++++++++++++++++++--------------------------
 1 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index ece41b9..20687d5 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -420,24 +420,12 @@ static struct rtc_class_ops twl_rtc_ops = {
 static int __devinit twl_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
-	int ret = 0;
+	int ret = -EINVAL;
 	int irq = platform_get_irq(pdev, 0);
 	u8 rd_reg;
 
 	if (irq <= 0)
-		return -EINVAL;
-
-	rtc = rtc_device_register(pdev->name,
-				  &pdev->dev, &twl_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
-		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
-			PTR_ERR(rtc));
-		goto out0;
-
-	}
-
-	platform_set_drvdata(pdev, rtc);
+		goto out1;
 
 	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (ret < 0)
@@ -454,14 +442,6 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto out1;
 
-	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
-				   IRQF_TRIGGER_RISING,
-				   dev_name(&rtc->dev), rtc);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "IRQ is not free.\n");
-		goto out1;
-	}
-
 	if (twl_class_is_6030()) {
 		twl6030_interrupt_unmask(TWL6030_RTC_INT_MASK,
 			REG_INT_MSK_LINE_A);
@@ -472,28 +452,44 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 	/* Check RTC module status, Enable if it is off */
 	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_CTRL_REG);
 	if (ret < 0)
-		goto out2;
+		goto out1;
 
 	if (!(rd_reg & BIT_RTC_CTRL_REG_STOP_RTC_M)) {
 		dev_info(&pdev->dev, "Enabling TWL-RTC.\n");
 		rd_reg = BIT_RTC_CTRL_REG_STOP_RTC_M;
 		ret = twl_rtc_write_u8(rd_reg, REG_RTC_CTRL_REG);
 		if (ret < 0)
-			goto out2;
+			goto out1;
 	}
 
 	/* init cached IRQ enable bits */
 	ret = twl_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
 	if (ret < 0)
+		goto out1;
+
+	rtc = rtc_device_register(pdev->name,
+				  &pdev->dev, &twl_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		ret = PTR_ERR(rtc);
+		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
+			PTR_ERR(rtc));
+		goto out1;
+	}
+
+	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
+				   IRQF_TRIGGER_RISING,
+				   dev_name(&rtc->dev), rtc);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "IRQ is not free.\n");
 		goto out2;
+	}
 
-	return ret;
+	platform_set_drvdata(pdev, rtc);
+	return 0;
 
 out2:
-	free_irq(irq, rtc);
-out1:
 	rtc_device_unregister(rtc);
-out0:
+out1:
 	return ret;
 }
 
-- 
1.7.3.1

