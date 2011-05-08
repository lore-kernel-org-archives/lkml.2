Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1EHSfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:35:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46706 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab1EHSf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:35:29 -0400
Message-ID: <4DC6E25B.90407@kernel.org>
Date: Sun, 08 May 2011 11:35:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Olaf Hering <olaf@aepfle.de>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] memblock/nobootmem: Allow alloc_bootmem take 0 as low limit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4DC6E267.0040,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bootmem wrapper with memblock support top-down now, So do not need set low limit
to __pa(MAX_DMA_ADDRESS).

the logic should be: good to allocate above __pa(MAX_DMA_ADDRESS), but it is ok if we
can not find above 16M on system that have small amount of RAM.

Need to apply this one after
	[PATCH] mm: Use alloc_bootmem_node_nopanic on really needed path

Signed-off-by: Yinghai LU <yinghai@kernel.org>

---
 include/linux/bootmem.h |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/bootmem.h
===================================================================
--- linux-2.6.orig/include/linux/bootmem.h
+++ linux-2.6/include/linux/bootmem.h
@@ -99,24 +99,31 @@ extern void *__alloc_bootmem_low_node(pg
 				      unsigned long align,
 				      unsigned long goal);
 
+#ifdef CONFIG_NO_BOOTMEM
+/* We are using top down, so it is safe to use 0 here */
+#define BOOTMEM_LOW_LIMIT 0
+#else
+#define BOOTMEM_LOW_LIMIT __pa(MAX_DMA_ADDRESS)
+#endif
+
 #define alloc_bootmem(x) \
-	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem(x, SMP_CACHE_BYTES, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_align(x, align) \
-	__alloc_bootmem(x, align, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem(x, align, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_nopanic(x) \
-	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_pages(x) \
-	__alloc_bootmem(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem(x, PAGE_SIZE, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_pages_nopanic(x) \
-	__alloc_bootmem_nopanic(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_nopanic(x, PAGE_SIZE, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_node(pgdat, x) \
-	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_node_nopanic(pgdat, x) \
-	__alloc_bootmem_node_nopanic(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node_nopanic(pgdat, x, SMP_CACHE_BYTES, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_pages_node(pgdat, x) \
-	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_pages_node_nopanic(pgdat, x) \
-	__alloc_bootmem_node_nopanic(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node_nopanic(pgdat, x, PAGE_SIZE, BOOTMEM_LOW_LIMIT)
 
 #define alloc_bootmem_low(x) \
 	__alloc_bootmem_low(x, SMP_CACHE_BYTES, 0)
