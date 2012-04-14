Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab2DNKzg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:55:36 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:30636 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752648Ab2DNKyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:54:14 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, axel.lin@gmail.com,
        broonie@opensource.wolfsonmicro.com, marek.vasut@gmail.com,
        thierry.reding@avionic-design.de, devel@driverdev.osuosl.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 1/4] ohci-nxp: Device tree support
Date: Sat, 14 Apr 2012 12:53:07 +0200
Message-Id: <1334400790-10892-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1334400790-10892-1-git-send-email-stigge@antcom.de>
References: <1334400790-10892-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support to ohci-nxp.c

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Applies to v3.4-rc2

 Documentation/devicetree/bindings/usb/ohci-nxp.txt |   16 ++++
 drivers/usb/host/ohci-nxp.c                        |   68 ++++++++++++++-------
 2 files changed, 64 insertions(+), 20 deletions(-)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/usb/ohci-nxp.txt
@@ -0,0 +1,16 @@
+* OHCI controller, NXP ohci-nxp variant
+
+Required properties:
+- compatible: must be "nxp,ohci-nxp"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: The OHCI interrupt
+
+Example (LPC32xx):
+
+	ohci@31020000 {
+		compatible = "nxp,ohci-nxp";
+		reg = <0x31020000 0x300>;
+		interrupt-parent = <&mic>;
+		interrupts = <0x3b 0>;
+	};
--- linux-2.6.orig/drivers/usb/host/ohci-nxp.c
+++ linux-2.6/drivers/usb/host/ohci-nxp.c
@@ -22,6 +22,7 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
+#include <linux/of.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -29,7 +30,6 @@
 
 #include <mach/platform.h>
 #include <mach/irqs.h>
-#include <asm/gpio.h>
 
 #define USB_CONFIG_BASE		0x31020000
 #define PWRMAN_BASE		0x40004000
@@ -38,6 +38,7 @@
 
 /* USB_CTRL bit defines */
 #define USB_SLAVE_HCLK_EN	(1 << 24)
+#define USB_DEV_NEED_CLK_EN	(1 << 22)
 #define USB_HOST_NEED_CLK_EN	(1 << 21)
 
 #define USB_OTG_CLK_CTRL	IO_ADDRESS(USB_CONFIG_BASE + 0xFF4)
@@ -117,7 +118,6 @@ static struct i2c_driver isp1301_driver;
 static struct i2c_client *isp1301_i2c_client;
 
 extern int usb_disabled(void);
-extern int ocpi_enable(void);
 
 static struct clk *usb_clk;
 
@@ -220,7 +220,7 @@ static void isp1301_configure_lpc32xx(vo
 		ISP1301_I2C_INTERRUPT_RISING | ISP1301_I2C_REG_CLEAR_ADDR, ~0);
 
 	/* Enable usb_need_clk clock after transceiver is initialized */
-	__raw_writel((__raw_readl(USB_CTRL) | (1 << 22)), USB_CTRL);
+	__raw_writel((__raw_readl(USB_CTRL) | USB_HOST_NEED_CLK_EN), USB_CTRL);
 
 	printk(KERN_INFO "ISP1301 Vendor ID  : 0x%04x\n",
 	      i2c_smbus_read_word_data(isp1301_i2c_client, 0x00));
@@ -266,7 +266,7 @@ static void nxp_stop_hc(void)
 	__raw_writel(tmp, USB_OTG_STAT_CONTROL);
 }
 
-static int __devinit ohci_nxp_start(struct usb_hcd *hcd)
+static int ohci_nxp_start(struct usb_hcd *hcd)
 {
 	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
 	int ret;
@@ -367,16 +367,20 @@ static void nxp_unset_usb_bits(void)
 	}
 }
 
-static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
+static int usb_hcd_nxp_probe(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd = 0;
 	struct ohci_hcd *ohci;
 	const struct hc_driver *driver = &ohci_nxp_hc_driver;
 	struct i2c_adapter *i2c_adap;
 	struct i2c_board_info i2c_info;
+	struct resource *res;
 
 	int ret = 0, irq;
 
+	pdev->dev.coherent_dma_mask = 0xFFFFFFFF;
+	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
+
 	dev_dbg(&pdev->dev, "%s: " DRIVER_DESC " (nxp)\n", hcd_name);
 	if (usb_disabled()) {
 		err("USB is disabled");
@@ -384,16 +388,10 @@ static int __devinit usb_hcd_nxp_probe(s
 		goto out;
 	}
 
-	if (pdev->num_resources != 2
-	    || pdev->resource[0].flags != IORESOURCE_MEM
-	    || pdev->resource[1].flags != IORESOURCE_IRQ) {
-		err("Invalid resource configuration");
-		ret = -ENODEV;
-		goto out;
-	}
-
 	/* Enable AHB slave USB clock, needed for further USB clock control */
-	__raw_writel(USB_SLAVE_HCLK_EN | (1 << 19), USB_CTRL);
+	__raw_writel(__raw_readl(USB_CTRL) | USB_SLAVE_HCLK_EN, USB_CTRL);
+	__raw_writel(__raw_readl(USB_CTRL) & ~(1 << 20), USB_CTRL);
+	__raw_writel(__raw_readl(USB_CTRL) | (1 << 19), USB_CTRL);
 
 	ret = i2c_add_driver(&isp1301_driver);
 	if (ret < 0) {
@@ -401,6 +399,11 @@ static int __devinit usb_hcd_nxp_probe(s
 		goto out;
 	}
 	i2c_adap = i2c_get_adapter(2);
+	if (!i2c_adap) {
+		err("failed on i2c_get_adapter");
+		goto out_i2c_driver;
+	}
+
 	memset(&i2c_info, 0, sizeof(struct i2c_board_info));
 	strlcpy(i2c_info.type, "isp1301_nxp", I2C_NAME_SIZE);
 	isp1301_i2c_client = i2c_new_probed_device(i2c_adap, &i2c_info,
@@ -435,6 +438,7 @@ static int __devinit usb_hcd_nxp_probe(s
 	}
 
 	__raw_writel(__raw_readl(USB_CTRL) | USB_HOST_NEED_CLK_EN, USB_CTRL);
+	__raw_writel(__raw_readl(USB_CTRL) & ~USB_DEV_NEED_CLK_EN, USB_CTRL);
 
 	/* Set to enable all needed USB clocks */
 	__raw_writel(USB_CLOCK_MASK, USB_OTG_CLK_CTRL);
@@ -442,7 +446,7 @@ static int __devinit usb_hcd_nxp_probe(s
 	while ((__raw_readl(USB_OTG_CLK_STAT) & USB_CLOCK_MASK) !=
 	       USB_CLOCK_MASK) ;
 
-	hcd = usb_create_hcd (driver, &pdev->dev, dev_name(&pdev->dev));
+	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
 	if (!hcd) {
 		err("Failed to allocate HC buffer");
 		ret = -ENOMEM;
@@ -452,19 +456,30 @@ static int __devinit usb_hcd_nxp_probe(s
 	/* Set all USB bits in the Start Enable register */
 	nxp_set_usb_bits();
 
-	hcd->rsrc_start = pdev->resource[0].start;
-	hcd->rsrc_len = pdev->resource[0].end - pdev->resource[0].start + 1;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "Failed to get MEM resource");
+		ret =  -ENOMEM;
+		goto out4;
+	}
+	hcd->rsrc_start = IO_ADDRESS(res->start);
+	hcd->rsrc_len = resource_size(res);
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		dev_dbg(&pdev->dev, "request_mem_region failed\n");
+		dev_err(&pdev->dev, "request_mem_region failed\n");
 		ret =  -ENOMEM;
 		goto out4;
 	}
-	hcd->regs = (void __iomem *)pdev->resource[0].start;
+	hcd->regs = ioremap(res->start, hcd->rsrc_len);
+	if (!hcd->regs) {
+		err("Failed to ioremap");
+		ret =  -ENOMEM;
+		goto out5;
+	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		ret = -ENXIO;
-		goto out4;
+		goto out6;
 	}
 
 	nxp_start_hc();
@@ -478,6 +493,10 @@ static int __devinit usb_hcd_nxp_probe(s
 		return ret;
 
 	nxp_stop_hc();
+out6:
+	iounmap(hcd->regs);
+out5:
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 out4:
 	nxp_unset_usb_bits();
 	usb_put_hcd(hcd);
@@ -517,10 +536,19 @@ static int usb_hcd_nxp_remove(struct pla
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:usb-ohci");
 
+#ifdef CONFIG_OF
+static const struct of_device_id usb_hcd_nxp_match[] = {
+	{ .compatible = "nxp,ohci-nxp" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, usb_hcd_nxp_match);
+#endif
+
 static struct platform_driver usb_hcd_nxp_driver = {
 	.driver = {
 		.name = "usb-ohci",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(usb_hcd_nxp_match),
 	},
 	.probe = usb_hcd_nxp_probe,
 	.remove = usb_hcd_nxp_remove,
