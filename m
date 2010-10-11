Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0JKTfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 15:35:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27088 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab0JKTfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 15:35:42 -0400
Message-ID: <4CB366B1.40405@kernel.org>
Date: Mon, 11 Oct 2010 12:34:09 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree (tip
 tree related)
References: <20101011160429.81483d01.sfr@canb.auug.org.au> <4CB344C6.5040408@kernel.org> <4CB35EC1.5040909@zytor.com>
In-Reply-To: <4CB35EC1.5040909@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2010 12:00 PM, H. Peter Anvin wrote:
> On 10/11/2010 10:09 AM, Yinghai Lu wrote:
>>
>> make all functions in memblock.c without __init to carry __init_memblock.
>>
>>  
>> -static phys_addr_t __init memblock_find_region(phys_addr_t start, phys_addr_t end,
>> +static phys_addr_t __init_memblock memblock_find_region(phys_addr_t start, phys_addr_t end,
>>  					  phys_addr_t size, phys_addr_t align)
>>  
>> -static int memblock_search(struct memblock_type *type, phys_addr_t addr)
>> +static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
>>  
> 
> Your patch description doesn't match what your patch does.  Please write
> a correct description.

please check

[PATCH -v2] x86: Fix section mismatch with memblock_find_region()

Stephen found

WARNING: mm/built-in.o(.text+0x25ab8): Section mismatch in reference from the function memblock_find_base() to the function .init.text:memblock_find_region()
The function memblock_find_base() references
the function __init memblock_find_region().
This is often because memblock_find_base lacks a __init 
annotation or the annotation of memblock_find_region is wrong.

So let memblock_find_region() to use __init_memblock insteaf of __init directly.

Also make left function that doesn't have __init* to carry  __init_memblock.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/memblock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/memblock.c
===================================================================
--- linux-2.6.orig/mm/memblock.c
+++ linux-2.6/mm/memblock.c
@@ -99,7 +99,7 @@ long __init_memblock memblock_overlaps_r
  * are top-down.
  */
 
-static phys_addr_t __init memblock_find_region(phys_addr_t start, phys_addr_t end,
+static phys_addr_t __init_memblock memblock_find_region(phys_addr_t start, phys_addr_t end,
 					  phys_addr_t size, phys_addr_t align)
 {
 	phys_addr_t base, res_base;
@@ -653,7 +653,7 @@ void __init memblock_enforce_memory_limi
 	}
 }
 
-static int memblock_search(struct memblock_type *type, phys_addr_t addr)
+static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
 {
 	unsigned int left = 0, right = type->cnt;
 
