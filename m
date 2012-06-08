Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250Ab2FHRZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:25:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44869 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762232Ab2FHRZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:25:03 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 2/4] slub: use __cmpxchg_double_slab() at interrupt disabled place
Date: Sat,  9 Jun 2012 02:23:15 +0900
Message-Id: <1339176197-13270-2-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339176197-13270-1-git-send-email-js1304@gmail.com>
References: <yes>
 <1339176197-13270-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_freelist(), unfreeze_partials() are only called with interrupt disabled,
so __cmpxchg_double_slab() is suitable.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/slub.c b/mm/slub.c
index 30ceb6d..686ed90 100644
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

