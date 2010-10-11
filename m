Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0JKLX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 07:23:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39028 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954Ab0JKLX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 07:23:27 -0400
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Catalin Marinas <catalin.marinas@arm.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <AANLkTinMuKDpbL9ka61QhUFJfze_HWWHxjUbAqbz2_vi@mail.gmail.com>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	 <20101007192245.GC26435@n2100.arm.linux.org.uk>
	 <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	 <20101008175308.GA10975@n2100.arm.linux.org.uk>
	 <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com>
	 <20101008230451.GB10975@n2100.arm.linux.org.uk>
	 <20101008232539.GA28697@kroah.com>
	 <20101008234448.GD10975@n2100.arm.linux.org.uk>
	 <20101009000046.GA30616@kroah.com>
	 <20101009002546.GB14675@n2100.arm.linux.org.uk>
	 <alpine.LFD.2.00.1010082210150.3107@xanadu.home>
	 <1286791544.19739.31.camel@e102109-lin.cambridge.arm.com>
	 <AANLkTinMuKDpbL9ka61QhUFJfze_HWWHxjUbAqbz2_vi@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 11 Oct 2010 12:23:07 +0100
Message-ID: <1286796187.19739.52.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Oct 2010 11:23:07.0878 (UTC) FILETIME=[AE031860:01CB6936]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-11 at 11:39 +0100, Felipe Contreras wrote:
> On Mon, Oct 11, 2010 at 1:05 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > We could be a bit more flexible as a temporary solution. But that's a
> > hack and doesn't guarantee the attributes that the driver requested. If
> > the driver would use writel/readl, that's not too bad since we pushed
> > explicit barriers in these macros.
> >
> > It would need to be improved to invalidate the corresponding cache lines
> > (using the DMA API?) but it would look even worse.
> >
> >
> > diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
> > index 6bdf42c..082bbd0 100644
> > --- a/arch/arm/mm/ioremap.c
> > +++ b/arch/arm/mm/ioremap.c
> > @@ -204,10 +204,13 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
> >  #endif
> >
> >        /*
> > -        * Don't allow RAM to be mapped - this causes problems with ARMv6+
> > +        * Don't allow RAM to be mapped as Device memory - this causes
> > +        * problems with ARMv6+
> >         */
> >        if (WARN_ON(pfn_valid(pfn)))
> > -               return NULL;
> > +               if (__LINUX_ARM_ARCH__ >= 6 &&
> > +                   (mtype != MT_DEVICE_CACHED || mtype != MT_DEVICE_WC))
> > +                       mtype = MT_DEVICE_WC;
> >
> >        type = get_mem_type(mtype);
> >        if (!type)
> 
> I will try that, but from what I can see this might still break some
> drivers, right? 

Probably, it depends on how drivers use the memory returned by ioremap
and the assumptions they make about the memory type (strict ordering,
write buffers, speculation). I think such memory should be used via the
I/O accessors and not directly, so you get the benefit of explicit
memory barriers. If not, you have to cope with the loss of attributes
because of the WC mapping.

But as it has been said (and it's my opinion as well), the drivers are
broken and are misusing the ioremap API.

> Anyway, I'm reading the TRM and I can't find any mention of this.
> Catalin, can you point out where is this mentioned, and also, can you
> confirm if this would affect only the memory that has the double
> mapping, or it can corrupt other memory as well?

That's in the ARM ARM (Architecture Reference Manual), not a TRM.

You never know what "unpredictable" means and this is specific to the
processor implementation, not the ARM ARM. You should not mix different
memory types for the same page.

Back in 2006 there was a discussion for a set of palliative measures in
hardware (initially until the OSes are fixed) and these allow the same
memory type but with different cacheability attributes (e.g. Normal
Non-cacheable vs Normal Cacheable) given that care is taken in software
wrt stale cache lines and speculation (but at least you don't get random
corruption somewhere else). They would need to have the same
shareability attributes though.

With the hack above, MT_DEVICE_WC is actually Normal Non-cacheable
memory. It needs cache flushing but it's not worse than the original
ioremap allowing this. The driver may not work as expected though.

-- 
Catalin

