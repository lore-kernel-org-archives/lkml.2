Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab2IEQn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:43:27 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:55685 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752056Ab2IEQn0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:43:26 -0400
Subject: Re: [PATCH] Don't clobber access methods when !regmap
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <50477FA9.8060905@metafoo.de>
Date: Wed, 5 Sep 2012 19:43:20 +0300
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D96C7824-5EBC-4418-B016-DCE395A720D7@antoniou-consulting.com>
References: <1346939132-20187-1-git-send-email-panto@antoniou-consulting.com> <50477FA9.8060905@metafoo.de>
To: Lars-Peter Clausen <lars@metafoo.de>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Sep 5, 2012, at 7:36 PM, Lars-Peter Clausen wrote:

> On 09/06/2012 03:45 PM, Pantelis Antoniou wrote:
>> A snd-soc driver that doesn't support regmap blow up horribly
>> when you assume that regmap is available. Fix it by marking
>> the driver as not supporting regmap & not clobbering the codec
>> access methods.
>> 
>> This is immediately noticeable on the beagleboard where we crash,
>> since we might have REGMAP enabled, but it doesn't mean that the
>> omap driver uses it.
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> 
> But calling snd_soc_codec_set_cache_io sort of implies that you are using
> regmap. If you are not using regmap your codec should not call
> snd_soc_codec_set_cache_io.
> 
> - Lars
> 

The driver in question (twl4030.c) does not call snd_soc_codec_set_cache_io().
However the snd-soc core does call it in sound/soc/soc-core.c in soc_probe_codec.

I do see that there's a commit 98d3088e534a2a61f6690b5426909b0c3b57a785 that is
fixing it in a different manner.

> diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
> index f219b2f..f81c597 100644
> --- a/sound/soc/soc-core.c
> +++ b/sound/soc/soc-core.c
> @@ -1096,7 +1096,7 @@ static int soc_probe_codec(struct snd_soc_card *card,
>         }
>  
>         /* If the driver didn't set I/O up try regmap */
> -       if (!codec->control_data)
> +       if (!codec->write && dev_get_regmap(codec->dev, NULL))
>                 snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
>  
>         if (driver->controls)
> 
> 

Originally it was call unconditionally, but now it should work. Let me check this
and I'll report back.

Regards

-- Pantelis


>> 
>> ---
>> sound/soc/soc-io.c | 14 ++++++++++----
>> 1 file changed, 10 insertions(+), 4 deletions(-)
>> 
>> diff --git a/sound/soc/soc-io.c b/sound/soc/soc-io.c
>> index 29183ef..4e5b4ae 100644
>> --- a/sound/soc/soc-io.c
>> +++ b/sound/soc/soc-io.c
>> @@ -117,9 +117,6 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
>> 	int ret;
>> 
>> 	memset(&config, 0, sizeof(config));
>> -	codec->write = hw_write;
>> -	codec->read = hw_read;
>> -	codec->bulk_write_raw = snd_soc_hw_bulk_write_raw;
>> 
>> 	config.reg_bits = addr_bits;
>> 	config.val_bits = data_bits;
>> @@ -151,7 +148,9 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
>> 			 * multiples */
>> 			if (ret > 0)
>> 				codec->val_bytes = ret;
>> -		}
>> +		} else
>> +			codec->using_regmap = false;
>> +
>> 		break;
>> 
>> 	default:
>> @@ -161,6 +160,13 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
>> 	if (IS_ERR(codec->control_data))
>> 		return PTR_ERR(codec->control_data);
>> 
>> +	/* only when using regmap; don't modify unconditionally */
>> +	if (codec->using_regmap) {
>> +		codec->write = hw_write;
>> +		codec->read = hw_read;
>> +		codec->bulk_write_raw = snd_soc_hw_bulk_write_raw;
>> +	}
>> +
>> 	return 0;
>> }
>> EXPORT_SYMBOL_GPL(snd_soc_codec_set_cache_io);
> 

