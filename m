Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab0INRGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:06:14 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:57706 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab0INRGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:06:08 -0400
From: Pekka Enberg <penberg@kernel.org>
To: torvalds@linux-founation.org
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Subject: [PATCH 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
Date: Tue, 14 Sep 2010 20:06:04 +0300
Message-Id: <1284483964-2370-2-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1284483964-2370-1-git-send-email-penberg@kernel.org>
References: <1284483964-2370-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB uses the name of the first slab cache for all merged slab caches. To make
the output of /proc/slabinfo more obvious, append the name of each merged slab
cache to s->name.

An example output looks like this:

  bip-16,ip_dst_cache,kioctx     42     42    [snip]

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 mm/slub.c |   41 ++++++++++++++++++++++++++++++-----------
 1 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0704288..6b08256 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3149,6 +3149,34 @@ void __init kmem_cache_init_late(void)
 {
 }
 
+static int kmem_merge_names(struct kmem_cache *s, const char *name)
+{
+	size_t new_size;
+	char *new_name;
+
+	/* Don't append name to merged name more than once */
+	if (strstr(s->name, name))
+		return 0;
+
+	/* Comma separated and NULL terminated. */
+	new_size = strlen(s->name) + strlen(name) + 2;
+
+	new_name = kmalloc(new_size, GFP_KERNEL);
+	if (!new_name)
+		return -ENOMEM;
+
+	snprintf(new_name, new_size, "%s,%s", s->name, name);
+
+	if (s->flags & SLAB_DYNAMIC_NAME)
+		kfree(s->name);
+
+	s->name = new_name;
+
+	s->flags |= SLAB_DYNAMIC_NAME;
+
+	return 0;
+}
+
 /*
  * Find a mergeable slab cache
  */
@@ -3221,17 +3249,8 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 	down_write(&slub_lock);
 	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {
-		if (!(s->flags & SLAB_DYNAMIC_NAME)) {
-			const char *new_name;
-
-			new_name = kstrdup(s->name, GFP_KERNEL);
-			if (!new_name)
-				goto err;
-
-			s->name = new_name;
-
-			s->flags |= SLAB_DYNAMIC_NAME;
-		}
+		if (kmem_merge_names(s, name))
+			goto err;
 
 		s->refcount++;
 		/*
-- 
1.6.3.3

