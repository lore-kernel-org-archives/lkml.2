Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2L1Voa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 16:44:30 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:41353 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab2L1Vo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 16:44:27 -0500
MIME-Version: 1.0
In-Reply-To: <1356729284.21409.889.camel@edumazet-glaptop>
References: <cover.1356721114.git.decot@googlers.com> <d1d3f42dff1837cd43e67f954c51eb9d1f91b4ba.1356721114.git.decot@googlers.com>
 <1356729284.21409.889.camel@edumazet-glaptop>
From: David Decotigny <decot@googlers.com>
Date: Fri, 28 Dec 2012 13:44:06 -0800
Message-ID: <CAG88wWbPY76O1YOSb=Jp2hGhQEgSDLoseorkTjOcep3pj1Z1bA@mail.gmail.com>
Subject: Re: [PATCH v2] lib: cpu_rmap: avoid flushing all workqueues
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

Ok for the cpu_rmap_put helper. Will do this in v3 of this patch.

Your comments suggest more refactoring, which might be better in the
form of 1 or 2 additional patches that:
 - rename alloc_cpu_rmap & co according to new conventions (cpu_rmap_*)
 - remove the cpu_rmap sub-API altogether, keeping only irq_cpu_rmap
(controversial?)

I'd rather current patch is integrated in its own as it fixes an actual bug.
I will send the other patch(es) separately later.

v3 for this patch coming soon.

On Fri, Dec 28, 2012 at 1:14 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Fri, 2012-12-28 at 11:03 -0800, David Decotigny wrote:
>> In some cases, free_irq_cpu_rmap() is called while holding a lock
>> (eg. rtnl). This can lead to deadlocks, because it invokes
>> flush_scheduled_work() which ends up waiting for whole system
>> workqueue to flush, but some pending works might try to acquire the
>> lock we are already holding.
>>
>> This commit uses reference-counting to replace
>> irq_run_affinity_notifiers(). It also removes
>> irq_run_affinity_notifiers() altogether.
>>
>> Signed-off-by: David Decotigny <decot@googlers.com>
>> ---
>>  include/linux/cpu_rmap.h  |   13 ++++---------
>>  include/linux/interrupt.h |    5 -----
>>  lib/cpu_rmap.c            |   47 +++++++++++++++++++++++++++++++++++++++------
>>  3 files changed, 45 insertions(+), 20 deletions(-)
>>
>> diff --git a/include/linux/cpu_rmap.h b/include/linux/cpu_rmap.h
>> index ac3bbb5..3be2813 100644
>> --- a/include/linux/cpu_rmap.h
>> +++ b/include/linux/cpu_rmap.h
>> @@ -13,9 +13,11 @@
>>  #include <linux/cpumask.h>
>>  #include <linux/gfp.h>
>>  #include <linux/slab.h>
>> +#include <linux/kref.h>
>>
>>  /**
>>   * struct cpu_rmap - CPU affinity reverse-map
>> + * @refcount: kref for object
>>   * @size: Number of objects to be reverse-mapped
>>   * @used: Number of objects added
>>   * @obj: Pointer to array of object pointers
>> @@ -23,6 +25,7 @@
>>   *      based on affinity masks
>>   */
>>  struct cpu_rmap {
>> +     struct kref     refcount;
>>       u16             size, used;
>>       void            **obj;
>>       struct {
>> @@ -33,15 +36,7 @@ struct cpu_rmap {
>>  #define CPU_RMAP_DIST_INF 0xffff
>>
>>  extern struct cpu_rmap *alloc_cpu_rmap(unsigned int size, gfp_t flags);
>> -
>> -/**
>> - * free_cpu_rmap - free CPU affinity reverse-map
>> - * @rmap: Reverse-map allocated with alloc_cpu_rmap(), or %NULL
>> - */
>> -static inline void free_cpu_rmap(struct cpu_rmap *rmap)
>> -{
>> -     kfree(rmap);
>> -}
>> +extern void free_cpu_rmap(struct cpu_rmap *rmap);
>>
>>  extern int cpu_rmap_add(struct cpu_rmap *rmap, void *obj);
>>  extern int cpu_rmap_update(struct cpu_rmap *rmap, u16 index,
>> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
>> index 5e4e617..5fa5afe 100644
>> --- a/include/linux/interrupt.h
>> +++ b/include/linux/interrupt.h
>> @@ -268,11 +268,6 @@ struct irq_affinity_notify {
>>  extern int
>>  irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify);
>>
>> -static inline void irq_run_affinity_notifiers(void)
>> -{
>> -     flush_scheduled_work();
>> -}
>> -
>>  #else /* CONFIG_SMP */
>>
>>  static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
>> diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
>> index 145dec5..bb5d0af 100644
>> --- a/lib/cpu_rmap.c
>> +++ b/lib/cpu_rmap.c
>> @@ -45,6 +45,7 @@ struct cpu_rmap *alloc_cpu_rmap(unsigned int size, gfp_t flags)
>>       if (!rmap)
>>               return NULL;
>>
>> +     kref_init(&rmap->refcount);
>>       rmap->obj = (void **)((char *)rmap + obj_offset);
>>
>>       /* Initially assign CPUs to objects on a rota, since we have
>> @@ -63,6 +64,26 @@ struct cpu_rmap *alloc_cpu_rmap(unsigned int size, gfp_t flags)
>>  }
>>  EXPORT_SYMBOL(alloc_cpu_rmap);
>>
>> +/**
>> + * reclaim_cpu_rmap - internal reclaiming helper called from kref_put
>> + * @ref: kref to struct cpu_rmap
>> + */
>> +static void reclaim_cpu_rmap(struct kref *ref)
>
> Could be named cpu_rmap_free()
>
> (and alloc_cpu_rmap() should be renamed as cpu_rmap_alloc()
>
>> +{
>> +     struct cpu_rmap *rmap = container_of(ref, struct cpu_rmap, refcount);
>> +     kfree(rmap);
>> +}
>> +
>> +/**
>> + * free_cpu_rmap - free CPU affinity reverse-map
>> + * @rmap: Reverse-map allocated with alloc_cpu_rmap(), or %NULL
>> + */
>> +void free_cpu_rmap(struct cpu_rmap *rmap)
>
> This could be named : cpu_rmap_put()
>
>> +{
>> +     kref_put(&rmap->refcount, reclaim_cpu_rmap);
>> +}
>> +EXPORT_SYMBOL(free_cpu_rmap);
>
> It seems this function could be static, and not exported.
>
>> +
>>  /* Reevaluate nearest object for given CPU, comparing with the given
>>   * neighbours at the given distance.
>>   */
>> @@ -197,8 +218,7 @@ struct irq_glue {
>>   * free_irq_cpu_rmap - free a CPU affinity reverse-map used for IRQs
>>   * @rmap: Reverse-map allocated with alloc_irq_cpu_map(), or %NULL
>>   *
>> - * Must be called in process context, before freeing the IRQs, and
>> - * without holding any locks required by global workqueue items.
>> + * Must be called in process context, before freeing the IRQs.
>>   */
>>  void free_irq_cpu_rmap(struct cpu_rmap *rmap)
>>  {
>> @@ -212,12 +232,18 @@ void free_irq_cpu_rmap(struct cpu_rmap *rmap)
>>               glue = rmap->obj[index];
>>               irq_set_affinity_notifier(glue->notify.irq, NULL);
>>       }
>> -     irq_run_affinity_notifiers();
>>
>> -     kfree(rmap);
>> +     free_cpu_rmap(rmap);
>>  }
>>  EXPORT_SYMBOL(free_irq_cpu_rmap);
>>
>> +/**
>> + * irq_cpu_rmap_notify - callback for IRQ subsystem when IRQ affinity updated
>> + * @notify: struct irq_affinity_notify passed by irq/manage.c
>> + * @mask: cpu mask for new SMP affinity
>> + *
>> + * This is executed in workqueue context.
>> + */
>>  static void
>>  irq_cpu_rmap_notify(struct irq_affinity_notify *notify, const cpumask_t *mask)
>>  {
>> @@ -230,16 +256,22 @@ irq_cpu_rmap_notify(struct irq_affinity_notify *notify, const cpumask_t *mask)
>>               pr_warning("irq_cpu_rmap_notify: update failed: %d\n", rc);
>>  }
>>
>> +/**
>> + * irq_cpu_rmap_release - reclaiming callback for IRQ subsystem
>> + * @ref: kref to struct irq_affinity_notify passed by irq/manage.c
>> + */
>>  static void irq_cpu_rmap_release(struct kref *ref)
>>  {
>>       struct irq_glue *glue =
>>               container_of(ref, struct irq_glue, notify.kref);
>> +
>> +     kref_put(&glue->rmap->refcount, reclaim_cpu_rmap);
>
>         cpu_rmap_put(glue->rmap);
>
>>       kfree(glue);
>>  }
>>
>>  /**
>>   * irq_cpu_rmap_add - add an IRQ to a CPU affinity reverse-map
>> - * @rmap: The reverse-map
>> + * @rmap: The per-IRQ reverse-map
>>   * @irq: The IRQ number
>>   *
>>   * This adds an IRQ affinity notifier that will update the reverse-map
>> @@ -259,9 +291,12 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
>>       glue->notify.release = irq_cpu_rmap_release;
>>       glue->rmap = rmap;
>>       glue->index = cpu_rmap_add(rmap, glue);
>> +     kref_get(&rmap->refcount);
>>       rc = irq_set_affinity_notifier(irq, &glue->notify);
>> -     if (rc)
>> +     if (rc) {
>> +             kref_put(&rmap->refcount, reclaim_cpu_rmap);
>
>                 cpu_rmap_put(rmap);
>
>>               kfree(glue);
>> +     }
>>       return rc;
>>  }
>>  EXPORT_SYMBOL(irq_cpu_rmap_add);
>
> I personally don't like kref abstraction, especially when used without
> wrapper :
>
> kref_put(&rmap->refcount, reclaim_cpu_rmap);
>
> Its cleaner to have instead :
>
> cpu_rmap_put(rmap);
>
>
>
>
