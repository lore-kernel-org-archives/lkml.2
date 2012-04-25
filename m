Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab2DYWqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 18:46:44 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:64865 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355Ab2DYWqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 18:46:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120425.161050.1011838269798884593.davem@davemloft.net>
References: <20120425.161050.1011838269798884593.davem@davemloft.net>
Date: Wed, 25 Apr 2012 15:46:42 -0700
X-Google-Sender-Auth: sJ7lWiRxi4-bkE3S3XazDrwRrRA
Message-ID: <CAE9FiQWYPPXA0YmgBP6SkKiEaLJJnzxMqPn2_VwOKoYSKGwULQ@mail.gmail.com>
Subject: Re: [PATCH] mm: nobootmem: Correct alloc_bootmem semantics.
From: Yinghai Lu <yinghai@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 1:10 PM, David Miller <davem@davemloft.net> wrote:
>
> The comments above __alloc_bootmem_node() claim that the code will
> first try the allocation using 'goal' and if that fails it will
> try again but with the 'goal' requirement dropped.
>
> Unfortunately, this is not what the code does, so fix it to do so.
>
> This is important for nobootmem conversions to architectures such
> as sparc where MAX_DMA_ADDRESS is infinity.
>
> On such architectures all of the allocations done by generic spots,
> such as the sparse-vmemmap implementation, will pass in:
>
>        __pa(MAX_DMA_ADDRESS)
>
> as the goal, and with the limit given as "-1" this will always fail
> unless we add the appropriate fallback logic here.
>
> Signed-off-by: David S. Miller <davem@davemloft.net>
>
> diff --git a/mm/nobootmem.c b/mm/nobootmem.c
> index 24f0fc1..e53bb8a 100644
> --- a/mm/nobootmem.c
> +++ b/mm/nobootmem.c
> @@ -298,13 +298,19 @@ void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
>        if (WARN_ON_ONCE(slab_is_available()))
>                return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
>
> +again:
>        ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
>                                         goal, -1ULL);
>        if (ptr)
>                return ptr;

If you want to be consistent to bootmem version.

again label should be here instead.

>
> -       return __alloc_memory_core_early(MAX_NUMNODES, size, align,
> -                                        goal, -1ULL);
> +       ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
> +                                       goal, -1ULL);
> +       if (!ptr && goal) {
> +               goal = 0;
> +               goto again;
> +       }
> +       return ptr;
>  }

Thanks

Yinghai
