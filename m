Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab1EYIc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:32:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:42139 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476Ab1EYIc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:32:56 -0400
Date: Wed, 25 May 2011 10:32:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Milton Miller <miltonm@bga.com>
cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC 4/4] irq: allow a per-allocation upper limit when
 allocating irqs
In-Reply-To: <alloc-irq-range-v2@mdm.bga.com>
Message-ID: <alpine.LFD.2.02.1105251022390.3078@ionos>
References: <generic-irq-changes@mdm.bga.com> <alloc-irq-range-v2@mdm.bga.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Milton Miller wrote:
>  
> +int irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)

You might want this to be inline :)

> +{
> +	if (irq < 0)
> +		return irq_alloc_descs_range(from, 0, cnt, node);
> +	/* fail if specified start at 4 and obtain 6 */

  -ENOPARSE

> +	if (irq != from)
> +		return -EEXIST;

  -EINVAL perhaps ?

> +	return irq_alloc_descs_range(from, from + cnt, cnt, node);
> +}
> +
>  static inline int irq_alloc_desc(int node)
>  {
>  	return irq_alloc_descs(-1, 0, 1, node);
> Index: work.git/kernel/irq/irqdesc.c
> ===================================================================
> --- work.git.orig/kernel/irq/irqdesc.c	2011-05-25 01:02:11.454480436 -0500
> +++ work.git/kernel/irq/irqdesc.c	2011-05-25 01:04:03.441480315 -0500
> @@ -343,27 +343,37 @@ void irq_free_descs(unsigned int from, u
>  EXPORT_SYMBOL_GPL(irq_free_descs);
>  
>  /**
> - * irq_alloc_descs - allocate and initialize a range of irq descriptors
> - * @irq:	Allocate for specific irq number if irq >= 0
> + * irq_alloc_descs_range - allocate and initialize a range of irq descriptors
>   * @from:	Start the search from this irq number
> + * @limit:	Unless zero, all irq numbers must be less than this value
>   * @cnt:	Number of consecutive irqs to allocate.
>   * @node:	Preferred node on which the irq descriptor should be allocated
>   *
>   * Returns the first irq number or error code
>   */
> -int irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
> +int irq_alloc_descs_range(unsigned int from, unsigned int limit,
> +		unsigned int cnt, int node)
>  {
> -	int start, ret;
> +	unsigned int start, end;
> +	int ret;
>  
>  	if (!cnt)
>  		return -EINVAL;
> +	if (limit) {

Why 0 ? Just use UINT_MAX (or something like IRQ_ALLOC_ANY) for the
limit when you want an unlimited allocation.

> +		if (cnt > limit)
> +			return -ENOMEM;
> +		if (from > limit - cnt)
> +			return -EINVAL;
> +		end = min_t(unsigned int, limit, IRQ_BITMAP_BITS);
> +	} else {
> +		end = IRQ_BITMAP_BITS;
> +	}
>  
>  	mutex_lock(&sparse_irq_lock);
>  
> -	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
> -					   from, cnt, 0);
> +	start = bitmap_find_next_zero_area(allocated_irqs, end, from, cnt, 0);
>  	ret = -EEXIST;
> -	if (irq >=0 && start != irq)
> +	if (start >= end)
>  		goto err;

Otherwise I like the approach in general.

Thanks,

	tglx
