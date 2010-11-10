Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab0KJFyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 00:54:45 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:44301 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab0KJFyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 00:54:43 -0500
Date: Wed, 10 Nov 2010 07:54:20 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Indan Zupancic <indan@nul.nu>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCHv2] drivers/misc: Altera Cyclone active serial
 implementation
Message-ID: <20101110055419.GA26776@jasper.tkos.co.il>
References: <f04cbe31c7e03a9d798b30526a5fed1cd8ee4c7a.1289297142.git.baruch@tkos.co.il>
 <0d1a323315dcf505e64fb5165ea41e95.squirrel@webmail.greenhost.nl>
 <20101109153550.GD29441@jasper.tkos.co.il>
 <dbd33aac54791d5b5f33f03325b6b4bc.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbd33aac54791d5b5f33f03325b6b4bc.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Indan,

On Tue, Nov 09, 2010 at 09:15:09PM +0100, Indan Zupancic wrote:
> On Tue, November 9, 2010 16:35, Baruch Siach wrote:

[snip]

> >> > +static struct {
> >> > +	int minor;
> >> > +	struct cyclone_as_device *drvdata;
> >> > +} cyclone_as_devs[AS_MAX_DEVS];
> >> > +
> >> > +static struct cyclone_as_device *get_as_dev(int minor)
> >> > +{
> >> > +	int i;
> >> > +
> >> > +	for (i = 0; i < ARRAY_SIZE(cyclone_as_devs); i++)
> >>
> >> To me AS_MAX_DEVS looks clearer than ARRAY_SIZE(cyclone_as_devs).
> >
> > Not to me. The fact that AS_MAX_DEVS happens to be equal to
> > ARRAY_SIZE(cyclone_as_devs) is not relevant to the understanding of this
> > procedure. It just forces the reader to lookup the AS_MAX_DEVS value, and
> > distracts the reader's attention.
> 
> Then just leave the AS_MAX_DEVS define away, it doesn't add anything.

I use AS_MAX_DEVS to set the size of cyclone_as_devs. It documents why this 
array is of that length.

> Also change the:
> 
> +	if (pdata->id >= AS_MAX_DEVS)
> +		return -ENODEV;
> 
> to
> 
> +	if (pdata->id >= ARRAY_SIZE(cyclone_as_devs))
> +		return -ENODEV;
> 
> After all, what you're really checking is if the id falls within the
> array.

The current code seems more clear to me. AS_MAX_DEVS expresses the reason for 
not letting id exceed this value, and for having -ENODEV as return value. The 
cyclone_as_devs boundary check is just a side effect.

[snip]

> >> > +	/* writes must be page aligned */
> >> > +	if (!AS_ALIGNED(*ppos) || !AS_ALIGNED(count))
> >> > +		return -EINVAL;
> 
> As you're only incrementing ppos with the page size, is that first check
> really needed? I don't think anything else can change ppos.

I'd rather be on the safe side here. Future extensions (like read or lseek 
implementations) may change *ppos.

> >> > +	page_count = *ppos / AS_PAGE_SIZE;
> >> > +
> >> > +	page_buf = kmalloc(AS_PAGE_SIZE, GFP_KERNEL);
> >> > +	if (page_buf == NULL)
> >> > +		return -ENOMEM;
> >> > +
> >> > +	if (*ppos == 0) {
> >> > +		u8 as_status;
> >> > +
> >> > +		xmit_cmd(drvdata->gpios, AS_WRITE_ENABLE);
> >> > +		xmit_cmd(drvdata->gpios, AS_ERASE_BULK);
> >> > +
> >> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> >> > +		xmit_byte(drvdata->gpios, AS_READ_STATUS);
> >> > +		for (i = 0; i < AS_ERASE_TIMEOUT; i++) {
> >> > +			as_status = recv_byte(drvdata->gpios);
> >> > +			if ((as_status & AS_STATUS_WIP) == 0)
> >> > +				break; /* erase done */
> >> > +			if (msleep_interruptible(1000) > 0) {
> >> > +				err = -EINTR;
> >> > +				break;
> >> > +			}
> >> > +		}
> >> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> >> > +		if ((as_status & AS_STATUS_WIP) && err == 0)
> >> > +			err = -EIO; /* erase timeout */
> >> > +		if (err)
> >> > +			goto out;
> >> > +		ndelay(300);
> >> > +	}
> >>
> >> I'd move this into its own function, erase_device() or something.
> >
> > OK.
> >
> >> (And drop the ndelay.)
> >
> > See above.
> 
> In that case I'd move it to just after the gpio_set*.

OK. My original rationale was to skip the delay in case of error, but this 
micro-optimization doesn't worth the code obfuscation.

baruch

> > Thanks,
> >
> > baruch
> >
> 
> You're welcome.
> 
> Greetings,
> 
> Indan

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
