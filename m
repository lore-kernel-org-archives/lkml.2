Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab2IDGgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 02:36:10 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41148 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2IDGgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 02:36:08 -0400
Message-ID: <5045A11B.3070300@gmail.com>
Date: Tue, 04 Sep 2012 08:35:07 +0200
From: =?UTF-8?B?R2HDq3RhbiBDYXJsaWVy?= <gcembed@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Javier Martin <javier.martin@vista-silicon.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        broonie@opensource.wolfsonmicro.com, fabio.estevam@freescale.com,
        s.hauer@pengutronix.de
Subject: Re: [ASoC] Fix: Revert 'ASoC: imx-ssi: Remove mono support'.
References: <1346660831-9662-1-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1346660831-9662-1-git-send-email-javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,
On 09/03/2012 10:27 AM, Javier Martin wrote:
> The following commit should be reverted: 0865a75d4166bddc533fd50831829ceefb94f9b0
>
> The bug this patch is meant to solve doesn't occur in Visstrim_M10 boards.
> Furthermore, after applying this patch sound in Visstrim_M10 is played
> at slower rates.
>
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
> diff --git b/sound/soc/fsl/imx-ssi.c a/sound/soc/fsl/imx-ssi.c
> index ac337ac..28dd76c 100644
> --- b/sound/soc/fsl/imx-ssi.c
> +++ a/sound/soc/fsl/imx-ssi.c
> @@ -380,13 +380,13 @@ static int imx_ssi_dai_probe(struct snd_soc_dai *dai)
>   static struct snd_soc_dai_driver imx_ssi_dai = {
>   	.probe = imx_ssi_dai_probe,
>   	.playback = {
> -		.channels_min = 2,
> +		.channels_min = 1,
>   		.channels_max = 2,
>   		.rates = SNDRV_PCM_RATE_8000_96000,
>   		.formats = SNDRV_PCM_FMTBIT_S16_LE,
>   	},
>   	.capture = {
> -		.channels_min = 2,
> +		.channels_min = 1,
>   		.channels_max = 2,
>   		.rates = SNDRV_PCM_RATE_8000_96000,
>   		.formats = SNDRV_PCM_FMTBIT_S16_LE,
>
When applied on linux-next-20120824, the patch failed because original 
imx-ssi.c file looks like :
static struct snd_soc_dai_driver imx_ssi_dai = {
	.probe = imx_ssi_dai_probe,
	.playback = {
		/* The SSI does not support monaural audio. */
		.channels_min = 2,
		.channels_max = 2,
		.rates = SNDRV_PCM_RATE_8000_96000,
		.formats = SNDRV_PCM_FMTBIT_S16_LE,
	},
	.capture = {
		.channels_min = 2,
		.channels_max = 2,
		.rates = SNDRV_PCM_RATE_8000_96000,
		.formats = SNDRV_PCM_FMTBIT_S16_LE,
	},
	.ops = &imx_ssi_pcm_dai_ops,
};

The comment line is missing in your patch. Here is the right patch :

@@ -378,18 +378,17 @@ static int imx_ssi_dai_probe(struct snd_soc_dai *dai)
  }

  static struct snd_soc_dai_driver imx_ssi_dai = {
  	.probe = imx_ssi_dai_probe,
  	.playback = {
-		/* The SSI does not support monaural audio. */
-		.channels_min = 2,
+		.channels_min = 1,
  		.channels_max = 2,
  		.rates = SNDRV_PCM_RATE_8000_96000,
  		.formats = SNDRV_PCM_FMTBIT_S16_LE,
  	},
  	.capture = {
-		.channels_min = 2,
+		.channels_min = 1,
  		.channels_max = 2,
  		.rates = SNDRV_PCM_RATE_8000_96000,
  		.formats = SNDRV_PCM_FMTBIT_S16_LE,
  	},
  	.ops = &imx_ssi_pcm_dai_ops,

Regards,
Gaëtan Carlier.
