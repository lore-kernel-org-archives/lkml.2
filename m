Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1I1HNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:13:38 -0400
Received: from smtp-out-142.synserver.de ([212.40.185.142]:1121 "HELO
	smtp-out-141.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753281Ab1I1HNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:13:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 14868
Message-ID: <4E82C90A.5090905@metafoo.de>
Date: Wed, 28 Sep 2011 09:13:14 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Cliff Cai <cliff.cai@analog.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] ASoC: adau1701: Initialize codec->control_data before
 using it
References: <1317188861.13692.1.camel@phoenix>
In-Reply-To: <1317188861.13692.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 07:47 AM, Axel Lin wrote:
> Currently codec->control_data is not initialized before calling
> process_sigma_firmware(codec->control_data, ADAU1701_FIRMWARE).

Just replacing codec->control_data with to_i2c_client(codec->dev) should be a
simpler patch to fix the issue.

Thanks
- Lars

> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/adau1701.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/codecs/adau1701.c b/sound/soc/codecs/adau1701.c
> index 2758d5f..1354902 100644
> --- a/sound/soc/codecs/adau1701.c
> +++ b/sound/soc/codecs/adau1701.c
> @@ -88,6 +88,7 @@
>  
>  struct adau1701 {
>  	unsigned int dai_fmt;
> +	void *control_data;
>  };
>  
>  static const struct snd_kcontrol_new adau1701_controls[] = {
> @@ -455,9 +456,11 @@ static struct snd_soc_dai_driver adau1701_dai = {
>  
>  static int adau1701_probe(struct snd_soc_codec *codec)
>  {
> +	struct adau1701 *adau1701 = snd_soc_codec_get_drvdata(codec);
>  	int ret;
>  
>  	codec->dapm.idle_bias_off = 1;
> +	codec->control_data = adau1701->control_data;
>  
>  	ret = adau1701_load_firmware(codec);
>  	if (ret)
> @@ -500,6 +503,7 @@ static __devinit int adau1701_i2c_probe(struct i2c_client *client,
>  		return -ENOMEM;
>  
>  	i2c_set_clientdata(client, adau1701);
> +	adau1701->control_data = client;
>  	ret = snd_soc_register_codec(&client->dev, &adau1701_codec_drv,
>  			&adau1701_dai, 1);
>  	if (ret < 0)

