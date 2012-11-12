Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab2KLQec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:34:32 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47759 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2KLQe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:34:29 -0500
From: Joonsoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 3/4] bootmem: remove alloc_arch_preferred_bootmem()
Date: Tue, 13 Nov 2012 01:31:54 +0900
Message-Id: <1352737915-30906-3-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352737915-30906-1-git-send-email-js1304@gmail.com>
References: <1352737915-30906-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name of function is not suitable for now.
And removing function and inlining it's code to each call sites
makes code more understandable.

Additionally, we shouldn't do allocation from bootmem
when slab_is_available(), so directly return kmalloc*'s return value.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 6f62c03e..cd5c5a2 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -583,14 +583,6 @@ find_block:
 	return NULL;
 }
 
-static void * __init alloc_arch_preferred_bootmem(bootmem_data_t *bdata,
-					unsigned long size, unsigned long align,
-					unsigned long goal, unsigned long limit)
-{
-	if (WARN_ON_ONCE(slab_is_available()))
-		return kzalloc(size, GFP_NOWAIT);
-}
-
 static void * __init alloc_bootmem_core(unsigned long size,
 					unsigned long align,
 					unsigned long goal,
@@ -599,9 +591,8 @@ static void * __init alloc_bootmem_core(unsigned long size,
 	bootmem_data_t *bdata;
 	void *region;
 
-	region = alloc_arch_preferred_bootmem(NULL, size, align, goal, limit);
-	if (region)
-		return region;
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc(size, GFP_NOWAIT);
 
 	list_for_each_entry(bdata, &bdata_list, list) {
 		if (goal && bdata->node_low_pfn <= PFN_DOWN(goal))
@@ -699,11 +690,9 @@ void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
 {
 	void *ptr;
 
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc(size, GFP_NOWAIT);
 again:
-	ptr = alloc_arch_preferred_bootmem(pgdat->bdata, size,
-					   align, goal, limit);
-	if (ptr)
-		return ptr;
 
 	/* do not panic in alloc_bootmem_bdata() */
 	if (limit && goal + size > limit)
-- 
1.7.9.5

