Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab1JRPrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:47:10 -0400
Received: from smtp-out-070.synserver.de ([212.40.185.70]:1200 "EHLO
	smtp-out-054.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932541Ab1JRPrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:47:08 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1246
Message-ID: <4E9D9F88.109@metafoo.de>
Date: Tue, 18 Oct 2011 17:47:20 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111005 Iceowl/1.0b2 Icedove/3.1.15
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Barry Song <21cnbao@gmail.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH v2] ASoC: ad193x: Use snd_soc_update_bits
 for read-modify-write
References: <1318890308.15935.0.camel@phoenix>
In-Reply-To: <1318890308.15935.0.camel@phoenix>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2011 12:25 AM, Axel Lin wrote:
> Use snd_soc_update_bits for read-modify-write register access instead of
> open-coding it using snd_soc_read and snd_soc_write
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks

> ---
>  sound/soc/codecs/ad193x.c |   31 +++++++++++++++----------------
>  1 files changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
> index 39056ce..1206021 100644
> --- a/sound/soc/codecs/ad193x.c
> +++ b/sound/soc/codecs/ad193x.c
> @@ -103,12 +103,14 @@ static const struct snd_soc_dapm_route audio_paths[] = {
>  static int ad193x_mute(struct snd_soc_dai *dai, int mute)
>  {
>  	struct snd_soc_codec *codec = dai->codec;
> -	int reg;
>  
> -	reg = snd_soc_read(codec, AD193X_DAC_CTRL2);
> -	reg = (mute > 0) ? reg | AD193X_DAC_MASTER_MUTE : reg &
> -		(~AD193X_DAC_MASTER_MUTE);
> -	snd_soc_write(codec, AD193X_DAC_CTRL2, reg);
> +	if (mute)
> +		snd_soc_update_bits(codec, AD193X_DAC_CTRL2,
> +				    AD193X_DAC_MASTER_MUTE,
> +				    AD193X_DAC_MASTER_MUTE);
> +	else
> +		snd_soc_update_bits(codec, AD193X_DAC_CTRL2,
> +				    AD193X_DAC_MASTER_MUTE, 0);
>  
>  	return 0;
>  }
> @@ -262,7 +264,7 @@ static int ad193x_hw_params(struct snd_pcm_substream *substream,
>  		struct snd_pcm_hw_params *params,
>  		struct snd_soc_dai *dai)
>  {
> -	int word_len = 0, reg = 0, master_rate = 0;
> +	int word_len = 0, master_rate = 0;
>  
>  	struct snd_soc_pcm_runtime *rtd = substream->private_data;
>  	struct snd_soc_codec *codec = rtd->codec;
> @@ -297,18 +299,15 @@ static int ad193x_hw_params(struct snd_pcm_substream *substream,
>  		break;
>  	}
>  
> -	reg = snd_soc_read(codec, AD193X_PLL_CLK_CTRL0);
> -	reg = (reg & (~AD193X_PLL_INPUT_MASK)) | master_rate;
> -	snd_soc_write(codec, AD193X_PLL_CLK_CTRL0, reg);
> +	snd_soc_update_bits(codec, AD193X_PLL_CLK_CTRL0,
> +			    AD193X_PLL_INPUT_MASK, master_rate);
>  
> -	reg = snd_soc_read(codec, AD193X_DAC_CTRL2);
> -	reg = (reg & (~AD193X_DAC_WORD_LEN_MASK))
> -		| (word_len << AD193X_DAC_WORD_LEN_SHFT);
> -	snd_soc_write(codec, AD193X_DAC_CTRL2, reg);
> +	snd_soc_update_bits(codec, AD193X_DAC_CTRL2,
> +			    AD193X_DAC_WORD_LEN_MASK,
> +			    word_len << AD193X_DAC_WORD_LEN_SHFT);
>  
> -	reg = snd_soc_read(codec, AD193X_ADC_CTRL1);
> -	reg = (reg & (~AD193X_ADC_WORD_LEN_MASK)) | word_len;
> -	snd_soc_write(codec, AD193X_ADC_CTRL1, reg);
> +	snd_soc_update_bits(codec, AD193X_ADC_CTRL1,
> +			    AD193X_ADC_WORD_LEN_MASK, word_len);
>  
>  	return 0;
>  }

