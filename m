Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab0C2Cqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:46:43 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:55799 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab0C2Cqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:46:39 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 17/31] lmb: Add lmb_memory_size()
Date: Sun, 28 Mar 2010 19:43:10 -0700
Message-Id: <1269830604-26214-18-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0205.4BB01478.0037,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will return memory size in specified range according to lmb.memory.region

Try to share some code with lmb_free_memory_size() by passing get_free to
__lmb_memory_size().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    1 +
 mm/lmb.c            |   18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 51a8653..285f287 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -102,6 +102,7 @@ void lmb_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long last_pfn);
 u64 lmb_hole_size(u64 start, u64 end);
 u64 lmb_free_memory_size(u64 addr, u64 limit);
+u64 lmb_memory_size(u64 addr, u64 limit);
 
 #include <asm/lmb.h>
 
diff --git a/mm/lmb.c b/mm/lmb.c
index 233c40d..f49d6c8 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -756,7 +756,7 @@ void __init lmb_to_bootmem(u64 start, u64 end)
 }
 #endif
 
-u64 __init lmb_free_memory_size(u64 addr, u64 limit)
+static u64 __init __lmb_memory_size(u64 addr, u64 limit, bool get_free)
 {
 	int i, count;
 	struct range *range;
@@ -786,6 +786,10 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
 	}
 	subtract_range(range, count, 0, addr);
 	subtract_range(range, count, limit, -1ULL);
+
+	/* Subtract lmb.reserved.region in range ? */
+	if (!get_free)
+		goto sort_and_count_them;
 	for (i = 0; i < lmb.reserved.cnt; i++) {
 		struct lmb_property *r = &lmb.reserved.region[i];
 
@@ -798,6 +802,8 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
 
 		subtract_range(range, count, final_start, final_end);
 	}
+
+sort_and_count_them:
 	nr_range = clean_sort_range(range, count);
 
 	free_size = 0;
@@ -807,6 +813,16 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
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
 static int __init find_overlapped_early(u64 start, u64 end)
 {
 	int i;
-- 
1.6.4.2

