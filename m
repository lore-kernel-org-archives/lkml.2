Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab2LMF4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 00:56:36 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:49995 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab2LMF4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 00:56:34 -0500
Message-ID: <1355378190.1567.6.camel@kernel.cn.ibm.com>
Subject: Re: [patch 2/8] mm: vmscan: disregard swappiness shortly before
 going OOM
From: Simon Jeons <simon.jeons@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Wed, 12 Dec 2012 23:56:30 -0600
In-Reply-To: <1355348620-9382-3-git-send-email-hannes@cmpxchg.org>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
	 <1355348620-9382-3-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 16:43 -0500, Johannes Weiner wrote:
> When a reclaim scanner is doing its final scan before giving up and
> there is swap space available, pay no attention to swappiness
> preference anymore.  Just swap.
> 

Confuse! If it's final scan and still swap space available, why nr[lru]
= div64_u64(scan * fraction[file], denominator); instead of nr[lru] =
scan; ? 

> Note that this change won't make too big of a difference for general
> reclaim: anonymous pages are already force-scanned when there is only
> very little file cache left, and there very likely isn't when the
> reclaimer enters this final cycle.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3874dcb..6e53446 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1751,7 +1751,7 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  		unsigned long scan;
>  
>  		scan = get_lru_size(lruvec, lru);
> -		if (sc->priority || noswap || !vmscan_swappiness(sc)) {
> +		if (sc->priority || noswap) {
>  			scan >>= sc->priority;
>  			if (!scan && force_scan)
>  				scan = SWAP_CLUSTER_MAX;


