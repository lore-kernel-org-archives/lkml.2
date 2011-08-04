Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab1HDIf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:35:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:48618 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab1HDIfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:35:48 -0400
Date: Thu, 4 Aug 2011 08:35:15 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-83835b3d9aec8e9f666d8223d8a386814f756266@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, penberg@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, sebastian@breakpoint.cc, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, penberg@kernel.org,
        tglx@linutronix.de, sebastian@breakpoint.cc, mingo@elte.hu
In-Reply-To: <1311341165.27400.58.camel@twins>
References: <1311341165.27400.58.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] slab, lockdep: Annotate slab -> rcu -> debug_object -> slab
Git-Commit-ID: 83835b3d9aec8e9f666d8223d8a386814f756266
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Aug 2011 08:35:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83835b3d9aec8e9f666d8223d8a386814f756266
Gitweb:     http://git.kernel.org/tip/83835b3d9aec8e9f666d8223d8a386814f756266
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 22 Jul 2011 15:26:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Aug 2011 10:17:54 +0200

slab, lockdep: Annotate slab -> rcu -> debug_object -> slab

Lockdep thinks there's lock recursion through:

	kmem_cache_free()
	  cache_flusharray()
	    spin_lock(&l3->list_lock)  <----------------.
	    free_block()                                |
	      slab_destroy()                            |
		call_rcu()                              |
		  debug_object_activate()               |
		    debug_object_init()                 |
		      __debug_object_init()             |
			kmem_cache_alloc()              |
			  cache_alloc_refill()          |
			    spin_lock(&l3->list_lock) --'

Now debug objects doesn't use SLAB_DESTROY_BY_RCU and hence there is no
actual possibility of recursing. Luckily debug objects marks it slab
with SLAB_DEBUG_OBJECTS so we can identify the thing.

Mark all SLAB_DEBUG_OBJECTS (all one!) slab caches with a special
lockdep key so that lockdep sees its a different cachep.

Also add a WARN on trying to create a SLAB_DESTROY_BY_RCU |
SLAB_DEBUG_OBJECTS cache, to avoid possible future trouble.

Reported-and-tested-by: Sebastian Siewior <sebastian@breakpoint.cc>
[ fixes to the initial patch ]
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1311341165.27400.58.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/slab.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 68 insertions(+), 18 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 9594740..0703578 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -622,6 +622,51 @@ int slab_is_available(void)
 static struct lock_class_key on_slab_l3_key;
 static struct lock_class_key on_slab_alc_key;
 
+static struct lock_class_key debugobj_l3_key;
+static struct lock_class_key debugobj_alc_key;
+
+static void slab_set_lock_classes(struct kmem_cache *cachep,
+		struct lock_class_key *l3_key, struct lock_class_key *alc_key,
+		int q)
+{
+	struct array_cache **alc;
+	struct kmem_list3 *l3;
+	int r;
+
+	l3 = cachep->nodelists[q];
+	if (!l3)
+		return;
+
+	lockdep_set_class(&l3->list_lock, l3_key);
+	alc = l3->alien;
+	/*
+	 * FIXME: This check for BAD_ALIEN_MAGIC
+	 * should go away when common slab code is taught to
+	 * work even without alien caches.
+	 * Currently, non NUMA code returns BAD_ALIEN_MAGIC
+	 * for alloc_alien_cache,
+	 */
+	if (!alc || (unsigned long)alc == BAD_ALIEN_MAGIC)
+		return;
+	for_each_node(r) {
+		if (alc[r])
+			lockdep_set_class(&alc[r]->lock, alc_key);
+	}
+}
+
+static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep, int node)
+{
+	slab_set_lock_classes(cachep, &debugobj_l3_key, &debugobj_alc_key, node);
+}
+
+static void slab_set_debugobj_lock_classes(struct kmem_cache *cachep)
+{
+	int node;
+
+	for_each_online_node(node)
+		slab_set_debugobj_lock_classes_node(cachep, node);
+}
+
 static void init_node_lock_keys(int q)
 {
 	struct cache_sizes *s = malloc_sizes;
@@ -630,29 +675,14 @@ static void init_node_lock_keys(int q)
 		return;
 
 	for (s = malloc_sizes; s->cs_size != ULONG_MAX; s++) {
-		struct array_cache **alc;
 		struct kmem_list3 *l3;
-		int r;
 
 		l3 = s->cs_cachep->nodelists[q];
 		if (!l3 || OFF_SLAB(s->cs_cachep))
 			continue;
-		lockdep_set_class(&l3->list_lock, &on_slab_l3_key);
-		alc = l3->alien;
-		/*
-		 * FIXME: This check for BAD_ALIEN_MAGIC
-		 * should go away when common slab code is taught to
-		 * work even without alien caches.
-		 * Currently, non NUMA code returns BAD_ALIEN_MAGIC
-		 * for alloc_alien_cache,
-		 */
-		if (!alc || (unsigned long)alc == BAD_ALIEN_MAGIC)
-			continue;
-		for_each_node(r) {
-			if (alc[r])
-				lockdep_set_class(&alc[r]->lock,
-					&on_slab_alc_key);
-		}
+
+		slab_set_lock_classes(s->cs_cachep, &on_slab_l3_key,
+				&on_slab_alc_key, q);
 	}
 }
 
@@ -671,6 +701,14 @@ static void init_node_lock_keys(int q)
 static inline void init_lock_keys(void)
 {
 }
+
+static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep, int node)
+{
+}
+
+static void slab_set_debugobj_lock_classes(struct kmem_cache *cachep)
+{
+}
 #endif
 
 /*
@@ -1264,6 +1302,8 @@ static int __cpuinit cpuup_prepare(long cpu)
 		spin_unlock_irq(&l3->list_lock);
 		kfree(shared);
 		free_alien_cache(alien);
+		if (cachep->flags & SLAB_DEBUG_OBJECTS)
+			slab_set_debugobj_lock_classes_node(cachep, node);
 	}
 	init_node_lock_keys(node);
 
@@ -2426,6 +2466,16 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 		goto oops;
 	}
 
+	if (flags & SLAB_DEBUG_OBJECTS) {
+		/*
+		 * Would deadlock through slab_destroy()->call_rcu()->
+		 * debug_object_activate()->kmem_cache_alloc().
+		 */
+		WARN_ON_ONCE(flags & SLAB_DESTROY_BY_RCU);
+
+		slab_set_debugobj_lock_classes(cachep);
+	}
+
 	/* cache setup completed, link it into the list */
 	list_add(&cachep->next, &cache_chain);
 oops:
