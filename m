Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab1KWIc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 03:32:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45691 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1KWIc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 03:32:26 -0500
Date: Wed, 23 Nov 2011 10:32:21 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Christoph Lameter <cl@linux.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christian Kujau <lists@nerdbynature.de>, markus@trippelsdorf.de,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH V2] slub: avoid potential NULL dereference or
 corruption
In-Reply-To: <1321974122.2474.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.LFD.2.02.1111231030370.14209@tux.localdomain>
References: <1321973629.2474.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <alpine.DEB.2.00.1111220855460.25785@router.home> <1321974122.2474.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Eric Dumazet wrote:
> show_slab_objects() can trigger NULL dereferences or memory corruption.
>
> Another cpu can change its c->page to NULL or c->node to NUMA_NO_NODE
> while we use them.
>
> Use ACCESS_ONCE(c->page) and ACCESS_ONCE(c->node) to make sure this
> cannot happen.
>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Did someone test this patch? Does it fix any of the reported issues?

> ---
> V2: remove a not needed "if (!c)" test
>
> mm/slub.c |   21 +++++++++++----------
> 1 file changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 7d2a996..9deef7d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4435,30 +4435,31 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
>
> 		for_each_possible_cpu(cpu) {
> 			struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
> +			int node = ACCESS_ONCE(c->node);
> 			struct page *page;
>
> -			if (!c || c->node < 0)
> +			if (node < 0)
> 				continue;
> -
> -			if (c->page) {
> -					if (flags & SO_TOTAL)
> -						x = c->page->objects;
> +			page = ACCESS_ONCE(c->page);
> +			if (page) {
> +				if (flags & SO_TOTAL)
> +					x = page->objects;
> 				else if (flags & SO_OBJECTS)
> -					x = c->page->inuse;
> +					x = page->inuse;
> 				else
> 					x = 1;
>
> 				total += x;
> -				nodes[c->node] += x;
> +				nodes[node] += x;
> 			}
> 			page = c->partial;
>
> 			if (page) {
> 				x = page->pobjects;
> -                                total += x;
> -                                nodes[c->node] += x;
> +				total += x;
> +				nodes[node] += x;
> 			}
> -			per_cpu[c->node]++;
> +			per_cpu[node]++;
> 		}
> 	}
>
>
>
>
