Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1GLJ1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:27:15 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50932 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab1GLJ1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:27:14 -0400
MIME-Version: 1.0
In-Reply-To: <1310389274-13995-2-git-send-email-mgorman@suse.de>
References: <1310389274-13995-1-git-send-email-mgorman@suse.de>
	<1310389274-13995-2-git-send-email-mgorman@suse.de>
Date: Tue, 12 Jul 2011 18:27:13 +0900
Message-ID: <CAEwNFnATXiQsmbfuvZNEtcpcVZkyZKRFB1SKbkEREaCW4S-aUg@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: vmscan: Do use use PF_SWAPWRITE from zone_reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Mon, Jul 11, 2011 at 10:01 PM, Mel Gorman <mgorman@suse.de> wrote:
> Zone reclaim is similar to direct reclaim in a number of respects.
> PF_SWAPWRITE is used by kswapd to avoid a write-congestion check
> but it's set also set for zone_reclaim which is inappropriate.
> Setting it potentially allows zone_reclaim users to cause large IO
> stalls which is worse than remote memory accesses.

As I read zone_reclaim_mode in vm.txt, I think it's intentional.
It has meaning of throttle the process which are writing large amounts
of data. The point is to prevent use of remote node's free memory.

And we has still the comment. If you're right, you should remove comment.
"         * and we also need to be able to write out pages for RECLAIM_WRITE
         * and RECLAIM_SWAP."


And at least, we should Cc Christoph and KOSAKI.

>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  mm/vmscan.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 4f49535..ebef213 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3063,7 +3063,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>         * and we also need to be able to write out pages for RECLAIM_WRITE
>         * and RECLAIM_SWAP.
>         */
> -       p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
> +       p->flags |= PF_MEMALLOC;
>        lockdep_set_current_reclaim_state(gfp_mask);
>        reclaim_state.reclaimed_slab = 0;
>        p->reclaim_state = &reclaim_state;
> @@ -3116,7 +3116,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>        }
>
>        p->reclaim_state = NULL;
> -       current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
> +       current->flags &= ~PF_MEMALLOC;
>        lockdep_clear_current_reclaim_state();
>        return sc.nr_reclaimed >= nr_pages;
>  }
> --
> 1.7.3.4
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kind regards,
Minchan Kim
