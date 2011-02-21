Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1BUIui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 03:50:38 -0500
Received: from mail09.linbit.com ([212.69.161.110]:50403 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1BUIug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 03:50:36 -0500
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Feb 2011 03:50:36 EST
Date: Mon, 21 Feb 2011 09:44:19 +0100
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: Re: [Drbd-dev] [PATCH] lru_cache: Use correct type in sizeof for
 allocation
Message-ID: <20110221084419.GC20194@barkeeper1-xen.linbit>
Mail-Followup-To: Ilia Mirkin <imirkin@alum.mit.edu>,
	drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
References: <1298241914-1400-1-git-send-email-imirkin@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298241914-1400-1-git-send-email-imirkin@alum.mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 05:45:14PM -0500, Ilia Mirkin wrote:
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
> Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>

  Acked-by: Lars Ellenberg <lars@linbit.com>

> 
> ---
>  lib/lru_cache.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Note that in lc_reset, there is the line
> 
> memset(lc->lc_slot, 0, sizeof(struct hlist_head) * lc->nr_elements);
> 
> So this seems correct. But otherwise untested.
> 
> diff --git a/lib/lru_cache.c b/lib/lru_cache.c
> index 270de9d..b312c8f 100644
> --- a/lib/lru_cache.c
> +++ b/lib/lru_cache.c
> @@ -84,7 +84,7 @@ struct lru_cache *lc_create(const char *name, struct kmem_cache *cache,
>  	if (e_count > LC_MAX_ACTIVE)
>  		return NULL;
>  
> -	slot = kzalloc(e_count * sizeof(struct hlist_head*), GFP_KERNEL);
> +	slot = kzalloc(e_count * sizeof(struct hlist_head), GFP_KERNEL);

Luckily sizeof(struct hlist_head*) == sizeof(struct hlist_head),
so this went unnoticed, as it did not have any effect.

Thanks for having this spotted by semantic matching.

	Lars

>  	if (!slot)
>  		goto out_fail;
>  	element = kzalloc(e_count * sizeof(struct lc_element *), GFP_KERNEL);
> -- 
> 1.7.3.4
