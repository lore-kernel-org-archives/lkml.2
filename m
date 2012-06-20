Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab2FTMCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:02:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63136 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab2FTMCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:02:52 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ohci-nxp: add usbd and otg clock initialization
Date: Wed, 20 Jun 2012 09:02:23 -0300
Message-Id: <1340193743-30764-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ohci-nxp was assuming the clock was enabled by the board init or
bootloader and just enabling the pll. This enables the usbd and otg
clocks this periferal also needs.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 drivers/usb/host/ohci-nxp.c |   88 +++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 33 deletions(-)

diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
index 1e364ec..a446386 100644
--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -43,16 +43,6 @@
 #define USB_HOST_NEED_CLK_EN	(1 << 21)
 #define PAD_CONTROL_LAST_DRIVEN	(1 << 19)
 
-#define USB_OTG_CLK_CTRL	IO_ADDRESS(USB_CONFIG_BASE + 0xFF4)
-#define USB_OTG_CLK_STAT	IO_ADDRESS(USB_CONFIG_BASE + 0xFF8)
-
-/* USB_OTG_CLK_CTRL bit defines */
-#define AHB_M_CLOCK_ON		(1 << 4)
-#define OTG_CLOCK_ON		(1 << 3)
-#define I2C_CLOCK_ON		(1 << 2)
-#define DEV_CLOCK_ON		(1 << 1)
-#define HOST_CLOCK_ON		(1 << 0)
-
 #define USB_OTG_STAT_CONTROL	IO_ADDRESS(USB_CONFIG_BASE + 0x110)
 
 /* USB_OTG_STAT_CONTROL bit defines */
@@ -72,7 +62,9 @@ static struct i2c_client *isp1301_i2c_client;
 
 extern int usb_disabled(void);
 
-static struct clk *usb_clk;
+static struct clk *usb_pll_clk;
+static struct clk *usb_dev_clk;
+static struct clk *usb_otg_clk;
 
 static void isp1301_configure_pnx4008(void)
 {
@@ -249,8 +241,6 @@ static const struct hc_driver ohci_nxp_hc_driver = {
 	.start_port_reset = ohci_start_port_reset,
 };
 
-#define USB_CLOCK_MASK (AHB_M_CLOCK_ON| OTG_CLOCK_ON | HOST_CLOCK_ON | I2C_CLOCK_ON)
-
 static void nxp_set_usb_bits(void)
 {
 	if (machine_is_pnx4008()) {
@@ -327,41 +317,63 @@ static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
 	/* Enable AHB slave USB clock, needed for further USB clock control */
 	__raw_writel(USB_SLAVE_HCLK_EN | PAD_CONTROL_LAST_DRIVEN, USB_CTRL);
 
-	isp1301_configure();
-
 	/* Enable USB PLL */
-	usb_clk = clk_get(&pdev->dev, "ck_pll5");
-	if (IS_ERR(usb_clk)) {
+	usb_pll_clk = clk_get(&pdev->dev, "ck_pll5");
+	if (IS_ERR(usb_pll_clk)) {
 		dev_err(&pdev->dev, "failed to acquire USB PLL\n");
-		ret = PTR_ERR(usb_clk);
+		ret = PTR_ERR(usb_pll_clk);
 		goto out1;
 	}
 
-	ret = clk_enable(usb_clk);
+	ret = clk_enable(usb_pll_clk);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to start USB PLL\n");
 		goto out2;
 	}
 
-	ret = clk_set_rate(usb_clk, 48000);
+	ret = clk_set_rate(usb_pll_clk, 48000);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to set USB clock rate\n");
 		goto out3;
 	}
 
+	/* Enable USB device clock */
+	usb_dev_clk = clk_get(&pdev->dev, "ck_usbd");
+	if (IS_ERR(usb_dev_clk)) {
+		dev_err(&pdev->dev, "failed to acquire USB DEV Clock\n");
+		ret = PTR_ERR(usb_dev_clk);
+		goto out4;
+	}
+
+	ret = clk_enable(usb_dev_clk);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to start USB DEV Clock\n");
+		goto out5;
+	}
+
+	/* Enable USB otg clocks */
+	usb_otg_clk = clk_get(&pdev->dev, "ck_usb_otg");
+	if (IS_ERR(usb_otg_clk)) {
+		dev_err(&pdev->dev, "failed to acquire USB DEV Clock\n");
+		ret = PTR_ERR(usb_dev_clk);
+		goto out6;
+	}
+
 	__raw_writel(__raw_readl(USB_CTRL) | USB_HOST_NEED_CLK_EN, USB_CTRL);
 
-	/* Set to enable all needed USB clocks */
-	__raw_writel(USB_CLOCK_MASK, USB_OTG_CLK_CTRL);
+	ret = clk_enable(usb_otg_clk);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to start USB DEV Clock\n");
+		goto out7;
+	}
 
-	while ((__raw_readl(USB_OTG_CLK_STAT) & USB_CLOCK_MASK) !=
-	       USB_CLOCK_MASK) ;
+	isp1301_configure();
 
 	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
 	if (!hcd) {
 		dev_err(&pdev->dev, "Failed to allocate HC buffer\n");
 		ret = -ENOMEM;
-		goto out3;
+		goto out8;
 	}
 
 	/* Set all USB bits in the Start Enable register */
@@ -371,14 +383,14 @@ static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
 	if (!res) {
 		dev_err(&pdev->dev, "Failed to get MEM resource\n");
 		ret =  -ENOMEM;
-		goto out4;
+		goto out8;
 	}
 
 	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
 	if (!hcd->regs) {
 		dev_err(&pdev->dev, "Failed to devm_request_and_ioremap\n");
 		ret =  -ENOMEM;
-		goto out4;
+		goto out8;
 	}
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
@@ -386,7 +398,7 @@ static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		ret = -ENXIO;
-		goto out4;
+		goto out8;
 	}
 
 	nxp_start_hc();
@@ -400,13 +412,21 @@ static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
 		return ret;
 
 	nxp_stop_hc();
-out4:
+out8:
 	nxp_unset_usb_bits();
 	usb_put_hcd(hcd);
+out7:
+	clk_disable(usb_otg_clk);
+out6:
+	clk_put(usb_otg_clk);
+out5:
+	clk_disable(usb_dev_clk);
+out4:
+	clk_put(usb_dev_clk);
 out3:
-	clk_disable(usb_clk);
+	clk_disable(usb_pll_clk);
 out2:
-	clk_put(usb_clk);
+	clk_put(usb_pll_clk);
 out1:
 	isp1301_i2c_client = NULL;
 out:
@@ -422,8 +442,10 @@ static int usb_hcd_nxp_remove(struct platform_device *pdev)
 	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	nxp_unset_usb_bits();
-	clk_disable(usb_clk);
-	clk_put(usb_clk);
+	clk_disable(usb_pll_clk);
+	clk_put(usb_pll_clk);
+	clk_disable(usb_dev_clk);
+	clk_put(usb_dev_clk);
 	i2c_unregister_device(isp1301_i2c_client);
 	isp1301_i2c_client = NULL;
 
-- 
1.7.10

