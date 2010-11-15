Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab0KOKJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:09:35 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:51155 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab0KOKJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:09:33 -0500
Date: Mon, 15 Nov 2010 12:08:38 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
Message-ID: <20101115100838.GA3649@jasper.tkos.co.il>
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il>
 <4CE0FE71.6000303@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE0FE71.6000303@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Thanks for reviewing. See my response to your comments below.

On Mon, Nov 15, 2010 at 10:33:37AM +0100, Jiri Slaby wrote:
> On 11/15/2010 09:23 AM, Baruch Siach wrote:
> > --- /dev/null
> > +++ b/drivers/misc/altera_as.c
> > @@ -0,0 +1,349 @@
> ...
> > +struct altera_as_device {
> > +	unsigned id;
> > +	struct device *dev;
> > +	struct miscdevice miscdev;
> > +	struct mutex open_lock;
> > +	struct gpio gpios[AS_GPIO_NUM];
> > +};
> > +
> > +/*
> > + * The only functions updating this array are .probe/.remove, which are
> > + * serialized. Hence, no locking is needed here.
> > + */
> > +static struct {
> > +	int minor;
> 
> Why you need minor here? It's in drvdata->miscdev.minor.

I use the minor field to lookup the drvdata pointer in get_as_dev(), which I 
use is altera_as_open().  I do this because I have no access to the 'struct 
device' pointer from the .open method. Do you know a better way?

> > +	struct altera_as_device *drvdata;
> > +} altera_as_devs[AS_MAX_DEVS];
> 
> You don't need the struct at all.
> static struct altera_as_device *drvdata[AS_MAX_DEVS];
> should be enough.

See above.

> > +static int altera_as_open(struct inode *inode, struct file *file)
> > +{
> > +	int ret;
> > +	struct altera_as_device *drvdata = get_as_dev(iminor(inode));
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
> > +	if (ret < 0) {
> > +		mutex_unlock(&drvdata->open_lock);
> > +		return ret;
> > +	}
> 
> So leaving to userspace with mutex held. This is *wrong*. use
> test_and_set_bit or alike instead.

Can you explain why this is wrong? I don't mind doing test_and_set_bit 
instead, I'm just curious.

> > +	return 0;
> > +}
> > +
> > +static ssize_t altera_as_write(struct file *file, const char __user *buf,
> > +		size_t count, loff_t *ppos)
> > +{
> ...
> > +	while ((count - written) > 0) {
> > +		err = copy_from_user(page_buf, buf+written, AS_PAGE_SIZE);
> > +		if (err < 0) {
> > +			err = -EFAULT;
> > +			goto out;
> > +		}
> > +
> > +		xmit_cmd(drvdata->gpios, AS_WRITE_ENABLE);
> > +
> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> > +		/* op code */
> > +		xmit_byte(drvdata->gpios, AS_PAGE_PROGRAM);
> > +		/* address */
> > +		xmit_byte(drvdata->gpios, (*ppos >> 16) & 0xff);
> > +		xmit_byte(drvdata->gpios, (*ppos >> 8) & 0xff);
> > +		xmit_byte(drvdata->gpios, *ppos & 0xff);
> > +		/* page data (LSB first) */
> > +		for (i = 0; i < AS_PAGE_SIZE; i++)
> > +			xmit_byte(drvdata->gpios, bitrev8(page_buf[i]));
> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> > +		mdelay(7);
> 
> So if I write 100 pages, I will _spin_ for 700 ms. You should rather
> (m)sleep here.

OK.

> > +		*ppos += AS_PAGE_SIZE;
> > +		written += AS_PAGE_SIZE;
> > +	}
> > +
> > +out:
> > +	kfree(page_buf);
> > +	return err ?: written;
> > +}
> ...
> > +static int __init altera_as_probe(struct platform_device *pdev)
> > +{
> ...
> > +	drvdata->miscdev.minor = MISC_DYNAMIC_MINOR;
> > +	drvdata->miscdev.name = kasprintf(GFP_KERNEL, "altera_as%d",
> > +			pdata->id);
> > +	if (drvdata->miscdev.name == NULL)
> > +		return -ENOMEM;
> > +	drvdata->miscdev.fops = &altera_as_fops;
> > +	if (misc_register(&drvdata->miscdev) < 0) {
> 
> Hmm, how many devices can be in the system?

Up to AS_MAX_DEVS, currently 16.

> This doesn't look like the right way.

What is the right way then?

> > +		kfree(drvdata->miscdev.name);
> > +		return -ENODEV;
> > +	}
> > +	altera_as_devs[pdata->id].minor = drvdata->miscdev.minor;
> > +	altera_as_devs[pdata->id].drvdata = drvdata;
> 
> So now the device is usable without the mutex and gpios inited?

I was thinking that the device lock which is being held during the .probe run, 
prevents the device from being open. After all I can still return -EGOAWAY at 
this point. Am I wrong?

If so, I'll reorder this code.

> > +	mutex_init(&drvdata->open_lock);
> > +
> > +	drvdata->id = pdata->id;
> > +
> > +	drvdata->gpios[ASIO_DATA].gpio		= pdata->data;
> > +	drvdata->gpios[ASIO_DATA].flags		= GPIOF_IN;
> > +	drvdata->gpios[ASIO_DATA].label		= "as_data";
> ...
> > +	drvdata->gpios[ASIO_NCE].gpio		= pdata->nce;
> > +	drvdata->gpios[ASIO_NCE].flags		= GPIOF_OUT_INIT_HIGH;
> > +	drvdata->gpios[ASIO_NCE].label		= "as_nce";
> > +
> > +	dev_info(drvdata->dev, "Altera Cyclone Active Serial driver\n");
> > +
> > +	return 0;
> > +}
> 
> regards,
> -- 
> js
> suse labs

Thanks,

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
