Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0GIIKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:10:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41487 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab0GIIKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:10:39 -0400
Message-ID: <4C36D873.8060901@kernel.org>
Date: Fri, 09 Jul 2010 01:06:11 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Michal Simek <monstr@monstr.eu>,
       microblaze-uclinux@itee.uq.edu.au
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 01/49] lmb: rename to memblock
References: <1278455982-24621-1-git-send-email-yinghai@kernel.org> <1278455982-24621-2-git-send-email-yinghai@kernel.org>
In-Reply-To: <1278455982-24621-2-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C36D956.01C5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 03:38 PM, Yinghai Lu wrote:
> via following scripts
> 
>       FILES=$(find * -type f | grep -vE 'oprofile|[^K]config')
> 
>       sed -i \
>         -e 's/lmb/memblock/g' \
>         -e 's/LMB/MEMBLOCK/g' \
>         $FILES
> 
>       for N in $(find . -name lmb.[ch]); do
>         M=$(echo $N | sed 's/lmb/memblock/g')
>         mv $N $M
>       done
> 
> and remove some wrong change like lmbench and dlmb etc.
> 
> also move memblock.c from lib/ to mm/
> 
> Suggested-by: Ingo Molnar <mingo@elte.hu>
> Acked-by: "H. Peter Anvin" <hpa@zytor.com>
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/microblaze/platform/generic/system.dts       |    4 +-
> 
...
> diff --git a/arch/microblaze/platform/generic/system.dts b/arch/microblaze/platform/generic/system.dts
> index 2d5c417..2936ae6 100644
> --- a/arch/microblaze/platform/generic/system.dts
> +++ b/arch/microblaze/platform/generic/system.dts
> @@ -70,7 +70,7 @@
>  			xlnx,allow-icache-wr = <0x1>;
>  			xlnx,area-optimized = <0x0>;
>  			xlnx,cache-byte-size = <0x2000>;
> -			xlnx,d-lmb = <0x1>;
> +			xlnx,d-memblock = <0x1>;
>  			xlnx,d-opb = <0x0>;
>  			xlnx,d-plb = <0x1>;
>  			xlnx,data-size = <0x20>;
> @@ -89,7 +89,7 @@
>  			xlnx,fsl-data-size = <0x20>;
>  			xlnx,fsl-exception = <0x0>;
>  			xlnx,fsl-links = <0x0>;
> -			xlnx,i-lmb = <0x1>;
> +			xlnx,i-memblock = <0x1>;
>  			xlnx,i-opb = <0x0>;
>  			xlnx,i-plb = <0x1>;
>  			xlnx,icache-always-used = <0x1>;
...

looks like that change to microblaze dts is wrong.

Michal, it seems lmb in microblaze have lmb special?

in arch/microblaze/

include/asm/cpuinfo.h:  u32 use_dlmb;
include/asm/cpuinfo.h:  u32 use_ilmb;
kernel/cpu/cpuinfo-pvr-full.c:  CI(use_dlmb, D_LMB);
kernel/cpu/cpuinfo-pvr-full.c:  CI(use_ilmb, I_LMB);
kernel/cpu/cpuinfo-static.c:    ci->use_dlmb = fcpu(cpu, "xlnx,d-lmb");
kernel/cpu/cpuinfo-static.c:    ci->use_ilmb = fcpu(cpu, "xlnx,i-lmb");
kernel/prom.c:#include <linux/lmb.h>
kernel/prom.c:  lmb_add(base, size);
kernel/prom.c:  return lmb_alloc(size, align);
kernel/prom.c:  lmb_init();
kernel/prom.c:  lmb_analyze();
kernel/prom.c:  pr_debug("Phys. mem: %lx\n", (unsigned long) lmb_phys_mem_size());
mm/init.c:#include <linux/lmb.h>
mm/init.c:      for (i = 0; i < lmb.memory.cnt; i++) {
mm/init.c:              memory_start = (u32) lmb.memory.region[i].base;
mm/init.c:              memory_end = (u32) lmb.memory.region[i].base
mm/init.c:                              + (u32) lmb.memory.region[i].size;
mm/init.c:      lmb_reserve(kernel_align_start, kernel_align_size);
mm/init.c:      lmb_reserve(PFN_UP(TOPHYS((u32)klimit)) << PAGE_SHIFT, map_size);
mm/init.c:      for (i = 0; i < lmb.reserved.cnt; i++) {
mm/init.c:                      (u32) lmb.reserved.region[i].base,
mm/init.c:                      (u32) lmb_size_bytes(&lmb.reserved, i));
mm/init.c:              reserve_bootmem(lmb.reserved.region[i].base,
mm/init.c:                      lmb_size_bytes(&lmb.reserved, i) - 1, BOOTMEM_DEFAULT);
mm/init.c:                      lmb.memory.region[0].size = memory_size;
mm/init.c:      if (!lmb.reserved.cnt) {
mm/init.c:      if ((u32) lmb.memory.region[0].size < 0x1000000) {
mm/init.c:      memory_start = (u32) lmb.memory.region[0].base;
mm/init.c:      memory_end = (u32) lmb.memory.region[0].base +
mm/init.c:                              (u32) lmb.memory.region[0].size;
mm/init.c:      lmb_reserve(kstart, ksize);
mm/init.c:              p = __va(lmb_alloc_base(PAGE_SIZE, PAGE_SIZE,
platform/generic/system.dts:                    xlnx,d-lmb = <0x1>;
platform/generic/system.dts:                    xlnx,i-lmb = <0x1>;

thought we should keep d-lmb and i-lmb, and change other lmb to memblock.

Thanks

Yinghai
