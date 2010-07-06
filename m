Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab0GFWvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 18:51:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31578 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab0GFWna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 18:43:30 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 24/49] memblock: Separate memblock_alloc_nid() and memblock_alloc_try_nid()
Date: Tue,  6 Jul 2010 15:39:17 -0700
Message-Id: <1278455982-24621-25-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
References: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C33B16E.0121,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

The former is now strict, it will fail if it cannot honor the allocation
within the node, while the later implements the previous semantic which
falls back to allocating anywhere.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/sparc/mm/init_64.c  |    4 ++--
 include/linux/memblock.h |    6 +++++-
 mm/memblock.c            |   10 ++++++++++
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 0883113..dc584d2 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -820,7 +820,7 @@ static void __init allocate_node_data(int nid)
 	struct pglist_data *p;
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
-	paddr = memblock_alloc_nid(sizeof(struct pglist_data), SMP_CACHE_BYTES, nid);
+	paddr = memblock_alloc_try_nid(sizeof(struct pglist_data), SMP_CACHE_BYTES, nid);
 	if (!paddr) {
 		prom_printf("Cannot allocate pglist_data for nid[%d]\n", nid);
 		prom_halt();
@@ -840,7 +840,7 @@ static void __init allocate_node_data(int nid)
 	if (p->node_spanned_pages) {
 		num_pages = bootmem_bootmap_pages(p->node_spanned_pages);
 
-		paddr = memblock_alloc_nid(num_pages << PAGE_SHIFT, PAGE_SIZE, nid);
+		paddr = memblock_alloc_try_nid(num_pages << PAGE_SHIFT, PAGE_SIZE, nid);
 		if (!paddr) {
 			prom_printf("Cannot allocate bootmap for nid[%d]\n",
 				  nid);
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index b69c243..08a12cf 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -50,7 +50,11 @@ extern long __init memblock_reserve(phys_addr_t base, phys_addr_t size);
 /* The numa aware allocator is only available if
  * CONFIG_ARCH_POPULATES_NODE_MAP is set
  */
-extern phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid);
+extern phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align,
+					int nid);
+extern phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align,
+					    int nid);
+
 extern phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align);
 
 /* Flags for memblock_alloc_base() amd __memblock_alloc_base() */
diff --git a/mm/memblock.c b/mm/memblock.c
index d701c88..4e3e9ff 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -528,9 +528,19 @@ phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int n
 			return ret;
 	}
 
+	return 0;
+}
+
+phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, int nid)
+{
+	phys_addr_t res = memblock_alloc_nid(size, align, nid);
+
+	if (res)
+		return res;
 	return memblock_alloc(size, align);
 }
 
+
 /*
  * Remaining API functions
  */
-- 
1.6.4.2

