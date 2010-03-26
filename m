Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab0CZW1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:27:23 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:52661 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab0CZWZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:25:57 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/24] lmb: Add find_lmb_area()
Date: Fri, 26 Mar 2010 15:21:36 -0700
Message-Id: <1269642114-16588-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269642114-16588-1-git-send-email-yinghai@kernel.org>
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BAD3439.0165,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will try find area according with size/align in specified range (start, end).

Need use it find correct buffer for new lmb.reserved.region.

also make it more easy for x86 to use lmb.
x86 early_res is using find/reserve pattern instead of alloc.

find_lmb_area() will hohor goal

When we need temperary buff for range array etc for range work, if We are using
lmb_alloc(), We will need to add some post fix code for buffer that is used
by range array, because it is in the lmb.reserved already.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    4 ++
 mm/lmb.c            |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index e14ea8d..05234bd 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -83,6 +83,10 @@ lmb_end_pfn(struct lmb_region *type, unsigned long region_nr)
 	       lmb_size_pages(type, region_nr);
 }
 
+u64 __find_lmb_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
+			 u64 size, u64 align);
+u64 find_lmb_area(u64 start, u64 end, u64 size, u64 align);
+
 #include <asm/lmb.h>
 
 #endif /* __KERNEL__ */
diff --git a/mm/lmb.c b/mm/lmb.c
index 65b62dc..d5d5dc4 100644
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
 
@@ -546,3 +550,80 @@ int lmb_find(struct lmb_property *res)
 	}
 	return -1;
 }
+
+static int __init find_overlapped_early(u64 start, u64 end)
+{
+	int i;
+	struct lmb_property *r;
+
+	for (i = 0; i < lmb.reserved.cnt && lmb.reserved.region[i].size; i++) {
+		r = &lmb.reserved.region[i];
+		if (end > r->base && start < (r->base + r->size))
+			break;
+	}
+
+	return i;
+}
+
+/* Check for already reserved areas */
+static inline bool __init bad_addr(u64 *addrp, u64 size, u64 align)
+{
+	int i;
+	u64 addr = *addrp;
+	bool changed = false;
+	struct lmb_property *r;
+again:
+	i = find_overlapped_early(addr, addr + size);
+	r = &lmb.reserved.region[i];
+	if (i < lmb.reserved.cnt && r->size) {
+		*addrp = addr = round_up(r->base + r->size, align);
+		changed = true;
+		goto again;
+	}
+	return changed;
+}
+
+u64 __init __find_lmb_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
+				 u64 size, u64 align)
+{
+	u64 addr, last;
+
+	addr = round_up(ei_start, align);
+	if (addr < start)
+		addr = round_up(start, align);
+	if (addr >= ei_last)
+		goto out;
+	while (bad_addr(&addr, size, align) && addr+size <= ei_last)
+		;
+	last = addr + size;
+	if (last > ei_last)
+		goto out;
+	if (last > end)
+		goto out;
+
+	return addr;
+
+out:
+	return -1ULL;
+}
+
+/*
+ * Find a free area with specified alignment in a specific range.
+ */
+u64 __init find_lmb_area(u64 start, u64 end, u64 size, u64 align)
+{
+	int i;
+
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		u64 ei_start = lmb.memory.region[i].base;
+		u64 ei_last = ei_start + lmb.memory.region[i].size;
+		u64 addr;
+
+		addr = __find_lmb_area(ei_start, ei_last, start, end,
+					 size, align);
+
+		if (addr != -1ULL)
+			return addr;
+	}
+	return -1ULL;
+}
-- 
1.6.4.2

