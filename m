Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab1GEH7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 03:59:15 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:5057 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab1GEH7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 03:59:14 -0400
Message-ID: <4E12C426.8050501@atmel.com>
Date: Tue, 05 Jul 2011 09:58:30 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, lrg@ti.com
CC: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: wm8731: set the ACTIVE bit if bias ON entered
References: <ccd4b125244271af7978948689cf1dcef37bc06b.1309368631.git.nicolas.ferre@atmel.com> <1309517034-26110-1-git-send-email-nicolas.ferre@atmel.com> <20110701161506.GC23784@opensource.wolfsonmicro.com> <4E118BF6.6010205@atmel.com> <20110704172856.GF28726@opensource.wolfsonmicro.com>
In-Reply-To: <20110704172856.GF28726@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 04/07/2011 19:29, Mark Brown :
> On Mon, Jul 04, 2011 at 11:46:30AM +0200, Nicolas Ferre wrote:
> 
>> Ah, ok... but I fear that I do not know the whole system enough for this
>> addition ;-(
>> Do you think you can code this modification, I will be happy to test it,
>> if you want...
> 
> It's pretty trivial - try the below (Liam, are you OK with this if it
> tests OK?):
> 
>>From 1dd054eb530641dadbf71525ee517c847f19e161 Mon Sep 17 00:00:00 2001
> From: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Date: Mon, 4 Jul 2011 10:27:51 -0700
> Subject: [PATCH] ASoC: Manage WM8731 ACTIVE bit as a supply widget
> 
> Now we have supply widgets there's no need to open code the handling of
> the ACTIVE bit.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  sound/soc/codecs/wm8731.c |   29 +++--------------------------
>  1 files changed, 3 insertions(+), 26 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
> index 2dc964b..59d9e59 100644
> --- a/sound/soc/codecs/wm8731.c
> +++ b/sound/soc/codecs/wm8731.c
> @@ -175,6 +175,7 @@ static const struct snd_kcontrol_new wm8731_input_mux_controls =
>  SOC_DAPM_ENUM("Input Select", wm8731_insel_enum);
>  
>  static const struct snd_soc_dapm_widget wm8731_dapm_widgets[] = {
> +SND_SOC_DAPM_SUPPLY("Active",WM8731_ACTIVE, 0, 0, NULL, 0),

------------------------^^^^^^^
I have replaced this with ACTIVE to match the route declaration.

*With this modification* it works, so you can add my:

Tested-by: Nicolas Ferre <nicolas.ferre@atmel.com>


>  SND_SOC_DAPM_SUPPLY("OSC", WM8731_PWR, 5, 1, NULL, 0),
>  SND_SOC_DAPM_MIXER("Output Mixer", WM8731_PWR, 4, 1,
>  	&wm8731_output_mixer_controls[0],
> @@ -204,6 +205,8 @@ static int wm8731_check_osc(struct snd_soc_dapm_widget *source,
>  static const struct snd_soc_dapm_route wm8731_intercon[] = {
>  	{"DAC", NULL, "OSC", wm8731_check_osc},
>  	{"ADC", NULL, "OSC", wm8731_check_osc},
> +	{"DAC", NULL, "ACTIVE"},
> +	{"ADC", NULL, "ACTIVE"},
>  
>  	/* output mixer */
>  	{"Output Mixer", "Line Bypass Switch", "Line Input"},
> @@ -315,29 +318,6 @@ static int wm8731_hw_params(struct snd_pcm_substream *substream,
>  	return 0;
>  }
>  
> -static int wm8731_pcm_prepare(struct snd_pcm_substream *substream,
> -			      struct snd_soc_dai *dai)
> -{
> -	struct snd_soc_codec *codec = dai->codec;
> -
> -	/* set active */
> -	snd_soc_write(codec, WM8731_ACTIVE, 0x0001);
> -
> -	return 0;
> -}
> -
> -static void wm8731_shutdown(struct snd_pcm_substream *substream,
> -			    struct snd_soc_dai *dai)
> -{
> -	struct snd_soc_codec *codec = dai->codec;
> -
> -	/* deactivate */
> -	if (!codec->active) {
> -		udelay(50);
> -		snd_soc_write(codec, WM8731_ACTIVE, 0x0);
> -	}
> -}
> -
>  static int wm8731_mute(struct snd_soc_dai *dai, int mute)
>  {
>  	struct snd_soc_codec *codec = dai->codec;
> @@ -480,7 +460,6 @@ static int wm8731_set_bias_level(struct snd_soc_codec *codec,
>  		snd_soc_write(codec, WM8731_PWR, reg | 0x0040);
>  		break;
>  	case SND_SOC_BIAS_OFF:
> -		snd_soc_write(codec, WM8731_ACTIVE, 0x0);
>  		snd_soc_write(codec, WM8731_PWR, 0xffff);
>  		regulator_bulk_disable(ARRAY_SIZE(wm8731->supplies),
>  				       wm8731->supplies);
> @@ -496,9 +475,7 @@ static int wm8731_set_bias_level(struct snd_soc_codec *codec,
>  	SNDRV_PCM_FMTBIT_S24_LE)
>  
>  static struct snd_soc_dai_ops wm8731_dai_ops = {
> -	.prepare	= wm8731_pcm_prepare,
>  	.hw_params	= wm8731_hw_params,
> -	.shutdown	= wm8731_shutdown,
>  	.digital_mute	= wm8731_mute,
>  	.set_sysclk	= wm8731_set_dai_sysclk,
>  	.set_fmt	= wm8731_set_dai_fmt,


-- 
Nicolas Ferre

