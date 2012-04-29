Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2D2Osq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 10:48:46 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:37476 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752239Ab2D2Ork (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 10:47:40 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v8 1/5] ohci-nxp: Driver cleanup
Date: Sun, 29 Apr 2012 16:47:02 +0200
Message-Id: <1335710826-6684-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1335710826-6684-1-git-send-email-stigge@antcom.de>
References: <1335710826-6684-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup for ohci-nxp.c:

* Cleanup of resource handling (mem and irq), use devm_request_and_ioremap()
* Use DMA_BIT_MASK()
* Don't remove __devinit
* Removed obsolete gpio.h include
* More consistent bit access symbols
* Removed unused extern declaration ocpi_enable()
* Added error handling on i2c_get_adapter()
* Whitespace cleanup

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 drivers/usb/host/ohci-nxp.c |   44 +++++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
index d02abc3..63261f7 100644
--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -29,7 +29,6 @@
 
 #include <mach/platform.h>
 #include <mach/irqs.h>
-#include <asm/gpio.h>
 
 #define USB_CONFIG_BASE		0x31020000
 #define PWRMAN_BASE		0x40004000
@@ -38,7 +37,9 @@
 
 /* USB_CTRL bit defines */
 #define USB_SLAVE_HCLK_EN	(1 << 24)
+#define USB_DEV_NEED_CLK_EN	(1 << 22)
 #define USB_HOST_NEED_CLK_EN	(1 << 21)
+#define PAD_CONTROL_LAST_DRIVEN	(1 << 19)
 
 #define USB_OTG_CLK_CTRL	IO_ADDRESS(USB_CONFIG_BASE + 0xFF4)
 #define USB_OTG_CLK_STAT	IO_ADDRESS(USB_CONFIG_BASE + 0xFF8)
@@ -117,7 +118,6 @@ static struct i2c_driver isp1301_driver;
 static struct i2c_client *isp1301_i2c_client;
 
 extern int usb_disabled(void);
-extern int ocpi_enable(void);
 
 static struct clk *usb_clk;
 
@@ -220,7 +220,7 @@ static void isp1301_configure_lpc32xx(void)
 		ISP1301_I2C_INTERRUPT_RISING | ISP1301_I2C_REG_CLEAR_ADDR, ~0);
 
 	/* Enable usb_need_clk clock after transceiver is initialized */
-	__raw_writel((__raw_readl(USB_CTRL) | (1 << 22)), USB_CTRL);
+	__raw_writel(__raw_readl(USB_CTRL) | USB_HOST_NEED_CLK_EN, USB_CTRL);
 
 	printk(KERN_INFO "ISP1301 Vendor ID  : 0x%04x\n",
 	      i2c_smbus_read_word_data(isp1301_i2c_client, 0x00));
@@ -374,9 +374,13 @@ static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
 	const struct hc_driver *driver = &ohci_nxp_hc_driver;
 	struct i2c_adapter *i2c_adap;
 	struct i2c_board_info i2c_info;
+	struct resource *res;
 
 	int ret = 0, irq;
 
+	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
+
 	dev_dbg(&pdev->dev, "%s: " DRIVER_DESC " (nxp)\n", hcd_name);
 	if (usb_disabled()) {
 		dev_err(&pdev->dev, "USB is disabled\n");
@@ -384,16 +388,8 @@ static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	if (pdev->num_resources != 2
-	    || pdev->resource[0].flags != IORESOURCE_MEM
-	    || pdev->resource[1].flags != IORESOURCE_IRQ) {
-		dev_err(&pdev->dev, "Invalid resource configuration\\nn");
-		ret = -ENODEV;
-		goto out;
-	}
-
 	/* Enable AHB slave USB clock, needed for further USB clock control */
-	__raw_writel(USB_SLAVE_HCLK_EN | (1 << 19), USB_CTRL);
+	__raw_writel(USB_SLAVE_HCLK_EN | PAD_CONTROL_LAST_DRIVEN, USB_CTRL);
 
 	ret = i2c_add_driver(&isp1301_driver);
 	if (ret < 0) {
@@ -401,6 +397,11 @@ static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
 		goto out;
 	}
 	i2c_adap = i2c_get_adapter(2);
+	if (!i2c_adap) {
+		dev_err(&pdev->dev, "failed on i2c_get_adapter");
+		goto out_i2c_driver;
+	}
+
 	memset(&i2c_info, 0, sizeof(struct i2c_board_info));
 	strlcpy(i2c_info.type, "isp1301_nxp", I2C_NAME_SIZE);
 	isp1301_i2c_client = i2c_new_probed_device(i2c_adap, &i2c_info,
@@ -442,7 +443,7 @@ static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
 	while ((__raw_readl(USB_OTG_CLK_STAT) & USB_CLOCK_MASK) !=
 	       USB_CLOCK_MASK) ;
 
-	hcd = usb_create_hcd (driver, &pdev->dev, dev_name(&pdev->dev));
+	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
 	if (!hcd) {
 		dev_err(&pdev->dev, "Failed to allocate HC buffer\n");
 		ret = -ENOMEM;
@@ -452,14 +453,21 @@ static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
 	/* Set all USB bits in the Start Enable register */
 	nxp_set_usb_bits();
 
-	hcd->rsrc_start = pdev->resource[0].start;
-	hcd->rsrc_len = pdev->resource[0].end - pdev->resource[0].start + 1;
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		dev_dbg(&pdev->dev, "request_mem_region failed\n");
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "Failed to get MEM resource\n");
+		ret =  -ENOMEM;
+		goto out4;
+	}
+
+	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
+	if (!hcd->regs) {
+		dev_err(&pdev->dev, "Failed to devm_request_and_ioremap\n");
 		ret =  -ENOMEM;
 		goto out4;
 	}
-	hcd->regs = (void __iomem *)pdev->resource[0].start;
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = resource_size(res);
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-- 
1.7.9

