Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab2CBWrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:47:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab2CBWry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:47:54 -0500
Message-ID: <4F514E09.5060801@redhat.com>
Date: Fri, 02 Mar 2012 17:47:37 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Satoru Moriya <satoru.moriya@hds.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [RFC][PATCH] avoid swapping out with swappiness==0
References: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com>
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 12:36 PM, Satoru Moriya wrote:
> Sometimes we'd like to avoid swapping out anonymous memory
> in particular, avoid swapping out pages of important process or
> process groups while there is a reasonable amount of pagecache
> on RAM so that we can satisfy our customers' requirements.
>
> OTOH, we can control how aggressive the kernel will swap memory pages
> with /proc/sys/vm/swappiness for global and
> /sys/fs/cgroup/memory/memory.swappiness for each memcg.
>
> But with current reclaim implementation, the kernel may swap out
> even if we set swappiness==0 and there is pagecache on RAM.
>
> This patch changes the behavior with swappiness==0. If we set
> swappiness==0, the kernel does not swap out completely
> (for global reclaim until the amount of free pages and filebacked
> pages in a zone has been reduced to something very very small
> (nr_free + nr_filebacked<  high watermark)).
>
> Any comments are welcome.
>
> Regards,
> Satoru Moriya
>
> Signed-off-by: Satoru Moriya<satoru.moriya@hds.com>
> ---
>   mm/vmscan.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c52b235..27dc3e8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1983,10 +1983,10 @@ static void get_scan_count(struct mem_cgroup_zone *mz, struct scan_control *sc,
>   	 * proportional to the fraction of recently scanned pages on
>   	 * each list that were recently referenced and in active use.
>   	 */
> -	ap = (anon_prio + 1) * (reclaim_stat->recent_scanned[0] + 1);
> +	ap = anon_prio * (reclaim_stat->recent_scanned[0] + 1);
>   	ap /= reclaim_stat->recent_rotated[0] + 1;
>
> -	fp = (file_prio + 1) * (reclaim_stat->recent_scanned[1] + 1);
> +	fp = file_prio * (reclaim_stat->recent_scanned[1] + 1);
>   	fp /= reclaim_stat->recent_rotated[1] + 1;
>   	spin_unlock_irq(&mz->zone->lru_lock);

ACK on this bit of the patch.

> @@ -1999,7 +1999,7 @@ out:
>   		unsigned long scan;
>
>   		scan = zone_nr_lru_pages(mz, lru);
> -		if (priority || noswap) {
> +		if (priority || noswap || !vmscan_swappiness(mz, sc)) {
>   			scan>>= priority;
>   			if (!scan&&  force_scan)
>   				scan = SWAP_CLUSTER_MAX;

However, I do not understand why we fail to scale
the number of pages we want to scan with priority
if "noswap".

For that matter, surely if we do not want to swap
out anonymous pages, we WANT to go into this if
branch, in order to make sure we set "scan" to 0?

scan = div64_u64(scan * fraction[file], denominator);

With your patch and swappiness=0, or no swap space, it
looks like we do not zero out "scan" and may end up
scanning anonymous pages.

Am I overlooking something?  Is this correct?

I mean, it is Friday and my brain is very full...

-- 
All rights reversed
