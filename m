Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab2GFHzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:55:00 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:58987 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2GFHy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:54:58 -0400
Message-ID: <1341561286.24895.9.camel@ThinkPad-T420>
Subject: [PATCH SLAB 1/2 v3] duplicate the cache name in SLUB's saved_alias
 list, SLAB, and SLOB
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>
Date: Fri, 06 Jul 2012 15:54:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12070522-3568-0000-0000-00000217F26B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB duplicates the cache name string passed into kmem_cache_create().
However if the cache could be merged to others during early boot, the
name pointer is saved in saved_alias list, and the string needs to be
kept valid before slab_sysfs_init() is finished. With this patch, the
name string (if kmalloced) could be kfreed after calling
kmem_cache_create().

Some more details:

kmem_cache_create() checks whether it is mergeable before creating one.
If not mergeable, the name is duplicated: n = kstrdup(name, GFP_KERNEL);

If it is mergeable, it calls sysfs_slab_alias(). If the sysfs is ready
(slab_state == SYSFS), then the name is duplicated (or dropped if no
SYSFS support) in sysfs_create_link() for use.

For the above cases, we could safely kfree the name string after calling
cache create. 

However, during early boot, before sysfs is ready (slab_state < SYSFS),
the sysfs_slab_alias() saves the pointer of name in the alias_list.
Those entries in the list are added to sysfs later in slab_sysfs_init()
to set up the sysfs stuff, and we need keep the name string passed in
valid until it finishes. By duplicating the name string here also, we
are able to safely kfree the name string after calling cache create.

v2: removed an unnecessary assignment in v1; some changes in change log,
added more details

v3: changed slab/slot to let them also duplicate the name string, so the
code is not slub-dependent, and in patch 2/2, we could call kfree()
after cache create without #ifdef slub.
    for slab, the name of the sizes caches created before
slab_is_available() is not duplicated, and it is not checked in
kmem_cache_destroy(), as I think these caches won't be destroyed.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 mm/slab.c |   15 ++++++++++++++-
 mm/slob.c |   17 ++++++++++++++---
 mm/slub.c |    7 ++++++-
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index e901a36..87df7d1 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2280,6 +2280,7 @@ kmem_cache_create (const char *name, size_t size,
size_t align,
 	size_t left_over, slab_size, ralign;
 	struct kmem_cache *cachep = NULL, *pc;
 	gfp_t gfp;
+	const char *lname;
 
 	/*
 	 * Sanity checks... these are all serious usage bugs.
@@ -2291,6 +2292,13 @@ kmem_cache_create (const char *name, size_t size,
size_t align,
 		BUG();
 	}
 
+	if (slab_is_available()) {
+		lname = kstrdup(name, GFP_KERNEL);
+		if (!lname)
+			goto oops;
+	} else
+		lname = name;
+
 	/*
 	 * We use cache_chain_mutex to ensure a consistent view of
 	 * cpu_online_mask as well.  Please see cpuup_callback
@@ -2526,7 +2534,7 @@ kmem_cache_create (const char *name, size_t size,
size_t align,
 		BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
 	}
 	cachep->ctor = ctor;
-	cachep->name = name;
+	cachep->name = lname;
 
 	if (setup_cpu_cache(cachep, gfp)) {
 		__kmem_cache_destroy(cachep);
@@ -2550,6 +2558,9 @@ oops:
 	if (!cachep && (flags & SLAB_PANIC))
 		panic("kmem_cache_create(): failed to create slab `%s'\n",
 		      name);
+	if (!cachep && lname)
+		kfree(lname);
+
 	if (slab_is_available()) {
 		mutex_unlock(&cache_chain_mutex);
 		put_online_cpus();
@@ -2752,6 +2763,8 @@ void kmem_cache_destroy(struct kmem_cache *cachep)
 	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU))
 		rcu_barrier();
 
+	/* sizes caches will not be destroyed? */
+	kfree(cachep->name);
 	__kmem_cache_destroy(cachep);
 	mutex_unlock(&cache_chain_mutex);
 	put_online_cpus();
diff --git a/mm/slob.c b/mm/slob.c
index 8105be4..7bea3a3 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -569,13 +569,18 @@ struct kmem_cache {
 struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 	size_t align, unsigned long flags, void (*ctor)(void *))
 {
-	struct kmem_cache *c;
+	struct kmem_cache *c = NULL;
+	const char *lname;
+
+	lname = kstrdup(name, GFP_KERNEL);
+	if (!lname)
+		goto oops;
 
 	c = slob_alloc(sizeof(struct kmem_cache),
 		GFP_KERNEL, ARCH_KMALLOC_MINALIGN, -1);
 
 	if (c) {
-		c->name = name;
+		c->name = lname;
 		c->size = size;
 		if (flags & SLAB_DESTROY_BY_RCU) {
 			/* leave room for rcu footer at the end of object */
@@ -589,9 +594,14 @@ struct kmem_cache *kmem_cache_create(const char
*name, size_t size,
 			c->align = ARCH_SLAB_MINALIGN;
 		if (c->align < align)
 			c->align = align;
-	} else if (flags & SLAB_PANIC)
+	}
+oops:
+	if (!c && (flags & SLAB_PANIC))
 		panic("Cannot create slab cache %s\n", name);
 
+	if (!c && lname)
+		kfree(lname);
+
 	kmemleak_alloc(c, sizeof(struct kmem_cache), 1, GFP_KERNEL);
 	return c;
 }
@@ -602,6 +612,7 @@ void kmem_cache_destroy(struct kmem_cache *c)
 	kmemleak_free(c);
 	if (c->flags & SLAB_DESTROY_BY_RCU)
 		rcu_barrier();
+	kfree(c->name);
 	slob_free(c, sizeof(struct kmem_cache));
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
diff --git a/mm/slub.c b/mm/slub.c
index 8c691fa..ed9f3c5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5372,7 +5372,11 @@ static int sysfs_slab_alias(struct kmem_cache *s,
const char *name)
 		return -ENOMEM;
 
 	al->s = s;
-	al->name = name;
+	al->name = kstrdup(name, GFP_KERNEL);
+	if (!al->name) {
+		kfree(al);
+		return -ENOMEM;
+	}
 	al->next = alias_list;
 	alias_list = al;
 	return 0;
@@ -5409,6 +5413,7 @@ static int __init slab_sysfs_init(void)
 		if (err)
 			printk(KERN_ERR "SLUB: Unable to add boot slab alias"
 					" %s to sysfs\n", s->name);
+		kfree(al->name);
 		kfree(al);
 	}
 
-- 
1.7.1



