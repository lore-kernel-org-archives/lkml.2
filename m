Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab2BBPE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 10:04:27 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:35598 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751766Ab2BBPEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 10:04:24 -0500
From: stigge@antcom.de
To: w.sang@pengutronix.de, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, jic23@cam.ac.uk,
        gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] ARM: LPC32xx: ADC support
Date: Thu,  2 Feb 2012 16:02:58 +0100
Message-Id: <1328194978-20064-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.8.3
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a 3-channel ADC driver for the LPC32xx ARM SoC

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/arch/arm/mach-lpc32xx/clock.c b/arch/arm/mach-lpc32xx/clock.c
index c269ef5..9cda6fa 100644
--- a/arch/arm/mach-lpc32xx/clock.c
+++ b/arch/arm/mach-lpc32xx/clock.c
@@ -760,6 +760,36 @@ static struct clk clk_tsc = {
 	.get_rate	= local_return_parent_rate,
 };
 
+static int adc_onoff_enable(struct clk *clk, int enable)
+{
+	u32 tmp;
+
+	/* Use PERIPH_CLOCK */
+	tmp = __raw_readl(LPC32XX_CLKPWR_ADC_CLK_CTRL_1);
+	tmp |= LPC32XX_CLKPWR_ADCCTRL1_PCLK_SEL;
+	/*
+	 * Set clock divider so that we have equal to or less than
+	 * 4.5MHz clock at ADC
+	 */
+	tmp |= clk->get_rate(clk) / 4500000 + 1;
+	__raw_writel(tmp, LPC32XX_CLKPWR_ADC_CLK_CTRL_1);
+
+	if (enable == 0)
+		__raw_writel(0, clk->enable_reg);
+	else
+		__raw_writel(clk->enable_mask, clk->enable_reg);
+
+	return 0;
+}
+
+static struct clk clk_adc = {
+	.parent		= &clk_pclk,
+	.enable		= adc_onoff_enable,
+	.enable_reg	= LPC32XX_CLKPWR_ADC_CLK_CTRL,
+	.enable_mask	= LPC32XX_CLKPWR_ADC32CLKCTRL_CLK_EN,
+	.get_rate	= local_return_parent_rate,
+};
+
 static int mmc_onoff_enable(struct clk *clk, int enable)
 {
 	u32 tmp;
@@ -1097,6 +1127,7 @@ static struct clk_lookup lookups[] = {
 	_REGISTER_CLOCK("dev:ssp1", NULL, clk_ssp1)
 	_REGISTER_CLOCK("lpc32xx_keys.0", NULL, clk_kscan)
 	_REGISTER_CLOCK("lpc32xx-nand.0", "nand_ck", clk_nand)
+	_REGISTER_CLOCK("lpc32xx-adc", NULL, clk_adc)
 	_REGISTER_CLOCK(NULL, "i2s0_ck", clk_i2s0)
 	_REGISTER_CLOCK(NULL, "i2s1_ck", clk_i2s1)
 	_REGISTER_CLOCK("ts-lpc32xx", NULL, clk_tsc)
diff --git a/arch/arm/mach-lpc32xx/common.c b/arch/arm/mach-lpc32xx/common.c
index f220eb0..2f869c0 100644
--- a/arch/arm/mach-lpc32xx/common.c
+++ b/arch/arm/mach-lpc32xx/common.c
@@ -137,6 +137,27 @@ struct platform_device lpc32xx_rtc_device = {
 	.resource = lpc32xx_rtc_resources,
 };
 
+/*
+ * ADC support
+ */
+static struct resource adc_resources[] = {
+	{
+		.start = LPC32XX_ADC_BASE,
+		.end = LPC32XX_ADC_BASE + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_LPC32XX_TS_IRQ,
+		.end = IRQ_LPC32XX_TS_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+struct platform_device lpc32xx_adc_device = {
+	.name =  "lpc32xx-adc",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(adc_resources),
+	.resource = adc_resources,
+};
+
 #if defined(CONFIG_USB_OHCI_HCD)
 /* The dmamask must be set for OHCI to work */
 static u64 ohci_dmamask = ~(u32) 0;
diff --git a/arch/arm/mach-lpc32xx/common.h b/arch/arm/mach-lpc32xx/common.h
index e42d702..5bf0050 100644
--- a/arch/arm/mach-lpc32xx/common.h
+++ b/arch/arm/mach-lpc32xx/common.h
@@ -30,6 +30,7 @@ extern struct platform_device lpc32xx_i2c0_device;
 extern struct platform_device lpc32xx_i2c1_device;
 extern struct platform_device lpc32xx_i2c2_device;
 extern struct platform_device lpc32xx_tsc_device;
+extern struct platform_device lpc32xx_adc_device;
 extern struct platform_device lpc32xx_rtc_device;
 extern struct platform_device lpc32xx_ohci_device;
 
diff --git a/arch/arm/mach-lpc32xx/phy3250.c b/arch/arm/mach-lpc32xx/phy3250.c
index 69a5ceb..23b484c 100644
--- a/arch/arm/mach-lpc32xx/phy3250.c
+++ b/arch/arm/mach-lpc32xx/phy3250.c
@@ -317,6 +317,9 @@ static struct platform_device *phy3250_devs[] __initdata = {
 #if defined(CONFIG_LPC_ENET)
 	&lpc32xx_net_device,
 #endif
+#if defined(CONFIG_LPC32XX_ADC)
+	&lpc32xx_adc_device,
+#endif
 };
 
 static struct amba_device *amba_devs[] __initdata = {
diff --git a/drivers/staging/iio/adc/Kconfig b/drivers/staging/iio/adc/Kconfig
index d9decea..592eabd 100644
--- a/drivers/staging/iio/adc/Kconfig
+++ b/drivers/staging/iio/adc/Kconfig
@@ -193,4 +193,13 @@ config MAX1363_RING_BUFFER
 	  Say yes here to include ring buffer support in the MAX1363
 	  ADC driver.
 
+config LPC32XX_ADC
+	tristate "NXP LPC32XX ADC"
+	depends on ARCH_LPC32XX && !TOUCHSCREEN_LPC32XX
+	help
+	  Say yes here to build support for the integrated ADC inside the
+	  LPC32XX SoC. Note that this feature uses the same hardware as the
+	  touchscreen driver, so you can only select one of the two drivers
+	  (lpc32xx_adc or lpc32xx_ts). Provides direct access via sysfs.
+
 endmenu
diff --git a/drivers/staging/iio/adc/Makefile b/drivers/staging/iio/adc/Makefile
index ceee7f3..f83ab95 100644
--- a/drivers/staging/iio/adc/Makefile
+++ b/drivers/staging/iio/adc/Makefile
@@ -37,3 +37,4 @@ obj-$(CONFIG_AD7192) += ad7192.o
 obj-$(CONFIG_ADT7310) += adt7310.o
 obj-$(CONFIG_ADT7410) += adt7410.o
 obj-$(CONFIG_AD7280) += ad7280a.o
+obj-$(CONFIG_LPC32XX_ADC) += lpc32xx_adc.o
diff --git a/drivers/staging/iio/adc/lpc32xx_adc.c b/drivers/staging/iio/adc/lpc32xx_adc.c
new file mode 100644
index 0000000..6b27446
--- /dev/null
+++ b/drivers/staging/iio/adc/lpc32xx_adc.c
@@ -0,0 +1,286 @@
+/*
+ *  lpc32xx_adc.c - Support for ADC in LPC32XX
+ *
+ *  Copyright (C) 2011 Roland Stigge <stigge@antcom.de>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/completion.h>
+
+#include "../iio.h"
+#include "../sysfs.h"
+
+/*
+ * LPC32XX registers definitions
+ */
+
+#define LPC32XX_ADC_SELECT(x)	((x) + 0x04)
+#define LPC32XX_ADC_CTRL(x)	((x) + 0x08)
+#define LPC32XX_ADC_VALUE(x)	((x) + 0x48)
+
+/* Bit definitions for LPC32XX_ADC_SELECT: */
+#define AD_REFm         0x00000200 /* constant, always write this value! */
+#define AD_REFp		0x00000080 /* constant, always write this value! */
+#define AD_IN		0x00000010 /* multiple of this is the */
+				   /* channel number: 0, 1, 2 */
+#define AD_INTERNAL	0x00000004 /* constant, always write this value! */
+
+/* Bit definitions for LPC32XX_ADC_CTRL: */
+#define AD_STROBE	0x00000002
+#define AD_PDN_CTRL	0x00000004
+
+/* Bit definitions for LPC32XX_ADC_VALUE: */
+#define ADC_VALUE_MASK	0x000003FF
+
+#define MOD_NAME "lpc32xx-adc"
+
+/*
+ * chip specifc information
+ */
+
+struct lpc32xx_adc_info {
+	struct iio_dev *dev;
+	void __iomem *adc_base;
+	int irq;
+	struct clk *clk;
+	struct completion completion;
+
+	u32 value;
+};
+
+/*
+ * sysfs nodes
+ */
+static ssize_t lpc32xx_adin_value(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct lpc32xx_adc_info *info = iio_priv(dev_info);
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	int result;
+
+	mutex_lock(&dev_info->mlock);
+	/* Measurement setup */
+	__raw_writel(AD_INTERNAL | (AD_IN * this_attr->address) |
+		AD_REFp | AD_REFm,
+		LPC32XX_ADC_SELECT(info->adc_base));
+	/* Trigger conversion */
+	__raw_writel(AD_PDN_CTRL | AD_STROBE,
+		LPC32XX_ADC_CTRL(info->adc_base));
+
+	wait_for_completion(&info->completion); /* set by ISR */
+
+	result = sprintf(buf, "%d\n", info->value);
+
+	mutex_unlock(&dev_info->mlock);
+
+	return result;
+}
+
+static IIO_DEVICE_ATTR(in0_raw, S_IRUGO, lpc32xx_adin_value, NULL, 0);
+static IIO_DEVICE_ATTR(in1_raw, S_IRUGO, lpc32xx_adin_value, NULL, 1);
+static IIO_DEVICE_ATTR(in2_raw, S_IRUGO, lpc32xx_adin_value, NULL, 2);
+
+static struct attribute *lpc32xx_adin_attributes[] = {
+	&iio_dev_attr_in0_raw.dev_attr.attr,
+	&iio_dev_attr_in1_raw.dev_attr.attr,
+	&iio_dev_attr_in2_raw.dev_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group lpc32xx_adin_attribute_group = {
+	.attrs = lpc32xx_adin_attributes,
+};
+
+static const struct iio_info lpc32xx_adc_iio_info = {
+	.attrs = &lpc32xx_adin_attribute_group,
+	.driver_module = THIS_MODULE,
+};
+
+static irqreturn_t lpc32xx_adc_isr(int irq, void *dev_id)
+{
+	struct lpc32xx_adc_info *info = (struct lpc32xx_adc_info *) dev_id;
+
+	/* Read value and clear irq */
+	info->value = __raw_readl(LPC32XX_ADC_VALUE(info->adc_base)) &
+				ADC_VALUE_MASK;
+	complete(&info->completion);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit lpc32xx_adc_probe(struct platform_device *pdev)
+{
+	struct lpc32xx_adc_info *info = NULL;
+	struct resource *res;
+	int retval = -ENODEV;
+	struct iio_dev *iodev = NULL;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to get platform I/O memory\n");
+		retval = -EBUSY;
+		goto errout1;
+	}
+
+	iodev = iio_allocate_device(sizeof(struct lpc32xx_adc_info));
+	if (!iodev) {
+		dev_err(&pdev->dev, "failed allocating iio device\n");
+		retval = -ENOMEM;
+		goto errout1;
+	}
+
+	info = iio_priv(iodev);
+	info->dev = iodev;
+
+	info->adc_base = ioremap(res->start, res->end - res->start + 1);
+	if (!info->adc_base) {
+		dev_err(&pdev->dev, "failed mapping memory\n");
+		retval = -EBUSY;
+		goto errout3;
+	}
+
+	iodev->name = MOD_NAME;
+	iodev->dev.parent = &pdev->dev;
+	iodev->info = &lpc32xx_adc_iio_info;
+	iodev->modes = INDIO_DIRECT_MODE;
+
+	retval = iio_device_register(iodev);
+	if (retval)
+		goto errout4;
+
+	info->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(info->clk)) {
+		dev_err(&pdev->dev, "failed getting clock\n");
+		goto errout5;
+	}
+	clk_enable(info->clk);
+
+	info->irq = platform_get_irq(pdev, 0);
+	if ((info->irq < 0) || (info->irq >= NR_IRQS)) {
+		dev_err(&pdev->dev, "failed getting interrupt resource\n");
+		retval = -EINVAL;
+		goto errout6;
+	}
+
+	retval = request_irq(info->irq, lpc32xx_adc_isr, 0, MOD_NAME, info);
+	if (retval < 0) {
+		dev_err(&pdev->dev, "failed requesting interrupt\n");
+		goto errout6;
+	}
+
+	platform_set_drvdata(pdev, info);
+
+	device_init_wakeup(&pdev->dev, 1);
+	init_completion(&info->completion);
+
+	printk(KERN_INFO "LPC32XX ADC driver loaded, IRQ %d\n", info->irq);
+
+	return 0;
+
+errout6:
+	clk_disable(info->clk);
+	clk_put(info->clk);
+errout5:
+	iio_device_unregister(info->dev);
+errout4:
+	iounmap(info->adc_base);
+errout3:
+	iio_free_device(info->dev);
+errout1:
+	return retval;
+}
+
+static int __devexit lpc32xx_adc_remove(struct platform_device *pdev)
+{
+	struct lpc32xx_adc_info *info = platform_get_drvdata(pdev);
+
+	free_irq(info->irq, info->dev);
+	platform_set_drvdata(pdev, NULL);
+	clk_disable(info->clk);
+	clk_put(info->clk);
+	iio_device_unregister(info->dev);
+	iio_free_device(info->dev);
+	iounmap(info->adc_base);
+	kfree(info);
+
+	printk(KERN_INFO "LPC32XX ADC driver unloaded\n");
+
+	return 0;
+}
+
+#if defined(CONFIG_SUSPEND)
+static int lpc32xx_adc_suspend(struct device *dev)
+{
+	struct lpc32xx_adc_info *info = dev_get_drvdata(dev);
+
+	clk_disable(info->clk);
+	return 0;
+}
+
+static int lpc32xx_adc_resume(struct device *dev)
+{
+	struct lpc32xx_adc_info *info = dev_get_drvdata(dev);
+
+	clk_enable(info->clk);
+	return 0;
+}
+
+static const struct dev_pm_ops lpc32xx_adc_pm_ops = {
+	.suspend	= lpc32xx_adc_suspend,
+	.resume		= lpc32xx_adc_resume,
+};
+#define LPC32XX_ADC_PM_OPS (&lpc32xx_adc_pm_ops)
+#else
+#define LPC32XX_ADC_PM_OPS NULL
+#endif
+
+static struct platform_driver lpc32xx_adc_driver = {
+	.probe		= lpc32xx_adc_probe,
+	.remove		= __devexit_p(lpc32xx_adc_remove),
+	.driver		= {
+		.name	= MOD_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= LPC32XX_ADC_PM_OPS,
+	},
+};
+
+static int __init lpc32xx_adc_init(void)
+{
+	return platform_driver_register(&lpc32xx_adc_driver);
+}
+
+static void __exit lpc32xx_adc_exit(void)
+{
+	platform_driver_unregister(&lpc32xx_adc_driver);
+}
+
+module_init(lpc32xx_adc_init);
+module_exit(lpc32xx_adc_exit);
+
+MODULE_AUTHOR("Roland Stigge <stigge@antcom.de>");
+MODULE_DESCRIPTION("LPC32XX ADC driver");
+MODULE_LICENSE("GPL");
