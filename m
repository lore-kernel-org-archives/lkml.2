Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab0HDC4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:56:49 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:39586 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932258Ab0HDCwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:52:10 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: NLeSSb8VM1nKcJPSd6FxbHkKftQK0h966WVIAPWtFMzpY7b
 1tA82gtfjF66jHz70uu5g5hqy42rSwamnwNptR1vupBuTGZGWyMzq1TNpMeI
 3om2SLHYi.naDQccAuOQq0atK_rs95EY5kJ0vZoWrwRMQ7S513IZB35zFkKw
 Sq9zDM7.Ca39JTBKff_aEideJxND_YF8.YDcL6ufDLuA27uK8BcAHjmQiVDd
 TwRtxICG0d8.ZiInm8gs5DGKrv9rAOW9.FhSVRYpOI4lXscEhWEz_7_19pHO
 5GBgwCQ--
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20100804024529.634058590@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 Aug 2010 21:45:24 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q3 10/23] slub: Allow removal of slab caches during boot V2
References: <20100804024514.139976032@linux.com>
Content-Disposition: inline; filename=slub_sysfs_remove_during_boot
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serialize kmem_cache_create and kmem_cache_destroy using the slub_lock. Only
possible after the use of the slub_lock during dynamic dma creation has been
removed.

Then make sure that the setup of the slab sysfs entries does not race
with kmem_cache_create and kmem_cache destroy.

If a slab cache is removed before we have setup sysfs then simply skip over
the sysfs handling.

V1->V2:
- Do proper synchronization to address race conditions

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-27 22:51:41.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-27 22:51:43.000000000 -0500
@@ -2482,7 +2482,6 @@ void kmem_cache_destroy(struct kmem_cach
 	s->refcount--;
 	if (!s->refcount) {
 		list_del(&s->list);
-		up_write(&slub_lock);
 		if (kmem_cache_close(s)) {
 			printk(KERN_ERR "SLUB %s: %s called for cache that "
 				"still has objects.\n", s->name, __func__);
@@ -2491,8 +2490,8 @@ void kmem_cache_destroy(struct kmem_cach
 		if (s->flags & SLAB_DESTROY_BY_RCU)
 			rcu_barrier();
 		sysfs_slab_remove(s);
-	} else
-		up_write(&slub_lock);
+	}
+	up_write(&slub_lock);
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
@@ -3147,14 +3146,12 @@ struct kmem_cache *kmem_cache_create(con
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
 
@@ -3163,14 +3160,12 @@ struct kmem_cache *kmem_cache_create(con
 		if (kmem_cache_open(s, name,
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
@@ -4418,6 +4413,13 @@ static int sysfs_slab_add(struct kmem_ca
 
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
@@ -4463,8 +4465,11 @@ static int __init slab_sysfs_init(void)
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
@@ -4489,6 +4494,7 @@ static int __init slab_sysfs_init(void)
 		kfree(al);
 	}
 
+	up_write(&slub_lock);
 	resiliency_test();
 	return 0;
 }

