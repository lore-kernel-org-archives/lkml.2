Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab0I2WSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 18:18:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44066 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751707Ab0I2WSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 18:18:12 -0400
Date: Wed, 29 Sep 2010 15:18:26 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Subject: Re: [PATCH] ASoC: Add max98088 CODEC driver
Message-ID: <20100929221826.GC31934@opensource.wolfsonmicro.com>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
 <20100929033757.GB29975@opensource.wolfsonmicro.com>
 <B2150E1E4418E1438554A300EA5040E40D46F2D8D8@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40D46F2D8D8@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 02:42:32PM -0700, Peter Hsiang wrote:
> On Wed, Sep 29, 2010, Mark Brown wrote:
> > On Tue, Sep 28, 2010 at 07:34:34PM -0700, Peter Hsiang wrote:

> > > +#define EQ_CFG_MAX 32

> > There doesn't seem to be any need to hard code a limit here?

> Are you requiring the implementation be exactly the same way you did?

It doesn't seem very good to hard code a limit when we already know how
to figure this out at runtime, especially given the amount of dynamic
allocation you already need for the strings themselves.

> > > +/*
> > > + * For kernels compiled without unsigned long long int division
> > > + */
> > > +unsigned long long int ulldiv(unsigned long long int dividend,
> > > +                             unsigned long long int divisor)

> > This is causing me some concern.  Even if it is required this does not
> > look like something that should be part of a specific driver - what
> > happens if some other driver needs the same thing?

> You are more than welcome to use this in your driver as well :)
> Just use it.  Sounds like you are suggesting to have it located in a
> central location outside of the codec driver?
> Would you like that in soc-core.c?  Let me know.

If it is needed it should be a core kernel feature as there is nothing
ASoC specific about doing a division, but you've not explained why it is
required in the first place - are you sure you're not looking for
do_div()?

> There are more than one way to solve a problem, and they all can be
> correct.
> Would additional comments to clarify that this is not register bits
> satisfy your requirement?

Like I say the issue is that the code is *very* opaque and non-idiomatic.

> > > +       if (event == SND_SOC_DAPM_POST_PMU) {
> > > +               /* ON */
> > > +               *state |= pga;
> > > +
> > > +               /* Turn on, avoiding unnecessary writes */
> > > +               val = snd_soc_read(codec, w->reg);
> > > +               if (!(val & (1 << w->shift))) {
> > > +                       val |= (1 << w->shift);
> > > +                       snd_soc_write(codec, w->reg, val);
> > > +               }

> > snd_soc_update_bits() will suppress unwanted register writes.

> From the comments sounds like it resemble snd_soc_update_bits.
> The code logic here is different from snd_soc_update_bits,
> and therefore snd_soc_update_bits can not be used for this
> like you suggested.

What makes you say this (and as with several other things here if things
aren't clear from the code then you should make it clear in the code)?

> > You should add value muxes like we have for DAPM.

> Please clarify what you mean by referencing the specific 
> code usage case in the dapm source module.

You're looking for the non-DAPM equivalent of SND_SOC_DAPM_VALUE_MUX().

> > > +static const char *max98088_extmic[] = {
> > > +       "Off",
> > > +       "MIC1",
> > > +       "MIC2",
> > > +};

> > > +static const struct soc_enum max98088_extmic_enum[] = {
> > > +       SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(max98088_extmic), max98088_extmic),
> > > +};

> > This looks like it should be in DAPM.

> This has nothing to do with power management.  
> I guess you were confused by the word "Off" in the options list.
> The "Off" case means the input for external mic is not used,
> i.e. disconnected.  It does not power up or down anything.

This is exactly my point - DAPM doesn't just manage power, it also
manages the audio routing (and the power as a function of that).
Remember that the DAPM map extends out of the CODEC so even if the CODEC
does not offer any meaningful power management within the device there
may be other external circuits which do (microphone biases being the
obvious example here).

> > > +       *mode = ucontrol->value.integer.value[0];
> > > +       return 0;
> > > +}
> > 

> > All this does is set a variable, changing the control will have no
> > effect.

> The register field works like this:
> 00 = preamp disabled
> 01 = 0dB
> 10 = 20dB
> 11 = 30dB
> So the gain and the power setting are in the same bit field.
> DAPM owns the power control.  Here the user settings are stored,
> and they get picked up by DAPM.

This does not address my comment at all.  Please address my comment - if
the user sets a value here one would expect that to have some immediate
effect on the operation of the device but all this does is store the
setting in a variable but there will be no immediate effect on the
operation of the device and there is nothing restricting when the value
can be set.  This means that the control state that the user sees can
vary from the actual device configuration.

> > > +       /* powering down headphone gracefully */
> > > +       status = snd_soc_read(codec, M98088_REG_4D_PWR_EN_OUT);
> > > +       if ((status & M98088_HPEN) == M98088_HPEN) {
> > > +               max98088_hw_write(codec, M98088_REG_4D_PWR_EN_OUT,
> > > +                       (status & ~M98088_HPEN));
> > > +       }
> > > +       schedule_timeout(msecs_to_jiffies(20));

> > This looks rather like it should just be a post event implementing a
> > timeout?

> This needs to work as a pre event.

Again, why is this?

> > > +       if (rate != cdata->rate) {
> > > +               /* set DAI1 SR1 value for the DSP; FREQ1:0=anyclock */
> > > +               if (rate_value(rate, &regval))
> > > +                       return -EINVAL;
> > > +
> > > +               snd_soc_write(codec, M98088_REG_11_DAI1_CLKMODE, regval);
> > > +               cdata->rate = rate;
> > > +       }

> > Just use snd_soc_update_bits() to suppress unneeded writes.  Many of the
> > operaations have this issue.

> The full value for this register is accounted for here and so there
> is no need to use snd_soc_update_bits for this case.

The "to suppress unneeded writes" bit of my comment is important here -
removing the conditional statements would make the code easier to read.

> > > +       case SND_SOC_BIAS_STANDBY:
> > > +               max98088_sync_cache(codec);
> > > +               snd_soc_update_bits(codec, M98088_REG_4C_PWR_EN_IN,
> > > +                               M98088_MBEN, M98088_MBEN);
> > > +               break;

> > Do you really want to sync the cache *every* time you go into standby?

> The sync_cache function itself will just return if the
> codec->cache_sync flag is cleared from the first time it ran.
> You do the exact same thing in your codec driver...
> What is the change that you are suggesting?

The cache syncs should be part of some operation which would make it
useful to sync the cache rather than just located at some point in the
driver without any particular reason.  For example, with the drivers
I've worked on the cache is synced after we enable the supplies for the
device since the CODEC may have been powered off and therefore lost any
register settings that might have been done.  If the cache sync is not
associated with any such event then it's at best redundant and at worst
the driver will loose some robustness since it becomes unclear if the
events which cause a cache sync to be required are joined up with the
triggering of a sync.

> > > +module_init(max98088_init);

> > Normally this would be next to the function it references.

> Is this a new formatting style of the kernel now all across,
> or is this a personal preference?

It's a global style for the kernel, though not enforced with 100%
success.
