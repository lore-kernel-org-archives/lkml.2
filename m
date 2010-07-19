Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936472Ab0GSQnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 12:43:03 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:35559 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936440Ab0GSQnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 12:43:00 -0400
Date: Mon, 19 Jul 2010 11:39:11 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q2 07/19] slub: Allow removal of slab caches during boot
In-Reply-To: <1279498030.10390.1760.camel@pasglop>
Message-ID: <alpine.DEB.2.00.1007191058220.29361@router.home>
References: <20100709190706.938177313@quilx.com>  <20100709190853.770833931@quilx.com>  <alpine.DEB.2.00.1007141647340.29110@chino.kir.corp.google.com> <1279498030.10390.1760.camel@pasglop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010, Benjamin Herrenschmidt wrote:

> On Wed, 2010-07-14 at 16:48 -0700, David Rientjes wrote:
> > On Fri, 9 Jul 2010, Christoph Lameter wrote:
> >
> > > If a slab cache is removed before we have setup sysfs then simply skip over
> > > the sysfs handling.
> > >
> > > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > > Cc: Roland Dreier <rdreier@cisco.com>
> > > Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> >
> > Acked-by: David Rientjes <rientjes@google.com>
> >
> > I missed this case earlier because I didn't consider slab caches being
> > created and destroyed prior to slab_state == SYSFS, sorry!
>
> Ok so I may be a bit sleepy or something but I still fail to see how
> this whole thing isn't totally racy...
>
> AFAIK. By the time we switch the slab state, we -do- have all CPUs up
> and can race happily between creating slab caches and creating the sysfs
> files...

If kmem_cache_init_late() is called after all other processors are up then
we need to serialize the activities. But we cannot do that since the
slub_lock is taken during kmalloc() for dynamic dma creation (lockdep
will complain although we never use dma caches for sysfs....).

After removal of dynamic dma creation we can take the lock for all of slab
creation and removal.

Like in the following patch:

Subject: slub: Allow removal of slab caches during boot

Serialize kmem_cache_create and kmem_cache_destroy using the slub_lock. Only
possible after the use of the slub_lock during dynamic dma creation has been
removed.

Then make sure that the setup of the slab sysfs entries does not race
with kmem_cache_create and kmem_cache destroy.

If a slab cache is removed before we have setup sysfs then simply skip over
the sysfs handling.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-19 11:02:15.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-19 11:33:32.000000000 -0500
@@ -2490,7 +2490,6 @@ void kmem_cache_destroy(struct kmem_cach
 	s->refcount--;
 	if (!s->refcount) {
 		list_del(&s->list);
-		up_write(&slub_lock);
 		if (kmem_cache_close(s)) {
 			printk(KERN_ERR "SLUB %s: %s called for cache that "
 				"still has objects.\n", s->name, __func__);
@@ -2499,8 +2498,8 @@ void kmem_cache_destroy(struct kmem_cach
 		if (s->flags & SLAB_DESTROY_BY_RCU)
 			rcu_barrier();
 		sysfs_slab_remove(s);
-	} else
-		up_write(&slub_lock);
+	}
+	up_write(&slub_lock);
 }
 EXPORT_SYMBOL(kmem_cache_destroy);

@@ -3226,14 +3225,12 @@ struct kmem_cache *kmem_cache_create(con
 		 */
 		s->objsize = max(s->objsize, (int)size);
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
-		up_write(&slub_lock);

 		if (sysfs_slab_alias(s, name)) {
-			down_write(&slub_lock);
 			s->refcount--;
-			up_write(&slub_lock);
 			goto err;
 		}
+		up_write(&slub_lock);
 		return s;
 	}

@@ -3242,14 +3239,12 @@ struct kmem_cache *kmem_cache_create(con
 		if (kmem_cache_open(s, GFP_KERNEL, name,
 				size, align, flags, ctor)) {
 			list_add(&s->list, &slab_caches);
-			up_write(&slub_lock);
 			if (sysfs_slab_add(s)) {
-				down_write(&slub_lock);
 				list_del(&s->list);
-				up_write(&slub_lock);
 				kfree(s);
 				goto err;
 			}
+			up_write(&slub_lock);
 			return s;
 		}
 		kfree(s);
@@ -4507,6 +4502,13 @@ static int sysfs_slab_add(struct kmem_ca

 static void sysfs_slab_remove(struct kmem_cache *s)
 {
+	if (slab_state < SYSFS)
+		/*
+		 * Sysfs has not been setup yet so no need to remove the
+		 * cache from sysfs.
+		 */
+		return;
+
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
 	kobject_put(&s->kobj);
@@ -4552,8 +4554,11 @@ static int __init slab_sysfs_init(void)
 	struct kmem_cache *s;
 	int err;

+	down_write(&slub_lock);
+
 	slab_kset = kset_create_and_add("slab", &slab_uevent_ops, kernel_kobj);
 	if (!slab_kset) {
+		up_write(&slub_lock);
 		printk(KERN_ERR "Cannot register slab subsystem.\n");
 		return -ENOSYS;
 	}
@@ -4578,6 +4583,7 @@ static int __init slab_sysfs_init(void)
 		kfree(al);
 	}

+	up_write(&slub_lock);
 	resiliency_test();
 	return 0;
 }


