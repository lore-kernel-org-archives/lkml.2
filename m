Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab0C3L1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 07:27:25 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:51245 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab0C3L1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 07:27:21 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/29] lmb: Add lmb_find_area()
Date: Tue, 30 Mar 2010 04:19:38 -0700
Message-Id: <1269948003-17221-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269948003-17221-1-git-send-email-yinghai@kernel.org>
References: <1269948003-17221-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BB1DEBF.008E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will try find area according with size/align in specified range (start, end).

Need use it find correct buffer for new lmb.reserved.region. and avoid to find
the area is overlapped with area that we are going to reserved.
becase lmb_find_area() will honor goal/limit.

also make it more easy for x86 to use lmb.
x86 early_res is using find/reserve pattern instead of alloc.

When we need temporaray buff for range array etc for range work, if We are using
lmb_alloc(), We will need to add some post fix code for buffer that is used
by range array, because it is in the lmb.reserved already.

-v2: Change name to lmb_find_area() according to Michael Ellerman
     use __lmb_alloc_base() for find_lmb_area according to Ben

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    4 +++
 mm/lmb.c            |   70 ++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index e14ea8d..4cf2f3b 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -83,6 +83,10 @@ lmb_end_pfn(struct lmb_region *type, unsigned long region_nr)
 	       lmb_size_pages(type, region_nr);
 }
 
+u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
+			 u64 size, u64 align);
+u64 lmb_find_area(u64 start, u64 end, u64 size, u64 align);
+
 #include <asm/lmb.h>
 
 #endif /* __KERNEL__ */
diff --git a/mm/lmb.c b/mm/lmb.c
index 65b62dc..30c6917 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -11,9 +11,13 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/types.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/lmb.h>
+#include <linux/bootmem.h>
+#include <linux/mm.h>
+#include <linux/range.h>
 
 #define LMB_ALLOC_ANYWHERE	0
 
@@ -393,7 +397,7 @@ u64 __init lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 	return alloc;
 }
 
-u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
+static u64 __init __lmb_find_base(u64 size, u64 align, u64 max_addr)
 {
 	long i, j;
 	u64 base = 0;
@@ -426,8 +430,6 @@ u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 			j = lmb_overlaps_region(&lmb.reserved, base, size);
 			if (j < 0) {
 				/* this area isn't reserved, take it */
-				if (lmb_add_region(&lmb.reserved, base, size) < 0)
-					return 0;
 				return base;
 			}
 			res_base = lmb.reserved.region[j].base;
@@ -436,7 +438,22 @@ u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 			base = lmb_align_down(res_base - size, align);
 		}
 	}
-	return 0;
+	return -1ULL;
+}
+
+u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
+{
+	u64 base;
+
+	base = __lmb_find_base(size, align, max_addr);
+
+	if (base == -1ULL)
+		return 0;
+
+	if (lmb_add_region(&lmb.reserved, base, size) < 0)
+		return 0;
+
+	return base;
 }
 
 /* You must call lmb_analyze() before this. */
@@ -546,3 +563,48 @@ int lmb_find(struct lmb_property *res)
 	}
 	return -1;
 }
+
+u64 __init __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
+				 u64 size, u64 align)
+{
+	u64 final_start, final_end;
+	u64 mem;
+
+	final_start = max(ei_start, start);
+	final_end = min(ei_last, end);
+
+	if (final_start >= final_end)
+		return -1ULL;
+
+	mem = __lmb_find_base(size, align, final_end);
+
+	if (mem == -1ULL)
+		return -1ULL;
+
+	lmb_free(mem, size);
+	if (mem >= final_start)
+		return mem;
+
+	return -1ULL;
+}
+
+/*
+ * Find a free area with specified alignment in a specific range.
+ */
+u64 __init lmb_find_area(u64 start, u64 end, u64 size, u64 align)
+{
+	int i;
+
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		u64 ei_start = lmb.memory.region[i].base;
+		u64 ei_last = ei_start + lmb.memory.region[i].size;
+		u64 addr;
+
+		addr = __lmb_find_area(ei_start, ei_last, start, end,
+					 size, align);
+
+		if (addr != -1ULL)
+			return addr;
+	}
+	return -1ULL;
+}
-- 
1.6.4.2

