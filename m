Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab2ACWiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:38:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39754 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab2ACWh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:37:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:36 2012
Message-Id: <20120103223036.871289026@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:30:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kyle Manna <kyle@kylemanna.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [66/67] mfd: Turn on the twl4030-madc MADC clock
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Manna <kyle@kylemanna.com>

commit 3d6271f92e98094584fd1e609a9969cd33e61122 upstream.

Without turning the MADC clock on, no MADC conversions occur.

$ cat /sys/class/hwmon/hwmon0/device/in8_input
[   53.428436] twl4030_madc twl4030_madc: conversion timeout!
cat: read error: Resource temporarily unavailable

Signed-off-by: Kyle Manna <kyle@kylemanna.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/twl4030-madc.c       |   22 ++++++++++++++++++++++
 include/linux/i2c/twl4030-madc.h |    4 ++++
 2 files changed, 26 insertions(+)

--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -740,6 +740,28 @@ static int __devinit twl4030_madc_probe(
 			TWL4030_BCI_BCICTL1);
 		goto err_i2c;
 	}
+
+	/* Check that MADC clock is on */
+	ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &regval, TWL4030_REG_GPBR1);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to read reg GPBR1 0x%X\n",
+				TWL4030_REG_GPBR1);
+		goto err_i2c;
+	}
+
+	/* If MADC clk is not on, turn it on */
+	if (!(regval & TWL4030_GPBR1_MADC_HFCLK_EN)) {
+		dev_info(&pdev->dev, "clk disabled, enabling\n");
+		regval |= TWL4030_GPBR1_MADC_HFCLK_EN;
+		ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, regval,
+				       TWL4030_REG_GPBR1);
+		if (ret) {
+			dev_err(&pdev->dev, "unable to write reg GPBR1 0x%X\n",
+					TWL4030_REG_GPBR1);
+			goto err_i2c;
+		}
+	}
+
 	platform_set_drvdata(pdev, madc);
 	mutex_init(&madc->lock);
 	ret = request_threaded_irq(platform_get_irq(pdev, 0), NULL,
--- a/include/linux/i2c/twl4030-madc.h
+++ b/include/linux/i2c/twl4030-madc.h
@@ -129,6 +129,10 @@ enum sample_type {
 #define REG_BCICTL2             0x024
 #define TWL4030_BCI_ITHSENS	0x007
 
+/* Register and bits for GPBR1 register */
+#define TWL4030_REG_GPBR1		0x0c
+#define TWL4030_GPBR1_MADC_HFCLK_EN	(1 << 7)
+
 struct twl4030_madc_user_parms {
 	int channel;
 	int average;


