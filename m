Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2KFTxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:53:45 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51150 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab2KFTxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:53:43 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 1/8] mm: Introduce memory regions data-structure to
 capture region boundaries within node
To: akpm@linux-foundation.org, mgorman@suse.de, mjg59@srcf.ucam.org,
        paulmck@linux.vnet.ibm.com, dave@linux.vnet.ibm.com,
        maxime.coquelin@stericsson.com, loic.pallardy@stericsson.com,
        arjan@linux.intel.com, kmpark@infradead.org,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, amit.kachhap@linaro.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org, santosh.shilimkar@ti.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Nov 2012 01:22:29 +0530
Message-ID: <20121106195225.6941.2868.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121106195026.6941.24662.stgit@srivatsabhat.in.ibm.com>
References: <20121106195026.6941.24662.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12110619-9264-0000-0000-000002A20601
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Within a node, we can have regions of memory that can be power-managed.
That is, chunks of memory can be transitioned (manually or automatically)
to low-power states based on the frequency of references to that region.
For example, if a memory chunk is not referenced for a given threshold
amount of time, the hardware can decide to put that piece of memory into
a content-preserving low-power state. And of course, on the next reference
to that chunk of memory, it will be transitioned to full-power for
read/write operations.

We propose to incorporate this knowledge of power-manageable chunks of
memory into a new data-structure called "Memory Regions". This way of
acknowledging the existence of different classes of memory with different
characteristics is the first step to in order to manage memory
power-efficiently, such as performing power-aware memory allocation etc.

[Also, the concept of memory regions could potentially be extended to work
with different classes of memory like PCM (Phase Change Memory) etc and
hence, it is not limited to just power management alone].

We already sub-divide a node's memory into zones, based on some well-known
constraints. So the question is, where do we fit in memory regions in this
hierarchy. Instead of artificially trying to fit it into the hierarchy one
way or the other, we choose to simply capture the region boundaries in a
parallel data-structure, since there is no guarantee that the region
boundaries will naturally fit inside zone boundaries or vice-versa.

But of course, memory regions are sub-divisions *within* a node, so it makes
sense to keep the data-structures in the node's struct pglist_data. (Thus
this placement makes memory regions parallel to zones in that node).

Once we capture the region boundaries in the memory regions data-structure,
we can influence MM decisions at various places, such as page allocation,
reclamation etc.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/mmzone.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 50aaca8..bb7c3ef 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -80,6 +80,8 @@ static inline int get_pageblock_migratetype(struct page *page)
 	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
 }
 
+#define MAX_NR_REGIONS	256
+
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free;
@@ -328,6 +330,15 @@ enum zone_type {
 #error ZONES_SHIFT -- too many zones configured adjust calculation
 #endif
 
+struct node_mem_region {
+	unsigned long start_pfn;
+	unsigned long present_pages;
+	unsigned long spanned_pages;
+	int idx;
+	int node;
+	struct pglist_data *pgdat;
+};
+
 struct zone {
 	/* Fields commonly accessed by the page allocator */
 
@@ -687,6 +698,8 @@ typedef struct pglist_data {
 	struct zone node_zones[MAX_NR_ZONES];
 	struct zonelist node_zonelists[MAX_ZONELISTS];
 	int nr_zones;
+	struct node_mem_region node_regions[MAX_NR_REGIONS];
+	int nr_node_regions;
 #ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
 	struct page *node_mem_map;
 #ifdef CONFIG_MEMCG

