Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0ENAYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:24:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53786 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab0ENAYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:24:33 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/35] x86, lmb: Add lmb_memory_size()
Date: Thu, 13 May 2010 17:19:35 -0700
Message-Id: <1273796396-29649-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090203.4BEC97C4.007E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will return memory size in specified range according to lmb.memory.region

Try to share some code with lmb_free_memory_size() by passing get_free to
__lmb_memory_size().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/lmb.h |    1 +
 arch/x86/mm/lmb.c          |   18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
index 4fb94b5..dd42ac1 100644
--- a/arch/x86/include/asm/lmb.h
+++ b/arch/x86/include/asm/lmb.h
@@ -17,5 +17,6 @@ void lmb_register_active_regions(int nid, unsigned long start_pfn,
 u64 lmb_hole_size(u64 start, u64 end);
 u64 lmb_find_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
 u64 lmb_free_memory_size(u64 addr, u64 limit);
+u64 lmb_memory_size(u64 addr, u64 limit);
 
 #endif
diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
index 6c69e99..19a5f49 100644
--- a/arch/x86/mm/lmb.c
+++ b/arch/x86/mm/lmb.c
@@ -226,7 +226,7 @@ void __init lmb_to_bootmem(u64 start, u64 end)
 }
 #endif
 
-u64 __init lmb_free_memory_size(u64 addr, u64 limit)
+static u64 __init __lmb_memory_size(u64 addr, u64 limit, bool get_free)
 {
 	int i, count;
 	struct range *range;
@@ -256,6 +256,10 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
 	}
 	subtract_range(range, count, 0, addr);
 	subtract_range(range, count, limit, -1ULL);
+
+	/* Subtract lmb.reserved.region in range ? */
+	if (!get_free)
+		goto sort_and_count_them;
 	for (i = 0; i < lmb.reserved.cnt; i++) {
 		struct lmb_region *r = &lmb.reserved.regions[i];
 
@@ -268,6 +272,8 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
 
 		subtract_range(range, count, final_start, final_end);
 	}
+
+sort_and_count_them:
 	nr_range = clean_sort_range(range, count);
 
 	free_size = 0;
@@ -277,6 +283,16 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
 	return free_size << PAGE_SHIFT;
 }
 
+u64 __init lmb_free_memory_size(u64 addr, u64 limit)
+{
+	return __lmb_memory_size(addr, limit, true);
+}
+
+u64 __init lmb_memory_size(u64 addr, u64 limit)
+{
+	return __lmb_memory_size(addr, limit, false);
+}
+
 void __init lmb_add_memory(u64 start, u64 end)
 {
 	lmb_add_region(&lmb.memory, start, end - start);
-- 
1.6.4.2

