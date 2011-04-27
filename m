Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1D0IsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:48:22 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56315 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1D0IsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:48:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uBA0ITg2fGHqlkxAGl8fzvA2Z8Ii2UaBBqdTf5aopeVVIuFulPCBlidQwNOJ8xvWdY
         psYhHCM9ZKSwZmpmUXh0iX4o1VAWPVFl4riEVj4TeH3Ex/96p3D4THatHZxKxnKmgQyb
         rBpJeXHd1lSC9d+kbdlwh5gCTVX0eXzmbIl6g=
MIME-Version: 1.0
In-Reply-To: <20110427164708.1143395e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110427164708.1143395e.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 27 Apr 2011 17:48:18 +0900
Message-ID: <BANLkTin+rDOWGYq9dg-XcCWs+yT8Yw-VMw@mail.gmail.com>
Subject: Re: [PATCHv3] memcg: fix get_scan_count for small targets
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "mgorman@suse.de" <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 4:47 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> At memory reclaim, we determine the number of pages to be scanned
> per zone as
>        (anon + file) >> priority.
> Assume
>        scan = (anon + file) >> priority.
>
> If scan < SWAP_CLUSTER_MAX, the scan will be skipped for this time
> and priority gets higher. This has some problems.
>
>  1. This increases priority as 1 without any scan.
>     To do scan in this priority, amount of pages should be larger than 512M.
>     If pages>>priority < SWAP_CLUSTER_MAX, it's recorded and scan will be
>     batched, later. (But we lose 1 priority.)
>     If memory size is below 16M, pages >> priority is 0 and no scan in
>     DEF_PRIORITY forever.
>
>  2. If zone->all_unreclaimabe==true, it's scanned only when priority==0.
>     So, x86's ZONE_DMA will never be recoverred until the user of pages
>     frees memory by itself.
>
>  3. With memcg, the limit of memory can be small. When using small memcg,
>     it gets priority < DEF_PRIORITY-2 very easily and need to call
>     wait_iff_congested().
>     For doing scan before priorty=9, 64MB of memory should be used.
>
> Then, this patch tries to scan SWAP_CLUSTER_MAX of pages in force...when
>
>  1. the target is enough small.
>  2. it's kswapd or memcg reclaim.
>
> Then we can avoid rapid priority drop and may be able to recover
> all_unreclaimable in a small zones. And this patch removes nr_saved_scan.
> This will allow scanning in this priority even when pages >> priority
> is very small.
>
> Changelog v2->v3
>  - removed nr_saved_scan completely.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

The patch looks good to me but I have a nitpick about just coding style.
How about this? I think below looks better but it's just my private
opinion and I can't insist on my style. If you don't mind it, ignore.

barrios@barrios-desktop:~/linux-2.6$ git diff
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6771ea7..268e7d4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1817,8 +1817,28 @@ out:
                        scan >>= priority;
                        scan = div64_u64(scan * fraction[file], denominator);
                }
-               nr[l] = nr_scan_try_batch(scan,
-                                         &reclaim_stat->nr_saved_scan[l]);
+
+               nr[l] = scan;
+               if (scan)
+                       continue;
+               /*
+                * If zone is small or memcg is small, nr[l] can be 0.
+                * This results no-scan on this priority and priority drop down.
+                * For global direct reclaim, it can visit next zone and tend
+                * not to have problems. For global kswapd, it's for zone
+                * balancing and it need to scan a small amounts. When using
+                * memcg, priority drop can cause big latency. So, it's better
+                * to scan small amount. See may_noscan above.
+                */
+               if (((anon + file) >> priority) < SWAP_CLUSTER_MAX) {
+                       /* kswapd does zone balancing and need to scan
this zone */
+                       /* memcg may have small limit and need to
avoid priority drop */
+                       if ((scanning_global_lru(sc) && current_is_kswapd())
+                                       || !scanning_global_lru(sc)) {
+                               if (file || !noswap)
+                                       nr[l] = SWAP_CLUSTER_MAX;
+                       }
+               }
        }
 }


-- 
Kind regards,
Minchan Kim
