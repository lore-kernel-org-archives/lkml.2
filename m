Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab2CJSco (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 13:32:44 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:15992 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab2CJScW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 13:32:22 -0500
Message-ID: <4F5B9E32.9080809@bfs.de>
Date: Sat, 10 Mar 2012 19:32:18 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Jeff Garzik <jgarzik@pobox.com>, kernel-janitors@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] drivers/ata/pata_mpc52xx.c: add missing kfree
References: <1331402199-8000-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1331402199-8000-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 10.03.2012 18:56, schrieb Julia Lawall:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> There is no need to call the devm cleanup functions on failure of a probe
> or remove function.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/ata/pata_mpc52xx.c |   11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
> index 00748ae..1f02008 100644
> --- a/drivers/ata/pata_mpc52xx.c
> +++ b/drivers/ata/pata_mpc52xx.c
> @@ -806,17 +806,12 @@ mpc52xx_ata_probe(struct platform_device *op)
>  	return 0;
>  
>   err:
> -	devm_release_mem_region(&op->dev, res_mem.start, sizeof(*ata_regs));
>  	if (ata_irq)
>  		irq_dispose_mapping(ata_irq);
>  	if (task_irq)
>  		irq_dispose_mapping(task_irq);

hi julia,
i did a quick look at lxr and it showed that irq_dispose_mapping()
is only used with powerpc, and here is it checking for
	if (virq == NO_IRQ)
            return;

I do not know how current the lxt on free-electrons.com is but perhaps
it is possible to dump the if (ata_irq) stuff.

can you double check it ?

re,
 wh


>  	if (dmatsk)
>  		bcom_ata_release(dmatsk);
> -	if (ata_regs)
> -		devm_iounmap(&op->dev, ata_regs);
> -	if (priv)
> -		devm_kfree(&op->dev, priv);
>  	return rv;
>  }
>  
> @@ -835,12 +830,6 @@ mpc52xx_ata_remove(struct platform_device *op)
>  	bcom_ata_release(priv->dmatsk);
>  	irq_dispose_mapping(priv->ata_irq);
>  
> -	/* Clear up IO allocations */
> -	devm_iounmap(&op->dev, priv->ata_regs);
> -	devm_release_mem_region(&op->dev, priv->ata_regs_pa,
> -				sizeof(*priv->ata_regs));
> -	devm_kfree(&op->dev, priv);
> -
>  	return 0;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
