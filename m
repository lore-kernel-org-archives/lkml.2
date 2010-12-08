Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab0LHXKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:10:20 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:33745 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab0LHXKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:10:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HbgyImbC3Ktydh/1OpG+3NoosP5zyjAw8OoQnix7XDm/sHXR1JCZuRYfVmhdyHIasp
         AOxbaUaK04WTKfI2CKppSADUjeZV0EKvKLtFqHOr5HQiaOp4OAvTee43IzkGwT3iMlAd
         BanURzd8ip8ISVH9+QmvZOCgGXEnmTFJcs/xU=
MIME-Version: 1.0
In-Reply-To: <87oc8wa063.fsf@gmail.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
	<0724024711222476a0c8deadb5b366265b8e5824.1291568905.git.minchan.kim@gmail.com>
	<20101208170504.1750.A69D9226@jp.fujitsu.com>
	<AANLkTikG1EAMm8yPvBVUXjFz1Bu9m+vfwH3TRPDzS9mq@mail.gmail.com>
	<87oc8wa063.fsf@gmail.com>
Date: Thu, 9 Dec 2010 08:10:17 +0900
Message-ID: <AANLkTin642NFLMubtCQhSVUNLzfdk5ajz-RWe2zT+Lw6@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] Reclaim invalidated page ASAP
From: Minchan Kim <minchan.kim@gmail.com>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 10:01 PM, Ben Gamari <bgamari.foss@gmail.com> wrote:
>> Make sense to me. If Ben is busy, I will measure it and send the result.
>
> I've done measurements on the patched kernel. All that remains is to do
> measurements on the baseline unpached case. To summarize the results
> thusfar,
>
> Times:
> =======
>                       user    sys     %cpu    inputs           outputs
> Patched, drop          142     64      46      13557744         14052744
> Patched, nodrop        55      57      33      13557936         13556680
>
> vmstat:
> ========
>                        free_pages      inact_anon      act_anon        inact_file      act_file        dirtied      written  reclaim
> Patched, drop, pre      306043          37541           185463          276266          153955          3689674      3604959  1550641
> Patched, drop, post     13233           38462           175252          536346          178792          5527564      5371563  3169155
>
> Patched, nodrop, pre    475211          38602           175242          81979           178820          5527592      5371554  3169155
> Patched, nodrop, post   7697            38959           176986          547984          180855          7324836      7132158  3169155
>
> Altogether, it seems that something is horribly wrong, most likely with
> my test (or rsync patch). I'll do the baseline benchmarks today.
>
> Thoughts?


How do you test it?
I think patch's effect would be good in big memory pressure environment.

Quickly I did it on my desktop environment.(2G DRAM)
So it's not completed result. I will test more when out of office.

Used kernel : mmotm-12-02 + my patch series
Used rsync :
1. rsync_normal : v3.0.7 vanilla
2. rsync_patch : v3.0.7 + Ben's patch(fadvise)

Test scenario :
* kernel full compile
* git clone linux-kernel
* rsync local host directory to local host dst directory


1) rsync_normal : 89.08user 127.48system 33:22.24elapsed
2) rsync_patch : 88.42user 135.26system 31:30.56elapsed

1) rsync_normal vmstat :
pgfault : 45538203
pgmajfault : 4181

pgactivate 377416
pgdeactivate 34183
pginvalidate 0
pgreclaim 0

pgsteal_dma 0
pgsteal_normal 2144469
pgsteal_high 2884412
pgsteal_movable 0
pgscan_kswapd_dma 0
pgscan_kswapd_normal 2149739
pgscan_kswapd_high 2909140
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_normal 647
pgscan_direct_high 716
pgscan_direct_movable 0
pginodesteal 0
slabs_scanned 1737344
kswapd_steal 5028353
kswapd_inodesteal 438910
pageoutrun 81208
allocstall 9
pgrotated 1642

2) rsync_patch vmstat:

pgfault : 47570231
pgmajfault : 2669

pgactivate 391806
pgdeactivate 36861
pginvalidate 1685065
pgreclaim 1685065

pgrefill_dma 0
pgrefill_normal 32025
pgrefill_high 9619
pgrefill_movable 0
pgsteal_dma 0
pgsteal_normal 744904
pgsteal_high 1079709
pgsteal_movable 0
pgscan_kswapd_dma 0
pgscan_kswapd_normal 745017
pgscan_kswapd_high 1096660
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_normal 0
pgscan_direct_high 0
pgscan_direct_movable 0
pginodesteal 0
slabs_scanned 1896960
kswapd_steal 1824613
kswapd_inodesteal 703499
pageoutrun 26828
allocstall 0
pgrotated 1681570

In summary,
Unfortunately, the number of fault is increased (47570231 - 45538203)
but pgmajfault is reduced (4181 - 2669).

The number of scanning is much reduced. 2149739 -> 745017, 2909140 ->
1096660 and even no direct reclaim in patched rsync.

The number of steal is much reduced. 2144469 -> 744904, 2884412 ->
1079709, 5028353 -> 1824613.

The elapsed time is reduced 2 minutes.

I think result is good. Reduced the steal number could imply prevent
eviction of working set pages.

It has a good result with small effort(small scanning).

I will resend with more exact measurement after repeated test.

> Thanks,
>
> - Ben
>
>



-- 
Kind regards,
Minchan Kim
