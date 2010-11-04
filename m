Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab0KDGrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 02:47:14 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:33816 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab0KDGrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 02:47:11 -0400
Date: Thu, 4 Nov 2010 08:46:44 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Indan Zupancic <indan@nul.nu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCH] drivers/misc: Altera Cyclone active serial
 implementation
Message-ID: <20101104064643.GA11249@jasper.tkos.co.il>
References: <879a6320efee16c04f0732a6887b95c1b4c6d10f.1288793522.git.baruch@tkos.co.il>
 <e15f89ec737d2478bf5edd5369028554.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e15f89ec737d2478bf5edd5369028554.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Indan,

On Wed, Nov 03, 2010 at 06:13:58PM +0100, Indan Zupancic wrote:
> Hello,
> 
> I'm in a code review mood, and you're the lucky person.
> Feedback below.
> 
> On Wed, November 3, 2010 15:21, Baruch Siach wrote:
> > From: Alex Gershgorin <agersh@rambler.ru>
> >
> > The active serial protocol can be used to program Altera Cyclone FPGA devices.
> > This driver uses the kernel gpio interface to implement the active serial
> > protocol.
> >
> > Signed-off-by: Alex Gershgorin <agersh@rambler.ru>
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---

[snip]

> > +static void xmit_byte(struct gpio *gpios, char c, char lsb_first)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < 8; i++) {
> > +		gpio_set_value(gpios[ASIO_DATA].gpio,
> > +				lsb_first ? (c >> i) & 1 : (c << i) & 0x80);
> > +
> > +		gpio_set_value(gpios[ASIO_DCLK].gpio, 0);
> > +		ndelay(40);
> > +		gpio_set_value(gpios[ASIO_DCLK].gpio, 1);
> > +		ndelay(20);
> > +	}
> > +}
> 
> I think it would clear up the code a lot if you introduced a xmit_bytes()
> function which does the above for variable lengths, as well as the ASIO_NCS
> fiddling.

I'll consider this for the next version. Keep in mind that we send a whole 
command during nCS assertion, not arbitrary buffers. So, in the case of the 
PAGE_PROGRAM command, we'll need to prepend the instruction and its address 
argument to the page data. I'm not sure we end up with something more clear 
than we have now.

> Also pass in drvdata and get the gpios from there in this function,
> you never have the one without the other.

So? I want to avoid the 'drvdata->' prefix when it's not needed.

> Only thing preventing this is the lsb_first thing. That is only needed for
> the page data itself, so I'd get rid of that option (always 0) and instead
> introduce a function swap_page_byte_bits() or something and call that for
> the page data before sending it all sequentially in one go. It can use
> bitrev8() from bitrev.h for the actual bits swapping.

Thanks for the tip. I plan to use bitrev8() at the caller function and remove 
this argument from xmit_byte().

> > +static int cyclone_as_open(struct inode *inode, struct file *file)
> > +{
> > +	int ret;
> > +	struct cyclone_as_device *drvdata;
> > +
> > +	drvdata = container_of(inode->i_cdev, struct cyclone_as_device, cdev);
> > +	ret = mutex_trylock(&drvdata->open_lock);
> > +	if (ret == 0)
> > +		return -EBUSY;
> > +
> > +	file->private_data = drvdata;
> > +
> > +	ret = gpio_request_array(drvdata->gpios, ARRAY_SIZE(drvdata->gpios));
> > +	if (ret < 0) {
> > +		mutex_unlock(&drvdata->open_lock);
> > +		return ret;
> > +	}
> > +	ndelay(300);
> 
> This delay looks redundant.

Right.

> > +
> > +	dev_dbg(drvdata->dev,
> > +			"data: %d, nconfig: %d, dclk: %d, ncs: %d, nce: %d\n",
> > +			drvdata->gpios[ASIO_DATA].gpio,
> > +			drvdata->gpios[ASIO_NCONFIG].gpio,
> > +			drvdata->gpios[ASIO_DCLK].gpio,
> > +			drvdata->gpios[ASIO_NCS].gpio,
> > +			drvdata->gpios[ASIO_NCE].gpio);
> 
> Can't you get the same info from somewhere in /sys, or from the gpio
> debug prints? If so, consider leaving this away.

The debugfs gpio file gives this information. I'll drop it.

> > +
> > +	return 0;
> > +}
> 
> You don't unlock open_lock, so this supports only one user at the time?

Correct. I don't think anything good will come out of concurrent writes to the 
FPGA, and read is not supported.

> > +static ssize_t cyclone_as_write(struct file *file, const char *buf,
> > +		size_t count, loff_t *ppos)
> > +{
> > +	int	i, ret;
> > +	u8	*page_buf;
> > +	ssize_t len = count;
> > +	struct cyclone_as_device *drvdata = file->private_data;
> > +	unsigned page_count;
> 
> unsigned short?

The largest chip currently supporting this protocol (EPCS128) has 2^16 pages, 
but the protocol allocates 3 address bytes. So why limit ourselves? Currently 
the code only uses the 16 LSBs, I'll change this.

> > +	if (len < 0)
> > +		return -EFAULT;
> > +
> > +	if (len == 0)
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
> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> > +		xmit_byte(drvdata->gpios, AS_WRITE_ENABLE, 0);
> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> > +		ndelay(300);
> > +
> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> > +		xmit_byte(drvdata->gpios, AS_ERASE_BULK, 0);
> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> > +		msleep_interruptible(5000);
> 
> Is 5s always enough? Is there some way to check if it's really done?

You are right. 5 seconds are definitely not enough for the larger chips 
(typical time of 105 seconds for EPCS128). I'll poll the "write in progress" 
bit instead. More code to write :(.

> > +	}
> > +
> > +	while (len) {
> > +		dev_dbg(drvdata->dev, "offset = 0x%p\n", buf);
> > +
> > +		ret = copy_from_user(page_buf, buf, AS_PAGE_SIZE);
> > +		if (ret == 0) {
> > +			buf += AS_PAGE_SIZE;
> > +			*ppos += AS_PAGE_SIZE;
> > +			len -= AS_PAGE_SIZE;
> > +		} else {
> > +			kfree(page_buf);
> > +			return -EFAULT;
> > +		}
> 
> Maybe check the whole range before sending any data?

What is there to check?

> > +
> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> > +		xmit_byte(drvdata->gpios, AS_WRITE_ENABLE, 0);
> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> > +		ndelay(300);
> > +
> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> > +		xmit_byte(drvdata->gpios, AS_PAGE_PROGRAM, 0);
> > +		xmit_byte(drvdata->gpios, (page_count >> 8) & 0xff, 0);
> > +		xmit_byte(drvdata->gpios, page_count & 0xff, 0);
> > +		xmit_byte(drvdata->gpios, 0, 0);
> > +		ndelay(300);
> 
> This delay looks redundant, sure it's needed when you're not fiddling
> with ASIO_NCS?

Probably not.

> > +		for (i = 0; i < AS_PAGE_SIZE; i++)
> > +			xmit_byte(drvdata->gpios, page_buf[i], 1);
> > +
> > +		ndelay(300);
> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> 
> Everywhere else the delay is after setting the NCS. Just weird
> protocol or a mistake?

Mistake.

> > +		page_count++;
> > +		mdelay(5);
> > +	}
> > +
> > +	kfree(page_buf);
> > +	return count;
> > +}

[snip

> > +static int __init cyclone_as_probe(struct platform_device *pdev)
> > +{
> > +	int ret, minor;
> > +	struct cyclone_as_device *drvdata;
> > +	struct device *dev;
> > +	struct cyclone_as_platform_data *pdata = pdev->dev.platform_data;
> > +
> > +	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
> > +	if (!drvdata)
> > +		return -ENOMEM;
> > +
> > +	drvdata->dev = &pdev->dev;
> > +
> > +	cdev_init(&drvdata->cdev, &cyclone_as_fops);
> > +	drvdata->cdev.owner = THIS_MODULE;
> 
> Isn't that already set by cdev_init? Hmm, apparently not, perhaps it should?
> 
> > +
> > +	minor = find_first_zero_bit(cyclone_as_devs, AS_MAX_DEVS);
> > +	if (minor >= AS_MAX_DEVS)
> > +		return -EBUSY;
> > +	ret = cdev_add(&drvdata->cdev, MKDEV(cyclone_as_major, minor), 1);
> > +	if (ret < 0)
> > +		return ret;
> > +	set_bit(minor, cyclone_as_devs);
> > +
> > +	dev = device_create(cyclone_as_class, &pdev->dev,
> > +			MKDEV(cyclone_as_major, minor), drvdata,
> > +			"%s%d", "cyclone_as", minor);
> 
> Shouldn't you do this at the very end?

Sounds reasonable.

> > +	if (IS_ERR(dev)) {
> > +		ret = PTR_ERR(dev);
> > +		goto cdev_del;
> > +	}
> > +
> > +	mutex_init(&drvdata->open_lock);
> > +
> > +	drvdata->gpios[ASIO_DATA].gpio		= pdata->data;
> > +	drvdata->gpios[ASIO_DATA].flags		= GPIOF_OUT_INIT_LOW;
> > +	drvdata->gpios[ASIO_DATA].label		= "as_data";
> > +	drvdata->gpios[ASIO_NCONFIG].gpio	= pdata->nconfig;
> > +	drvdata->gpios[ASIO_NCONFIG].flags	= GPIOF_OUT_INIT_LOW;
> > +	drvdata->gpios[ASIO_NCONFIG].label	= "as_nconfig";
> > +	drvdata->gpios[ASIO_DCLK].gpio		= pdata->dclk;
> > +	drvdata->gpios[ASIO_DCLK].flags		= GPIOF_OUT_INIT_LOW;
> > +	drvdata->gpios[ASIO_DCLK].label		= "as_dclk";
> > +	drvdata->gpios[ASIO_NCS].gpio		= pdata->ncs;
> > +	drvdata->gpios[ASIO_NCS].flags		= GPIOF_OUT_INIT_HIGH;
> > +	drvdata->gpios[ASIO_NCS].label		= "as_ncs";
> > +	drvdata->gpios[ASIO_NCE].gpio		= pdata->nce;
> > +	drvdata->gpios[ASIO_NCE].flags		= GPIOF_OUT_INIT_HIGH;
> > +	drvdata->gpios[ASIO_NCE].label		= "as_nce";
> 
> ...at least after this bit?
> 
> > +
> > +	dev_info(drvdata->dev, "Altera Cyclone Active Serial driver\n");
> > +
> > +	return 0;
> > +
> > +cdev_del:
> > +	clear_bit(minor, cyclone_as_devs);
> > +	cdev_del(&drvdata->cdev);
> > +	return ret;
> > +}

[snip]

> > diff --git a/include/linux/cyclone_as.h b/include/linux/cyclone_as.h
> > new file mode 100644
> > index 0000000..cf86955
> > --- /dev/null
> > +++ b/include/linux/cyclone_as.h
> > @@ -0,0 +1,23 @@
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
> > +
> > +#ifndef __ALTERA_PROG_H
> > +#define __ALTERA_PROG_H
> > +
> > +struct cyclone_as_platform_data {
> > +	unsigned data;
> > +	unsigned nconfig;
> > +	unsigned dclk;
> > +	unsigned ncs;
> > +	unsigned nce;
> > +};
> > +
> > +#endif /* __ALTERA_PROG_H */
> 
> I know other drivers put their header files in include/linux/ too,
> but is there any reason to? This seems all internal to cyclone_as.c,
> why not have no header file?

This part is not internal at all. Using this struct the platform code (knowing 
the actual machine specific GPIO wiring) passes this information to the 
driver.

> Probably not high on your list, but what about suspend support?
> Preventing suspend from succeeding seems like a good idea when
> stuff is going on.

I'm not sure we should impose a suspend prevention in this case. The user 
should bear the consequences if he/she decides to suspend the system in the 
middle of FPGA programming. Maybe we should just warn.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
