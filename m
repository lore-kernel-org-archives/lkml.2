Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0IOUGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 16:06:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23809 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab0IOUGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 16:06:44 -0400
Message-ID: <4C912709.2090201@kernel.org>
Date: Wed, 15 Sep 2010 13:05:29 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH -v4] memblock: Fix section mismatch warnings
References: <20100913132721.5a02cfbc.sfr@canb.auug.org.au> <4C8DA517.9000603@kernel.org> <20100913143942.7344ada4.sfr@canb.auug.org.au> <4C8DDFB4.1020508@kernel.org> <20100914145025.977ec2a6.sfr@canb.auug.org.au> <4C8FFE76.8070801@kernel.org> <20100915150047.42551e34.sfr@canb.auug.org.au> <20100915092532.GH16593@elte.hu>
In-Reply-To: <20100915092532.GH16593@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Stephen found bunch of section mismatch warnings with memblock new changes.

Use __init_memblock to replace __init in memblock.c and remove __init in memblock.h.
We should not use __init in header files.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Yinghai Lu <Yinghai@kernel.org>

---
 include/linux/memblock.h |   24 ++++++++++++------------
 mm/memblock.c            |   14 +++++++-------
 2 files changed, 19 insertions(+), 19 deletions(-)

Index: linux-2.6/mm/memblock.c
===================================================================
--- linux-2.6.orig/mm/memblock.c
+++ linux-2.6/mm/memblock.c
@@ -125,8 +125,8 @@ static phys_addr_t __init memblock_find_
 	return MEMBLOCK_ERROR;
 }
 
-static phys_addr_t __init memblock_find_base(phys_addr_t size, phys_addr_t align,
-					phys_addr_t start, phys_addr_t end)
+static phys_addr_t __init_memblock memblock_find_base(phys_addr_t size,
+			phys_addr_t align, phys_addr_t start, phys_addr_t end)
 {
 	long i;
 
@@ -439,12 +439,12 @@ long __init_memblock memblock_remove(phy
 	return __memblock_remove(&memblock.memory, base, size);
 }
 
-long __init memblock_free(phys_addr_t base, phys_addr_t size)
+long __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
 {
 	return __memblock_remove(&memblock.reserved, base, size);
 }
 
-long __init memblock_reserve(phys_addr_t base, phys_addr_t size)
+long __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 {
 	struct memblock_type *_rgn = &memblock.reserved;
 
@@ -671,12 +671,12 @@ int __init memblock_is_reserved(phys_add
 	return memblock_search(&memblock.reserved, addr) != -1;
 }
 
-int memblock_is_memory(phys_addr_t addr)
+int __init_memblock memblock_is_memory(phys_addr_t addr)
 {
 	return memblock_search(&memblock.memory, addr) != -1;
 }
 
-int memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
+int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
 {
 	int idx = memblock_search(&memblock.reserved, base);
 
@@ -693,7 +693,7 @@ int __init_memblock memblock_is_region_r
 }
 
 
-void __init memblock_set_current_limit(phys_addr_t limit)
+void __init_memblock memblock_set_current_limit(phys_addr_t limit)
 {
 	memblock.current_limit = limit;
 }
Index: linux-2.6/include/linux/memblock.h
===================================================================
--- linux-2.6.orig/include/linux/memblock.h
+++ linux-2.6/include/linux/memblock.h
@@ -51,39 +51,39 @@ u64 memblock_find_in_range(u64 start, u6
 int memblock_free_reserved_regions(void);
 int memblock_reserve_reserved_regions(void);
 
-extern void __init memblock_init(void);
-extern void __init memblock_analyze(void);
+extern void memblock_init(void);
+extern void memblock_analyze(void);
 extern long memblock_add(phys_addr_t base, phys_addr_t size);
 extern long memblock_remove(phys_addr_t base, phys_addr_t size);
-extern long __init memblock_free(phys_addr_t base, phys_addr_t size);
-extern long __init memblock_reserve(phys_addr_t base, phys_addr_t size);
+extern long memblock_free(phys_addr_t base, phys_addr_t size);
+extern long memblock_reserve(phys_addr_t base, phys_addr_t size);
 
 /* The numa aware allocator is only available if
  * CONFIG_ARCH_POPULATES_NODE_MAP is set
  */
-extern phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align,
+extern phys_addr_t memblock_alloc_nid(phys_addr_t size, phys_addr_t align,
 					int nid);
-extern phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align,
+extern phys_addr_t memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align,
 					    int nid);
 
-extern phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align);
+extern phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align);
 
 /* Flags for memblock_alloc_base() amd __memblock_alloc_base() */
 #define MEMBLOCK_ALLOC_ANYWHERE	(~(phys_addr_t)0)
 #define MEMBLOCK_ALLOC_ACCESSIBLE	0
 
-extern phys_addr_t __init memblock_alloc_base(phys_addr_t size,
+extern phys_addr_t memblock_alloc_base(phys_addr_t size,
 					 phys_addr_t align,
 					 phys_addr_t max_addr);
-extern phys_addr_t __init __memblock_alloc_base(phys_addr_t size,
+extern phys_addr_t __memblock_alloc_base(phys_addr_t size,
 					   phys_addr_t align,
 					   phys_addr_t max_addr);
-extern phys_addr_t __init memblock_phys_mem_size(void);
+extern phys_addr_t memblock_phys_mem_size(void);
 extern phys_addr_t memblock_end_of_DRAM(void);
-extern void __init memblock_enforce_memory_limit(phys_addr_t memory_limit);
+extern void memblock_enforce_memory_limit(phys_addr_t memory_limit);
 extern int memblock_is_memory(phys_addr_t addr);
 extern int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
-extern int __init memblock_is_reserved(phys_addr_t addr);
+extern int memblock_is_reserved(phys_addr_t addr);
 extern int memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
 
 extern void memblock_dump_all(void);
