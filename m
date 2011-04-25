Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab1DYRrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:47:06 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:60611 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758696Ab1DYRqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:46:53 -0400
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC/PATCH 2/2] slub: Don't share struct kmem_cache for shared caches
Date: Mon, 25 Apr 2011 20:46:48 +0300
Message-Id: <1303753608-19248-2-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1303753608-19248-1-git-send-email-penberg@kernel.org>
References: <1303753608-19248-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the slab cache sharing in SLUB to only share 'struct
kmem_cpu_cache' which contains the actual list of slabs and object freelists.
We no longer share 'struct kmem_cache' between merged caches so /proc/slabinfo
statistics work as expected:

  Before:

  # cat /proc/slabinfo | wc -l
  104

  After:

  # cat /proc/slabinfo | wc -l
  185

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 mm/slub.c |   98 +++++++++++++++++++-----------------------------------------
 1 files changed, 31 insertions(+), 67 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index cb61024..3a8fbca 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2349,6 +2349,11 @@ init_kmem_cache_node(struct kmem_cache_node *n, struct kmem_cache *s)
 #endif
 }
 
+static inline void dup_kmem_cache_cpus(struct kmem_cache *src, struct kmem_cache *dst)
+{
+	dst->cpu_slab = src->cpu_slab;
+}
+
 static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
 {
 	BUILD_BUG_ON(PERCPU_DYNAMIC_EARLY_SIZE <
@@ -3441,26 +3446,41 @@ static struct kmem_cache *find_mergeable(size_t size,
 struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 		size_t align, unsigned long flags, void (*ctor)(void *))
 {
-	struct kmem_cache *s;
+	struct kmem_cache *s, *parent;
 	char *n;
 
 	if (WARN_ON(!name))
 		return NULL;
 
 	down_write(&slub_lock);
-	s = find_mergeable(size, align, flags, name, ctor);
-	if (s) {
-		s->refcount++;
+	parent = find_mergeable(size, align, flags, name, ctor);
+	if (parent) {
+		n = kstrdup(name, GFP_KERNEL);
+		if (!n)
+			goto err;
+
+		s = kmalloc(kmem_size, GFP_KERNEL);
+		if (!s)
+			goto err_free;
+
+		if (!kmem_cache_open(s, n, size, align, flags, ctor))
+			goto err_free;
+
+		dup_kmem_cache_cpus(parent, s);
+
+		parent->refcount++;
 		/*
 		 * Adjust the object sizes so that we clear
 		 * the complete object on kzalloc.
 		 */
-		s->objsize = max(s->objsize, (int)size);
-		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
+		parent->objsize = max(parent->objsize, (int)size);
+		parent->inuse = max_t(int, parent->inuse, ALIGN(size, sizeof(void *)));
 
-		if (sysfs_slab_alias(s, name)) {
-			s->refcount--;
-			goto err;
+		list_add(&s->list, &slab_caches);
+		if (sysfs_slab_add(s)) {
+			parent->refcount--;
+			list_del(&s->list);
+			goto err_free;
 		}
 		up_write(&slub_lock);
 		return s;
@@ -4670,68 +4690,17 @@ static const struct kset_uevent_ops slab_uevent_ops = {
 
 static struct kset *slab_kset;
 
-#define ID_STR_LENGTH 64
-
-/* Create a unique string id for a slab cache:
- *
- * Format	:[flags-]size
- */
-static char *create_unique_id(struct kmem_cache *s)
-{
-	char *name = kmalloc(ID_STR_LENGTH, GFP_KERNEL);
-	char *p = name;
-
-	BUG_ON(!name);
-
-	*p++ = ':';
-	/*
-	 * First flags affecting slabcache operations. We will only
-	 * get here for aliasable slabs so we do not need to support
-	 * too many flags. The flags here must cover all flags that
-	 * are matched during merging to guarantee that the id is
-	 * unique.
-	 */
-	if (s->flags & SLAB_CACHE_DMA)
-		*p++ = 'd';
-	if (s->flags & SLAB_RECLAIM_ACCOUNT)
-		*p++ = 'a';
-	if (s->flags & SLAB_DEBUG_FREE)
-		*p++ = 'F';
-	if (!(s->flags & SLAB_NOTRACK))
-		*p++ = 't';
-	if (p != name + 1)
-		*p++ = '-';
-	p += sprintf(p, "%07d", s->size);
-	BUG_ON(p > name + ID_STR_LENGTH - 1);
-	return name;
-}
-
 static int sysfs_slab_add(struct kmem_cache *s)
 {
 	int err;
 	const char *name;
-	int unmergeable;
 
 	if (slab_state < SYSFS)
 		/* Defer until later */
 		return 0;
 
-	unmergeable = slab_unmergeable(s);
-	if (unmergeable) {
-		/*
-		 * Slabcache can never be merged so we can use the name proper.
-		 * This is typically the case for debug situations. In that
-		 * case we can catch duplicate names easily.
-		 */
-		sysfs_remove_link(&slab_kset->kobj, s->name);
-		name = s->name;
-	} else {
-		/*
-		 * Create a unique name for the slab as a target
-		 * for the symlinks.
-		 */
-		name = create_unique_id(s);
-	}
+	sysfs_remove_link(&slab_kset->kobj, s->name);
+	name = s->name;
 
 	s->kobj.kset = slab_kset;
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, name);
@@ -4747,11 +4716,6 @@ static int sysfs_slab_add(struct kmem_cache *s)
 		return err;
 	}
 	kobject_uevent(&s->kobj, KOBJ_ADD);
-	if (!unmergeable) {
-		/* Setup first alias */
-		sysfs_slab_alias(s, s->name);
-		kfree(name);
-	}
 	return 0;
 }
 
-- 
1.7.0.4

