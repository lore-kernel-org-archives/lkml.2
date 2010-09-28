Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586Ab0I1CoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:44:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18000 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759826Ab0I1CoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:44:02 -0400
Message-ID: <4CA155F2.5030101@kernel.org>
Date: Mon, 27 Sep 2010 19:41:54 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        kexec <kexec@lists.infradead.org>, caiqian@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: kexec load failure introduced by "x86, memblock: Replace e820_/_early
 string with memblock_"
References: <632974489.2046131285586512527.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <4CA11918.7050708@kernel.org> <4CA11FB7.2080101@zytor.com> <4CA126BE.7000609@kernel.org> <4CA1283C.9010105@zytor.com> <4CA12976.5060504@kernel.org> <4CA129EB.5000309@zytor.com> <4CA12BAB.1040308@kernel.org> <20100928005358.GA6456@redhat.com>
In-Reply-To: <20100928005358.GA6456@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 05:53 PM, Vivek Goyal wrote:
> Actually, hardcoding the upper limit to 4G is probably not the best idea.
> Kexec loads the the relocatable binary (purgatory) and I remember that
> one of the generated relocation type was signed 32 bit and allowed max value
> to be 2G only. So IIRC, purgatory code always needed to be loaded below 2G.

also kexec want bzImage under 37ffffff.

> 
> I liked HPA's other idea better of introducing memblock_find_in_range_lowest() 
> so that we search bottom up and not rely on a specific upper limit.
> 

Please check.

[PATCH -v4] x86, memblock: Fix crashkernel allocation

Cai Qian found crashkernel is broken with x86 memblock changes
1. crashkernel=128M@32M always reported that range is used, even first kernel is small
   no one use that range
2. always get following report when using "kexec -p"
        Could not find a free area of memory of a000 bytes...
        locate_hole failed

The root cause is that generic memblock_find_in_range() will try to get range from top_down.
But crashkernel do need from low and specified range.

Let's limit the target range with rash_base + crash_size to make sure that
We get range from bottom.

-v4: add find_memblock_find_in_range_lowest() according to hpa and vivik.

Reported-and-Bisected-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/memblock.h |    2 +
 arch/x86/kernel/setup.c         |    8 +++---
 arch/x86/mm/memblock.c          |   52 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/mm/memblock.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/memblock.c
+++ linux-2.6/arch/x86/mm/memblock.c
@@ -352,3 +352,55 @@ u64 __init memblock_x86_hole_size(u64 st
 
 	return end - start - ((u64)ram << PAGE_SHIFT);
 }
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
+u64 __init memblock_find_in_range_lowest(u64 start, u64 end, u64 size, u64 align)
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
Index: linux-2.6/arch/x86/include/asm/memblock.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/memblock.h
+++ linux-2.6/arch/x86/include/asm/memblock.h
@@ -18,4 +18,6 @@ u64 memblock_x86_find_in_range_node(int
 u64 memblock_x86_free_memory_in_range(u64 addr, u64 limit);
 u64 memblock_x86_memory_in_range(u64 addr, u64 limit);
 
+u64 memblock_find_in_range_lowest(u64 start, u64 end, u64 size, u64 align);
+
 #endif
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -518,8 +518,8 @@ static void __init reserve_crashkernel(v
 	if (crash_base <= 0) {
 		const unsigned long long alignment = 16<<20;	/* 16M */
 
-		crash_base = memblock_find_in_range(alignment, ULONG_MAX, crash_size,
-				 alignment);
+		crash_base = memblock_find_in_range_lowest(alignment,
+					 ULONG_MAX, crash_size, alignment);
 		if (crash_base == MEMBLOCK_ERROR) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
 			return;
@@ -527,8 +527,8 @@ static void __init reserve_crashkernel(v
 	} else {
 		unsigned long long start;
 
-		start = memblock_find_in_range(crash_base, ULONG_MAX, crash_size,
-				 1<<20);
+		start = memblock_find_in_range(crash_base,
+				 crash_base + crash_size, crash_size, 1<<20);
 		if (start != crash_base) {
 			pr_info("crashkernel reservation failed - memory is in use.\n");
 			return;
