Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1BXN7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 08:59:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63838 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab1BXN7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 08:59:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ClTVRSMJhrkkBTwfmpsAviEaO6tFCHqM2lf80aALDbrAuM3PriKoNI2pfzC68S1vXn
         4HbCzCHXwYhAH9ibtI8Sfo1T0Jn/xWEAJK9nUyTmlUZvXZI4TL/wD+gGMXBJkrudTbc7
         +sEgYK9FHSMyFUyZzCwhdkLc50HxViOmM8PjM=
Date: Thu, 24 Feb 2011 14:59:08 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bootmem: Move __alloc_memory_core_early() to nobootmem.c
Message-ID: <20110224135908.GJ7840@htj.dyndns.org>
References: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
 <1297120632-24933-11-git-send-email-yinghai@kernel.org>
 <20110222154806.0be18267.akpm@linux-foundation.org>
 <4D660375.10005@kernel.org>
 <4D6604DD.8000500@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6604DD.8000500@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8bc1f91e1f0e977fb95b11d8fa686f5091888110 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Thu, 24 Feb 2011 14:43:06 +0100

Now that bootmem.c and nobootmem.c are separate, there's no reason to
define __alloc_memory_core_early(), which is used only by nobootmem,
inside #ifdef in page_alloc.c.  Move it to nobootmem.c and make it
static.

This patch doesn't introduce any behavior change.

-tj: Updated commit description.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Committed to misc:x86-numa with description updated.  Thanks.

 include/linux/mm.h |    2 --
 mm/nobootmem.c     |   25 +++++++++++++++++++++++++
 mm/page_alloc.c    |   28 ----------------------------
 3 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f6385fc..679300c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1309,8 +1309,6 @@ int add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid);
 u64 __init find_memory_core_early(int nid, u64 size, u64 align,
 					u64 goal, u64 limit);
-void *__alloc_memory_core_early(int nodeid, u64 size, u64 align,
-				 u64 goal, u64 limit);
 typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
 extern void work_with_active_regions(int nid, work_fn_t work_fn, void *data);
 extern void sparse_memory_present_with_active_regions(int nid);
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 6a018e4..e2bdb07 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -40,6 +40,31 @@ unsigned long max_pfn;
 unsigned long saved_max_pfn;
 #endif
 
+static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
+					u64 goal, u64 limit)
+{
+	void *ptr;
+	u64 addr;
+
+	if (limit > memblock.current_limit)
+		limit = memblock.current_limit;
+
+	addr = find_memory_core_early(nid, size, align, goal, limit);
+
+	if (addr == MEMBLOCK_ERROR)
+		return NULL;
+
+	ptr = phys_to_virt(addr);
+	memset(ptr, 0, size);
+	memblock_x86_reserve_range(addr, addr + size, "BOOTMEM");
+	/*
+	 * The min_count is set to 0 so that bootmem allocated blocks
+	 * are never reported as leaks.
+	 */
+	kmemleak_alloc(ptr, size, 0, 0);
+	return ptr;
+}
+
 /*
  * free_bootmem_late - free bootmem pages directly to page allocator
  * @addr: starting address of the range
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a243a7f..6035136 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3780,34 +3780,6 @@ int __init add_from_early_node_map(struct range *range, int az,
 	return nr_range;
 }
 
-#ifdef CONFIG_NO_BOOTMEM
-void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
-					u64 goal, u64 limit)
-{
-	void *ptr;
-	u64 addr;
-
-	if (limit > memblock.current_limit)
-		limit = memblock.current_limit;
-
-	addr = find_memory_core_early(nid, size, align, goal, limit);
-
-	if (addr == MEMBLOCK_ERROR)
-		return NULL;
-
-	ptr = phys_to_virt(addr);
-	memset(ptr, 0, size);
-	memblock_x86_reserve_range(addr, addr + size, "BOOTMEM");
-	/*
-	 * The min_count is set to 0 so that bootmem allocated blocks
-	 * are never reported as leaks.
-	 */
-	kmemleak_alloc(ptr, size, 0, 0);
-	return ptr;
-}
-#endif
-
-
 void __init work_with_active_regions(int nid, work_fn_t work_fn, void *data)
 {
 	int i;
-- 
1.7.1

