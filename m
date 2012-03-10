Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab2CJVus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 16:50:48 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:14777 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377Ab2CJVuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 16:50:46 -0500
X-IronPort-AV: E=Sophos;i="4.73,563,1325458800"; 
   d="scan'208";a="148635081"
Date: Sat, 10 Mar 2012 22:50:42 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: walter harms <wharms@bfs.de>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Jeff Garzik <jgarzik@pobox.com>,
        kernel-janitors@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] drivers/ata/pata_mpc52xx.c: add missing kfree
In-Reply-To: <4F5B9E32.9080809@bfs.de>
Message-ID: <alpine.DEB.2.02.1203102243070.1971@localhost6.localdomain6>
References: <1331402199-8000-1-git-send-email-Julia.Lawall@lip6.fr> <4F5B9E32.9080809@bfs.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Mar 2012, walter harms wrote:

>
>
> Am 10.03.2012 18:56, schrieb Julia Lawall:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> There is no need to call the devm cleanup functions on failure of a probe
>> or remove function.
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>>  drivers/ata/pata_mpc52xx.c |   11 -----------
>>  1 file changed, 11 deletions(-)
>>
>> diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
>> index 00748ae..1f02008 100644
>> --- a/drivers/ata/pata_mpc52xx.c
>> +++ b/drivers/ata/pata_mpc52xx.c
>> @@ -806,17 +806,12 @@ mpc52xx_ata_probe(struct platform_device *op)
>>  	return 0;
>>
>>   err:
>> -	devm_release_mem_region(&op->dev, res_mem.start, sizeof(*ata_regs));
>>  	if (ata_irq)
>>  		irq_dispose_mapping(ata_irq);
>>  	if (task_irq)
>>  		irq_dispose_mapping(task_irq);
>
> hi julia,
> i did a quick look at lxr and it showed that irq_dispose_mapping()
> is only used with powerpc, and here is it checking for
> 	if (virq == NO_IRQ)
>            return;
>
> I do not know how current the lxt on free-electrons.com is but perhaps
> it is possible to dump the if (ata_irq) stuff.
>
> can you double check it ?

The definition in v3.2.9/kernel/irq/irqdomain.c does nothing but says:

nothing yet; will be filled when support for dynamic allocation of
irq_descs is added to irq_domain

So it would seem better to keep the call.  On the other hand, the error 
handling code of this function seems to be a mess.  When the 
initialization of ata_irq fails, it just returns instead of cleaning up. 
Prior code goes to err.  On ther other hand, now that the devm cleanups 
are gone, it is the goto err, which is unnecessary.  I'll look at the code 
some more.

julia

>
> re,
> wh
>
>
>>  	if (dmatsk)
>>  		bcom_ata_release(dmatsk);
>> -	if (ata_regs)
>> -		devm_iounmap(&op->dev, ata_regs);
>> -	if (priv)
>> -		devm_kfree(&op->dev, priv);
>>  	return rv;
>>  }
>>
>> @@ -835,12 +830,6 @@ mpc52xx_ata_remove(struct platform_device *op)
>>  	bcom_ata_release(priv->dmatsk);
>>  	irq_dispose_mapping(priv->ata_irq);
>>
>> -	/* Clear up IO allocations */
>> -	devm_iounmap(&op->dev, priv->ata_regs);
>> -	devm_release_mem_region(&op->dev, priv->ata_regs_pa,
>> -				sizeof(*priv->ata_regs));
>> -	devm_kfree(&op->dev, priv);
>> -
>>  	return 0;
>>  }
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
