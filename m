Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab2IEQcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:32:11 -0400
Received: from smtp-out-233.synserver.de ([212.40.185.233]:1090 "EHLO
	smtp-out-233.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab2IEQcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:32:08 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22067
Message-ID: <50477FA9.8060905@metafoo.de>
Date: Wed, 05 Sep 2012 18:36:57 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] Don't clobber access methods when !regmap
References: <1346939132-20187-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1346939132-20187-1-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 03:45 PM, Pantelis Antoniou wrote:
> A snd-soc driver that doesn't support regmap blow up horribly
> when you assume that regmap is available. Fix it by marking
> the driver as not supporting regmap & not clobbering the codec
> access methods.
> 
> This is immediately noticeable on the beagleboard where we crash,
> since we might have REGMAP enabled, but it doesn't mean that the
> omap driver uses it.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

But calling snd_soc_codec_set_cache_io sort of implies that you are using
regmap. If you are not using regmap your codec should not call
snd_soc_codec_set_cache_io.

- Lars

> 
> ---
>  sound/soc/soc-io.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/sound/soc/soc-io.c b/sound/soc/soc-io.c
> index 29183ef..4e5b4ae 100644
> --- a/sound/soc/soc-io.c
> +++ b/sound/soc/soc-io.c
> @@ -117,9 +117,6 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
>  	int ret;
>  
>  	memset(&config, 0, sizeof(config));
> -	codec->write = hw_write;
> -	codec->read = hw_read;
> -	codec->bulk_write_raw = snd_soc_hw_bulk_write_raw;
>  
>  	config.reg_bits = addr_bits;
>  	config.val_bits = data_bits;
> @@ -151,7 +148,9 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
>  			 * multiples */
>  			if (ret > 0)
>  				codec->val_bytes = ret;
> -		}
> +		} else
> +			codec->using_regmap = false;
> +
>  		break;
>  
>  	default:
> @@ -161,6 +160,13 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
>  	if (IS_ERR(codec->control_data))
>  		return PTR_ERR(codec->control_data);
>  
> +	/* only when using regmap; don't modify unconditionally */
> +	if (codec->using_regmap) {
> +		codec->write = hw_write;
> +		codec->read = hw_read;
> +		codec->bulk_write_raw = snd_soc_hw_bulk_write_raw;
> +	}
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(snd_soc_codec_set_cache_io);

