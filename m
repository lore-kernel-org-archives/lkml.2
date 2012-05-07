Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab2EGLjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:39:39 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50922 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab2EGLiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:38:18 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>, David Miller <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 09/10] mm: bootmem: pass pgdat instead of pgdat->bdata down the stack
Date: Mon,  7 May 2012 13:37:51 +0200
Message-Id: <1336390672-14421-10-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass down the node descriptor instead of the more specific bootmem
node descriptor down the call stack, like nobootmem does, when there
is no good reason for the two to be different.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/bootmem.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index d9185c3..9d0f266 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -698,18 +698,19 @@ void * __init __alloc_bootmem(unsigned long size, unsigned long align,
 	return ___alloc_bootmem(size, align, goal, limit);
 }
 
-static void * __init ___alloc_bootmem_node_nopanic(bootmem_data_t *bdata,
+static void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
 				unsigned long size, unsigned long align,
 				unsigned long goal, unsigned long limit)
 {
 	void *ptr;
 
 again:
-	ptr = alloc_arch_preferred_bootmem(bdata, size, align, goal, limit);
+	ptr = alloc_arch_preferred_bootmem(pgdat->bdata, size,
+					   align, goal, limit);
 	if (ptr)
 		return ptr;
 
-	ptr = alloc_bootmem_bdata(bdata, size, align, goal, limit);
+	ptr = alloc_bootmem_bdata(pgdat->bdata, size, align, goal, limit);
 	if (ptr)
 		return ptr;
 
@@ -731,17 +732,16 @@ void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
-	return ___alloc_bootmem_node_nopanic(pgdat->bdata, size,
-					     align, goal, 0);
+	return ___alloc_bootmem_node_nopanic(pgdat, size, align, goal, 0);
 }
 
-void * __init ___alloc_bootmem_node(bootmem_data_t *bdata, unsigned long size,
+void * __init ___alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				    unsigned long align, unsigned long goal,
 				    unsigned long limit)
 {
 	void *ptr;
 
-	ptr = ___alloc_bootmem_node_nopanic(bdata, size, align, goal, 0);
+	ptr = ___alloc_bootmem_node_nopanic(pgdat, size, align, goal, 0);
 	if (ptr)
 		return ptr;
 
@@ -771,7 +771,7 @@ void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
-	return  ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
+	return  ___alloc_bootmem_node(pgdat, size, align, goal, 0);
 }
 
 void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
@@ -869,6 +869,6 @@ void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
-	return ___alloc_bootmem_node(pgdat->bdata, size, align,
-				goal, ARCH_LOW_ADDRESS_LIMIT);
+	return ___alloc_bootmem_node(pgdat, size, align,
+				     goal, ARCH_LOW_ADDRESS_LIMIT);
 }
-- 
1.7.10

