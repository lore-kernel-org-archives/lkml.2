Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1GLJSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:18:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61601 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1GLJQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:16:19 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/13] memblock: Implement for_each_free_mem_range()
Date: Tue, 12 Jul 2011 11:15:59 +0200
Message-Id: <1310462166-31469-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310462166-31469-1-git-send-email-tj@kernel.org>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement for_each_free_mem_range() which iterates over free memory
areas according to memblock (memory && !reserved).  This will be used
to simplify memblock users.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |   20 ++++++++++++
 mm/memblock.c            |   76 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index e78a9ad..013dfe0 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -61,6 +61,26 @@ extern long memblock_remove(phys_addr_t base, phys_addr_t size);
 extern long memblock_free(phys_addr_t base, phys_addr_t size);
 extern long memblock_reserve(phys_addr_t base, phys_addr_t size);
 
+extern void __next_free_mem_range(u64 *idx, int nid, phys_addr_t *out_start,
+				  phys_addr_t *out_end, int *out_nid);
+
+/**
+ * for_each_free_mem_range - iterate through free memblock areas
+ * @i: u64 used as loop variable
+ * @nid: node selector, %MAX_NUMNODES for all nodes
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ * @p_nid: ptr to int for nid of the range, can be %NULL
+ *
+ * Walks over free (memory && !reserved) areas of memblock.  Available as
+ * soon as memblock is initialized.
+ */
+#define for_each_free_mem_range(i, nid, p_start, p_end, p_nid)		\
+	for (i = 0,							\
+	     __next_free_mem_range(&i, nid, p_start, p_end, p_nid);	\
+	     i != (u64)ULLONG_MAX;					\
+	     __next_free_mem_range(&i, nid, p_start, p_end, p_nid))
+
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 extern int memblock_set_node(phys_addr_t base, phys_addr_t size, int nid);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 766adec..4d318bf 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -461,6 +461,82 @@ long __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 	return memblock_add_region(_rgn, base, size);
 }
 
+/**
+ * __next_free_mem_range - next function for for_each_free_mem_range()
+ * @idx: pointer to u64 loop variable
+ * @nid: nid: node selector, %MAX_NUMNODES for all nodes
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ * @p_nid: ptr to int for nid of the range, can be %NULL
+ *
+ * Find the first free area from *@idx which matches @nid, fill the out
+ * parameters, and update *@idx for the next iteration.  The lower 32bit of
+ * *@idx contains index into memory region and the upper 32bit indexes the
+ * areas before each reserved region.  For example, if reserved regions
+ * look like the following,
+ *
+ *	0:[0-16), 1:[32-48), 2:[128-130)
+ *
+ * The upper 32bit indexes the following regions.
+ *
+ *	0:[0-0), 1:[16-32), 2:[48-128), 3:[130-MAX)
+ *
+ * As both region arrays are sorted, the function advances the two indices
+ * in lockstep and returns each intersection.
+ */
+void __init_memblock __next_free_mem_range(u64 *idx, int nid,
+					   phys_addr_t *out_start,
+					   phys_addr_t *out_end, int *out_nid)
+{
+	struct memblock_type *mem = &memblock.memory;
+	struct memblock_type *rsv = &memblock.reserved;
+	int mi = *idx & 0xffffffff;
+	int ri = *idx >> 32;
+
+	for ( ; mi < mem->cnt; mi++) {
+		struct memblock_region *m = &mem->regions[mi];
+		phys_addr_t m_start = m->base;
+		phys_addr_t m_end = m->base + m->size;
+
+		/* only memory regions are associated with nodes, check it */
+		if (nid != MAX_NUMNODES && nid != memblock_get_region_node(m))
+			continue;
+
+		/* scan areas before each reservation for intersection */
+		for ( ; ri < rsv->cnt + 1; ri++) {
+			struct memblock_region *r = &rsv->regions[ri];
+			phys_addr_t r_start = ri ? r[-1].base + r[-1].size : 0;
+			phys_addr_t r_end = ri < rsv->cnt ? r->base : ULLONG_MAX;
+
+			/* if ri advanced past mi, break out to advance mi */
+			if (r_start >= m_end)
+				break;
+			/* if the two regions intersect, we're done */
+			if (m_start < r_end) {
+				if (out_start)
+					*out_start = max(m_start, r_start);
+				if (out_end)
+					*out_end = min(m_end, r_end);
+				if (out_nid)
+					*out_nid = memblock_get_region_node(m);
+				/*
+				 * The region which ends first is advanced
+				 * for the next iteration.
+				 */
+				if (m_end <= r_end)
+					mi++;
+				else
+					ri++;
+				*idx = (u32)mi | (u64)ri << 32;
+				return;
+			}
+		}
+	}
+
+	/* signal end of iteration */
+	*idx = ULLONG_MAX;
+}
+
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /*
  * Common iterator interface used to define for_each_mem_range().
-- 
1.7.6

