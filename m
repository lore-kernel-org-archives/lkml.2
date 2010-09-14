Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0INXCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:02:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27048 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab0INXCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:02:14 -0400
Message-ID: <4C8FFE76.8070801@kernel.org>
Date: Tue, 14 Sep 2010 16:00:06 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build warnings after merge of the final tree (tip
 treee related)
References: <20100913132721.5a02cfbc.sfr@canb.auug.org.au>	<4C8DA517.9000603@kernel.org>	<20100913143942.7344ada4.sfr@canb.auug.org.au>	<4C8DDFB4.1020508@kernel.org> <20100914145025.977ec2a6.sfr@canb.auug.org.au>
In-Reply-To: <20100914145025.977ec2a6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 09:50 PM, Stephen Rothwell wrote:
> Hi Yinghai,
> 
> On Mon, 13 Sep 2010 01:24:20 -0700 Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> On 09/12/2010 09:39 PM, Stephen Rothwell wrote:
>>>
>>> Your patch fixes some of the warnings, but still leaves these for a
>>> powerpc allnoconfig build:
>>>
>>> WARNING: mm/built-in.o(.text+0x25d80): Section mismatch in reference from the function memblock_double_array() to the function .init.text:memblock_free()
>>> The function memblock_double_array() references
>>> the function __init memblock_free().
>>> This is often because memblock_double_array lacks a __init 
>>> annotation or the annotation of memblock_free is wrong.
>>>
>>> WARNING: mm/built-in.o(.text+0x26318): Section mismatch in reference from the function memblock_reserve_reserved_regions() to the function .init.text:memblock_reserve()
>>> The function memblock_reserve_reserved_regions() references
>>> the function __init memblock_reserve().
>>> This is often because memblock_reserve_reserved_regions lacks a __init 
>>> annotation or the annotation of memblock_reserve is wrong.
>>>
>>> WARNING: mm/built-in.o(.text+0x26490): Section mismatch in reference from the function memblock_free_reserved_regions() to the function .init.text:memblock_free()
>>> The function memblock_free_reserved_regions() references
>>> the function __init memblock_free().
>>> This is often because memblock_free_reserved_regions lacks a __init 
>>> annotation or the annotation of memblock_free is wrong.
>>
>> v1 already changed them all to __init_memblock, so we should not have those warnings.
> 
> They are still marked as __init in include/linux/memblock.h.  I don't
> think that they need to be marked at all there.

good,

Also, we may need to remove all extern and __init and __initdata etc in .h files.

please check

[PATCH -v3] memblock: Fix section mismatch warning

Use __init_memblock to replace __init, and remove __init in memblock.h

-v2: more with memblock_is_meory()
-v3: remove __init for function declaring in memblock.h. Pointed out by Stephen.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Yinghai Lu <Yinghai@kernel.org>

---
 include/linux/memblock.h |   44 ++++++++++++++++++++++----------------------
 mm/memblock.c            |   14 +++++++-------
 2 files changed, 29 insertions(+), 29 deletions(-)

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
@@ -51,46 +51,46 @@ u64 memblock_find_in_range(u64 start, u6
 int memblock_free_reserved_regions(void);
 int memblock_reserve_reserved_regions(void);
 
-extern void __init memblock_init(void);
-extern void __init memblock_analyze(void);
-extern long memblock_add(phys_addr_t base, phys_addr_t size);
-extern long memblock_remove(phys_addr_t base, phys_addr_t size);
-extern long __init memblock_free(phys_addr_t base, phys_addr_t size);
-extern long __init memblock_reserve(phys_addr_t base, phys_addr_t size);
+void memblock_init(void);
+void memblock_analyze(void);
+long memblock_add(phys_addr_t base, phys_addr_t size);
+long memblock_remove(phys_addr_t base, phys_addr_t size);
+long memblock_free(phys_addr_t base, phys_addr_t size);
+long memblock_reserve(phys_addr_t base, phys_addr_t size);
 
 /* The numa aware allocator is only available if
  * CONFIG_ARCH_POPULATES_NODE_MAP is set
  */
-extern phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align,
+phys_addr_t memblock_alloc_nid(phys_addr_t size, phys_addr_t align,
 					int nid);
-extern phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align,
+phys_addr_t memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align,
 					    int nid);
 
-extern phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align);
+phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align);
 
 /* Flags for memblock_alloc_base() amd __memblock_alloc_base() */
 #define MEMBLOCK_ALLOC_ANYWHERE	(~(phys_addr_t)0)
 #define MEMBLOCK_ALLOC_ACCESSIBLE	0
 
-extern phys_addr_t __init memblock_alloc_base(phys_addr_t size,
+phys_addr_t memblock_alloc_base(phys_addr_t size,
 					 phys_addr_t align,
 					 phys_addr_t max_addr);
-extern phys_addr_t __init __memblock_alloc_base(phys_addr_t size,
+phys_addr_t __memblock_alloc_base(phys_addr_t size,
 					   phys_addr_t align,
 					   phys_addr_t max_addr);
-extern phys_addr_t __init memblock_phys_mem_size(void);
-extern phys_addr_t memblock_end_of_DRAM(void);
-extern void __init memblock_enforce_memory_limit(phys_addr_t memory_limit);
-extern int memblock_is_memory(phys_addr_t addr);
-extern int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
-extern int __init memblock_is_reserved(phys_addr_t addr);
-extern int memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
+phys_addr_t memblock_phys_mem_size(void);
+phys_addr_t memblock_end_of_DRAM(void);
+void memblock_enforce_memory_limit(phys_addr_t memory_limit);
+int memblock_is_memory(phys_addr_t addr);
+int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
+int memblock_is_reserved(phys_addr_t addr);
+int memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
 
-extern void memblock_dump_all(void);
+void memblock_dump_all(void);
 
 /* Provided by the architecture */
-extern phys_addr_t memblock_nid_range(phys_addr_t start, phys_addr_t end, int *nid);
-extern int memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
+phys_addr_t memblock_nid_range(phys_addr_t start, phys_addr_t end, int *nid);
+int memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
 				   phys_addr_t addr2, phys_addr_t size2);
 
 /**
@@ -99,7 +99,7 @@ extern int memblock_memory_can_coalesce(
  *                         accessible during boot
  * @limit: New limit value (physical address)
  */
-extern void memblock_set_current_limit(phys_addr_t limit);
+void memblock_set_current_limit(phys_addr_t limit);
 
 
 /*
