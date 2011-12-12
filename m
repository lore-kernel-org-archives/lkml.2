Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1LLHSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:18:09 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58868 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448Ab1LLHSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:18:04 -0500
Date: Mon, 12 Dec 2011 09:17:47 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Christoph Lameter <cl@linux.com>
cc: David Rientjes <rientjes@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: slub: Lockout validation scans during freeing of object
In-Reply-To: <alpine.DEB.2.00.1111230922210.16544@router.home>
Message-ID: <alpine.LFD.2.02.1112120917230.2555@tux.localdomain>
References: <alpine.DEB.2.00.1111230922210.16544@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, Christoph Lameter wrote:

> Eric tested this one.
>
>
> Subject: slub: Lockout validation scans during freeing of object
>
> Slab validation can run right now while the slab free paths prepare
> the redzone fields etc around the objects in preparation of the
> actual freeing of the object. This can lead to false positives.
>
> Take the node lock unconditionally during free so that the validation
> can examine objects without them being disturbed by freeing operations.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
> ---
> mm/slub.c |   12 ++++++++++--
> 1 file changed, 10 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-11-22 10:42:19.000000000 -0600
> +++ linux-2.6/mm/slub.c	2011-11-22 10:44:34.000000000 -0600
> @@ -2391,8 +2391,15 @@ static void __slab_free(struct kmem_cach
>
> 	stat(s, FREE_SLOWPATH);
>
> -	if (kmem_cache_debug(s) && !free_debug_processing(s, page, x, addr))
> -		return;
> +	if (kmem_cache_debug(s)) {
> +
> +		/* Lock out any concurrent validate_slab calls */
> +		n = get_node(s, page_to_nid(page));
> +		spin_lock_irqsave(&n->list_lock, flags);
> +
> +		if (!free_debug_processing(s, page, x, addr))
> +			goto out;
> +	}
>
> 	do {
> 		prior = page->freelist;
> @@ -2471,6 +2478,7 @@ static void __slab_free(struct kmem_cach
> 			stat(s, FREE_ADD_PARTIAL);
> 		}
> 	}
> +out:
> 	spin_unlock_irqrestore(&n->list_lock, flags);
> 	return;

Ditto.
