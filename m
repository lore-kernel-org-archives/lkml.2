Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab1CPC2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:28:09 -0400
Received: from science.horizon.com ([71.41.210.146]:44047 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751161Ab1CPC2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:28:07 -0400
Message-ID: <20110316022805.27719.qmail@science.horizon.com>
MBOX-Line: From ab321f5e7dd802cc38df405697732aeb3418d36e Mon Sep 17 00:00:00 2001
From: George Spelvin <linux@horizon.com>
Date: Mon, 14 Mar 2011 22:22:14 -0400
Subject: [PATCH 6/8] mm/slub: Remove unnecessary parameter
To: penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au, mpm@selenic.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup_object() does not need the page pointer.
It's a private static function, so no API changes whatsoever.
---
 mm/slub.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 856246f..3a20b71 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -878,8 +878,7 @@ static inline void dec_slabs_node(struct kmem_cache *s, int node, int objects)
 }
 
 /* Object debug checks for alloc/free paths */
-static void setup_object_debug(struct kmem_cache *s, struct page *page,
-								void *object)
+static void setup_object_debug(struct kmem_cache *s, void *object)
 {
 	if (!(s->flags & (SLAB_STORE_USER|SLAB_RED_ZONE|__OBJECT_POISON)))
 		return;
@@ -1060,8 +1059,7 @@ static unsigned long kmem_cache_flags(unsigned long objsize,
 	return flags;
 }
 #else
-static inline void setup_object_debug(struct kmem_cache *s,
-			struct page *page, void *object) {}
+static inline void setup_object_debug(struct kmem_cache *s, void *object) {}
 
 static inline int alloc_debug_processing(struct kmem_cache *s,
 	struct page *page, void *object, unsigned long addr) { return 0; }
@@ -1175,10 +1173,9 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	return page;
 }
 
-static void setup_object(struct kmem_cache *s, struct page *page,
-				void *object)
+static void setup_object(struct kmem_cache *s, void *object)
 {
-	setup_object_debug(s, page, object);
+	setup_object_debug(s, object);
 	if (unlikely(s->ctor))
 		s->ctor(object);
 }
@@ -1208,11 +1205,11 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 
 	last = start;
 	for_each_object(p, s, start, page->objects) {
-		setup_object(s, page, last);
+		setup_object(s, last);
 		set_freepointer(s, last, p);
 		last = p;
 	}
-	setup_object(s, page, last);
+	setup_object(s, last);
 	set_freepointer(s, last, NULL);
 
 	page->freelist = start;
-- 
1.7.4.1

