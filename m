Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0IMI0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:26:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30395 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab0IMI0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:26:46 -0400
Message-ID: <4C8DDFB4.1020508@kernel.org>
Date: Mon, 13 Sep 2010 01:24:20 -0700
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
References: <20100913132721.5a02cfbc.sfr@canb.auug.org.au>	<4C8DA517.9000603@kernel.org> <20100913143942.7344ada4.sfr@canb.auug.org.au>
In-Reply-To: <20100913143942.7344ada4.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2010 09:39 PM, Stephen Rothwell wrote:

> 
> Your patch fixes some of the warnings, but still leaves these for a
> powerpc allnoconfig build:
> 
> WARNING: mm/built-in.o(.text+0x25d80): Section mismatch in reference from the function memblock_double_array() to the function .init.text:memblock_free()
> The function memblock_double_array() references
> the function __init memblock_free().
> This is often because memblock_double_array lacks a __init 
> annotation or the annotation of memblock_free is wrong.
> 
> WARNING: mm/built-in.o(.text+0x26318): Section mismatch in reference from the function memblock_reserve_reserved_regions() to the function .init.text:memblock_reserve()
> The function memblock_reserve_reserved_regions() references
> the function __init memblock_reserve().
> This is often because memblock_reserve_reserved_regions lacks a __init 
> annotation or the annotation of memblock_reserve is wrong.
> 
> WARNING: mm/built-in.o(.text+0x26490): Section mismatch in reference from the function memblock_free_reserved_regions() to the function .init.text:memblock_free()
> The function memblock_free_reserved_regions() references
> the function __init memblock_free().
> This is often because memblock_free_reserved_regions lacks a __init 
> annotation or the annotation of memblock_free is wrong.

v1 already changed them all to __init_memblock, so we should not have those warnings.

> 
> And these for a i386 defconfig build:
> 
> WARNING: mm/built-in.o(.text+0x1e261): Section mismatch in reference from the function memblock_is_memory() to the variable .init.data:memblock
> The function memblock_is_memory() references
> the variable __initdata memblock.
> This is often because memblock_is_memory lacks a __initdata 
> annotation or the annotation of memblock is wrong.
> 
> WARNING: mm/built-in.o(.text+0x1e27f): Section mismatch in reference from the function memblock_is_region_memory() to the variable .init.data:memblock
> The function memblock_is_region_memory() references
> the variable __initdata memblock.
> This is often because memblock_is_region_memory lacks a __initdata 
> annotation or the annotation of memblock is wrong.
> 

you must have old gcc, those functions are not used with i386.

[PATCH -v2] memblock: Fix section mismatch warning

for arches that use memblock other than x86

-v2: more with memblock_is_meory()

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Yinghai Lu <Yinghai@kernel.org>

---
 mm/memblock.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

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
