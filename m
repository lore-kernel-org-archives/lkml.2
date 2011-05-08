Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1EHSL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:11:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46353 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab1EHSLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:11:12 -0400
Message-ID: <4DC6DC94.8020505@kernel.org>
Date: Sun, 08 May 2011 11:10:28 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Stefan Hellermann <stefan@the2masters.de>, linux-kernel@vger.kernel.org
Subject: [PATCH -v2] mm: Use alloc_bootmem_node_nopanic on really needed path
References: <4DC30251.9040902@the2masters.de> <4DC31D5F.8070209@the2masters.de> <4DC31F72.5050206@kernel.org> <4DC328AC.1060906@the2masters.de> <4DC3958F.1090800@kernel.org> <4DC3B6C6.7000704@the2masters.de>
In-Reply-To: <4DC3B6C6.7000704@the2masters.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DC6DCA6.00B3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stefan found nobootmem cause early crash on his system that only have 8M ram.

> Linux version 2.6.36 (stefan@hel-stefan.lan) (gcc version 4.6.0 20110428
> (Red Hat 4.6.0-6) (GCC) ) #5 Thu May 5 21:49:09 CEST 2011
> BIOS-provided physical RAM map:
>  BIOS-88: 0000000000000000 - 000000000009f000 (usable)
>  BIOS-88: 0000000000100000 - 0000000000840000 (usable)
> bootconsole [earlyser0] enabled
> Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
> DMI not present or invalid.
> last_pfn = 0x840 max_arch_pfn = 0x100000
> init_memory_mapping: 0000000000000000-0000000000840000
> 8MB LOWMEM available.
>   mapped low ram: 0 - 00840000
>   low ram: 0 - 00840000
> Zone PFN ranges:
>   DMA      0x00000001 -> 0x00001000
>   Normal   empty
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000001 -> 0x0000009f
>     0: 0x00000100 -> 0x00000840
> BUG: Int 6: CR2 (null)
>      EDI c034663c  ESI (null)  EBP c0329f38  ESP c0329ef4
>      EBX c0346380  EDX 00000006  ECX ffffffff  EAX fffffff4
>      err (null)  EIP c0353191   CS c0320060  flg 00010082
> Stack: (null) c030c533 000007cd (null) c030c533 00000001 (null) (null)
>        00000003 0000083f 00000018 00000002 00000002 c0329f6c c03534d6 (null)
>        (null) 00000100 00000840 (null) c0329f64 00000001 00001000 (null)
> Pid: 0, comm: swapper Not tainted 2.6.36 #5
> Call Trace:
>  [<c02e3707>] ? 0xc02e3707
>  [<c035e6e5>] 0xc035e6e5
>  [<c0353191>] ? 0xc0353191
>  [<c03534d6>] 0xc03534d6
>  [<c034f1cd>] 0xc034f1cd
>  [<c034a824>] 0xc034a824
>  [<c03513cb>] ? 0xc03513cb
>  [<c0349432>] 0xc0349432
>  [<c0349066>] 0xc0349066

It turns out we should ignore the low limit the 16M.

Use alloc_bootmem_node_nopanic in those calling.

We need to backport this patch from 2.6.34

-v2: update patch description.

Reported-and-tested-by: Stefan Hellermann <stefan@the2masters.de>
Signed-off-by: Yinghai LU <yinghai@kernel.org>

---
 include/linux/bootmem.h |    2 ++
 mm/page_alloc.c         |    6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/bootmem.h
===================================================================
--- linux-2.6.orig/include/linux/bootmem.h
+++ linux-2.6/include/linux/bootmem.h
@@ -111,6 +111,8 @@ extern void *__alloc_bootmem_low_node(pg
 	__alloc_bootmem_nopanic(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_node_nopanic(pgdat, x) \
+	__alloc_bootmem_node_nopanic(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages_node_nopanic(pgdat, x) \
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3564,7 +3564,7 @@ int zone_wait_table_init(struct zone *zo
 
 	if (!slab_is_available()) {
 		zone->wait_table = (wait_queue_head_t *)
-			alloc_bootmem_node(pgdat, alloc_size);
+			alloc_bootmem_node_nopanic(pgdat, alloc_size);
 	} else {
 		/*
 		 * This case means that a zone whose size was 0 gets new memory
@@ -4141,7 +4141,7 @@ static void __init setup_usemap(struct p
 	unsigned long usemapsize = usemap_size(zonesize);
 	zone->pageblock_flags = NULL;
 	if (usemapsize)
-		zone->pageblock_flags = alloc_bootmem_node(pgdat, usemapsize);
+		zone->pageblock_flags = alloc_bootmem_node_nopanic(pgdat, usemapsize);
 }
 #else
 static inline void setup_usemap(struct pglist_data *pgdat,
@@ -4307,7 +4307,7 @@ static void __init_refok alloc_node_mem_
 		size =  (end - start) * sizeof(struct page);
 		map = alloc_remap(pgdat->node_id, size);
 		if (!map)
-			map = alloc_bootmem_node(pgdat, size);
+			map = alloc_bootmem_node_nopanic(pgdat, size);
 		pgdat->node_mem_map = map + (pgdat->node_start_pfn - start);
 	}
 #ifndef CONFIG_NEED_MULTIPLE_NODES
