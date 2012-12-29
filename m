Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab2L2AQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 19:16:44 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54954 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab2L2AQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 19:16:42 -0500
X-Originating-IP: 217.70.178.139
X-Originating-IP: 50.43.39.152
Date: Fri, 28 Dec 2012 16:16:33 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: David Decotigny <decot@googlers.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH v1] lib: cpu_rmap: avoid flushing all workqueues
Message-ID: <20121229001633.GA17342@leaf>
References: <cover.1356635879.git.decot@googlers.com>
 <82b0a7204d5cb4032b02f731a956ee9923ff150c.1356635879.git.decot@googlers.com>
 <20121228040430.GA10244@leaf>
 <CAG88wWadShHHK_7DwyDmYYZkCHXmrF0NKtJDY0aSYcEjisP95A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG88wWadShHHK_7DwyDmYYZkCHXmrF0NKtJDY0aSYcEjisP95A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 10:18:11AM -0800, David Decotigny wrote:
> Thank you, Josh,
> 
> A few comments below, and the revised version shortly.

Responses below.

> On Thu, Dec 27, 2012 at 8:04 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> > On Thu, Dec 27, 2012 at 11:24:34AM -0800, David Decotigny wrote:
> >> In some cases, free_irq_cpu_rmap() is called while holding a lock
> >> (eg. rtnl). This can lead to deadlocks, because it invokes
> >> flush_scheduled_work() which ends up waiting for whole system
> >> workqueue to flush, but some pending works might try to acquire the
> >> lock we are already holding.
> >>
> >> This commit uses reference-counting to replace
> >> irq_run_affinity_notifiers(). It also removes
> >> irq_run_affinity_notifiers() altogether.
> >>
> >> Signed-off-by: David Decotigny <decot@googlers.com>
> >
> > A couple of comments below; with those addressed,
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> >
> >> --- a/lib/cpu_rmap.c
> >> +++ b/lib/cpu_rmap.c
> >> @@ -230,16 +256,23 @@ irq_cpu_rmap_notify(struct irq_affinity_notify *notify, const cpumask_t *mask)
> >>               pr_warning("irq_cpu_rmap_notify: update failed: %d\n", rc);
> >>  }
> >>
> >> +/**
> >> + * irq_cpu_rmap_release - reclaiming callback for IRQ subsystem
> >> + * @ref: kref to struct irq_affinity_notify passed by irq/manage.c
> >> + */
> >>  static void irq_cpu_rmap_release(struct kref *ref)
> >>  {
> >>       struct irq_glue *glue =
> >>               container_of(ref, struct irq_glue, notify.kref);
> >> +     struct cpu_rmap *rmap = glue->rmap;
> >> +
> >>       kfree(glue);
> >> +     kref_put(&rmap->refcount, reclaim_cpu_rmap);
> >
> > Likewise, but also, why not call free_cpu_rmap(glue->rmap) before
> > kfree(glue) so you don't need the local copy?
> 
> I prefer to keep this kref_put here. I believe that calling something
> named "free_cpu_rmap" here might be misleading. It's code sharing vs.
> what we actually need to do, even though both are equivalent... for
> now.

If calling something named free_cpu_rmap feels wrong here, perhaps you
should call it cpu_rmap_put or cpu_rmap_unref or similar instead, since
it doesn't actually free unless the refcount goes to zero.  Then you
could have irq_cpu_rmap_release calling cpu_rmap_put, which feels more
natural.  But in any case, I think you should avoid having multiple
instances of the full call to kref_put on a cpu_rmap.

> For the order, it was deliberate, to have some kind of symmetry with
> kfree/kref_put in the error path we have in next function
> (irq_cpu_rmap_add). I reversed the order in that next function to
> avoid this unneeded local variable here. New ordering makes more sense
> anyways.

Ah, I see; makes sense to me.

> >>  }
> >>
> >>  /**
> >>   * irq_cpu_rmap_add - add an IRQ to a CPU affinity reverse-map
> >> - * @rmap: The reverse-map
> >> + * @rmap: The per-IRQ reverse-map
> >>   * @irq: The IRQ number
> >>   *
> >>   * This adds an IRQ affinity notifier that will update the reverse-map
> >> @@ -259,9 +292,12 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
> >>       glue->notify.release = irq_cpu_rmap_release;
> >>       glue->rmap = rmap;
> >>       glue->index = cpu_rmap_add(rmap, glue);
> >> +     kref_get(&rmap->refcount);
> >>       rc = irq_set_affinity_notifier(irq, &glue->notify);
> >> -     if (rc)
> >> +     if (rc) {
> >>               kfree(glue);
> >> +             kref_put(&rmap->refcount, reclaim_cpu_rmap);
> >
> > Likewise.
> 
> I prefer to leave the explicit kref_put here too.

In this case, for symmetry with kref_get?

Would it help to add a cpu_rmap_get, along with cpu_rmap_put?

static inline struct cpu_rmap *cpu_rmap_get(struct cpu_rmap *rmap)
{
    kref_get(&rmap->refcount);
    return rmap;
}

...
    glue->rmap = cpu_rmap_get(rmap);
...

> Next version soon, after some re-testing.

Thanks.

- Josh Triplett
