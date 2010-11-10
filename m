Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab0KJLxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 06:53:23 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:49676 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab0KJLxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 06:53:21 -0500
Date: Wed, 10 Nov 2010 13:52:55 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Indan Zupancic <indan@nul.nu>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCHv2] drivers/misc: Altera Cyclone active serial
 implementation
Message-ID: <20101110115255.GE26776@jasper.tkos.co.il>
References: <f04cbe31c7e03a9d798b30526a5fed1cd8ee4c7a.1289297142.git.baruch@tkos.co.il>
 <0d1a323315dcf505e64fb5165ea41e95.squirrel@webmail.greenhost.nl>
 <20101109153550.GD29441@jasper.tkos.co.il>
 <dbd33aac54791d5b5f33f03325b6b4bc.squirrel@webmail.greenhost.nl>
 <20101110055419.GA26776@jasper.tkos.co.il>
 <39a033e053cd6dee4faf7bb8d1083993.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39a033e053cd6dee4faf7bb8d1083993.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Indan,

On Wed, Nov 10, 2010 at 11:59:17AM +0100, Indan Zupancic wrote:
> On Wed, November 10, 2010 06:54, Baruch Siach wrote:
> > On Tue, Nov 09, 2010 at 09:15:09PM +0100, Indan Zupancic wrote:
> >> On Tue, November 9, 2010 16:35, Baruch Siach wrote:
> >
> > [snip]
> >
> >> >> > +static struct {
> >> >> > +	int minor;
> >> >> > +	struct cyclone_as_device *drvdata;
> >> >> > +} cyclone_as_devs[AS_MAX_DEVS];
> >> >> > +
> >> >> > +static struct cyclone_as_device *get_as_dev(int minor)
> >> >> > +{
> >> >> > +	int i;
> >> >> > +
> >> >> > +	for (i = 0; i < ARRAY_SIZE(cyclone_as_devs); i++)
> >> >>
> >> >> To me AS_MAX_DEVS looks clearer than ARRAY_SIZE(cyclone_as_devs).
> >> >
> >> > Not to me. The fact that AS_MAX_DEVS happens to be equal to
> >> > ARRAY_SIZE(cyclone_as_devs) is not relevant to the understanding of this
> >> > procedure. It just forces the reader to lookup the AS_MAX_DEVS value, and
> >> > distracts the reader's attention.
> >>
> >> Then just leave the AS_MAX_DEVS define away, it doesn't add anything.
> >
> > I use AS_MAX_DEVS to set the size of cyclone_as_devs. It documents why
> > this array is of that length.
> 
> The array size _is_ the limit of the number of devices. AS_MAX_DEVS now
> looks like some magical number coming from nowhere. But its source is
> that array size. So you can put the raw number in the array declaration
> and it's as clear as defining AS_MAX_DEVS a few lines higher.

Well, I beg to differ. To me the AS_MAX_DEVS define gives a meaning to a 
number. It says that the cyclone_as_devs array size (and, hence, the number of 
supported devices) is an arbitrary design decision, and not something that is 
inherent to the active serial protocol, like the delay values. I'd keep this 
define event if its only use is for the cyclone_as_devs size.

> >> Also change the:
> >>
> >> +	if (pdata->id >= AS_MAX_DEVS)
> >> +		return -ENODEV;
> >>
> >> to
> >>
> >> +	if (pdata->id >= ARRAY_SIZE(cyclone_as_devs))
> >> +		return -ENODEV;
> >>
> >> After all, what you're really checking is if the id falls within the
> >> array.
> >
> > The current code seems more clear to me. AS_MAX_DEVS expresses the reason
> > for not letting id exceed this value, and for having -ENODEV as return value.
> > The cyclone_as_devs boundary check is just a side effect.
> 
> (I agree that the current code looks more clear, I'm just trying to point
> out the inconsistency in the usage of AS_MAX_DEVS.)
> 
> But as you said above, if the "fact that AS_MAX_DEVS happens to be equal
> to ARRAY_SIZE(cyclone_as_devs) is not relevant to the understanding of
> this procedure", then you have to add an explicit array boundary check
> to make sure that the dev falls within the array, no? Otherwise, to see
> that the code is correct, you do have to understand that AS_MAX_DEVS
> happens to be equal to ARRAY_SIZE(cyclone_as_devs), which is something
> you wanted to avoid.

I said this in the context of the get_as_dev code which indeed iterates 
through the cyclone_as_devs elements, and thus needs the number of elements.  
No further knowledge is required.

Here, I chose to emphasize in the code that we verify the AS_MAX_DEVS limit, 
for the reasons stated above. Later, I rely on the side effect of this check 
when I access cyclone_as_devs elements. Although this does look a little less 
clear, I prefer this way on the other.

> Sorry for my nagging.

Not a problem :).

baruch

> > [snip]
> >
> >> >> > +	/* writes must be page aligned */
> >> >> > +	if (!AS_ALIGNED(*ppos) || !AS_ALIGNED(count))
> >> >> > +		return -EINVAL;
> >>
> >> As you're only incrementing ppos with the page size, is that first check
> >> really needed? I don't think anything else can change ppos.
> >
> > I'd rather be on the safe side here. Future extensions (like read or lseek
> > implementations) may change *ppos.
> 
> Yes, that is a good precaution, it's very easy to forget this check then.
> 
> But the only thing that makes writing work is the erase device when the
> first page is written, so non-streamed writes not starting at address 0
> will fail anyway. That said, that's a lot less subtle than the alignment
> thing, so just leave it as it is.
> 
> >> >> > +	page_count = *ppos / AS_PAGE_SIZE;
> >> >> > +
> >> >> > +	page_buf = kmalloc(AS_PAGE_SIZE, GFP_KERNEL);
> >> >> > +	if (page_buf == NULL)
> >> >> > +		return -ENOMEM;
> >> >> > +
> >> >> > +	if (*ppos == 0) {
> >> >> > +		u8 as_status;
> >> >> > +
> >> >> > +		xmit_cmd(drvdata->gpios, AS_WRITE_ENABLE);
> >> >> > +		xmit_cmd(drvdata->gpios, AS_ERASE_BULK);
> >> >> > +
> >> >> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> >> >> > +		xmit_byte(drvdata->gpios, AS_READ_STATUS);
> >> >> > +		for (i = 0; i < AS_ERASE_TIMEOUT; i++) {
> >> >> > +			as_status = recv_byte(drvdata->gpios);
> >> >> > +			if ((as_status & AS_STATUS_WIP) == 0)
> >> >> > +				break; /* erase done */
> >> >> > +			if (msleep_interruptible(1000) > 0) {
> >> >> > +				err = -EINTR;
> >> >> > +				break;
> >> >> > +			}
> >> >> > +		}
> >> >> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> >> >> > +		if ((as_status & AS_STATUS_WIP) && err == 0)
> >> >> > +			err = -EIO; /* erase timeout */
> >> >> > +		if (err)
> >> >> > +			goto out;
> >> >> > +		ndelay(300);
> >> >> > +	}
> >> >>
> >> >> I'd move this into its own function, erase_device() or something.
> >> >
> >> > OK.
> >> >
> >> >> (And drop the ndelay.)
> >> >
> >> > See above.
> >>
> >> In that case I'd move it to just after the gpio_set*.
> >
> > OK. My original rationale was to skip the delay in case of error, but this
> > micro-optimization doesn't worth the code obfuscation.
> 
> There's nothing preventing the caller to do another command on the device
> within 300ns, except a slow CPU, so it seems this delay is always needed.
> 
> Greetings,
> 
> Indan
> 
> 

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
