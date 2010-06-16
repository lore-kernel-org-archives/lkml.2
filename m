Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab0FPFtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:49:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28709 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420Ab0FPFqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:46:48 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 26/37] lmb: Move __alloc_memory_core_early() to nobootmem.c
Date: Tue, 15 Jun 2010 22:42:35 -0700
Message-Id: <1276666966-14259-27-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
References: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090209.4C186510.012A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can remove #ifdef in mm/page_alloc.c

and change that function to static

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/mm.h |    2 --
 mm/nobootmem.c     |   21 +++++++++++++++++++++
 mm/page_alloc.c    |   24 ------------------------
 3 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a85bb08..cfb71a6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1166,8 +1166,6 @@ int add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid);
 u64 __init find_memory_core_early(int nid, u64 size, u64 align,
 					u64 goal, u64 limit);
-void *__alloc_memory_core_early(int nodeid, u64 size, u64 align,
-				 u64 goal, u64 limit);
 typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
 extern void work_with_active_regions(int nid, work_fn_t work_fn, void *data);
 extern void sparse_memory_present_with_active_regions(int nid);
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index c17b5d0..3319056 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -40,6 +40,27 @@ unsigned long max_pfn;
 unsigned long saved_max_pfn;
 #endif
 
+static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
+					u64 goal, u64 limit)
+{
+	void *ptr;
+
+	u64 addr;
+
+	if (limit > lmb.current_limit)
+		limit = lmb.current_limit;
+
+	addr = find_memory_core_early(nid, size, align, goal, limit);
+
+	if (addr == LMB_ERROR)
+		return NULL;
+
+	ptr = phys_to_virt(addr);
+	memset(ptr, 0, size);
+	lmb_reserve_range(addr, addr + size, "BOOTMEM");
+	return ptr;
+}
+
 /*
  * free_bootmem_late - free bootmem pages directly to page allocator
  * @addr: starting address of the range
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ed53402..e7ea13a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3663,30 +3663,6 @@ int __init add_from_early_node_map(struct range *range, int az,
 	return nr_range;
 }
 
-#ifdef CONFIG_NO_BOOTMEM
-void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
-					u64 goal, u64 limit)
-{
-	void *ptr;
-
-	u64 addr;
-
-	if (limit > lmb.current_limit)
-		limit = lmb.current_limit;
-
-	addr = find_memory_core_early(nid, size, align, goal, limit);
-
-	if (addr == LMB_ERROR)
-		return NULL;
-
-	ptr = phys_to_virt(addr);
-	memset(ptr, 0, size);
-	lmb_reserve_range(addr, addr + size, "BOOTMEM");
-	return ptr;
-}
-#endif
-
-
 void __init work_with_active_regions(int nid, work_fn_t work_fn, void *data)
 {
 	int i;
-- 
1.6.4.2

