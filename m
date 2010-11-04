Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab0KDNhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:37:25 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:43818 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab0KDNhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:37:23 -0400
Date: Thu, 4 Nov 2010 15:37:02 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Indan Zupancic <indan@nul.nu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCH] drivers/misc: Altera Cyclone active serial
 implementation
Message-ID: <20101104133702.GC11249@jasper.tkos.co.il>
References: <879a6320efee16c04f0732a6887b95c1b4c6d10f.1288793522.git.baruch@tkos.co.il>
 <e15f89ec737d2478bf5edd5369028554.squirrel@webmail.greenhost.nl>
 <20101104064643.GA11249@jasper.tkos.co.il>
 <d8ecdedc03353ad14daa29178528255e.squirrel@webmail.greenhost.nl>
 <20101104122056.GB11249@jasper.tkos.co.il>
 <8af4637640a0128476ac3b271f532f56.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8af4637640a0128476ac3b271f532f56.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Indan,

On Thu, Nov 04, 2010 at 02:09:41PM +0100, Indan Zupancic wrote:
> On Thu, November 4, 2010 13:20, Baruch Siach wrote:
> > I was wrong about this. I checked the spec again, and it seems that the 24bit
> > PAGE_PROGRAM parameter is a byte pointer, not page pointer. So we can change
> > page_count to u16 after all.
> 
> If it's a byte pointer, then isn't page_count totally wrong?
> If it's not the page count, then it should be named differently.

No. It is a page_count. Appending one zero byte to page_count makes the page 
pointer a byte pointer.

> For your next submission, can you test if this driver can successfully
> program a FPGA? I mean, including a test to see if all the code made
> it to the FPGA, to catch short writes.

The driver does program FPGAs successfully. I test it after every change using 
two .rdp images. Each image makes the FPGA blink a LED is a slightly different 
way.

> If the protocol doesn't allow
> reads, how are you supposed to check if the programming was really
> successful? Is there a CRC somewhere or anything?

The protocol does allow reads. I just haven't implemented it. This is going to 
be the job of someone else.

> I'd also get rid of "len" and use "count" directly. You have to
> check if "count" and/or *ppos + count isn't too big anyway. Or
> use len instead of page_count. I don't know. Maybe change the
> while into a for loop?

I'll consider this.

> +		ret = copy_from_user(page_buf, buf, AS_PAGE_SIZE);
> +		if (ret == 0) {
> +			buf += AS_PAGE_SIZE;
> +			*ppos += AS_PAGE_SIZE;
> +			len -= AS_PAGE_SIZE;
> +		} else {
> +			kfree(page_buf);
> +			return -EFAULT;
> +		}
> 
> I'd change that into:
> 
> +		ret = copy_from_user(page_buf, buf, AS_PAGE_SIZE);
> +		if (ret) {
> +			kfree(page_buf);
> +			return -EFAULT;
> +		}
> +		buf += AS_PAGE_SIZE;
> +		*ppos += AS_PAGE_SIZE;
> +		len -= AS_PAGE_SIZE;

Just did before seeing your reply :).

> > OK. I'm now implementing this. Also, ignoring the return value of
> > msleep_interruptible() is a terrible mistake. I've posted a patch
> > earlier today that makes it __must_check.
> 
> Also if you don't care if it slept for shorter?

If you don't care than why sleep longer? If you need the delay you must make 
sure it doesn't get shorter than expected.

> > I'm setting dev.platform_data somewhere under arch/ as follows:
> >
> > static struct cyclone_as_platform_data altera_prog_info = {
> >         .data           = 102,
> >         .nconfig        = 105,
> >         .dclk           = 103,
> >         .ncs            = 106,
> >         .nce            = 104,
> > };
> >
> > static struct platform_device fpga_prog_device = {
> >         .name = "cyclone_as",
> >         .dev = {
> >                 .platform_data = &altera_prog_info,
> >         }
> > };
> >
> > And then:
> >
> >         platform_device_register(&fpga_prog_device);
> >
> > This is a very common patters in the arch/ underworld. I need struct
> > cyclone_as_platform_data to be visible for this.
> 
> Thanks for the explanation.
> 
> I mixed up drvdata with pdata, so yeah, you're right.
> 
> Shouldn't you add this platform bit to the patch? A platform driver
> with no users seems a bit useless.

I'm keeping my platform code private for now. May platform drivers have no 
user under arch/, but it doesn't mean they are not being used. See, for 
example, the DesignWare I2C bus driver (drivers/i2c/busses/i2c-designware.c).  
Anyway, the custom is to put drivers code and platform code in separate 
patches. They tend to go to different trees/maintainers.

> >> >> Probably not high on your list, but what about suspend support?
> >> >> Preventing suspend from succeeding seems like a good idea when
> >> >> stuff is going on.
> >> >
> >> > I'm not sure we should impose a suspend prevention in this case. The user
> >> > should bear the consequences if he/she decides to suspend the system in
> >> the
> >> > middle of FPGA programming. Maybe we should just warn.
> >>
> >> I don't think any user would ever want to suspend in the middle of
> >> FPGA programming. So if it happens it's most likely a mistake or
> >> some automatic suspend. Both should fail. The code to fail is
> >> slightly simpler than the code to warn too. So I'd say either let
> >> it fail or keep your code simpler and ignore it altogether.
> >
> > I think I'll go for the latter for now. This can always be added later.
> 
> As long as this isn't used for very expensive OTP FPGAs handling
> suspend is not that important...

As far as I know this protocol is not for OTP FPGAs. Anyone doing expensive 
expensive OTP FPGAs programming, should have the resources to either protect 
the machine from being suspended, or write the code to make sure it doesn't 
happen.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
