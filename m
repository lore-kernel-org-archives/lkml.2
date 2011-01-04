Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab1ADVRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 16:17:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41107 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab1ADVRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 16:17:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=W9EIZE66Ix71TX18YwiZZrvbQAci33Zg+GclXawzkGND5zKrcx8guCUECNbnhFyO1O
         7R130PEfhshW+3gOlKSPhssSAawZIRbBw9B7QMFEw4rdacfqPR7icszTEb+jf5JeAIK1
         cMLmXfaySCPQK+3kUrPZqbKNxtG6JjEOqAEsA=
Subject: Re: [PATCH 2/2] lib: cpu_rmap: CPU affinity reverse-mapping
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
        Tom Herbert <therbert@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-net-drivers@solarflare.com
In-Reply-To: <1294169967.3636.34.camel@bwh-desktop>
References: <1294169842.3636.31.camel@bwh-desktop>
	 <1294169967.3636.34.camel@bwh-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 22:17:03 +0100
Message-ID: <1294175823.3420.7.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 04 janvier 2011 à 19:39 +0000, Ben Hutchings a écrit :
> When initiating I/O on a multiqueue and multi-IRQ device, we may want
> to select a queue for which the response will be handled on the same
> or a nearby CPU.  This requires a reverse-map of IRQ affinity.  Add
> library functions to support a generic reverse-mapping from CPUs to
> objects with affinity and the specific case where the objects are
> IRQs.
> 
> Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
> ---
>  include/linux/cpu_rmap.h |   73 +++++++++++++
>  lib/Kconfig              |    4 +
>  lib/Makefile             |    2 +
>  lib/cpu_rmap.c           |  262 ++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 341 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/cpu_rmap.h
>  create mode 100644 lib/cpu_rmap.c
> 
> diff --git a/include/linux/cpu_rmap.h b/include/linux/cpu_rmap.h
> new file mode 100644
> index 0000000..6e2f5ff
> --- /dev/null
> +++ b/include/linux/cpu_rmap.h
> @@ -0,0 +1,73 @@
> +/*
> + * cpu_rmap.c: CPU affinity reverse-map support
> + * Copyright 2010 Solarflare Communications Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation, incorporated herein by reference.
> + */
> +
> +#include <linux/cpumask.h>
> +#include <linux/gfp.h>
> +#include <linux/slab.h>
> +
> +/**
> + * struct cpu_rmap - CPU affinity reverse-map
> + * @near: For each CPU, the index and distance to the nearest object,
> + *      based on affinity masks
> + * @size: Number of objects to be reverse-mapped
> + * @used: Number of objects added
> + * @obj: Array of object pointers
> + */
> +struct cpu_rmap {
> +	struct {
> +		u16     index;
> +		u16     dist;
> +	} near[NR_CPUS];

This [NR_CPUS] is highly suspect.

Are you sure you cant use a per_cpu allocation here ?

> +	u16		size, used;
> +	void		*obj[0];
> +};
> +#define CPU_RMAP_DIST_INF 0xffff
> +


> +
> +/**
> + * alloc_cpu_rmap - allocate CPU affinity reverse-map
> + * @size: Number of objects to be mapped
> + * @flags: Allocation flags e.g. %GFP_KERNEL
> + */

I really doubt you need other than GFP_KERNEL. (Especially if you switch
to per_cpu alloc ;) )

> +struct cpu_rmap *alloc_cpu_rmap(unsigned int size, gfp_t flags)
> +{
> +	struct cpu_rmap *rmap;
> +	unsigned int cpu;
> +
> +	/* This is a silly number of objects, and we use u16 indices. */
> +	if (size > 0xffff)
> +		return NULL;
> +
> +	rmap = kzalloc(sizeof(*rmap) + size * sizeof(rmap->obj[0]), flags);
> +	if (!rmap)
> +		return NULL;


