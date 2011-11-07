Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab1KGCay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 21:30:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45451 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab1KGCax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 21:30:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 7 Nov 2011 11:29:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@parallels.com>,
        Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [rfc 1/3] mm: vmscan: never swap under low memory pressure
Message-Id: <20111107112941.0dfa07cb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111102163141.GH19965@redhat.com>
References: <20110808110658.31053.55013.stgit@localhost6>
	<CAOJsxLF909NRC2r6RL+hm1ARve+3mA6UM_CY9epJaauyqJTG8w@mail.gmail.com>
	<4E3FD403.6000400@parallels.com>
	<20111102163056.GG19965@redhat.com>
	<20111102163141.GH19965@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Nov 2011 17:31:41 +0100
Johannes Weiner <jweiner@redhat.com> wrote:

> We want to prevent floods of used-once file cache pushing us to swap
> out anonymous pages.  Never swap under a certain priority level.  The
> availability of used-once cache pages should prevent us from reaching
> that threshold.
> 
> This is needed because subsequent patches will revert some of the
> mechanisms that tried to prefer file over anon, and this should not
> result in more eager swapping again.
> 
> It might also be better to keep the aging machinery going and just not
> swap, rather than staying away from anonymous pages in the first place
> and having less useful age information at the time of swapout.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> ---
>  mm/vmscan.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a90c603..39d3da3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -831,6 +831,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  		 * Try to allocate it some swap space here.
>  		 */
>  		if (PageAnon(page) && !PageSwapCache(page)) {
> +			if (priority >= DEF_PRIORITY - 2)
> +				goto keep_locked;
>  			if (!(sc->gfp_mask & __GFP_IO))
>  				goto keep_locked;
>  			if (!add_to_swap(page))

Hm, how about not scanning LRU_ANON rather than checking here ?
Add some bias to get_scan_count() or some..
If you think to need rotation of LRU, only kswapd should do that..

Thanks,
-Kame

