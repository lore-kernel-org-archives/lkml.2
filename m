Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2JWKwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:52:51 -0400
Received: from mx2.parallels.com ([64.131.90.16]:36330 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab2JWKwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:52:49 -0400
Message-ID: <508676FA.4000107@parallels.com>
Date: Tue, 23 Oct 2012 14:52:42 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: JoonSoo Kim <js1304@gmail.com>
CC: Christoph Lameter <cl@linux.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/2] slab: move kmem_cache_free to common code
References: <1350914737-4097-1-git-send-email-glommer@parallels.com> <1350914737-4097-3-git-send-email-glommer@parallels.com> <0000013a88eff593-50da3bb8-3294-41db-9c32-4e890ef6940a-000000@email.amazonses.com> <508561E0.5000406@parallels.com> <CAAmzW4PJkDbLJBKZ1zPNDw+dHPcgzX_25tMw3rWoX0ybpXACSQ@mail.gmail.com> <50865024.60309@parallels.com>
In-Reply-To: <50865024.60309@parallels.com>
Content-Type: multipart/mixed;
	boundary="------------030003060004030207070807"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------030003060004030207070807
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 10/23/2012 12:07 PM, Glauber Costa wrote:
> On 10/23/2012 04:48 AM, JoonSoo Kim wrote:
>> Hello, Glauber.
>>
>> 2012/10/23 Glauber Costa <glommer@parallels.com>:
>>> On 10/22/2012 06:45 PM, Christoph Lameter wrote:
>>>> On Mon, 22 Oct 2012, Glauber Costa wrote:
>>>>
>>>>> + * kmem_cache_free - Deallocate an object
>>>>> + * @cachep: The cache the allocation was from.
>>>>> + * @objp: The previously allocated object.
>>>>> + *
>>>>> + * Free an object which was previously allocated from this
>>>>> + * cache.
>>>>> + */
>>>>> +void kmem_cache_free(struct kmem_cache *s, void *x)
>>>>> +{
>>>>> +    __kmem_cache_free(s, x);
>>>>> +    trace_kmem_cache_free(_RET_IP_, x);
>>>>> +}
>>>>> +EXPORT_SYMBOL(kmem_cache_free);
>>>>> +
>>>>
>>>> This results in an additional indirection if tracing is off. Wonder if
>>>> there is a performance impact?
>>>>
>>> if tracing is on, you mean?
>>>
>>> Tracing already incurs overhead, not sure how much a function call would
>>> add to the tracing overhead.
>>>
>>> I would not be concerned with this, but I can measure, if you have any
>>> specific workload in mind.
>>
>> With this patch, kmem_cache_free() invokes __kmem_cache_free(),
>> that is, it add one more "call instruction" than before.
>>
>> I think that Christoph's comment means above fact.
> 
> Ah, this. Ok, I got fooled by his mention to tracing.
> 
> I do agree, but since freeing is ultimately dependent on the allocator
> layout, I don't see a clean way of doing this without dropping tears of
> sorrow around. The calls in slub/slab/slob would have to be somehow
> inlined. Hum... maybe it is possible to do it from
> include/linux/sl*b_def.h...
> 
> Let me give it a try and see what I can come up with.
> 

Ok.

I am attaching a PoC for this for your appreciation. This gets quite
ugly, but it's the way I found without including sl{a,u,o}b.c directly -
which would be even worse.

But I guess if we really want to avoid the cost of a function call,
there has to be a tradeoff...

For the record, the proposed usage for this would be:

1) Given a (inline) function, defined in mm/slab.h that translates the
cache from its object address (and then sanity checks it against the
cache parameter), translate_cache():

#define KMEM_CACHE_FREE(allocator_fn)                   \
void kmem_cache_free(struct kmem_cache *s, void *x)     \
{                                                       \
        struct kmem_cache *cachep;                      \
        cachep = translate_cache(s, x);                 \
        if (!cachep)                                    \
                return;                                 \
        allocator_fn(cachep, x);                        \
        trace_kmem_cache_free(_RET_IP_, x);             \
}                                                       \
EXPORT_SYMBOL(kmem_cache_free)



--------------030003060004030207070807
Content-Type: text/x-patch;
	name="0001-slab-move-kmem_cache_free-to-common-code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-slab-move-kmem_cache_free-to-common-code.patch"

>From 825f5179174be825f1219e23bdde769ef9febd45 Mon Sep 17 00:00:00 2001
From: Glauber Costa <glommer@parallels.com>
Date: Mon, 22 Oct 2012 15:20:26 +0400
Subject: [PATCH] slab: move kmem_cache_free to common code

In the effort of commonizing the slab allocators, it would be better if
we had a single entry-point for kmem_cache_free. At the same time, the
different layout of the allocators lead to routines that are necessarily
different.

Because we would also want the allocators to be able to free objects in
their fast paths without issuing a call instruction, we will rely on the
pre-processor to aid us.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>
CC: David Rientjes <rientjes@google.com>
---
 mm/slab.c | 15 +++------------
 mm/slab.h | 26 ++++++++++++++++++++++++++
 mm/slob.c |  6 ++----
 mm/slub.c |  6 ++----
 4 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 98b3460..bceffcc 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3903,15 +3903,8 @@ void *__kmalloc(size_t size, gfp_t flags)
 EXPORT_SYMBOL(__kmalloc);
 #endif
 
-/**
- * kmem_cache_free - Deallocate an object
- * @cachep: The cache the allocation was from.
- * @objp: The previously allocated object.
- *
- * Free an object which was previously allocated from this
- * cache.
- */
-void kmem_cache_free(struct kmem_cache *cachep, void *objp)
+static __always_inline void
+__kmem_cache_free(struct kmem_cache *cachep, void *objp)
 {
 	unsigned long flags;
 
@@ -3921,10 +3914,8 @@ void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 		debug_check_no_obj_freed(objp, cachep->object_size);
 	__cache_free(cachep, objp, __builtin_return_address(0));
 	local_irq_restore(flags);
-
-	trace_kmem_cache_free(_RET_IP_, objp);
 }
-EXPORT_SYMBOL(kmem_cache_free);
+KMEM_CACHE_FREE(__kmem_cache_free);
 
 /**
  * kfree - free previously allocated memory
diff --git a/mm/slab.h b/mm/slab.h
index 66a62d3..32063f8 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -92,4 +92,30 @@ void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo);
 void slabinfo_show_stats(struct seq_file *m, struct kmem_cache *s);
 ssize_t slabinfo_write(struct file *file, const char __user *buffer,
 		       size_t count, loff_t *ppos);
+
+/*
+ * What goes below for kmem_cache_free is not pretty. But because this
+ * is an extremely hot path, we would like to avoid function calls as
+ * much as we can.
+ *
+ * As ugly as it is, this is a way to guarantee that different allocators,
+ * with different layouts, and therefore, different free functions, can
+ * still live in different files and inline the whole of kmem_cache_free.
+ */
+/**
+ * kmem_cache_free - Deallocate an object
+ * @cachep: The cache the allocation was from.
+ * @objp: The previously allocated object.
+ *
+ * Free an object which was previously allocated from this
+ * cache.
+ *
+ */
+#define KMEM_CACHE_FREE(allocator_fn)			\
+void kmem_cache_free(struct kmem_cache *s, void *x)	\
+{							\
+	allocator_fn(s, x);				\
+	trace_kmem_cache_free(_RET_IP_, x);		\
+}							\
+EXPORT_SYMBOL(kmem_cache_free)
 #endif
diff --git a/mm/slob.c b/mm/slob.c
index 3edfeaa..1580371 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -571,7 +571,7 @@ static void kmem_rcu_free(struct rcu_head *head)
 	__kmem_cache_free(b, slob_rcu->size);
 }
 
-void kmem_cache_free(struct kmem_cache *c, void *b)
+static __always_inline void do_kmem_cache_free(struct kmem_cache *c, void *b)
 {
 	kmemleak_free_recursive(b, c->flags);
 	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
@@ -582,10 +582,8 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 	} else {
 		__kmem_cache_free(b, c->size);
 	}
-
-	trace_kmem_cache_free(_RET_IP_, b);
 }
-EXPORT_SYMBOL(kmem_cache_free);
+KMEM_CACHE_FREE(do_kmem_cache_free);
 
 unsigned int kmem_cache_size(struct kmem_cache *c)
 {
diff --git a/mm/slub.c b/mm/slub.c
index 259bc2c..7dd41d7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2606,7 +2606,7 @@ redo:
 
 }
 
-void kmem_cache_free(struct kmem_cache *s, void *x)
+static __always_inline void __kmem_cache_free(struct kmem_cache *s, void *x)
 {
 	struct page *page;
 
@@ -2620,10 +2620,8 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 	}
 
 	slab_free(s, page, x, _RET_IP_);
-
-	trace_kmem_cache_free(_RET_IP_, x);
 }
-EXPORT_SYMBOL(kmem_cache_free);
+KMEM_CACHE_FREE(__kmem_cache_free);
 
 /*
  * Object placement in a slab is made very easy because we always start at
-- 
1.7.11.7


--------------030003060004030207070807--
