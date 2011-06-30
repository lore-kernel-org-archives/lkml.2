Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab1F3JGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 05:06:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51361 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1F3JGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:06:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E0C3C77.8010608@jp.fujitsu.com>
Date: Thu, 30 Jun 2011 18:05:59 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: mgorman@suse.de
CC: akpm@linux-foundation.org, P@draigBrady.com,
        James.Bottomley@HansenPartnership.com, colin.king@canonical.com,
        minchan.kim@gmail.com, luto@mit.edu, riel@redhat.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm: vmscan: Only read new_classzone_idx from pgdat
 when reclaiming successfully
References: <1308926697-22475-1-git-send-email-mgorman@suse.de> <1308926697-22475-5-git-send-email-mgorman@suse.de>
In-Reply-To: <1308926697-22475-5-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/24 23:44), Mel Gorman wrote:
> During allocator-intensive workloads, kswapd will be woken frequently
> causing free memory to oscillate between the high and min watermark.
> This is expected behaviour.  Unfortunately, if the highest zone is
> small, a problem occurs.
> 
> When balance_pgdat() returns, it may be at a lower classzone_idx than
> it started because the highest zone was unreclaimable. Before checking
> if it should go to sleep though, it checks pgdat->classzone_idx which
> when there is no other activity will be MAX_NR_ZONES-1. It interprets
> this as it has been woken up while reclaiming, skips scheduling and
> reclaims again. As there is no useful reclaim work to do, it enters
> into a loop of shrinking slab consuming loads of CPU until the highest
> zone becomes reclaimable for a long period of time.
> 
> There are two problems here. 1) If the returned classzone or order is
> lower, it'll continue reclaiming without scheduling. 2) if the highest
> zone was marked unreclaimable but balance_pgdat() returns immediately
> at DEF_PRIORITY, the new lower classzone is not communicated back to
> kswapd() for sleeping.
> 
> This patch does two things that are related. If the end_zone is
> unreclaimable, this information is communicated back. Second, if
> the classzone or order was reduced due to failing to reclaim, new
> information is not read from pgdat and instead an attempt is made to go
> to sleep. Due to this, it is also necessary that pgdat->classzone_idx
> be initialised each time to pgdat->nr_zones - 1 to avoid re-reads
> being interpreted as wakeups.
> 
> Reported-and-tested-by: Pádraig Brady <P@draigBrady.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  mm/vmscan.c |   34 +++++++++++++++++++++-------------
>  1 files changed, 21 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a76b6cc2..fe854d7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2448,7 +2448,6 @@ loop_again:
>  			if (!zone_watermark_ok_safe(zone, order,
>  					high_wmark_pages(zone), 0, 0)) {
>  				end_zone = i;
> -				*classzone_idx = i;
>  				break;
>  			}
>  		}
> @@ -2528,8 +2527,11 @@ loop_again:
>  			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
>  				sc.may_writepage = 1;
>  
> -			if (zone->all_unreclaimable)
> +			if (zone->all_unreclaimable) {
> +				if (end_zone && end_zone == i)
> +					end_zone--;
>  				continue;
> +			}
>  
>  			if (!zone_watermark_ok_safe(zone, order,
>  					high_wmark_pages(zone), end_zone, 0)) {
> @@ -2709,8 +2711,8 @@ static void kswapd_try_to_sleep(pg_data_t *pgdat, int order, int classzone_idx)
>   */
>  static int kswapd(void *p)
>  {
> -	unsigned long order;
> -	int classzone_idx;
> +	unsigned long order, new_order;
> +	int classzone_idx, new_classzone_idx;
>  	pg_data_t *pgdat = (pg_data_t*)p;
>  	struct task_struct *tsk = current;
>  
> @@ -2740,17 +2742,23 @@ static int kswapd(void *p)
>  	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
>  	set_freezable();
>  
> -	order = 0;
> -	classzone_idx = MAX_NR_ZONES - 1;
> +	order = new_order = 0;
> +	classzone_idx = new_classzone_idx = pgdat->nr_zones - 1;
>  	for ( ; ; ) {
> -		unsigned long new_order;
> -		int new_classzone_idx;
>  		int ret;
>  
> -		new_order = pgdat->kswapd_max_order;
> -		new_classzone_idx = pgdat->classzone_idx;
> -		pgdat->kswapd_max_order = 0;
> -		pgdat->classzone_idx = MAX_NR_ZONES - 1;
> +		/*
> +		 * If the last balance_pgdat was unsuccessful it's unlikely a
> +		 * new request of a similar or harder type will succeed soon
> +		 * so consider going to sleep on the basis we reclaimed at
> +		 */
> +		if (classzone_idx >= new_classzone_idx && order == new_order) {

I'm confusing this. If we take a following scenario, new_classzone_idx may be garbage.

1. new_classzone_idx = pgdat->classzone_idx
2. kswapd_try_to_sleep()
3. classzone_idx = pgdat->classzone_idx
4. balance_pgdat()

Wouldn't we need to reinitialize new_classzone_idx nad new_order at kswapd_try_to_sleep()
path too?



> +			new_order = pgdat->kswapd_max_order;
> +			new_classzone_idx = pgdat->classzone_idx;
> +			pgdat->kswapd_max_order =  0;
> +			pgdat->classzone_idx = pgdat->nr_zones - 1;
> +		}
> +
>  		if (order < new_order || classzone_idx > new_classzone_idx) {
>  			/*
>  			 * Don't sleep if someone wants a larger 'order'

