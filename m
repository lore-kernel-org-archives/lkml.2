Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0DSQ7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:59:46 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:40706 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab0DSQ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:59:45 -0400
Date: Mon, 19 Apr 2010 18:59:39 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Nguyen Dinh-R00091 <R00091@freescale.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       valentin.longchamp@epfl.ch, grant.likely@secretlab.ca,
       bryan.wu@canonical.com, amit.kucheria@canonical.com,
       Herring Robert-RA7055 <RA7055@freescale.com>,
       Li Jun-R65092 <R65092@freescale.com>,
       Zhang Lily-R58066 <R58066@freescale.com>
Subject: Re: [PATCHv4 2.6.34-rc4 5/7] mxc: Add generic USB HWinitialization
 for MX51
Message-ID: <20100419165939.GB30807@buzzloop.caiaq.de>
References: <1271445371-18501-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-3-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-4-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-5-git-send-email-Dinh.Nguyen@freescale.com>
 <20100418020726.GB7882@pengutronix.de>
 <86A0E76937111F4C92FABEC0A20988510473395C@az33exm21>
 <20100419155828.GE7882@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419155828.GE7882@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 05:58:28PM +0200, Sascha Hauer wrote:
> On Mon, Apr 19, 2010 at 08:40:29AM -0700, Nguyen Dinh-R00091 wrote:
> > > cb0b638..35ff1c1 100644
> > > --- a/arch/arm/plat-mxc/ehci.c
> > > +++ b/arch/arm/plat-mxc/ehci.c
> > > @@ -1,5 +1,6 @@
> > >  /*
> > >   * Copyright (c) 2009 Daniel Mack <daniel@caiaq.de>
> > > + * Copyright (C) 2010 Freescale Semiconductor, Inc.
> > >   *
> > >   * This program is free software; you can redistribute it and/or
> > modify it
> > >   * under the terms of the GNU General Public License as published by 
> > > the @@ -18,6 +19,7 @@
> > >  
> > >  #include <linux/platform_device.h>
> > >  #include <linux/io.h>
> > > +#include <linux/delay.h>
> > >  
> > >  #include <mach/hardware.h>
> > >  #include <mach/mxc_ehci.h>
> > > @@ -50,9 +52,14 @@
> > >  #define MX35_H1_TLL_BIT		(1 << 5)
> > >  #define MX35_H1_USBTE_BIT	(1 << 4)
> > >  
> > > -int mxc_set_usbcontrol(int port, unsigned int flags)
> > > +int mxc_intialize_usb_hw(int port, unsigned int flags)
> > >  {
> > >  	unsigned int v;
> > > +	void __iomem *usb_base;
> > > +	u32 usbotg_base;
> > > +	u32 usbother_base;
> > > +	int timeout;
> > > +	int ret = 0;
> > >  #ifdef CONFIG_ARCH_MX3
> > >  	if (cpu_is_mx31()) {
> > >  		v = readl(MX31_IO_ADDRESS(MX31_OTG_BASE_ADDR + @@ -186,9
> > +193,126 
> > > @@ int mxc_set_usbcontrol(int port, unsigned int flags)
> > >  		return 0;
> > >  	}
> > >  #endif /* CONFIG_MACH_MX27 */
> > > +#ifdef CONFIG_ARCH_MX51
> > > +	if (cpu_is_mx51()) {
> > > +		usb_base = ioremap(MX51_OTG_BASE_ADDR, SZ_4K);
> > > +
> > > +		switch (port) {
> > > +		case 0:	/* OTG port */
> > > +			usbotg_base = (u32)usb_base + USBOTG_OFFSET;
> > > +			break;
> > > +		case 1:	/* Host 1 port */
> > > +			usbotg_base = (u32)usb_base + USBH1_OFFSET;
> > > +			break;
> > > +		default:
> > > +			printk(KERN_ERR"%s no such port %d\n", __func__,
> > port);
> > > +			ret = -ENOENT;
> > > +			goto error;
> > > +		}
> > > +		usbother_base = (u32)usb_base + USBOTHER_REGS_OFFSET;
> > > +
> > > +		/* Stop then Reset */
> > > +		v = __raw_readl(usbotg_base + USBCMD_OFFSET);
> > > +		v &= ~UCMD_RUN_STOP;
> > > +		__raw_writel(v, usbotg_base + USBCMD_OFFSET);
> > > +		timeout = 0x100000;
> > > +		while (--timeout && __raw_readl(usbotg_base +
> > USBCMD_OFFSET) & UCMD_RUN_STOP)
> > > +			cpu_relax();
> > > +		if (!timeout) {
> > > +			printk(KERN_ERR "%s could not stop usb
> > hardware\n", __func__);
> > > +			ret = -ETIMEDOUT;
> > > +			goto error;
> > > +		}
> > > +
> > > +		v = __raw_readl(usbotg_base + USBCMD_OFFSET);
> > > +		v |= UCMD_RESET;
> > > +		__raw_writel(v, usbotg_base + USBCMD_OFFSET);
> > > +		timeout = 0x100000;
> > > +		while (--timeout && __raw_readl(usbotg_base +
> > USBCMD_OFFSET) & UCMD_RESET)
> > > +			cpu_relax();
> > > +		if (!timeout) {
> > > +			printk(KERN_ERR "%s could not reset usb
> > hardware\n", __func__);
> > > +			ret = -ETIMEDOUT;
> > > +			goto error;
> > > +		}
> > > +
> > > +		switch (port) {
> > > +		case 0:	/*OTG port */
> > > +			v = __raw_readl(usbother_base +
> > USB_PHY_CTR_FUNC_OFFSET);
> > > +			v |= USB_UTMI_PHYCTRL_OC_DIS; /* OC is not used
> > */
> > > +			__raw_writel(v, usbother_base +
> > USB_PHY_CTR_FUNC_OFFSET);
> > > +
> > > +			v = __raw_readl(usbother_base + USBCTRL_OFFSET);
> > > +			v &= ~(UCTRL_OPM | UCTRL_OWIE);/* OTG
> > wakeup/power mask disable */
> > > +			__raw_writel(v, usbother_base + USBCTRL_OFFSET);
> > > +
> > > +			/* Set the PHY clock to 19.2MHz */
> > > +			v = __raw_readl(usbother_base +
> > USB_PHY_CTR_FUNC2_OFFSET);
> > > +			v &= ~USB_UTMI_PHYCTRL2_PLLDIV_MASK;
> > > +			v |= 0x01;
> > > +			__raw_writel(v, usbother_base +
> > USB_PHY_CTR_FUNC2_OFFSET);
> > > +			break;
> > 
> > The sense of this funtion is to make the interface configuration,
> > especially the receiver type configurable with the flags parameter to
> > this function. This all looks very specific to your board, flags is
> > completely unused.
> > 
> > [Dinh] I think you're right Sascha, I think I can move this to the board
> > initialization. Do you agree Daniel?
> 
> No, and Daniel won't agree either. What I meant is that you should add
> support for the different transceiver types in this function. Take
> i.MX27/31/35 as an example how to do this: Parse the flag parameter and
> do whatever you have to.

Yes, of course. Sorry I didn't see this when reviewing.

Think about what's necessary to add support for a new board. You don't
want to copy all the register accessing functions again but re-use and
share generic code. All you need to have in the board specific support
code are flags which are passed to the generic driver core. Just like
all other board support code does it as well. Not just for USB btw. but
for all sorts of other drivers as wel. Have a look at code which is
already there to get the idea.

[Btw - your mail client is broken as it wraps quoted lines (see above).
 See Documentation/email-clients.txt]

Daniel

