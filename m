Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0GIWMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:12:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34265 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab0GIWMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:12:13 -0400
Message-ID: <4C379DB6.3040605@kernel.org>
Date: Fri, 09 Jul 2010 15:07:50 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Conny Seidel <conny.seidel@amd.com>
CC: "Petkov, Borislav" <Borislav.Petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: unable to handle kernel paging request at 40000000 __alloc_memory_core_early+0x147/0x1d6
References: <20100709145415.GC11199@aftab>	<4C3773C4.1010609@kernel.org>	<20100709215202.4be679a8@marah.osrc.amd.com>	<4C37841F.4030500@kernel.org> <20100709224231.5736113b@marah.osrc.amd.com>
In-Reply-To: <20100709224231.5736113b@marah.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C379EA7.00B4,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 01:42 PM, Conny Seidel wrote:
> sparse_early_mem_map_alloc: sparsemem memory map backing failed some memory will not be available.

please check

[PATCH -v2] x86,mm: fix 32bit numa sparsemem

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

-v2: add fallback for sparse_mem_map_populate()
    for "sparse_early_mem_map_alloc: sparsemem memory map backing failed some memory will not be available."


Reported-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/page_alloc.c |    3 +++
 mm/sparse.c     |   10 +++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

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
Index: linux-2.6/mm/sparse.c
===================================================================
--- linux-2.6.orig/mm/sparse.c
+++ linux-2.6/mm/sparse.c
@@ -363,7 +363,10 @@ static void __init sparse_early_usemaps_
 		return;
 	}
 
-	usemap = alloc_bootmem_node(NODE_DATA(nodeid), size * usemap_count);
+	usemap = __alloc_bootmem_node_nopanic(NODE_DATA(nodeid),
+					      size * usemap_count,
+					      SMP_CACHE_BYTES,
+					      __pa(MAX_DMA_ADDRESS));
 	if (usemap) {
 		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
 			if (!present_section_nr(pnum))
@@ -391,6 +394,11 @@ struct page __init *sparse_mem_map_popul
 	size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
 	map = __alloc_bootmem_node_high(NODE_DATA(nid), size,
 					 PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+
+	if (!map)
+		map = __alloc_bootmem_node_nopanic(NODE_DATA(nid), size,
+					 PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+
 	return map;
 }
 void __init sparse_mem_maps_populate_node(struct page **map_map,
