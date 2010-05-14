Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab0ENCd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:33:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:35458 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756953Ab0ENCd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:33:27 -0400
Subject: Re: [PATCH 14/35] x86, lmb: Add lmb_memory_size()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273796396-29649-15-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-15-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 12:31:45 +1000
Message-ID: <1273804305.21352.393.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
> It will return memory size in specified range according to lmb.memory.region
> 
> Try to share some code with lmb_free_memory_size() by passing get_free to
> __lmb_memory_size().

Same comments as previous patch.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/include/asm/lmb.h |    1 +
>  arch/x86/mm/lmb.c          |   18 +++++++++++++++++-
>  2 files changed, 18 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
> index 4fb94b5..dd42ac1 100644
> --- a/arch/x86/include/asm/lmb.h
> +++ b/arch/x86/include/asm/lmb.h
> @@ -17,5 +17,6 @@ void lmb_register_active_regions(int nid, unsigned long start_pfn,
>  u64 lmb_hole_size(u64 start, u64 end);
>  u64 lmb_find_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
>  u64 lmb_free_memory_size(u64 addr, u64 limit);
> +u64 lmb_memory_size(u64 addr, u64 limit);
>  
>  #endif
> diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
> index 6c69e99..19a5f49 100644
> --- a/arch/x86/mm/lmb.c
> +++ b/arch/x86/mm/lmb.c
> @@ -226,7 +226,7 @@ void __init lmb_to_bootmem(u64 start, u64 end)
>  }
>  #endif
>  
> -u64 __init lmb_free_memory_size(u64 addr, u64 limit)
> +static u64 __init __lmb_memory_size(u64 addr, u64 limit, bool get_free)
>  {
>  	int i, count;
>  	struct range *range;
> @@ -256,6 +256,10 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
>  	}
>  	subtract_range(range, count, 0, addr);
>  	subtract_range(range, count, limit, -1ULL);
> +
> +	/* Subtract lmb.reserved.region in range ? */
> +	if (!get_free)
> +		goto sort_and_count_them;
>  	for (i = 0; i < lmb.reserved.cnt; i++) {
>  		struct lmb_region *r = &lmb.reserved.regions[i];
>  
> @@ -268,6 +272,8 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
>  
>  		subtract_range(range, count, final_start, final_end);
>  	}
> +
> +sort_and_count_them:
>  	nr_range = clean_sort_range(range, count);
>  
>  	free_size = 0;
> @@ -277,6 +283,16 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
>  	return free_size << PAGE_SHIFT;
>  }
>  
> +u64 __init lmb_free_memory_size(u64 addr, u64 limit)
> +{
> +	return __lmb_memory_size(addr, limit, true);
> +}
> +
> +u64 __init lmb_memory_size(u64 addr, u64 limit)
> +{
> +	return __lmb_memory_size(addr, limit, false);
> +}
> +
>  void __init lmb_add_memory(u64 start, u64 end)
>  {
>  	lmb_add_region(&lmb.memory, start, end - start);


