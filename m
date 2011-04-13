Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab1DMPEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:04:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42735 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab1DMPEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:04:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N5ZIS8xdI3+2puLNoIr57a7xJZbt4ECYwCPP6P4Vhh407Aeossev8yUVUjR2XwngQV
         ShGOGbs/mV3bDys0KVHJqmQ7OVLFilV6IUtfEIm3+y1r3cGL+LPz/a706tw+w8a1hFuy
         r2R5//Ol05oMqmhzxGAmjQej+788PVOl5tsBw=
Date: Wed, 13 Apr 2011 19:03:24 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 11/13] power_supply: max8925: use platform_data from
 cell
Message-ID: <20110413150324.GA16679@oksana.dev.rtsoft.ru>
References: <1302706264-25815-3-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-4-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-5-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-6-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-7-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-8-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-9-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-10-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-11-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-12-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1302706264-25815-12-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 10:51:02PM +0800, Haojian Zhuang wrote:
> Avoid to get platform_data from parent device. Get it from mfd cell
> device instead.
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> ---

I don't see the whole series, but I hope the patch doesn't break any
existing in-tree users of that driver?

>  drivers/power/max8925_power.c |   16 +++++-----------
>  1 files changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
> index 8e5aec2..359c53c 100644
> --- a/drivers/power/max8925_power.c
> +++ b/drivers/power/max8925_power.c
> @@ -425,21 +425,16 @@ static __devexit int max8925_deinit_charger(struct max8925_power_info *info)
>  static __devinit int max8925_power_probe(struct platform_device *pdev)
>  {
>  	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
> -	struct max8925_platform_data *max8925_pdata;
>  	struct max8925_power_pdata *pdata = NULL;
>  	struct max8925_power_info *info;
> -	int ret;
> -
> -	if (pdev->dev.parent->platform_data) {
> -		max8925_pdata = pdev->dev.parent->platform_data;
> -		pdata = max8925_pdata->power;
> -	}
> +	int ret = -EINVAL;

I guess you don't need the initializer.

>  
> -	if (!pdata) {
> +	pdata = pdev->dev.platform_data;
> +	if (pdata == NULL) {

I'd prefer to keep '!pdata'.

>  		dev_err(&pdev->dev, "platform data isn't assigned to "
>  			"power supply\n");
>  		return -EINVAL;
> -	}
> +	};

No need for the semicolon.

>  
>  	info = kzalloc(sizeof(struct max8925_power_info), GFP_KERNEL);
>  	if (!info)
> @@ -447,6 +442,7 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
>  	info->chip = chip;
>  	info->gpm = chip->i2c;
>  	info->adc = chip->adc;
> +	dev_set_drvdata(&pdev->dev, info);

As this is a platform driver, you'd better do platform_set_drvdata(pdev, info),
not dev_set_drvdata(). In the end, it's the same thing.

>  
>  	info->ac.name = "max8925-ac";
>  	info->ac.type = POWER_SUPPLY_TYPE_MAINS;
> @@ -482,8 +478,6 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
>  	info->topoff_threshold = pdata->topoff_threshold;
>  	info->fast_charge = pdata->fast_charge;
>  	info->set_charger = pdata->set_charger;
> -	dev_set_drvdata(&pdev->dev, info);
> -	platform_set_drvdata(pdev, info);
>  
>  	max8925_init_charger(chip, info);
>  	return 0;

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
