Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1BSTIJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 14:08:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:50721 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab1BSTIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 14:08:06 -0500
Message-ID: <4D6014F9.8040605@kernel.org>
Date: Sat, 19 Feb 2011 11:07:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Make nr_irqs runtime expandable
References: <tip-e7bcecb7b1d29b9ad5af939149a945658620ca8f@git.kernel.org>
In-Reply-To: <tip-e7bcecb7b1d29b9ad5af939149a945658620ca8f@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D601505.00DA,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2011 04:15 AM, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  e7bcecb7b1d29b9ad5af939149a945658620ca8f
> Gitweb:     http://git.kernel.org/tip/e7bcecb7b1d29b9ad5af939149a945658620ca8f
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Wed, 16 Feb 2011 17:12:57 +0100
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Sat, 19 Feb 2011 12:58:06 +0100
> 
> genirq: Make nr_irqs runtime expandable
> 
> We face more and more the requirement to expand nr_irqs at
> runtime. The reason are irq expanders which can not be detected in the
> early boot stage. So we speculate nr_irqs to have enough room. Further
> Xen needs extra irq numbers and we really want to avoid adding more
> "detection" code into the early boot. There is no real good reason why
> we need to limit nr_irqs at early boot.
> 
> Allow the allocation code to expand nr_irqs. We have already 8k extra
> number space in the allocation bitmap, so lets use it.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/irq/irqdesc.c |   22 +++++++++++++++++++---
>  1 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
> index a250d3a..6f6644f 100644
> --- a/kernel/irq/irqdesc.c
> +++ b/kernel/irq/irqdesc.c
> @@ -206,6 +206,14 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
>  	return NULL;
>  }
>  
> +static int irq_expand_nr_irqs(unsigned int cnt)
> +{
> +	if (nr_irqs + cnt > IRQ_BITMAP_BITS)
> +		return -ENOMEM;
> +	nr_irqs += cnt;
> +	return 0;
> +}
> +
>  int __init early_irq_init(void)
>  {
>  	int i, initcnt, node = first_online_node;
> @@ -287,6 +295,12 @@ static inline int alloc_descs(unsigned int start, unsigned int cnt, int node)
>  {
>  	return start;
>  }
> +
> +static int irq_expand_nr_irqs(unsigned int cnt)
> +{
> +	return -ENOMEM;
> +}
> +
>  #endif /* !CONFIG_SPARSE_IRQ */
>  
>  /* Dynamic interrupt handling */
> @@ -335,9 +349,11 @@ irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
>  	if (irq >=0 && start != irq)
>  		goto err;
>  
> -	ret = -ENOMEM;
> -	if (start >= nr_irqs)
> -		goto err;
> +	if (start >= nr_irqs) {
> +		ret = irq_expand_nr_irqs(cnt);
> +		if (ret)
> +			goto err;
> +	}

may need following patch.

[PATCH] genirq: use IRQ_BITMAP_BITS as search size

instead of nr_irqs.

Otherwise bitmap_find_next_area could exit with larger start and in extreme
case we could fail to get wrong irqs return.

For example:
IRQ_BITMAP_BITS=10240
nr_irqs=8192
cnt=2048

and bit 0 to bit 8190 are set already.

before patch start from bit_find_next_area() will be 8191+2048.
later irq_expand_nr_irqs will set nr_irqs 10240.
finally irq_alloc_descs will return [8191+2048, 8191+2048+2047] happily..

with this patch, will get correct [8191, 8191+2047]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/irq/irqdesc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6.orig/kernel/irq/irqdesc.c
+++ linux-2.6/kernel/irq/irqdesc.c
@@ -346,12 +346,13 @@ irq_alloc_descs(int irq, unsigned int fr
 
 	mutex_lock(&sparse_irq_lock);
 
-	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs, from, cnt, 0);
+	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
+						 from, cnt, 0);
 	ret = -EEXIST;
 	if (irq >=0 && start != irq)
 		goto err;
 
-	if (start >= nr_irqs) {
+	if (start + cnt > nr_irqs) {
 		ret = irq_expand_nr_irqs(cnt);
 		if (ret)
 			goto err;
