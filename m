Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab0GFWnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 18:43:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31521 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab0GFWnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 18:43:24 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 43/49] x86, memblock: Add memblock_x86_memory_in_range()
Date: Tue,  6 Jul 2010 15:39:36 -0700
Message-Id: <1278455982-24621-44-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
References: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C33B172.022E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will return memory size in specified range according to memblock.memory.region

Try to share some code with memblock_x86_free_memory_in_range() by passing get_free to
__memblock_x86_memory_in_range().

-v2: Ben want _in_range in the name instead of size

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/memblock.h |    1 +
 arch/x86/mm/memblock.c          |   18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index fc3c230..2c304bb 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -16,5 +16,6 @@ void memblock_x86_register_active_regions(int nid, unsigned long start_pfn,
 u64 memblock_x86_hole_size(u64 start, u64 end);
 u64 memblock_x86_find_in_range_node(int nid, u64 start, u64 end, u64 size, u64 align);
 u64 memblock_x86_free_memory_in_range(u64 addr, u64 limit);
+u64 memblock_x86_memory_in_range(u64 addr, u64 limit);
 
 #endif
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index b04b43b..b10258d 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -217,7 +217,7 @@ void __init memblock_x86_to_bootmem(u64 start, u64 end)
 }
 #endif
 
-u64 __init memblock_x86_free_memory_in_range(u64 addr, u64 limit)
+static u64 __init __memblock_x86_memory_in_range(u64 addr, u64 limit, bool get_free)
 {
 	int i, count;
 	struct range *range;
@@ -246,6 +246,10 @@ u64 __init memblock_x86_free_memory_in_range(u64 addr, u64 limit)
 	}
 	subtract_range(range, count, 0, addr);
 	subtract_range(range, count, limit, -1ULL);
+
+	/* Subtract memblock.reserved.region in range ? */
+	if (!get_free)
+		goto sort_and_count_them;
 	for_each_memblock(reserved, r) {
 		final_start = PFN_DOWN(r->base);
 		final_end = PFN_UP(r->base + r->size);
@@ -256,6 +260,8 @@ u64 __init memblock_x86_free_memory_in_range(u64 addr, u64 limit)
 
 		subtract_range(range, count, final_start, final_end);
 	}
+
+sort_and_count_them:
 	nr_range = clean_sort_range(range, count);
 
 	free_size = 0;
@@ -265,6 +271,16 @@ u64 __init memblock_x86_free_memory_in_range(u64 addr, u64 limit)
 	return free_size << PAGE_SHIFT;
 }
 
+u64 __init memblock_x86_free_memory_in_range(u64 addr, u64 limit)
+{
+	return __memblock_x86_memory_in_range(addr, limit, true);
+}
+
+u64 __init memblock_x86_memory_in_range(u64 addr, u64 limit)
+{
+	return __memblock_x86_memory_in_range(addr, limit, false);
+}
+
 void __init memblock_x86_reserve_range(u64 start, u64 end, char *name)
 {
 	if (start == end)
-- 
1.6.4.2

