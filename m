Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab2JDB1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:27:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34661 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab2JDB1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:27:51 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-dd-506ce615783e
Message-id: <506CE614.30606@samsung.com>
Date: Thu, 04 Oct 2012 10:27:48 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] extcon: max77693: Fix max77693_muic_probe error handling
References: <1349231038.6191.1.camel@phoenix>
In-reply-to: <1349231038.6191.1.camel@phoenix>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jAV3RZzkBBo8bDS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGlcadTAUzBSpmt31hb2C8xdPFyMkhIWAicePwLRYIW0ziwr31
	bF2MXBxCAosYJVY2v2OGcLqYJK6c+8bexcjBwSugIXHwBheIySKgKtFy2h2kl01AS2L/ixts
	IGFRgQiJX/0cIGFeAUGJH5PvgY0XEVCSWHX/MpjNLOApcfpWFzOILSzgK7Fv/zU2EFtIQFfi
	weX5YHFOAT2JGSsuMUPUq0tMmrcIypaX2LzmLfMERoFZSFbMQlI2C0nZAkbmVYyiqQXJBcVJ
	6bmGesWJucWleel6yfm5mxjBwfdMagfjygaLQ4wCHIxKPLyG3TkBQqyJZcWVuYcYJTiYlUR4
	jbcChXhTEiurUovy44tKc1KLDzFKc7AoifM2e6QECAmkJ5akZqemFqQWwWSZODilGhhzZwu7
	Ndrd/xdhybPIVq/zaSDD2SLJI69YK4zCj09fV34sSul0kbxMBPNsv1lMAgsiTj5cz213x7/5
	vge/mJX8p32f6iaLBT+J9LFLV2jdz3Lv8c2iqe8cuv0WCd5wa19wbM+bfoc9u59c6d/+o0j2
	ziexnteZPFbPrLdLOAmvuPftdryB2CUlluKMREMt5qLiRABay8W3OgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 11:23 AM, Axel Lin wrote:

> Fix below issues:
> 1. If request_threaded_irq() fails, current code does not free all requested
>    irqs.
> 2. Add missing extcon_dev_unregister() in error path if failed to read revision
>    number.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/extcon/extcon-max77693.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index e0ed622..9928c63 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -696,12 +696,8 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
>  				IRQF_ONESHOT, muic_irq->name, info);
>  		if (ret) {
>  			dev_err(&pdev->dev,
> -				"failed: irq request (IRQ: %d,"
> -				" error :%d)\n",
> +				"failed: irq request (IRQ: %d, error :%d)\n",
>  				muic_irq->irq, ret);
> -
> -			for (i = i - 1; i >= 0; i--)
> -				free_irq(muic_irq->virq, info);
>  			goto err_irq;
>  		}
>  	}
> @@ -726,7 +722,7 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
>  			MAX77693_MUIC_REG_ID, &id);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed to read revision number\n");
> -		goto err_extcon;
> +		goto err_read_reg;
>  	}
>  	dev_info(info->dev, "device ID : 0x%x\n", id);
>  
> @@ -738,9 +734,13 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
>  
>  	return ret;
>  
> +err_read_reg:
> +	extcon_dev_unregister(info->edev);
>  err_extcon:
>  	kfree(info->edev);
>  err_irq:
> +	while (--i >= 0)
> +		free_irq(muic_irqs[i].virq, info);


This include possible error when 'i' variable may be used after
completed request_thread_irq() operation. I think the below patch
is appropriate because free_irq() function return NULL if first parameter
is unrequested irq.

err_irq:
+       for (i = 0; i < ARRAY_SIZE(muic_irqs); i++)
+               free_irq(muic_irqs[i].virq, info);

Thank you,
Chanwoo Choi
