Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab0LMSVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:21:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37557 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668Ab0LMSVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 13:21:22 -0500
Message-ID: <4D0663F0.2060103@kernel.org>
Date: Mon, 13 Dec 2010 10:20:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Maxim Uvarov <muvarov@gmail.com>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101203111623.GA2741@redhat.com> <AANLkTi=Xvbi5M_cNRL=wC+uwksG08SiCyWcqdmwB_5TU@mail.gmail.com> <20101203171147.GA2299@redhat.com> <20101203175401.GE28603@hmsreliant.think-freely.org> <20101207105053.GA2803@redhat.com> <4CFE89FE.1090901@kernel.org> <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com>
In-Reply-To: <20101213100848.GA2237@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 02:08 AM, Stanislaw Gruszka wrote:
> On Thu, Dec 09, 2010 at 12:09:31PM -0800, Yinghai Lu wrote:
>> On 12/09/2010 04:41 AM, Stanislaw Gruszka wrote:
>>> On Wed, Dec 08, 2010 at 11:16:10PM -0800, Yinghai Lu wrote:
>>>>>> please check debug patches, and boot first kernel and kexec second kernel with "ignore_loglevel debug earlyprintk...."
>>>>>
>>>>> Second kernel does not print anything, so maybe it not even start.
>>>>> Dmesg from primary kernel attached.
>>>>>
>>>>> Stanislaw
>>>>
>>>>
>>>> please try attached debug patch.
>>>
>>> With debug patch kdump kernel boot. Dmesg's from kdump and 
>>> primary kernel in attachment.
>>>
>>
>> thanks.
>>
>> please check if this one works. it only put crashkernel low.
> 
> Yes, with patch kdump works.

peter, vivek,

it seems 32bit kdump need crashkernel much low than we expect...

Maybe we have to find_in_range_low() to make 32bit kdump happy.

Thanks

Yinghai

Subject: [PATCH] x86, memblock: Add memblock_x86_find_in_range_low()

Generic version is going from high to low, and it seems it can not find
right area compact enough.

the x86 version will go from goal to limit and just like the way We used
for early_res

to make crashkernel happy with 32bit kdump

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/memblock.h |    2 +
 arch/x86/kernel/setup.c         |    2 -
 arch/x86/mm/memblock.c          |   52 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/mm/memblock.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/memblock.c
+++ linux-2.6/arch/x86/mm/memblock.c
@@ -346,3 +346,55 @@ u64 __init memblock_x86_hole_size(u64 st
 
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
+u64 __init memblock_x86_find_in_range_low(u64 start, u64 end, u64 size, u64 align)
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
@@ -20,4 +20,6 @@ u64 memblock_x86_find_in_range_node(int
 u64 memblock_x86_free_memory_in_range(u64 addr, u64 limit);
 u64 memblock_x86_memory_in_range(u64 addr, u64 limit);
 
+u64 memblock_x86_find_in_range_low(u64 start, u64 end, u64 size, u64 align);
+
 #endif
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -522,7 +522,7 @@ static void __init reserve_crashkernel(v
 		/*
 		 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
 		 */
-		crash_base = memblock_find_in_range(alignment,
+		crash_base = memblock_x86_find_in_range_low(alignment,
 			       DEFAULT_BZIMAGE_ADDR_MAX, crash_size, alignment);
 
 		if (crash_base == MEMBLOCK_ERROR) {
