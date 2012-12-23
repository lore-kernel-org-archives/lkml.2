Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab2LWUQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 15:16:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42549 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2LWUQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 15:16:04 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: rientjes@google.com, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Joonsoo Kim <js1304@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 2/3] mm, bootmem: panic in bootmem alloc functions even if slab is available
Date: Sun, 23 Dec 2012 15:15:07 -0500
Message-Id: <1356293711-23864-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com>
References: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bootmem alloc functions are supposed to panic if allocation fails unless a
*_nopanic() function is used. However, if slab is available this is not the
case currently, and the function might return a NULL.

Currect it to panic on failed allocations even if slab is available.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/bootmem.c   | 9 ---------
 mm/nobootmem.c | 6 ------
 2 files changed, 15 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 1324cd7..198a92f 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -763,9 +763,6 @@ void * __init ___alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
-	if (WARN_ON_ONCE(slab_is_available()))
-		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
-
 	return  ___alloc_bootmem_node(pgdat, size, align, goal, 0);
 }
 
@@ -775,9 +772,6 @@ void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
 #ifdef MAX_DMA32_PFN
 	unsigned long end_pfn;
 
-	if (WARN_ON_ONCE(slab_is_available()))
-		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
-
 	/* update goal according ...MAX_DMA32_PFN */
 	end_pfn = pgdat->node_start_pfn + pgdat->node_spanned_pages;
 
@@ -839,9 +833,6 @@ void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
-	if (WARN_ON_ONCE(slab_is_available()))
-		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
-
 	return ___alloc_bootmem_node(pgdat, size, align,
 				     goal, ARCH_LOW_ADDRESS_LIMIT);
 }
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index b8294fc..7c4c608 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -371,9 +371,6 @@ void * __init ___alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
-	if (WARN_ON_ONCE(slab_is_available()))
-		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
-
 	return ___alloc_bootmem_node(pgdat, size, align, goal, 0);
 }
 
@@ -424,9 +421,6 @@ void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
-	if (WARN_ON_ONCE(slab_is_available()))
-		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
-
 	return ___alloc_bootmem_node(pgdat, size, align, goal,
 				     ARCH_LOW_ADDRESS_LIMIT);
 }
-- 
1.8.0

