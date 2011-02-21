Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab1BUNhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 08:37:52 -0500
Received: from www.tglx.de ([62.245.132.106]:34139 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab1BUNhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 08:37:50 -0500
Date: Mon, 21 Feb 2011 14:37:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Make nr_irqs runtime expandable
In-Reply-To: <4D6014F9.8040605@kernel.org>
Message-ID: <alpine.LFD.2.00.1102211435320.2701@localhost6.localdomain6>
References: <tip-e7bcecb7b1d29b9ad5af939149a945658620ca8f@git.kernel.org> <4D6014F9.8040605@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Feb 2011, Yinghai Lu wrote:
> On 02/19/2011 04:15 AM, tip-bot for Thomas Gleixner wrote:
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

What a horrible changelog.
 
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

One off. That needs to be  >= nr_irqs. Good catch otherwise.

Thanks,

	tglx
