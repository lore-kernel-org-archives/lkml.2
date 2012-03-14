Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab2CNJXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 05:23:53 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:11985 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065Ab2CNJXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 05:23:50 -0400
X-IronPort-AV: E=Sophos;i="4.73,583,1325458800"; 
   d="scan'208";a="149275019"
Date: Wed, 14 Mar 2012 10:23:47 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
cc: Dan Carpenter <dan.carpenter@oracle.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] arch/unicore32/kernel/dma.c: ensure arguments to
 request_irq and free_irq are compatible
In-Reply-To: <1331714575.2389.47.camel@epip-laptop>
Message-ID: <alpine.DEB.2.02.1203140957020.2146@localhost6.localdomain6>
References: <1331494587-12196-1-git-send-email-Julia.Lawall@lip6.fr>  <1331494587-12196-8-git-send-email-Julia.Lawall@lip6.fr>  <1331513926.2048.58.camel@epip-laptop>  <alpine.DEB.2.02.1203120625570.2066@localhost6.localdomain6>  <1331622633.2048.87.camel@epip-laptop>
  <alpine.DEB.2.02.1203130921250.1974@localhost6.localdomain6>  <1331712444.2389.36.camel@epip-laptop> <20120314081910.GC3163@mwanda> <1331714575.2389.47.camel@epip-laptop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Mar 2012, Guan Xuetao wrote:

> On Wed, 2012-03-14 at 11:19 +0300, Dan Carpenter wrote:
>> On Wed, Mar 14, 2012 at 04:07:24PM +0800, Guan Xuetao wrote:
>>> puv3_init_dma() is called ONCE when initializing.
>>> In logical, if request_irq(IRQ_DMAERR, *) failed, free_irq(IRQ_DMA, *)
>>> is unnecessary, and dma device/driver can keep on working.
>>> The patch could be:
>>>   	ret = request_irq(IRQ_DMAERR, dma_err_handler, 0, "DMAERR", NULL);
>>>   	if (ret) {
>>>   		printk(KERN_CRIT "Can't register IRQ for DMAERR\n");
>>>  -		free_irq(IRQ_DMA, "DMA");
>>>   		return ret;
>>>   	}
>>
>> It seems like you should remove the error return as well?
>>
>> regards,
>> dan carpenter
>>
> The error return value will only generate an extra warning message, and
> have no side-effect.

The whole thing seems a little strange.  I guess your point is that the 
call site never looks at the return value?  Wouldn't it be better to make 
there be no return value in that case?  If there is a return value, some 
calling context in the future might take that into account and then the 
lack of a free_irq would be a memory leak.  Also if the first request_irq 
can never fail, perhaps that should be made explicit by not testing the 
return value?

julia
