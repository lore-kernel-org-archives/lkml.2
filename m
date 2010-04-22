Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab0DVHOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 03:14:44 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37437 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab0DVHOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 03:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VJ4rqJaNgTpXKGdCM9rN862+68M9+GhYPVGhqZNYHfqgSXqLboOdkO/4RLpK/Y1TGf
         qHQi0t1nGWTbg6SQ+HqJry0oI8z+6EtAZKT+3GGgl1HCbozm/Im1gFuQwPGqW0TTOW5Z
         sVREeob6FPmffJHL3T59zQXkVL1LrPLcA/Ogo=
Date: Thu, 22 Apr 2010 11:14:38 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Ryan Mallon <ryan@bluewatersys.com>, linux-kernel@vger.kernel.org,
       Yulia Vilensky <vilensky@compulab.co.il>
Subject: Re: [PATCH] ds2782_battery: add support for ds2786 battery gas
 gauge
Message-ID: <20100422071437.GA32489@oksana.dev.rtsoft.ru>
References: <1271919172-12175-1-git-send-email-mike@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1271919172-12175-1-git-send-email-mike@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 22, 2010 at 09:52:52AM +0300, Mike Rapoport wrote:
> From: Yulia Vilensky <vilensky@compulab.co.il>
> 
> Signed-off-by: Yulia Vilensky <vilensky@compulab.co.il>
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> ---

Thanks for the patch, looks good overall. Few comments below.

[...]
> +struct ds278x_battery_ops {
> +	int	(*get_temp)(struct ds278x_info *info, int *temp);
> +	int	(*get_current)(struct ds278x_info *info, int *current_uA);
> +	int	(*get_voltage)(struct ds278x_info *info, int *voltage_uA);
> +	int	(*get_capacity)(struct ds278x_info *info, int *capacity_uA);
> +

Unneeded empty line.

[...]
>  
> -	info->battery.name = kasprintf(GFP_KERNEL, "ds2782-%d", num);
> +	info->battery.name = kasprintf(GFP_KERNEL, "ds278x-%d", num);

I'm a bit worried about this, as this will change sysfs stuff.
I tend to think that this won't cause any real issues, but just
to be on a safe side, can we change that to
kasprintf(GFP_KERNEL, "%s-%d", client->name, num); ?

>  	if (!info->battery.name) {
>  		ret = -ENOMEM;
>  		goto fail_name;
> @@ -277,7 +399,10 @@ static int ds2782_battery_probe(struct i2c_client *client,
>  
>  	i2c_set_clientdata(client, info);
>  	info->client = client;
> -	ds2782_power_supply_init(&info->battery);
> +	info->id = num;
> +	info->ops  = &ds278x_ops[id->driver_data];
> +	info->rsns = *((int *)info->client->dev.platform_data);

Please introduce 'struct ds278x_platform_data {int rsns;};'
for this. Place it into include/linux/ds2782_battery.h.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
