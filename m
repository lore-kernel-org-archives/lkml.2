Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1HTKdJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 06:33:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59999 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1HTKdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 06:33:04 -0400
Date: Sat, 20 Aug 2011 13:32:53 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@localhost6.localdomain6
To: Christoph Lameter <cl@linux.com>
cc: linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [slub p4 1/7] slub: free slabs without holding locks (V2)
In-Reply-To: <20110809211259.123603907@linux.com>
Message-ID: <alpine.DEB.2.00.1108201331400.3008@localhost6.localdomain6>
References: <20110809211221.831975979@linux.com> <20110809211259.123603907@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011, Christoph Lameter wrote:
> There are two situations in which slub holds a lock while releasing
> pages:
>
> 	A. During kmem_cache_shrink()
> 	B. During kmem_cache_close()
>
> For A build a list while holding the lock and then release the pages
> later. In case of B we are the last remaining user of the slab so
> there is no need to take the listlock.
>
> After this patch all calls to the page allocator to free pages are
> done without holding any spinlocks. kmem_cache_destroy() will still
> hold the slub_lock semaphore.
>
> V1->V2. Remove kfree. Avoid locking in free_partial.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
> ---
> mm/slub.c |   26 +++++++++++++-------------
> 1 file changed, 13 insertions(+), 13 deletions(-)
>
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-08-09 13:01:59.071582163 -0500
> +++ linux-2.6/mm/slub.c	2011-08-09 13:05:00.051582012 -0500
> @@ -2970,13 +2970,13 @@ static void list_slab_objects(struct kme
>
> /*
>  * Attempt to free all partial slabs on a node.
> + * This is called from kmem_cache_close(). We must be the last thread
> + * using the cache and therefore we do not need to lock anymore.
>  */
> static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
> {

Is it possible to somehow verify that we're the last thread using the 
cache when SLUB debugging is enabled? It'd be useful for tracking down 
callers that violate this assumption.

 			Pekka
