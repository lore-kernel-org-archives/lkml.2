Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab2JRWmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:42:08 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35953 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2JRWmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:42:04 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Cc: Tim Bird <tim.bird@am.sony.com>, Ezequiel Garcia <elezegarcia@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: [PATCH 2/3] mm/slob: Use object_size field in kmem_cache_size()
Date: Thu, 18 Oct 2012 19:41:46 -0300
Message-Id: <1350600107-4558-2-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1350600107-4558-1-git-send-email-elezegarcia@gmail.com>
References: <1350600107-4558-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fields object_size and size are not the same: the latter might include
slab metadata. Return object_size field in kmem_cache_size().
Also, improve trace accuracy by correctly tracing reported size.

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 mm/slob.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index 06a5ec7..287a88a 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -554,12 +554,12 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 
 	if (c->size < PAGE_SIZE) {
 		b = slob_alloc(c->size, flags, c->align, node);
-		trace_kmem_cache_alloc_node(_RET_IP_, b, c->size,
+		trace_kmem_cache_alloc_node(_RET_IP_, b, c->object_size,
 					    SLOB_UNITS(c->size) * SLOB_UNIT,
 					    flags, node);
 	} else {
 		b = slob_new_pages(flags, get_order(c->size), node);
-		trace_kmem_cache_alloc_node(_RET_IP_, b, c->size,
+		trace_kmem_cache_alloc_node(_RET_IP_, b, c->object_size,
 					    PAGE_SIZE << get_order(c->size),
 					    flags, node);
 	}
@@ -606,7 +606,7 @@ EXPORT_SYMBOL(kmem_cache_free);
 
 unsigned int kmem_cache_size(struct kmem_cache *c)
 {
-	return c->size;
+	return c->object_size;
 }
 EXPORT_SYMBOL(kmem_cache_size);
 
-- 
1.7.8.6

