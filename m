Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2L1SSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 13:18:36 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:58249 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab2L1SSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 13:18:32 -0500
MIME-Version: 1.0
In-Reply-To: <20121228040430.GA10244@leaf>
References: <cover.1356635879.git.decot@googlers.com> <82b0a7204d5cb4032b02f731a956ee9923ff150c.1356635879.git.decot@googlers.com>
 <20121228040430.GA10244@leaf>
From: David Decotigny <decot@googlers.com>
Date: Fri, 28 Dec 2012 10:18:11 -0800
Message-ID: <CAG88wWadShHHK_7DwyDmYYZkCHXmrF0NKtJDY0aSYcEjisP95A@mail.gmail.com>
Subject: Re: [PATCH v1] lib: cpu_rmap: avoid flushing all workqueues
To: Josh Triplett <josh@joshtriplett.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you, Josh,

A few comments below, and the revised version shortly.

On Thu, Dec 27, 2012 at 8:04 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Thu, Dec 27, 2012 at 11:24:34AM -0800, David Decotigny wrote:
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
>
> A couple of comments below; with those addressed,
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>
>>  include/linux/cpu_rmap.h  |   13 ++++--------
>>  include/linux/interrupt.h |    5 -----
>>  lib/cpu_rmap.c            |   48 +++++++++++++++++++++++++++++++++++++++------
>>  3 files changed, 46 insertions(+), 20 deletions(-)
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
>> index 145dec5..295cbf8 100644
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
>> +{
>> +     kref_put(&rmap->refcount, reclaim_cpu_rmap);
>> +}
>> +EXPORT_SYMBOL(free_cpu_rmap);
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
>> +     kref_put(&rmap->refcount, reclaim_cpu_rmap);
>
> This should call free_cpu_rmap, rather than duplicating its body.

Makes sense. Will do.

>
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
>> @@ -230,16 +256,23 @@ irq_cpu_rmap_notify(struct irq_affinity_notify *notify, const cpumask_t *mask)
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
>> +     struct cpu_rmap *rmap = glue->rmap;
>> +
>>       kfree(glue);
>> +     kref_put(&rmap->refcount, reclaim_cpu_rmap);
>
> Likewise, but also, why not call free_cpu_rmap(glue->rmap) before
> kfree(glue) so you don't need the local copy?

I prefer to keep this kref_put here. I believe that calling something
named "free_cpu_rmap" here might be misleading. It's code sharing vs.
what we actually need to do, even though both are equivalent... for
now.

For the order, it was deliberate, to have some kind of symmetry with
kfree/kref_put in the error path we have in next function
(irq_cpu_rmap_add). I reversed the order in that next function to
avoid this unneeded local variable here. New ordering makes more sense
anyways.

>
>>  }
>>
>>  /**
>>   * irq_cpu_rmap_add - add an IRQ to a CPU affinity reverse-map
>> - * @rmap: The reverse-map
>> + * @rmap: The per-IRQ reverse-map
>>   * @irq: The IRQ number
>>   *
>>   * This adds an IRQ affinity notifier that will update the reverse-map
>> @@ -259,9 +292,12 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
>>       glue->notify.release = irq_cpu_rmap_release;
>>       glue->rmap = rmap;
>>       glue->index = cpu_rmap_add(rmap, glue);
>> +     kref_get(&rmap->refcount);
>>       rc = irq_set_affinity_notifier(irq, &glue->notify);
>> -     if (rc)
>> +     if (rc) {
>>               kfree(glue);
>> +             kref_put(&rmap->refcount, reclaim_cpu_rmap);
>
> Likewise.

I prefer to leave the explicit kref_put here too.

>
>> +     }
>>       return rc;
>>  }
>>  EXPORT_SYMBOL(irq_cpu_rmap_add);
>> --
>> 1.7.10.2.5.g20d7bc9
>>

Next version soon, after some re-testing.
