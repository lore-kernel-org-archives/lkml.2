Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab0JEXaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 19:30:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56251 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab0JEXaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 19:30:22 -0400
Message-ID: <4CABB4FD.2090304@kernel.org>
Date: Tue, 05 Oct 2010 16:30:05 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatches in memblock
References: <4CABAAB4.3090707@zytor.com>
In-Reply-To: <4CABAAB4.3090707@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 03:46 PM, H. Peter Anvin wrote:
> o.i386-allconfig/make.log:WARNING: mm/built-in.o(.text+0x48b6f): Section
> mismatch in reference from the function memblock_is_memory() to the
> variable .init.data:memblock
> o.i386-allconfig/make.log:The function memblock_is_memory() references
> o.i386-allconfig/make.log:This is often because memblock_is_memory lacks
> a __initdata
> o.i386-allconfig/make.log:WARNING: mm/built-in.o(.text+0x48bb0): Section
> mismatch in reference from the function memblock_is_region_memory() to
> the variable .init.data:memblock
> o.i386-allconfig/make.log:The function memblock_is_region_memory()
> references
> o.i386-allconfig/make.log:This is often because
> memblock_is_region_memory lacks a __initdata
> o.i386-allconfig/make.log:WARNING: mm/built-in.o(.text+0x48bd5): Section
> mismatch in reference from the function memblock_is_region_memory() to
> the variable .init.data:memblock
> o.i386-allconfig/make.log:The function memblock_is_region_memory()
> references
> o.i386-allconfig/make.log:This is often because
> memblock_is_region_memory lacks a __initdata
> 
> Happens with both i386 and x86-64.


[PATCH] memblock: Fix section mismatch warnings with memblock_search()

HPA found
o.i386-allconfig/make.log:WARNING: mm/built-in.o(.text+0x48b6f): Section
mismatch in reference from the function memblock_is_memory() to the
variable .init.data:memblock
o.i386-allconfig/make.log:The function memblock_is_memory() references
o.i386-allconfig/make.log:This is often because memblock_is_memory lacks
a __initdata
o.i386-allconfig/make.log:WARNING: mm/built-in.o(.text+0x48bb0): Section
mismatch in reference from the function memblock_is_region_memory() to
the variable .init.data:memblock
o.i386-allconfig/make.log:The function memblock_is_region_memory()
references
o.i386-allconfig/make.log:This is often because
memblock_is_region_memory lacks a __initdata

looks like gcc problem.

| static int memblock_search(struct memblock_type *type, phys_addr_t addr)
| {
|	.....
| }
|
|int __init memblock_is_reserved(phys_addr_t addr)
|{
|        return memblock_search(&memblock.reserved, addr) != -1;
|}
|
|int __init_memblock memblock_is_memory(phys_addr_t addr)
|{
|        return memblock_search(&memblock.memory, addr) != -1;
|}

Because We already have __init for those two functions.

Just make memblock_search to have __init_memblock atribute.


Reported-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Yinghai Lu <Yinghai@kernel.org>

---
 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/memblock.c
===================================================================
--- linux-2.6.orig/mm/memblock.c
+++ linux-2.6/mm/memblock.c
@@ -653,7 +653,7 @@ void __init memblock_enforce_memory_limi
 	}
 }
 
-static int memblock_search(struct memblock_type *type, phys_addr_t addr)
+static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
 {
 	unsigned int left = 0, right = type->cnt;
 
