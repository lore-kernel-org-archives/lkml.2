Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0EHPUM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:20:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63627 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab0EHPUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:20:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/22] lmb: Add lmb_find_area()
Date: Sat,  8 May 2010 08:17:22 -0700
Message-Id: <1273331860-14325-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4BE580FB.0098,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will try find area according with size/align in specified range (start, end).

lmb_find_area() will honor goal/limit.

also make it more easy for x86 to use lmb.
x86 early_res is using find/reserve pattern instead of alloc.

When we need temporaray buff for range array etc for range work, if We are using
lmb_alloc(), We will need to add some post fix code for buffer that is used
by range array, because it is in the lmb.reserved already. and have to call
extra lmb_free().

-v2: Change name to lmb_find_area() according to Michael Ellerman
-v3: Add generic weak version __lmb_find_area()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    4 ++++
 mm/lmb.c            |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index d2e456b..211cece 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -84,6 +84,10 @@ lmb_end_pfn(struct lmb_region *type, unsigned long region_nr)
 	       lmb_size_pages(type, region_nr);
 }
 
+u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
+			 u64 size, u64 align);
+u64 lmb_find_area(u64 start, u64 end, u64 size, u64 align);
+
 #include <asm/lmb.h>
 
 #endif /* __KERNEL__ */
diff --git a/mm/lmb.c b/mm/lmb.c
index d130527..888937d 100644
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
 
@@ -559,3 +563,47 @@ int lmb_find(struct lmb_property *res)
 	}
 	return -1;
 }
+
+u64 __init __weak __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
+				 u64 size, u64 align)
+{
+	u64 final_start, final_end;
+	u64 mem;
+
+	final_start = max(ei_start, start);
+	final_end = min(ei_last, end);
+
+	if (final_start >= final_end)
+		return LMB_ERROR;
+
+	mem = __lmb_find_base(size, align, final_end);
+
+	if (mem == LMB_ERROR)
+		return LMB_ERROR;
+
+	if (mem >= final_start)
+		return mem;
+
+	return LMB_ERROR;
+}
+
+/*
+ * Find a free area with specified alignment in a specific range.
+ */
+u64 __init __weak lmb_find_area(u64 start, u64 end, u64 size, u64 align)
+{
+	int i;
+
+	for (i = lmb.memory.cnt - 1; i >= 0; i--) {
+		u64 ei_start = lmb.memory.region[i].base;
+		u64 ei_last = ei_start + lmb.memory.region[i].size;
+		u64 addr;
+
+		addr = __lmb_find_area(ei_start, ei_last, start, end,
+					 size, align);
+
+		if (addr != LMB_ERROR)
+			return addr;
+	}
+	return LMB_ERROR;
+}
-- 
1.6.4.2

