Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0JKKGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 06:06:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33710 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640Ab0JKKGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 06:06:11 -0400
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Greg KH <greg@kroah.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <alpine.LFD.2.00.1010082210150.3107@xanadu.home>
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
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 11 Oct 2010 11:05:44 +0100
Message-ID: <1286791544.19739.31.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Oct 2010 10:05:45.0650 (UTC) FILETIME=[DF075120:01CB692B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-09 at 03:41 +0100, Nicolas Pitre wrote:
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
>         if (pfn >= 0x100000 && (__pfn_to_phys(pfn) & ~SUPERSECTION_MASK))
>                 return NULL;
> 
> +       /*
> +        * Warn if RAM is mapped to discourage this usage. Let's forbid it
> +        * outright on ARMv6+ where this became architecturally undefined
> +        * in theory and causes memory corruption in practice.
> +        */
> +       if (WARN_ON(pfn_valid(pfn)))
> +               if (__LINUX_ARM_ARCH__ >= 6)
> +                       return NULL;
> +
>         type = get_mem_type(mtype);
>         if (!type)
>                 return NULL;

We could be a bit more flexible as a temporary solution. But that's a
hack and doesn't guarantee the attributes that the driver requested. If
the driver would use writel/readl, that's not too bad since we pushed
explicit barriers in these macros.

It would need to be improved to invalidate the corresponding cache lines
(using the DMA API?) but it would look even worse.


diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 6bdf42c..082bbd0 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -204,10 +204,13 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 #endif
 
 	/*
-	 * Don't allow RAM to be mapped - this causes problems with ARMv6+
+	 * Don't allow RAM to be mapped as Device memory - this causes
+	 * problems with ARMv6+
 	 */
 	if (WARN_ON(pfn_valid(pfn)))
-		return NULL;
+		if (__LINUX_ARM_ARCH__ >= 6 &&
+		    (mtype != MT_DEVICE_CACHED || mtype != MT_DEVICE_WC))
+			mtype = MT_DEVICE_WC;
 
 	type = get_mem_type(mtype);
 	if (!type)



-- 
Catalin

