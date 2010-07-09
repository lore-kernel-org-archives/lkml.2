Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0GIJwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 05:52:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50534 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab0GIJwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 05:52:50 -0400
Message-ID: <4C36F0B6.4060807@monstr.eu>
Date: Fri, 09 Jul 2010 11:49:42 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: microblaze-uclinux@itee.uq.edu.au, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 01/49] lmb: rename to memblock
References: <1278455982-24621-1-git-send-email-yinghai@kernel.org> <1278455982-24621-2-git-send-email-yinghai@kernel.org> <4C36D873.8060901@kernel.org>
In-Reply-To: <4C36D873.8060901@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On 07/06/2010 03:38 PM, Yinghai Lu wrote:
>> via following scripts
>>
>>       FILES=$(find * -type f | grep -vE 'oprofile|[^K]config')
>>
>>       sed -i \
>>         -e 's/lmb/memblock/g' \
>>         -e 's/LMB/MEMBLOCK/g' \
>>         $FILES
>>
>>       for N in $(find . -name lmb.[ch]); do
>>         M=$(echo $N | sed 's/lmb/memblock/g')
>>         mv $N $M
>>       done
>>
>> and remove some wrong change like lmbench and dlmb etc.
>>
>> also move memblock.c from lib/ to mm/
>>
>> Suggested-by: Ingo Molnar <mingo@elte.hu>
>> Acked-by: "H. Peter Anvin" <hpa@zytor.com>
>> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  arch/microblaze/platform/generic/system.dts       |    4 +-
>>
> ...
>> diff --git a/arch/microblaze/platform/generic/system.dts b/arch/microblaze/platform/generic/system.dts
>> index 2d5c417..2936ae6 100644
>> --- a/arch/microblaze/platform/generic/system.dts
>> +++ b/arch/microblaze/platform/generic/system.dts
>> @@ -70,7 +70,7 @@
>>  			xlnx,allow-icache-wr = <0x1>;
>>  			xlnx,area-optimized = <0x0>;
>>  			xlnx,cache-byte-size = <0x2000>;
>> -			xlnx,d-lmb = <0x1>;
>> +			xlnx,d-memblock = <0x1>;
>>  			xlnx,d-opb = <0x0>;
>>  			xlnx,d-plb = <0x1>;
>>  			xlnx,data-size = <0x20>;
>> @@ -89,7 +89,7 @@
>>  			xlnx,fsl-data-size = <0x20>;
>>  			xlnx,fsl-exception = <0x0>;
>>  			xlnx,fsl-links = <0x0>;
>> -			xlnx,i-lmb = <0x1>;
>> +			xlnx,i-memblock = <0x1>;
>>  			xlnx,i-opb = <0x0>;
>>  			xlnx,i-plb = <0x1>;
>>  			xlnx,icache-always-used = <0x1>;
> ...
> 
> looks like that change to microblaze dts is wrong.
> 
> Michal, it seems lmb in microblaze have lmb special?

DTS change is definitely wrong. LMB means local memory bus - which means 
that CPU has this connection.

> 
> in arch/microblaze/
> 
> include/asm/cpuinfo.h:  u32 use_dlmb;
> include/asm/cpuinfo.h:  u32 use_ilmb;
> kernel/cpu/cpuinfo-pvr-full.c:  CI(use_dlmb, D_LMB);
> kernel/cpu/cpuinfo-pvr-full.c:  CI(use_ilmb, I_LMB);
> kernel/cpu/cpuinfo-static.c:    ci->use_dlmb = fcpu(cpu, "xlnx,d-lmb");
> kernel/cpu/cpuinfo-static.c:    ci->use_ilmb = fcpu(cpu, "xlnx,i-lmb");
> kernel/prom.c:#include <linux/lmb.h>
> kernel/prom.c:  lmb_add(base, size);
> kernel/prom.c:  return lmb_alloc(size, align);
> kernel/prom.c:  lmb_init();
> kernel/prom.c:  lmb_analyze();
> kernel/prom.c:  pr_debug("Phys. mem: %lx\n", (unsigned long) lmb_phys_mem_size());
> mm/init.c:#include <linux/lmb.h>
> mm/init.c:      for (i = 0; i < lmb.memory.cnt; i++) {
> mm/init.c:              memory_start = (u32) lmb.memory.region[i].base;
> mm/init.c:              memory_end = (u32) lmb.memory.region[i].base
> mm/init.c:                              + (u32) lmb.memory.region[i].size;
> mm/init.c:      lmb_reserve(kernel_align_start, kernel_align_size);
> mm/init.c:      lmb_reserve(PFN_UP(TOPHYS((u32)klimit)) << PAGE_SHIFT, map_size);
> mm/init.c:      for (i = 0; i < lmb.reserved.cnt; i++) {
> mm/init.c:                      (u32) lmb.reserved.region[i].base,
> mm/init.c:                      (u32) lmb_size_bytes(&lmb.reserved, i));
> mm/init.c:              reserve_bootmem(lmb.reserved.region[i].base,
> mm/init.c:                      lmb_size_bytes(&lmb.reserved, i) - 1, BOOTMEM_DEFAULT);
> mm/init.c:                      lmb.memory.region[0].size = memory_size;
> mm/init.c:      if (!lmb.reserved.cnt) {
> mm/init.c:      if ((u32) lmb.memory.region[0].size < 0x1000000) {
> mm/init.c:      memory_start = (u32) lmb.memory.region[0].base;
> mm/init.c:      memory_end = (u32) lmb.memory.region[0].base +
> mm/init.c:                              (u32) lmb.memory.region[0].size;
> mm/init.c:      lmb_reserve(kstart, ksize);
> mm/init.c:              p = __va(lmb_alloc_base(PAGE_SIZE, PAGE_SIZE,
> platform/generic/system.dts:                    xlnx,d-lmb = <0x1>;
> platform/generic/system.dts:                    xlnx,i-lmb = <0x1>;
> 
> thought we should keep d-lmb and i-lmb, and change other lmb to memblock.


The rest of microblaze changes look ok.

Please revert this DTS part and for the rest:

Acked-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
