Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab0JDL7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 07:59:24 -0400
Received: from mail.karo-electronics.de ([213.146.116.110]:32832 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab0JDL7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 07:59:23 -0400
Message-ID: <19625.49548.968542.149572@ipc1.ka-ro>
Date: Mon, 4 Oct 2010 13:59:08 +0200
From: =?iso-8859-15?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: Dinh.Nguyen@freescale.com, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        valentin.longchamp@epfl.ch, daniel@caiaq.de,
        xiao-lizhang@freescale.com, r.schwebel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ARM: imx: Add iram allocator functions
In-Reply-To: <20101004114921.GB2529@matterhorn.lan>
References: <1285966279-27719-1-git-send-email-Dinh.Nguyen@freescale.com>
	<20101004114921.GB2529@matterhorn.lan>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Kucheria writes:
> On 10 Oct 01, Dinh.Nguyen@freescale.com wrote:
> > From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > 
> > Add iram allocation functions using GENERIC_ALLOCATOR. The
> > allocation size is 4KB multiples to guarantee alignment. The
> > idea for these functions is for i.MX platforms to use them
> > to dynamically allocate IRAM usage.
> > 
> > Applies on 2.6.36-rc6
> > 
> > Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > ---
> >  arch/arm/plat-mxc/Kconfig                   |    5 ++
> >  arch/arm/plat-mxc/Makefile                  |    1 +
> >  arch/arm/plat-mxc/include/mach/iram_alloc.h |   35 +++++++++++++++
> >  arch/arm/plat-mxc/iram.c                    |   62 +++++++++++++++++++++++++++
> >  4 files changed, 103 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/plat-mxc/include/mach/iram_alloc.h
> >  create mode 100644 arch/arm/plat-mxc/iram.c
> > 
> > diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
> > index 6785db4..283d5bc 100644
> > --- a/arch/arm/plat-mxc/Kconfig
> > +++ b/arch/arm/plat-mxc/Kconfig
> > @@ -57,6 +57,11 @@ source "arch/arm/mach-mx5/Kconfig"
> >  
> >  endmenu
> >  
> > +config IRAM_ALLOC
> > +	bool
> 
> If it is a bool, shouldn't it need a description entry so it shows up in the
> menuconfig?
> 
> It can't be disabled currently.
> 
> > +	default y
> > +	select GENERIC_ALLOCATOR
> > +
> >  config MXC_IRQ_PRIOR
> >  	bool "Use IRQ priority"
> >  	help
> > diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
> > index 78d405e..35cf07b 100644
> > --- a/arch/arm/plat-mxc/Makefile
> > +++ b/arch/arm/plat-mxc/Makefile
> > @@ -10,6 +10,7 @@ obj-$(CONFIG_MXC_TZIC) += tzic.o
> >  
> >  obj-$(CONFIG_IMX_HAVE_IOMUX_V1) += iomux-v1.o
> >  obj-$(CONFIG_ARCH_MXC_IOMUX_V3) += iomux-v3.o
> > +obj-$(CONFIG_IRAM_ALLOC) += iram.o
> >  obj-$(CONFIG_MXC_PWM)  += pwm.o
> >  obj-$(CONFIG_USB_EHCI_MXC) += ehci.o
> >  obj-$(CONFIG_MXC_ULPI) += ulpi.o
> > diff --git a/arch/arm/plat-mxc/include/mach/iram_alloc.h b/arch/arm/plat-mxc/include/mach/iram_alloc.h
> > new file mode 100644
> > index 0000000..12881aa
> > --- /dev/null
> > +++ b/arch/arm/plat-mxc/include/mach/iram_alloc.h
> > @@ -0,0 +1,35 @@
> > +/*
> > + * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
> > + * MA 02110-1301, USA.
> > + */
> > +
> > +#ifdef CONFIG_IRAM_ALLOC
> > +int __init iram_init(unsigned long base, unsigned long size);
> > +void *iram_alloc(unsigned int size, unsigned long *dma_addr);
> > +void iram_free(unsigned long dma_addr, unsigned int size);
> > +#else
> > +static inline int __init iram_init(unsigned long base, unsigned long size)
> > +{
> > +	return -ENOMEM;
> > +}
> > +static inline void *iram_alloc(unsigned int size, unsigned long *dma_addr)
                        ^
> > +{
> > +	return NULL;
> 
> Return for a void function
> 
Not quite. You obviously missed the one and only star in the void. ;)


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
