Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1DOAlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 20:41:35 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:59830 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab1DOAlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 20:41:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=UDLBIOc2XqjF7DkDvhJEc2fj9dX9KeuzSPH1GLYxLX42vvo3/CDAQ0ZTQq+6LXghxy
         x3deQKWxeUxEC+996XmSps/dGvNJw+fabhtZw9nk/8Wfnexf2tjufFvwwG1XG2igg+bo
         hw7CHFWD20iyz3eLpcKwIBqd8V+RGGAsPpRyA=
MIME-Version: 1.0
Reply-To: wanlong.gao@gmail.com
In-Reply-To: <1302706264-25815-11-git-send-email-haojian.zhuang@marvell.com>
References: <1302706264-25815-1-git-send-email-haojian.zhuang@marvell.com>
	<1302706264-25815-2-git-send-email-haojian.zhuang@marvell.com>
	<1302706264-25815-3-git-send-email-haojian.zhuang@marvell.com>
	<1302706264-25815-4-git-send-email-haojian.zhuang@marvell.com>
	<1302706264-25815-5-git-send-email-haojian.zhuang@marvell.com>
	<1302706264-25815-6-git-send-email-haojian.zhuang@marvell.com>
	<1302706264-25815-7-git-send-email-haojian.zhuang@marvell.com>
	<1302706264-25815-8-git-send-email-haojian.zhuang@marvell.com>
	<1302706264-25815-9-git-send-email-haojian.zhuang@marvell.com>
	<1302706264-25815-10-git-send-email-haojian.zhuang@marvell.com>
	<1302706264-25815-11-git-send-email-haojian.zhuang@marvell.com>
Date: Fri, 15 Apr 2011 08:41:31 +0800
X-Google-Sender-Auth: xM3-pTQpcM9VpZ5IZpom3lmdq9g
Message-ID: <BANLkTimnW2qihVvux--pG7q+FYXKYuzVCw@mail.gmail.com>
Subject: Re: [PATCH 10/13] rtc: avoid to use hardcoding irq number in max8925
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/11, Haojian Zhuang <haojian.zhuang@marvell.com> wrote:
> Avoid to use hardcoding irq number in max8925 rtc driver. Use irq number
> from resources instead.
>
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Acked-by:Wanlong Gao<wanlong.gao@gmail.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> ---
>  drivers/rtc/rtc-max8925.c |   22 +++++++++++++---------
>  1 files changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/rtc/rtc-max8925.c b/drivers/rtc/rtc-max8925.c
> index 174036d..c460152 100644
> --- a/drivers/rtc/rtc-max8925.c
> +++ b/drivers/rtc/rtc-max8925.c
> @@ -69,6 +69,7 @@ struct max8925_rtc_info {
>  	struct max8925_chip	*chip;
>  	struct i2c_client	*rtc;
>  	struct device		*dev;
> +	int			irq;
>  };
>
>  static irqreturn_t rtc_update_handler(int irq, void *data)
> @@ -239,7 +240,7 @@ static int __devinit max8925_rtc_probe(struct
> platform_device *pdev)
>  {
>  	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
>  	struct max8925_rtc_info *info;
> -	int irq, ret;
> +	int ret = -EINVAL;
>
>  	info = kzalloc(sizeof(struct max8925_rtc_info), GFP_KERNEL);
>  	if (!info)
> @@ -247,16 +248,22 @@ static int __devinit max8925_rtc_probe(struct
> platform_device *pdev)
>  	info->chip = chip;
>  	info->rtc = chip->rtc;
>  	info->dev = &pdev->dev;
> -	irq = chip->irq_base + MAX8925_IRQ_RTC_ALARM0;
> +	info->irq = platform_get_irq(pdev, 0);
> +	if (info->irq < 0) {
> +		dev_err(chip->dev, "Failed to get IRQ resource\n");
> +		goto out_irq;
> +	}
>
> -	ret = request_threaded_irq(irq, NULL, rtc_update_handler,
> +	ret = request_threaded_irq(info->irq, NULL, rtc_update_handler,
>  				   IRQF_ONESHOT, "rtc-alarm0", info);
>  	if (ret < 0) {
>  		dev_err(chip->dev, "Failed to request IRQ: #%d: %d\n",
> -			irq, ret);
> +			info->irq, ret);
>  		goto out_irq;
>  	}
>
> +	dev_set_drvdata(&pdev->dev, info);
> +	platform_set_drvdata(pdev, info);
>  	info->rtc_dev = rtc_device_register("max8925-rtc", &pdev->dev,
>  					&max8925_rtc_ops, THIS_MODULE);
>  	ret = PTR_ERR(info->rtc_dev);
> @@ -265,12 +272,9 @@ static int __devinit max8925_rtc_probe(struct
> platform_device *pdev)
>  		goto out_rtc;
>  	}
>
> -	dev_set_drvdata(&pdev->dev, info);
> -	platform_set_drvdata(pdev, info);
> -
>  	return 0;
>  out_rtc:
> -	free_irq(chip->irq_base + MAX8925_IRQ_RTC_ALARM0, info);
> +	free_irq(info->irq, info);
>  out_irq:
>  	kfree(info);
>  	return ret;
> @@ -281,7 +285,7 @@ static int __devexit max8925_rtc_remove(struct
> platform_device *pdev)
>  	struct max8925_rtc_info *info = platform_get_drvdata(pdev);
>
>  	if (info) {
> -		free_irq(info->chip->irq_base + MAX8925_IRQ_RTC_ALARM0, info);
> +		free_irq(info->irq, info);
>  		rtc_device_unregister(info->rtc_dev);
>  		kfree(info);
>  	}
Added the irq to the info , Hmm.........,seems like all good to me .
Thanks
Best regards
> --
> 1.5.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
