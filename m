Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0C3Ldv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 07:33:51 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:53593 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab0C3Lds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 07:33:48 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/29] lmb: Add lmb_memory_size()
Date: Tue, 30 Mar 2010 04:19:48 -0700
Message-Id: <1269948003-17221-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269948003-17221-1-git-send-email-yinghai@kernel.org>
References: <1269948003-17221-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0206.4BB1DECC.01C1,ss=1,fgs=0
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
index b874dc0..8332934 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -101,6 +101,7 @@ void lmb_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long last_pfn);
 u64 lmb_hole_size(u64 start, u64 end);
 u64 lmb_free_memory_size(u64 addr, u64 limit);
+u64 lmb_memory_size(u64 addr, u64 limit);
 
 #include <asm/lmb.h>
 
diff --git a/mm/lmb.c b/mm/lmb.c
index 1a686ff..d0fa04d 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -747,7 +747,7 @@ void __init lmb_to_bootmem(u64 start, u64 end)
 }
 #endif
 
-u64 __init lmb_free_memory_size(u64 addr, u64 limit)
+static u64 __init __lmb_memory_size(u64 addr, u64 limit, bool get_free)
 {
 	int i, count;
 	struct range *range;
@@ -777,6 +777,10 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
 	}
 	subtract_range(range, count, 0, addr);
 	subtract_range(range, count, limit, -1ULL);
+
+	/* Subtract lmb.reserved.region in range ? */
+	if (!get_free)
+		goto sort_and_count_them;
 	for (i = 0; i < lmb.reserved.cnt; i++) {
 		struct lmb_property *r = &lmb.reserved.region[i];
 
@@ -789,6 +793,8 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
 
 		subtract_range(range, count, final_start, final_end);
 	}
+
+sort_and_count_them:
 	nr_range = clean_sort_range(range, count);
 
 	free_size = 0;
@@ -798,6 +804,16 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
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
 u64 __init __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 				 u64 size, u64 align)
 {
-- 
1.6.4.2

