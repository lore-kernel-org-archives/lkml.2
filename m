Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab0FERWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 13:22:47 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:50725 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab0FERWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 13:22:45 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C0A87F1.8000201@jic23.retrosnub.co.uk>
Date: Sat, 05 Jun 2010 18:22:57 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [RFC][PATCH 22/26] hwmon: Add JZ4740 ADC driver
References: <1275505397-16758-1-git-send-email-lars@metafoo.de> <1275505950-17334-6-git-send-email-lars@metafoo.de>
In-Reply-To: <1275505950-17334-6-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/10 20:12, Lars-Peter Clausen wrote:
> This patch adds support for the ADC module on JZ4740 SoCs.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: lm-sensors@lm-sensors.org
> ---
>  drivers/hwmon/Kconfig      |   11 ++
>  drivers/hwmon/Makefile     |    1 +
>  drivers/hwmon/jz4740-adc.c |  423 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/jz4740-adc.h |   25 +++
>  4 files changed, 460 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/jz4740-adc.c
>  create mode 100644 include/linux/jz4740-adc.h
Hi, I'm just wondering of one wants the majority of this driver to sit in hwmon?

Looks to me like a fairly classic case for something that might be best implemented
as an mfd with the hwmon, touchscreen and battery drivers separately hanging off that.
You might well have someone who needs the battery driver to work, but doesn't care
about hwmon and so doesn't want to build that bit in... 

Just an immediate thought.  Perhaps this is the best way to do things...

Also after a quick look.  How is it used by the touchscreen driver?
If not, please remove the reference from kconfig until it it is true.

Few other bits and bobs inline.

> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index e19cf8e..da79ba9 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -446,6 +446,17 @@ config SENSORS_IT87
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called it87.
>  
> +config SENSORS_JZ4740
> +	tristate "Ingenic JZ4740 SoC ADC driver"
> +	depends on MACH_JZ4740
> +    help
> +      If you say yes here you get support for the Ingenic JZ4740 SoC ADC core.
> +      It is required for the JZ4740 battery and touchscreen driver and is used
> +      to synchronize access to the adc module between those two.
> +
> +      This driver can also be build as a module. If so, the module will be
> +      called jz4740-adc.
> +
>  config SENSORS_LM63
>  	tristate "National Semiconductor LM63 and LM64"
>  	depends on I2C
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 2138ceb..3e772aa 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -55,6 +55,7 @@ obj-$(CONFIG_SENSORS_I5K_AMB)	+= i5k_amb.o
>  obj-$(CONFIG_SENSORS_IBMAEM)	+= ibmaem.o
>  obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
>  obj-$(CONFIG_SENSORS_IT87)	+= it87.o
> +obj-$(CONFIG_SENSORS_JZ4740)	+= jz4740-adc.o
>  obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
>  obj-$(CONFIG_SENSORS_K10TEMP)	+= k10temp.o
>  obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o hp_accel.o
> diff --git a/drivers/hwmon/jz4740-adc.c b/drivers/hwmon/jz4740-adc.c
> new file mode 100644
> index 0000000..635dfe9
> --- /dev/null
> +++ b/drivers/hwmon/jz4740-adc.c
> @@ -0,0 +1,423 @@
> +/*
> + * Copyright (C) 2009-2010, Lars-Peter Clausen <lars@metafoo.de>
> + *		JZ4740 SoC ADC driver
> + *
> + * This program is free software; you can redistribute	 it and/or modify it
> + * under  the terms of	 the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the	License, or (at your
> + * option) any later version.
> + *
> + * You should have received a copy of the  GNU General Public License along
> + * with this program; if not, write  to the Free Software Foundation, Inc.,
> + * 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + * This driver is meant to synchronize access to the adc core for the battery
> + * and touchscreen driver. Thus these drivers should use the adc driver as a
> + * parent.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +
> +#include <linux/clk.h>
> +
> +#include <linux/jz4740-adc.h>
> +
> +#define JZ_REG_ADC_ENABLE	0x00
> +#define JZ_REG_ADC_CFG		0x04
> +#define JZ_REG_ADC_CTRL		0x08
> +#define JZ_REG_ADC_STATUS	0x0C
> +#define JZ_REG_ADC_SAME		0x10
> +#define JZ_REG_ADC_WAIT		0x14
> +#define JZ_REG_ADC_TOUCH	0x18
> +#define JZ_REG_ADC_BATTERY	0x1C
> +#define JZ_REG_ADC_ADCIN	0x20
> +
> +#define JZ_ADC_ENABLE_TOUCH		BIT(2)
> +#define JZ_ADC_ENABLE_BATTERY		BIT(1)
> +#define JZ_ADC_ENABLE_ADCIN		BIT(0)
> +
> +#define JZ_ADC_CFG_SPZZ			BIT(31)
> +#define JZ_ADC_CFG_EX_IN		BIT(30)
> +#define JZ_ADC_CFG_DNUM_MASK		(0x7 << 16)
> +#define JZ_ADC_CFG_DMA_ENABLE		BIT(15)
> +#define JZ_ADC_CFG_XYZ_MASK		(0x2 << 13)
> +#define JZ_ADC_CFG_SAMPLE_NUM_MASK	(0x7 << 10)
> +#define JZ_ADC_CFG_CLKDIV		(0xf << 5)
> +#define JZ_ADC_CFG_BAT_MB		BIT(4)
> +
> +#define JZ_ADC_CFG_DNUM_OFFSET		16
> +#define JZ_ADC_CFG_XYZ_OFFSET		13
> +#define JZ_ADC_CFG_SAMPLE_NUM_OFFSET	10
> +#define JZ_ADC_CFG_CLKDIV_OFFSET	5
> +
> +#define JZ_ADC_IRQ_PENDOWN		BIT(4)
> +#define JZ_ADC_IRQ_PENUP		BIT(3)
> +#define JZ_ADC_IRQ_TOUCH		BIT(2)
> +#define JZ_ADC_IRQ_BATTERY		BIT(1)
> +#define JZ_ADC_IRQ_ADCIN		BIT(0)
> +
> +#define JZ_ADC_TOUCH_TYPE1		BIT(31)
> +#define JZ_ADC_TOUCH_DATA1_MASK		0xfff
> +#define JZ_ADC_TOUCH_TYPE0		BIT(15)
> +#define JZ_ADC_TOUCH_DATA0_MASK		0xfff
> +
> +#define JZ_ADC_BATTERY_MASK		0xfff
> +
> +#define JZ_ADC_ADCIN_MASK		0xfff
> +
> +struct jz4740_adc {
> +	struct resource *mem;
> +	void __iomem *base;
> +
> +	int irq;
> +
> +	struct clk *clk;
> +	unsigned int clk_ref;
> +
> +	struct device *hwmon;
> +
> +	struct completion bat_completion;
> +	struct completion adc_completion;
> +
> +	spinlock_t lock;
> +};
> +
> +static irqreturn_t jz4740_adc_irq(int irq, void *data)
> +{
> +	struct jz4740_adc *adc = data;
> +	uint8_t status;
> +
> +	status = readb(adc->base + JZ_REG_ADC_STATUS);
> +
> +	if (status & JZ_ADC_IRQ_BATTERY)
> +		complete(&adc->bat_completion);
> +	if (status & JZ_ADC_IRQ_ADCIN)
> +		complete(&adc->adc_completion);
> +
> +	writeb(0xff, adc->base + JZ_REG_ADC_STATUS);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void jz4740_adc_enable_irq(struct jz4740_adc *adc, int irq)
> +{
> +	unsigned long flags;
> +	uint8_t val;
> +
> +	spin_lock_irqsave(&adc->lock, flags);
> +
> +	val = readb(adc->base + JZ_REG_ADC_CTRL);
> +	val &= ~irq;
> +	writeb(val, adc->base + JZ_REG_ADC_CTRL);
> +
> +	spin_unlock_irqrestore(&adc->lock, flags);
> +}
> +
> +static void jz4740_adc_disable_irq(struct jz4740_adc *adc, int irq)
> +{
> +	unsigned long flags;
> +	uint8_t val;
> +
> +	spin_lock_irqsave(&adc->lock, flags);
> +
> +	val = readb(adc->base + JZ_REG_ADC_CTRL);
> +	val |= irq;
> +	writeb(val, adc->base + JZ_REG_ADC_CTRL);
> +
> +	spin_unlock_irqrestore(&adc->lock, flags);
> +}
You could unify the two functions above with a simple parameter.  They share
almost all their code.


> +
> +static void jz4740_adc_enable_adc(struct jz4740_adc *adc, int engine)
> +{
> +	unsigned long flags;
> +	uint8_t val;
> +
> +	spin_lock_irqsave(&adc->lock, flags);
> +
> +	val = readb(adc->base + JZ_REG_ADC_ENABLE);
> +	val |= engine;
> +	writeb(val, adc->base + JZ_REG_ADC_ENABLE);
> +
> +	spin_unlock_irqrestore(&adc->lock, flags);
> +}
> +
> +static void jz4740_adc_disable_adc(struct jz4740_adc *adc, int engine)
> +{
> +	unsigned long flags;
> +	uint8_t val;
> +
> +	spin_lock_irqsave(&adc->lock, flags);
> +
> +	val = readb(adc->base + JZ_REG_ADC_ENABLE);
> +	val &= ~engine;
> +	writeb(val, adc->base + JZ_REG_ADC_ENABLE);
> +
> +	spin_unlock_irqrestore(&adc->lock, flags);
> +}
The two above could be unified as well.

> +
> +static inline void jz4740_adc_set_cfg(struct jz4740_adc *adc, uint32_t mask,
> +uint32_t val)
Not sure, but the formatting of this line looks a bit odd..


> +{
> +	unsigned long flags;
> +	uint32_t cfg;
> +
> +	spin_lock_irqsave(&adc->lock, flags);
> +
> +	cfg = readl(adc->base + JZ_REG_ADC_CFG);
> +
> +	cfg &= ~mask;
> +	cfg |= val;
> +
> +	writel(cfg, adc->base + JZ_REG_ADC_CFG);
> +
> +	spin_unlock_irqrestore(&adc->lock, flags);
> +}
> +
> +static inline void jz4740_adc_clk_enable(struct jz4740_adc *adc)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&adc->lock, flags);
> +	if (adc->clk_ref++ == 0)
> +		clk_enable(adc->clk);
> +	spin_unlock_irqrestore(&adc->lock, flags);
> +}
> +
> +static inline void jz4740_adc_clk_disable(struct jz4740_adc *adc)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&adc->lock, flags);
> +	if (--adc->clk_ref == 0)
> +		clk_disable(adc->clk);
> +	spin_unlock_irqrestore(&adc->lock, flags);
> +}
> +

For example of mfd reasoning, nothing in this driver cares about this functionality.
To my mind it should be in the battery driver and the exports should be the
higher level functions.

Having this sort of access control in a hwmon driver seems like an unusual
approach.
> +long jz4740_adc_read_battery_voltage(struct device *dev,
> +						enum jz_adc_battery_scale scale)
> +{
> +	struct jz4740_adc *adc = dev_get_drvdata(dev);
> +	unsigned long t;
> +	long long voltage;
> +	uint16_t val;
> +
> +	if (!adc)
> +		return -ENODEV;
> +
> +	jz4740_adc_clk_enable(adc);
> +
> +	if (scale == JZ_ADC_BATTERY_SCALE_2V5)
> +		jz4740_adc_set_cfg(adc, JZ_ADC_CFG_BAT_MB, JZ_ADC_CFG_BAT_MB);
> +	else
> +		jz4740_adc_set_cfg(adc, JZ_ADC_CFG_BAT_MB, 0);
> +

> +	jz4740_adc_enable_irq(adc, JZ_ADC_IRQ_BATTERY);
> +	jz4740_adc_enable_adc(adc, JZ_ADC_ENABLE_BATTERY);
> +
> +	t = wait_for_completion_interruptible_timeout(&adc->bat_completion,
> +							HZ);
> +
> +	jz4740_adc_disable_irq(adc, JZ_ADC_IRQ_BATTERY);
> +
> +	if (t <= 0) {
> +		jz4740_adc_disable_adc(adc, JZ_ADC_ENABLE_BATTERY);
> +		return t ? t : -ETIMEDOUT;
> +	}
> +
> +	val = readw(adc->base + JZ_REG_ADC_BATTERY);
> +
> +	jz4740_adc_clk_disable(adc);
> +
> +	if (scale == JZ_ADC_BATTERY_SCALE_2V5)
> +		voltage = (((long long)val) * 2500000LL) >> 12LL;
> +	else
> +		voltage = ((((long long)val) * 7395000LL) >> 12LL) + 33000LL;
> +
> +	return voltage;
> +}
> +EXPORT_SYMBOL_GPL(jz4740_adc_read_battery_voltage);
> +
> +static ssize_t jz4740_adc_read_adcin(struct device *dev,
> +					struct device_attribute *dev_attr,
> +					char *buf)
> +{
> +	struct jz4740_adc *adc = dev_get_drvdata(dev);
> +	unsigned long t;
> +	uint16_t val;
> +
> +	jz4740_adc_clk_enable(adc);
> +
Is there a possible race here?
> +	jz4740_adc_enable_irq(adc, JZ_ADC_IRQ_ADCIN);
> +	jz4740_adc_enable_adc(adc, JZ_ADC_ENABLE_ADCIN);
> +
> +	t = wait_for_completion_interruptible_timeout(&adc->adc_completion,
> +							HZ);
> +
> +	jz4740_adc_disable_irq(adc, JZ_ADC_IRQ_ADCIN);
> +
> +	if (t <= 0) {
> +		jz4740_adc_disable_adc(adc, JZ_ADC_ENABLE_ADCIN);
> +		return t ? t : -ETIMEDOUT;
> +	}
> +
> +	val = readw(adc->base + JZ_REG_ADC_ADCIN);
> +	jz4740_adc_clk_disable(adc);
> +
Does this device really use units of milivolts? (standard in hwmon).
I couldn't confirm either way via quick googling.
> +	return sprintf(buf, "%d\n", val);
> +}
> +
> +static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, jz4740_adc_read_adcin, NULL, 0);
> +
> +static int __devinit jz4740_adc_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct jz4740_adc *adc;
> +
> +	adc = kmalloc(sizeof(*adc), GFP_KERNEL);
> +
> +	adc->irq = platform_get_irq(pdev, 0);
> +
> +	if (adc->irq < 0) {
> +		ret = adc->irq;
> +		dev_err(&pdev->dev, "Failed to get platform irq: %d\n", ret);
> +		goto err_free;
> +	}
> +
> +	adc->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +	if (!adc->mem) {
> +		ret = -ENOENT;
> +		dev_err(&pdev->dev, "Failed to get platform mmio resource\n");
> +		goto err_free;
> +	}
> +
> +	adc->mem = request_mem_region(adc->mem->start, resource_size(adc->mem),
> +					pdev->name);
> +
> +	if (!adc->mem) {
> +		ret = -EBUSY;
> +		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
> +		goto err_free;
> +	}
> +
> +	adc->base = ioremap_nocache(adc->mem->start, resource_size(adc->mem));
> +
> +	if (!adc->base) {
> +		ret = -EBUSY;
> +		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
> +		goto err_release_mem_region;
> +	}
> +
> +	adc->clk = clk_get(&pdev->dev, "adc");
> +
> +	if (IS_ERR(adc->clk)) {
> +		ret = PTR_ERR(adc->clk);
> +		dev_err(&pdev->dev, "Failed to get clock: %d\n", ret);
> +		goto err_iounmap;
> +	}
> +
> +	init_completion(&adc->bat_completion);
> +	init_completion(&adc->adc_completion);
> +
> +	spin_lock_init(&adc->lock);
> +
> +	adc->clk_ref = 0;
> +
> +	platform_set_drvdata(pdev, adc);
> +
> +	ret = request_irq(adc->irq, jz4740_adc_irq, 0, pdev->name, adc);
> +
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to request irq: %d\n", ret);
> +		goto err_clk_put;
> +	}
> +
> +	ret = device_create_file(&pdev->dev, &sensor_dev_attr_in0_input.dev_attr);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to create sysfs file: %d\n", ret);
> +		goto err_free_irq;
> +	}
> +
> +	adc->hwmon = hwmon_device_register(&pdev->dev);
> +	if (IS_ERR(adc->hwmon)) {
> +		ret = PTR_ERR(adc->hwmon);
> +		goto err_remove_file;
> +	}
> +
> +	writeb(0x00, adc->base + JZ_REG_ADC_ENABLE);
> +	writeb(0xff, adc->base + JZ_REG_ADC_CTRL);
> +
> +	return 0;
> +
> +err_remove_file:
> +	device_remove_file(&pdev->dev, &sensor_dev_attr_in0_input.dev_attr);
> +err_free_irq:
> +	free_irq(adc->irq, adc);
> +err_clk_put:
> +	clk_put(adc->clk);
> +err_iounmap:
> +	platform_set_drvdata(pdev, NULL);
> +	iounmap(adc->base);
> +err_release_mem_region:
> +	release_mem_region(adc->mem->start, resource_size(adc->mem));
> +err_free:
> +	kfree(adc);
> +
> +	return ret;
> +}
> +
> +static int __devexit jz4740_adc_remove(struct platform_device *pdev)
> +{
> +	struct jz4740_adc *adc = platform_get_drvdata(pdev);
> +
> +	hwmon_device_unregister(adc->hwmon);
> +	device_remove_file(&pdev->dev, &sensor_dev_attr_in0_input.dev_attr);
> +
> +	free_irq(adc->irq, adc);
> +
> +	iounmap(adc->base);
> +	release_mem_region(adc->mem->start, resource_size(adc->mem));
> +
> +	clk_put(adc->clk);
> +
> +	platform_set_drvdata(pdev, NULL);
> +
> +	kfree(adc);
> +
> +	return 0;
> +}
> +
> +struct platform_driver jz4740_adc_driver = {
> +	.probe	= jz4740_adc_probe,
> +	.remove = __devexit_p(jz4740_adc_remove),
> +	.driver = {
> +		.name = "jz4740-adc",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +static int __init jz4740_adc_init(void)
> +{
> +	return platform_driver_register(&jz4740_adc_driver);
> +}
> +module_init(jz4740_adc_init);
> +
> +static void __exit jz4740_adc_exit(void)
> +{
> +	platform_driver_unregister(&jz4740_adc_driver);
> +}
> +module_exit(jz4740_adc_exit);
> +
> +MODULE_DESCRIPTION("JZ4740 SoC ADC driver");
> +MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:jz4740-adc");
> diff --git a/include/linux/jz4740-adc.h b/include/linux/jz4740-adc.h
> new file mode 100644
> index 0000000..59cfe63
> --- /dev/null
> +++ b/include/linux/jz4740-adc.h
> @@ -0,0 +1,25 @@
> +
> +#ifndef __LINUX_JZ4740_ADC
> +#define __LINUX_JZ4740_ADC
> +
> +#include <linux/device.h>
> +
> +enum jz_adc_battery_scale {
> +	JZ_ADC_BATTERY_SCALE_2V5, /* Mesures voltages up to 2.5V */
> +	JZ_ADC_BATTERY_SCALE_7V5, /* Mesures voltages up to 7.5V */
> +};
> +
> +/*
> + * jz4740_adc_read_battery_voltage - Read battery voltage from the ADC PBAT pin
> + * @dev: Pointer to a jz4740-adc device
> + * @scale: Whether to use 2.5V or 7.5V scale
> + *
> + * Returns: Battery voltage in mircovolts
> + *
> + * Context: Process
> +*/
> +long jz4740_adc_read_battery_voltage(struct device *dev,
> +					enum jz_adc_battery_scale scale);
> +
> +
> +#endif

