Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab0LRBBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 20:01:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33311 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab0LRBBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 20:01:21 -0500
Message-ID: <4D0C075B.3040501@kernel.org>
Date: Fri, 17 Dec 2010 16:59:07 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 3/3] memblock: Make find_memory_core_early() find from top-down
References: <4D0C0336.9010009@kernel.org>
In-Reply-To: <4D0C0336.9010009@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


That is used for find ram in node or bootmem type.

We should make it top-down so it will be consistent to memblock_find.

Suggested-by: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/page_alloc.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3556,6 +3556,34 @@ static int __meminit next_active_region_
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
@@ -3607,6 +3635,10 @@ bool __meminit early_pfn_in_nid(unsigned
 	for (i = first_active_region_index_in_nid(nid); i != -1; \
 				i = next_active_region_index_in_nid(i, nid))
 
+#define for_each_active_range_index_in_nid_reverse(i, nid) \
+	for (i = last_active_region_index_in_nid(nid); i != -1; \
+				i = previous_active_region_index_in_nid(i, nid))
+
 /**
  * free_bootmem_with_active_regions - Call free_bootmem_node for each active range
  * @nid: The node to free memory on. If MAX_NUMNODES, all nodes are freed.
@@ -3645,7 +3677,7 @@ u64 __init find_memory_core_early(int ni
 	int i;
 
 	/* Need to go over early_node_map to find out good range for node */
-	for_each_active_range_index_in_nid(i, nid) {
+	for_each_active_range_index_in_nid_reverse(i, nid) {
 		u64 addr;
 		u64 ei_start, ei_last;
 		u64 final_start, final_end;
