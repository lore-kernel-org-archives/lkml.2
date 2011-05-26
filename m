Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582Ab1EZWQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:16:31 -0400
Received: from smtp-out.google.com ([74.125.121.67]:2020 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758532Ab1EZWQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:16:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type:content-id;
        b=wnFaBa+v4i0X56SC7jXZPD5U/Qkzh31ayn5g95TF7ClNGrHjfobL15kEUtrNIvZot8
         YZOw0spTSFNNnXN7rVNA==
Date: Thu, 26 May 2011 15:16:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv6 12/17] slub: Avoid disabling interrupts in free
 slowpath
In-Reply-To: <20110526181508.302886720@linux.com>
Message-ID: <alpine.DEB.2.00.1105261354130.26952@chino.kir.corp.google.com>
References: <20110526181442.789868308@linux.com> <20110526181508.302886720@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-1776596693-1306443338=:26952"
Content-ID: <alpine.DEB.2.00.1105261516032.10790@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-1776596693-1306443338=:26952
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1105261516033.10790@chino.kir.corp.google.com>

On Thu, 26 May 2011, Christoph Lameter wrote:

> Disabling interrupts can be avoided now. However, list operation still require
> disabling interrupts since allocations can occur from interrupt
> contexts and there is no way to perform atomic list operations.
> 
> The acquition of the list_lock therefore has to disable interrupts as well.
> 
> Dropping interrupt handling significantly simplifies the slowpath.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  mm/slub.c |   16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-05-24 09:40:57.434875035 -0500
> +++ linux-2.6/mm/slub.c	2011-05-24 09:41:00.194875015 -0500
> @@ -2183,11 +2183,10 @@ static void __slab_free(struct kmem_cach
>  	struct kmem_cache_node *n = NULL;
>  	unsigned long flags;
>  
> -	local_irq_save(flags);
>  	stat(s, FREE_SLOWPATH);
>  
>  	if (kmem_cache_debug(s) && !free_debug_processing(s, page, x, addr))
> -		goto out_unlock;
> +		return;
>  
>  	do {
>  		prior = page->freelist;
> @@ -2206,7 +2205,7 @@ static void __slab_free(struct kmem_cach
>  			 * Otherwise the list_lock will synchronize with
>  			 * other processors updating the list of slabs.
>  			 */
> -                        spin_lock(&n->list_lock);
> +                        spin_lock_irqsave(&n->list_lock, flags);
>  		}
>  		inuse = new.inuse;
>  
> @@ -2222,7 +2221,7 @@ static void __slab_free(struct kmem_cach
>  		 */
>                  if (was_frozen)
>                          stat(s, FREE_FROZEN);
> -                goto out_unlock;
> +                return;
>          }
>  
>  	/*
> @@ -2245,11 +2244,7 @@ static void __slab_free(struct kmem_cach
>  			stat(s, FREE_ADD_PARTIAL);
>  		}
>  	}
> -
> -	spin_unlock(&n->list_lock);
> -
> -out_unlock:
> -	local_irq_restore(flags);
> +	spin_unlock_irqrestore(&n->list_lock, flags);

We know that flags will be initialized at this point in the code, but the 
compiler doesn't and it emits this:

	mm/slub.c: In function ‘__slab_free’:
	mm/slub.c:2198: warning: ‘flags’ may be used uninitialized in this function

so it'll need uninitialized_var().

>  	return;
>  
>  slab_empty:
> @@ -2261,8 +2256,7 @@ slab_empty:
>  		stat(s, FREE_REMOVE_PARTIAL);
>  	}
>  
> -	spin_unlock(&n->list_lock);
> -	local_irq_restore(flags);
> +	spin_unlock_irqrestore(&n->list_lock, flags);
>  	stat(s, FREE_SLAB);
>  	discard_slab(s, page);
>  }
> 
> 
--531368966-1776596693-1306443338=:26952--
