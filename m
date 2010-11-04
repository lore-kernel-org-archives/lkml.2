Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab0KDMVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 08:21:55 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:41965 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab0KDMVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 08:21:53 -0400
Date: Thu, 4 Nov 2010 14:20:56 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Indan Zupancic <indan@nul.nu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCH] drivers/misc: Altera Cyclone active serial
 implementation
Message-ID: <20101104122056.GB11249@jasper.tkos.co.il>
References: <879a6320efee16c04f0732a6887b95c1b4c6d10f.1288793522.git.baruch@tkos.co.il>
 <e15f89ec737d2478bf5edd5369028554.squirrel@webmail.greenhost.nl>
 <20101104064643.GA11249@jasper.tkos.co.il>
 <d8ecdedc03353ad14daa29178528255e.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8ecdedc03353ad14daa29178528255e.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Indan,

On Thu, Nov 04, 2010 at 12:57:22PM +0100, Indan Zupancic wrote:
> On Thu, November 4, 2010 07:46, Baruch Siach wrote:
> >>
> >> I think it would clear up the code a lot if you introduced a xmit_bytes()
> >> function which does the above for variable lengths, as well as the ASIO_NCS
> >> fiddling.
> >
> > I'll consider this for the next version. Keep in mind that we send a whole
> > command during nCS assertion, not arbitrary buffers. So, in the case of the
> > PAGE_PROGRAM command, we'll need to prepend the instruction and its address
> > argument to the page data. I'm not sure we end up with something more clear
> > than we have now.
> 
> You just have to make the buffer slightly bigger and do something like:
> 
> ret = copy_from_user(page_buf + 4, buf, AS_PAGE_SIZE);
> ...
> page_buf[0] = AS_PAGE_PROGRAM;
> page_buf[1] = (page_count >> 8) & 0xff;
> page_buf[2] = page_count & 0xff;
> page_buf[3] = 0;
> 
> Which doesn't look too bad.

OK.

> (Btw, aren't [1] and [2] accidentally swapped? If it supports three
> address bytes as you say below, then middle-low-high byte seems like
> a weird order.)

I was wrong about this. I checked the spec again, and it seems that the 24bit 
PAGE_PROGRAM parameter is a byte pointer, not page pointer. So we can change 
page_count to u16 after all.

> 
> >> Also pass in drvdata and get the gpios from there in this function,
> >> you never have the one without the other.
> >
> > So? I want to avoid the 'drvdata->' prefix when it's not needed.
> 
> Good point. Perhaps add a temporary var holding the pointer if after
> the changes there's still drvdata->gpios everywhere.

OK.

> >> You don't unlock open_lock, so this supports only one user at the time?
> >
> > Correct. I don't think anything good will come out of concurrent writes to the
> > FPGA, and read is not supported.
> 
> Seems sensible.
> 
> >> unsigned short?
> >
> > The largest chip currently supporting this protocol (EPCS128) has 2^16 pages,
> > but the protocol allocates 3 address bytes. So why limit ourselves? Currently
> > the code only uses the 16 LSBs, I'll change this.
> 
> I think you should add a check to see if page_count isn't too big,
> or else things go silently wrong when the caller supplies a too big
> value.
> 
> >> Is 5s always enough? Is there some way to check if it's really done?
> >
> > You are right. 5 seconds are definitely not enough for the larger chips
> > (typical time of 105 seconds for EPCS128). I'll poll the "write in progress"
> > bit instead. More code to write :(.
> 
> If it takes that long, just poll every second or so I guess.

OK. I'm now implementing this. Also, ignoring the return value of 
msleep_interruptible() is a terrible mistake. I've posted a patch earlier 
today that makes it __must_check.

> >> Maybe check the whole range before sending any data?
> >
> > What is there to check?
> 
> The whole range of 'buf'. If the copy_from_user fails later on you end
> up with a partially programmed FPGA. No big deal, but avoidable.

OK.

> Maybe annotate buf with __user to keep Sparse happy?
> 
> static ssize_t cyclone_as_write(struct file *file, const char __user *buf,
> 		size_t count, loff_t *ppos)

No problem.

> >> > diff --git a/include/linux/cyclone_as.h b/include/linux/cyclone_as.h
> >> > new file mode 100644
> >> > index 0000000..cf86955
> >> > --- /dev/null
> >> > +++ b/include/linux/cyclone_as.h
> >> > @@ -0,0 +1,23 @@
> >> > +/*
> >> > + * Copyright 2010 Alex Gershgorin, Orex Computed Radiography
> >> > + *
> >> > + * The code contained herein is licensed under the GNU General Public
> >> > + * License. You may obtain a copy of the GNU General Public License
> >> > + * Version 2 or later at the following locations:
> >> > + *
> >> > + * http://www.opensource.org/licenses/gpl-license.html
> >> > + * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
> >> > + */
> >> > +
> >> > +#ifndef __ALTERA_PROG_H
> >> > +#define __ALTERA_PROG_H
> >> > +
> >> > +struct cyclone_as_platform_data {
> >> > +	unsigned data;
> >> > +	unsigned nconfig;
> >> > +	unsigned dclk;
> >> > +	unsigned ncs;
> >> > +	unsigned nce;
> >> > +};
> >> > +
> >> > +#endif /* __ALTERA_PROG_H */
> >>
> >> I know other drivers put their header files in include/linux/ too,
> >> but is there any reason to? This seems all internal to cyclone_as.c,
> >> why not have no header file?
> >
> > This part is not internal at all. Using this struct the platform code (knowing
> > the actual machine specific GPIO wiring) passes this information to the
> > driver.
> 
> Except if I'm missing some build system voodoo, no, it's totally internal.
> The driver sets it, no one else knows about it:
> 
> +static int __init cyclone_as_probe(struct platform_device *pdev)
> +{
> +	int ret, minor;
> +	struct cyclone_as_device *drvdata;
> +	struct device *dev;
> +	struct cyclone_as_platform_data *pdata = pdev->dev.platform_data;
> +
> +	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
> 
> I'm sure that dev.platform_data is void*.

I'm setting dev.platform_data somewhere under arch/ as follows:

static struct cyclone_as_platform_data altera_prog_info = {
        .data           = 102,
        .nconfig        = 105,
        .dclk           = 103,
        .ncs            = 106,
        .nce            = 104,
};

static struct platform_device fpga_prog_device = {
        .name = "cyclone_as",
        .dev = {
                .platform_data = &altera_prog_info,
        }
};

And then:

        platform_device_register(&fpga_prog_device);

This is a very common patters in the arch/ underworld. I need struct 
cyclone_as_platform_data to be visible for this.

> >> Probably not high on your list, but what about suspend support?
> >> Preventing suspend from succeeding seems like a good idea when
> >> stuff is going on.
> >
> > I'm not sure we should impose a suspend prevention in this case. The user
> > should bear the consequences if he/she decides to suspend the system in the
> > middle of FPGA programming. Maybe we should just warn.
> 
> I don't think any user would ever want to suspend in the middle of
> FPGA programming. So if it happens it's most likely a mistake or
> some automatic suspend. Both should fail. The code to fail is
> slightly simpler than the code to warn too. So I'd say either let
> it fail or keep your code simpler and ignore it altogether.

I think I'll go for the latter for now. This can always be added later.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
