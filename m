Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab0KIPBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:01:55 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:49096 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab0KIPBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:01:54 -0500
Message-ID: <0d1a323315dcf505e64fb5165ea41e95.squirrel@webmail.greenhost.nl>
In-Reply-To: <f04cbe31c7e03a9d798b30526a5fed1cd8ee4c7a.1289297142.git.baruch@tkos.c
     o.il>
References: <f04cbe31c7e03a9d798b30526a5fed1cd8ee4c7a.1289297142.git.baruch@tkos.co.il>
Date: Tue, 9 Nov 2010 16:01:51 +0100 (CET)
Subject: Re: [PATCHv2] drivers/misc: Altera Cyclone active serial 
     implementation
From: "Indan Zupancic" <indan@nul.nu>
To: "Baruch Siach" <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>,
        "Baruch Siach" <baruch@tkos.co.il>,
        "Alex Gershgorin" <agersh@rambler.ru>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 0cf14f8480d580d3e3eafcfe68ba1008
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Looks a lot better now!

On Tue, November 9, 2010 11:06, Baruch Siach wrote:
> The active serial protocol can be used to program Altera Cyclone FPGA devices.
> This driver uses the kernel gpio interface to implement the active serial
> protocol.
>
> Signed-off-by: Alex Gershgorin <agersh@rambler.ru>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
> Changes in v2:
>
>     * Don't create a new class, use the misc class instead
>
>     * Depend on GENERIC_GPIO
>
>     * Simplify xmit_byte(), use bitrev8() to flip data bytes
>
>     * Add xmit_cmd() to simplify send of simple commands
>
>     * Remove unnecessary debug prints
>
>     * Check msleep_interruptible() return value
>
>     * Remove unneeded ndelay() calls
>
>     * Poll the write-in-progress indicator instead of waiting for a fixed (and
>       too short) period of time after erase.
>
>  drivers/misc/Kconfig                  |   11 +
>  drivers/misc/Makefile                 |    1 +
>  drivers/misc/cyclone_as.c             |  343
> +++++++++++++++++++++++++++++++++
>  include/platform_drivers/cyclone_as.h |   27 +++
>  4 files changed, 382 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/cyclone_as.c
>  create mode 100644 include/platform_drivers/cyclone_as.h
>
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 4d073f1..70534bf 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -452,6 +452,17 @@ config PCH_PHUB
>  	  To compile this driver as a module, choose M here: the module will
>  	  be called pch_phub.
>
> +config CYCLONE_AS
> +	depends on GENERIC_GPIO
> +	tristate "Altera Cyclone Active Serial driver"
> +	help
> +	  Provides support for active serial programming of Altera Cyclone
> +	  devices. For the active serial protocol details see the Altera
> +	  "Serial Configuration Devices" document (C51014).
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called cyclone_as.
> +

Looking at cyc_c51014.pdf this protocol is used to program some Altera
"Serial Configuration Devices", which are more or less flash chips that
program the FPGA at start-up (notably EPCS* devices). Perhaps that could
be made more clear. According to the document it's not only for Cyclone
FPGA's, but also the Arria and Stratix and FPGA's using the Active Serial
configuration scheme.

>  source "drivers/misc/c2port/Kconfig"
>  source "drivers/misc/eeprom/Kconfig"
>  source "drivers/misc/cb710/Kconfig"
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 98009cc..58c6548 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -42,3 +42,4 @@ obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
>  obj-$(CONFIG_PCH_PHUB)		+= pch_phub.o
>  obj-y				+= ti-st/
>  obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
> +obj-$(CONFIG_CYCLONE_AS)	+= cyclone_as.o
> diff --git a/drivers/misc/cyclone_as.c b/drivers/misc/cyclone_as.c
> new file mode 100644
> index 0000000..cdae2a7
> --- /dev/null
> +++ b/drivers/misc/cyclone_as.c
> @@ -0,0 +1,343 @@
> +/*
> + * Copyright 2010 Alex Gershgorin, Orex Computed Radiography
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
> + */

GPLv2 is included with the kernel source, no need to give external links.

> +
> +#include <linux/fs.h>
> +#include <linux/err.h>
> +#include <linux/gpio.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/delay.h>
> +#include <linux/bitrev.h>
> +#include <linux/device.h>
> +#include <linux/uaccess.h>
> +#include <linux/miscdevice.h>
> +#include <linux/platform_device.h>
> +
> +#include <platform_drivers/cyclone_as.h>
> +
> +/* Active Serial Instruction Set */
> +#define AS_WRITE_ENABLE		0x06
> +#define AS_WRITE_DISABLE	0x04
> +#define AS_READ_STATUS		0x05
> +#define AS_WRITE_STATUS		0x01
> +#define AS_READ_BYTES		0x03
> +#define AS_FAST_READ_BYTES	0x0B
> +#define AS_PAGE_PROGRAM		0x02
> +#define AS_ERASE_SECTOR		0xD8
> +#define AS_ERASE_BULK		0xC7
> +#define AS_READ_SILICON_ID	0xAB
> +#define AS_CHECK_SILICON_ID	0x9F
> +
> +#define AS_STATUS_WIP		(1 << 0)
> +#define AS_STATUS_WEL		(1 << 1)
> +#define AS_STATUS_BP0		(1 << 2)
> +#define AS_STATUS_BP1		(1 << 3)
> +#define AS_STATUS_BP2		(1 << 4)
> +
> +#define AS_ERASE_TIMEOUT	250 /* seconds, max for EPCS128 */
> +
> +#define AS_PAGE_SIZE		256
> +
> +#define AS_MAX_DEVS		16
> +
> +#define ASIO_DATA		0
> +#define ASIO_ASDI		1
> +#define ASIO_NCONFIG		2

What is the function of this pin?

> +#define ASIO_DCLK		3
> +#define ASIO_NCS		4
> +#define ASIO_NCE		5

And NCE?

Neither is mentioned in the doc, nor are they really used.

> +#define AS_GPIO_NUM		6
> +
> +#define AS_ALIGNED(x)	IS_ALIGNED(x, AS_PAGE_SIZE)
> +
> +struct cyclone_as_device {
> +	unsigned id;
> +	struct device *dev;
> +	struct miscdevice miscdev;
> +	struct mutex open_lock;
> +	struct gpio gpios[AS_GPIO_NUM];

I wonder whether it would be nicer to have them as proper struct members
instead of an array.

> +};
> +
> +static struct {
> +	int minor;
> +	struct cyclone_as_device *drvdata;
> +} cyclone_as_devs[AS_MAX_DEVS];
> +
> +static struct cyclone_as_device *get_as_dev(int minor)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(cyclone_as_devs); i++)

To me AS_MAX_DEVS looks clearer than ARRAY_SIZE(cyclone_as_devs).

> +		if (cyclone_as_devs[i].minor == minor)
> +			return cyclone_as_devs[i].drvdata;
> +
> +	return NULL;
> +}
> +
> +static void as_clk_tick(struct gpio *gpios)
> +{
> +	gpio_set_value(gpios[ASIO_DCLK].gpio, 0);
> +	ndelay(40);
> +	gpio_set_value(gpios[ASIO_DCLK].gpio, 1);
> +	ndelay(20);

Shouldn't the first ndelay(40) be a ndelay(20) too? That way the total
is 40 and you get a 25MHz clock.

> +}
> +
> +static void xmit_byte(struct gpio *gpios, u8 c)
> +{
> +	int i;
> +
> +	for (i = 0; i < 8; i++) {
> +		gpio_set_value(gpios[ASIO_ASDI].gpio, (c << i) & 0x80);
> +		as_clk_tick(gpios);
> +	}
> +}
> +
> +static void xmit_cmd(struct gpio *gpios, u8 cmd)
> +{
> +	gpio_set_value(gpios[ASIO_NCS].gpio, 0);
> +	xmit_byte(gpios, cmd);
> +	gpio_set_value(gpios[ASIO_NCS].gpio, 1);
> +	ndelay(300);

That ndelay looks redundant, just leave it away?

I can't find any requirement for it in the doc. Is it the 8 cycles
thing for NCS? If so, that seems to be handled automatically because
only whole bytes are sent at a time.

> +}
> +
> +static u8 recv_byte(struct gpio *gpios)
> +{
> +	int i;
> +	u8 val = 0;
> +
> +	for (i = 0; i < 8; i++) {
> +		as_clk_tick(gpios);
> +		val |= (!!gpio_get_value(gpios[ASIO_DATA].gpio) << (7 - i));

The !! is a bit redundant. If it changes the reslult, val is invalid anyway?

> +	}
> +
> +	return val;
> +}
> +
> +static int cyclone_as_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +	struct cyclone_as_device *drvdata = get_as_dev(iminor(inode));
> +
> +	if (drvdata == NULL)
> +		return -ENODEV;
> +	file->private_data = drvdata;
> +
> +	ret = mutex_trylock(&drvdata->open_lock);
> +	if (ret == 0)
> +		return -EBUSY;
> +
> +	ret = gpio_request_array(drvdata->gpios, ARRAY_SIZE(drvdata->gpios));

AS_GPIO_NUM?

> +	if (ret < 0) {
> +		mutex_unlock(&drvdata->open_lock);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static ssize_t cyclone_as_write(struct file *file, const char __user *buf,
> +		size_t count, loff_t *ppos)
> +{
> +	int	i, err = 0;
> +	u8	*page_buf;
> +	ssize_t written = 0;
> +	struct cyclone_as_device *drvdata = file->private_data;
> +	unsigned page_count;
> +
> +	if (count == 0)
> +		return 0;
> +
> +	/* writes must be page aligned */
> +	if (!AS_ALIGNED(*ppos) || !AS_ALIGNED(count))
> +		return -EINVAL;
> +	page_count = *ppos / AS_PAGE_SIZE;
> +
> +	page_buf = kmalloc(AS_PAGE_SIZE, GFP_KERNEL);
> +	if (page_buf == NULL)
> +		return -ENOMEM;
> +
> +	if (*ppos == 0) {
> +		u8 as_status;
> +
> +		xmit_cmd(drvdata->gpios, AS_WRITE_ENABLE);
> +		xmit_cmd(drvdata->gpios, AS_ERASE_BULK);
> +
> +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> +		xmit_byte(drvdata->gpios, AS_READ_STATUS);
> +		for (i = 0; i < AS_ERASE_TIMEOUT; i++) {
> +			as_status = recv_byte(drvdata->gpios);
> +			if ((as_status & AS_STATUS_WIP) == 0)
> +				break; /* erase done */
> +			if (msleep_interruptible(1000) > 0) {
> +				err = -EINTR;
> +				break;
> +			}
> +		}
> +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> +		if ((as_status & AS_STATUS_WIP) && err == 0)
> +			err = -EIO; /* erase timeout */
> +		if (err)
> +			goto out;
> +		ndelay(300);
> +	}

I'd move this into its own function, erase_device() or something.

(And drop the ndelay.)

> +
> +	while (count) {
> +		dev_dbg(drvdata->dev, "offset = 0x%p\n", buf+written);

If you tested this code and it works, then this dev_dbg() shouldn't be
needed anymore.

> +
> +		err = copy_from_user(page_buf, buf+written, AS_PAGE_SIZE);
> +		if (err < 0) {
> +			err = -EFAULT;
> +			goto out;
> +		}
> +
> +		*ppos += AS_PAGE_SIZE;
> +		count -= AS_PAGE_SIZE;
> +		written += AS_PAGE_SIZE;
> +
> +		xmit_cmd(drvdata->gpios, AS_WRITE_ENABLE);
> +
> +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> +		/* op code */
> +		xmit_byte(drvdata->gpios, AS_PAGE_PROGRAM);
> +		/* address */
> +		xmit_byte(drvdata->gpios, (page_count >> 8) & 0xff);
> +		xmit_byte(drvdata->gpios, page_count & 0xff);
> +		xmit_byte(drvdata->gpios, 0);
> +		/* page data (LSB first) */
> +		for (i = 0; i < AS_PAGE_SIZE; i++)
> +			xmit_byte(drvdata->gpios, bitrev8(page_buf[i]));
> +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> +		page_count++;
> +		mdelay(7);
> +	}
> +
> +out:
> +	kfree(page_buf);
> +	return err ?: written;

Maybe use one variable to combine err and written.

> +}
> +
> +static int cyclone_as_release(struct inode *inode, struct file *file)
> +{
> +	struct cyclone_as_device *drvdata = file->private_data;
> +	int i;
> +
> +	gpio_set_value(drvdata->gpios[ASIO_NCONFIG].gpio, 1);
> +	gpio_set_value(drvdata->gpios[ASIO_NCE].gpio, 0);
> +	gpio_set_value(drvdata->gpios[ASIO_DCLK].gpio, 0);
> +	ndelay(500);
> +
> +	for (i = 0; i < ARRAY_SIZE(drvdata->gpios); i++)
> +		gpio_direction_input(drvdata->gpios[i].gpio);
> +	gpio_free_array(drvdata->gpios, ARRAY_SIZE(drvdata->gpios));
> +	mutex_unlock(&drvdata->open_lock);
> +
> +	return 0;
> +}
> +
> +static const struct file_operations cyclone_as_fops = {
> +	.open		= cyclone_as_open,
> +	.write		= cyclone_as_write,
> +	.release	= cyclone_as_release,
> +};
> +
> +static int __init cyclone_as_probe(struct platform_device *pdev)
> +{
> +	struct cyclone_as_device *drvdata;
> +	struct cyclone_as_platform_data *pdata = pdev->dev.platform_data;
> +
> +	if (pdata->id >= AS_MAX_DEVS)
> +		return -ENODEV;
> +
> +	if (cyclone_as_devs[pdata->id].drvdata)
> +		return -EBUSY;
> +
> +	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
> +	if (!drvdata)
> +		return -ENOMEM;
> +
> +	drvdata->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, drvdata);
> +
> +	drvdata->miscdev.minor = MISC_DYNAMIC_MINOR;
> +	drvdata->miscdev.name = kasprintf(GFP_KERNEL, "cyclone_as%d",
> +			pdata->id);
> +	if (drvdata->miscdev.name == NULL)
> +		return -ENOMEM;
> +	drvdata->miscdev.fops = &cyclone_as_fops;
> +	if (misc_register(&drvdata->miscdev) < 0) {
> +		kfree(drvdata->miscdev.name);
> +		return -ENODEV;
> +	}
> +	cyclone_as_devs[pdata->id].minor = drvdata->miscdev.minor;
> +	cyclone_as_devs[pdata->id].drvdata = drvdata;
> +
> +	mutex_init(&drvdata->open_lock);
> +
> +	drvdata->id = pdata->id;
> +
> +	drvdata->gpios[ASIO_DATA].gpio		= pdata->data;
> +	drvdata->gpios[ASIO_DATA].flags		= GPIOF_IN;
> +	drvdata->gpios[ASIO_DATA].label		= "as_data";
> +	drvdata->gpios[ASIO_ASDI].gpio		= pdata->asdi;
> +	drvdata->gpios[ASIO_ASDI].flags		= GPIOF_OUT_INIT_LOW;
> +	drvdata->gpios[ASIO_ASDI].label		= "as_asdi";
> +	drvdata->gpios[ASIO_NCONFIG].gpio	= pdata->nconfig;
> +	drvdata->gpios[ASIO_NCONFIG].flags	= GPIOF_OUT_INIT_LOW;
> +	drvdata->gpios[ASIO_NCONFIG].label	= "as_nconfig";
> +	drvdata->gpios[ASIO_DCLK].gpio		= pdata->dclk;
> +	drvdata->gpios[ASIO_DCLK].flags		= GPIOF_OUT_INIT_LOW;
> +	drvdata->gpios[ASIO_DCLK].label		= "as_dclk";
> +	drvdata->gpios[ASIO_NCS].gpio		= pdata->ncs;
> +	drvdata->gpios[ASIO_NCS].flags		= GPIOF_OUT_INIT_HIGH;
> +	drvdata->gpios[ASIO_NCS].label		= "as_ncs";
> +	drvdata->gpios[ASIO_NCE].gpio		= pdata->nce;
> +	drvdata->gpios[ASIO_NCE].flags		= GPIOF_OUT_INIT_HIGH;
> +	drvdata->gpios[ASIO_NCE].label		= "as_nce";
> +
> +	dev_info(drvdata->dev, "Altera Cyclone Active Serial driver\n");
> +
> +	return 0;
> +}
> +
> +static int __devexit cyclone_as_remove(struct platform_device *pdev)
> +{
> +	struct cyclone_as_device *drvdata = platform_get_drvdata(pdev);
> +
> +	cyclone_as_devs[drvdata->id].drvdata = NULL;
> +	kfree(drvdata->miscdev.name);
> +
> +	return misc_deregister(&drvdata->miscdev);
> +}
> +
> +static struct platform_driver cyclone_as_driver = {
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = "cyclone_as",
> +	},
> +	.remove = __devexit_p(cyclone_as_remove),
> +};
> +
> +int __init cyclone_as_init(void)
> +{
> +	return platform_driver_probe(&cyclone_as_driver, cyclone_as_probe);
> +}
> +
> +void __exit cyclone_as_cleanup(void)
> +{
> +	platform_driver_unregister(&cyclone_as_driver);
> +}
> +
> +module_init(cyclone_as_init);
> +module_exit(cyclone_as_cleanup);
> +
> +MODULE_AUTHOR("Alex Gershgorin <agersh@rambler.ru>");
> +MODULE_DESCRIPTION("Altera Cyclone Active Serial driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/platform_drivers/cyclone_as.h
> b/include/platform_drivers/cyclone_as.h
> new file mode 100644
> index 0000000..44c8407
> --- /dev/null
> +++ b/include/platform_drivers/cyclone_as.h
> @@ -0,0 +1,27 @@
> +/* include/linux/cyclone_as.h
> + *
> + * Copyright 2010 Alex Gershgorin, Orex Computed Radiography
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
> + */
> +
> +#ifndef __LINUX_CYCLONE_AS_H__
> +#define __LINUX_CYCLONE_AS_H__
> +
> +struct cyclone_as_platform_data {
> +	unsigned id; /* instance number */
> +
> +	unsigned data;
> +	unsigned asdi;
> +	unsigned nconfig;
> +	unsigned dclk;
> +	unsigned ncs;
> +	unsigned nce;
> +};
> +
> +#endif /* __LINUX_CYCLONE_AS_H__ */
> --
> 1.7.2.3
>
>

Reviewed-by: Indan Zupancic <indan@nul.nu>

Greetings,

Indan


