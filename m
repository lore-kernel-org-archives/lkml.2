Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab1CPC2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:28:12 -0400
Received: from science.horizon.com ([71.41.210.146]:44039 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751130Ab1CPC2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:28:07 -0400
Message-ID: <20110316022805.27713.qmail@science.horizon.com>
MBOX-Line: From 2f896fda99af21252c2f4b2526c984e0f200d1af Mon Sep 17 00:00:00 2001
From: George Spelvin <linux@horizon.com>
Date: Mon, 14 Mar 2011 21:58:24 -0400
Subject: [PATCH 5/8] mm/slub: Factor out some common code.
To: penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au, mpm@selenic.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For sysfs files that map a boolean to a flags bit.
---
 mm/slub.c |   93 ++++++++++++++++++++++++++++--------------------------------
 1 files changed, 43 insertions(+), 50 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index e15aa7f..856246f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3982,38 +3982,61 @@ static ssize_t objects_partial_show(struct kmem_cache *s, char *buf)
 }
 SLAB_ATTR_RO(objects_partial);
 
+static ssize_t flag_show(struct kmem_cache *s, char *buf, unsigned flag)
+{
+	return sprintf(buf, "%d\n", !!(s->flags & flag));
+}
+
+static ssize_t flag_store(struct kmem_cache *s,
+				const char *buf, size_t length, unsigned flag)
+{
+	s->flags &= ~flag;
+	if (buf[0] == '1')
+		s->flags |= flag;
+	return length;
+}
+
+/* Like above, but changes allocation size; so only allowed on empty slab */
+static ssize_t flag_store_sizechange(struct kmem_cache *s,
+				const char *buf, size_t length, unsigned flag)
+{
+	if (any_slab_objects(s))
+		return -EBUSY;
+
+	flag_store(s, buf, length, flag);
+	calculate_sizes(s, -1);
+	return length;
+}
+
 static ssize_t reclaim_account_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_RECLAIM_ACCOUNT));
+	return flag_show(s, buf, SLAB_RECLAIM_ACCOUNT);
 }
 
 static ssize_t reclaim_account_store(struct kmem_cache *s,
 				const char *buf, size_t length)
 {
-	s->flags &= ~SLAB_RECLAIM_ACCOUNT;
-	if (buf[0] == '1')
-		s->flags |= SLAB_RECLAIM_ACCOUNT;
-	return length;
+	return flag_store(s, buf, length, SLAB_RECLAIM_ACCOUNT);
 }
 SLAB_ATTR(reclaim_account);
 
 static ssize_t hwcache_align_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_HWCACHE_ALIGN));
+	return flag_show(s, buf, SLAB_HWCACHE_ALIGN);
 }
 SLAB_ATTR_RO(hwcache_align);
 
 #ifdef CONFIG_ZONE_DMA
 static ssize_t cache_dma_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_CACHE_DMA));
+	return flag_show(s, buf, SLAB_CACHE_DMA);
 }
 SLAB_ATTR_RO(cache_dma);
 #endif
 
 static ssize_t destroy_by_rcu_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_DESTROY_BY_RCU));
+	return flag_show(s, buf, SLAB_DESTROY_BY_RCU);
 }
 SLAB_ATTR_RO(destroy_by_rcu);
 
@@ -4032,88 +4055,61 @@ SLAB_ATTR_RO(total_objects);
 
 static ssize_t sanity_checks_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_DEBUG_FREE));
+	return flag_show(s, buf, SLAB_DEBUG_FREE);
 }
 
 static ssize_t sanity_checks_store(struct kmem_cache *s,
 				const char *buf, size_t length)
 {
-	s->flags &= ~SLAB_DEBUG_FREE;
-	if (buf[0] == '1')
-		s->flags |= SLAB_DEBUG_FREE;
-	return length;
+	return flag_store(s, buf, length, SLAB_DEBUG_FREE);
 }
 SLAB_ATTR(sanity_checks);
 
 static ssize_t trace_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_TRACE));
+	return flag_show(s, buf, SLAB_TRACE);
 }
 
 static ssize_t trace_store(struct kmem_cache *s, const char *buf,
 							size_t length)
 {
-	s->flags &= ~SLAB_TRACE;
-	if (buf[0] == '1')
-		s->flags |= SLAB_TRACE;
-	return length;
+	return flag_store(s, buf, length, SLAB_TRACE);
 }
 SLAB_ATTR(trace);
 
 static ssize_t red_zone_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_RED_ZONE));
+	return flag_show(s, buf, SLAB_RED_ZONE);
 }
 
 static ssize_t red_zone_store(struct kmem_cache *s,
 				const char *buf, size_t length)
 {
-	if (any_slab_objects(s))
-		return -EBUSY;
-
-	s->flags &= ~SLAB_RED_ZONE;
-	if (buf[0] == '1')
-		s->flags |= SLAB_RED_ZONE;
-	calculate_sizes(s, -1);
-	return length;
+	return flag_store_sizechange(s, buf, length, SLAB_RED_ZONE);
 }
 SLAB_ATTR(red_zone);
 
 static ssize_t poison_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_POISON));
+	return flag_show(s, buf, SLAB_POISON);
 }
 
 static ssize_t poison_store(struct kmem_cache *s,
 				const char *buf, size_t length)
 {
-	if (any_slab_objects(s))
-		return -EBUSY;
-
-	s->flags &= ~SLAB_POISON;
-	if (buf[0] == '1')
-		s->flags |= SLAB_POISON;
-	calculate_sizes(s, -1);
-	return length;
+	return flag_store_sizechange(s, buf, length, SLAB_POISON);
 }
 SLAB_ATTR(poison);
 
 static ssize_t store_user_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_STORE_USER));
+	return flag_show(s, buf, SLAB_STORE_USER);
 }
 
 static ssize_t store_user_store(struct kmem_cache *s,
 				const char *buf, size_t length)
 {
-	if (any_slab_objects(s))
-		return -EBUSY;
-
-	s->flags &= ~SLAB_STORE_USER;
-	if (buf[0] == '1')
-		s->flags |= SLAB_STORE_USER;
-	calculate_sizes(s, -1);
-	return length;
+	return flag_store_sizechange(s, buf, length, SLAB_STORE_USER);
 }
 SLAB_ATTR(store_user);
 
@@ -4156,16 +4152,13 @@ SLAB_ATTR_RO(free_calls);
 #ifdef CONFIG_FAILSLAB
 static ssize_t failslab_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_FAILSLAB));
+	return flag_show(s, buf, SLAB_FAILSLAB);
 }
 
 static ssize_t failslab_store(struct kmem_cache *s, const char *buf,
 							size_t length)
 {
-	s->flags &= ~SLAB_FAILSLAB;
-	if (buf[0] == '1')
-		s->flags |= SLAB_FAILSLAB;
-	return length;
+	return flag_store(s, buf, length, SLAB_FAILSLAB);
 }
 SLAB_ATTR(failslab);
 #endif
-- 
1.7.4.1

