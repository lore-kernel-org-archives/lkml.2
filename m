Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab1KVOxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:53:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43057 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab1KVOxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:53:52 -0500
Message-ID: <1321973629.2474.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: [PATCH] slub: avoid potential NULL dereference or corruption
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 22 Nov 2011 15:53:49 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

show_slab_objects() can trigger NULL dereferences or memory corruption.

Another cpu can change its c->page to NULL or c->node to NUMA_NO_NODE
while we use them.

Use ACCESS_ONCE(c->page) and ACCESS_ONCE(c->node) to make sure this
cannot happen.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 mm/slub.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7d2a996..e8e6714 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4436,29 +4436,33 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 		for_each_possible_cpu(cpu) {
 			struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
 			struct page *page;
+			int node;
 
-			if (!c || c->node < 0)
+			if (!c)
 				continue;
-
-			if (c->page) {
-					if (flags & SO_TOTAL)
-						x = c->page->objects;
+			node = ACCESS_ONCE(c->node);
+			if (node < 0)
+				continue;
+			page = ACCESS_ONCE(c->page);
+			if (page) {
+				if (flags & SO_TOTAL)
+					x = page->objects;
 				else if (flags & SO_OBJECTS)
-					x = c->page->inuse;
+					x = page->inuse;
 				else
 					x = 1;
 
 				total += x;
-				nodes[c->node] += x;
+				nodes[node] += x;
 			}
 			page = c->partial;
 
 			if (page) {
 				x = page->pobjects;
                                 total += x;
-                                nodes[c->node] += x;
+                                nodes[node] += x;
 			}
-			per_cpu[c->node]++;
+			per_cpu[node]++;
 		}
 	}
 


