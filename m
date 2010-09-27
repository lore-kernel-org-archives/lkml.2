Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788Ab0I0XWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 19:22:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58510 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab0I0XWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 19:22:42 -0400
Message-ID: <4CA126BE.7000609@kernel.org>
Date: Mon, 27 Sep 2010 16:20:30 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: caiqian@redhat.com, Ingo Molnar <mingo@elte.hu>,
        kexec <kexec@lists.infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: kexec load failure introduced by "x86, memblock: Replace e820_/_early
 string with memblock_"
References: <632974489.2046131285586512527.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <4CA11918.7050708@kernel.org> <4CA11FB7.2080101@zytor.com>
In-Reply-To: <4CA11FB7.2080101@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 03:50 PM, H. Peter Anvin wrote:
> +		crash_base = alignment;
> +		while ((crash_base + crash_size) <= total_mem) {
> +			start = memblock_find_in_range(crash_base,
> +				crash_base + crash_size, crash_size, alignment);
> +
> +			if (start == crash_base)
> +				break;
> +
> +			crash_base += alignment;
> +		}
> +		if (start != crash_base) {
> 
> Open-coded crap violation error!
> 
> Seriously, these kinds of open-coded loops are *never* acceptable, since
> they are really "let's violate the interface by making it do something
> it wasn't intended to do" -- it means we need a new interface.
> 
> Alternatively, if we really need the lowest possible address, why do we
> need to search?

x86 own version for find_area?

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
@@ -352,3 +352,57 @@ u64 __init memblock_x86_hole_size(u64 st
 
 	return end - start - ((u64)ram << PAGE_SHIFT);
 }
+
+#ifdef CONFIG_ARCH_MEMBLOCK_FIND_AREA
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
+ * Find a free area with specified alignment in a specific range.
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
@@ -569,6 +569,14 @@ config PARAVIRT_DEBUG
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
@@ -165,7 +165,7 @@ static phys_addr_t __init_memblock membl
 /*
  * Find a free area with specified alignment in a specific range.
  */
-u64 __init_memblock memblock_find_in_range(u64 start, u64 end, u64 size, u64 align)
+u64 __init_memblock __weak memblock_find_in_range(u64 start, u64 end, u64 size, u64 align)
 {
 	return memblock_find_base(size, align, start, end);
 }
