Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1KYO3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 09:29:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50618 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753611Ab1KYO3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 09:29:02 -0500
Date: Fri, 25 Nov 2011 14:28:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v2] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20111125142858.GE5315@opensource.wolfsonmicro.com>
References: <1322224743-15671-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322224743-15671-1-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 09:39:03PM +0900, Tomoya MORINAGA wrote:

This is better than the previous version but the major issue is that the
driver isn't really fitting in with the subsystem - it's still relying
on hard coded register write sequences for example.

> ML26124-01HB/ML26124-02GD is 16bit monaural audio CODEC which has high
> resistance to voltage noise. On chip regulator realizes power supply rejection
> ratio (PSRR) be over 90dB so more than 50dB is improved than ever. ML26124-01HB/

You should fix the word wrapping in your commit message to be well
within 80 columns.

> +struct ml26124_priv {
> +	enum snd_soc_control_type control_type;

Since the device only supports I2C you should just unconditionally use
I2C.  You should also use regmap for register access.

> +static const struct snd_kcontrol_new ml26124_snd_controls[] = {
> +	SOC_SINGLE_TLV("Capture Digital Volume", ML26124_RECORD_DIG_VOL, 0, 0xff, 1, rec_play_digi_vol),
> +	SOC_SINGLE_TLV("Playback Digital Volume", ML26124_PLBAK_DIG_VOL, 0, 0xff, 1, rec_play_digi_vol),

> +	SOC_SINGLE("Digital Volume Switch", ML26124_FILTER_EN, 4, 1, 0),

This needs either a Playback or Capture in there to match up with the
above unless it genuinely does mute both which would be really weird.

> +	SND_SOC_DAPM_VMID("VMID"),

Remove this unless it's actually used in your routing.

> +	SND_SOC_DAPM_MICBIAS("MICBIAS", ML26124_PW_REF_PW_MNG, 0, 0),

This should be a supply widget, MICBIAS widgets are legacy.

> +	SND_SOC_DAPM_MIXER("Output Mixer", ML26124_PW_SPAMP_PW_MNG, 0x1f, 0, 
> +			   &ml26124_output_mixer_controls[0],
> +			   ARRAY_SIZE(ml26124_output_mixer_controls)),

Do you *really* have a shift of 0x1f for the enable bit?

> +static int ml26124_snd_card_codec_set(int number, struct ml26124_priv *priv,
> +				      struct snd_soc_codec *codec)
> +{
> +	unsigned char data;
> +	unsigned int rate = priv->rate;
> +	unsigned int channels = priv->ch;
> +
> +	data = snd_soc_read(codec, ML26124_PW_MICBIAS_VOL);
> +	snd_soc_update_bits(codec, ML26124_SW_RST, 0x01, 1);	/* soft reset assert */
> +	snd_soc_update_bits(codec, ML26124_SW_RST, 0x01, 0);	/* soft reset negate */
> +
> +	snd_soc_update_bits(codec, 0x0c, 0x1f, 0);	/* Stop clock  */

The same issue as with your previous submission applies to this function
- you shouldn't have hard coded register write sequences in your code,
the driver should use the facilities of the subsystem to allow the user
to configure it at runtime.  Given how big an issue this is I've stopped
reading at this point.
