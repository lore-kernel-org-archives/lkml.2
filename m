Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab1KBRyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:54:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38495 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab1KBRyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:54:41 -0400
Message-ID: <4EB183CF.6050300@jp.fujitsu.com>
Date: Wed, 02 Nov 2011 10:54:23 -0700
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: jweiner@redhat.com
CC: khlebnikov@parallels.com, penberg@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com,
        hannes@cmpxchg.org, riel@redhat.com, mel@csn.ul.ie,
        minchan.kim@gmail.com, gene.heskett@gmail.com
Subject: Re: [rfc 1/3] mm: vmscan: never swap under low memory pressure
References: <20110808110658.31053.55013.stgit@localhost6> <CAOJsxLF909NRC2r6RL+hm1ARve+3mA6UM_CY9epJaauyqJTG8w@mail.gmail.com> <4E3FD403.6000400@parallels.com> <20111102163056.GG19965@redhat.com> <20111102163141.GH19965@redhat.com>
In-Reply-To: <20111102163141.GH19965@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---
>  mm/vmscan.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a90c603..39d3da3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -831,6 +831,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  		 * Try to allocate it some swap space here.l
>  		 */
>  		if (PageAnon(page) && !PageSwapCache(page)) {
> +			if (priority >= DEF_PRIORITY - 2)
> +				goto keep_locked;
>  			if (!(sc->gfp_mask & __GFP_IO))
>  				goto keep_locked;
>  			if (!add_to_swap(page))

Hehe, i tried very similar way very long time ago. Unfortunately, it doesn't work.
"DEF_PRIORITY - 2" is really poor indicator for reclaim pressure. example, if the
machine have 1TB memory, DEF_PRIORITY-2 mean 1TB>>10 = 1GB. It't too big.

