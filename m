Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945941Ab2ERNCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:02:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47716 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056Ab2ERNCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:02:33 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 1,2/4 v4] slub: use __cmpxchg_double_slab() at interrupt disabled place
Date: Fri, 18 May 2012 22:01:17 +0900
Message-Id: <1337346077-2754-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.LFD.2.02.1205181231170.3899@tux.localdomain>
References: <alpine.LFD.2.02.1205181231170.3899@tux.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_freelist(), unfreeze_partials() are only called with interrupt disabled,
so __cmpxchg_double_slab() is suitable.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <js1304@gmail.com>
---
According to comment from Pekka, add some comment.

diff --git a/mm/slub.c b/mm/slub.c
index 0c3105c..d7f8291 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1879,7 +1879,11 @@ redo:
 	}
 }
 
-/* Unfreeze all the cpu partial slabs */
+/*
+ * Unfreeze all the cpu partial slabs.
+ *
+ * This function must be called with interrupt disabled.
+ */
 static void unfreeze_partials(struct kmem_cache *s)
 {
 	struct kmem_cache_node *n = NULL;
@@ -1935,7 +1939,7 @@ static void unfreeze_partials(struct kmem_cache *s)
 				l = m;
 			}
 
-		} while (!cmpxchg_double_slab(s, page,
+		} while (!__cmpxchg_double_slab(s, page,
 				old.freelist, old.counters,
 				new.freelist, new.counters,
 				"unfreezing slab"));
@@ -2163,6 +2167,8 @@ static inline void *new_slab_objects(struct kmem_cache *s, gfp_t flags,
  * The page is still frozen if the return value is not NULL.
  *
  * If this function returns NULL then the page has been unfrozen.
+ *
+ * This function must be called with interrupt disabled.
  */
 static inline void *get_freelist(struct kmem_cache *s, struct page *page)
 {
@@ -2179,7 +2185,7 @@ static inline void *get_freelist(struct kmem_cache *s, struct page *page)
 		new.inuse = page->objects;
 		new.frozen = freelist != NULL;
 
-	} while (!cmpxchg_double_slab(s, page,
+	} while (!__cmpxchg_double_slab(s, page,
 		freelist, counters,
 		NULL, new.counters,
 		"get_freelist"));
-- 
1.7.9.5

