Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab0KIDql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:46:41 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:63419 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab0KIDqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:46:38 -0500
Date: Tue, 9 Nov 2010 12:44:26 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: avoid overflow in
 memcg_hierarchical_free_pages()
Message-Id: <20101109124426.312f9979.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <1289265320-7025-1-git-send-email-gthelen@google.com>
References: <1289265320-7025-1-git-send-email-gthelen@google.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  8 Nov 2010 17:15:20 -0800
Greg Thelen <gthelen@google.com> wrote:

> Use page counts rather than byte counts to avoid overflowing
> unsigned long local variables.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  mm/memcontrol.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6c7115d..b287afd 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1345,17 +1345,17 @@ memcg_hierarchical_free_pages(struct mem_cgroup *mem)
>  {
>  	unsigned long free, min_free;
>  
hmm, the default value of RES_LIMIT is LLONG_MAX, so I think we must declare
"free" as unsinged long long to avoid overflow.

Thanks,
Daisuke Nishimura.

> -	min_free = global_page_state(NR_FREE_PAGES) << PAGE_SHIFT;
> +	min_free = global_page_state(NR_FREE_PAGES);
>  
>  	while (mem) {
> -		free = res_counter_read_u64(&mem->res, RES_LIMIT) -
> -			res_counter_read_u64(&mem->res, RES_USAGE);
> +		free = (res_counter_read_u64(&mem->res, RES_LIMIT) -
> +			res_counter_read_u64(&mem->res, RES_USAGE)) >>
> +			PAGE_SHIFT;
>  		min_free = min(min_free, free);
>  		mem = parent_mem_cgroup(mem);
>  	}
>  
> -	/* Translate free memory in pages */
> -	return min_free >> PAGE_SHIFT;
> +	return min_free;
>  }
>  
>  /*
> -- 
> 1.7.3.1
> 
