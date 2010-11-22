Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0KVLln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 06:41:43 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57620 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab0KVLlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 06:41:42 -0500
Date: Mon, 22 Nov 2010 11:41:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: alsa-devel@alsa-project.org, Philipp Zabel <philipp.zabel@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Harald Welte <laforge@gnumonks.org>, lrg@slimlogic.co.uk
Subject: Re: [PATCH 1/3] ASoC: Asahi Kasei AK4641 codec driver
Message-ID: <20101122114137.GA15156@sirena.org.uk>
References: <1290257964-17435-1-git-send-email-mad_soft@inbox.ru> <1290257964-17435-2-git-send-email-mad_soft@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290257964-17435-2-git-send-email-mad_soft@inbox.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 03:59:22PM +0300, Dmitry Artamonow wrote:
> A driver for the AK4641 codec used in iPAQ hx4700 and Glofiish M800
> among others.

Remember to CC maintainers on patches, as documented in SubmittingPatches.
This ensures that they see your patches and they don't get lost in the
mailing list.

> +/* codec private data */
> +struct ak4641_priv {
> +       struct snd_soc_codec *codec;
> +       u8 reg_cache[AK4641_CACHEREGNUM];

Shouldn't need the register cache any more - the core should be able to
take care of allocating and managing it for you.

> +static const char *ak4641_mono_gain[] = {"+6dB", "-17dB"};

Gain controls should be exported to userspace as volume controls with
TLV information.

> +static const char *ak4641_deemp[] = {"44.1kHz", "Off", "48kHz", "32kHz"};

It is better to expose deemphasis controls as as on/off switch then
automatically select the best match for sample rate when enabled.

> +static const char *ak4641_mic_select[] = {"Internal", "External"};
> +static const char *ak4641_mic_or_dac[] = {"Microphone", "Voice DAC"};
> +
> +static const struct soc_enum ak4641_enum[] = {
> +	SOC_ENUM_SINGLE(AK4641_SIG1, 7, 2, ak4641_mono_gain),

Don't do this, declare individual variables for each enum.  Referencing
into the array by element number is really bad for legibility and as a
result maintainability - it's easy to be off by one in your count and
very hard to notice it when reading the code.

> +	SOC_SINGLE("Mic Boost (+20dB) Switch", AK4641_MIC, 0, 1, 0),

This ought to be a volume control too.

> +	SOC_SINGLE("ALC Volume", AK4641_ALC2, 0, 127, 0),
> +	SOC_SINGLE("Capture Volume", AK4641_PGA, 0, 127, 0),
> +	SOC_DOUBLE_R("Master Playback Volume", AK4641_LATT,
> +				AK4641_RATT, 0, 255, 1),
> +	SOC_SINGLE("AUX In Volume", AK4641_VOL, 0, 15, 0),
> +	SOC_SINGLE("Mic In Volume", AK4641_VOL, 4, 7, 0),

It'd be nice to supply TLV information for these.

> +	SOC_SINGLE("Mic In -4dB", AK4641_VOL, 7, 1, 0),

This should also be a Volume control.

> +	SOC_SINGLE("Equalizer", AK4641_DAC, 2, 1, 0),

Should be "Equalizer Switch".

> +static const struct snd_kcontrol_new ak4641_hpl_control =
> +	SOC_DAPM_SINGLE("Switch", AK4641_SIG2, 1, 1, 0);
> +
> +/* HP R switch */
> +static const struct snd_kcontrol_new ak4641_hpr_control =
> +	SOC_DAPM_SINGLE("Switch", AK4641_SIG2, 0, 1, 0);

I'm not sure these should be DAPM controls - it'd be more normal to do
these as just regular controls - but it does depend if there's any way
of controlling the inputs individually.  If there isn't then this makes
sense.

> +static int ak4641_pcm_hw_params(struct snd_pcm_substream *substream,
> +				 struct snd_pcm_hw_params *params,
> +				 struct snd_soc_dai *dai)
> +{
> +	/* FIXME */
> +
> +	return 0;
> +}

Either fix this or remove it - no point in having the empty function.
If removing then just set the capabilities in the DAI defintion to be
whatever the hardware defaults are.

> +
> +static int ak4641_i2s_hw_params(struct snd_pcm_substream *substream,
> +				 struct snd_pcm_hw_params *params,
> +				 struct snd_soc_dai *dai)
> +{
> +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> +	struct snd_soc_codec *codec = rtd->codec;
> +	struct ak4641_priv *ak4641 = snd_soc_codec_get_drvdata(codec);
> +	u8 mode2 = snd_soc_read(codec, AK4641_MODE2) & ~(0x3 << 5);
> +	int rate = params_rate(params), fs = 256;
> +
> +	if (rate)
> +		fs = ak4641->sysclk / rate;

If there's no rate then return an error; that should never happen.

> +
> +	/* set fs */
> +	switch (fs) {
> +	case 1024:
> +		mode2 |= (0x2 << 5);
> +		break;
> +	case 512:
> +		mode2 |= (0x1 << 5);
> +		break;
> +	case 256:
> +		break;
> +	}

I'd expect to see some reporting/handling of erronious setups here - if
you've got a clock set up for 44.1kHz and someone's trying to play 48kHz
for example.  It'd also be nice if the driver were able to tell
userspace what the constraints imposed by sysclk are if sysclk has been
configured when opening the PCM, see wm8988 for an example of doing this.
This ensures that userspace won't try to do something unsupported.

> +#define AK4641_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_11025 |\
> +		SNDRV_PCM_RATE_16000 | SNDRV_PCM_RATE_22050 |\
> +		SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000)

SNDRV_PCM_RATE_8000_48000

> +		if (gpio_is_valid(pdata->gpio_power))
> +			gpio_direction_output(pdata->gpio_power, 1);
> +		if (gpio_is_valid(pdata->gpio_npdn)) {
> +			gpio_direction_output(pdata->gpio_npdn, 0);
> +			udelay(1); /* > 150 ns */
> +			gpio_set_value(pdata->gpio_npdn, 1);
> +		}

Would it not make sense to manage the power GPIOs as part of the bias
management?  That'd seem logical and would mean that when the driver
goes to _OFF you'd be using this feature also, which would presumably
reduce the power consumption still further.  As things stand I don't see
anything that puts the GPIOs into a powersave mode.

> +static struct i2c_driver ak4641_i2c_driver = {
> +	.driver = {
> +		.name = "ak4641-codec",

Remove the -codec from the name.

> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
> +	ret = i2c_add_driver(&ak4641_i2c_driver);
> +	if (ret != 0)
> +		pr_err("Failed to register AK4641 I2C driver: %d\n", ret);
> +#endif

No need to make this conditional on I2C if the driver only supports I2C.
