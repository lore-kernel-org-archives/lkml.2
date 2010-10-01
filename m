Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab0JAFb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:31:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53817 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab0JAFb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:31:56 -0400
Message-ID: <4CA57173.5060803@kernel.org>
Date: Thu, 30 Sep 2010 22:28:19 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 14/47] genirq: Implement a sane sparse_irq allocator
References: <20100930221351.682772535@linutronix.de> <20100930221739.858896807@linutronix.de>
In-Reply-To: <20100930221739.858896807@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2010 04:15 PM, Thomas Gleixner wrote:
......
> ---
>  include/linux/irq.h  |   25 +++++
>  kernel/irq/irqdesc.c |  226 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 243 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6-tip/include/linux/irq.h
> ===================================================================
> --- linux-2.6-tip.orig/include/linux/irq.h
> +++ linux-2.6-tip/include/linux/irq.h
> @@ -276,6 +276,31 @@ static inline struct irq_desc *move_irq_
>  
>  extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
>  
> +int irq_alloc_descs(unsigned int irq, unsigned int from, unsigned int cnt, int node);
> +
> +static inline int irq_alloc_desc(int node)
> +{
> +	return irq_alloc_descs(0, 0, 1, node);
> +}
> +
> +static inline int
> +irq_alloc_desc_at(unsigned int at, int node)
> +{
> +	return irq_alloc_descs(at, 0, 1, node);

need to change to 

	return irq_alloc_descs(at, at, 1, node);

> +}
> +
...

> Index: linux-2.6-tip/kernel/irq/irqdesc.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/irq/irqdesc.c
> +++ linux-2.6-tip/kernel/irq/irqdesc.c
...

> +/**
> + * irq_alloc_descs - allocate and initialize a range of irq descriptors
> + * @irq:	Allocate for specific irq number if irq > 0
> + * @from:	Start the search from this irq number
> + * @cnt:	Number of consecutive irqs to allocate.
> + * @node:	Preferred node on which the irq descriptor should be allocated
> + *
> + * Returns the first irq number or error code
> + */
> +int __ref
> +irq_alloc_descs(unsigned int irq, unsigned int from, unsigned int cnt, int node)
> +{
> +	unsigned long flags;
> +	int start, ret;
> +
> +	if (!cnt)
> +		return -EINVAL;
> +
> +	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
> +
or add
	if (irq)
		from = irq;
here.

> +	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs, from, cnt, 0);
> +	ret = -EEXIST;
> +	if (irq && start != irq)
> +		goto err;
> +
> +	ret = -ENOMEM;
> +	if (start >= nr_irqs)
> +		goto err;
> +
> +	bitmap_set(allocated_irqs, start, cnt);
> +	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
> +	return alloc_descs(start, cnt, node);
> +
> +err:
> +	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
> +	return ret;
> +}

Yinghai
