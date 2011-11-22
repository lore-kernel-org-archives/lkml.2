Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab1KVPCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:02:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58988 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab1KVPCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:02:07 -0500
Message-ID: <1321974122.2474.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: [PATCH V2] slub: avoid potential NULL dereference or corruption
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 22 Nov 2011 16:02:02 +0100
In-Reply-To: <alpine.DEB.2.00.1111220855460.25785@router.home>
References: <1321973629.2474.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <alpine.DEB.2.00.1111220855460.25785@router.home>
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
V2: remove a not needed "if (!c)" test

 mm/slub.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7d2a996..9deef7d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4435,30 +4435,31 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 
 		for_each_possible_cpu(cpu) {
 			struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
+			int node = ACCESS_ONCE(c->node);
 			struct page *page;
 
-			if (!c || c->node < 0)
+			if (node < 0)
 				continue;
-
-			if (c->page) {
-					if (flags & SO_TOTAL)
-						x = c->page->objects;
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
-                                total += x;
-                                nodes[c->node] += x;
+				total += x;
+				nodes[node] += x;
 			}
-			per_cpu[c->node]++;
+			per_cpu[node]++;
 		}
 	}
 


