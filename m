Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0ETXIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 19:08:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743Ab0ETXIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 19:08:43 -0400
Date: Thu, 20 May 2010 16:08:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tim <tim.c.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/2] tmpfs: Quick token library to allow scalable
 retrieval of tokens from token jar
Message-Id: <20100520160834.d537ccf6.akpm@linux-foundation.org>
In-Reply-To: <1274225668.31973.8950.camel@mudge.jf.intel.com>
References: <1274225668.31973.8950.camel@mudge.jf.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010 16:34:28 -0700
tim <tim.c.chen@linux.intel.com> wrote:

> This patch creates a quick token (qtoken) library to maintain local
> caches of tokens. This avoids lock contention when a token is
> retrieved or returned to the token jar, and allows better scaling
> on system with many cpus.
> 

A few things...

> diff --git a/include/linux/qtoken.h b/include/linux/qtoken.h
> new file mode 100644
> index 0000000..a09bba9
> --- /dev/null
> +++ b/include/linux/qtoken.h
> @@ -0,0 +1,40 @@
> +/*
> + * qtoken.h: Structure and function prototypes to implement quick token
> + * retrieval from a jar of tokens with per cpu cache.
> + *
> + * Copyright (C) 2010 Intel Corporation
> + * Author: Tim Chen <tim.c.chen@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + *
> + */
> +
> +#ifndef _QTOKEN_H
> +#define _QTOKEN_H
> +
> +#define QTOKEN_CACHE_HIGHMARK 2
> +#define QTOKEN_POOL_HIGHMARK (2 * QTOKEN_CACHE_HIGHMARK)
> +
> +struct qtoken {
> +	long		pool;	/* pool of free tokens */
> +	long		total;  /* total num of tokens */
> +#ifdef CONFIG_SMP
> +	long		init_cache_sz; /* initial cache size */

I don't think that it si meaningful for any of these things to have
negative values, so an unsigned type would be more appropriate.

Did they really need to be `long'?  Plain old `unsigned' might be more
efficient, perhaps.

> +	spinlock_t	lock;	/* lock on token jar */
> +	atomic_long_t __percpu *cache; /* per cpu cache of tokens */

Why are these long?  Bear in mind that `long' is only 32-bit on 32-bit..

> +#endif
> +};
> +
> +extern void qtoken_return(struct qtoken *token_jar, long tokens);
> +extern int qtoken_get(struct qtoken *token_jar, long tkn, long reserve);
> +extern int qtoken_init(struct qtoken *token_jar, long total_tokens,
> +			long init_cache_sz);
> +extern void qtoken_put(struct qtoken *token_jar);
> +extern long qtoken_avail(struct qtoken *token_jar);
> +extern int qtoken_resize(struct qtoken *token_jar, long new_total_tokens);
> +extern long qtoken_total(struct qtoken *token_jar);
> +
> +#endif /* _QTOKEN_H */
> diff --git a/lib/Makefile b/lib/Makefile
> index 0d40152..1fa8945 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>  	 idr.o int_sqrt.o extable.o prio_tree.o \
>  	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
>  	 proportions.o prio_heap.o ratelimit.o show_mem.o \
> -	 is_single_threaded.o plist.o decompress.o flex_array.o
> +	 is_single_threaded.o plist.o decompress.o flex_array.o qtoken.o
>  
>  lib-$(CONFIG_MMU) += ioremap.o
>  lib-$(CONFIG_SMP) += cpumask.o
> diff --git a/lib/qtoken.c b/lib/qtoken.c
> new file mode 100644
> index 0000000..9ab34f2
> --- /dev/null
> +++ b/lib/qtoken.c
> @@ -0,0 +1,235 @@
> +/*
> + * qtoken.c: Library of functions to implement quick token
> + * retrieval from a jar of tokens with per cpu cache.
> + *
> + * Copyright (C) 2010 Intel Corporation
> + * Author: Tim Chen <tim.c.chen@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + *
> + */

It would be nice to have some description of what this thing actually
does and how it does it.  And under which circumstances one should use
it, and how one should use it.  In the changelog or, better, in .the
.c file


> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/cpumask.h>
> +#include <linux/qtoken.h>
> +
> +void qtoken_return(struct qtoken *token_jar, long tokens)

Please document at least all the interface functions.

kerneldoc is suitable, but avoid falling into the trap of just lamely
describing the function arguments without actually telling anyone
anything interesting or relevant.

> +{
> +#ifdef CONFIG_SMP
> +	long	cnt;
> +	int	cpu;
> +	atomic_long_t	*cache;
> +
> +	cpu = get_cpu();
> +	cache = per_cpu_ptr(token_jar->cache, cpu);
> +	cnt = atomic_long_read(cache);
> +	if (cnt >= 0) {
> +		if (likely((cnt+tokens) <=
> +			QTOKEN_CACHE_HIGHMARK*token_jar->init_cache_sz)) {

It's kernel-conventional to put spaces around arithmetic operators. 
(Many instances).

> +			/* Add freed tokens to local cache unless cache was
> +			* reaped and disabled, return tokens to pool
> +			* for that case
> +			*/

More typical comment layout is like this (many instances):

			/*
			 * Add freed tokens to local cache unless cache was
			 * reaped and disabled, return tokens to pool
			 * for that case
			 */

> +			if (!atomic_long_add_unless(
> +			     cache, tokens, -1)) {
> +				spin_lock(&token_jar->lock);
> +				token_jar->pool += tokens;
> +				spin_unlock(&token_jar->lock);

It internally calls spin_lock(), so this whole facility cannot be used from
interrupt context, unless one jumps through obscure hoops.

This might be a significant restriction.  We should think about this
and it should be documented and justified.  Or fixed.

> +			}
> +		} else {
> +			spin_lock(&token_jar->lock);
> +			/* If cache has not been reaped and set to -1,
> +			 * set cache to init cache size
> +			 */
> +			if (atomic_long_add_unless(
> +				cache, token_jar->init_cache_sz-cnt, -1)) {
> +				long excess = cnt + tokens -
> +						token_jar->init_cache_sz;

In several places this code does strange contortions to avoid
overflowing 80-cols.  It would be better to let it overflow rather than
doing things like the above.

There are often tasteful fixes.  In this case,

				long extra;

				extra = cnt + tokens - token_jar->init_cache_sz;

("excess" would have overflowed ;))

Please have a think about it..

> +				token_jar->pool += excess;
> +			} else
> +				token_jar->pool += tokens;
> +			spin_unlock(&token_jar->lock);
> +		}
> +	} else {
> +		/* local cache reaped and disabled, */
> +		/* return pages to global pool */

This reference to "pages" assumes a particular application.

> +		spin_lock(&token_jar->lock);
> +		token_jar->pool += tokens;
> +		spin_unlock(&token_jar->lock);
> +	}
> +	put_cpu();
> +#else
> +	token_jar->pool += tokens;
> +#endif
> +}
> +EXPORT_SYMBOL(qtoken_return);

Can we do something to reduce the amount of `#ifdef CONFIG_SMP' in here?

> +#ifdef CONFIG_SMP
> +static void qtoken_reap_cache(struct qtoken *token_jar)
> +{
> +	long	cnt;
> +	int	i;
> +
> +	/* Need to have already acquired lock before here */
> +	/* Reap cache into pool and disable local cache */
> +	for_each_possible_cpu(i) {
> +		atomic_long_t	*cache;
> +
> +		cache = per_cpu_ptr(token_jar->cache, i);
> +		cnt = atomic_long_xchg(cache, -1);
> +		if (cnt > 0)
> +			token_jar->pool += cnt;
> +	}
> +}
> +#endif

What happens if num_possible_cpus() is much larger than num_online_cpus()?

Have you though about making this code cpu-hotplug-aware?

> +static int qtoken_from_pool(struct qtoken *token_jar, unsigned tkn,
> +				unsigned reserve)
> +{
> +	int	allocated = 0;
> +
> +#ifdef CONFIG_SMP
> +	/* Need to have acquired lock of token pool before coming here */
> +	if (token_jar->pool < (reserve+tkn))
> +		qtoken_reap_cache(token_jar);
> +#endif
> +	if (token_jar->pool >= (reserve+tkn)) {
> +		token_jar->pool -= tkn;
> +		allocated = 1;
> +	}
> +	return allocated;
> +}

Sometimes the code uses "token" and sometimes it uses "tkn".  "tkn" is
plain ugly - "token" is better.

> +int qtoken_get(struct qtoken *token_jar, long tkn, long reserve)
> +{
> +	int	allocated = 0;
> +#ifdef CONFIG_SMP
> +	int	cpu;
> +	long	cnt;
> +	atomic_long_t	*cache;
> +
> +	if (tkn <= 0)
> +		return 0;
> +	cpu = get_cpu();
> +	cache = per_cpu_ptr(token_jar->cache, cpu);
> +	cnt = atomic_long_read(cache);
> +	/* Need to reserve tokens after allocation */

As often happens, the comment explains the "what", but leaves the
reader wondering "why".

> +	if ((cnt > reserve) && (cnt >= tkn)) {
> +		if (atomic_long_add_unless(cache, -tkn, -1))
> +			allocated = 1;
> +		else {
> +			/* cache has been reaped, get token from pool */
> +			spin_lock(&token_jar->lock);
> +			allocated = qtoken_from_pool(token_jar, tkn, reserve);
> +			spin_unlock(&token_jar->lock);
> +		}
> +	} else {
> +		/* cache low, allocate from pool */
> +		spin_lock(&token_jar->lock);
> +		if ((token_jar->pool - tkn) > (QTOKEN_POOL_HIGHMARK *
> +			token_jar->init_cache_sz * num_possible_cpus())) {
> +			/* abundant tokens in pool */
> +			/* allocate token and replenish cache */
> +			token_jar->pool -= tkn;
> +			allocated = tkn;
> +			token_jar->pool -= token_jar->init_cache_sz;
> +			cnt = atomic_long_read(cache);
> +			if (cnt < 0)
> +				cnt = token_jar->init_cache_sz;
> +			else
> +				cnt += token_jar->init_cache_sz;
> +			atomic_long_set(cache, cnt);
> +		} else
> +			allocated = qtoken_from_pool(token_jar, tkn, reserve);
> +		spin_unlock(&token_jar->lock);
> +	}
> +	put_cpu();
> +#else
> +	allocated = qtoken_from_pool(token_jar, tkn, reserve);
> +#endif
> +	return allocated;
> +}
> +EXPORT_SYMBOL(qtoken_get);
> +
> +int qtoken_init(struct qtoken *token_jar, long total_tokens, long cache_size)
> +{
> +#ifdef CONFIG_SMP
> +	int	i;
> +
> +	token_jar->cache = alloc_percpu(atomic_long_t);
> +	if (!token_jar->cache)
> +		return 0;
> +	spin_lock_init(&token_jar->lock);
> +	for_each_possible_cpu(i) {
> +		atomic_long_t	*cache;
> +
> +		cache = per_cpu_ptr(token_jar->cache, i);
> +		atomic_long_set(cache, -1);
> +	}
> +	token_jar->init_cache_sz = cache_size;
> +#endif
> +	token_jar->total = token_jar->pool = total_tokens;
> +	return 1;
> +}
> +EXPORT_SYMBOL(qtoken_init);

This (undocumented) interface function returns 0 on failure and 1 on
success.  This is very atypical.  The expected interface would be 0 on
success and a -ve errno (in this case -ENOMEM) on failure.

> +void qtoken_put(struct qtoken *token_jar)
> +{
> +#ifdef CONFIG_SMP
> +	if (token_jar->cache)
> +		free_percpu(token_jar->cache);
> +#endif
> +	token_jar->pool = 0;
> +	token_jar->total = 0;
> +}
> +EXPORT_SYMBOL(qtoken_put);

One expects a kernel function called "foo_put()" to decrease the
refcount on a foo, and to free it if the refcount went to zero.  But
that isn't what this (undocumented) function appears to be doing. 
Perhaps qtoken_free() would be a more appropriate name?

> +/* This function should be called sparingly, it is
> + * expensive to get a total count of free tokens.
> + */
> +long qtoken_avail(struct qtoken *token_jar)
> +{
> +	long	cnt;
> +
> +#ifdef CONFIG_SMP
> +	spin_lock(&token_jar->lock);
> +	qtoken_reap_cache(token_jar);
> +	cnt = token_jar->pool;
> +	spin_unlock(&token_jar->lock);
> +#else
> +	cnt = token_jar->pool;
> +#endif
> +	return cnt;
> +}
> +EXPORT_SYMBOL(qtoken_avail);

Perhaps it was inappropriate to run qtoken_reap_cache() in this function.

> +int qtoken_resize(struct qtoken *token_jar, long new_total_tokens)
> +{
> +	long	in_use;
> +
> +#ifdef CONFIG_SMP
> +	spin_lock(&token_jar->lock);
> +	qtoken_reap_cache(token_jar);
> +#endif
> +	in_use = token_jar->total - token_jar->pool;
> +	if (in_use > new_total_tokens)
> +		return 0;
> +	token_jar->total = new_total_tokens - in_use;
> +#ifdef CONFIG_SMP
> +	spin_unlock(&token_jar->lock);
> +#endif
> +	return 1;
> +}
> +EXPORT_SYMBOL(qtoken_resize);

This code will get an unused-variable warning on CONFIG_SMP=n.  Please
do a uniprocessor test build, get it clean.

> +long qtoken_total(struct qtoken *token_jar)
> +{
> +	return token_jar->total;
> +}
> +EXPORT_SYMBOL(qtoken_total);

