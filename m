Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab2DMJK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:10:58 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:54369 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab2DMJK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:10:56 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AohnAMfsh09V5qnhPGdsb2JhbABCijSsSgSBBBkBAQEBNzSCCQEBBAEnExwjBQsIAw44FCUKGgoJiAkJtmsTi0mFGGMElWuGAoNViUk
X-IronPort-AV: E=Sophos;i="4.75,416,1330902000"; 
   d="scan'208";a="16023717"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 13 Apr 2012 11:13:30 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 09/16 v2] Input: atmel_mxt_ts - optimize writing of
 object table entries
Message-ID: <20120413091330.GB3923@polaris.bitmath.org>
References: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
 <1333039766-8617-10-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333039766-8617-10-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> Write each object using a single bulk i2c write transfer.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index a865967..3abc5b0 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -628,33 +628,33 @@ end:
>  static int mxt_check_reg_init(struct mxt_data *data)
>  {
>  	const struct mxt_platform_data *pdata = data->pdata;
> -	struct mxt_object *object;
>  	struct device *dev = &data->client->dev;
> -	int index = 0;
> -	int i, j, config_offset, config_size;
> +	int i, offset;
> +	int ret;
>  
>  	if (!pdata->config) {
>  		dev_dbg(dev, "No cfg data defined, skipping reg init\n");
>  		return 0;
>  	}
>  
> -	for (i = 0; i < data->info.object_num; i++) {
> -		object = data->object_table + i;
> +	for (offset = 0, i = 0; i < data->info.object_num; i++) {
> +		struct mxt_object *object = &data->object_table[i];
> +		size_t config_size;
>  
>  		if (!mxt_object_writable(object->type))
>  			continue;
>  
>  		config_size = object->size * object->instances;
> -		for (j = 0; j < config_size; j++) {
> -			config_offset = index + j;
> -			if (config_offset > pdata->config_length) {
> -				dev_err(dev, "Not enough config data!\n");
> -				return -EINVAL;
> -			}
> -			mxt_write_object(data, object->type, j,
> -					 pdata->config[config_offset]);
> +		if (offset + config_size > pdata->config_length) {
> +			dev_err(dev, "Not enough config data!\n");
> +			return -EINVAL;
>  		}
> -		index += config_size;
> +
> +		ret = mxt_write_reg(data->client, object->start_address,
> +				    config_size, &pdata->config[offset]);

How big is config_size? Removing the need for a stack copy here would
be better, see patch 11.

> +		if (ret)
> +			return ret;
> +		offset += config_size;
>  	}
>  
>  	return 0;
> -- 
> 1.7.7.3
> 

Thanks,
Henrik
