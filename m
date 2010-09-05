Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab0IEGeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 02:34:18 -0400
Received: from kroah.org ([198.145.64.141]:45281 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab0IEGeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 02:34:04 -0400
Date: Sat, 4 Sep 2010 22:17:57 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] West Bridge Astoria Driver 2.6.35, Kconfig and HAL
	fixes
Message-ID: <20100905051757.GA4354@kroah.com>
References: <5BFACB1451C1459BA8562A5561D0A4E6@stanford.edu> <1283386101.17399.10.camel@odc-laptop> <1283467434.4378.11.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283467434.4378.11.camel@odc-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 03:43:54PM -0700, David Cross wrote:
> On Wed, 2010-09-01 at 17:08 -0700, David Cross wrote:
>  From: Greg KH [mailto:greg@kroah.com] 
> > Sent: Tuesday, August 31, 2010 9:32 AM
> > To: David Cross
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] West Bridge Astoria Driver 2.6.35
> > 
> > On Tue, Aug 31, 2010 at 09:17:18AM -0700, David Cross wrote:
> > > 
> > > > I get a build error when I try to build this driver:
> > > >
> > > drivers/staging/westbridge/astoria/block/../include/linux/westbridge/c>
> > > yasmisc.h:521:2: error: expected declaration specifiers or '...' before  >
> > > 'cy_as_hal_device_tag'
> > > 
> > > > It looks like the #include mess isn't working quite properly.
> > > 
> > > > Also note that this driver is building on an x86-64 platform, which is
> > > > something that you probably don't want :)
> > > 
> > > > So, for now, I'll just mark the driver as CONFIG_BROKEN and can you send
> > > > me some Kconfig patches against the next linux-next release which should
> > > > have this driver in it, so that it will build properly?
> > > 
> > > Sure, I can do that. I have since changed the Kconfig structure a bit. It
> > > actually will build properly with the correct .config as it is though. I
> > can
> > > send you the .config if you would like.
> > 
> > It's up to the Kconfig rules to ensure that there can never be a
> > "non-correct" .config file, so that needs to be fixed so that the build
> > will never be broken no matter what type of options are selected.
> > 
> > Care to send a patch for that?
> 
> This patch actually contains the KConfig changes necessary an additional
> HAL layer.

Note, when sending a patch, don't include all of the stuff above, that
makes no sense.

Also, your Subject: should be a bit cleaner.  For example, I would edit
this subject from:

  Subject: Re: [PATCH] West Bridge Astoria Driver 2.6.35, Kconfig and HAL fixes

to

  Subject: [PATCH] Staging: westbridge: Kconfig and HAL fixes

The kernel version doesn't matter as I can't patch an old kernel, right?
:)

> The Kconfig changes are pretty closely related to this HAL
> layer, as such this patch is difficult to logically separate. The HAL
> layers also rely on the export of some gpmc functions, which are added
> to this patch. Although I don't own this driver, it is difficult for me
> to understand why there would be issues with exporting these symbols.
> The linux-next tree does not seem to have a config for the zoom2, and
> trying to build it for that board seems to make the compilation break.
> As such, the only thing that I tested was compilation using the two
> different HALs (one of which is added in this patch). Please let me know
> if there are problems or questions with this.
> Thanks,
> David
> 
> Signed-off-by: David Cross <david.cross@cypress.com>

You really need all of this at once to fix the Kconfig issues?  It's a
huge patch, what happened that made it needed?

> diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/arch/arm/mach-omap2/gpmc.c linux-next-incl-sdk/arch/arm/mach-omap2/gpmc.c
> --- linux-next-vanilla/arch/arm/mach-omap2/gpmc.c	2010-08-31 19:32:51.000000000 -0700
> +++ linux-next-incl-sdk/arch/arm/mach-omap2/gpmc.c	2010-09-01 16:10:21.000000000 -0700
> @@ -133,6 +133,7 @@ void gpmc_cs_write_reg(int cs, int idx, 
>  	reg_addr = gpmc_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
>  	__raw_writel(val, reg_addr);
>  }
> +EXPORT_SYMBOL(gpmc_cs_write_reg);
>  
>  u32 gpmc_cs_read_reg(int cs, int idx)
>  {
> @@ -141,6 +142,7 @@ u32 gpmc_cs_read_reg(int cs, int idx)
>  	reg_addr = gpmc_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
>  	return __raw_readl(reg_addr);
>  }
> +EXPORT_SYMBOL(gpmc_cs_read_reg);
>  
>  /* TODO: Add support for gpmc_fck to clock framework and use it */
>  unsigned long gpmc_get_fclk_period(void)
> @@ -294,6 +296,7 @@ int gpmc_cs_set_timings(int cs, const st
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL(gpmc_cs_set_timings);
>  
>  static void gpmc_cs_enable_mem(int cs, u32 base, u32 size)
>  {

Sorry, I can't change things outside of the drivers/staging/ directory
unless you get the maintainer/owner of this file to agree to export
these symbols.

Can you do that as a separate patch and get their ack?  Then I can apply
it.

Also, how about "EXPORT_SYMBOL_GPL()" instead?

So, care to redo this patch?

thanks,

greg k-h
