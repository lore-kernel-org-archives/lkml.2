Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276Ab0JFV51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:57:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61901 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab0JFV51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:57:27 -0400
Message-ID: <4CACF064.7000101@kernel.org>
Date: Wed, 06 Oct 2010 14:55:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memblock: Fix big size with find_region()
References: <4CA1ABA4.6070803@kernel.org> <20101006140604.982b22d6.akpm@linux-foundation.org>
In-Reply-To: <20101006140604.982b22d6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 02:06 PM, Andrew Morton wrote:
> On Tue, 28 Sep 2010 01:47:32 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>
>> When trying to find huge range for crashkernel, get
>>
>> [    0.000000] ------------[ cut here ]------------
>> [    0.000000] WARNING: at arch/x86/mm/memblock.c:248 memblock_x86_reserve_range+0x40/0x7a()
>> [    0.000000] Hardware name: Sun Fire x4800
>> [    0.000000] memblock_x86_reserve_range: wrong range [0xffffffff37000000, 0x137000000)
>> [    0.000000] Modules linked in:
>> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.36-rc5-tip-yh-01876-g1cac214-dirty #59
>> [    0.000000] Call Trace:
>> [    0.000000]  [<ffffffff82816f7e>] ? memblock_x86_reserve_range+0x40/0x7a
>> [    0.000000]  [<ffffffff81078c2d>] warn_slowpath_common+0x85/0x9e
>> [    0.000000]  [<ffffffff81078d38>] warn_slowpath_fmt+0x6e/0x70
>> [    0.000000]  [<ffffffff8281e77c>] ? memblock_find_region+0x40/0x78
>> [    0.000000]  [<ffffffff8281eb1f>] ? memblock_find_base+0x9a/0xb9
>> [    0.000000]  [<ffffffff82816f7e>] memblock_x86_reserve_range+0x40/0x7a
>> [    0.000000]  [<ffffffff8280452c>] setup_arch+0x99d/0xb2a
>> [    0.000000]  [<ffffffff810a3e02>] ? trace_hardirqs_off+0xd/0xf
>> [    0.000000]  [<ffffffff81cec7d8>] ? _raw_spin_unlock_irqrestore+0x3d/0x4c
>> [    0.000000]  [<ffffffff827ffcec>] start_kernel+0xde/0x3f1
>> [    0.000000]  [<ffffffff827ff2d4>] x86_64_start_reservations+0xa0/0xa4
>> [    0.000000]  [<ffffffff827ff3de>] x86_64_start_kernel+0x106/0x10d
>> [    0.000000] ---[ end trace a7919e7f17c0a725 ]---
>> [    0.000000] Reserving 8192MB of memory at 17592186041200MB for crashkernel (System RAM: 526336MB)
>>
>> Because memblock_find_region() can not handle size > end, base will be set to huge num.
>>
>> Try to check size with end.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  mm/memblock.c |    7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> Index: linux-2.6/mm/memblock.c
>> ===================================================================
>> --- linux-2.6.orig/mm/memblock.c
>> +++ linux-2.6/mm/memblock.c
>> @@ -105,13 +105,18 @@ static phys_addr_t __init memblock_find_
>>  	phys_addr_t base, res_base;
>>  	long j;
>>  
>> +	/* In case, huge size is requested */
>> +	if (end < size)
>> +		return MEMBLOCK_ERROR;
>> +
>> +	base = memblock_align_down((end - size), align);
> 
> This seems rather odd.  If some caller is passing in size>end then that
> caller is buggy isn't it?  A memory block which ends at 0x1000 and has
> a size of 0x2000 is nonsensical.
> 
> So shouldn't we at leat emit a warning so tht the offending caller can
> be found and fixed?

hpa already put the patch in tip with new title.

| Commit-ID:  f1af98c7629a1b76fd7336decbc776acdeed2120
| Gitweb:     http://git.kernel.org/tip/f1af98c7629a1b76fd7336decbc776acdeed2120
| Committer:  H. Peter Anvin <hpa@zytor.com>
| CommitDate: Tue, 5 Oct 2010 21:45:35 -0700
|
| memblock: Fix wraparound in find_region()


Please check following on top of that patch.

Yinghai

[PATCH] memblock: Add input size checking with memblock_find_region()

Make sure two callers have right inputs.
and add print warning to catch other offending callers.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/memblock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/memblock.c
===================================================================
--- linux-2.6.orig/mm/memblock.c
+++ linux-2.6/mm/memblock.c
@@ -106,7 +106,7 @@ static phys_addr_t __init memblock_find_
 	long j;
 
 	/* In case, huge size is requested */
-	if (end < size)
+	if (WARN_ONCE(end < size, "memblock_find_region: wrong range [%#llx-%#llx] size %#llx", start, end, size))
 		return MEMBLOCK_ERROR;
 
 	base = memblock_align_down((end - size), align);
@@ -152,14 +152,14 @@ static phys_addr_t __init_memblock membl
 		phys_addr_t memblocksize = memblock.memory.regions[i].size;
 		phys_addr_t bottom, top, found;
 
-		if (memblocksize < size)
-			continue;
 		if ((memblockbase + memblocksize) <= start)
 			break;
 		bottom = max(memblockbase, start);
 		top = min(memblockbase + memblocksize, end);
 		if (bottom >= top)
 			continue;
+		if ((top - bottom) < size)
+			continue;
 		found = memblock_find_region(bottom, top, size, align);
 		if (found != MEMBLOCK_ERROR)
 			return found;
@@ -547,7 +547,7 @@ static phys_addr_t __init memblock_alloc
 		int this_nid;
 
 		this_end = memblock_nid_range(start, end, &this_nid);
-		if (this_nid == nid) {
+		if (this_nid == nid && (this_end - start) >= size) {
 			phys_addr_t ret = memblock_find_region(start, this_end, size, align);
 			if (ret != MEMBLOCK_ERROR &&
 			    memblock_add_region(&memblock.reserved, ret, size) >= 0)

