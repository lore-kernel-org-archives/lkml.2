Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab3ABXMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 18:12:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3ABXMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 18:12:43 -0500
Date: Wed, 2 Jan 2013 15:12:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Decotigny <decot@googlers.com>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH v4] lib: cpu_rmap: avoid flushing all workqueues
Message-Id: <20130102151242.fc6f1bee.akpm@linux-foundation.org>
In-Reply-To: <bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
References: <cover.1357163124.git.decot@googlers.com>
	<bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Jan 2013 13:52:25 -0800
David Decotigny <decot@googlers.com> wrote:

> In some cases, free_irq_cpu_rmap() is called while holding a lock
> (eg. rtnl). This can lead to deadlocks, because it invokes
> flush_scheduled_work() which ends up waiting for whole system
> workqueue to flush, but some pending works might try to acquire the
> lock we are already holding.
> 
> This commit uses reference-counting to replace
> irq_run_affinity_notifiers(). It also removes
> irq_run_affinity_notifiers() altogether.

I can't say that I've ever noticed cpu_rmap.c before :( Is is too late
to review it?

- The naming is chaotic.  At least these:

	EXPORT_SYMBOL(alloc_cpu_rmap);
	EXPORT_SYMBOL(free_cpu_rmap);
	EXPORT_SYMBOL(cpu_rmap_add);
	EXPORT_SYMBOL(cpu_rmap_update);
	EXPORT_SYMBOL(free_irq_cpu_rmap);
	EXPORT_SYMBOL(irq_cpu_rmap_add);

  should be consistently named cpu_rmap_foo()

- What's the locking model?  It appears to be caller-provided, but
  it is undocumented.

  drivers/net/ethernet/mellanox/mlx4/ appears to be using
  msix_ctl.pool_lock for exclusion, but I didn't check for coverage.

  drivers/net/ethernet/sfc/efx.c seems to not need locking because
  all its cpu_rmap operations are at module_init() time.

  The cpu_rmap code would be less of a hand grenade if each of its
  interface functions documented the caller's locking requirements.


As for this patch: there's no cc:stable here but it does appear that
the problem is sufficiently serious to justify a backport, agree?

> --- a/include/linux/cpu_rmap.h
> +++ b/include/linux/cpu_rmap.h
>
> ...
>
> @@ -33,15 +36,7 @@ struct cpu_rmap {
>  #define CPU_RMAP_DIST_INF 0xffff
>  
>  extern struct cpu_rmap *alloc_cpu_rmap(unsigned int size, gfp_t flags);
> -
> -/**
> - * free_cpu_rmap - free CPU affinity reverse-map
> - * @rmap: Reverse-map allocated with alloc_cpu_rmap(), or %NULL
> - */
> -static inline void free_cpu_rmap(struct cpu_rmap *rmap)
> -{
> -	kfree(rmap);
> -}
> +extern void free_cpu_rmap(struct cpu_rmap *rmap);

Can we do away with free_cpu_rmap() altogether?  It is a misleading
name - it is a put() function, not a free() function.  It would be
clearer (not to mention faster and smaller) to change all call sites
to directly call cpu_rmap_put().


>  extern int cpu_rmap_add(struct cpu_rmap *rmap, void *obj);
>  extern int cpu_rmap_update(struct cpu_rmap *rmap, u16 index,
>
> ...
>
> @@ -63,6 +64,44 @@ struct cpu_rmap *alloc_cpu_rmap(unsigned int size, gfp_t flags)
>  }
>  EXPORT_SYMBOL(alloc_cpu_rmap);
>  
> +/**
> + * cpu_rmap_reclaim - internal reclaiming helper called from kref_put
> + * @ref: kref to struct cpu_rmap
> + */
> +static void cpu_rmap_reclaim(struct kref *ref)
> +{
> +	struct cpu_rmap *rmap = container_of(ref, struct cpu_rmap, refcount);
> +	kfree(rmap);
> +}

I suggest this be renamed to cpu_rmap_release().  As "release" is the
conventional term for a kref release handler.

>
> ...
>
> +/**
> + * cpu_rmap_put - internal helper to release ref on a cpu_rmap
> + * @rmap: reverse-map allocated with alloc_cpu_rmap()
> + */
> +static inline void cpu_rmap_put(struct cpu_rmap *rmap)
> +{
> +	kref_put(&rmap->refcount, cpu_rmap_reclaim);
> +}

As mentioned, I suggest this become the public interface.  And I
suppose it should propagate kref_put()'s return value, in case someone
is interested.

> +/**
> + * free_cpu_rmap - free CPU affinity reverse-map
> + * @rmap: Reverse-map allocated with alloc_cpu_rmap()
> + */
> +void free_cpu_rmap(struct cpu_rmap *rmap)
> +{
> +	cpu_rmap_put(rmap);
> +}
> +EXPORT_SYMBOL(free_cpu_rmap);

zap.

>  /* Reevaluate nearest object for given CPU, comparing with the given
>   * neighbours at the given distance.
>   */
>
> ...
>

