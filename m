Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1JLQJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:09:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45831 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818Ab1JLQJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:09:00 -0400
Date: Wed, 12 Oct 2011 17:08:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg@ti.com, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        kuninori.morimoto.gx@renesas.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 9/9] ASoC: da7210: Add support for DAPM
Message-ID: <20111012160854.GV3647@opensource.wolfsonmicro.com>
References: <1318432251.12107.432.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318432251.12107.432.camel@matrix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 08:40:51PM +0530, Ashish Chavan wrote:
> This patch adds support for DAPM covering all inputs and outputs
> as well as ADC and DAC.

So, you added a bunch of additional routes using the register sequence
method and then add DAPM support, this seems to be the wrong way round
and isn't great for review.  Converting the existing stuff to DAPM and
then adding new features seems a lot more sensible.

> +	/* MICBIAS */
> +	SND_SOC_DAPM_MICBIAS("Mic Bias", DA7210_MIC_L, 6, 0),

Use supply widgets for biases, new code shouldn't introduce micbiases.

> +	/* Input path */
> +	{"Mic Bias", NULL, "MICR"},
> +	{"Mic Bias", NULL, "MICL"},
> +
> +	{"Mic Left", NULL, "Mic Bias"},
> +	{"Mic Right", NULL, "Mic Bias"},

Microphone bias must be hooked up by the board - for example, the system
may use an external microphone bias.

> +static int da7210_add_widgets(struct snd_soc_codec *codec)
> +{
> +	struct snd_soc_dapm_context *dapm = &codec->dapm;
> +
> +	snd_soc_dapm_new_controls(dapm, da7210_dapm_widgets,
> +				  ARRAY_SIZE(da7210_dapm_widgets));
> +	snd_soc_dapm_add_routes(dapm, da7210_audio_map,
> +				ARRAY_SIZE(da7210_audio_map));

Just assign these in the card struct.

> @@ -748,6 +942,10 @@ static int da7210_probe(struct snd_soc_codec *codec)
>  	snd_soc_write(codec, DA7210_INMIX_L, DA7210_IN_L_EN);
>  	snd_soc_write(codec, DA7210_INMIX_R, DA7210_IN_R_EN);
>  
> +	/* In mixer source selection, only MIC is selected by default */
> +	snd_soc_write(codec, DA7210_INMIX_L, 0x01);
> +	snd_soc_write(codec, DA7210_INMIX_R, 0x01);
> +

As ever just leave the chip defaults alone.

> +	/* Enable standby for all inputs and outputs */
> +	snd_soc_write(codec, DA7210_STARTUP2, DA7210_LOUT1_L_STBY |
> +		DA7210_LOUT1_R_STBY | DA7210_LOUT2_STBY | DA7210_HP_L_STBY |
> +		DA7210_HP_R_STBY | DA7210_DAC_L_STBY | DA7210_DAC_R_STBY);
> +	snd_soc_write(codec, DA7210_STARTUP3, DA7210_MIC_L_STBY |
> +		DA7210_MIC_R_STBY | DA7210_LIN1_L_STBY | DA7210_LIN1_R_STBY |
> +		DA7210_LIN2_STBY | DA7210_ADC_L_STBY | DA7210_ADC_R_STBY);
> +

This looks like it should be in set_bias_level().
