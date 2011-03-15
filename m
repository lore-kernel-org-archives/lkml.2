Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1CPC3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:29:30 -0400
Received: from science.horizon.com ([71.41.210.146]:44043 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751188Ab1CPC2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:28:07 -0400
Message-ID: <20110316022805.27727.qmail@science.horizon.com>
MBOX-Line: From c85ac3d8df4c90ecfa7f8ed0465e2be2512ad154 Mon Sep 17 00:00:00 2001
From: George Spelvin <linux@horizon.com>
Date: Mon, 14 Mar 2011 23:41:36 -0400
Subject: [PATCH 7/8] mm/slub.c: Add slab randomization.
To: penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au, mpm@selenic.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If SLAB_RANDOMIZE is set, the initial free list is shuffled into random
order to make it harder for an attacker to control where a buffer overrun
attack will overrun into.

Not supported (does nothing) for SLAB and SLOB allocators.
---
 include/linux/slab.h |    2 +
 mm/slub.c            |   69 +++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index fa90866..8e812f1 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -79,6 +79,8 @@
 /* The following flags affect the page allocator grouping pages by mobility */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
+
+#define SLAB_RANDOMIZE		0x04000000UL	/* Randomize allocation order */
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
  *
diff --git a/mm/slub.c b/mm/slub.c
index 3a20b71..4ba1db4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -27,6 +27,7 @@
 #include <linux/memory.h>
 #include <linux/math64.h>
 #include <linux/fault-inject.h>
+#include <linux/random.h>
 
 #include <trace/events/kmem.h>
 
@@ -1180,12 +1181,41 @@ static void setup_object(struct kmem_cache *s, void *object)
 		s->ctor(object);
 }
 
+/*
+ * Initialize a slab's free list in random order, to make
+ * buffer overrun attacks harder.  Using a (moderately) secure
+ * random number generator, this ensures an attacker can't
+ * figure out which other object an overrun will hit.
+ */
+static void *
+setup_slab_randomized(struct kmem_cache *s, void *start, int count)
+{
+	struct cpu_random *r = get_random_mod_start();
+	void *p = start;
+	int i;
+
+	setup_object(s, p);
+	set_freepointer(s, p, p);
+
+	for (i = 1; i < count; i++) {
+		void *q = start + i * s->size;
+		setup_object(s, q);
+		/* p points to a random object in the list; link q in after */
+		set_freepointer(s, q, get_freepointer(s, p));
+		set_freepointer(s, p, q);
+		p = start + s->size * get_random_mod(r, i+1);
+	}
+	start = get_freepointer(s, p);
+	set_freepointer(s, p, NULL);
+	get_random_mod_stop(r);
+
+	return start;
+}
+
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
 	struct page *page;
 	void *start;
-	void *last;
-	void *p;
 
 	BUG_ON(flags & GFP_SLAB_BUG_MASK);
 
@@ -1203,16 +1233,19 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 	if (unlikely(s->flags & SLAB_POISON))
 		memset(start, POISON_INUSE, PAGE_SIZE << compound_order(page));
 
-	last = start;
-	for_each_object(p, s, start, page->objects) {
+	if (s->flags & SLAB_RANDOMIZE) {
+		page->freelist = setup_slab_randomized(s, start, page->objects);
+	} else {
+		void *p, *last = start;
+		for_each_object(p, s, start, page->objects) {
+			setup_object(s, last);
+			set_freepointer(s, last, p);
+			last = p;
+		}
 		setup_object(s, last);
-		set_freepointer(s, last, p);
-		last = p;
+		set_freepointer(s, last, NULL);
+		page->freelist = start;
 	}
-	setup_object(s, last);
-	set_freepointer(s, last, NULL);
-
-	page->freelist = start;
 	page->inuse = 0;
 out:
 	return page;
@@ -1227,8 +1260,7 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 		void *p;
 
 		slab_pad_check(s, page);
-		for_each_object(p, s, page_address(page),
-						page->objects)
+		for_each_object(p, s, page_address(page), page->objects)
 			check_object(s, page, p, SLUB_RED_INACTIVE);
 	}
 
@@ -4160,6 +4192,18 @@ static ssize_t failslab_store(struct kmem_cache *s, const char *buf,
 SLAB_ATTR(failslab);
 #endif
 
+static ssize_t randomize_show(struct kmem_cache *s, char *buf)
+{
+	return flag_show(s, buf, SLAB_RANDOMIZE);
+}
+
+static ssize_t randomize_store(struct kmem_cache *s,
+				const char *buf, size_t length)
+{
+	return flag_store(s, buf, length, SLAB_RANDOMIZE);
+}
+SLAB_ATTR(randomize);
+
 static ssize_t shrink_show(struct kmem_cache *s, char *buf)
 {
 	return 0;
@@ -4292,6 +4336,7 @@ static struct attribute *slab_attrs[] = {
 	&hwcache_align_attr.attr,
 	&reclaim_account_attr.attr,
 	&destroy_by_rcu_attr.attr,
+	&randomize_attr.attr,
 	&shrink_attr.attr,
 #ifdef CONFIG_SLUB_DEBUG
 	&total_objects_attr.attr,
-- 
1.7.4.1

