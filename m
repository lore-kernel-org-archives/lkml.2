Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab0LIHQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 02:16:44 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:17875 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0LIHQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 02:16:43 -0500
Message-ID: <4D00823A.9050808@kernel.org>
Date: Wed, 08 Dec 2010 23:16:10 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Maxim Uvarov <muvarov@gmail.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101203111623.GA2741@redhat.com> <AANLkTi=Xvbi5M_cNRL=wC+uwksG08SiCyWcqdmwB_5TU@mail.gmail.com> <20101203171147.GA2299@redhat.com> <20101203175401.GE28603@hmsreliant.think-freely.org> <20101207105053.GA2803@redhat.com> <4CFE89FE.1090901@kernel.org> <20101208141942.GA2335@redhat.com>
In-Reply-To: <20101208141942.GA2335@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------070501050006030903080503"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070501050006030903080503
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/08/2010 06:19 AM, Stanislaw Gruszka wrote:
> On Tue, Dec 07, 2010 at 11:24:46AM -0800, Yinghai Lu wrote:
>> On 12/07/2010 02:50 AM, Stanislaw Gruszka wrote:
>>> On Fri, Dec 03, 2010 at 12:54:01PM -0500, Neil Horman wrote:
>>>> On Fri, Dec 03, 2010 at 06:11:48PM +0100, Stanislaw Gruszka wrote:
>>>>> On Fri, Dec 03, 2010 at 06:46:09PM +0300, Maxim Uvarov wrote:
>>>>>> 2010/12/3 Stanislaw Gruszka <sgruszka@redhat.com>:
>>>>>>> On my T-60 laptop, i686 system with 2.6.37-rc4 kernel,
>>>>>>> "echo c > /proc/sysrq-trigger" just hung the system. Kdump
>>>>>>> works on 2.6.36. Is this known issue? If not, what info
>>>>>>> I should provide to solve it (I think the easiest way
>>>>>>> to solve the problem would be bisect) ?
>>>>>>>
>>>>>>> Stanislaw
>>>>>>>
>>>>>>
>>>>>> I tested x86 QEMU yesterday with the latest git. It worked.
>>>>>> Might be something target specific.., What does console print?
>>>>>
>>>>> Here is the photo 
>>>>> http://people.redhat.com/sgruszka/20101203_005.jpg
>>>>>
>>>>> There are two BUGs, first "sleeping function called from invalid
>>>>> context" and then "unable to handle null pointer dereference".
>>>>>
>>>> The warning about sleeping is an artifact of the fact that we panic the box with
>>>> irqs disabled I think (although I would think the fault handler would have
>>>> re-enabled them properly).  Not sure what the NULL pointer is from
>>>
>>> NULL pointer dereferece is ok, that's the way sysrq_handle_crash
>>> trigger a crash. Problem here is that secondary kdump kernel hung at
>>> start.
>>>
>>> Bisection shows that bad commit is
>>>
>>> commit 72d7c3b33c980843e756681fb4867dc1efd62a76
>>> Author: Yinghai Lu <yinghai@kernel.org>
>>> Date:   Wed Aug 25 13:39:17 2010 -0700
>>
>> please check debug patches, and boot first kernel and kexec second kernel with "ignore_loglevel debug earlyprintk...."
> 
> Second kernel does not print anything, so maybe it not even start.
> Dmesg from primary kernel attached.
> 
> Stanislaw


please try attached debug patch.

Thanks

	Yinghai

--------------070501050006030903080503
Content-Type: text/x-patch;
 name="lmb_x86_back_9_x.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lmb_x86_back_9_x.patch"

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

--------------070501050006030903080503--
