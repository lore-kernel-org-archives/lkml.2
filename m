Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab1AaXyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:54:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37492 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab1AaXyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:54:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 1 Feb 2011 08:48:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, nishimura@mxp.nes.nec.co.jp,
        balbir@linux.vnet.ibm.com, minchan.kim@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] memcg: prevent endless loop when charging huge
 pages
Message-Id: <20110201084829.86b7290c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1296482635-13421-2-git-send-email-hannes@cmpxchg.org>
References: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
	<1296482635-13421-2-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 15:03:53 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> The charging code can encounter a charge size that is bigger than a
> regular page in two situations: one is a batched charge to fill the
> per-cpu stocks, the other is a huge page charge.
> 
> This code is distributed over two functions, however, and only the
> outer one is aware of huge pages.  In case the charging fails, the
> inner function will tell the outer function to retry if the charge
> size is bigger than regular pages--assuming batched charging is the
> only case.  And the outer function will retry forever charging a huge
> page.
> 
> This patch makes sure the inner function can distinguish between batch
> charging and a single huge page charge.  It will only signal another
> attempt if batch charging failed, and go into regular reclaim when it
> is called on behalf of a huge page.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Thank you very much.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  mm/memcontrol.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d572102..73ea323 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1837,8 +1837,15 @@ static int __mem_cgroup_do_charge(struct mem_cgroup *mem, gfp_t gfp_mask,
>  		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
>  	} else
>  		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
> -
> -	if (csize > PAGE_SIZE) /* change csize and retry */
> +	/*
> +	 * csize can be either a huge page (HPAGE_SIZE), a batch of
> +	 * regular pages (CHARGE_SIZE), or a single regular page
> +	 * (PAGE_SIZE).
> +	 *
> +	 * Never reclaim on behalf of optional batching, retry with a
> +	 * single page instead.
> +	 */
> +	if (csize == CHARGE_SIZE)
>  		return CHARGE_RETRY;
>  
>  	if (!(gfp_mask & __GFP_WAIT))
> -- 
> 1.7.3.5
> 
> 

