Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab0GITN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:13:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19557 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab0GITM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:12:27 -0400
Message-ID: <4C3773C4.1010609@kernel.org>
Date: Fri, 09 Jul 2010 12:08:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Conny Seidel <conny.seidel@amd.com>
Subject: Re: BUG: unable to handle kernel paging request at 40000000 __alloc_memory_core_early+0x147/0x1d6
References: <20100709145415.GC11199@aftab>
In-Reply-To: <20100709145415.GC11199@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0209.4C37746B.007A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 07:54 AM, Borislav Petkov wrote:
> Hi,
> 
> this is something we're getting during testing on one of our boxes here,
> a dual socket Magny-Cours machine. It is oopsing on the addr variable in
> __alloc_memory_core_early() after converting it to a virtual address in
> order to clear the mem region at it. I've removed the "#if 0.. #endif"
> around the printk which dumps the ranges in the early node map for more
> info.
> 
> It's latest -git, 32bit build, config is attached.
> 

can not duplicate on all my setup.

but look at the code there is limit problem with 32 bit...

please check if it will fix the problem.

and we will need to rebase early_res to memblock patchset.

Thanks

Yinghai Lu

[PATCH] x86,mm: fix 32bit numa sparse vmemmp

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

Reported-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/page_alloc.c |    3 +++
 mm/sparse.c     |    5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

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
