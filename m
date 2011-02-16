Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab1BPIua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:50:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:53748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab1BPIu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:50:26 -0500
Date: Wed, 16 Feb 2011 08:50:04 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com,
        mingo@redhat.com, yinghai@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <4D0C075B.3040501@kernel.org>
References: <4D0C075B.3040501@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] memblock: Make find_memory_core_early() find from top-down
Message-ID: <tip-1a4a678b12c84db9ae5dce424e0e97f0559bb57c@git.kernel.org>
Git-Commit-ID: 1a4a678b12c84db9ae5dce424e0e97f0559bb57c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 08:50:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a4a678b12c84db9ae5dce424e0e97f0559bb57c
Gitweb:     http://git.kernel.org/tip/1a4a678b12c84db9ae5dce424e0e97f0559bb57c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 17 Dec 2010 16:59:07 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 29 Dec 2010 14:46:55 -0800

memblock: Make find_memory_core_early() find from top-down

That is used for find ram in node or bootmem type.

We should make it top-down so it will be consistent to memblock_find,
and to avoid allocating potentially valuable low memory before we
actually need it.

Suggested-by: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4D0C075B.3040501@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 mm/page_alloc.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 07a6544..19413bf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3555,6 +3555,34 @@ static int __meminit next_active_region_index_in_nid(int index, int nid)
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
@@ -3606,6 +3634,10 @@ bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
 	for (i = first_active_region_index_in_nid(nid); i != -1; \
 				i = next_active_region_index_in_nid(i, nid))
 
+#define for_each_active_range_index_in_nid_reverse(i, nid) \
+	for (i = last_active_region_index_in_nid(nid); i != -1; \
+				i = previous_active_region_index_in_nid(i, nid))
+
 /**
  * free_bootmem_with_active_regions - Call free_bootmem_node for each active range
  * @nid: The node to free memory on. If MAX_NUMNODES, all nodes are freed.
@@ -3644,7 +3676,7 @@ u64 __init find_memory_core_early(int nid, u64 size, u64 align,
 	int i;
 
 	/* Need to go over early_node_map to find out good range for node */
-	for_each_active_range_index_in_nid(i, nid) {
+	for_each_active_range_index_in_nid_reverse(i, nid) {
 		u64 addr;
 		u64 ei_start, ei_last;
 		u64 final_start, final_end;
