Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab0INRGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:06:12 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39482 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab0INRGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:06:08 -0400
From: Pekka Enberg <penberg@kernel.org>
To: torvalds@linux-founation.org
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Subject: [PATCH 1/2] SLUB: Fix merged slab cache names
Date: Tue, 14 Sep 2010 20:06:03 +0300
Message-Id: <1284483964-2370-1-git-send-email-penberg@kernel.org>
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

This patch fixes the problem by introducing a SLAB_DYNAMIC_NAME flag and using
kstrdup() to allocate memory when reference count is bumped up.

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 include/linux/slab.h |    2 ++
 mm/slub.c            |   15 +++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 59260e2..df201cf 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -76,6 +76,8 @@
 # define SLAB_FAILSLAB		0x00000000UL
 #endif
 
+#define SLAB_DYNAMIC_NAME	0x04000000UL	/* s->name is kmalloc()'d */
+
 /* The following flags affect the page allocator grouping pages by mobility */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
diff --git a/mm/slub.c b/mm/slub.c
index 13fffe1..0704288 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -210,6 +210,9 @@ static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
 							{ return 0; }
 static inline void sysfs_slab_remove(struct kmem_cache *s)
 {
+	if (s->flags & SLAB_DYNAMIC_NAME)
+		kfree(s->name);
+
 	kfree(s);
 }
 
@@ -3218,6 +3221,18 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 	down_write(&slub_lock);
 	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {
+		if (!(s->flags & SLAB_DYNAMIC_NAME)) {
+			const char *new_name;
+
+			new_name = kstrdup(s->name, GFP_KERNEL);
+			if (!new_name)
+				goto err;
+
+			s->name = new_name;
+
+			s->flags |= SLAB_DYNAMIC_NAME;
+		}
+
 		s->refcount++;
 		/*
 		 * Adjust the object sizes so that we clear
-- 
1.6.3.3

