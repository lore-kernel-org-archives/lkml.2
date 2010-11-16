Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab0KPF5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 00:57:04 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:42982 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab0KPF5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 00:57:03 -0500
Date: Tue, 16 Nov 2010 07:56:02 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Indan Zupancic <indan@nul.nu>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
Message-ID: <20101116055602.GA18210@jasper.tkos.co.il>
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il>
 <4CE0FE71.6000303@suse.cz>
 <20101115100838.GA3649@jasper.tkos.co.il>
 <4CE10B32.8090705@suse.cz>
 <c30e46c1b5343789b6475722071c3020.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c30e46c1b5343789b6475722071c3020.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Indan,

On Tue, Nov 16, 2010 at 01:47:52AM +0100, Indan Zupancic wrote:
> On Mon, November 15, 2010 11:28, Jiri Slaby wrote:
> > On 11/15/2010 11:08 AM, Baruch Siach wrote:
> >> Hi Jiri,
> >>
> >> Thanks for reviewing. See my response to your comments below.
> >>
> >> On Mon, Nov 15, 2010 at 10:33:37AM +0100, Jiri Slaby wrote:
> >>> On 11/15/2010 09:23 AM, Baruch Siach wrote:
> >>>> --- /dev/null
> >>>> +++ b/drivers/misc/altera_as.c
> >>>> @@ -0,0 +1,349 @@
> >>> ...
> >>>> +struct altera_as_device {
> >>>> +	unsigned id;
> >>>> +	struct device *dev;
> >>>> +	struct miscdevice miscdev;
> >>>> +	struct mutex open_lock;
> >>>> +	struct gpio gpios[AS_GPIO_NUM];
> >>>> +};
> >>>> +
> >>>> +/*
> >>>> + * The only functions updating this array are .probe/.remove, which are
> >>>> + * serialized. Hence, no locking is needed here.
> >>>> + */
> >>>> +static struct {
> >>>> +	int minor;
> >>>
> >>> Why you need minor here? It's in drvdata->miscdev.minor.
> >>
> >> I use the minor field to lookup the drvdata pointer in get_as_dev(), which I
> >> use is altera_as_open().  I do this because I have no access to the 'struct
> >> device' pointer from the .open method. Do you know a better way?
> 
> Yes.
> 
> Get rid of the array and minor lookup, and instead use container_of()
> to get struct altera_as_device directly from file->private_data, which
> is a pointer to miscdev, set by misc_open().

Thanks. This was exactly what I was looking for.

> Sorry for not noticing this before.
> 
> >>
> >>>> +	struct altera_as_device *drvdata;
> >>>> +} altera_as_devs[AS_MAX_DEVS];
> >>>
> >>> You don't need the struct at all.
> >>> static struct altera_as_device *drvdata[AS_MAX_DEVS];
> >>> should be enough.
> >>
> >> See above.
> >
> > The answer to you previous question is here. You can just have a global
> > array of struct altera_as_device.
> >
> >>>> +static int altera_as_open(struct inode *inode, struct file *file)
> >>>> +{
> >>>> +	int ret;
> >>>> +	struct altera_as_device *drvdata = get_as_dev(iminor(inode));
> >>>> +
> >>>> +	if (drvdata == NULL)
> >>>> +		return -ENODEV;
> >>>> +	file->private_data = drvdata;
> >>>> +
> >>>> +	ret = mutex_trylock(&drvdata->open_lock);
> >>>> +	if (ret == 0)
> >>>> +		return -EBUSY;
> >>>> +
> >>>> +	ret = gpio_request_array(drvdata->gpios, ARRAY_SIZE(drvdata->gpios));
> >>>> +	if (ret < 0) {
> >>>> +		mutex_unlock(&drvdata->open_lock);
> >>>> +		return ret;
> >>>> +	}
> >>>
> >>> So leaving to userspace with mutex held. This is *wrong*. use
> >>> test_and_set_bit or alike instead.
> >>
> >> Can you explain why this is wrong? I don't mind doing test_and_set_bit
> >> instead, I'm just curious.
> >
> > The mutex has an owner which it expects to unlock it. For example if you
> > fork a process which already opened the device, you have a problem. This
> > is a technical point. Another point is that it's ugly to leave to
> > userspace with any lock.
> >
> >>>> +static int __init altera_as_probe(struct platform_device *pdev)
> >>>> +{
> >>> ...
> >>>> +	drvdata->miscdev.minor = MISC_DYNAMIC_MINOR;
> >>>> +	drvdata->miscdev.name = kasprintf(GFP_KERNEL, "altera_as%d",
> >>>> +			pdata->id);
> >>>> +	if (drvdata->miscdev.name == NULL)
> >>>> +		return -ENOMEM;
> >>>> +	drvdata->miscdev.fops = &altera_as_fops;
> >>>> +	if (misc_register(&drvdata->miscdev) < 0) {
> >>>
> >>> Hmm, how many devices can be in the system?
> >>
> >> Up to AS_MAX_DEVS, currently 16.
> >>
> >>> This doesn't look like the right way.
> >>
> >> What is the right way then?
> >
> > Ok, so for that count it definitely deserves its own major to not eat up
> > misc device space.
> 
> Ther are only as many minors allocates as needed, not always 16.
> Almost always there will be only one FPGA, maybe a couple, but
> more is very rare. And when that's the case there are probably
> not many other misc devices around either, or they use a more
> scalable way to program many FPGAs.
> 
> This is niche enough, don't make it more complicated than needed.
> Having its own major seems overkill.

I agree.

> >>>> +		kfree(drvdata->miscdev.name);
> >>>> +		return -ENODEV;
> >>>> +	}
> >>>> +	altera_as_devs[pdata->id].minor = drvdata->miscdev.minor;
> >>>> +	altera_as_devs[pdata->id].drvdata = drvdata;
> >>>
> >>> So now the device is usable without the mutex and gpios inited?
> >>
> >> I was thinking that the device lock which is being held during the .probe
> >> run,
> >> prevents the device from being open. After all I can still return -EGOAWAY
> >> at
> >> this point. Am I wrong?
> >>
> >> If so, I'll reorder this code.
> >
> > This cannot be done easily. You need to set drvdata prior to minor and
> > after all the assignments here. The former because in get_as_dev you
> > test minor and return drvdata. The latter because you use open_lock &
> > gpios after playing with minor & drvdata.
> >
> > Technically, it can be done with a use of barriers, but I don't
> > recommend it as drivers should not use barriers at all. You should
> > introduce some locking here (it introduces barriers on its own).
> >
> > So move the assignment to altera_as_devs below the mutex_init & gpios
> > setup and lock it appropriately. Then add a lock to get_as_dev.
> 
> Just put the misc_register() call at the end and it should be fine,
> once the array is gone.

Thanks again. You were immensely helpful.

Going to remove some lines of code. I love the sound it makes.

baruch

> >>>> +	mutex_init(&drvdata->open_lock);
> >>>> +
> >>>> +	drvdata->id = pdata->id;
> >>>> +
> >>>> +	drvdata->gpios[ASIO_DATA].gpio		= pdata->data;
> >>>> +	drvdata->gpios[ASIO_DATA].flags		= GPIOF_IN;
> >>>> +	drvdata->gpios[ASIO_DATA].label		= "as_data";
> >>> ...
> >>>> +	drvdata->gpios[ASIO_NCE].gpio		= pdata->nce;
> >>>> +	drvdata->gpios[ASIO_NCE].flags		= GPIOF_OUT_INIT_HIGH;
> >>>> +	drvdata->gpios[ASIO_NCE].label		= "as_nce";
> >>>> +
> >>>> +	dev_info(drvdata->dev, "Altera Cyclone Active Serial driver\n");
> >>>> +
> >>>> +	return 0;
> >>>> +}

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
