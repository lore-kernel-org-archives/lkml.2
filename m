Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab2ISQog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:44:36 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:11786 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756486Ab2ISQoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:44:32 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+e9ouWskCnQHjDBmG7elCs
Date: Wed, 19 Sep 2012 09:44:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Felipe Balbi <felipe.balbi@nokia.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, sricharan <r.sricharan@ti.com>
Subject: Re: [PATCH 17/24] ARM: OMAP: use __iomem pointers for MMIO
Message-ID: <20120919164424.GD11762@atomide.com>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
 <20120916203850.GI4521@atomide.com>
 <20120917212506.GB11762@atomide.com>
 <201209191335.48051.arnd@arndb.de>
 <20120919133648.GB6106@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919133648.GB6106@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [120919 06:42]:
> On Wed, Sep 19, 2012 at 01:35:47PM +0000, Arnd Bergmann wrote:
> > On Monday 17 September 2012, Tony Lindgren wrote:
> > > * Tony Lindgren <tony@atomide.com> [120916 13:39]:
> > > > * Arnd Bergmann <arnd@arndb.de> [120915 13:15]:
> > > > > On Saturday 15 September 2012, Tony Lindgren wrote:
> > > > > > With my patches, this is now all omap1 specific and
> > > > > > moved to arch/arm/mach-omap1/include/mach/hardware.h.
> > > > > > It's probably easiest to just update this patch on
> > > > > > top of the hardware.h changes I've done.
> > > > > 
> > > > > Yes, sounds good. Do you want to send a patch for that
> > > > > and let me drop this one then?
> > > > 
> > > > Yes I can pick this one and update it against one of my
> > > > branches to avoid merge conflicts.
> > > 
> > > This applies against mach-omap1/include/mach/hardware.h
> > > with some fuzz so no issues there.
> > > 
> > > But I think we should not apply it as these are physical
> > > addresses, not virtual addresses for omap1.
> > 
> > Right, I misread what is actually going on here because the
> > only driver I looked at treated the address as a virtual
> > address pointer.
> > 
> > > We have IOMEM already in use for omap_read/write because of:
> > > 
> > > #define OMAP1_IO_ADDRESS(pa)    IOMEM((pa) - OMAP1_IO_OFFSET)
> > > 
> > > I think the right solution is to eventually get rid of
> > > omap_read/write for omap1 also and replace them with ioremap
> > > + readl/writel.
> > 
> > Agreed.

OK.
 
> > > Or am I missing something?
> > 
> > I did not see any new warnings for omap1, but I did see this
> > on omap2plus_defconfig:
> > 
> > drivers/watchdog/omap_wdt.c: In function 'omap_wdt_ioctl':
> > drivers/watchdog/omap_wdt.c:222:4: error: passing argument 1 of '__raw_readw' makes pointer from integer without a cast [-Werror]
> > arch/arm/include/asm/io.h:71:90: note: expected 'const volatile void *' but argument is of type 'unsigned int'
> > 
> > It seems I misinterpreted this, and it's actually a bug in the watchdog
> > driver that should be fixed using this patch instead (and backport it
> > to stable)
> > 
> > diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
> > index fceec4f..7b45802 100644
> > --- a/drivers/watchdog/omap_wdt.c
> > +++ b/drivers/watchdog/omap_wdt.c
> > @@ -218,9 +218,11 @@ static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
> >  	case WDIOC_GETSTATUS:
> >  		return put_user(0, (int __user *)arg);
> >  	case WDIOC_GETBOOTSTATUS:
> > +#ifdef CONFIG_ARCH_OMAP1
> >  		if (cpu_is_omap16xx())
> > -			return put_user(__raw_readw(ARM_SYSST),
> > +			return put_user(omap_readw(ARM_SYSST),
> >  					(int __user *)arg);
> > +#endif
> 
> indeed... my bad. I agree this should be changed by something better
> though.

Yes that's wrong.

Regards,

Tony
