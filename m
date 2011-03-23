Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab1CWQKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:10:11 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:33906 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933123Ab1CWQKF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:10:05 -0400
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Date: Wed, 23 Mar 2011 17:08:42 +0100
Subject: RE: [PATCH 2/2] mach-ux500: Add CG2900 devices
Thread-Topic: [PATCH 2/2] mach-ux500: Add CG2900 devices
Thread-Index: AcvpaJdjOw3hUZRMScWfbFVVM54cQwABqSuQ
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA334C4DE937@EXDCVYMBSTM005.EQ1STM.local>
References: <1300888803-26474-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <201103231542.28311.arnd@arndb.de>
In-Reply-To: <201103231542.28311.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,
 
> > diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-
> ux500/Makefile
> > index b549a8f..47c92fa 100644
> > --- a/arch/arm/mach-ux500/Makefile
> > +++ b/arch/arm/mach-ux500/Makefile
> > @@ -2,6 +2,9 @@
> >  # Makefile for the linux kernel, U8500 machine.
> >  #
> >
> > +ccflags-y :=					\
> > +	-Idrivers/staging/cg2900/include
> > +
> >  obj-y				:= clock.o cpu.o devices.o
> devices-common.o \
> >  				   id.o usb.o
> 
> Could we keep this more self-contained? Just register a
> single device with the necessary resources and let the
> staging driver figure out how to initialize it, rather
> than splitting it between mach-ux500 and drivers/staging.
> 

I will see what I can do.

> > +#ifdef CONFIG_CG2900
> > +#define CG2900_BT_ENABLE_GPIO		170
> > +#define CG2900_GBF_ENA_RESET_GPIO	171
> > +#define CG2900_BT_CTS_GPIO		0
> 
> Don't make hardware definitions depending on Kconfig symbols.
> Just describe what the hardware looks like if present, and
> let the board code figure out if it's actually there.
> 

Will fix.

> > +static struct platform_device ux500_cg2900_device = {
> > +	.name = "cg2900",
> > +};
> > +
> > +#ifdef CONFIG_CG2900_CHIP
> > +static struct platform_device ux500_cg2900_chip_device = {
> > +	.name = "cg2900-chip",
> > +	.dev = {
> > +		.parent = &ux500_cg2900_device.dev,
> > +	},
> > +};
> > +#endif /* CONFIG_CG2900_CHIP */
> > +
> > +#ifdef CONFIG_STLC2690_CHIP
> > +static struct platform_device ux500_stlc2690_chip_device = {
> > +	.name = "stlc2690-chip",
> > +	.dev = {
> > +		.parent = &ux500_cg2900_device.dev,
> > +	},
> > +};
> > +#endif /* CONFIG_STLC2690_CHIP */
> > +
> > +#ifdef CONFIG_CG2900_TEST
> > +static struct cg2900_platform_data cg2900_test_platform_data = {
> > +	.bus = HCI_VIRTUAL,
> > +	.gpio_sleep = cg2900_sleep_gpio,
> > +};
> 
> Also, don't make the device registration dependent on the Kconfig.
> Make sure that the hardware is there by asking the hardware, then
> register it, even if we don't compile the driver using it.
> 
> I assume that this would get much simpler if you register everything
> from the .probe function of the main "cg2900" device.
> 

I will see how I can fix this. I'm not 100% how I will solve the
"asking the hardware" part, but as you say we might be able to do
this in a better way by doing it from the main staging driver instead.

> > diff --git a/arch/arm/mach-ux500/devices-cg2900.c b/arch/arm/mach-
> ux500/devices-cg2900.c
> > new file mode 100644
> > index 0000000..525c871
> > --- /dev/null
> > +++ b/arch/arm/mach-ux500/devices-cg2900.c
> 
> As far as I can tell, everything in this file can simply become part of
> the
> staging driver. I'm fine with basically anything that compiles going
> into
> drivers/staging, but we should keep the platform code outside of
> staging
> clean of stuff that might have to change as part of the staging
> process.
> 
> 	Arnd

I agree that we can probably move at least most of the code, maybe all.
I will check and update.

Thanks,
/P-G

