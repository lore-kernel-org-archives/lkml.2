Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0FSJtU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 05:49:20 -0400
Received: from ossa.mas.viperplatform.net.au ([202.147.75.25]:33128 "EHLO
	ossa.mas.viperplatform.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307Ab0FSJtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 05:49:18 -0400
Date: Sat, 19 Jun 2010 19:49:08 +1000
From: Stuart Longland <redhatter@gentoo.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>,
       ALSA Development List <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: Add new TI TLV320AIC3204 CODEC
 driver
Message-ID: <20100619094908.GD30868@www.longlandclan.yi.org>
References: <1276833465-31702-1-git-send-email-redhatter@gentoo.org>
 <1276899876-19001-1-git-send-email-redhatter@gentoo.org>
 <20100619011221.GC2463@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619011221.GC2463@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 02:12:21AM +0100, Mark Brown wrote:
> On Sat, Jun 19, 2010 at 08:24:36AM +1000, Stuart Longland wrote:
> 
> This all looks pretty good, the comments below are fairly minor.
> 
> > +	/* AVDD <->DVDD Link enable */
> > +	u8	avdd_link_en;
> 
> What's this?  It looks like a boolean which makes u8 an odd choice.
> 
> > +	/* LDO Enable */
> > +	u8	ldo_en;
> 
> Similarly here.

Well, I didn't see the point in allocating 32-bits when I'd only be
using 1 of them.  However, I can change it to an int if need be.  I'm
not certain that C has a true "bool" type, but I could be wrong.

> > +
> > +	/* Oversampling rate (both ADC and DAC) */
> > +	u8	osr;
> 
> Why is this platform data rather than a runtime configurable option?

How would the application elect a particular oversampling rate?  I'll
admit I'm very new to the ALSA framework in general, but I didn't
realise there was an oversampling rate setting.  I'll have a look at how
the other drivers do it.

> > +config SND_SOC_TLV320AIC3204
> > +	tristate
> > +	depends on I2C
> > +
> 
> Drop the depends, it doesn't actually do anything for selected items.
> 
> > +	/* Page 1 */
> > +	if (page == 1) {
> > +		if (reg <= 4)
> > +			return 1;
> 
> I can't help but think that this'd be more legible with switch ()
> statements (GCC has an extension for ranges in switch statements which
> you could use).

I did if statements here for two reasons:

(1) Range selection (I was unaware of the GCC extension)
(2) I found by experiment that if is slighly more efficient than
	switch... at least that was the case on MSP430 (using mspgcc).
	Other platforms could be very different.

> > +/*
> > + * Pretty-print the value of a register
> > + */
> > +static int aic3204_show_reg(struct snd_soc_codec *codec, char *buf,
> > +		int buf_sz, unsigned int reg)
> > +{
> > +	return snprintf(buf, buf_sz, "%02x",
> > +			aic3204_read_reg_cache(codec, reg));
> > +}
> 
> This looks suspiciously close to the standard show_reg() - it seems
> wrong that you should need it.

Well, the main difference; standard show_reg uses %4x as its format; and
therefore wastes two characters printing nothing useful.  Given space is
already tight for displaying register dumps via debugfs, any little bit
helps. :-)

Certainly there's no explicit reason why it is necessary and it can go.

> > +	/*
> > +	 * These registers are not manipulated by us, so we must read them from
> > +	 * the CODEC directly.
> > +	 */
> 
> Hrm?  Also, it strikes me that this code is also used in the WCLK
> function and might benefit from being factored out - it's moderately
> verbose.

The ADC flags register (and the DAC flags registers) are read-only and
manipulated by the CODEC when the ADCs and DACs are actually powered up.
I could use the flags set elsewhere, but this reflects what *is* the
present state, not what ought to be the present state.

There is common code between the WCLK and BCLK functions; in fact I did
consider making it the one callback, but since they are separate in the
registers, I kept them separate in the callbacks.

> > +static const char *aic3204_micbias_voltages[] = {
> > +	"Low", "Med", "High", "V+"
> > +};
> 
> I'd be inclined to spell medium out and write "V+" as "Supply" or
> similar unless there's a strong reason to do otherwise - it seems more
> legible.

Fair enough... I was originally going to try and use some shortened
version of what's in the datasheet... but the values of "Low", "Medium"
and "High" are dependant on the selected source and the power rails.
"Supply" is probably just as descriptive, if not as compact as "V+"...
I'll update that.

> > +static const char *aic3204_ldac_srcs[] = {
> > +	"disabled", "left channel", "right channel", "mix"
> > +};
> 
> Capital letters are more idiomatic for enumerations.
> 
> > +/*
> > + * DAC digital volumes. From -63.5 to +24 dB in 0.5 dB steps.
> > + * Does not mute control.
> > + */
> 
> I'm finding these comments a little too verbose but that's just me -
> I stop and read them only to find there's nothing odd going on here.

Yeah, some of this is due to the fact that, in the early days, I wasn't
too sure if this was the "right way".  So I figured I'd describe my
intentions, and then if I was doing it wrong, people would at least
know what was intended, and could suggest improvements.

Now that the mixer is working okay, I could cut this down... but also I
hope that others who follow the same path as me, might find this helpful
to determine what's going on.

> > +	/*
> > +	 * Note regarding SOC_DOUBLE_R_SX_TLV...
> > +	 *
> > +	 * This is a bit misleading; xshift refers to the bit one bit *past*
> > +	 * the most significant bit.  Or at least that's what it appears to be
> > +	 * doing the math.  Mask needs to select the last 6 bits; which is the
> > +	 * signed bitfield specifiying the gain in dB.
> > +	 */
> 
> I suspect that fixing the control may break what you're doing here?  It
> would certainly bitrot the comment.

Well, when the problem goes, so can the comment. :-)  One question
though, the shift value derives the mask for further operations on these
registers... if we were to change the shift value so it reflected how
other widget types work, how does one define the mask?

> > +	SOC_SINGLE("Differential Output Switch", AIC3204_DACS2,
> > +			AIC3204_DACS2_RMOD_INV_SHIFT, 1, 0),
> 
> This feels like platform data - the use of differential outputs is
> normally a property of the physical wiring of the board, it's very rare
> to be able to vary this usefully at runtime.

Arguably, so is the DAC audio path routing.  I wasn't sure how to set
this up at the time, initially it was CODEC setup data, then I moved it
into the mixer.

The other consideration here; is the use case where a device with a mono
speaker, but a stereo line-out jack... I wasn't sure how to handle these
features.

> > +	/* MICBIAS Options */
> > +	SOC_SINGLE("MICBIAS Enable", AIC3204_MICBIAS, 6, 0x1, 0),
> 
> MICBIAS Enable should definitely be DAPM.
> 
> > +	SOC_ENUM("MICBIAS Level", aic3204_enum_micbias_voltage),
> > +	SOC_ENUM("MICBIAS Source", aic3204_enum_micbias_src),
> 
> These I would expect to be managed in kernel - they're normally either a
> property of the board or need to be managed in conjunction with jack
> detection code which tends to live in kernel.

I'll look into this... I was aware of the MICBIAS widget, but will have
to do some further research here.  As to the others... I wasn't sure how
they should be handled.

> > +static const struct snd_soc_dapm_widget aic3204_dapm_widgets[] = {
> > +	/* Driver/Amplifier Selection */
> > +	SND_SOC_DAPM_SWITCH("HPL Playback Switch", AIC3204_OUTDRV,
> > +			AIC3204_OUTDRV_HPL_UP_SHIFT, 0,
> > +			&aic3204_hpl_switch),
> > +	SND_SOC_DAPM_SWITCH("HPR Playback Switch", AIC3204_OUTDRV,
> > +			AIC3204_OUTDRV_HPR_UP_SHIFT, 0,
> > +			&aic3204_hpr_switch),
> 
> A lot of these SWITCH controls feel like they ought to be PGAs and the
> switch controls mutes on those.  When muting an output you normally
> don't want to power up and down the path since that is slow and tends to
> trigger audible issues, you'd normally control the power for path
> endpoints and elements that affect routing only.

They are PGAs connecting the driver to its mixer... I wasn't sure how
the PGAs worked in DAPM.  I knew this did work however, the only catch
is that DAPM won't power up the DACs unless you switch them through via
these mixers to one of the output drivers.  I'll have a closer look at
the PGAs and see what they're doing.

> > +	SND_SOC_DAPM_AIF_IN("Left Data In", "Left Playback",
> > +			0, SND_SOC_NOPM, 0, 0),
> > +	SND_SOC_DAPM_AIF_IN("Right Data In", "Right Playback",
> > +			1, SND_SOC_NOPM, 0, 0),
> > +	SND_SOC_DAPM_AIF_OUT("Left Data Out", "Left Capture",
> > +			0, SND_SOC_NOPM, 0, 0),
> > +	SND_SOC_DAPM_AIF_OUT("Right Data Out", "Right Capture",
> > +			1, SND_SOC_NOPM, 0, 0),
> 
> You have these AIF widgets but at least the DAC input selection was
> being done in the regular controls rather than in the DAPM routing.

Indeed, DAC inputs are selectable, the ADC is not.  I should probably
making the DAC inputs a MUX... I'll give this a re-think too.

> > +	/*
> > +	 * Set BCLK and WCLK sources...
> > +	 *
> > +	 * Despite DAPM; this is still needed, as DAPM doesn't yet set the
> > +	 * source at the right time.
> > +	 *
> > +	 * TODO: See if we can change the order of initialisation so this
> > +	 * selection is made after bringing up the ADCs/DACs.  Alternative:
> > +	 * see if we can find out ahead of time which one to use.
> 
> It surprises me that the ordering matters too much here; worst case you
> leave the interface declocked a little longer when you need to switch
> sources but that doesn't seem like the end of the world?

Well, what I found is that if I didn't do it there... it would call the
WCLK and BCLK functions before powering up the DACs/ADCs.  Since they
have no idea whether recording or playback is in progress (I wasn't sure
how to extract this information), the functions rely on the flags
registers to determine this.

Therefore, it only works *after* DAPM has turned on the respective
parts.  Without manually switching it here, the functions see that
neither ADC nor DAC is active, and therefore don't do any switching of
the BCLK and WCLK.  End result; no clocks, DMA times out and the user is
left with deafening silence.

This, is probably one of the biggest areas where the DAPM support in
this CODEC driver needs work.  I tried to follow what was going on in
the other CODEC drivers, and I know what's submitted isn't quite right,
but it does at least work.

> > +	snd_soc_update_bits(codec, AIC3204_AISR3, AIC3204_AISR3_BDIV,
> > +			(substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
> > +				? AIC3204_AISR3_BDIV_DAC
> > +				: AIC3204_AISR3_BDIV_ADC);
> 
> I have to say that I'm really not a fan of the ternery operator for
> legibility.
>
> > +static int aic3204_mute(struct snd_soc_dai *dai, int mute)
> > +{
> 
> ...
> 
> > +	aic3204_write(codec, AIC3204_DACS2, dacs2);	/* Unmute DAC */
> 
> ...or possibly mute it :)

Yes, obsolete comment I guess. :-)  This is also a mixer control...
which is better... leave it to ASoC core, or the user to control PCM
mute?  The user can mute using the line driver controls... so I guess I
should ditch the "PCM Playback Switch" control.

> > +static int aic3204_resume(struct platform_device *pdev)
> > +{
> > +	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
> > +	struct snd_soc_codec *codec = socdev->card->codec;
> > +	int i;
> > +	u8 data[2];
> > +	u8 *cache = codec->reg_cache;
> > +
> > +	/* Sync reg_cache with the hardware */
> > +	for (i = 0; i < AIC3204_CACHEREGNUM; i++) {
> > +		data[0] = i;
> > +		data[1] = cache[i];
> > +		codec->hw_write(codec->control_data, data, 2);
> 
> Since you've got a register defaults table you could skip rewriting
> registers which have their default value.

Indeed, suspend/resume isn't tested at all, so no idea if it works or
not.  I should probably do a forced reset too just to be on the safe
side.  This is a reminant from the aic3x driver.

> > +	/* LDO enable, analogue blocks enable */
> > +	snd_soc_update_bits(codec, AIC3204_LDO,
> > +			AIC3204_LDO_ANALOG | AIC3204_LDO_AVDD_UP,
> > +			AIC3204_LDO_ANALOG_ENABLED |
> > +			(aic3204->pdata.ldo_en
> > +			  ? AIC3204_LDO_AVDD_UP : 0));
> 
> This looks a bit fishy since the mask covers more bits than can ever be
> enabled - it reads like the other two bits should be unconditionally
> cleared.

Would I be better breaking that statement up into two statements?  I did
them as one for efficiency, but I do recognise there is a potential
readability issue.  Basically, it clears the "analog power-down" bit in
the LDO register (yes, this inverse logic irritates me) and optionally
turns on the LDO.  I figure some users may wish to provide their own
AVDD and thus won't want the LDO.

I wasn't sure about the link between AVDD and DVDD, so I left that
configurable.  I'm guessing most will probably want it disabled.  This
was configured using arbitrary register initialisation scripts, passed
in via the CODEC setup data... so at least things are headded in the
right direction. :-)

Regards,
-- 
Stuart Longland (aka Redhatter, VK4MSL)      .'''.
Gentoo Linux/MIPS Cobalt and Docs Developer  '.'` :
. . . . . . . . . . . . . . . . . . . . . .   .'.'
http://dev.gentoo.org/~redhatter             :.'

I haven't lost my mind...
  ...it's backed up on a tape somewhere.
