Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2KGJWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:22:40 -0500
Received: from mx2.parallels.com ([64.131.90.16]:55103 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab2KGJWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:22:37 -0500
Message-ID: <509A2849.9090509@parallels.com>
Date: Wed, 7 Nov 2012 10:22:17 +0100
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v6 25/29] memcg/sl[au]b: shrink dead caches
References: <1351771665-11076-1-git-send-email-glommer@parallels.com> <1351771665-11076-26-git-send-email-glommer@parallels.com> <20121105164813.2eba5ecb.akpm@linux-foundation.org> <509A0A04.2030503@parallels.com> <20121106231627.3610c908.akpm@linux-foundation.org>
In-Reply-To: <20121106231627.3610c908.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
	boundary="------------090100090506080805050303"
X-Originating-IP: [88.2.50.55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------090100090506080805050303
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 11/07/2012 08:16 AM, Andrew Morton wrote:
> On Wed, 7 Nov 2012 08:13:08 +0100 Glauber Costa <glommer@parallels.com> wrote:
> 
>> On 11/06/2012 01:48 AM, Andrew Morton wrote:
>>> On Thu,  1 Nov 2012 16:07:41 +0400
>>> Glauber Costa <glommer@parallels.com> wrote:
>>>
>>>> This means that when we destroy a memcg cache that happened to be empty,
>>>> those caches may take a lot of time to go away: removing the memcg
>>>> reference won't destroy them - because there are pending references, and
>>>> the empty pages will stay there, until a shrinker is called upon for any
>>>> reason.
>>>>
>>>> In this patch, we will call kmem_cache_shrink for all dead caches that
>>>> cannot be destroyed because of remaining pages. After shrinking, it is
>>>> possible that it could be freed. If this is not the case, we'll schedule
>>>> a lazy worker to keep trying.
>>>
>>> This patch is really quite nasty.  We poll the cache once per minute
>>> trying to shrink then free it?  a) it gives rise to concerns that there
>>> will be scenarios where the system could suffer unlimited memory windup
>>> but mainly b) it's just lame.
>>>
>>> The kernel doesn't do this sort of thing.  The kernel tries to be
>>> precise: in a situation like this we keep track of the number of
>>> outstanding objects and when that falls to zero, we free their
>>> container synchronously.  If those objects are normally left floating
>>> around in an allocated but reclaimable state then we can address that
>>> by synchronously freeing them if their container has been destroyed.
>>>
>>> Or something like that.  If it's something else then fine, but not this.
>>>
>>> What do we need to do to fix this?
>>>
>> The original patch had a unlikely() test in the free path, conditional
>> on whether or not the cache is dead, that would then call this is the
>> cache would now be empty.
>>
>> I got several requests to remove it and change it to something like
>> this, because that is a fast path (I myself think an unlikely branch is
>> not that bad)
>>
>> If you think such a test is acceptable, I can bring it back and argue in
>> the basis of "akpm made me do it!". But meanwhile I will give this extra
>> though to see if there is any alternative way I can do it...
> 
> OK, thanks, please do take a look at it.
> 
> I'd be interested in seeing the old version of the patch which had this
> test-n-branch.  Perhaps there's some trick we can pull to lessen its cost.
> 
Attached.

This is the last version that used it (well, I believe it is). There is
other unrelated things in this patch, that I got rid of. Look for
kmem_cache_verify_dead().

In a summary, all calls to the free function would as a last step do:
kmem_cache_verify_dead() that would either be an empty placeholder, or:

+static inline void kmem_cache_verify_dead(struct kmem_cache *s)
+{
+       if (unlikely(s->memcg_params.dead))
+               schedule_work(&s->memcg_params.cache_shrinker);
+}


cache_shrinker got changed to the destroy worker. So if we are freeing
an object from a cache that is dead, we try to schedule a worker that
will eventually call kmem_cache_srhink(), and hopefully
kmem_cache_destroy() - if last object.


--------------090100090506080805050303
Content-Type: text/x-patch;
	name="0015-memcg-sl-au-b-shrink-dead-caches.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0015-memcg-sl-au-b-shrink-dead-caches.patch"

>From c99404a760fa69e8ccda0ff4b2636c6abd1ac990 Mon Sep 17 00:00:00 2001
From: Glauber Costa <glommer@parallels.com>
Date: Thu, 3 May 2012 13:33:03 -0300
Subject: [PATCH v3 15/16] memcg/sl[au]b: shrink dead caches

In the slub allocator, when the last object of a page goes away, we
don't necessarily free it - there is not necessarily a test for empty
page in any slab_free path.

This means that when we destroy a memcg cache that happened to be empty,
those caches may take a lot of time to go away: removing the memcg
reference won't destroy them - because there are pending references, and
the empty pages will stay there, until a shrinker is called upon for any
reason.

This patch marks all memcg caches as dead. kmem_cache_shrink is called
for the ones who are not yet dead - this will force internal cache
reorganization, and then all references to empty pages will be removed.

An unlikely branch is used to make sure this case does not affect
performance in the usual slab_free path.

The slab allocator has a time based reaper that would eventually get rid
of the objects, but we can also call it explicitly, since dead caches
are not a likely event.

[ v2: also call verify_dead for the slab ]

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Michal Hocko <mhocko@suse.cz>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
CC: Suleiman Souhlal <suleiman@google.com>
---
 include/linux/slab.h |  3 +++
 mm/memcontrol.c      | 44 +++++++++++++++++++++++++++++++++++++++++++-
 mm/slab.c            |  2 ++
 mm/slab.h            | 10 ++++++++++
 mm/slub.c            |  1 +
 5 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 9badb8c..765e12c 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -182,6 +182,8 @@ unsigned int kmem_cache_size(struct kmem_cache *);
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
+#include <linux/workqueue.h>
+
 struct mem_cgroup_cache_params {
 	struct mem_cgroup *memcg;
 	struct kmem_cache *parent;
@@ -190,6 +192,7 @@ struct mem_cgroup_cache_params {
 	atomic_t nr_pages;
 	struct list_head destroyed_list; /* Used when deleting memcg cache */
 	struct list_head sibling_list;
+	struct work_struct cache_shrinker;
 };
 #endif
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index da38652..c0cf564 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -578,7 +578,7 @@ static char *memcg_cache_name(struct mem_cgroup *memcg, struct kmem_cache *cache
 
 	BUG_ON(dentry == NULL);
 
-	name = kasprintf(GFP_KERNEL, "%s(%d:%s)",
+	name = kasprintf(GFP_KERNEL, "%s(%d:%s)dead",
 	    cachep->name, css_id(&memcg->css), dentry->d_name.name);
 
 	return name;
@@ -739,12 +739,25 @@ static void disarm_kmem_keys(struct mem_cgroup *memcg)
 	WARN_ON(res_counter_read_u64(&memcg->kmem, RES_USAGE) != 0);
 }
 
+static void cache_shrinker_work_func(struct work_struct *work)
+{
+	struct mem_cgroup_cache_params *params;
+	struct kmem_cache *cachep;
+
+	params = container_of(work, struct mem_cgroup_cache_params,
+			      cache_shrinker);
+	cachep = container_of(params, struct kmem_cache, memcg_params);
+
+	kmem_cache_shrink(cachep);
+}
+
 static DEFINE_MUTEX(memcg_cache_mutex);
 static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 						  struct kmem_cache *cachep)
 {
 	struct kmem_cache *new_cachep;
 	int idx;
+	char *name;
 
 	BUG_ON(!memcg_can_account_kmem(memcg));
 
@@ -764,10 +777,21 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 		goto out;
 	}
 
+	/*
+	 * Because the cache is expected to duplicate the string,
+	 * we must make sure it has opportunity to copy its full
+	 * name. Only now we can remove the dead part from it
+	 */
+	name = (char *)new_cachep->name;
+	if (name)
+		name[strlen(name) - 4] = '\0';
+
 	mem_cgroup_get(memcg);
 	memcg->slabs[idx] = new_cachep;
 	new_cachep->memcg_params.memcg = memcg;
 	atomic_set(&new_cachep->memcg_params.nr_pages , 0);
+	INIT_WORK(&new_cachep->memcg_params.cache_shrinker,
+		  cache_shrinker_work_func);
 out:
 	mutex_unlock(&memcg_cache_mutex);
 	return new_cachep;
@@ -790,6 +814,21 @@ static void kmem_cache_destroy_work_func(struct work_struct *w)
 	struct mem_cgroup_cache_params *p, *tmp;
 	unsigned long flags;
 	LIST_HEAD(del_unlocked);
+	LIST_HEAD(shrinkers);
+
+	spin_lock_irqsave(&cache_queue_lock, flags);
+	list_for_each_entry_safe(p, tmp, &destroyed_caches, destroyed_list) {
+		cachep = container_of(p, struct kmem_cache, memcg_params);
+		if (atomic_read(&cachep->memcg_params.nr_pages) != 0)
+			list_move(&cachep->memcg_params.destroyed_list, &shrinkers);
+	}
+	spin_unlock_irqrestore(&cache_queue_lock, flags);
+
+	list_for_each_entry_safe(p, tmp, &shrinkers, destroyed_list) {
+		cachep = container_of(p, struct kmem_cache, memcg_params);
+		list_del(&cachep->memcg_params.destroyed_list);
+		kmem_cache_shrink(cachep);
+	}
 
 	spin_lock_irqsave(&cache_queue_lock, flags);
 	list_for_each_entry_safe(p, tmp, &destroyed_caches, destroyed_list) {
@@ -867,11 +906,14 @@ static void mem_cgroup_destroy_all_caches(struct mem_cgroup *memcg)
 
 	spin_lock_irqsave(&cache_queue_lock, flags);
 	for (i = 0; i < MAX_KMEM_CACHE_TYPES; i++) {
+		char *name;
 		cachep = memcg->slabs[i];
 		if (!cachep)
 			continue;
 
 		cachep->memcg_params.dead = true;
+		name = (char *)cachep->name;
+		name[strlen(name)] = 'd';
 		__mem_cgroup_destroy_cache(cachep);
 	}
 	spin_unlock_irqrestore(&cache_queue_lock, flags);
diff --git a/mm/slab.c b/mm/slab.c
index bd9928f..6cb4abf 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3785,6 +3785,8 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp,
 	}
 
 	ac_put_obj(cachep, ac, objp);
+
+	kmem_cache_verify_dead(cachep);
 }
 
 /**
diff --git a/mm/slab.h b/mm/slab.h
index 6024ad1..d21b982 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -80,6 +80,12 @@ static inline bool slab_equal_or_parent(struct kmem_cache *s,
 {
 	return (p == s) || (p == s->memcg_params.parent);
 }
+
+static inline void kmem_cache_verify_dead(struct kmem_cache *s)
+{
+	if (unlikely(s->memcg_params.dead))
+		schedule_work(&s->memcg_params.cache_shrinker);
+}
 #else
 static inline bool cache_match_memcg(struct kmem_cache *cachep,
 				     struct mem_cgroup *memcg)
@@ -100,5 +106,9 @@ static inline bool slab_equal_or_parent(struct kmem_cache *s,
 {
 	return true;
 }
+
+static inline void kmem_cache_verify_dead(struct kmem_cache *s)
+{
+}
 #endif
 #endif
diff --git a/mm/slub.c b/mm/slub.c
index 0b68d15..9d79216 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2602,6 +2602,7 @@ redo:
 	} else
 		__slab_free(s, page, x, addr);
 
+	kmem_cache_verify_dead(s);
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
-- 
1.7.11.4


--------------090100090506080805050303--
