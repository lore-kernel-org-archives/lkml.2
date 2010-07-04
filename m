Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab0GDHCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 03:02:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64029 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab0GDHB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 03:01:59 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 13/23] x86, lmb: Add lmb_x86_register_active_regions() and lmb_x86_hole_size()
Date: Sat,  3 Jul 2010 23:56:17 -0700
Message-Id: <1278226587-31213-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1278226587-31213-1-git-send-email-yinghai@kernel.org>
References: <1278226587-31213-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0203.4C30319A.0206,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lmb_x86_register_active_regions() will be used to fill early_node_map,
the result will be lmb.memory.region AND numa data

lmb_x86_hole_size will be used to find hole size on lmb.memory.region
with specified range.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/lmb.h |    4 ++
 arch/x86/mm/lmb.c          |   67 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
index 3fb32f3..f7595fd 100644
--- a/arch/x86/include/asm/lmb.h
+++ b/arch/x86/include/asm/lmb.h
@@ -11,4 +11,8 @@ void lmb_x86_free_range(u64 start, u64 end);
 struct range;
 int get_free_all_memory_range(struct range **rangep, int nodeid);
 
+void lmb_x86_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long last_pfn);
+u64 lmb_x86_hole_size(u64 start, u64 end);
+
 #endif
diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
index 5abcf00..d17e115 100644
--- a/arch/x86/mm/lmb.c
+++ b/arch/x86/mm/lmb.c
@@ -238,3 +238,70 @@ void __init lmb_x86_free_range(u64 start, u64 end)
 
 	lmb_free(start, end - start);
 }
+
+/*
+ * Finds an active region in the address range from start_pfn to last_pfn and
+ * returns its range in ei_startpfn and ei_endpfn for the lmb entry.
+ */
+static int __init lmb_x86_find_active_region(const struct lmb_region *ei,
+				  unsigned long start_pfn,
+				  unsigned long last_pfn,
+				  unsigned long *ei_startpfn,
+				  unsigned long *ei_endpfn)
+{
+	u64 align = PAGE_SIZE;
+
+	*ei_startpfn = round_up(ei->base, align) >> PAGE_SHIFT;
+	*ei_endpfn = round_down(ei->base + ei->size, align) >> PAGE_SHIFT;
+
+	/* Skip map entries smaller than a page */
+	if (*ei_startpfn >= *ei_endpfn)
+		return 0;
+
+	/* Skip if map is outside the node */
+	if (*ei_endpfn <= start_pfn || *ei_startpfn >= last_pfn)
+		return 0;
+
+	/* Check for overlaps */
+	if (*ei_startpfn < start_pfn)
+		*ei_startpfn = start_pfn;
+	if (*ei_endpfn > last_pfn)
+		*ei_endpfn = last_pfn;
+
+	return 1;
+}
+
+/* Walk the lmb.memory map and register active regions within a node */
+void __init lmb_x86_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long last_pfn)
+{
+	unsigned long ei_startpfn;
+	unsigned long ei_endpfn;
+	struct lmb_region *r;
+
+	for_each_lmb(memory, r)
+		if (lmb_x86_find_active_region(r, start_pfn, last_pfn,
+					   &ei_startpfn, &ei_endpfn))
+			add_active_range(nid, ei_startpfn, ei_endpfn);
+}
+
+/*
+ * Find the hole size (in bytes) in the memory range.
+ * @start: starting address of the memory range to scan
+ * @end: ending address of the memory range to scan
+ */
+u64 __init lmb_x86_hole_size(u64 start, u64 end)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long last_pfn = end >> PAGE_SHIFT;
+	unsigned long ei_startpfn, ei_endpfn, ram = 0;
+	struct lmb_region *r;
+
+	for_each_lmb(memory, r)
+		if (lmb_x86_find_active_region(r, start_pfn, last_pfn,
+					   &ei_startpfn, &ei_endpfn))
+			ram += ei_endpfn - ei_startpfn;
+
+	return end - start - ((u64)ram << PAGE_SHIFT);
+}
+
-- 
1.6.4.2

