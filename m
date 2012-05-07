Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2EGLiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:38:19 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50914 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520Ab2EGLiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:38:15 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>, David Miller <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 07/10] mm: nobootmem: panic on node-specific allocation failure
Date: Mon,  7 May 2012 13:37:49 +0200
Message-Id: <1336390672-14421-8-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__alloc_bootmem_node and __alloc_bootmem_low_node documentation claims
the functions panic on allocation failure.  Do it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/nobootmem.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index e53bb8a..b078ff8 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -306,11 +306,17 @@ again:
 
 	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
 					goal, -1ULL);
-	if (!ptr && goal) {
+	if (ptr)
+		return ptr;
+
+	if (goal) {
 		goal = 0;
 		goto again;
 	}
-	return ptr;
+
+	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
+	panic("Out of memory");
+	return NULL;
 }
 
 void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
@@ -408,6 +414,12 @@ void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 	if (ptr)
 		return ptr;
 
-	return  __alloc_memory_core_early(MAX_NUMNODES, size, align,
-				goal, ARCH_LOW_ADDRESS_LIMIT);
+	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
+					goal, ARCH_LOW_ADDRESS_LIMIT);
+	if (ptr)
+		return ptr;
+
+	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
+	panic("Out of memory");
+	return NULL;
 }
-- 
1.7.10

