Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab0DPBRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 21:17:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57110 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab0DPBRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 21:17:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Apr 2010 10:13:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-Id: <20100416101339.a501f554.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1271117878-19274-1-git-send-email-david@fromorbit.com>
References: <1271117878-19274-1-git-send-email-david@fromorbit.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Apr 2010 10:17:58 +1000
Dave Chinner <david@fromorbit.com> wrote:

> From: Dave Chinner <dchinner@redhat.com>
> 
> When we enter direct reclaim we may have used an arbitrary amount of stack
> space, and hence enterring the filesystem to do writeback can then lead to
> stack overruns. This problem was recently encountered x86_64 systems with
> 8k stacks running XFS with simple storage configurations.
> 
> Writeback from direct reclaim also adversely affects background writeback. The
> background flusher threads should already be taking care of cleaning dirty
> pages, and direct reclaim will kick them if they aren't already doing work. If
> direct reclaim is also calling ->writepage, it will cause the IO patterns from
> the background flusher threads to be upset by LRU-order writeback from
> pageout() which can be effectively random IO. Having competing sources of IO
> trying to clean pages on the same backing device reduces throughput by
> increasing the amount of seeks that the backing device has to do to write back
> the pages.
> 
> Hence for direct reclaim we should not allow ->writepages to be entered at all.
> Set up the relevant scan_control structures to enforce this, and prevent
> sc->may_writepage from being set in other places in the direct reclaim path in
> response to other events.
> 
> Reported-by: John Berthels <john@humyo.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Hmm. Then, if memoy cgroup is filled by dirty pages, it can't kick writeback
and has to wait for someone else's writeback ?

How long this will take ?
# mount -t cgroup none /cgroup -o memory
# mkdir /cgroup/A
# echo 20M > /cgroup/A/memory.limit_in_bytes
# echo $$ > /cgroup/A/tasks
# dd if=/dev/zero of=./tmpfile bs=4096 count=1000000

Can memcg ask writeback thread to "Wake Up Now! and Write this out!" effectively ?

Thanks,
-Kame

> ---
>  mm/vmscan.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e0e5f15..5321ac4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1826,10 +1826,8 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
>  		 * writeout.  So in laptop mode, write out the whole world.
>  		 */
>  		writeback_threshold = sc->nr_to_reclaim + sc->nr_to_reclaim / 2;
> -		if (total_scanned > writeback_threshold) {
> +		if (total_scanned > writeback_threshold)
>  			wakeup_flusher_threads(laptop_mode ? 0 : total_scanned);
> -			sc->may_writepage = 1;
> -		}
>  
>  		/* Take a nap, wait for some writeback to complete */
>  		if (!sc->hibernation_mode && sc->nr_scanned &&
> @@ -1871,7 +1869,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>  {
>  	struct scan_control sc = {
>  		.gfp_mask = gfp_mask,
> -		.may_writepage = !laptop_mode,
> +		.may_writepage = 0,
>  		.nr_to_reclaim = SWAP_CLUSTER_MAX,
>  		.may_unmap = 1,
>  		.may_swap = 1,
> @@ -1893,7 +1891,7 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
>  						struct zone *zone, int nid)
>  {
>  	struct scan_control sc = {
> -		.may_writepage = !laptop_mode,
> +		.may_writepage = 0,
>  		.may_unmap = 1,
>  		.may_swap = !noswap,
>  		.swappiness = swappiness,
> @@ -1926,7 +1924,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
>  {
>  	struct zonelist *zonelist;
>  	struct scan_control sc = {
> -		.may_writepage = !laptop_mode,
> +		.may_writepage = 0,
>  		.may_unmap = 1,
>  		.may_swap = !noswap,
>  		.nr_to_reclaim = SWAP_CLUSTER_MAX,
> @@ -2567,7 +2565,8 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  	struct reclaim_state reclaim_state;
>  	int priority;
>  	struct scan_control sc = {
> -		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
> +		.may_writepage = (current_is_kswapd() &&
> +					(zone_reclaim_mode & RECLAIM_WRITE)),
>  		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
>  		.may_swap = 1,
>  		.nr_to_reclaim = max_t(unsigned long, nr_pages,
> -- 
> 1.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

