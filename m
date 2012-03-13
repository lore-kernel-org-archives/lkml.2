Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab2CMIXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:23:46 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:14960 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265Ab2CMIXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:23:44 -0400
X-IronPort-AV: E=Sophos;i="4.73,575,1325458800"; 
   d="scan'208";a="149009473"
Date: Tue, 13 Mar 2012 09:23:41 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] arch/unicore32/kernel/dma.c: ensure arguments to
 request_irq and free_irq are compatible
In-Reply-To: <1331622633.2048.87.camel@epip-laptop>
Message-ID: <alpine.DEB.2.02.1203130921250.1974@localhost6.localdomain6>
References: <1331494587-12196-1-git-send-email-Julia.Lawall@lip6.fr>  <1331494587-12196-8-git-send-email-Julia.Lawall@lip6.fr>  <1331513926.2048.58.camel@epip-laptop>  <alpine.DEB.2.02.1203120625570.2066@localhost6.localdomain6>
 <1331622633.2048.87.camel@epip-laptop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012, Guan Xuetao wrote:

> On Mon, 2012-03-12 at 06:27 +0100, Julia Lawall wrote:
>> On Mon, 12 Mar 2012, Guan Xuetao wrote:
>>
>>> On Sun, 2012-03-11 at 20:36 +0100, Julia Lawall wrote:
>>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>>>
>>>> Convert calls to free_irq so that the second argument is the same as the
>>>> last argument of the corresponding call to request_irq, rather than the
>>>> second to last.  Without this property, free_irq does nothing.
>>>>
>>>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>>>
>>>> ---
>>>>  arch/unicore32/kernel/dma.c |    2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/unicore32/kernel/dma.c b/arch/unicore32/kernel/dma.c
>>>> index ae441bc..c813fec 100644
>>>> --- a/arch/unicore32/kernel/dma.c
>>>> +++ b/arch/unicore32/kernel/dma.c
>>>> @@ -173,7 +173,7 @@ int __init puv3_init_dma(void)
>>>>  	ret = request_irq(IRQ_DMAERR, dma_err_handler, 0, "DMAERR", NULL);
>>>>  	if (ret) {
>>>>  		printk(KERN_CRIT "Can't register IRQ for DMAERR\n");
>>>> -		free_irq(IRQ_DMA, "DMA");
>>>> +		free_irq(IRQ_DMA, NULL);
>>>>  		return ret;
>>>>  	}
>>>>
>>> Yeah, it's an obvious mistake. Thanks.
>>> Because the dma device is just located inside PKUnity-3 SoC, and
>>> request_irq() should always return 0, I prefer to remove this free_irq()
>>> line.
>>
>> Remove the whole if test I guess.  Is there a nce way to indicate that the
>> return value is not needed (eg for the benefit of future bug finding
>> rules)?
>>
>> julia
> In this case, removing the line containing free_irq() is well enough,
> because IRQ_DMA can work even when IRQ_DMAERR doesn't work. And we need
> printk and error return value to get potential logical bug information.

I'm not completely sure to understand.  The point is that the first 
request_irq can never fail, so we don't need to clean up when the second 
one fails?  Because the lack of cleaning up will not cause the first one 
to fail the next time?  free_irq removes an action from a list and does a 
module_put.  Are these operations both not needed?

thanks,julia
