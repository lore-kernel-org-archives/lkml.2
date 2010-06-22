Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054Ab0FVR3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:29:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33247 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759023Ab0FVR24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:28:56 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 17/25] x86, lmb: Add lmb_memory_in_range()
Date: Tue, 22 Jun 2010 10:26:46 -0700
Message-Id: <1277227614-11581-18-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277227614-11581-1-git-send-email-yinghai@kernel.org>
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C20F2B7.008A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will return memory size in specified range according to lmb.memory.region

Try to share some code with lmb_free_memory_in_range() by passing get_free to
__lmb_memory_in_range().

-v2: Ben want _in_range in the name instead of size

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/lmb.h |    1 +
 arch/x86/mm/lmb.c          |   18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
index 3a304f8..749c224 100644
--- a/arch/x86/include/asm/lmb.h
+++ b/arch/x86/include/asm/lmb.h
@@ -16,5 +16,6 @@ void lmb_register_active_regions(int nid, unsigned long start_pfn,
 u64 lmb_hole_size(u64 start, u64 end);
 u64 lmb_find_in_range_node(int nid, u64 start, u64 end, u64 size, u64 align);
 u64 lmb_free_memory_in_range(u64 addr, u64 limit);
+u64 lmb_memory_in_range(u64 addr, u64 limit);
 
 #endif
diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
index 991dd55..bd2f60b 100644
--- a/arch/x86/mm/lmb.c
+++ b/arch/x86/mm/lmb.c
@@ -217,7 +217,7 @@ void __init lmb_to_bootmem(u64 start, u64 end)
 }
 #endif
 
-u64 __init lmb_free_memory_in_range(u64 addr, u64 limit)
+static u64 __init __lmb_memory_in_range(u64 addr, u64 limit, bool get_free)
 {
 	int i, count;
 	struct range *range;
@@ -246,6 +246,10 @@ u64 __init lmb_free_memory_in_range(u64 addr, u64 limit)
 	}
 	subtract_range(range, count, 0, addr);
 	subtract_range(range, count, limit, -1ULL);
+
+	/* Subtract lmb.reserved.region in range ? */
+	if (!get_free)
+		goto sort_and_count_them;
 	for_each_lmb(reserved, r) {
 		final_start = PFN_DOWN(r->base);
 		final_end = PFN_UP(r->base + r->size);
@@ -256,6 +260,8 @@ u64 __init lmb_free_memory_in_range(u64 addr, u64 limit)
 
 		subtract_range(range, count, final_start, final_end);
 	}
+
+sort_and_count_them:
 	nr_range = clean_sort_range(range, count);
 
 	free_size = 0;
@@ -265,6 +271,16 @@ u64 __init lmb_free_memory_in_range(u64 addr, u64 limit)
 	return free_size << PAGE_SHIFT;
 }
 
+u64 __init lmb_free_memory_in_range(u64 addr, u64 limit)
+{
+	return __lmb_memory_in_range(addr, limit, true);
+}
+
+u64 __init lmb_memory_in_range(u64 addr, u64 limit)
+{
+	return __lmb_memory_in_range(addr, limit, false);
+}
+
 void __init lmb_reserve_range(u64 start, u64 end, char *name)
 {
 	if (start == end)
-- 
1.6.4.2

