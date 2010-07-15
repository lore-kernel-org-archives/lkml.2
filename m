Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab0GOPNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:13:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60075 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933418Ab0GOPNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:13:40 -0400
Subject: [PATCH] kmemleak: Add support for NO_BOOTMEM configurations
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 15 Jul 2010 15:58:34 +0100
Message-ID: <20100715145834.20885.20341.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-83-g972d5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2010 14:58:34.0835 (UTC) FILETIME=[32BA3230:01CB242E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commits 08677214 and 59be5a8e, alloc_bootmem()/free_bootmem() and
friends use the early_res functions for memory management when
NO_BOOTMEM is enabled. This patch adds the kmemleak calls in the
corresponding code paths for bootmem allocations.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 kernel/early_res.c |    6 ++++++
 mm/page_alloc.c    |    5 +++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/early_res.c b/kernel/early_res.c
index 31aa933..7bfae88 100644
--- a/kernel/early_res.c
+++ b/kernel/early_res.c
@@ -7,6 +7,8 @@
 #include <linux/bootmem.h>
 #include <linux/mm.h>
 #include <linux/early_res.h>
+#include <linux/slab.h>
+#include <linux/kmemleak.h>
 
 /*
  * Early reserved memory areas.
@@ -319,6 +321,8 @@ void __init free_early(u64 start, u64 end)
 	struct early_res *r;
 	int i;
 
+	kmemleak_free_part(__va(start), end - start);
+
 	i = find_overlapped_early(start, end);
 	r = &early_res[i];
 	if (i >= max_early_res || r->end != end || r->start != start)
@@ -333,6 +337,8 @@ void __init free_early_partial(u64 start, u64 end)
 	struct early_res *r;
 	int i;
 
+	kmemleak_free_part(__va(start), end - start);
+
 	if (start == end)
 		return;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 431214b..68319dd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3659,6 +3659,11 @@ void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 		ptr = phys_to_virt(addr);
 		memset(ptr, 0, size);
 		reserve_early_without_check(addr, addr + size, "BOOTMEM");
+		/*
+		 * The min_count is set to 0 so that bootmem allocated blocks
+		 * are never reported as leaks.
+		 */
+		kmemleak_alloc(ptr, size, 0, 0);
 		return ptr;
 	}
 

