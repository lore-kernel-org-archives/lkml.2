Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0CWIDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 04:03:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35464 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab0CWIDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 04:03:09 -0400
Date: Tue, 23 Mar 2010 09:02:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       benh@kernel.crashing.org, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.cy
Message-ID: <20100323080252.GA4848@elte.hu>
References: <20100322193720.GA2844@elte.hu>
 <4BA7CE1B.9070109@kernel.org>
 <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain>
 <4BA7EE72.7000507@kernel.org>
 <alpine.LFD.2.00.1003222329050.3147@localhost.localdomain>
 <4BA80019.5000900@kernel.org>
 <alpine.LFD.2.00.1003230046050.3147@localhost.localdomain>
 <4BA813A4.1010704@kernel.org>
 <alpine.LFD.2.00.1003230213260.3147@localhost.localdomain>
 <4BA8594F.8090205@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA8594F.8090205@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> please check
> 
> [PATCH 01/20] x86: add find_e820_area_node
> 
> 
> [RFC PATCH] x86: use lmb to replace early_res
> 
> still keep kernel/early_res.c for the extension.
> 
> should move those file to lib/lmb.c later?
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/Kconfig               |    1 
>  arch/x86/include/asm/e820.h    |   38 +-
>  arch/x86/include/asm/lmb.h     |    8 
>  arch/x86/kernel/e820.c         |  163 +----------
>  arch/x86/kernel/head.c         |    2 
>  arch/x86/kernel/head32.c       |    4 
>  arch/x86/kernel/head64.c       |    2 
>  arch/x86/kernel/setup.c        |    2 
>  arch/x86/kernel/setup_percpu.c |    6 
>  include/linux/early_res.h      |    9 
>  include/linux/lmb.h            |    5 
>  kernel/early_res.c             |  594 ++++++++++++++++-------------------------
>  lib/lmb.c                      |    9 
>  mm/page_alloc.c                |    2 
>  mm/sparse-vmemmap.c            |    4 
>  15 files changed, 321 insertions(+), 528 deletions(-)

That looks like a very promising direction!

There's several things to do to make the approach fully clean:

1)

I think we want to shape this as a series of simpler (and bisectable) patches.

2)

I think we also need to concentrate the changes back into LMB:

> Index: linux-2.6/include/linux/early_res.h
> ===================================================================
> --- linux-2.6.orig/include/linux/early_res.h
> +++ linux-2.6/include/linux/early_res.h
> @@ -5,15 +5,18 @@
>  extern void reserve_early(u64 start, u64 end, char *name);
>  extern void reserve_early_overlap_ok(u64 start, u64 end, char *name);
>  extern void free_early(u64 start, u64 end);
> -void free_early_partial(u64 start, u64 end);
>  extern void early_res_to_bootmem(u64 start, u64 end);
>  
> -void reserve_early_without_check(u64 start, u64 end, char *name);
>  u64 find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
>  			 u64 size, u64 align);
>  u64 find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
>  			 u64 *sizep, u64 align);
> -u64 find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align);
> +u64 find_lmb_area(u64 start, u64 end, u64 size, u64 align);
> +u64 find_lmb_area_size(u64 start, u64 *sizep, u64 align);
> +u64 find_lmb_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
> +void lmb_register_active_regions(int nid, unsigned long start_pfn,
> +					 unsigned long last_pfn);
> +u64 lmb_hole_size(u64 start, u64 end);
>  u64 get_max_mapped(void);
>  #include <linux/range.h>
>  int get_free_all_memory_range(struct range **rangep, int nodeid);

those new lmb_*() APIs should go into lmb.h.

3) 

Furthermore, i think all of early_res.c should move into lmb.c as well and we 
should eliminate kernel/early_res.c.

early_res.h will go away as well and all the new APIs will be in lmb.h.

4)

Also, we should move lib/lmb.c to mm/lmb.c, as now it's not just some optional 
library but _the_ main early-reserve memory subsystem used by the biggest 
Linux architectures.

5)

Could we perhaps also try to eliminate e820_*() method uses in arch/x86/, and 
replace them by lmb_*() API uses? (that too should be a step by step method, 
for bisectability)

> +++ linux-2.6/include/linux/lmb.h
> @@ -26,7 +26,8 @@ struct lmb_property {
>  struct lmb_region {
>  	unsigned long cnt;
>  	u64 size;
> -	struct lmb_property region[MAX_LMB_REGIONS+1];
> +	struct lmb_property *region;
> +	unsigned long region_array_size;
>  };

I suspect this should keep current LMB architectures still working, right?

	Ingo
