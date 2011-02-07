Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1BGXTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:19:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:57721 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab1BGXTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:19:51 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/11] memblock: Make find_memory_core_early() find from top-down
Date: Mon,  7 Feb 2011 15:17:05 -0800
Message-Id: <1297120632-24933-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
References: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D507DC1.0051,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is used for find ram in node or bootmem type.

We should make it top-down so it will be consistent to memblock_find.

Suggested-by: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 mm/page_alloc.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a873e61..887ce3b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3616,6 +3616,34 @@ static int __meminit next_active_region_index_in_nid(int index, int nid)
 	return -1;
 }
 
+/*
+ * Basic iterator support. Return the last range of PFNs for a node
+ * Note: nid == MAX_NUMNODES returns last region regardless of node
+ */
+static int __meminit last_active_region_index_in_nid(int nid)
+{
+	int i;
+
+	for (i = nr_nodemap_entries - 1; i >= 0; i--)
+		if (nid == MAX_NUMNODES || early_node_map[i].nid == nid)
+			return i;
+
+	return -1;
+}
+
+/*
+ * Basic iterator support. Return the previous active range of PFNs for a node
+ * Note: nid == MAX_NUMNODES returns next region regardless of node
+ */
+static int __meminit previous_active_region_index_in_nid(int index, int nid)
+{
+	for (index = index - 1; index >= 0; index--)
+		if (nid == MAX_NUMNODES || early_node_map[index].nid == nid)
+			return index;
+
+	return -1;
+}
+
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 /*
  * Required by SPARSEMEM. Given a PFN, return what node the PFN is on.
@@ -3667,6 +3695,10 @@ bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
 	for (i = first_active_region_index_in_nid(nid); i != -1; \
 				i = next_active_region_index_in_nid(i, nid))
 
+#define for_each_active_range_index_in_nid_reverse(i, nid) \
+	for (i = last_active_region_index_in_nid(nid); i != -1; \
+				i = previous_active_region_index_in_nid(i, nid))
+
 /**
  * free_bootmem_with_active_regions - Call free_bootmem_node for each active range
  * @nid: The node to free memory on. If MAX_NUMNODES, all nodes are freed.
@@ -3705,7 +3737,7 @@ u64 __init find_memory_core_early(int nid, u64 size, u64 align,
 	int i;
 
 	/* Need to go over early_node_map to find out good range for node */
-	for_each_active_range_index_in_nid(i, nid) {
+	for_each_active_range_index_in_nid_reverse(i, nid) {
 		u64 addr;
 		u64 ei_start, ei_last;
 		u64 final_start, final_end;
-- 
1.7.1

