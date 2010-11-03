Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab0KCRcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:32:51 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:35264 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab0KCRct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:32:49 -0400
X-Greylist: delayed 1125 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Nov 2010 13:32:48 EDT
Message-ID: <e15f89ec737d2478bf5edd5369028554.squirrel@webmail.greenhost.nl>
In-Reply-To: <879a6320efee16c04f0732a6887b95c1b4c6d10f.1288793522.git.baruch@tkos.c
     o.il>
References: <879a6320efee16c04f0732a6887b95c1b4c6d10f.1288793522.git.baruch@tkos.co.il>
Date: Wed, 3 Nov 2010 18:13:58 +0100 (CET)
Subject: Re: [PATCH] drivers/misc: Altera Cyclone active serial 
     implementation
From: "Indan Zupancic" <indan@nul.nu>
To: "Baruch Siach" <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
        "Alex Gershgorin" <agersh@rambler.ru>,
        "Baruch Siach" <baruch@tkos.co.il>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: ff452d6661b1a372eada0628cb8db990
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm in a code review mood, and you're the lucky person.
Feedback below.

On Wed, November 3, 2010 15:21, Baruch Siach wrote:
> From: Alex Gershgorin <agersh@rambler.ru>
>
> The active serial protocol can be used to program Altera Cyclone FPGA devices.
> This driver uses the kernel gpio interface to implement the active serial
> protocol.
>
> Signed-off-by: Alex Gershgorin <agersh@rambler.ru>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  drivers/misc/Kconfig       |   10 ++
>  drivers/misc/Makefile      |    1 +
>  drivers/misc/cyclone_as.c  |  326++++++++++++++++++++++++++++++++++++++++++
>  include/linux/cyclone_as.h |   23 +++
>  4 files changed, 360 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/cyclone_as.c
>  create mode 100644 include/linux/cyclone_as.h
>
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index b743312..182328e 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -390,6 +390,16 @@ config BMP085
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called bmp085.
>
> +config CYCLONE_AS
> +	tristate "Altera Cyclone Active Serial driver"
> +	help
> +	  Provides support for active serial programming of Altera Cyclone
> +	  devices. For the active serial protocol details see the Altera
> +	  "Serial Configuration Devices" document (C51014).
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called cyclone_as.
> +
>  source "drivers/misc/c2port/Kconfig"
>  source "drivers/misc/eeprom/Kconfig"
>  source "drivers/misc/cb710/Kconfig"
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 42eab95..a3e0248 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -35,3 +35,4 @@ obj-y				+= eeprom/
>  obj-y				+= cb710/
>  obj-$(CONFIG_VMWARE_BALLOON)	+= vmw_balloon.o
>  obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
> +obj-$(CONFIG_CYCLONE_AS)	+= cyclone_as.o
> diff --git a/drivers/misc/cyclone_as.c b/drivers/misc/cyclone_as.c
> new file mode 100644
> index 0000000..bfaa60d
> --- /dev/null
> +++ b/drivers/misc/cyclone_as.c
> @@ -0,0 +1,326 @@
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
> +
> +#include <linux/fs.h>
> +#include <linux/err.h>
> +#include <linux/cdev.h>
> +#include <linux/gpio.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/uaccess.h>
> +#include <linux/cyclone_as.h>
> +#include <linux/platform_device.h>
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
> +#define AS_PAGE_SIZE		256
> +
> +#define AS_MAX_DEVS		16
> +
> +#define ASIO_DATA		0
> +#define ASIO_NCONFIG		1
> +#define ASIO_DCLK		2
> +#define ASIO_NCS		3
> +#define ASIO_NCE		4
> +#define AS_GPIO_NUM		5
> +
> +#define AS_ALIGNED(x)	IS_ALIGNED(x, AS_PAGE_SIZE)
> +
> +static struct class *cyclone_as_class;
> +static unsigned cyclone_as_major;
> +static DECLARE_BITMAP(cyclone_as_devs, AS_MAX_DEVS);
> +
> +struct cyclone_as_device {
> +	struct cdev cdev;
> +	struct device *dev;
> +	struct mutex open_lock;
> +	struct gpio gpios[AS_GPIO_NUM];
> +};
> +
> +static void xmit_byte(struct gpio *gpios, char c, char lsb_first)
> +{
> +	int i;
> +
> +	for (i = 0; i < 8; i++) {
> +		gpio_set_value(gpios[ASIO_DATA].gpio,
> +				lsb_first ? (c >> i) & 1 : (c << i) & 0x80);
> +
> +		gpio_set_value(gpios[ASIO_DCLK].gpio, 0);
> +		ndelay(40);
> +		gpio_set_value(gpios[ASIO_DCLK].gpio, 1);
> +		ndelay(20);
> +	}
> +}

I think it would clear up the code a lot if you introduced a xmit_bytes()
function which does the above for variable lengths, as well as the ASIO_NCS
fiddling. Also pass in drvdata and get the gpios from there in this function,
you never have the one without the other.

Only thing preventing this is the lsb_first thing. That is only needed for
the page data itself, so I'd get rid of that option (always 0) and instead
introduce a function swap_page_byte_bits() or something and call that for
the page data before sending it all sequentially in one go. It can use
bitrev8() from bitrev.h for the actual bits swapping.

> +
> +static int cyclone_as_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +	struct cyclone_as_device *drvdata;
> +
> +	drvdata = container_of(inode->i_cdev, struct cyclone_as_device, cdev);
> +	ret = mutex_trylock(&drvdata->open_lock);
> +	if (ret == 0)
> +		return -EBUSY;
> +
> +	file->private_data = drvdata;
> +
> +	ret = gpio_request_array(drvdata->gpios, ARRAY_SIZE(drvdata->gpios));
> +	if (ret < 0) {
> +		mutex_unlock(&drvdata->open_lock);
> +		return ret;
> +	}
> +	ndelay(300);

This delay looks redundant.

> +
> +	dev_dbg(drvdata->dev,
> +			"data: %d, nconfig: %d, dclk: %d, ncs: %d, nce: %d\n",
> +			drvdata->gpios[ASIO_DATA].gpio,
> +			drvdata->gpios[ASIO_NCONFIG].gpio,
> +			drvdata->gpios[ASIO_DCLK].gpio,
> +			drvdata->gpios[ASIO_NCS].gpio,
> +			drvdata->gpios[ASIO_NCE].gpio);

Can't you get the same info from somewhere in /sys, or from the gpio
debug prints? If so, consider leaving this away.

> +
> +	return 0;
> +}

You don't unlock open_lock, so this supports only one user at the time?

> +
> +static ssize_t cyclone_as_write(struct file *file, const char *buf,
> +		size_t count, loff_t *ppos)
> +{
> +	int	i, ret;
> +	u8	*page_buf;
> +	ssize_t len = count;
> +	struct cyclone_as_device *drvdata = file->private_data;
> +	unsigned page_count;

unsigned short?

> +
> +	if (len < 0)
> +		return -EFAULT;
> +
> +	if (len == 0)
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
> +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> +		xmit_byte(drvdata->gpios, AS_WRITE_ENABLE, 0);
> +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> +		ndelay(300);
> +
> +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> +		xmit_byte(drvdata->gpios, AS_ERASE_BULK, 0);
> +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> +		msleep_interruptible(5000);

Is 5s always enough? Is there some way to check if it's really done?

> +	}
> +
> +	while (len) {
> +		dev_dbg(drvdata->dev, "offset = 0x%p\n", buf);
> +
> +		ret = copy_from_user(page_buf, buf, AS_PAGE_SIZE);
> +		if (ret == 0) {
> +			buf += AS_PAGE_SIZE;
> +			*ppos += AS_PAGE_SIZE;
> +			len -= AS_PAGE_SIZE;
> +		} else {
> +			kfree(page_buf);
> +			return -EFAULT;
> +		}

Maybe check the whole range before sending any data?

> +
> +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> +		xmit_byte(drvdata->gpios, AS_WRITE_ENABLE, 0);
> +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> +		ndelay(300);
> +
> +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> +		xmit_byte(drvdata->gpios, AS_PAGE_PROGRAM, 0);
> +		xmit_byte(drvdata->gpios, (page_count >> 8) & 0xff, 0);
> +		xmit_byte(drvdata->gpios, page_count & 0xff, 0);
> +		xmit_byte(drvdata->gpios, 0, 0);
> +		ndelay(300);

This delay looks redundant, sure it's needed when you're not fiddling
with ASIO_NCS?

> +
> +		for (i = 0; i < AS_PAGE_SIZE; i++)
> +			xmit_byte(drvdata->gpios, page_buf[i], 1);
> +
> +		ndelay(300);
> +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);

Everywhere else the delay is after setting the NCS. Just weird
protocol or a mistake?

> +		page_count++;
> +		mdelay(5);
> +	}
> +
> +	kfree(page_buf);
> +	return count;
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
> +	int ret, minor;
> +	struct cyclone_as_device *drvdata;
> +	struct device *dev;
> +	struct cyclone_as_platform_data *pdata = pdev->dev.platform_data;
> +
> +	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
> +	if (!drvdata)
> +		return -ENOMEM;
> +
> +	drvdata->dev = &pdev->dev;
> +
> +	cdev_init(&drvdata->cdev, &cyclone_as_fops);
> +	drvdata->cdev.owner = THIS_MODULE;

Isn't that already set by cdev_init? Hmm, apparently not, perhaps it should?

> +
> +	minor = find_first_zero_bit(cyclone_as_devs, AS_MAX_DEVS);
> +	if (minor >= AS_MAX_DEVS)
> +		return -EBUSY;
> +	ret = cdev_add(&drvdata->cdev, MKDEV(cyclone_as_major, minor), 1);
> +	if (ret < 0)
> +		return ret;
> +	set_bit(minor, cyclone_as_devs);
> +
> +	dev = device_create(cyclone_as_class, &pdev->dev,
> +			MKDEV(cyclone_as_major, minor), drvdata,
> +			"%s%d", "cyclone_as", minor);

Shouldn't you do this at the very end?

> +	if (IS_ERR(dev)) {
> +		ret = PTR_ERR(dev);
> +		goto cdev_del;
> +	}
> +
> +	mutex_init(&drvdata->open_lock);
> +
> +	drvdata->gpios[ASIO_DATA].gpio		= pdata->data;
> +	drvdata->gpios[ASIO_DATA].flags		= GPIOF_OUT_INIT_LOW;
> +	drvdata->gpios[ASIO_DATA].label		= "as_data";
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

...at least after this bit?

> +
> +	dev_info(drvdata->dev, "Altera Cyclone Active Serial driver\n");
> +
> +	return 0;
> +
> +cdev_del:
> +	clear_bit(minor, cyclone_as_devs);
> +	cdev_del(&drvdata->cdev);
> +	return ret;
> +}
> +
> +static int __devexit cyclone_as_remove(struct platform_device *pdev)
> +{
> +	struct cyclone_as_device *drvdata = platform_get_drvdata(pdev);
> +	int minor = MINOR(drvdata->cdev.dev);
> +
> +	device_destroy(cyclone_as_class, MKDEV(cyclone_as_major, minor));
> +	clear_bit(minor, cyclone_as_devs);
> +	cdev_del(&drvdata->cdev);
> +
> +	return 0;
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
> +	int err;
> +	dev_t dev;
> +
> +	cyclone_as_class = class_create(THIS_MODULE, "cyclone_as");
> +	if (IS_ERR(cyclone_as_class)) {
> +		err = PTR_ERR(cyclone_as_class);
> +		goto out;
> +	}
> +
> +	err = alloc_chrdev_region(&dev, 0, AS_MAX_DEVS, "cyclone_as");
> +	if (err < 0)
> +		goto class_destroy;
> +	cyclone_as_major = MAJOR(dev);
> +
> +	err = platform_driver_probe(&cyclone_as_driver, cyclone_as_probe);
> +	if (err < 0)
> +		goto chr_remove;
> +
> +	return 0;
> +
> +chr_remove:
> +	unregister_chrdev_region(dev, AS_MAX_DEVS);
> +class_destroy:
> +	class_destroy(cyclone_as_class);
> +out:
> +	return err;
> +}
> +
> +void __exit cyclone_as_cleanup(void)
> +{
> +	platform_driver_unregister(&cyclone_as_driver);
> +	unregister_chrdev_region(MKDEV(cyclone_as_major, 0), AS_MAX_DEVS);
> +	class_destroy(cyclone_as_class);
> +}
> +
> +module_init(cyclone_as_init);
> +module_exit(cyclone_as_cleanup);
> +
> +MODULE_AUTHOR("Alex Gershgorin <agersh@rambler.ru>");
> +MODULE_DESCRIPTION("Altera Cyclone Active Serial driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/cyclone_as.h b/include/linux/cyclone_as.h
> new file mode 100644
> index 0000000..cf86955
> --- /dev/null
> +++ b/include/linux/cyclone_as.h
> @@ -0,0 +1,23 @@
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
> +
> +#ifndef __ALTERA_PROG_H
> +#define __ALTERA_PROG_H
> +
> +struct cyclone_as_platform_data {
> +	unsigned data;
> +	unsigned nconfig;
> +	unsigned dclk;
> +	unsigned ncs;
> +	unsigned nce;
> +};
> +
> +#endif /* __ALTERA_PROG_H */

I know other drivers put their header files in include/linux/ too,
but is there any reason to? This seems all internal to cyclone_as.c,
why not have no header file?

Probably not high on your list, but what about suspend support?
Preventing suspend from succeeding seems like a good idea when
stuff is going on.

Greetings,

Indan


