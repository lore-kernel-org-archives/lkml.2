Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1CQHHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 03:07:10 -0400
Received: from science.horizon.com ([71.41.210.146]:25529 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751288Ab1CQHHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 03:07:07 -0400
Date: 17 Mar 2011 03:07:05 -0400
Message-ID: <20110317070705.15100.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, penberg@kernel.org
Subject: Re: [PATCH 5/8] mm/slub: Factor out some common code.
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mpm@selenic.com, penberg@cs.helsinki.fi,
        rientjes@google.com
In-Reply-To: <AANLkTikDAEuTcrgo0YcUO40A9x5jaL-d+ZPviCXANe3r@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I certainly don't but I'd still like to ask you to change it to
> 'unsigned long'. That's a Linux kernel idiom and we're not going to
> change the whole kernel.

Damn, and I just prepared the following patch.  Should I, instead, do

--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -62,5 +62,5 @@ struct kmem_cache {
 /* 3) touched by every alloc & free from the backend */
 
-	unsigned int flags;		/* constant flags */
+	unsigned long flags;		/* constant flags */
 	unsigned int num;		/* # of objs per slab */
 
... because the original slab code uses an unsigned int.  To fix it
the other way (for SLAB_ flags only) is a patch like this:

>From 217645dfbb1fd42a451ae27aa1ea2c503ff31ef1 Mon Sep 17 00:00:00 2001
From: George Spelvin <linux@horizon.com>
Date: Wed, 16 Mar 2011 22:36:50 -0400
Subject: [PATCH 01/11] mm: Make SLAB_* flags consistently 32-bit unsigned int.

The type of "unsigned long" is silly for a portable flags field, because
you can't portably use more than 32 bits, but it takes 64 bits on 64-bit
processors.  And 32-bit manipulations are never slower than 64-bit ones.

Also, include/slab_def.h has always used an "unsigned int" flags field.
This just updates the other implementations to do the same.
(EXCEPTION: SLOB structure must match "struct page".)

Signed-off-by: George Spelvin <linux@horizon.com>
---
 include/linux/slab.h     |   38 +++++++++++++++++++-------------------
 include/linux/slub_def.h |    2 +-
 mm/slab.c                |    2 +-
 mm/slob.c                |    5 ++---
 mm/slub.c                |   22 +++++++++++-----------
 5 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index fa90866..0ff4221 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -16,13 +16,13 @@
  * Flags to pass to kmem_cache_create().
  * The ones marked DEBUG are only valid if CONFIG_SLAB_DEBUG is set.
  */
-#define SLAB_DEBUG_FREE		0x00000100UL	/* DEBUG: Perform (expensive) checks on free */
-#define SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
-#define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
-#define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
-#define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
-#define SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store the last owner for bug hunting */
-#define SLAB_PANIC		0x00040000UL	/* Panic if kmem_cache_create() fails */
+#define SLAB_DEBUG_FREE		0x00000100U	/* DEBUG: Perform (expensive) checks on free */
+#define SLAB_RED_ZONE		0x00000400U	/* DEBUG: Red zone objs in a cache */
+#define SLAB_POISON		0x00000800U	/* DEBUG: Poison objects */
+#define SLAB_HWCACHE_ALIGN	0x00002000U	/* Align objs on cache lines */
+#define SLAB_CACHE_DMA		0x00004000U	/* Use GFP_DMA memory */
+#define SLAB_STORE_USER		0x00010000U	/* DEBUG: Store the last owner for bug hunting */
+#define SLAB_PANIC		0x00040000U	/* Panic if kmem_cache_create() fails */
 /*
  * SLAB_DESTROY_BY_RCU - **WARNING** READ THIS!
  *
@@ -51,33 +51,33 @@
  *
  * See also the comment on struct slab_rcu in mm/slab.c.
  */
-#define SLAB_DESTROY_BY_RCU	0x00080000UL	/* Defer freeing slabs to RCU */
-#define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
-#define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
+#define SLAB_DESTROY_BY_RCU	0x00080000U	/* Defer freeing slabs to RCU */
+#define SLAB_MEM_SPREAD		0x00100000U	/* Spread some memory over cpuset */
+#define SLAB_TRACE		0x00200000U	/* Trace allocations and frees */
 
 /* Flag to prevent checks on free */
 #ifdef CONFIG_DEBUG_OBJECTS
-# define SLAB_DEBUG_OBJECTS	0x00400000UL
+# define SLAB_DEBUG_OBJECTS	0x00400000U
 #else
-# define SLAB_DEBUG_OBJECTS	0x00000000UL
+# define SLAB_DEBUG_OBJECTS	0x00000000U
 #endif
 
-#define SLAB_NOLEAKTRACE	0x00800000UL	/* Avoid kmemleak tracing */
+#define SLAB_NOLEAKTRACE	0x00800000U	/* Avoid kmemleak tracing */
 
 /* Don't track use of uninitialized memory */
 #ifdef CONFIG_KMEMCHECK
-# define SLAB_NOTRACK		0x01000000UL
+# define SLAB_NOTRACK		0x01000000U
 #else
-# define SLAB_NOTRACK		0x00000000UL
+# define SLAB_NOTRACK		0x00000000U
 #endif
 #ifdef CONFIG_FAILSLAB
-# define SLAB_FAILSLAB		0x02000000UL	/* Fault injection mark */
+# define SLAB_FAILSLAB		0x02000000U	/* Fault injection mark */
 #else
-# define SLAB_FAILSLAB		0x00000000UL
+# define SLAB_FAILSLAB		0x00000000U
 #endif
 
 /* The following flags affect the page allocator grouping pages by mobility */
-#define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
+#define SLAB_RECLAIM_ACCOUNT	0x00020000U		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
@@ -99,7 +99,7 @@ void __init kmem_cache_init(void);
 int slab_is_available(void);
 
 struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
-			unsigned long,
+			unsigned int,
 			void (*)(void *));
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 8b6e8ae..5ed8408 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -69,7 +69,7 @@ struct kmem_cache_order_objects {
 struct kmem_cache {
 	struct kmem_cache_cpu __percpu *cpu_slab;
 	/* Used for retriving partial slabs etc */
-	unsigned long flags;
+	unsigned int flags;
 	int size;		/* The size of an object including meta data */
 	int objsize;		/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
diff --git a/mm/slab.c b/mm/slab.c
index 37961d1..40e71b2 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2164,7 +2164,7 @@ static int __init_refok setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
  */
 struct kmem_cache *
 kmem_cache_create (const char *name, size_t size, size_t align,
-	unsigned long flags, void (*ctor)(void *))
+	unsigned int flags, void (*ctor)(void *))
 {
 	size_t left_over, slab_size, ralign;
 	struct kmem_cache *cachep = NULL, *pc;
diff --git a/mm/slob.c b/mm/slob.c
index 3588eaa..7745256 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -558,14 +558,13 @@ size_t ksize(const void *block)
 EXPORT_SYMBOL(ksize);
 
 struct kmem_cache {
-	unsigned int size, align;
-	unsigned long flags;
+	unsigned int size, align, flags;
 	const char *name;
 	void (*ctor)(void *);
 };
 
 struct kmem_cache *kmem_cache_create(const char *name, size_t size,
-	size_t align, unsigned long flags, void (*ctor)(void *))
+	size_t align, unsigned int flags, void (*ctor)(void *))
 {
 	struct kmem_cache *c;
 
diff --git a/mm/slub.c b/mm/slub.c
index e15aa7f..ab36cbe 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1046,8 +1046,8 @@ out:
 
 __setup("slub_debug", setup_slub_debug);
 
-static unsigned long kmem_cache_flags(unsigned long objsize,
-	unsigned long flags, const char *name,
+static unsigned int kmem_cache_flags(unsigned long objsize,
+	unsigned int flags, const char *name,
 	void (*ctor)(void *))
 {
 	/*
@@ -1074,8 +1074,8 @@ static inline int slab_pad_check(struct kmem_cache *s, struct page *page)
 static inline int check_object(struct kmem_cache *s, struct page *page,
 			void *object, u8 val) { return 1; }
 static inline void add_full(struct kmem_cache_node *n, struct page *page) {}
-static inline unsigned long kmem_cache_flags(unsigned long objsize,
-	unsigned long flags, const char *name,
+static inline unsigned int kmem_cache_flags(unsigned long objsize,
+	unsigned int flags, const char *name,
 	void (*ctor)(void *))
 {
 	return flags;
@@ -2069,7 +2069,7 @@ static inline int calculate_order(int size)
 /*
  * Figure out what the alignment of the objects will be.
  */
-static unsigned long calculate_alignment(unsigned long flags,
+static unsigned long calculate_alignment(unsigned int flags,
 		unsigned long align, unsigned long size)
 {
 	/*
@@ -2220,7 +2220,7 @@ static void set_min_partial(struct kmem_cache *s, unsigned long min)
  */
 static int calculate_sizes(struct kmem_cache *s, int forced_order)
 {
-	unsigned long flags = s->flags;
+	unsigned int flags = s->flags;
 	unsigned long size = s->objsize;
 	unsigned long align = s->align;
 	int order;
@@ -2340,7 +2340,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 
 static int kmem_cache_open(struct kmem_cache *s,
 		const char *name, size_t size,
-		size_t align, unsigned long flags,
+		size_t align, unsigned int flags,
 		void (*ctor)(void *))
 {
 	memset(s, 0, kmem_size);
@@ -2384,7 +2384,7 @@ static int kmem_cache_open(struct kmem_cache *s,
 error:
 	if (flags & SLAB_PANIC)
 		panic("Cannot create slab %s size=%lu realsize=%u "
-			"order=%u offset=%u flags=%lx\n",
+			"order=%u offset=%u flags=%x\n",
 			s->name, (unsigned long)size, s->size, oo_order(s->oo),
 			s->offset, flags);
 	return 0;
@@ -3160,7 +3160,7 @@ static int slab_unmergeable(struct kmem_cache *s)
 }
 
 static struct kmem_cache *find_mergeable(size_t size,
-		size_t align, unsigned long flags, const char *name,
+		size_t align, unsigned int flags, const char *name,
 		void (*ctor)(void *))
 {
 	struct kmem_cache *s;
@@ -3201,7 +3201,7 @@ static struct kmem_cache *find_mergeable(size_t size,
 }
 
 struct kmem_cache *kmem_cache_create(const char *name, size_t size,
-		size_t align, unsigned long flags, void (*ctor)(void *))
+		size_t align, unsigned int flags, void (*ctor)(void *))
 {
 	struct kmem_cache *s;
 	char *n;
@@ -3760,7 +3760,7 @@ enum slab_stat_type {
 #define SO_TOTAL	(1 << SL_TOTAL)
 
 static ssize_t show_slab_objects(struct kmem_cache *s,
-			    char *buf, unsigned long flags)
+			    char *buf, unsigned int flags)
 {
 	unsigned long total = 0;
 	int node;
-- 
1.7.4.1

