Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab1BUP45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:56:57 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:60066 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174Ab1BUP4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:56:55 -0500
Message-ID: <4D628B38.7040105@metafoo.de>
Date: Mon, 21 Feb 2011 16:56:40 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Make nr_irqs runtime expandable
References: <tip-e7bcecb7b1d29b9ad5af939149a945658620ca8f@git.kernel.org> <4D6014F9.8040605@kernel.org>
In-Reply-To: <4D6014F9.8040605@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2011 08:07 PM, Yinghai Lu wrote:
> On 02/19/2011 04:15 AM, tip-bot for Thomas Gleixner wrote:
>> Commit-ID:  e7bcecb7b1d29b9ad5af939149a945658620ca8f
>> Gitweb:     http://git.kernel.org/tip/e7bcecb7b1d29b9ad5af939149a945658620ca8f
>> Author:     Thomas Gleixner <tglx@linutronix.de>
>> AuthorDate: Wed, 16 Feb 2011 17:12:57 +0100
>> Committer:  Thomas Gleixner <tglx@linutronix.de>
>> CommitDate: Sat, 19 Feb 2011 12:58:06 +0100
>>
>> genirq: Make nr_irqs runtime expandable
>>
>> We face more and more the requirement to expand nr_irqs at
>> runtime. The reason are irq expanders which can not be detected in the
>> early boot stage. So we speculate nr_irqs to have enough room. Further
>> Xen needs extra irq numbers and we really want to avoid adding more
>> "detection" code into the early boot. There is no real good reason why
>> we need to limit nr_irqs at early boot.
>>
>> Allow the allocation code to expand nr_irqs. We have already 8k extra
>> number space in the allocation bitmap, so lets use it.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  kernel/irq/irqdesc.c |   22 +++++++++++++++++++---
>>  1 files changed, 19 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
>> index a250d3a..6f6644f 100644
>> --- a/kernel/irq/irqdesc.c
>> +++ b/kernel/irq/irqdesc.c
>> @@ -206,6 +206,14 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
>>  	return NULL;
>>  }
>>  
>> +static int irq_expand_nr_irqs(unsigned int cnt)
>> +{
>> +	if (nr_irqs + cnt > IRQ_BITMAP_BITS)
>> +		return -ENOMEM;
>> +	nr_irqs += cnt;
>> +	return 0;
>> +}
>> +
>>  int __init early_irq_init(void)
>>  {
>>  	int i, initcnt, node = first_online_node;
>> @@ -287,6 +295,12 @@ static inline int alloc_descs(unsigned int start, unsigned int cnt, int node)
>>  {
>>  	return start;
>>  }
>> +
>> +static int irq_expand_nr_irqs(unsigned int cnt)
>> +{
>> +	return -ENOMEM;
>> +}
>> +
>>  #endif /* !CONFIG_SPARSE_IRQ */
>>  
>>  /* Dynamic interrupt handling */
>> @@ -335,9 +349,11 @@ irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
>>  	if (irq >=0 && start != irq)
>>  		goto err;
>>  
>> -	ret = -ENOMEM;
>> -	if (start >= nr_irqs)
>> -		goto err;
>> +	if (start >= nr_irqs) {
>> +		ret = irq_expand_nr_irqs(cnt);
>> +		if (ret)
>> +			goto err;
>> +	}
> 
> may need following patch.
> 
> [PATCH] genirq: use IRQ_BITMAP_BITS as search size
> 
> instead of nr_irqs.
> 
> Otherwise bitmap_find_next_area could exit with larger start and in extreme
> case we could fail to get wrong irqs return.
> 
> For example:
> IRQ_BITMAP_BITS=10240
> nr_irqs=8192
> cnt=2048
> 
> and bit 0 to bit 8190 are set already.
> 
> before patch start from bit_find_next_area() will be 8191+2048.
> later irq_expand_nr_irqs will set nr_irqs 10240.
> finally irq_alloc_descs will return [8191+2048, 8191+2048+2047] happily..
> 
> with this patch, will get correct [8191, 8191+2047]
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  kernel/irq/irqdesc.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/kernel/irq/irqdesc.c
> ===================================================================
> --- linux-2.6.orig/kernel/irq/irqdesc.c
> +++ linux-2.6/kernel/irq/irqdesc.c
> @@ -346,12 +346,13 @@ irq_alloc_descs(int irq, unsigned int fr
>  
>  	mutex_lock(&sparse_irq_lock);
>  
> -	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs, from, cnt, 0);
> +	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
> +						 from, cnt, 0);
>  	ret = -EEXIST;
>  	if (irq >=0 && start != irq)
>  		goto err;
>  
> -	if (start >= nr_irqs) {
> +	if (start + cnt > nr_irqs) {
>  		ret = irq_expand_nr_irqs(cnt);
Just a minor thing, but if there are still unused irqs available at the end of
the current range, you'll end up expanding the range more then you need to.
So either do
	irq_expand_nr_irqs(nr_irqs - start + cnt);
or change irq_expand_nr_irqs to let it take the new total number of irqs.

Btw., with this patch in place does it make sense to initialize nr_irqs to
anything else then initcnt in early_irq_init?


>  		if (ret)
>  			goto err;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

