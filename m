Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206Ab0JIDEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 23:04:13 -0400
Received: from kroah.org ([198.145.64.141]:44884 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760166Ab0JIDEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 23:04:12 -0400
Date: Fri, 8 Oct 2010 20:04:55 -0700
From: Greg KH <greg@kroah.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101009030455.GB5913@kroah.com>
References: <20101007192245.GC26435@n2100.arm.linux.org.uk> <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com> <20101008175308.GA10975@n2100.arm.linux.org.uk> <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com> <20101008230451.GB10975@n2100.arm.linux.org.uk> <20101008232539.GA28697@kroah.com> <20101008234448.GD10975@n2100.arm.linux.org.uk> <20101009000046.GA30616@kroah.com> <20101009002546.GB14675@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1010082210150.3107@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010082210150.3107@xanadu.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 10:41:42PM -0400, Nicolas Pitre wrote:
> On Sat, 9 Oct 2010, Russell King - ARM Linux wrote:
> 
> > On Fri, Oct 08, 2010 at 05:00:46PM -0700, Greg KH wrote:
> > > But you can't expect that you make this change, and not fix up the
> > > drivers, and people would be happy, right?  The rule for API changes
> > > like this, or anything, is that the person making the change fixes the
> > > other drivers, and that seems to be the issue here.
> > 
> > Let's entirely revert the change and wait for people's data to be
> > corrupted then.  I don't have the time nor the motivation to work
> > through crap driver code to fix up these unreliable games which are
> > already illegal on platforms such as x86.
> > 
> > If people want their system to be unpredictable, then let's carry on
> > giving them the rope to hang themselves in that manner.
> > 
> > > Any pointers to patches where people have fixed up the drivers?
> > 
> > Despite the discussion, I'm unaware of anyone really taking the issue
> > seriously and producing any patches during the last six months.
> > 
> > So, I say sod it, let's revert the change.
> 
> I think that the real issue here is to avoid breaking those drivers 
> which were using this legitimately.  So what about this compromize 
> instead:
> 
> diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
> index 99627d3..4f071e4 100644
> --- a/arch/arm/mm/ioremap.c
> +++ b/arch/arm/mm/ioremap.c
> @@ -201,6 +201,15 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
>  	if (pfn >= 0x100000 && (__pfn_to_phys(pfn) & ~SUPERSECTION_MASK))
>  		return NULL;
>  
> +	/*
> +	 * Warn if RAM is mapped to discourage this usage. Let's forbid it
> +	 * outright on ARMv6+ where this became architecturally undefined
> +	 * in theory and causes memory corruption in practice.
> +	 */
> +	if (WARN_ON(pfn_valid(pfn)))
> +		if (__LINUX_ARM_ARCH__ >= 6)
> +			return NULL;
> +
>  	type = get_mem_type(mtype);
>  	if (!type)
>  		return NULL;
> 

That looks good to me, anyone else object to this?

Now we also need a way to fix the drivers for real on ARMv6+ now...

thanks,

greg k-h
