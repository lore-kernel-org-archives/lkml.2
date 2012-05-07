Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab2EGTRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:17:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54444 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab2EGTRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:17:06 -0400
MIME-Version: 1.0
In-Reply-To: <1336390672-14421-8-git-send-email-hannes@cmpxchg.org>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
	<1336390672-14421-8-git-send-email-hannes@cmpxchg.org>
Date: Mon, 7 May 2012 12:17:04 -0700
X-Google-Sender-Auth: zOfEiqMX2M1N018FAHsW9ND_QoM
Message-ID: <CAE9FiQVVvppc0iuxFEoqU+Pxq0A2c=uoByDGvYEccMU2kahJbQ@mail.gmail.com>
Subject: Re: [patch 07/10] mm: nobootmem: panic on node-specific allocation failure
From: Yinghai Lu <yinghai@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 4:37 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> __alloc_bootmem_node and __alloc_bootmem_low_node documentation claims
> the functions panic on allocation failure.  Do it.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/nobootmem.c |   20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/mm/nobootmem.c b/mm/nobootmem.c
> index e53bb8a..b078ff8 100644
> --- a/mm/nobootmem.c
> +++ b/mm/nobootmem.c
> @@ -306,11 +306,17 @@ again:
>
>        ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
>                                        goal, -1ULL);
> -       if (!ptr && goal) {
> +       if (ptr)
> +               return ptr;
> +
> +       if (goal) {
>                goal = 0;
>                goto again;
>        }
> -       return ptr;
> +
> +       printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
> +       panic("Out of memory");
> +       return NULL;
>  }
>
>  void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
> @@ -408,6 +414,12 @@ void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
>        if (ptr)
>                return ptr;
>
> -       return  __alloc_memory_core_early(MAX_NUMNODES, size, align,
> -                               goal, ARCH_LOW_ADDRESS_LIMIT);
> +       ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
> +                                       goal, ARCH_LOW_ADDRESS_LIMIT);
> +       if (ptr)
> +               return ptr;
> +
> +       printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
> +       panic("Out of memory");
> +       return NULL;
>  }

Acked-by: Yinghai Lu <yinghai@kernel.org>
