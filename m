Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab1K1NXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 08:23:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52186 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876Ab1K1NXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 08:23:20 -0500
Date: Mon, 28 Nov 2011 13:23:18 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v3] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20111128132317.GD8275@opensource.wolfsonmicro.com>
References: <1322474755-18785-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322474755-18785-1-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 07:05:55PM +0900, Tomoya MORINAGA wrote:
> ML26124-01HB/ML26124-02GD is 16bit monaural audio CODEC which has high
> resistance to voltage noise. On chip regulator realizes power supply rejection
> ratio (PSRR) be over 90dB so more than 50dB is improved than ever. ML26124-01HB/

To repeat what I said last time please fix the word wrapping in your
commit message.

> +struct ml26124_priv {
> +	struct snd_pcm_substream *substream;
> +};

I can't see this being referenced anywhere in the code.

> +/* ML26124 configuration */
> +static const DECLARE_TLV_DB_SCALE(digital_vol, -7150, 50, 0);
> +static const DECLARE_TLV_DB_SCALE(eq_band_gain, -7150, 50, 0);

These are identical.

> +	SOC_SINGLE_TLV("EQ Band1 Input Volume", ML26124_EQ_GAIN_BRAND1, 0,
> +			0xff, 1, eq_band_gain),

> +	SOC_SINGLE("EQ BAND1 Switch", ML26124_FILTER_EN, 3, 1, 0),

These should mathc.

> +	SOC_SINGLE("Play Limitter Switch", ML26124_DVOL_CTL, 0, 1, 0),
> +	SOC_SINGLE("Capture Limitter Switch", ML26124_DVOL_CTL, 1, 1, 0),

Limiter.

> +	SOC_SINGLE("Digital Volume Switch", ML26124_DVOL_CTL, 4, 1, 0),

Volume Switch makes no sense.

> +	SOC_DAPM_SINGLE("Line in Switch", ML26124_SPK_AMP_OUT, 3, 1, 0),

Line In.

> +       case 16000:
> +               snd_soc_update_bits(codec, ML26124_SMPLING_RATE, 0xf, 3);
> +               snd_soc_update_bits(codec, ML26124_PLLNL, 0xff, 0x0c);
> +               snd_soc_update_bits(codec, ML26124_PLLNH, 0x1, 0);
> +               snd_soc_update_bits(codec, ML26124_PLLML, 0xff, 0x20);
> +               snd_soc_update_bits(codec, ML26124_PLLMH, 0x3f, 0x00);
> +               snd_soc_update_bits(codec, ML26124_PLLDIV, 0x1f, 0x04);
> +               break;

You're configuring the PLL here...  I assume there's some fixed clock
rate that your driver supports, you should at least say what it is.

> +static int snd_card_ml7213i2s_hw_free(struct snd_pcm_substream *substream,
> +				      struct snd_soc_dai *dai)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +
> +	/* soft reset assert */
> +	snd_soc_update_bits(codec, ML26124_SW_RST, 0x01, 1);

If you need to do this for some reason I'd expect it to be in the bias
configuration.  Apart from anything else this will run for both playback
and capture streams.  I'm also not seeing anything that restores the
register cache later on.

> +	/* Stop  Record/Playback Running */
> +	snd_soc_update_bits(codec, ML26124_REC_PLYBAK_RUN, 0x3, 0);

This seems a bit odd immediately after the device was reset...

> +#define ML26134_CACHESIZE 79
> +static const u16 ml26124_reg[ML26134_CACHESIZE] = {

As previously mentioned you should use regmap.

> +static int ml26124_set_bias_level(struct snd_soc_codec *codec,
> +		enum snd_soc_bias_level level)
> +{
> +	switch (level) {
> +	case SND_SOC_BIAS_ON:
> +		/* VMID ON */
> +		snd_soc_update_bits(codec, ML26124_PW_REF_PW_MNG,
> +				    ML26124_VMID, ML26124_VMID);
> +	case SND_SOC_BIAS_PREPARE:
> +	case SND_SOC_BIAS_STANDBY:
> +		break;
> +	case SND_SOC_BIAS_OFF:
> +		/* VMID OFF */
> +		snd_soc_update_bits(codec, ML26124_PW_REF_PW_MNG,
> +				    ML26124_VMID, 0);
> +		break;

I'd be very surprised if this works well - you're powering up VMID
after DAPM has finished and there's no delay at all for bringing up
VMID.

> +#define ML26124_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_11025 |\
> +		       SNDRV_PCM_RATE_16000 | SNDRV_PCM_RATE_22050 |\
> +		       SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_44100 |\
> +		       SNDRV_PCM_RATE_48000)

This doesn't match the set of rates for which you're configuring magic
values at all.

> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (priv == NULL)
> +		return -ENOMEM;

devm_kzalloc().
