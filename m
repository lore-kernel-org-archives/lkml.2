Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab2KZJBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:01:12 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:51787 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab2KZJBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:01:11 -0500
Date: Mon, 26 Nov 2012 17:00:06 +0800
From: Woody Wu <narkewoody@gmail.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ethernet driver doesn't get probed
Message-ID: <20121126090006.GA4078@zuhnb712.ap.bm.net>
References: <slrnkb64p3.2k6.narkewoody@zuhnb712.local.com>
 <CAAfyv35QOvgvH8xoMkE-S5Zf-9HF5Jb9X1EbMoi2FCcx1UMXNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfyv35QOvgvH8xoMkE-S5Zf-9HF5Jb9X1EbMoi2FCcx1UMXNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 08:47:57AM +0100, Belisko Marek wrote:
> On Mon, Nov 26, 2012 at 7:59 AM, Woody Wu <narkewoody@gmail.com> wrote:
> > Hi, List
> >
> > I enabled an ax88796 Ethernet driver in the kernel configuration menu.
> > Kernel version is 3.4.19. The arch is ARM and the system type is
> > Samsung S3C2410.
> >
> > In my debugging, I found the probe function of the driver did not get
> > invoked.
> Did you define platform data and platform device in board file?
> See: arch/arm/mach-pxa/colibri-pxa300.c (line ~87)


No. After read the colibri-pxa300.c, now I understand I must do it!
Great! Thanks!


But some details in the file I need your help.

In pxa300,

static struct resource colibri_asix_resource[] = {
	[0] = {
		.start = PXA3xx_CS2_PHYS,
		.end   = PXA3xx_CS2_PHYS + (0x20 * 2) - 1,
		.flags = IORESOURCE_MEM,
	},
	[1] = {
		.start = PXA_GPIO_TO_IRQ(COLIBRI_ETH_IRQ_GPIO),
		.end   = PXA_GPIO_TO_IRQ(COLIBRI_ETH_IRQ_GPIO),
		.flags = IORESOURCE_IRQ | IRQF_TRIGGER_FALLING,
	}
};

On my board, I only know the below information about the ax88786
controllers::
    eth0: AX88796B found at 0x11000000, using IRQ 52, MAC 00:30:61:00:55:38
    eth1: AX88796B found at 0x19000000, using IRQ 53, MAC 00:30:61:00:55:39

Do you think how should I specify resources for it? Especially in the
IRQ part, I don't understand whether I should use the GPIO_TO_IRQ
macros as that in the pxa300.

Also, for the chip selection logic appearing in the pxa300, 

static mfp_cfg_t colibri_pxa300_eth_pin_config[] __initdata = {
	GPIO1_nCS2,			/* AX88796 chip select */
	GPIO26_GPIO | MFP_PULL_HIGH	/* AX88796 IRQ */
};

I also have no ideal whether I should use it.  I don't have schematics
for the board, I only have some kernel logs from an old version of
running linux, for which I don't have source code.

Really hope you can give me some help!  Thanks in advance.


> >
> > This driver is declared as platform_driver
> >
> > static struct platform_driver axdrv = {
> >         .driver = {
> >                 .name           = "ax88796",
> >                 .owner          = THIS_MODULE,
> >         },
> >         .probe          = ax_probe,
> >         .remove         = ax_remove,
> >         .suspend        = ax_suspend,
> >         .resume         = ax_resume,
> > };
> >
> > module_platform_driver(axdrv);
> >
> > So, its driver init function actually goes through
> > platform_driver_register() and then driver_register(), which eventually
> > call driver_attach() trying to attach the driver to the "platform" bus.
> > But, on the platform bus, there is no any device that can match the
> > ax88796 driver, hence the driver failed in attaching.
> >
> > I discovered the full list of devices found on the platform bus:
> >
> >     s3c2410-ohci,
> >     s3c2410-lcd,
> >     s3c2410-wdt,
> >     s3c2410-i2c,
> >     s3c24xx-iis,
> >     s3c2410-nand,
> >     s3c24xx_led,
> >     s3c2410-uart,
> >
> > You see, in the list, there is no a device looks like ax88796. All these
> > already existed devices on the platform bus are build-in peripherals on
> > the SoC of s3c2410, they are compiled into the code by enabling some
> > kernel configuration options.
> >
> > My question is, in terms of Linux driver technology, how to enable a
> > non-PCI and not on-chip device driver? I think the ax_probe function
> > must be called somehow, is this thinking right? If yes, I think before
> > the driver get initialized, the corresponding device has to appear on
> > the bus, but now it seems not.
> >
> > Thanks in advance.
> >
> > --
> > woody
> > I can't go back to yesterday - because I was a different person then.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> Cheers,
> 
> mbe
> 
> -- 
> as simple and primitive as possible
> -------------------------------------------------
> Marek Belisko - OPEN-NANDRA
> Freelance Developer
> 
> Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
> Tel: +421 915 052 184
> skype: marekwhite
> twitter: #opennandra
> web: http://open-nandra.com

-- 
woody
I can't go back to yesterday - because I was a different person then.
