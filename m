Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab0ICKRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:17:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53963 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753002Ab0ICKR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:17:28 -0400
Date: Fri, 3 Sep 2010 11:17:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: Add max98088 CODEC driver
Message-ID: <20100903101721.GE16587@rakim.wolfsonmicro.main>
References: <B2150E1E4418E1438554A300EA5040E40D469C123B@ITSVLEX06.it.maxim-ic.internal>
 <20100901111432.GE17548@opensource.wolfsonmicro.com>
 <B2150E1E4418E1438554A300EA5040E40D46A5BB13@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40D46A5BB13@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: The early worm gets the bird.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 04:30:14PM -0700, Peter Hsiang wrote:
> On Wed, Sep 01, 2010, Mark Brown wrote:

> >   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git

> Thanks for the git location you provided.  What version of Linux
> kernel does this git/broonie/sound-2.6.git version correspond to?
> Is it newer than even the latest kernel-next?

This is what's going into -next, it will often be trivially ahead of
-next with the patches addded since -next was last built but not
meaningfully so.

> Some of the ASoC API functions and features in the latest version of
> the kernel you require us to use are not in the popular stable kernel
> version 2.6.32 that people are using today to build products.
> Our intent is to release driver code that will work in both the current
> and latest kernel versions.

This is not how Linux development works, and in many cases will be
impossible as internal APIs are frequently removed from the
Linux kernel or changed incompatibly.

> Would it not be a good idea to use the API functions that exist in
> both the very latest and the currently popular kernel version?

Like I say this is just not possible in many cases.

> Does kernel.org provide a channel for releasing codec drivers that
> can be backward compatible to a popular earlier kernel version?

No, and it's not clear that a single approach can be adopted since newer
devices often drive enhancements to the core APIs so the approaches that
work best to integrate with older kernels vary depending on the particular 
devices and kernel versions involved.

> > > +       /* Bypass option for INA to MIC1 connection
> > > +        * 0 = normal setting
> > > +        * 1 = bypass enabled
> > > +        */
> > > +       unsigned int ina_to_mic1_bypass;
> > > +
> > > +       /* Bypass option for MIC1 to MIC2 connection

> > What are these - they sound like something I'd expect to be configurable
> > at runtime?

Please engage with questions like this.

> > > +/*
> > > + * Read the MAX98088 I2C register space
> > > + * Note: this driver source code is backward compatible to kernel
> > > + * version 2.6.32.
> > > + */
> > > +static unsigned int max98088_read(struct snd_soc_codec *codec,
> > > +                                 unsigned int reg)

> > Just use soc-cache.  Compatibility code for older kernels isn't really
> > acceptable for mainline due to the increased maintainance burden and it
> > will at best result in a driver that doesn't work as well as possible.

> This integrated registers feature is not available in 2.6.32
> Is it ok with you to keep it this way for this release?  Thanks.

No, you should use the features of the current kernel.  For your
backport you can do things like supply soc-cache.c as well.

> > > +       client = (struct i2c_client *)codec->control_data;

> > No need to cast away from void.

> Ok will do - but no harm in being informative :)

There is actually - if you have a cast then if you have done something
broken by mistake the compiler is much less likely to generate a warning
since the cast says you know what you're doing.

> > > +       "user-400Hz",
> > > +       "user-600Hz",
> > > +       "user-800Hz",
> > > +       "user-1000Hz"

> > These user options look very suspicous.

> The first 8 options are settings pre-defined in hardware that the
> user can choose from.
> The last 4 are user programmable options, and thus the name 'user'.

What happens if the user didn't supply any programmable options?  Would
it not be better to allow the user to specify meaningful text here?

> > > +       SOC_SINGLE("EQ1 switch", M98088_REG_49_CFG_LEVEL, 0, 1, 0),
> > > +       SOC_SINGLE("EQ2 switch", M98088_REG_49_CFG_LEVEL, 1, 1, 0),

> > Capitalise switch.

> I noticed that by capitalizing the first letter of the 2nd word,
> the 2nd word is dropped out by the system when amixer lists them.
> "EQ1 Switch" becomes just "EQ1", while "EQ1 switch" is "EQ1 switch".
> Have you seen this behavior before?
> Is this a known issue with some version of amixer or ASoC code base?

This is not a problem, this is intended behaviour.  ALSA applications
interpret the control names and use this naming information to present
an appropriate UI to users.

> > > +static const struct snd_soc_dapm_route audio_map[] = {
> > > +       /* Left headphone output mixer */
> > > +       {"Left HP Mixer", "Left DAC1", "DACL1"},
> > > +       {"Left HP Mixer", "Left DAC2", "DACL2"},
> > > +       {"Left HP Mixer", "Right DAC1", "DACR1"},
> > > +       {"Left HP Mixer", "Right DAC2", "DACR2"},
> > > +       {"Left HP Mixer", "MIC1", "Mic Bias"},
> > > +       {"Left HP Mixer", "MIC2", "Mic Bias"},

> > This looks wrong - I'd expect this to be switching the microphone input
> > to the mixer, not the bias.  Mixing the bias in would just present a DC
> > level which isn't going to be great.  Similarly for all your other
> > microphone input switching.

> I'll look at switching the microphone input like you suggested. Thanks.
> No worries, when turning on the mic bias, the hardware will not
> add DC into the digital samples.  It's handled well.

As I said I rather suspect that this is because the microphone input is
being switched into the path rather than the microphone bias.

> > > +                       /* BCI: normal bclk (rise) */
> > > +                       /* WCI: invert frame */
> > > +                       snd_soc_update_bits(codec,
> > M98088_REG_14_DAI1_FORMAT,
> > > +                               M98088_DAI_BCI, M98088_DAI_WCI);
> > > +                       break;
> > > +               case SND_SOC_DAIFMT_IB_NF:
> > > +                       /* BCI: invert bclk (fall) */
> > > +                       /* WCI: normal frame */
> > > +                       snd_soc_update_bits(codec,
> > M98088_REG_14_DAI1_FORMAT,
> > > +                               M98088_DAI_WCI, M98088_DAI_BCI);

> > This code (and most of the other update_bits() usages round here) looks
> > wrong - I'd expect to see a constant bitmask being supplied as the mask
> > argument then the value changing to set different values.

> The M98088_DAI_BCI and M98088_DAI_WCI are bit field masks.
> Is this what you expect?  If not, could you clarify?  Thanks!

As I said above I'd expect to see a constant mask being supplied and
varying values.  Could you please explain what you think the code above
does?

> > > +                       (0<<2) |  /* HIZOFF : ADC SDOUT (0=HiZ, 1=Drive)
> > */
> > > +                       (1<<1) |  /* SDOEN : serial data out ENABLE */
> > > +                       (1<<0));  /* SDIEN : serial data in ENABLE */

> > These look like they ought to be DAPM widgets for the AIF.

> Good idea. Which widget(s) will drive SDOEN, or SDIEN?

The AIF widgets.
