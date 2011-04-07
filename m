Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab1DGVTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:19:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524Ab1DGVTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:19:48 -0400
Date: Thu, 7 Apr 2011 14:19:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lru_cache: Use correct type in sizeof for allocation
Message-Id: <20110407141942.9d303e8c.akpm@linux-foundation.org>
In-Reply-To: <1298241914-1400-1-git-send-email-imirkin@alum.mit.edu>
References: <1298241914-1400-1-git-send-email-imirkin@alum.mit.edu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Feb 2011 17:45:14 -0500
Ilia Mirkin <imirkin@alum.mit.edu> wrote:

> This has no actual effect, since sizeof(struct hlist_head) ==
> sizeof(struct hlist_head *), but it's still the wrong type to use.
> 
> The semantic match that finds this problem:
> // <smpl>
> @@
> type T;
> identifier x;
> @@
> T *x;
> ...
> * x = kzalloc(... * sizeof(T*) * ..., ...);
> // </smpl>
> 
> ...
>
> --- a/lib/lru_cache.c
> +++ b/lib/lru_cache.c
> @@ -84,7 +84,7 @@ struct lru_cache *lc_create(const char *name, struct kmem_cache *cache,
>  	if (e_count > LC_MAX_ACTIVE)
>  		return NULL;
>  
> -	slot = kzalloc(e_count * sizeof(struct hlist_head*), GFP_KERNEL);
> +	slot = kzalloc(e_count * sizeof(struct hlist_head), GFP_KERNEL);
>  	if (!slot)
>  		goto out_fail;
>  	element = kzalloc(e_count * sizeof(struct lc_element *), GFP_KERNEL);

This is one of the reasons why I think it's better to use

	foo = kmalloc(sizeof(*foo));

Then, you just *know* it's correct by looking at the code and you don't
need to scroll up and double-check the type of foo.

The code as you have it is still vulnerable to multiplicative overflow.
So, to be really really correct,


--- a/lib/lru_cache.c~lru_cache-use-correct-type-in-sizeof-for-allocation-fix
+++ a/lib/lru_cache.c
@@ -84,7 +84,7 @@ struct lru_cache *lc_create(const char *
 	if (e_count > LC_MAX_ACTIVE)
 		return NULL;
 
-	slot = kzalloc(e_count * sizeof(struct hlist_head), GFP_KERNEL);
+	slot = kcalloc(e_count, sizeof(struct hlist_head), GFP_KERNEL);
 	if (!slot)
 		goto out_fail;
 	element = kzalloc(e_count * sizeof(struct lc_element *), GFP_KERNEL);
_

