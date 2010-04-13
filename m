Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab0DMEUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 00:20:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:47904 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab0DMEUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 00:20:46 -0400
Subject: Re: [PATCH 15/39] lmb: Add lmb_find_area_node()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1270793048-23796-16-git-send-email-yinghai@kernel.org>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
	 <1270793048-23796-16-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 14:18:50 +1000
Message-ID: <1271132330.13059.64.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 23:03 -0700, Yinghai Lu wrote:
> It can be used to find NODE_DATA for numa.
> 
> Need to make sure early_node_map[] is filled before it is called, otherwise
> it will fallback to lmb_find_area(), with node range.

Isn't that more duplication from what's already in there for nid
handling ? (Which btw may not be optimal, simply what I'm saying is that
all that stuff should be factored).

Cheers,
Ben.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/lmb.h |    1 +
>  mm/lmb.c            |   15 +++++++++++++++
>  2 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/lmb.h b/include/linux/lmb.h
> index 5dbc4ef..4078825 100644
> --- a/include/linux/lmb.h
> +++ b/include/linux/lmb.h
> @@ -91,6 +91,7 @@ void lmb_add_memory(u64 start, u64 end);
>  u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
>  			 u64 size, u64 align);
>  u64 lmb_find_area(u64 start, u64 end, u64 size, u64 align);
> +u64 lmb_find_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
>  
>  void lmb_to_bootmem(u64 start, u64 end);
>  struct range;
> diff --git a/mm/lmb.c b/mm/lmb.c
> index cf0f1c9..d3a58fb 100644
> --- a/mm/lmb.c
> +++ b/mm/lmb.c
> @@ -791,6 +791,21 @@ u64 __init __weak lmb_find_area(u64 start, u64 end, u64 size, u64 align)
>  	return -1ULL;
>  }
>  /*
> + * Need to call this function after lmb_register_active_regions,
> + * so early_node_map[] is filled already.
> + */
> +u64 __init lmb_find_area_node(int nid, u64 start, u64 end, u64 size, u64 align)
> +{
> +	u64 addr;
> +	addr = find_memory_core_early(nid, size, align, start, end);
> +	if (addr != -1ULL)
> +		return addr;
> +
> +	/* Fallback, should already have start end within node range */
> +	return lmb_find_area(start, end, size, align);
> +}
> +
> +/*
>   * Finds an active region in the address range from start_pfn to last_pfn and
>   * returns its range in ei_startpfn and ei_endpfn for the lmb entry.
>   */


