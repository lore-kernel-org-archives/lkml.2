Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab1EYJ2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:28:53 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:36356 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1EYJ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:28:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DDCCC82.90604@cam.ac.uk>
Date: Wed, 25 May 2011 10:31:46 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Anatolij Gustschin <agust@denx.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, dzu@denx.de
Subject: Re: [PATCH 1/2] misc/eeprom: add driver for 93xx46 EEPROMs over GPIO
References: <1306252963-20746-1-git-send-email-agust@denx.de>
In-Reply-To: <1306252963-20746-1-git-send-email-agust@denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/11 17:02, Anatolij Gustschin wrote:
> 93xx46 EEPROMs can be connected using GPIO lines. Add a generic
> 93xx46 EEPROM driver using common GPIO API for such configurations.
> A platform is supposed to register appropriate 93xx46 gpio device
> providing GPIO interface description and using this driver
> read/write/erase access to the EEPROM chip can be easily done
> over sysfs files.
Could you explain why this makes more sense than an spi driver and
use of spi_gpio ?

It's microwire compatible according to random google provided datasheet,
which iirc is a particular form of spi (half duplex, spi mode 0 according
to wikipedia)

That would give us a more generally useful driver.
> 
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> ---
>  drivers/misc/eeprom/Kconfig       |   10 +
>  drivers/misc/eeprom/Makefile      |    1 +
>  drivers/misc/eeprom/gpio-93xx46.c |  525 +++++++++++++++++++++++++++++++++++++
>  include/linux/gpio-93xx46.h       |   19 ++
>  4 files changed, 555 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/eeprom/gpio-93xx46.c
>  create mode 100644 include/linux/gpio-93xx46.h
> 
> diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
> index 9118613..fcceffd 100644
> --- a/drivers/misc/eeprom/Kconfig
> +++ b/drivers/misc/eeprom/Kconfig
> @@ -70,4 +70,14 @@ config EEPROM_93CX6
>  
>  	  If unsure, say N.
>  
> +config EEPROM_GPIO_93XX46
> +	tristate "EEPROM 93XX46 over GPIO support"
> +	depends on GPIOLIB && SYSFS
> +	help
> +	  Driver for the EEPROM chipsets 93xx46x connected with GPIO.
> +	  The driver supports both read and write commands and also
> +	  the command to erase the whole EEPROM.
> +
> +	  If unsure, say N.
> +
>  endmenu
> diff --git a/drivers/misc/eeprom/Makefile b/drivers/misc/eeprom/Makefile
> index df3d68f..38d8259 100644
> --- a/drivers/misc/eeprom/Makefile
> +++ b/drivers/misc/eeprom/Makefile
> @@ -3,3 +3,4 @@ obj-$(CONFIG_EEPROM_AT25)	+= at25.o
>  obj-$(CONFIG_EEPROM_LEGACY)	+= eeprom.o
>  obj-$(CONFIG_EEPROM_MAX6875)	+= max6875.o
>  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
> +obj-$(CONFIG_EEPROM_GPIO_93XX46) += gpio-93xx46.o
> diff --git a/drivers/misc/eeprom/gpio-93xx46.c b/drivers/misc/eeprom/gpio-93xx46.c
> new file mode 100644
> index 0000000..5c7d7dd
> --- /dev/null
> +++ b/drivers/misc/eeprom/gpio-93xx46.c
> @@ -0,0 +1,525 @@
> +/*
> + * Driver for 93xx46 EEPROMs over GPIO lines.
> + *
> + * (C) 2011 DENX Software Engineering, Anatolij Gustschin <agust@denx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/fs.h>
> +#include <linux/gpio.h>
> +#include <linux/gpio-93xx46.h>
> +#include <linux/delay.h>
> +#include <linux/mutex.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/sysctl.h>
> +
> +#define OP_START	0x4
> +#define OP_WRITE	(OP_START | 0x1)
> +#define OP_READ		(OP_START | 0x2)
> +#define OP_ERASE	(OP_START | 0x3)
> +#define OP_EWEN		(OP_START | 0x0)
> +#define OP_EWDS		(OP_START | 0x0)
> +#define ADDR_EWDS	0x00
> +#define ADDR_ERAL	0x20
> +#define ADDR_EWEN	0x30
> +#define DELAY		450
> +
> +struct gpio_93xx46_dev {
> +	struct device *dev;
> +	struct gpio_93xx46_platform_data *pdata;
> +	struct bin_attribute bin;
> +	int addrlen;
> +
> +	struct gpio pins[4];
> +};
> +
> +static DEFINE_MUTEX(gpio_93xx46_mutex);
> +
> +static int gpio_93xx46_request_gpios(struct gpio_93xx46_dev *edev)
> +{
> +	struct gpio_93xx46_platform_data *pd = edev->pdata;
> +	const char *name =  to_platform_device(edev->dev)->name;
> +	int ret;
> +
> +	edev->pins[0].gpio = pd->clk;
> +	edev->pins[0].flags = GPIOF_OUT_INIT_LOW;
> +	edev->pins[0].label = name;
> +	edev->pins[1].gpio = pd->cs;
> +	edev->pins[1].flags = GPIOF_OUT_INIT_LOW;
> +	edev->pins[1].label = name;
> +	edev->pins[2].gpio = pd->din;
> +	edev->pins[2].flags = GPIOF_OUT_INIT_LOW;
> +	edev->pins[2].label = name;
> +	edev->pins[3].gpio = pd->dout;
> +	edev->pins[3].flags = GPIOF_IN;
> +	edev->pins[3].label = name;
> +
> +	ret = gpio_request_array(edev->pins, ARRAY_SIZE(edev->pins));
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static void gpio_93xx46_tx_bit(struct gpio_93xx46_dev *edev, bool bit)
> +{
> +	struct gpio_93xx46_platform_data *pd = edev->pdata;
> +
> +	if (bit)
> +		gpio_set_value(pd->din, 1);
> +	else
> +		gpio_set_value(pd->din, 0);
> +
> +	ndelay(DELAY);
> +	gpio_set_value(pd->clk, 1);
> +	ndelay(DELAY);
> +	gpio_set_value(pd->clk, 0);
> +}
> +
> +static inline unsigned char
> +gpio_93xx46_rx_byte(struct gpio_93xx46_platform_data *pd)
> +{
> +	int data = 0, i;
> +
> +	for (i = 0; i < 8 ; i++) {
> +		gpio_set_value(pd->clk, 1);
> +		ndelay(DELAY);
> +		gpio_set_value(pd->clk, 0);
> +
> +		if (gpio_get_value(pd->dout))
> +			data |= 1;
> +		data <<= 1;
> +		ndelay(DELAY);
> +	}
> +	return data >>= 1;
> +}
> +
> +static void gpio_93xx46_read(struct gpio_93xx46_dev *edev,
> +			     char *buf, unsigned offs, size_t cnt)
> +{
> +	struct gpio_93xx46_platform_data *pd = edev->pdata;
> +	int active = !(pd->flags & EE_CS_LOW);
> +	int cmd_addr, len, mask;
> +	int i;
> +
> +	cmd_addr = (OP_READ << edev->addrlen);
> +	if (edev->addrlen == 7) {
> +		cmd_addr |= (offs & 0x7f);
> +		len = 10;
> +	} else {
> +		cmd_addr |= (offs & 0x3f);
> +		len = 9;
> +	}
> +	mask = 1 << (len - 1);
> +
> +	mutex_lock(&gpio_93xx46_mutex);
> +
> +	gpio_set_value(pd->cs, !active);
> +	gpio_set_value(pd->clk, 0);
> +	gpio_set_value(pd->din, 1);
> +	ndelay(DELAY);
> +
> +	if (pd->prepare)
> +		pd->prepare(edev);
> +
> +	gpio_set_value(pd->cs, active);
> +	ndelay(DELAY);
> +
> +	for (i = 0; i < len; i++, mask >>= 1)
> +		gpio_93xx46_tx_bit(edev, !!(cmd_addr & mask));
> +
> +	ndelay(DELAY);
> +
> +	for (i = 0; i < cnt; i++)
> +		buf[i] = gpio_93xx46_rx_byte(pd);
> +
> +	gpio_set_value(pd->clk, 0);
> +	gpio_set_value(pd->din, 0);
> +	gpio_set_value(pd->cs, !active);
> +	ndelay(DELAY);
> +
> +	if (pd->finish)
> +		pd->finish(edev);
> +
> +	mutex_unlock(&gpio_93xx46_mutex);
> +}
> +
> +static void gpio_93xx46_ewen(struct gpio_93xx46_dev *edev)
> +{
> +	struct gpio_93xx46_platform_data *pd = edev->pdata;
> +	int active = !(pd->flags & EE_CS_LOW);
> +	int cmd_addr, len, mask;
> +	int i;
> +
> +	cmd_addr = OP_EWEN << edev->addrlen;
> +	if (edev->addrlen == 7) {
> +		cmd_addr |= ADDR_EWEN << 1;
> +		len = 10;
> +	} else {
> +		cmd_addr |= ADDR_EWEN;
> +		len = 9;
> +	}
> +	mask = 1 << (len - 1);
> +
> +	mutex_lock(&gpio_93xx46_mutex);
> +
> +	gpio_set_value(pd->cs, !active);
> +	gpio_set_value(pd->clk, 0);
> +	gpio_set_value(pd->din, 1);
> +	ndelay(DELAY);
> +
> +	if (pd->prepare)
> +		pd->prepare(edev);
> +
> +	gpio_set_value(pd->cs, active);
> +	ndelay(DELAY);
> +
> +	for (i = 0; i < len; i++, mask >>= 1)
> +		gpio_93xx46_tx_bit(edev, !!(cmd_addr & mask));
> +
> +	ndelay(DELAY);
> +
> +	gpio_set_value(pd->clk, 0);
> +	gpio_set_value(pd->din, 0);
> +	gpio_set_value(pd->cs, !active);
> +	ndelay(DELAY);
> +
> +	if (pd->finish)
> +		pd->finish(edev);
> +
> +	mutex_unlock(&gpio_93xx46_mutex);
> +}
> +
> +static void gpio_93xx46_ewds(struct gpio_93xx46_dev *edev)
> +{
> +	struct gpio_93xx46_platform_data *pd = edev->pdata;
> +	int active = !(pd->flags & EE_CS_LOW);
> +	int cmd_addr, len, mask;
> +	int i;
> +
> +	cmd_addr = OP_EWDS << edev->addrlen;
> +	if (edev->addrlen == 7) {
> +		cmd_addr |= ADDR_EWDS << 1;
> +		len = 10;
> +	} else {
> +		cmd_addr |= ADDR_EWDS;
> +		len = 9;
> +	}
> +	mask = 1 << (len - 1);
> +
> +	mutex_lock(&gpio_93xx46_mutex);
> +
> +	gpio_set_value(pd->cs, !active);
> +	gpio_set_value(pd->clk, 0);
> +	gpio_set_value(pd->din, 1);
> +	ndelay(DELAY);
> +
> +	if (pd->prepare)
> +		pd->prepare(edev);
> +
> +	gpio_set_value(pd->cs, active);
> +	ndelay(DELAY);
> +
> +	for (i = 0; i < len; i++, mask >>= 1)
> +		gpio_93xx46_tx_bit(edev, !!(cmd_addr & mask));
> +
> +	ndelay(DELAY);
> +
> +	gpio_set_value(pd->clk, 0);
> +	gpio_set_value(pd->din, 0);
> +	gpio_set_value(pd->cs, !active);
> +	ndelay(DELAY);
> +
> +	if (pd->finish)
> +		pd->finish(edev);
> +
> +	mutex_unlock(&gpio_93xx46_mutex);
> +}
> +
> +static void gpio_93xx46_eral(struct gpio_93xx46_dev *edev)
> +{
> +	struct gpio_93xx46_platform_data *pd = edev->pdata;
> +	int active = !(pd->flags & EE_CS_LOW);
> +	int cmd_addr, len, mask;
> +	int i, to = 10;
> +
> +	cmd_addr = OP_START << edev->addrlen;
> +	if (edev->addrlen == 7) {
> +		cmd_addr |= ADDR_ERAL << 1;
> +		len = 10;
> +	} else {
> +		cmd_addr |= ADDR_ERAL;
> +		len = 9;
> +	}
> +	mask = 1 << (len - 1);
> +
> +	mutex_lock(&gpio_93xx46_mutex);
> +
> +	gpio_set_value(pd->cs, !active);
> +	gpio_set_value(pd->clk, 0);
> +	gpio_set_value(pd->din, 1);
> +	ndelay(DELAY);
> +
> +	if (pd->prepare)
> +		pd->prepare(edev);
> +
> +	gpio_set_value(pd->cs, active);
> +	ndelay(DELAY);
> +
> +	for (i = 0; i < len; i++, mask >>= 1)
> +		gpio_93xx46_tx_bit(edev, !!(cmd_addr & mask));
> +
> +	gpio_set_value(pd->cs, !active);
> +	ndelay(DELAY);
> +	gpio_set_value(pd->cs, active);
> +	ndelay(DELAY);
> +
> +	while (!gpio_get_value(pd->dout)) {
> +		if (!to--) {
> +			dev_err(edev->dev, "erase not ready timeout\n");
> +			break;
> +		}
> +		mdelay(1);
> +	}
> +
> +	gpio_set_value(pd->clk, 0);
> +	gpio_set_value(pd->din, 0);
> +	gpio_set_value(pd->cs, !active);
> +	ndelay(DELAY);
> +
> +	if (pd->finish)
> +		pd->finish(edev);
> +
> +	mutex_unlock(&gpio_93xx46_mutex);
> +}
> +
> +static void gpio_93xx46_write(struct gpio_93xx46_dev *edev,
> +			      unsigned offs, char data)
> +{
> +	struct gpio_93xx46_platform_data *pd = edev->pdata;
> +	int active = !(pd->flags & EE_CS_LOW);
> +	int cmd_addr, len, mask;
> +	int i, to = 10;
> +
> +	cmd_addr = (OP_WRITE << edev->addrlen);
> +	if (edev->addrlen == 7) {
> +		cmd_addr |= (offs & 0x7f);
> +		len = 10;
> +	} else {
> +		cmd_addr |= (offs & 0x3f);
> +		len = 9;
> +	}
> +	mask = 1 << (len - 1);
> +
> +	mutex_lock(&gpio_93xx46_mutex);
> +
> +	gpio_set_value(pd->cs, !active);
> +	gpio_set_value(pd->clk, 0);
> +	gpio_set_value(pd->din, 1);
> +	ndelay(DELAY);
> +
> +	if (pd->prepare)
> +		pd->prepare(edev);
> +
> +	gpio_set_value(pd->cs, active);
> +	ndelay(DELAY);
> +
> +	for (i = 0; i < len; i++, mask >>= 1)
> +		gpio_93xx46_tx_bit(edev, !!(cmd_addr & mask));
> +
> +	ndelay(DELAY);
> +
> +	for (i = 0; i < 8; i++) {
> +		gpio_93xx46_tx_bit(edev, !!(data & 0x80));
> +		data <<= 1;
> +	}
> +
> +	gpio_set_value(pd->cs, !active);
> +	ndelay(DELAY);
> +	gpio_set_value(pd->cs, active);
> +	ndelay(DELAY);
> +
> +	while (!gpio_get_value(pd->dout)) {
> +		if (!to--) {
> +			dev_err(edev->dev, "write not ready timeout\n");
> +			break;
> +		}
> +		mdelay(1);
> +	}
> +
> +	gpio_set_value(pd->clk, 0);
> +	gpio_set_value(pd->din, 0);
> +	gpio_set_value(pd->cs, !active);
> +	ndelay(DELAY);
> +
> +	if (pd->finish)
> +		pd->finish(edev);
> +
> +	mutex_unlock(&gpio_93xx46_mutex);
> +}
> +
> +static ssize_t
> +gpio_93xx46_bin_read(struct file *filp, struct kobject *kobj,
> +		     struct bin_attribute *bin_attr,
> +		     char *buf, loff_t off, size_t count)
> +{
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct gpio_93xx46_dev *edev = dev_get_drvdata(dev);
> +
> +	if (unlikely(!count))
> +		return count;
> +	if (unlikely(off >= edev->bin.size))
> +		return 0;
> +	if ((off + count) > edev->bin.size)
> +		count = edev->bin.size - off;
> +
> +	gpio_93xx46_read(edev, buf, off, count);
> +	return count;
> +}
> +
> +static ssize_t
> +gpio_93xx46_bin_write(struct file *filp, struct kobject *kobj,
> +		      struct bin_attribute *bin_attr,
> +		      char *buf, loff_t off, size_t count)
> +{
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct gpio_93xx46_dev *edev = dev_get_drvdata(dev);
> +	int i;
> +
> +	if (unlikely(!count))
> +		return count;
> +	if (unlikely(off >= edev->bin.size))
> +		return 0;
> +	if ((off + count) > edev->bin.size)
> +		count = edev->bin.size - off;
> +
> +	gpio_93xx46_ewen(edev);
> +
> +	for (i = 0; i < count; i++)
> +		gpio_93xx46_write(edev, off + i, buf[i]);
> +
> +	gpio_93xx46_ewds(edev);
> +
> +	return count;
> +}
> +
> +ssize_t gpio_93xx46_store_erase(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	struct gpio_93xx46_dev *edev = dev_get_drvdata(dev);
> +	int erase = 0;
> +
> +	sscanf(buf, "%d", &erase);
> +	if (erase) {
> +		gpio_93xx46_ewen(edev);
> +		gpio_93xx46_eral(edev);
> +		gpio_93xx46_ewds(edev);
> +	}
> +
> +	return count;
> +}
> +static DEVICE_ATTR(erase, S_IWUSR, NULL, gpio_93xx46_store_erase);
> +
> +static int __devinit gpio_93xx46_probe(struct platform_device *pdev)
> +{
> +	struct gpio_93xx46_platform_data *pd = pdev->dev.platform_data;
> +	struct gpio_93xx46_dev *edev = NULL;
> +	int err;
> +
> +	if (!pd)
> +		return -ENODEV;
> +
> +	edev = kzalloc(sizeof(*edev), GFP_KERNEL);
> +	if (!edev)
> +		return -ENOMEM;
> +
> +	edev->dev = &pdev->dev;
> +	edev->pdata = pd;
> +	if (pd->flags & EE_ADDR8)
> +		edev->addrlen = 7;
> +	else if (pd->flags & EE_ADDR16)
> +		edev->addrlen = 6;
> +	else {
> +		dev_err(&pdev->dev,
> +			"invalid address flags 0x%x\n", pd->flags);
> +		err = -EINVAL;
> +		goto fail;
> +	}
> +
> +	err = gpio_93xx46_request_gpios(edev);
> +	if (err)
> +		goto fail;
> +
> +	sysfs_bin_attr_init(&edev->bin);
> +	edev->bin.attr.name = "eeprom";
> +	edev->bin.attr.mode = S_IRUSR;
> +	edev->bin.read = gpio_93xx46_bin_read;
> +	edev->bin.size = 128;
> +	if (!(pd->flags & EE_READONLY)) {
> +		edev->bin.write = gpio_93xx46_bin_write;
> +		edev->bin.attr.mode |= S_IWUSR;
> +	}
> +
> +	err = sysfs_create_bin_file(&pdev->dev.kobj, &edev->bin);
> +	if (err)
> +		goto fail;
> +
> +	if (!(pd->flags & EE_READONLY)) {
> +		if (device_create_file(&pdev->dev, &dev_attr_erase))
> +			dev_err(&pdev->dev, "can't create erase interface\n");
> +	}
> +
> +	platform_set_drvdata(pdev, edev);
> +
> +	return 0;
> +fail:
> +	kfree(edev);
> +	return err;
> +}
> +
> +static int __devexit gpio_93xx46_remove(struct platform_device *pdev)
> +{
> +	struct gpio_93xx46_platform_data *pd = pdev->dev.platform_data;
> +	struct gpio_93xx46_dev *edev = platform_get_drvdata(pdev);
> +
> +	if (!(pd->flags & EE_READONLY))
> +		device_remove_file(&pdev->dev, &dev_attr_erase);
> +	sysfs_remove_bin_file(&pdev->dev.kobj, &edev->bin);
> +	gpio_free_array(edev->pins, ARRAY_SIZE(edev->pins));
> +	platform_set_drvdata(pdev, NULL);
> +	kfree(edev);
> +	return 0;
> +}
> +
> +static struct platform_driver gpio_93xx46_driver = {
> +	.probe		= gpio_93xx46_probe,
> +	.remove		= __devexit_p(gpio_93xx46_remove),
> +	.driver		= {
> +		.name	= "gpio-93xx46",
> +		.owner	= THIS_MODULE,
> +	}
> +};
> +
> +static int __init gpio_93xx46_init(void)
> +{
> +	return platform_driver_register(&gpio_93xx46_driver);
> +}
> +module_init(gpio_93xx46_init);
> +
> +static void __exit gpio_93xx46_exit(void)
> +{
> +	platform_driver_unregister(&gpio_93xx46_driver);
> +}
> +module_exit(gpio_93xx46_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Driver for 93xx46 EEPROMs over GPIO");
> +MODULE_AUTHOR("Anatolij Gustschin <agust@denx.de>");
> +MODULE_ALIAS("platform:gpio-93xx46");
> diff --git a/include/linux/gpio-93xx46.h b/include/linux/gpio-93xx46.h
> new file mode 100644
> index 0000000..a565de6
> --- /dev/null
> +++ b/include/linux/gpio-93xx46.h
> @@ -0,0 +1,19 @@
> +/*
> + * Module: gpio-93xx46
> + * Interface description for 93xx46 EEPROMs connected over GPIO.
> + */
> +struct gpio_93xx46_platform_data {
> +	unsigned	clk;
> +	unsigned	cs;
> +	unsigned	din;
> +	unsigned	dout;
> +
> +	u8		flags;
> +#define EE_ADDR8	0x01		/*  8 bit addr. cfg */
> +#define EE_ADDR16	0x02		/* 16 bit addr. cfg */
> +#define EE_READONLY	0x08		/* forbid writing */
> +#define EE_CS_LOW	0x10		/* CS is active low */
> +
> +	void (*prepare)(void *);
> +	void (*finish)(void *);
> +};

