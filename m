Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3ABWU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:20:27 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33101 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3ABWUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:20:22 -0500
X-Originating-IP: 217.70.178.139
X-Originating-IP: 173.246.103.110
Date: Wed, 2 Jan 2013 14:20:13 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: David Decotigny <decot@googlers.com>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH v4] lib: cpu_rmap: avoid flushing all workqueues
Message-ID: <20130102222013.GA29786@jtriplet-mobl1>
References: <cover.1357163124.git.decot@googlers.com>
 <bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 01:52:25PM -0800, David Decotigny wrote:
> In some cases, free_irq_cpu_rmap() is called while holding a lock
> (eg. rtnl). This can lead to deadlocks, because it invokes
> flush_scheduled_work() which ends up waiting for whole system
> workqueue to flush, but some pending works might try to acquire the
> lock we are already holding.
> 
> This commit uses reference-counting to replace
> irq_run_affinity_notifiers(). It also removes
> irq_run_affinity_notifiers() altogether.
> 
> Signed-off-by: David Decotigny <decot@googlers.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  include/linux/cpu_rmap.h  |   13 +++-------
>  include/linux/interrupt.h |    5 ----
>  lib/cpu_rmap.c            |   63 +++++++++++++++++++++++++++++++++++++++++----
>  3 files changed, 62 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/cpu_rmap.h b/include/linux/cpu_rmap.h
> index ac3bbb5..3be2813 100644
> --- a/include/linux/cpu_rmap.h
> +++ b/include/linux/cpu_rmap.h
> @@ -13,9 +13,11 @@
>  #include <linux/cpumask.h>
>  #include <linux/gfp.h>
>  #include <linux/slab.h>
> +#include <linux/kref.h>
>  
>  /**
>   * struct cpu_rmap - CPU affinity reverse-map
> + * @refcount: kref for object
>   * @size: Number of objects to be reverse-mapped
>   * @used: Number of objects added
>   * @obj: Pointer to array of object pointers
> @@ -23,6 +25,7 @@
>   *      based on affinity masks
>   */
>  struct cpu_rmap {
> +	struct kref	refcount;
>  	u16		size, used;
>  	void		**obj;
>  	struct {
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
>  
>  extern int cpu_rmap_add(struct cpu_rmap *rmap, void *obj);
>  extern int cpu_rmap_update(struct cpu_rmap *rmap, u16 index,
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 5e4e617..5fa5afe 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -268,11 +268,6 @@ struct irq_affinity_notify {
>  extern int
>  irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify);
>  
> -static inline void irq_run_affinity_notifiers(void)
> -{
> -	flush_scheduled_work();
> -}
> -
>  #else /* CONFIG_SMP */
>  
>  static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
> diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
> index 145dec5..bcd1f0e 100644
> --- a/lib/cpu_rmap.c
> +++ b/lib/cpu_rmap.c
> @@ -45,6 +45,7 @@ struct cpu_rmap *alloc_cpu_rmap(unsigned int size, gfp_t flags)
>  	if (!rmap)
>  		return NULL;
>  
> +	kref_init(&rmap->refcount);
>  	rmap->obj = (void **)((char *)rmap + obj_offset);
>  
>  	/* Initially assign CPUs to objects on a rota, since we have
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
> +
> +/**
> + * cpu_rmap_get - internal helper to get new ref on a cpu_rmap
> + * @rmap: reverse-map allocated with alloc_cpu_rmap()
> + */
> +static inline void cpu_rmap_get(struct cpu_rmap *rmap)
> +{
> +	kref_get(&rmap->refcount);
> +}
> +
> +/**
> + * cpu_rmap_put - internal helper to release ref on a cpu_rmap
> + * @rmap: reverse-map allocated with alloc_cpu_rmap()
> + */
> +static inline void cpu_rmap_put(struct cpu_rmap *rmap)
> +{
> +	kref_put(&rmap->refcount, cpu_rmap_reclaim);
> +}
> +
> +/**
> + * free_cpu_rmap - free CPU affinity reverse-map
> + * @rmap: Reverse-map allocated with alloc_cpu_rmap()
> + */
> +void free_cpu_rmap(struct cpu_rmap *rmap)
> +{
> +	cpu_rmap_put(rmap);
> +}
> +EXPORT_SYMBOL(free_cpu_rmap);
> +
>  /* Reevaluate nearest object for given CPU, comparing with the given
>   * neighbours at the given distance.
>   */
> @@ -197,8 +236,7 @@ struct irq_glue {
>   * free_irq_cpu_rmap - free a CPU affinity reverse-map used for IRQs
>   * @rmap: Reverse-map allocated with alloc_irq_cpu_map(), or %NULL
>   *
> - * Must be called in process context, before freeing the IRQs, and
> - * without holding any locks required by global workqueue items.
> + * Must be called in process context, before freeing the IRQs.
>   */
>  void free_irq_cpu_rmap(struct cpu_rmap *rmap)
>  {
> @@ -212,12 +250,18 @@ void free_irq_cpu_rmap(struct cpu_rmap *rmap)
>  		glue = rmap->obj[index];
>  		irq_set_affinity_notifier(glue->notify.irq, NULL);
>  	}
> -	irq_run_affinity_notifiers();
>  
> -	kfree(rmap);
> +	cpu_rmap_put(rmap);
>  }
>  EXPORT_SYMBOL(free_irq_cpu_rmap);
>  
> +/**
> + * irq_cpu_rmap_notify - callback for IRQ subsystem when IRQ affinity updated
> + * @notify: struct irq_affinity_notify passed by irq/manage.c
> + * @mask: cpu mask for new SMP affinity
> + *
> + * This is executed in workqueue context.
> + */
>  static void
>  irq_cpu_rmap_notify(struct irq_affinity_notify *notify, const cpumask_t *mask)
>  {
> @@ -230,10 +274,16 @@ irq_cpu_rmap_notify(struct irq_affinity_notify *notify, const cpumask_t *mask)
>  		pr_warning("irq_cpu_rmap_notify: update failed: %d\n", rc);
>  }
>  
> +/**
> + * irq_cpu_rmap_release - reclaiming callback for IRQ subsystem
> + * @ref: kref to struct irq_affinity_notify passed by irq/manage.c
> + */
>  static void irq_cpu_rmap_release(struct kref *ref)
>  {
>  	struct irq_glue *glue =
>  		container_of(ref, struct irq_glue, notify.kref);
> +
> +	cpu_rmap_put(glue->rmap);
>  	kfree(glue);
>  }
>  
> @@ -258,10 +308,13 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
>  	glue->notify.notify = irq_cpu_rmap_notify;
>  	glue->notify.release = irq_cpu_rmap_release;
>  	glue->rmap = rmap;
> +	cpu_rmap_get(rmap);
>  	glue->index = cpu_rmap_add(rmap, glue);
>  	rc = irq_set_affinity_notifier(irq, &glue->notify);
> -	if (rc)
> +	if (rc) {
> +		cpu_rmap_put(glue->rmap);
>  		kfree(glue);
> +	}
>  	return rc;
>  }
>  EXPORT_SYMBOL(irq_cpu_rmap_add);
> -- 
> 1.7.10.2.5.g20d7bc9
> 
