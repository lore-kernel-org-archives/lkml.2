Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2COGKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 02:10:42 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:49273 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753171Ab2COGKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 02:10:39 -0400
X-IronPort-AV: E=Sophos;i="4.73,588,1325458800"; 
   d="scan'208";a="149470320"
Date: Thu, 15 Mar 2012 07:10:36 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] arch/unicore32/kernel/dma.c: ensure arguments to
 request_irq and free_irq are compatible
In-Reply-To: <1331773284.2389.61.camel@epip-laptop>
Message-ID: <alpine.DEB.2.02.1203150710050.1981@localhost6.localdomain6>
References: <1331494587-12196-1-git-send-email-Julia.Lawall@lip6.fr>  <1331494587-12196-8-git-send-email-Julia.Lawall@lip6.fr>  <1331513926.2048.58.camel@epip-laptop>  <alpine.DEB.2.02.1203120625570.2066@localhost6.localdomain6>  <1331622633.2048.87.camel@epip-laptop>
  <alpine.DEB.2.02.1203130921250.1974@localhost6.localdomain6>  <1331712444.2389.36.camel@epip-laptop> <20120314081910.GC3163@mwanda>  <1331714575.2389.47.camel@epip-laptop>  <alpine.DEB.2.02.1203140957020.2146@localhost6.localdomain6>
 <1331773284.2389.61.camel@epip-laptop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Mar 2012, Guan Xuetao wrote:

> On Wed, 2012-03-14 at 10:23 +0100, Julia Lawall wrote:
>>
>> On Wed, 14 Mar 2012, Guan Xuetao wrote:
>>
>>> On Wed, 2012-03-14 at 11:19 +0300, Dan Carpenter wrote:
>>>> On Wed, Mar 14, 2012 at 04:07:24PM +0800, Guan Xuetao wrote:
>>>>> puv3_init_dma() is called ONCE when initializing.
>>>>> In logical, if request_irq(IRQ_DMAERR, *) failed, free_irq(IRQ_DMA, *)
>>>>> is unnecessary, and dma device/driver can keep on working.
>>>>> The patch could be:
>>>>>   	ret = request_irq(IRQ_DMAERR, dma_err_handler, 0, "DMAERR", NULL);
>>>>>   	if (ret) {
>>>>>   		printk(KERN_CRIT "Can't register IRQ for DMAERR\n");
>>>>>  -		free_irq(IRQ_DMA, "DMA");
>>>>>   		return ret;
>>>>>   	}
>>>>
>>>> It seems like you should remove the error return as well?
>>>>
>>>> regards,
>>>> dan carpenter
>>>>
>>> The error return value will only generate an extra warning message, and
>>> have no side-effect.
>>
>> The whole thing seems a little strange.  I guess your point is that the
>> call site never looks at the return value?  Wouldn't it be better to make
>> there be no return value in that case?  If there is a return value, some
>> calling context in the future might take that into account and then the
>> lack of a free_irq would be a memory leak.  Also if the first request_irq
>> can never fail, perhaps that should be made explicit by not testing the
>> return value?
>>
>> julia
> This function is an init_call, not a probe function, and it is only
> called ONCE.
> The dma device here has two interrupts, one IRQ_DMA, another IRQ_DMAERR.
> And the device could work without IRQ_DMAERR.
> The return value should indicate whether there is something wrong during
> initialization, so the function needs return errno when any request_irq
> is failed.
> For the first request_irq, some code has prepared its resources before
> this call, so I suppose it successful. However, the return value must be
> tested.

OK, thank you for the explanation. I will change the patch.

julia
