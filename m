Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030Ab0EDOo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:44:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48728 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932374Ab0EDOo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:44:56 -0400
Subject: [RFC PATCH] kmemleak: Add support for NO_BOOTMEM configurations
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 04 May 2010 15:33:30 +0100
Message-ID: <20100504143330.20420.30310.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-60-g0641
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 May 2010 14:33:31.0136 (UTC) FILETIME=[C4B5F000:01CAEB96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commits 08677214 and 59be5a8e, alloc_bootmem()/free_bootmem() and
friends use the early_res functions for memory management when
NO_BOOTMEM is enabled. This patch adds the kmemleak calls in the
corresponding code paths for bootmem allocations.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 mm/bootmem.c    |    2 ++
 mm/page_alloc.c |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 58c66cc..0747f68 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -435,6 +435,7 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 {
 #ifdef CONFIG_NO_BOOTMEM
 	free_early(physaddr, physaddr + size);
+	kmemleak_free_part(__va(physaddr), size);
 #else
 	unsigned long start, end;
 
@@ -460,6 +461,7 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
 {
 #ifdef CONFIG_NO_BOOTMEM
 	free_early(addr, addr + size);
+	kmemleak_free_part(__va(addr), size);
 #else
 	unsigned long start, end;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d03c946..e1bd32b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3440,6 +3440,7 @@ void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 		ptr = phys_to_virt(addr);
 		memset(ptr, 0, size);
 		reserve_early_without_check(addr, addr + size, "BOOTMEM");
+		kmemleak_alloc(ptr, size, 1, 0);
 		return ptr;
 	}
 

