Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab1FKOgd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 10:36:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60262 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689Ab1FKOg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 10:36:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCHv3 -next] MFD: MFD module of DA9052 PMIC driver
Date: Sat, 11 Jun 2011 16:35:42 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Ashish Jangam <Ashish.Jangam@kpitcummins.com>,
        "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BC62219@KCINPUNHJCMS01.kpit.com> <201106111249.05204.arnd@arndb.de> <20110611113705.GA2738@opensource.wolfsonmicro.com>
In-Reply-To: <20110611113705.GA2738@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106111635.42563.arnd@arndb.de>
X-Provags-ID: V02:K0:13V3gIpk5lrdkWbH1S2ZXyHz6DOs/3msT4ibOlpQ3ws
 IwuR3hEFeTS0yE8kHMDiSkLdU0VoAIfKjlPz3PuunfzEgpO2fr
 EknBo9ThRt1zOqzZ5uRlrlIh3jW4Xavb50s2w98HZk/0ZpCYpw
 e7vDhUwkH7lSfEvnz58YCY/Af67mSExpOfqPMpss7lmSirvSNK
 S0X+RNDIx20NNf6QzcQMw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 June 2011 13:37:06 Mark Brown wrote:
> On Sat, Jun 11, 2011 at 12:49:04PM +0200, Arnd Bergmann wrote:

> > I may have missed some major development here, but it seems to me that
> > hardcoding interrupt numbers from a device driver does not work when
> > those numbers conflict with other interrupt numbers. Can anyone explain
> > how this works?
> 
> This is fine - it's all handled by the MFD core.  When a MFD registers
> its subdevices it passes in a base interrupt and all the resources are
> adjusted to be relative to that before the devices are instantiated.

Ok, thanks for the explanation.

> > > +static struct da9052_irq_data da9052_irqs[] = {
> > > +       [DA9052_IRQ_DCIN] = {
> > > +               .mask = DA9052_IRQMASK_A_M_DCIN_VLD,
> > > +               .offset = 0,
> > > +       },
> > > +       [DA9052_IRQ_VBUS] = {
> > > +               .mask = DA9052_IRQMASK_A_M_VBUS_VLD,
> > > +               .offset = 0,
> > > +       },
> 
> > This long array would probably be more readable without the member names in it,
> > especially since the struct only has two members:
> 
> This bit is reasonably idiomatic for the subsystem, mostly because
> that's how I wrote the wm835x IRQ controller code (which had some
> optionally used members originally though it doesn't any more) and lots
> of people have drawn inspiration from it.
> 
> > static struct da9052_irq_data da9052_irqs[] = {
> >         [DA9052_IRQ_DCIN]	= { DA9052_IRQMASK_A_M_DCIN_VLD, 0 },
> >         [DA9052_IRQ_VBUS]	= { DA9052_IRQMASK_A_M_VBUS_VLD, 0 },
> >         [DA9052_IRQ_DCINREM]	= { DA9052_IRQMASK_A_M_DCIN_REM, 0 },
> >         [DA9052_IRQ_VBUSREM]	= { DA9052_IRQMASK_A_M_VBUS_REM, 0 },
> > 	...
> > };
> 
> > Since the DA9052_IRQMASK_... macros are only used in this one place,
> > it would be even better to just get rid of the macros and open-code
> > the contents here, to avoid having the reader look it up in another
> > file:
> 
> Likewise here.  I did this for wm831x because the constants are
> automatically generated for me and it allows one to map the code directly
> onto the datasheet without having to work through numbers.  It doesn't
> seem unreasonable for other people to take the same decision.

Right, except that in this case when you expand the macros, all you get is

{
	[ 0] = { 0x00000001 },
	[ 1] = { 0x00000002 },
	[ 2] = { 0x00000004 },
	[ 3] = { 0x00000008 },
	...
	[ n] = { 0x1 << n },
	...
	[30] = { 0x40000000 },
	[31] = { 0x80000000 },
}

This is entirely pointless for this particular driver. While I can
see good reasons to share idioms across similar drivers, this one
just doesn't need it. The only two functions where the data is used
AFAICT are da9052_irq_sync_unlock and da9052_irq_unmask, and both
could replace the table lookup with a trivial computation.

> > > +int da9052_clear_bits(struct da9052 *da9052, unsigned char reg,
> > > +                   unsigned char bit_mask);
> > > +
> > > +int da9052_device_init(struct da9052 *da9052);
> > > +void da9052_device_exit(struct da9052 *da9052);
> 
> > > +int da9052_irq_init(struct da9052 *da9052, struct da9052_pdata *pdata);
> > > +void da9052_irq_exit(struct da9052 *da9052);
> 
> > Not all of these functions are actually used by any of the client drivers,
> > so please make them static if you don't need them.
> 
> This is fairly idiomatic for MFD drivers.  It makes life easier if we
> can get the register I/O functions exported from the MFD when we need
> them so we don't have to faff about doing cross tree stuff to export a
> new function when you need it.  I'm not a big fan of having *all* the
> I/O functions (many of them are redundant, you just need the whole
> register and a single update bitmask operation) but it's reasonable for
> drivers to do this.

I only looked at the first function in the list (da9052_adc_manual_read)
and noticed that it doesn't have any users at all. It's certainly
ok to export a complete API set when some functions belong together,
but I had the impression that in this case it wasn't actually clear
what the API is or should be.

Maybe an explanation about what da9052_adc_manual_read does or why
it's exported would be useful, I'm objecting the other exports.

> I've got a regmap API I'm intending to post shortly which factors out
> the register I/O code for most I2C and SPI devices and should mean that
> drivers don't need to implement any of this stuff at all.  I just need
> to bash ASoC into using it (it's a factoring out of the shared I/O code
> ASoC has) but there's some infelicities in the ASoC code structure here
> due to multiple past refactorings which make that more annoying than it
> should be.

Ah, very nice.

> The device init/exit functions get shared between mulitple source files
> in the mfd directory so they can't actually be static, though they don't
> need to be fully exported.

Right, they could go into drivers/mfd/da905x.h header.

	Arnd
