Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab0EHPXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:23:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16714 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab0EHPW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:22:28 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/22] lmb: Add lmb_register_active_regions() and lmb_hole_size()
Date: Sat,  8 May 2010 08:17:27 -0700
Message-Id: <1273331860-14325-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090203.4BE58172.0169,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lmb_register_active_regions() will be used to fill early_node_map,
the result will be lmb.memory.region AND numa data

lmb_hole_size will be used to find hole size on lmb.memory.region
with specified range.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    4 +++
 mm/lmb.c            |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index aaef2ca..85918a4 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -96,6 +96,10 @@ void lmb_to_bootmem(u64 start, u64 end);
 struct range;
 int get_free_all_memory_range(struct range **rangep, int nodeid);
 
+void lmb_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long last_pfn);
+u64 lmb_hole_size(u64 start, u64 end);
+
 #include <asm/lmb.h>
 
 #endif /* __KERNEL__ */
diff --git a/mm/lmb.c b/mm/lmb.c
index 2e19df9..b9607fc 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -789,3 +789,71 @@ u64 __init __weak lmb_find_area(u64 start, u64 end, u64 size, u64 align)
 	}
 	return LMB_ERROR;
 }
+/*
+ * Finds an active region in the address range from start_pfn to last_pfn and
+ * returns its range in ei_startpfn and ei_endpfn for the lmb entry.
+ */
+static int __init lmb_find_active_region(const struct lmb_property *ei,
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
+void __init lmb_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long last_pfn)
+{
+	unsigned long ei_startpfn;
+	unsigned long ei_endpfn;
+	int i;
+
+	for (i = 0; i < lmb.memory.cnt; i++)
+		if (lmb_find_active_region(&lmb.memory.region[i],
+					    start_pfn, last_pfn,
+					    &ei_startpfn, &ei_endpfn))
+			add_active_range(nid, ei_startpfn, ei_endpfn);
+}
+
+/*
+ * Find the hole size (in bytes) in the memory range.
+ * @start: starting address of the memory range to scan
+ * @end: ending address of the memory range to scan
+ */
+u64 __init lmb_hole_size(u64 start, u64 end)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long last_pfn = end >> PAGE_SHIFT;
+	unsigned long ei_startpfn, ei_endpfn, ram = 0;
+	int i;
+
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		if (lmb_find_active_region(&lmb.memory.region[i],
+					    start_pfn, last_pfn,
+					    &ei_startpfn, &ei_endpfn))
+			ram += ei_endpfn - ei_startpfn;
+	}
+	return end - start - ((u64)ram << PAGE_SHIFT);
+}
+
-- 
1.6.4.2

