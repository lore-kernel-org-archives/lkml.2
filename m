Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab0KIPgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:36:19 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:35502 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab0KIPgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:36:18 -0500
Date: Tue, 9 Nov 2010 17:35:51 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Indan Zupancic <indan@nul.nu>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCHv2] drivers/misc: Altera Cyclone active serial
 implementation
Message-ID: <20101109153550.GD29441@jasper.tkos.co.il>
References: <f04cbe31c7e03a9d798b30526a5fed1cd8ee4c7a.1289297142.git.baruch@tkos.co.il>
 <0d1a323315dcf505e64fb5165ea41e95.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d1a323315dcf505e64fb5165ea41e95.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Indan,

On Tue, Nov 09, 2010 at 04:01:51PM +0100, Indan Zupancic wrote:
> Hello,
> 
> Looks a lot better now!
> 
> On Tue, November 9, 2010 11:06, Baruch Siach wrote:
> > The active serial protocol can be used to program Altera Cyclone FPGA devices.
> > This driver uses the kernel gpio interface to implement the active serial
> > protocol.
> >
> > Signed-off-by: Alex Gershgorin <agersh@rambler.ru>
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---

[snip]

> > +config CYCLONE_AS
> > +	depends on GENERIC_GPIO
> > +	tristate "Altera Cyclone Active Serial driver"
> > +	help
> > +	  Provides support for active serial programming of Altera Cyclone
> > +	  devices. For the active serial protocol details see the Altera
> > +	  "Serial Configuration Devices" document (C51014).
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called cyclone_as.
> > +
> 
> Looking at cyc_c51014.pdf this protocol is used to program some Altera
> "Serial Configuration Devices", which are more or less flash chips that
> program the FPGA at start-up (notably EPCS* devices). Perhaps that could
> be made more clear. According to the document it's not only for Cyclone
> FPGA's, but also the Arria and Stratix and FPGA's using the Active Serial
> configuration scheme.

OK. I'll make the description clearer.

> >  source "drivers/misc/c2port/Kconfig"
> >  source "drivers/misc/eeprom/Kconfig"
> >  source "drivers/misc/cb710/Kconfig"
> > diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> > index 98009cc..58c6548 100644
> > --- a/drivers/misc/Makefile
> > +++ b/drivers/misc/Makefile
> > @@ -42,3 +42,4 @@ obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
> >  obj-$(CONFIG_PCH_PHUB)		+= pch_phub.o
> >  obj-y				+= ti-st/
> >  obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
> > +obj-$(CONFIG_CYCLONE_AS)	+= cyclone_as.o
> > diff --git a/drivers/misc/cyclone_as.c b/drivers/misc/cyclone_as.c
> > new file mode 100644
> > index 0000000..cdae2a7
> > --- /dev/null
> > +++ b/drivers/misc/cyclone_as.c
> > @@ -0,0 +1,343 @@
> > +/*
> > + * Copyright 2010 Alex Gershgorin, Orex Computed Radiography
> > + *
> > + * The code contained herein is licensed under the GNU General Public
> > + * License. You may obtain a copy of the GNU General Public License
> > + * Version 2 or later at the following locations:
> > + *
> > + * http://www.opensource.org/licenses/gpl-license.html
> > + * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
> > + */
> 
> GPLv2 is included with the kernel source, no need to give external links.

This copyright notice (or a similar one) is common in almost all kernel source 
files. I guess it meant to cover the case of this file being distributed 
separate from the kernel.

> > +#include <linux/fs.h>
> > +#include <linux/err.h>
> > +#include <linux/gpio.h>
> > +#include <linux/slab.h>
> > +#include <linux/mutex.h>
> > +#include <linux/delay.h>
> > +#include <linux/bitrev.h>
> > +#include <linux/device.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/miscdevice.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include <platform_drivers/cyclone_as.h>
> > +
> > +/* Active Serial Instruction Set */
> > +#define AS_WRITE_ENABLE		0x06
> > +#define AS_WRITE_DISABLE	0x04
> > +#define AS_READ_STATUS		0x05
> > +#define AS_WRITE_STATUS		0x01
> > +#define AS_READ_BYTES		0x03
> > +#define AS_FAST_READ_BYTES	0x0B
> > +#define AS_PAGE_PROGRAM		0x02
> > +#define AS_ERASE_SECTOR		0xD8
> > +#define AS_ERASE_BULK		0xC7
> > +#define AS_READ_SILICON_ID	0xAB
> > +#define AS_CHECK_SILICON_ID	0x9F
> > +
> > +#define AS_STATUS_WIP		(1 << 0)
> > +#define AS_STATUS_WEL		(1 << 1)
> > +#define AS_STATUS_BP0		(1 << 2)
> > +#define AS_STATUS_BP1		(1 << 3)
> > +#define AS_STATUS_BP2		(1 << 4)
> > +
> > +#define AS_ERASE_TIMEOUT	250 /* seconds, max for EPCS128 */
> > +
> > +#define AS_PAGE_SIZE		256
> > +
> > +#define AS_MAX_DEVS		16
> > +
> > +#define ASIO_DATA		0
> > +#define ASIO_ASDI		1
> > +#define ASIO_NCONFIG		2
> 
> What is the function of this pin?
> 
> > +#define ASIO_DCLK		3
> > +#define ASIO_NCS		4
> > +#define ASIO_NCE		5
> 
> And NCE?
> 
> Neither is mentioned in the doc, nor are they really used.

On page 3-30, the third paragraph from the page end mentions both nCONFIG and 
nCE.

> > +#define AS_GPIO_NUM		6
> > +
> > +#define AS_ALIGNED(x)	IS_ALIGNED(x, AS_PAGE_SIZE)
> > +
> > +struct cyclone_as_device {
> > +	unsigned id;
> > +	struct device *dev;
> > +	struct miscdevice miscdev;
> > +	struct mutex open_lock;
> > +	struct gpio gpios[AS_GPIO_NUM];
> 
> I wonder whether it would be nicer to have them as proper struct members
> instead of an array.

This way I can use gpio_request_array/gpio_free_array directly.

> > +};
> > +
> > +static struct {
> > +	int minor;
> > +	struct cyclone_as_device *drvdata;
> > +} cyclone_as_devs[AS_MAX_DEVS];
> > +
> > +static struct cyclone_as_device *get_as_dev(int minor)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(cyclone_as_devs); i++)
> 
> To me AS_MAX_DEVS looks clearer than ARRAY_SIZE(cyclone_as_devs).

Not to me. The fact that AS_MAX_DEVS happens to be equal to 
ARRAY_SIZE(cyclone_as_devs) is not relevant to the understanding of this 
procedure. It just forces the reader to lookup the AS_MAX_DEVS value, and 
distracts the reader's attention.

> > +		if (cyclone_as_devs[i].minor == minor)
> > +			return cyclone_as_devs[i].drvdata;
> > +
> > +	return NULL;
> > +}
> > +
> > +static void as_clk_tick(struct gpio *gpios)
> > +{
> > +	gpio_set_value(gpios[ASIO_DCLK].gpio, 0);
> > +	ndelay(40);
> > +	gpio_set_value(gpios[ASIO_DCLK].gpio, 1);
> > +	ndelay(20);
> 
> Shouldn't the first ndelay(40) be a ndelay(20) too? That way the total
> is 40 and you get a 25MHz clock.

OK. I'll look into this.

> > +}
> > +
> > +static void xmit_byte(struct gpio *gpios, u8 c)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < 8; i++) {
> > +		gpio_set_value(gpios[ASIO_ASDI].gpio, (c << i) & 0x80);
> > +		as_clk_tick(gpios);
> > +	}
> > +}
> > +
> > +static void xmit_cmd(struct gpio *gpios, u8 cmd)
> > +{
> > +	gpio_set_value(gpios[ASIO_NCS].gpio, 0);
> > +	xmit_byte(gpios, cmd);
> > +	gpio_set_value(gpios[ASIO_NCS].gpio, 1);
> > +	ndelay(300);
> 
> That ndelay looks redundant, just leave it away?
> 
> I can't find any requirement for it in the doc. Is it the 8 cycles
> thing for NCS? If so, that seems to be handled automatically because
> only whole bytes are sent at a time.

Table 3-16 mandates 100ns for tCSH (Chip select high time). So this can be 
reduced to 100ns, but not eliminated.

> > +}
> > +
> > +static u8 recv_byte(struct gpio *gpios)
> > +{
> > +	int i;
> > +	u8 val = 0;
> > +
> > +	for (i = 0; i < 8; i++) {
> > +		as_clk_tick(gpios);
> > +		val |= (!!gpio_get_value(gpios[ASIO_DATA].gpio) << (7 - i));
> 
> The !! is a bit redundant. If it changes the reslult, val is invalid anyway?

According to Documentation/gpio.txt, gpio_get_value returns nonzero for high.  
The !! prefix makes this 1.

> > +	}
> > +
> > +	return val;
> > +}
> > +
> > +static int cyclone_as_open(struct inode *inode, struct file *file)
> > +{
> > +	int ret;
> > +	struct cyclone_as_device *drvdata = get_as_dev(iminor(inode));
> > +
> > +	if (drvdata == NULL)
> > +		return -ENODEV;
> > +	file->private_data = drvdata;
> > +
> > +	ret = mutex_trylock(&drvdata->open_lock);
> > +	if (ret == 0)
> > +		return -EBUSY;
> > +
> > +	ret = gpio_request_array(drvdata->gpios, ARRAY_SIZE(drvdata->gpios));
> 
> AS_GPIO_NUM?

See above.

> > +	if (ret < 0) {
> > +		mutex_unlock(&drvdata->open_lock);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static ssize_t cyclone_as_write(struct file *file, const char __user *buf,
> > +		size_t count, loff_t *ppos)
> > +{
> > +	int	i, err = 0;
> > +	u8	*page_buf;
> > +	ssize_t written = 0;
> > +	struct cyclone_as_device *drvdata = file->private_data;
> > +	unsigned page_count;
> > +
> > +	if (count == 0)
> > +		return 0;
> > +
> > +	/* writes must be page aligned */
> > +	if (!AS_ALIGNED(*ppos) || !AS_ALIGNED(count))
> > +		return -EINVAL;
> > +	page_count = *ppos / AS_PAGE_SIZE;
> > +
> > +	page_buf = kmalloc(AS_PAGE_SIZE, GFP_KERNEL);
> > +	if (page_buf == NULL)
> > +		return -ENOMEM;
> > +
> > +	if (*ppos == 0) {
> > +		u8 as_status;
> > +
> > +		xmit_cmd(drvdata->gpios, AS_WRITE_ENABLE);
> > +		xmit_cmd(drvdata->gpios, AS_ERASE_BULK);
> > +
> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> > +		xmit_byte(drvdata->gpios, AS_READ_STATUS);
> > +		for (i = 0; i < AS_ERASE_TIMEOUT; i++) {
> > +			as_status = recv_byte(drvdata->gpios);
> > +			if ((as_status & AS_STATUS_WIP) == 0)
> > +				break; /* erase done */
> > +			if (msleep_interruptible(1000) > 0) {
> > +				err = -EINTR;
> > +				break;
> > +			}
> > +		}
> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> > +		if ((as_status & AS_STATUS_WIP) && err == 0)
> > +			err = -EIO; /* erase timeout */
> > +		if (err)
> > +			goto out;
> > +		ndelay(300);
> > +	}
> 
> I'd move this into its own function, erase_device() or something.

OK.

> (And drop the ndelay.)

See above.

> > +	while (count) {
> > +		dev_dbg(drvdata->dev, "offset = 0x%p\n", buf+written);
> 
> If you tested this code and it works, then this dev_dbg() shouldn't be
> needed anymore.

OK.

> > +		err = copy_from_user(page_buf, buf+written, AS_PAGE_SIZE);
> > +		if (err < 0) {
> > +			err = -EFAULT;
> > +			goto out;
> > +		}
> > +
> > +		*ppos += AS_PAGE_SIZE;
> > +		count -= AS_PAGE_SIZE;
> > +		written += AS_PAGE_SIZE;
> > +
> > +		xmit_cmd(drvdata->gpios, AS_WRITE_ENABLE);
> > +
> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> > +		/* op code */
> > +		xmit_byte(drvdata->gpios, AS_PAGE_PROGRAM);
> > +		/* address */
> > +		xmit_byte(drvdata->gpios, (page_count >> 8) & 0xff);
> > +		xmit_byte(drvdata->gpios, page_count & 0xff);
> > +		xmit_byte(drvdata->gpios, 0);
> > +		/* page data (LSB first) */
> > +		for (i = 0; i < AS_PAGE_SIZE; i++)
> > +			xmit_byte(drvdata->gpios, bitrev8(page_buf[i]));
> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> > +		page_count++;
> > +		mdelay(7);
> > +	}
> > +
> > +out:
> > +	kfree(page_buf);
> > +	return err ?: written;
> 
> Maybe use one variable to combine err and written.

OK.

> > +}

[snip]

> Reviewed-by: Indan Zupancic <indan@nul.nu>

Thanks,

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
