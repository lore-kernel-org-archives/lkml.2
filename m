Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab0JKIfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 04:35:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50021 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab0JKIfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 04:35:15 -0400
Date: Mon, 11 Oct 2010 10:35:08 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Contreras <felipe.contreras@gmail.com>, Greg KH <greg@kroah.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101011083508.GW29673@pengutronix.de>
References: <20101007192245.GC26435@n2100.arm.linux.org.uk> <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com> <20101008175308.GA10975@n2100.arm.linux.org.uk> <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com> <20101008230451.GB10975@n2100.arm.linux.org.uk> <20101008232539.GA28697@kroah.com> <20101008234448.GD10975@n2100.arm.linux.org.uk> <AANLkTinhwORqdWU43yr1AXJGZm2zPKGG+Q9twruNs2aH@mail.gmail.com> <20101009092127.GB20975@n2100.arm.linux.org.uk> <AANLkTimQJLmDZPHtVJLCv9ZQgx_Yjh9=MOwOxMSAz4QX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimQJLmDZPHtVJLCv9ZQgx_Yjh9=MOwOxMSAz4QX@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
 
On Sun, Oct 10, 2010 at 04:52:36AM +0300, Felipe Contreras wrote:
> On Sat, Oct 9, 2010 at 12:21 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > static unsigned long reserve_mem(struct meminfo *mi, unsigned long size)
> > {
> >        unsigned long addr = ~0;
> >        int i;
> >
> >        for (i = mi->nr_banks - 1; i >= 0; i--)
> >                if (mi->bank[i].size >= size) {
> >                        mi->bank[i].size -= size;
> >                        addr = mi->bank[i].start + mi->bank[i].size;
> >                        break;
> >                }
> >
> >        return addr;
> > }
> >
> > static void __init my_fixup(struct machine_desc *desc, struct tag *tags,
> >                            char **cmdline, struct meminfo *mi)
> > {
> >        omapfb_buffer_phys = reserve_mem(mi, 32*1048576);
> >        if (omapfb_buffer_phys == ~0)
> >                pr_warn("Unable to allocate omapfb buffer\n");
> > }
> >
> > Then later:
> >
> >        omapfb_buffer = ioremap(omapfb_buffer_phys, 32*1048576);
> >
> > That's a damned simple and direct implementation of exactly what I
> > described, and results in something which is much more architecturally
> > correct than what's going on today.
> 
> I tried this, it doesn't work.
Ack, didn't work.  I tried it for arch/arm/mach-mx3/mach-pcm037.c.

> 
> At the time 'fixup' is called, 'meminfo' is empty; the tags haven't
> been parsed. So my solution is to move the memblock_add() after
> 'reserve', and pass 'meminfo' as an argument:
> 
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -272,8 +272,6 @@ void __init arm_memblock_init(struct meminfo *mi,
> struct machine_desc *mdesc)
>         int i;
> 
>         memblock_init();
> -       for (i = 0; i < mi->nr_banks; i++)
> -               memblock_add(mi->bank[i].start, mi->bank[i].size);
> 
>         /* Register the kernel text, kernel data and initrd with memblock. */
>  #ifdef CONFIG_XIP_KERNEL
> @@ -295,7 +293,10 @@ void __init arm_memblock_init(struct meminfo *mi,
> struct machine_desc *mdesc)
> 
>         /* reserve any platform specific memblock areas */
>         if (mdesc->reserve)
> -               mdesc->reserve();
> +               mdesc->reserve(mi);
> +
> +       for (i = 0; i < mi->nr_banks; i++)
> +               memblock_add(mi->bank[i].start, mi->bank[i].size);
> 
>         memblock_analyze();
>         memblock_dump_all();
Alternatively when calling fixup only after parse_tags in setup_arch()
it worked.  But I guess this change is not for discussion.
OTOH I wonder why fixup gets passed meminfo.  It's not very useful if
it's not yet filled.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
