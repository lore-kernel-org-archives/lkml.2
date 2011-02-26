Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab1BZWlk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 17:41:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24446 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab1BZWli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 17:41:38 -0500
Message-ID: <4D698135.1050302@oracle.com>
Date: Sat, 26 Feb 2011 14:39:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mariusz Kozlowski <mk@lab.zgora.pl>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-next@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: fix ksize() build error
References: <20110225105205.5a1309bb.randy.dunlap@oracle.com> <1298747426-8236-1-git-send-email-mk@lab.zgora.pl>
In-Reply-To: <1298747426-8236-1-git-send-email-mk@lab.zgora.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D698195.014B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/11 11:10, Mariusz Kozlowski wrote:
> mm/slub.c: In function 'ksize':
> mm/slub.c:2728: error: implicit declaration of function 'slab_ksize'
> 
> slab_ksize() needs to go out of CONFIG_SLUB_DEBUG section.
> 
> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
> Maybe something like this? Compile tested for slub debug enabled/disabled.
> 
>  mm/slub.c |   48 ++++++++++++++++++++++++------------------------
>  1 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 217b5b5..ea6f039 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -281,6 +281,30 @@ static inline int slab_index(void *p, struct kmem_cache *s, void *addr)
>  	return (p - addr) / s->size;
>  }
>  
> +static inline size_t slab_ksize(const struct kmem_cache *s)
> +{
> +#ifdef CONFIG_SLUB_DEBUG
> +	/*
> +	 * Debugging requires use of the padding between object
> +	 * and whatever may come after it.
> +	 */
> +	if (s->flags & (SLAB_RED_ZONE | SLAB_POISON))
> +		return s->objsize;
> +
> +#endif
> +	/*
> +	 * If we have the need to store the freelist pointer
> +	 * back there or track user information then we can
> +	 * only use the space before that information.
> +	 */
> +	if (s->flags & (SLAB_DESTROY_BY_RCU | SLAB_STORE_USER))
> +		return s->inuse;
> +	/*
> +	 * Else we can use all the padding etc for the allocation
> +	 */
> +	return s->size;
> +}
> +
>  static inline struct kmem_cache_order_objects oo_make(int order,
>  						unsigned long size)
>  {
> @@ -797,30 +821,6 @@ static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
>  	return should_failslab(s->objsize, flags, s->flags);
>  }
>  
> -static inline size_t slab_ksize(const struct kmem_cache *s)
> -{
> -#ifdef CONFIG_SLUB_DEBUG
> -	/*
> -	 * Debugging requires use of the padding between object
> -	 * and whatever may come after it.
> -	 */
> -	if (s->flags & (SLAB_RED_ZONE | SLAB_POISON))
> -		return s->objsize;
> -
> -#endif
> -	/*
> -	 * If we have the need to store the freelist pointer
> -	 * back there or track user information then we can
> -	 * only use the space before that information.
> -	 */
> -	if (s->flags & (SLAB_DESTROY_BY_RCU | SLAB_STORE_USER))
> -		return s->inuse;
> -	/*
> -	 * Else we can use all the padding etc for the allocation
> -	 */
> -	return s->size;
> -}
> -
>  static inline void slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags, void *object)
>  {
>  	flags &= gfp_allowed_mask;


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
