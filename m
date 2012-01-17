Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab2AQQz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:55:28 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:49647
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434Ab2AQQz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:55:27 -0500
X-IronPort-AV: E=Sophos;i="4.71,524,1320620400"; 
   d="scan'208";a="127786296"
Date: Tue, 17 Jan 2012 17:55:23 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Vinod Koul <vinod.koul@intel.com>
cc: Dan Williams <dan.j.williams@intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/15] drivers/dma/pl330.c: add missing iounmap
In-Reply-To: <1326819104.1540.166.camel@vkoul-udesk3>
Message-ID: <alpine.DEB.2.02.1201171754480.1897@localhost6.localdomain6>
References: <1326362117-29371-4-git-send-email-Julia.Lawall@lip6.fr> <1326819104.1540.166.camel@vkoul-udesk3>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jan 2012, Vinod Koul wrote:

> On Thu, 2012-01-12 at 10:55 +0100, Julia Lawall wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Add missing iounmap in error handling code, in a case where the function
>> already preforms iounmap on some other execution path.
>>
>> This patch additionally adds calls to clk_disable and clk_put.
>>
>> A simplified version of the semantic match that finds this problem is as
>> follows: (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> expression e;
>> statement S,S1;
>> int ret;
>> @@
>> e = \(ioremap\|ioremap_nocache\)(...)
>> ... when != iounmap(e)
>> if (<+...e...+>) S
>> ... when any
>>     when != iounmap(e)
>> *if (...)
>>    { ... when != iounmap(e)
>>      return ...; }
>> ... when any
>> iounmap(e);
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> Acked by Vinod Koul <vinod.koul@linux.intel.com>
>
> Which tree is this intended for?

It was generated from linux-next, although I'm not sure if that is the 
intended sense of the question.

julia

>>
>> ---
>> Perhaps clk_put is not needed?  It is not present in the remove function.
>>
>>  drivers/dma/pl330.c |   17 +++++++++++------
>>  1 file changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
>> index 2b3aab3..2f83094 100644
>> --- a/drivers/dma/pl330.c
>> +++ b/drivers/dma/pl330.c
>> @@ -2690,7 +2690,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>>  	if (IS_ERR(pdmac->clk)) {
>>  		dev_err(&adev->dev, "Cannot get operation clock.\n");
>>  		ret = -EINVAL;
>> -		goto probe_err1;
>> +		goto probe_err2;
>>  	}
>>
>>  	amba_set_drvdata(adev, pdmac);
>> @@ -2704,11 +2704,11 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>>  	ret = request_irq(irq, pl330_irq_handler, 0,
>>  			dev_name(&adev->dev), pi);
>>  	if (ret)
>> -		goto probe_err2;
>> +		goto probe_err3;
>>
>>  	ret = pl330_add(pi);
>>  	if (ret)
>> -		goto probe_err3;
>> +		goto probe_err4;
>>
>>  	INIT_LIST_HEAD(&pdmac->desc_pool);
>>  	spin_lock_init(&pdmac->pool_lock);
>> @@ -2765,7 +2765,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>>  	ret = dma_async_device_register(pd);
>>  	if (ret) {
>>  		dev_err(&adev->dev, "unable to register DMAC\n");
>> -		goto probe_err4;
>> +		goto probe_err5;
>>  	}
>>
>>  	dev_info(&adev->dev,
>> @@ -2778,10 +2778,15 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>>
>>  	return 0;
>>
>> -probe_err4:
>> +probe_err5:
>>  	pl330_del(pi);
>> -probe_err3:
>> +probe_err4:
>>  	free_irq(irq, pi);
>> +probe_err3:
>> +#ifndef CONFIG_PM_RUNTIME
>> +	clk_disable(pdmac->clk);
>> +#endif
>> +	clk_put(pdmac->clk);
>>  probe_err2:
>>  	iounmap(pi->base);
>>  probe_err1:
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
> -- 
> ~Vinod
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
