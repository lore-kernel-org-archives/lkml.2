Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab0INSs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:48:27 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:34767 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0INSs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:48:26 -0400
From: Pekka Enberg <penberg@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Subject: [PATCH v2 1/2] SLUB: Fix merged slab cache names
Date: Tue, 14 Sep 2010 21:48:20 +0300
Message-Id: <1284490101-2362-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As explained by Linus "I'm Proud to be an American" Torvalds:

  Looking at the merging code, I actually think it's totally
  buggy. If you have something like this:

   - load module A: create slab cache A

   - load module B: create slab cache B that can merge with A

   - unload module A

   - "cat /proc/slabinfo": BOOM. Oops.

  exactly because the name is not handled correctly, and you'll have
  module B holding open a slab cache that has a name pointer that points
  to module A that no longer exists.

This patch fixes the problem by using kstrdup() to allocate dynamic memory for
->name of "struct kmem_cache" as suggested by Christoph Lameter.

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 mm/slub.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 13fffe1..a31c033 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -210,6 +210,7 @@ static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
 							{ return 0; }
 static inline void sysfs_slab_remove(struct kmem_cache *s)
 {
+	kfree(s->name);
 	kfree(s);
 }
 
@@ -3117,6 +3118,19 @@ void __init kmem_cache_init(void)
 	slab_state = UP;
 
 	/* Provide the correct kmalloc names now that the caches are up */
+	kmalloc_caches[0].name = kstrdup(kmalloc_caches[0].name, GFP_NOWAIT);
+	BUG_ON(!kmalloc_caches[0].name);
+
+	if (KMALLOC_MIN_SIZE <= 32) {
+		kmalloc_caches[1].name = kstrdup(kmalloc_caches[1].name, GFP_NOWAIT);
+		BUG_ON(!kmalloc_caches[1].name);
+	}
+
+	if (KMALLOC_MIN_SIZE <= 64) {
+		kmalloc_caches[2].name = kstrdup(kmalloc_caches[2].name, GFP_NOWAIT);
+		BUG_ON(!kmalloc_caches[2].name);
+	}
+
 	for (i = KMALLOC_SHIFT_LOW; i < SLUB_PAGE_SHIFT; i++) {
 		char *s = kasprintf(GFP_NOWAIT, "kmalloc-%d", 1 << i);
 
@@ -3211,6 +3225,7 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 		size_t align, unsigned long flags, void (*ctor)(void *))
 {
 	struct kmem_cache *s;
+	char *dup_name;
 
 	if (WARN_ON(!name))
 		return NULL;
@@ -3234,19 +3249,25 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 		return s;
 	}
 
+	dup_name = kstrdup(name, GFP_KERNEL);
+	if (!dup_name)
+		goto err;
+
 	s = kmalloc(kmem_size, GFP_KERNEL);
 	if (s) {
-		if (kmem_cache_open(s, GFP_KERNEL, name,
+		if (kmem_cache_open(s, GFP_KERNEL, dup_name,
 				size, align, flags, ctor)) {
 			list_add(&s->list, &slab_caches);
 			if (sysfs_slab_add(s)) {
 				list_del(&s->list);
+				kfree(dup_name);
 				kfree(s);
 				goto err;
 			}
 			up_write(&slub_lock);
 			return s;
 		}
+		kfree(dup_name);
 		kfree(s);
 	}
 	up_write(&slub_lock);
@@ -4377,6 +4398,7 @@ static void kmem_cache_release(struct kobject *kobj)
 {
 	struct kmem_cache *s = to_slab(kobj);
 
+	kfree(s->name);
 	kfree(s);
 }
 
-- 
1.6.3.3

