Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1HTKos (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 06:44:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65223 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1HTKor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 06:44:47 -0400
Date: Sat, 20 Aug 2011 13:44:41 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@localhost6.localdomain6
To: Christoph Lameter <cl@linux.com>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        rientjes@google.com
Subject: Re: [slub p4 2/7] slub: Remove useless statements in __slab_alloc
In-Reply-To: <20110809211259.776343341@linux.com>
Message-ID: <alpine.DEB.2.00.1108201340270.3008@localhost6.localdomain6>
References: <20110809211221.831975979@linux.com> <20110809211259.776343341@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011, Christoph Lameter wrote:
> Two statements in __slab_alloc() do not have any effect.
>
> 1. c->page is already set to NULL by deactivate_slab() called right before.
>
> 2. gfpflags are masked in new_slab() before being passed to the page
>   allocator. There is no need to mask gfpflags in __slab_alloc in particular
>   since most frequent processing in __slab_alloc does not require the use of a
>   gfpmask.
>
> Cc: torvalds@linux-foundation.org
> Signed-off-by: Christoph Lameter <cl@linux.com>

Linus wasn't actually on the CC of the email.

> ---
> mm/slub.c |    4 ----
> 1 file changed, 4 deletions(-)
>
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-08-01 11:03:15.000000000 -0500
> +++ linux-2.6/mm/slub.c	2011-08-01 11:04:06.385859038 -0500
> @@ -2064,9 +2064,6 @@ static void *__slab_alloc(struct kmem_ca
> 	c = this_cpu_ptr(s->cpu_slab);
> #endif
>
> -	/* We handle __GFP_ZERO in the caller */
> -	gfpflags &= ~__GFP_ZERO;
> -

This is the part Linus felt strongly about in the past. It's not needed 
now that we mask GFP flags in new_slab() and the code path is pretty hot 
on workloads where SLAB traditionally has had better performance.

> 	page = c->page;
> 	if (!page)
> 		goto new_slab;
> @@ -2163,7 +2160,6 @@ debug:
>
> 	c->freelist = get_freepointer(s, object);
> 	deactivate_slab(s, c);
> -	c->page = NULL;
> 	c->node = NUMA_NO_NODE;
> 	local_irq_restore(flags);
> 	return object;
>
>
