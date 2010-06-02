Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab0FBRdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 13:33:09 -0400
Received: from mga07.intel.com ([143.182.124.22]:18806 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932856Ab0FBRdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 13:33:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,348,1272870000"; 
   d="scan'208";a="284172858"
Subject: Re: [PATCH v2 1/2] tmpfs: Quick token library to allow scalable
 retrieval of tokens from token jar
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hughd@google.com>
In-Reply-To: <20100601145126.f46572d1.akpm@linux-foundation.org>
References: <1274902371.31973.9392.camel@mudge.jf.intel.com>
	 <20100601145126.f46572d1.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 10:32:49 -0700
Message-ID: <1275499969.2385.16.camel@mudge.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 14:51 -0700, Andrew Morton wrote:

> >
> > +static void qtoken_reap_cache(struct qtoken *token_jar)
> > +{
> > +	long cnt;
> > +	int i;
> > +
> > +	for_each_possible_cpu(i) {
> > +		atomic_long_t	*cache;
> > +
> > +		cache = per_cpu_ptr(token_jar->cache, i);
> > +		cnt = atomic_long_xchg(cache, -1);
> > +		if (cnt > 0)
> > +			token_jar->pool += cnt;
> > +	}
> > +}
> 
> Not cpu-hotplug aware.  Also, inefficient if num_online_cpus is much
> less than num_possible_cpus.
> 
> It's really not hard to do!  lib/percpu_counter.c is per-cpu aware and
> it does this by sneakily connecting all counters together system-wide.
> 

I've thought about using "for_each_online_cpu" in the above loop.
However, it someone takes a cpu offline, then we will lose the tokens
in that cpu's cache when we do reap cache.  So I thought it is safer
to do for_each_possible_cpu. We should not be calling reap cache
very often (only when we are low on tokens). The impact to
performance should be small.

> > +/**
> > + * qtoken_from pool: Get tokens from common pool in token jar
> > + *
> > + * @token_jar: pointer to struct qtoken
> > + * @tokens: the number of tokens to acquire from token jar
> > + * @reserve: number of tokens to reserve in token jar after getting tokens
> > + *
> > + * Get @tokens from the token jar's common pool but keep @reserve tokens.
> > + * We will fail the operation if we cannot keep @reserve tokens in token jar.
> > + *
> > + * Return 0 if operations succeeds and -ENOSPC if operation fails.
> > + */
> > +static int qtoken_from_pool(struct qtoken *token_jar, unsigned long tokens,
> > +				unsigned long reserve)
> > +{
> > +	int	allocated = -ENOSPC;
> > +
> > +	/* We should have acquired lock of token pool before coming here */
> > +	if (token_jar->pool < (reserve + tokens))
> > +		qtoken_reap_cache(token_jar);
> > +	if (token_jar->pool >= (reserve + tokens)) {
> > +		token_jar->pool -= tokens;
> > +		allocated = 0;
> > +	}
> > +	return allocated;
> > +}
> 
> ENOSPC means "your disk is full".  But my disk isn't full.  If this
> inappropriate (indeed, incorrect) error code is ever propagated back to
> userspace then users will be justifiably confused.
> 

Originally, I was using -ENOSPC to mean tmpfs being full and out of
space.  Will -EBUSY to denote all resources are used be more
appropriate?  

Thanks.

Tim Chen

Acked-by: Tim Chen <tim.c.chen@linux.intel.com>

> Have some comment fixes.  I don't know if the " - " is compulsory in
> the kerneldoc, but it is conventional.
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> fix comment typo
> repair kerneldoc
> 
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  lib/qtoken.c |   26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff -puN lib/qtoken.c~tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix lib/qtoken.c
> --- a/lib/qtoken.c~tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix
> +++ a/lib/qtoken.c
> @@ -58,7 +58,7 @@
>   * the cache is disabled (i.e. value -1).  For this case,
>   * @tokens are returned to common pool.
>   * If the number of tokens in current cpu's cache exceed
> - * a a highmark, we will return the extra tokens into the
> + * a highmark, we will return the extra tokens into the
>   * common pool.
>   */
>  void qtoken_return(struct qtoken *token_jar, unsigned long tokens)
> @@ -100,7 +100,7 @@ void qtoken_return(struct qtoken *token_
>  EXPORT_SYMBOL(qtoken_return);
>  
>  /**
> - * qtoken_reap cache: Move tokens from cache into common pool in token jar
> + * qtoken_reap_cache - move tokens from cache into common pool in token jar
>   *
>   * @token_jar: pointer to token jar
>   *
> @@ -123,7 +123,7 @@ static void qtoken_reap_cache(struct qto
>  }
>  
>  /**
> - * qtoken_from pool: Get tokens from common pool in token jar
> + * qtoken_from_pool - get tokens from common pool in token jar
>   *
>   * @token_jar: pointer to struct qtoken
>   * @tokens: the number of tokens to acquire from token jar
> @@ -150,7 +150,7 @@ static int qtoken_from_pool(struct qtoke
>  }
>  
>  /**
> - * qtoken_get: Get tokens from token jar
> + * qtoken_get - get tokens from token jar
>   *
>   * @token_jar: pointer to struct qtoken
>   * @tokens: the number of tokens to acquire from token jar
> @@ -217,7 +217,7 @@ int qtoken_get(struct qtoken *token_jar,
>  EXPORT_SYMBOL(qtoken_get);
>  
>  /**
> - * qtoken_init: Init token jar
> + * qtoken_init - init token jar
>   *
>   * @token_jar: pointer to token jar
>   * @total_tokens: the total number of tokens that the token jar holds
> @@ -266,7 +266,7 @@ void qtoken_free(struct qtoken *token_ja
>  EXPORT_SYMBOL(qtoken_free);
>  
>  /**
> - * qtoken_avail: Calculates token available in token jar
> + * qtoken_avail - calculates token available in token jar
>   *
>   * @token_jar: pointer to token jar
>   *
> @@ -295,7 +295,7 @@ unsigned long qtoken_avail(struct qtoken
>  EXPORT_SYMBOL(qtoken_avail);
>  
>  /**
> - * qtoken_resize: Resize the total number of tokens in token jar
> + * qtoken_resize - resize the total number of tokens in token jar
>   *
>   * @token_jar: pointer to token jar
>   * @new_size: new total number of tokens in token jar
> @@ -337,7 +337,7 @@ void qtoken_return(struct qtoken *token_
>  EXPORT_SYMBOL(qtoken_return);
>  
>  /**
> - * qtoken_get: Get tokens from token jar
> + * qtoken_get - get tokens from token jar
>   *
>   * @token_jar: pointer to struct qtoken
>   * @tokens: the number of tokens to acquire from token jar
> @@ -364,7 +364,7 @@ int qtoken_get(struct qtoken *token_jar,
>  EXPORT_SYMBOL(qtoken_get);
>  
>  /**
> - * qtoken_init: Init token jar
> + * qtoken_init - init token jar
>   *
>   * @token_jar: pointer to token jar
>   * @total_tokens: the total number of tokens that the token jar holds
> @@ -383,7 +383,7 @@ int qtoken_init(struct qtoken *token_jar
>  EXPORT_SYMBOL(qtoken_init);
>  
>  /**
> - * qtoken_free: Free token jar
> + * qtoken_free - free token jar
>   *
>   * @token_jar: pointer to token jar
>   *
> @@ -397,7 +397,7 @@ void qtoken_free(struct qtoken *token_ja
>  EXPORT_SYMBOL(qtoken_free);
>  
>  /**
> - * qtoken_avail: Calculate the tokens available in token jar
> + * qtoken_avail - calculate the tokens available in token jar
>   *
>   * @token_jar: pointer to token jar
>   *
> @@ -409,7 +409,7 @@ unsigned long qtoken_avail(struct qtoken
>  EXPORT_SYMBOL(qtoken_avail);
>  
>  /**
> - * qtoken_resize: Resize the total number of tokens in token jar
> + * qtoken_resize - resize the total number of tokens in token jar
>   *
>   * @token_jar: pointer to token jar
>   * @new_size: new total number of tokens in token jar
> @@ -434,7 +434,7 @@ EXPORT_SYMBOL(qtoken_resize);
>  #endif /* CONFIG_SMP */
>  
>  /**
> - * qtoken_total: Return the total number of tokens configured for token jar
> + * qtoken_total - return the total number of tokens configured for token jar
>   *
>   * @token_jar: pointer to token jar
>   *
> _
> 


