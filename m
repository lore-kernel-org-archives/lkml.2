Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab2CGDl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 22:41:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45039 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab2CGDl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 22:41:58 -0500
Date: Tue, 6 Mar 2012 19:41:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rafael Aquini <aquini@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH -v2] mm: SLAB Out-of-memory diagnostics
In-Reply-To: <20120305181041.GA9829@x61.redhat.com>
Message-ID: <alpine.DEB.2.00.1203061941210.24600@chino.kir.corp.google.com>
References: <20120305181041.GA9829@x61.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2012, Rafael Aquini wrote:

> diff --git a/mm/slab.c b/mm/slab.c
> index f0bd785..4aeb5e7 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -1731,6 +1731,52 @@ static int __init cpucache_init(void)
>  }
>  __initcall(cpucache_init);
>  
> +static noinline void
> +slab_out_of_memory(struct kmem_cache *cachep, gfp_t gfpflags, int nodeid)
> +{
> +	struct kmem_list3 *l3;
> +	struct slab *slabp;
> +	unsigned long flags;
> +	int node;
> +
> +	printk(KERN_WARNING
> +		"SLAB: Unable to allocate memory on node %d (gfp=0x%x)\n",
> +		nodeid, gfpflags);
> +	printk(KERN_WARNING "   cache: %s, object size: %d, order: %d\n",
> +		cachep->name, cachep->buffer_size, cachep->gfporder);
> +
> +	for_each_online_node(node) {
> +		unsigned long active_objs = 0, num_objs = 0, free_objects = 0;
> +		unsigned long active_slabs = 0, num_slabs = 0;
> +
> +		l3 = cachep->nodelists[node];
> +		if (!l3)
> +			continue;
> +
> +		spin_lock_irqsave(&l3->list_lock, flags);

Could be spin_lock_irq(&l3->list_lock);
