Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab0DHJ2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 05:28:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab0DHJ22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 05:28:28 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: [PATCH] slub: __kmalloc_node_track_caller should trace kmalloc_large_node case
Date: Thu,  8 Apr 2010 17:26:44 +0800
Message-Id: <1270718804-27268-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 94b528d (kmemtrace: SLUB hooks for caller-tracking functions)
missed tracing kmalloc_large_node in __kmalloc_node_track_caller. We
should trace it same as __kmalloc_node.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
---
 mm/slub.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b364844..a3a5a18 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3335,8 +3335,15 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 	struct kmem_cache *s;
 	void *ret;
 
-	if (unlikely(size > SLUB_MAX_SIZE))
-		return kmalloc_large_node(size, gfpflags, node);
+	if (unlikely(size > SLUB_MAX_SIZE)) {
+		ret = kmalloc_large_node(size, gfpflags, node);
+
+		trace_kmalloc_node(caller, ret,
+				   size, PAGE_SIZE << get_order(size),
+				   gfpflags, node);
+
+		return ret;
+	}
 
 	s = get_slab(size, gfpflags);
 
-- 
1.7.0.1

