Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab3AFVUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 16:20:23 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:33427 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3AFVUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 16:20:21 -0500
Date: Sun, 6 Jan 2013 13:16:50 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/power/88pm860x_battery.c: eliminate possible
 references to released resources
Message-ID: <20130106211649.GA26928@lizard.sbx05280.losalca.wayport.net>
References: <1354986995-2324-1-git-send-email-Julia.Lawall@lip6.fr>
 <20130106050953.GH6919@lizard.sbx05280.losalca.wayport.net>
 <alpine.DEB.2.02.1301060941400.2070@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1301060941400.2070@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 09:43:10AM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> devm_kzalloc should not be followed by kfree, as this results in a double
> free.  The problem was found using the following semantic match
> (http://coccinelle.lip6.fr/):
> 
> // <smpl>
> @@
> expression x,e;
> @@
> x = devm_kzalloc(...)
> ... when != x = e
> ?-kfree(x,...);
> // </smpl>
> 
> Furthermore, in the remove function, the calls to free_irq are moved up to
> prevent a possible reference in the interrupt handler to resources freed by
> power_supply_unregister.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> V2, moving up the calls to free_irq, instead of removing them and using
> devm_request_threaded_irq.

The patch is whitespace-damaged (for some reason there are two spaces in
the beginning of each non-change line). I repeated changes manually, but
you might want to fix your mail/patch setup anyway. :)

Thanks.

>  drivers/power/88pm860x_battery.c |   13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/power/88pm860x_battery.c b/drivers/power/88pm860x_battery.c
> index 8bc80b0..d338c1c 100644
> --- a/drivers/power/88pm860x_battery.c
> +++ b/drivers/power/88pm860x_battery.c
> @@ -915,15 +915,13 @@ static int pm860x_battery_probe(struct platform_device *pdev)
>  	info->irq_cc = platform_get_irq(pdev, 0);
>  	if (info->irq_cc <= 0) {
>  		dev_err(&pdev->dev, "No IRQ resource!\n");
> -		ret = -EINVAL;
> -		goto out;
> +		return -EINVAL;
>  	}
> 
>  	info->irq_batt = platform_get_irq(pdev, 1);
>  	if (info->irq_batt <= 0) {
>  		dev_err(&pdev->dev, "No IRQ resource!\n");
> -		ret = -EINVAL;
> -		goto out;
> +		return -EINVAL;
>  	}
> 
>  	info->chip = chip;
> @@ -957,7 +955,7 @@ static int pm860x_battery_probe(struct platform_device *pdev)
> 
>  	ret = power_supply_register(&pdev->dev, &info->battery);
>  	if (ret)
> -		goto out;
> +		return ret;
>  	info->battery.dev->parent = &pdev->dev;
> 
>  	ret = request_threaded_irq(info->irq_cc, NULL,
> @@ -984,8 +982,6 @@ out_coulomb:
>  	free_irq(info->irq_cc, info);
>  out_reg:
>  	power_supply_unregister(&info->battery);
> -out:
> -	kfree(info);
>  	return ret;
>  }
> 
> @@ -993,10 +989,9 @@ static int pm860x_battery_remove(struct platform_device *pdev)
>  {
>  	struct pm860x_battery_info *info = platform_get_drvdata(pdev);
> 
> -	power_supply_unregister(&info->battery);
>  	free_irq(info->irq_batt, info);
>  	free_irq(info->irq_cc, info);
> -	kfree(info);
> +	power_supply_unregister(&info->battery);
>  	platform_set_drvdata(pdev, NULL);
>  	return 0;
>  }
> 
