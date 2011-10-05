Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934979Ab1JEQRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:17:08 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:29404 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934476Ab1JEQRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:17:03 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
Message-ID: <4E8C82F9.1030306@freescale.com>
Date: Wed, 5 Oct 2011 11:16:57 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: Return early with -EINVAL if invalid dai format
 is detected
References: <1317779135.2595.1.camel@phoenix>
In-Reply-To: <1317779135.2595.1.camel@phoenix>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Timur Tabi <timur@freescale.com>
> Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
> ---
>  sound/soc/codecs/cs4270.c  |    2 +-
>  sound/soc/codecs/cs42l51.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/codecs/cs4270.c b/sound/soc/codecs/cs4270.c
> index 5830c93..e645d67 100644
> --- a/sound/soc/codecs/cs4270.c
> +++ b/sound/soc/codecs/cs4270.c
> @@ -271,7 +271,7 @@ static int cs4270_set_dai_fmt(struct snd_soc_dai *codec_dai,
>  		break;
>  	default:
>  		dev_err(codec->dev, "invalid dai format\n");
> -		ret = -EINVAL;
> +		return -EINVAL;
>  	}
>  

If you're going to make a change like this, I say go all the way:

	/* set DAI format */
	switch (format & SND_SOC_DAIFMT_FORMAT_MASK) {
	case SND_SOC_DAIFMT_I2S:
	case SND_SOC_DAIFMT_LEFT_J:
		cs4270->mode = format & SND_SOC_DAIFMT_FORMAT_MASK;
		break;
	default:
		dev_err(codec->dev, "invalid dai format\n");
		return -EINVAL;
	}

	/* set master/slave audio interface */
	switch (format & SND_SOC_DAIFMT_MASTER_MASK) {
	case SND_SOC_DAIFMT_CBS_CFS:
		cs4270->slave_mode = 1;
		break;
	case SND_SOC_DAIFMT_CBM_CFM:
		cs4270->slave_mode = 0;
		break;
	default:
		/* all other modes are unsupported by the hardware */
---> also add an error message here
		return -EINVAL;
	}

	return 0;

Then you can delete local variable 'ret' altogether.

-- 
Timur Tabi
Linux kernel developer at Freescale

