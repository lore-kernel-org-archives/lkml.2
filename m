Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab2EQQmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:42:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44937 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106Ab2EQQmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:42:19 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 1,2/4 v2] slub: use __cmpxchg_double_slab() at interrupt disabled place
Date: Fri, 18 May 2012 01:41:04 +0900
Message-Id: <1337272864-5090-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337269668-4619-1-git-send-email-js1304@gmail.com>
References: <1337269668-4619-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_freelist() is only called by __slab_alloc() with interrupt disabled,
so __cmpxchg_double_slab() is suitable.

unfreeze_partials() is only called with interrupt disabled,
so __cmpxchg_double_slab() is suitable.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/slub.c b/mm/slub.c
index 0c3105c..c38efce 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1935,7 +1935,7 @@ static void unfreeze_partials(struct kmem_cache *s)
 				l = m;
 			}
 
-		} while (!cmpxchg_double_slab(s, page,
+		} while (!__cmpxchg_double_slab(s, page,
 				old.freelist, old.counters,
 				new.freelist, new.counters,
 				"unfreezing slab"));
@@ -2179,7 +2179,7 @@ static inline void *get_freelist(struct kmem_cache *s, struct page *page)
 		new.inuse = page->objects;
 		new.frozen = freelist != NULL;
 
-	} while (!cmpxchg_double_slab(s, page,
+	} while (!__cmpxchg_double_slab(s, page,
 		freelist, counters,
 		NULL, new.counters,
 		"get_freelist"));
-- 
1.7.9.5

