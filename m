Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab0GJSoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 14:44:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45058 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0GJSoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 14:44:20 -0400
Message-ID: <4C38BE8A.7080008@kernel.org>
Date: Sat, 10 Jul 2010 11:40:10 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
CC: Conny Seidel <conny.seidel@amd.com>,
       "Petkov, Borislav" <Borislav.Petkov@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>
Subject: [PATCH -v3] x86,nobootmem: make alloc_bootmem_node fall back to other
 node when 32bit numa are used
References: <20100709145415.GC11199@aftab>	<4C3773C4.1010609@kernel.org>	<20100709215202.4be679a8@marah.osrc.amd.com>	<4C37841F.4030500@kernel.org>	<20100709224231.5736113b@marah.osrc.amd.com>	<4C379DB6.3040605@kernel.org> <20100710015142.3f94b9dd@marah.osrc.amd.com>
In-Reply-To: <20100710015142.3f94b9dd@marah.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C38BF3F.01C2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Borislav Petkov reported his 32bit numa system has problem:

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

need this one for 2.6.34 and 2.6.35

Reported-by: Borislav Petkov <borislav.petkov@amd.com>
Tested-by: Conny Seidel <conny.seidel@amd.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org

---
 mm/bootmem.c    |   24 ++++++++++++++++++++----
 mm/page_alloc.c |    3 +++
 2 files changed, 23 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3634,6 +3634,9 @@ void * __init __alloc_memory_core_early(
 	int i;
 	void *ptr;
 
+	if (limit > get_max_mapped())
+		limit = get_max_mapped();
+
 	/* need to go over early_node_map to find out good range for node */
 	for_each_active_range_index_in_nid(i, nid) {
 		u64 addr;
Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -833,15 +833,24 @@ static void * __init ___alloc_bootmem_no
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
@@ -977,14 +986,21 @@ void * __init __alloc_bootmem_low(unsign
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
