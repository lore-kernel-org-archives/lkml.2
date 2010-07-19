Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761035Ab0GTAIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:08:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64057 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760951Ab0GSX6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:58:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        stable@kernel.org
Subject: [PATCH 02/49] x86,mm: fix 32bit numa sparsemem
Date: Mon, 19 Jul 2010 16:56:11 -0700
Message-Id: <1279583818-14249-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
References: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C44E681.0057,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <borislav.petkov@amd.com> reported his 32bit numa has problem:

[    0.000000] Reserving total of 4c00 pages for numa KVA remap
[    0.000000] kva_start_pfn ~ 32800 max_low_pfn ~ 375fe
[    0.000000] max_pfn = 238000
[    0.000000] 8202MB HIGHMEM available.
[    0.000000] 885MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 375fe000
[    0.000000]   low ram: 0 - 375fe000
[    0.000000] alloc (nid=8 100000 - 7ee00000) (1000000 - ffffffff) 1000 1000 => 34e7000
[    0.000000] alloc (nid=8 100000 - 7ee00000) (1000000 - ffffffff) 200 40 => 34c9d80
[    0.000000] alloc (nid=0 100000 - 7ee00000) (1000000 - ffffffffffffffff) 180 40 => 34e6140
[    0.000000] alloc (nid=1 80000000 - c7e60000) (1000000 - ffffffffffffffff) 240 40 => 80000000
[    0.000000] BUG: unable to handle kernel paging request at 40000000
[    0.000000] IP: [<c2c8cff1>] __alloc_memory_core_early+0x147/0x1d6
[    0.000000] *pdpt = 0000000000000000 *pde = f000ff53f000ff00
...
[    0.000000] Call Trace:
[    0.000000]  [<c2c8b4f8>] ? __alloc_bootmem_node+0x216/0x22f
[    0.000000]  [<c2c90c9b>] ? sparse_early_usemaps_alloc_node+0x5a/0x10b
[    0.000000]  [<c2c9149e>] ? sparse_init+0x1dc/0x499
[    0.000000]  [<c2c79118>] ? paging_init+0x168/0x1df
[    0.000000]  [<c2c780ff>] ? native_pagetable_setup_start+0xef/0x1bb

looks like it allocate much high address for bootmem.

try to cut limit with get_max_mapped()

-v3: make alloc_bootmem_node could fallback to other node.
     just like old alloc_bootmem_node did

need this patch for 2.6.34 and 2.6.35

Reported-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org
---
 mm/bootmem.c    |   24 ++++++++++++++++++++----
 mm/page_alloc.c |    3 +++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 58c66cc..142c84a 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -833,15 +833,24 @@ static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
+	void *ptr;
+
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
 #ifdef CONFIG_NO_BOOTMEM
-	return __alloc_memory_core_early(pgdat->node_id, size, align,
+	ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
+					 goal, -1ULL);
+	if (ptr)
+		return ptr;
+
+	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
 					 goal, -1ULL);
 #else
-	return ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
+	ptr = ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
 #endif
+
+	return ptr;
 }
 
 void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
@@ -977,14 +986,21 @@ void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
+	void *ptr;
+
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
 #ifdef CONFIG_NO_BOOTMEM
-	return __alloc_memory_core_early(pgdat->node_id, size, align,
+	ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
+				goal, ARCH_LOW_ADDRESS_LIMIT);
+	if (ptr)
+		return ptr;
+	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
 				goal, ARCH_LOW_ADDRESS_LIMIT);
 #else
-	return ___alloc_bootmem_node(pgdat->bdata, size, align,
+	ptr = ___alloc_bootmem_node(pgdat->bdata, size, align,
 				goal, ARCH_LOW_ADDRESS_LIMIT);
 #endif
+	return ptr;
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 68319dd..9bd339e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3634,6 +3634,9 @@ void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 	int i;
 	void *ptr;
 
+	if (limit > get_max_mapped())
+		limit = get_max_mapped();
+
 	/* need to go over early_node_map to find out good range for node */
 	for_each_active_range_index_in_nid(i, nid) {
 		u64 addr;
-- 
1.6.4.2

