Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab0JMFmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 01:42:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32295 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0JMFmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 01:42:42 -0400
Message-ID: <4CB54640.4000003@kernel.org>
Date: Tue, 12 Oct 2010 22:40:16 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org> <4CB4ABE2.3010300@goop.org> <4CB4CF4D.5020706@kernel.org> <4CB4F11F.4090104@goop.org>
In-Reply-To: <4CB4F11F.4090104@goop.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2010 04:37 PM, Jeremy Fitzhardinge wrote:
>  On 10/12/2010 02:12 PM, Yinghai Lu wrote:
>> On 10/12/2010 11:41 AM, Jeremy Fitzhardinge wrote:
>>>  On 10/04/2010 02:57 PM, Yinghai Lu wrote:
>>>> Please check memblock related patches
>>>>
>>>> [PATCH 1/4] memblock: Fix big size with find_region()
>>>> [PATCH -v5 2/4] x86, memblock: Fix crashkernel allocation
>>>> [PATCH 3/4] x86, memblock: Remove __memblock_x86_find_in_range_size()
>>>> [PATCH 4/4] x86, mm, memblock, 32bit: Make add_highpages honor early reserved ranges
>>>>
>>>> first one should get into core/memblock branch, and others should be in x86/mm/memeblock branch
>>>
>>> BTW, the memblock changes prevent the kernel from booting under Xen; it
>>> crashes while setting up the linear maps.  I haven't worked out what's
>>> failing yet, aside from bisecting it down to one of a9ce6bc151000 or
>>> 72d7c3b33c9808 (they don't compile in isolation so I had to skip them,
>>> but both are likely looking, but unfortunately large, complex and hard
>>> to further subdivide).
>>>
>>> I'll look further into this, but just a heads-up for the upcoming merge
>>> window.
>>>
>> please use 
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git memblock
>>
>> to find which commit cause xen broken.
>>
>> two xen related patch are folded into first converting commit.
> 
> Note that ce883cfc65c51e24 doesn't compile:
> 
> /home/jeremy/git/upstream/arch/x86/kernel/e820.c: In function
> ‘find_e820_area_size’:
> /home/jeremy/git/upstream/arch/x86/kernel/e820.c:764: error: expected
> ‘;’ before ‘return’
> 
> However, I can fix it with the obvious fix, and the Xen boot failure
> bisects to this change.
> 
> The specific crash is when constructing the initial pagetable, when Xen
> tries to remap a newly allocated pagetable page read-only, and finds the
> allocated page isn't mapped within the linear map. Since it is in the
> middle of creating the linear map, I guess its quite possible that the
> allocation order has changed, and it starts allocating pages which are
> not yet mapped, whereas before it was allocating already-mapped ones.

you can limit the allocation of pagetable page further ...

xen doesn't honor max_pfn_mapped?

> 
> I'll see if I can confirm this hypothesis and see if I can work around
> it (is poses some problems, because it means that when the pages later
> become mapped, I need to make sure they get mapped RO).

please check following debug patch, it will try find area bottom up...

Subject: [PATCH] x86, memblock: Add x86 version of memblock_find_in_range()

Generic version is going from high to low, and it seems it can not find
right area compact enough.

the x86 version will go from goal to limit and just like the way We used
for early_res

use ARCH_FIND_MEMBLOCK_AREA to select from them.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/Kconfig       |    8 +++++++
 arch/x86/mm/memblock.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++++
 mm/memblock.c          |    2 -
 3 files changed, 63 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/mm/memblock.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/memblock.c
+++ linux-2.6/arch/x86/mm/memblock.c
@@ -346,3 +346,57 @@ u64 __init memblock_x86_hole_size(u64 st
 
 	return end - start - ((u64)ram << PAGE_SHIFT);
 }
+#ifdef CONFIG_ARCH_MEMBLOCK_FIND_AREA
+
+/* Check for already reserved areas */
+static inline bool __init check_with_memblock_reserved(u64 *addrp, u64 size, u64 align)
+{
+	u64 addr = *addrp;
+	bool changed = false;
+	struct memblock_region *r;
+again:
+	for_each_memblock(reserved, r) {
+		if ((addr + size) > r->base && addr < (r->base + r->size)) {
+			addr = round_up(r->base + r->size, align);
+			changed = true;
+			goto again;
+		}
+	}
+
+	if (changed)
+		*addrp = addr;
+
+	return changed;
+}
+
+/*
+ * Find a free area with specified alignment in a specific range from bottom up
+ */
+u64 __init memblock_find_in_range(u64 start, u64 end, u64 size, u64 align)
+{
+	struct memblock_region *r;
+
+	for_each_memblock(memory, r) {
+		u64 ei_start = r->base;
+		u64 ei_last = ei_start + r->size;
+		u64 addr, last;
+
+		addr = round_up(ei_start, align);
+		if (addr < start)
+			addr = round_up(start, align);
+		if (addr >= ei_last)
+			continue;
+		while (check_with_memblock_reserved(&addr, size, align) && addr+size <= ei_last)
+			;
+		last = addr + size;
+		if (last > ei_last)
+			continue;
+		if (last > end)
+			continue;
+
+		return addr;
+	}
+
+	return MEMBLOCK_ERROR;
+}
+#endif
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -542,6 +542,14 @@ config PARAVIRT_DEBUG
 	  Enable to debug paravirt_ops internals.  Specifically, BUG if
 	  a paravirt_op is missing when it is called.
 
+config ARCH_MEMBLOCK_FIND_AREA
+	default y
+	bool "Use x86 own memblock_find_in_range()"
+	---help---
+	  Use memblock_find_in_range() version instead of generic version, it get free
+	  area up from low.
+	  Generic one try to get free area down from limit.
+
 config NO_BOOTMEM
 	def_bool y
 
Index: linux-2.6/mm/memblock.c
===================================================================
--- linux-2.6.orig/mm/memblock.c
+++ linux-2.6/mm/memblock.c
@@ -170,7 +170,7 @@ static phys_addr_t __init_memblock membl
 /*
  * Find a free area with specified alignment in a specific range.
  */
-u64 __init_memblock memblock_find_in_range(u64 start, u64 end, u64 size, u64 align)
+u64 __init_memblock __weak memblock_find_in_range(u64 start, u64 end, u64 size, u64 align)
 {
 	return memblock_find_base(size, align, start, end);
 }
