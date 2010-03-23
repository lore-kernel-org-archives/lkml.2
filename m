Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab0CWJEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 05:04:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:47596 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab0CWJEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 05:04:51 -0400
Message-ID: <4BA883C0.2070102@kernel.org>
Date: Tue, 23 Mar 2010 02:02:56 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       benh@kernel.crashing.org, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.cy
References: <20100322193720.GA2844@elte.hu> <4BA7CE1B.9070109@kernel.org> <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain> <4BA7EE72.7000507@kernel.org> <alpine.LFD.2.00.1003222329050.3147@localhost.localdomain> <4BA80019.5000900@kernel.org> <alpine.LFD.2.00.1003230046050.3147@localhost.localdomain> <4BA813A4.1010704@kernel.org> <alpine.LFD.2.00.1003230213260.3147@localhost.localdomain> <4BA8594F.8090205@kernel.org> <20100323080252.GA4848@elte.hu>
In-Reply-To: <20100323080252.GA4848@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2010 01:02 AM, Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> please check
>>
>> [PATCH 01/20] x86: add find_e820_area_node
>>
>>
>> [RFC PATCH] x86: use lmb to replace early_res
>>
>> still keep kernel/early_res.c for the extension.
>>
>> should move those file to lib/lmb.c later?
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/Kconfig               |    1 
>>  arch/x86/include/asm/e820.h    |   38 +-
>>  arch/x86/include/asm/lmb.h     |    8 
>>  arch/x86/kernel/e820.c         |  163 +----------
>>  arch/x86/kernel/head.c         |    2 
>>  arch/x86/kernel/head32.c       |    4 
>>  arch/x86/kernel/head64.c       |    2 
>>  arch/x86/kernel/setup.c        |    2 
>>  arch/x86/kernel/setup_percpu.c |    6 
>>  include/linux/early_res.h      |    9 
>>  include/linux/lmb.h            |    5 
>>  kernel/early_res.c             |  594 ++++++++++++++++-------------------------
>>  lib/lmb.c                      |    9 
>>  mm/page_alloc.c                |    2 
>>  mm/sparse-vmemmap.c            |    4 
>>  15 files changed, 321 insertions(+), 528 deletions(-)
> 
> That looks like a very promising direction!
> 
> There's several things to do to make the approach fully clean:
> 
> 1)
> 
> I think we want to shape this as a series of simpler (and bisectable) patches.

will check it.

at least change include/linux/lmb.h and lib/lmb.c change could be sperated.

other looks a little bit hard.
> 
> 2)
> 
> I think we also need to concentrate the changes back into LMB:

yes. put them in kernel/early_res.c and move them to lmb.c if lmb gugs are happy with the change.

> 
>> Index: linux-2.6/include/linux/early_res.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/early_res.h
>> +++ linux-2.6/include/linux/early_res.h
>> @@ -5,15 +5,18 @@
>>  extern void reserve_early(u64 start, u64 end, char *name);
>>  extern void reserve_early_overlap_ok(u64 start, u64 end, char *name);
>>  extern void free_early(u64 start, u64 end);
>> -void free_early_partial(u64 start, u64 end);
>>  extern void early_res_to_bootmem(u64 start, u64 end);
>>  
>> -void reserve_early_without_check(u64 start, u64 end, char *name);
>>  u64 find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
>>  			 u64 size, u64 align);
>>  u64 find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
>>  			 u64 *sizep, u64 align);
>> -u64 find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align);
>> +u64 find_lmb_area(u64 start, u64 end, u64 size, u64 align);
>> +u64 find_lmb_area_size(u64 start, u64 *sizep, u64 align);
>> +u64 find_lmb_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
>> +void lmb_register_active_regions(int nid, unsigned long start_pfn,
>> +					 unsigned long last_pfn);
>> +u64 lmb_hole_size(u64 start, u64 end);
>>  u64 get_max_mapped(void);
>>  #include <linux/range.h>
>>  int get_free_all_memory_range(struct range **rangep, int nodeid);
> 
> those new lmb_*() APIs should go into lmb.h.

next version

> 
> 3) 
> 
> Furthermore, i think all of early_res.c should move into lmb.c as well and we 
> should eliminate kernel/early_res.c.
> 
> early_res.h will go away as well and all the new APIs will be in lmb.h.

current have three levels
a. old lmb users
b. x86 with bootmem
c. x86 with no-bootmem

some functions later could be moved to new bootmem.c

> 
> 4)
> 
> Also, we should move lib/lmb.c to mm/lmb.c, as now it's not just some optional 
> library but _the_ main early-reserve memory subsystem used by the biggest 
> Linux architectures.

yes

> 
> 5)
> 
> Could we perhaps also try to eliminate e820_*() method uses in arch/x86/, and 
> replace them by lmb_*() API uses? (that too should be a step by step method, 
> for bisectability)

yes.

except e820_any_mapped(,,E820_RESERVED)

others should not be used after fill_lmb_memory()

> 
>> +++ linux-2.6/include/linux/lmb.h
>> @@ -26,7 +26,8 @@ struct lmb_property {
>>  struct lmb_region {
>>  	unsigned long cnt;
>>  	u64 size;
>> -	struct lmb_property region[MAX_LMB_REGIONS+1];
>> +	struct lmb_property *region;
>> +	unsigned long region_array_size;
>>  };
> 
> I suspect this should keep current LMB architectures still working, right?

they are still working. lmb_init will connect the pointers. 

Index: linux-2.6/lib/lmb.c
===================================================================
--- linux-2.6.orig/lib/lmb.c
+++ linux-2.6/lib/lmb.c
@@ -18,6 +18,8 @@
 #define LMB_ALLOC_ANYWHERE     0
 
 struct lmb lmb;
+struct lmb_property lmb_memory_region[MAX_LMB_REGIONS + 1];
+struct lmb_property lmb_reserved_region[MAX_LMB_REGIONS + 1];
 
 static int lmb_debug;
 
@@ -106,6 +108,11 @@ static void lmb_coalesce_regions(struct
 
 void __init lmb_init(void)
 {
+       lmb.memory.region   = lmb_memory_region;
+       lmb.memory.region_array_size   = ARRAY_SIZE(lmb_memory_region);
+       lmb.reserved.region = lmb_reserved_region;
+       lmb.reserved.region_array_size = ARRAY_SIZE(lmb_reserved_region);
+
        /* Create a dummy zero size LMB which will get coalesced away later.
         * This simplifies the lmb_add() code below...
         */
@@ -169,7 +176,7 @@ static long lmb_add_region(struct lmb_re
 
        if (coalesced)
                return coalesced;
-       if (rgn->cnt >= MAX_LMB_REGIONS)
+       if (rgn->cnt >= (rgn->region_array_size - 1))
                return -1;

Thanks

Yinghai
