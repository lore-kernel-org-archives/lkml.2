Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1HKXog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 19:44:36 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48074 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab1HKXof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 19:44:35 -0400
MIME-Version: 1.0
In-Reply-To: <1313094715-31187-2-git-send-email-jweiner@redhat.com>
References: <1313094715-31187-1-git-send-email-jweiner@redhat.com>
	<1313094715-31187-2-git-send-email-jweiner@redhat.com>
Date: Fri, 12 Aug 2011 08:44:34 +0900
Message-ID: <CAEwNFnBp7JBWpuaT=ZKDyfQTQqOe_mT0CLFAw9LWo10GoXaFnQ@mail.gmail.com>
Subject: Re: [patch 2/2] mm: vmscan: drop nr_force_scan[] from get_scan_count
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Balbir Singh <bsingharora@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 5:31 AM, Johannes Weiner <jweiner@redhat.com> wrote:
> The nr_force_scan[] tuple holds the effective scan numbers for anon
> and file pages in case the situation called for a forced scan and the
> regularly calculated scan numbers turned out zero.
>
> However, the effective scan number can always be assumed to be
> SWAP_CLUSTER_MAX right before the division into anon and file.  The
> numerators and denominator are properly set up for all cases, be it
> force scan for just file, just anon, or both, to do the right thing.
>
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

There is a nitpick at below.

> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Ying Han <yinghan@google.com>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/vmscan.c |   24 ++----------------------
>  1 files changed, 2 insertions(+), 22 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 96061d7..45f0986 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1831,7 +1831,6 @@ static void get_scan_count(struct zone *zone, struct scan_control *sc,
>        enum lru_list l;
>        int noswap = 0;
>        bool force_scan = false;
> -       unsigned long nr_force_scan[2];
>
>        /* kswapd does zone balancing and need to scan this zone */
>        if (scanning_global_lru(sc) && current_is_kswapd())
> @@ -1846,8 +1845,6 @@ static void get_scan_count(struct zone *zone, struct scan_control *sc,
>                fraction[0] = 0;
>                fraction[1] = 1;
>                denominator = 1;
> -               nr_force_scan[0] = 0;
> -               nr_force_scan[1] = SWAP_CLUSTER_MAX;
>                goto out;
>        }
>
> @@ -1864,8 +1861,6 @@ static void get_scan_count(struct zone *zone, struct scan_control *sc,
>                        fraction[0] = 1;
>                        fraction[1] = 0;
>                        denominator = 1;
> -                       nr_force_scan[0] = SWAP_CLUSTER_MAX;
> -                       nr_force_scan[1] = 0;
>                        goto out;
>                }
>        }
> @@ -1914,11 +1909,6 @@ static void get_scan_count(struct zone *zone, struct scan_control *sc,
>        fraction[0] = ap;
>        fraction[1] = fp;
>        denominator = ap + fp + 1;
> -       if (force_scan) {
> -               unsigned long scan = SWAP_CLUSTER_MAX;
> -               nr_force_scan[0] = div64_u64(scan * ap, denominator);
> -               nr_force_scan[1] = div64_u64(scan * fp, denominator);
> -       }
>  out:
>        for_each_evictable_lru(l) {
>                int file = is_file_lru(l);
> @@ -1927,20 +1917,10 @@ out:
>                scan = zone_nr_lru_pages(zone, sc, l);
>                if (priority || noswap) {
>                        scan >>= priority;
> +                       if (!scan && force_scan)
> +                               scan = SWAP_CLUSTER_MAX;
>                        scan = div64_u64(scan * fraction[file], denominator);
>                }
> -
> -               /*
> -                * If zone is small or memcg is small, nr[l] can be 0.
> -                * This results no-scan on this priority and priority drop down.
> -                * For global direct reclaim, it can visit next zone and tend
> -                * not to have problems. For global kswapd, it's for zone
> -                * balancing and it need to scan a small amounts. When using
> -                * memcg, priority drop can cause big latency. So, it's better
> -                * to scan small amount. See may_noscan above.
> -                */

Please move this comment with tidy-up at where making force_scan true.
Of course, we can find it by git log[246e87a9393] but as I looked the
git log, it explain this comment indirectly and it's not
understandable to newbies. I think this comment is more understandable
than changelog in git.



-- 
Kind regards,
Minchan Kim
