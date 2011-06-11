Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab1FKLhN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 07:37:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56609 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754423Ab1FKLhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 07:37:09 -0400
Date: Sat, 11 Jun 2011 12:37:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ashish Jangam <Ashish.Jangam@kpitcummins.com>,
        "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Subject: Re: [PATCHv3 -next] MFD: MFD module of DA9052 PMIC driver
Message-ID: <20110611113705.GA2738@opensource.wolfsonmicro.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BC62219@KCINPUNHJCMS01.kpit.com>
 <201106111249.05204.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106111249.05204.arnd@arndb.de>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 12:49:04PM +0200, Arnd Bergmann wrote:

> > +static struct resource da9052_rtc_resource = {
> > +       .name = "ALM",
> > +       .start = DA9052_IRQ_ALARM,
> > +       .end   = DA9052_IRQ_ALARM,
> > +       .flags = IORESOURCE_IRQ,
> > +};
> > +
> > +static struct resource da9052_onkey_resource = {
> > +       .name = "ONKEY",
> > +       .start = DA9052_IRQ_NONKEY,
> > +       .end   = DA9052_IRQ_NONKEY,
> > +       .flags = IORESOURCE_IRQ,
> > +};
> > +
> > +static struct resource da9052_power_resources[] = {
> > +       {
> > +               .name = "CHGEND",
> > +               .start = DA9052_IRQ_CHGEND,
> > +               .end   = DA9052_IRQ_CHGEND,
> > +               .flags = IORESOURCE_IRQ,
> > +       },
> > +       {
> > +               .name = "TBAT",
> > +               .start = DA9052_IRQ_TBAT,
> > +               .end   = DA9052_IRQ_TBAT,
> > +               .flags = IORESOURCE_IRQ,
> > +       },
> > +};
> 
> I may have missed some major development here, but it seems to me that
> hardcoding interrupt numbers from a device driver does not work when
> those numbers conflict with other interrupt numbers. Can anyone explain
> how this works?

This is fine - it's all handled by the MFD core.  When a MFD registers
its subdevices it passes in a base interrupt and all the resources are
adjusted to be relative to that before the devices are instantiated.

> > +static struct da9052_irq_data da9052_irqs[] = {
> > +       [DA9052_IRQ_DCIN] = {
> > +               .mask = DA9052_IRQMASK_A_M_DCIN_VLD,
> > +               .offset = 0,
> > +       },
> > +       [DA9052_IRQ_VBUS] = {
> > +               .mask = DA9052_IRQMASK_A_M_VBUS_VLD,
> > +               .offset = 0,
> > +       },

> This long array would probably be more readable without the member names in it,
> especially since the struct only has two members:

This bit is reasonably idiomatic for the subsystem, mostly because
that's how I wrote the wm835x IRQ controller code (which had some
optionally used members originally though it doesn't any more) and lots
of people have drawn inspiration from it.

> static struct da9052_irq_data da9052_irqs[] = {
>         [DA9052_IRQ_DCIN]	= { DA9052_IRQMASK_A_M_DCIN_VLD, 0 },
>         [DA9052_IRQ_VBUS]	= { DA9052_IRQMASK_A_M_VBUS_VLD, 0 },
>         [DA9052_IRQ_DCINREM]	= { DA9052_IRQMASK_A_M_DCIN_REM, 0 },
>         [DA9052_IRQ_VBUSREM]	= { DA9052_IRQMASK_A_M_VBUS_REM, 0 },
> 	...
> };

> Since the DA9052_IRQMASK_... macros are only used in this one place,
> it would be even better to just get rid of the macros and open-code
> the contents here, to avoid having the reader look it up in another
> file:

Likewise here.  I did this for wm831x because the constants are
automatically generated for me and it allows one to map the code directly
onto the datasheet without having to work through numbers.  It doesn't
seem unreasonable for other people to take the same decision.

> > +int da9052_clear_bits(struct da9052 *da9052, unsigned char reg,
> > +                   unsigned char bit_mask);
> > +
> > +int da9052_device_init(struct da9052 *da9052);
> > +void da9052_device_exit(struct da9052 *da9052);

> > +int da9052_irq_init(struct da9052 *da9052, struct da9052_pdata *pdata);
> > +void da9052_irq_exit(struct da9052 *da9052);

> Not all of these functions are actually used by any of the client drivers,
> so please make them static if you don't need them.

This is fairly idiomatic for MFD drivers.  It makes life easier if we
can get the register I/O functions exported from the MFD when we need
them so we don't have to faff about doing cross tree stuff to export a
new function when you need it.  I'm not a big fan of having *all* the
I/O functions (many of them are redundant, you just need the whole
register and a single update bitmask operation) but it's reasonable for
drivers to do this.

I've got a regmap API I'm intending to post shortly which factors out
the register I/O code for most I2C and SPI devices and should mean that
drivers don't need to implement any of this stuff at all.  I just need
to bash ASoC into using it (it's a factoring out of the shared I/O code
ASoC has) but there's some infelicities in the ASoC code structure here
due to multiple past refactorings which make that more annoying than it
should be.

The device init/exit functions get shared between mulitple source files
in the mfd directory so they can't actually be static, though they don't
need to be fully exported.
