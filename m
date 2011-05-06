Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1EFWaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:30:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28367 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab1EFWaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:30:09 -0400
Message-ID: <4DC47655.5040201@kernel.org>
Date: Fri, 06 May 2011 15:29:41 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Stefan Hellermann <stefan@the2masters.de>, linux-kernel@vger.kernel.org
Subject: PATCH] mm: Use alloc_bootmem_node_nopanic on really needed path
References: <4DC30251.9040902@the2masters.de> <4DC31D5F.8070209@the2masters.de> <4DC31F72.5050206@kernel.org> <4DC328AC.1060906@the2masters.de> <4DC3958F.1090800@kernel.org> <4DC3B6C6.7000704@the2masters.de>
In-Reply-To: <4DC3B6C6.7000704@the2masters.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DC4765C.0040,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stefan found nobootmem does not work on his system that only have 8M ram.

It turns out we should ignore the low limit the 16M.

Use alloc_bootmem_node_nopanic in those calling.

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
