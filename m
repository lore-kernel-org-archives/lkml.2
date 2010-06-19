Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0FSBML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 21:12:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48455 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753863Ab0FSBMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 21:12:09 -0400
Date: Sat, 19 Jun 2010 02:12:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stuart Longland <redhatter@gentoo.org>
Cc: ALSA Development List <alsa-devel@alsa-project.org>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ASoC: Add new TI TLV320AIC3204 CODEC driver
Message-ID: <20100619011221.GC2463@opensource.wolfsonmicro.com>
References: <1276833465-31702-1-git-send-email-redhatter@gentoo.org>
 <1276899876-19001-1-git-send-email-redhatter@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276899876-19001-1-git-send-email-redhatter@gentoo.org>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 08:24:36AM +1000, Stuart Longland wrote:

This all looks pretty good, the comments below are fairly minor.

> +	/* AVDD <->DVDD Link enable */
> +	u8	avdd_link_en;

What's this?  It looks like a boolean which makes u8 an odd choice.

> +	/* LDO Enable */
> +	u8	ldo_en;

Similarly here.

> +
> +	/* Oversampling rate (both ADC and DAC) */
> +	u8	osr;

Why is this platform data rather than a runtime configurable option?

> +config SND_SOC_TLV320AIC3204
> +	tristate
> +	depends on I2C
> +

Drop the depends, it doesn't actually do anything for selected items.

> +	/* Page 1 */
> +	if (page == 1) {
> +		if (reg <= 4)
> +			return 1;

I can't help but think that this'd be more legible with switch ()
statements (GCC has an extension for ranges in switch statements which
you could use).

> +/*
> + * Pretty-print the value of a register
> + */
> +static int aic3204_show_reg(struct snd_soc_codec *codec, char *buf,
> +		int buf_sz, unsigned int reg)
> +{
> +	return snprintf(buf, buf_sz, "%02x",
> +			aic3204_read_reg_cache(codec, reg));
> +}

This looks suspiciously close to the standard show_reg() - it seems
wrong that you should need it.

> +	/*
> +	 * These registers are not manipulated by us, so we must read them from
> +	 * the CODEC directly.
> +	 */

Hrm?  Also, it strikes me that this code is also used in the WCLK
function and might benefit from being factored out - it's moderately
verbose.

> +static const char *aic3204_micbias_voltages[] = {
> +	"Low", "Med", "High", "V+"
> +};

I'd be inclined to spell medium out and write "V+" as "Supply" or
similar unless there's a strong reason to do otherwise - it seems more
legible.

> +static const char *aic3204_ldac_srcs[] = {
> +	"disabled", "left channel", "right channel", "mix"
> +};

Capital letters are more idiomatic for enumerations.

> +/*
> + * DAC digital volumes. From -63.5 to +24 dB in 0.5 dB steps.
> + * Does not mute control.
> + */

I'm finding these comments a little too verbose but that's just me -
I stop and read them only to find there's nothing odd going on here.

> +	/*
> +	 * Note regarding SOC_DOUBLE_R_SX_TLV...
> +	 *
> +	 * This is a bit misleading; xshift refers to the bit one bit *past*
> +	 * the most significant bit.  Or at least that's what it appears to be
> +	 * doing the math.  Mask needs to select the last 6 bits; which is the
> +	 * signed bitfield specifiying the gain in dB.
> +	 */

I suspect that fixing the control may break what you're doing here?  It
would certainly bitrot the comment.

> +	SOC_SINGLE("Differential Output Switch", AIC3204_DACS2,
> +			AIC3204_DACS2_RMOD_INV_SHIFT, 1, 0),

This feels like platform data - the use of differential outputs is
normally a property of the physical wiring of the board, it's very rare
to be able to vary this usefully at runtime.

> +	/* MICBIAS Options */
> +	SOC_SINGLE("MICBIAS Enable", AIC3204_MICBIAS, 6, 0x1, 0),

MICBIAS Enable should definitely be DAPM.

> +	SOC_ENUM("MICBIAS Level", aic3204_enum_micbias_voltage),
> +	SOC_ENUM("MICBIAS Source", aic3204_enum_micbias_src),

These I would expect to be managed in kernel - they're normally either a
property of the board or need to be managed in conjunction with jack
detection code which tends to live in kernel.

> +static const struct snd_soc_dapm_widget aic3204_dapm_widgets[] = {
> +	/* Driver/Amplifier Selection */
> +	SND_SOC_DAPM_SWITCH("HPL Playback Switch", AIC3204_OUTDRV,
> +			AIC3204_OUTDRV_HPL_UP_SHIFT, 0,
> +			&aic3204_hpl_switch),
> +	SND_SOC_DAPM_SWITCH("HPR Playback Switch", AIC3204_OUTDRV,
> +			AIC3204_OUTDRV_HPR_UP_SHIFT, 0,
> +			&aic3204_hpr_switch),

A lot of these SWITCH controls feel like they ought to be PGAs and the
switch controls mutes on those.  When muting an output you normally
don't want to power up and down the path since that is slow and tends to
trigger audible issues, you'd normally control the power for path
endpoints and elements that affect routing only.

> +	SND_SOC_DAPM_AIF_IN("Left Data In", "Left Playback",
> +			0, SND_SOC_NOPM, 0, 0),
> +	SND_SOC_DAPM_AIF_IN("Right Data In", "Right Playback",
> +			1, SND_SOC_NOPM, 0, 0),
> +	SND_SOC_DAPM_AIF_OUT("Left Data Out", "Left Capture",
> +			0, SND_SOC_NOPM, 0, 0),
> +	SND_SOC_DAPM_AIF_OUT("Right Data Out", "Right Capture",
> +			1, SND_SOC_NOPM, 0, 0),

You have these AIF widgets but at least the DAC input selection was
being done in the regular controls rather than in the DAPM routing.

> +	/*
> +	 * Set BCLK and WCLK sources...
> +	 *
> +	 * Despite DAPM; this is still needed, as DAPM doesn't yet set the
> +	 * source at the right time.
> +	 *
> +	 * TODO: See if we can change the order of initialisation so this
> +	 * selection is made after bringing up the ADCs/DACs.  Alternative:
> +	 * see if we can find out ahead of time which one to use.

It surprises me that the ordering matters too much here; worst case you
leave the interface declocked a little longer when you need to switch
sources but that doesn't seem like the end of the world?

> +	snd_soc_update_bits(codec, AIC3204_AISR3, AIC3204_AISR3_BDIV,
> +			(substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
> +				? AIC3204_AISR3_BDIV_DAC
> +				: AIC3204_AISR3_BDIV_ADC);

I have to say that I'm really not a fan of the ternery operator for
legibility.

> +static int aic3204_mute(struct snd_soc_dai *dai, int mute)
> +{

...

> +	aic3204_write(codec, AIC3204_DACS2, dacs2);	/* Unmute DAC */

...or possibly mute it :)

> +static int aic3204_resume(struct platform_device *pdev)
> +{
> +	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
> +	struct snd_soc_codec *codec = socdev->card->codec;
> +	int i;
> +	u8 data[2];
> +	u8 *cache = codec->reg_cache;
> +
> +	/* Sync reg_cache with the hardware */
> +	for (i = 0; i < AIC3204_CACHEREGNUM; i++) {
> +		data[0] = i;
> +		data[1] = cache[i];
> +		codec->hw_write(codec->control_data, data, 2);

Since you've got a register defaults table you could skip rewriting
registers which have their default value.

> +	/* LDO enable, analogue blocks enable */
> +	snd_soc_update_bits(codec, AIC3204_LDO,
> +			AIC3204_LDO_ANALOG | AIC3204_LDO_AVDD_UP,
> +			AIC3204_LDO_ANALOG_ENABLED |
> +			(aic3204->pdata.ldo_en
> +			  ? AIC3204_LDO_AVDD_UP : 0));

This looks a bit fishy since the mask covers more bits than can ever be
enabled - it reads like the other two bits should be unconditionally
cleared.
