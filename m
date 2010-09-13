Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab0IMXKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 19:10:23 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50359 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0IMXKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 19:10:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q6HzbLtxrNHja874W4YbQq8p0g4L3DWMZIs885uurUm5Ppww+S5Y0e1fxkem434P6P
         399hZD4+dnluMzYZkDXEOI59+fgzo7g/5tyZSRg2+vKD2VQ2zREE0zoR/Ne7zw5P+TAm
         XIVoy9kAl0DmjZTwaG84TMYejrvLqHT/xvf2I=
MIME-Version: 1.0
In-Reply-To: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
Date: Tue, 14 Sep 2010 08:10:21 +0900
Message-ID: <AANLkTinq6v3-NKjszYVOR3qxr-UVNoGw0uQjBGcoifVs@mail.gmail.com>
Subject: Re: [PATCH 0/9] Reduce latencies and improve overall reclaim
 efficiency v1
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 6, 2010 at 7:47 PM, Mel Gorman <mel@csn.ul.ie> wrote:

<snip>

>
> These are just the raw figures taken from /proc/vmstat. It's a rough measure
> of reclaim activity. Note that allocstall counts are higher because we
> are entering direct reclaim more often as a result of not sleeping in
> congestion. In itself, it's not necessarily a bad thing. It's easier to
> get a view of what happened from the vmscan tracepoint report.
>
> FTrace Reclaim Statistics: vmscan
>            micro-traceonly-v1r5-micromicro-nocongest-v1r5-micromicro-lowlumpy-v1r5-micromicro-nodirect-v1r5-micro
>                traceonly-v1r5    nocongest-v1r5     lowlumpy-v1r5     nodirect-v1r5
> Direct reclaims                                152        941        967        729
> Direct reclaim pages scanned                507377    1404350    1332420    1450213
> Direct reclaim pages reclaimed               10968      72042      77186      41097
> Direct reclaim write file async I/O              0          0          0          0
> Direct reclaim write anon async I/O              0          0          0          0
> Direct reclaim write file sync I/O               0          0          0          0
> Direct reclaim write anon sync I/O               0          0          0          0
> Wake kswapd requests                        127195     241025     254825     188846
> Kswapd wakeups                                   6          1          1          1
> Kswapd pages scanned                       4210101    3345122    3427915    3306356
> Kswapd pages reclaimed                     2228073    2165721    2143876    2194611
> Kswapd reclaim write file async I/O              0          0          0          0
> Kswapd reclaim write anon async I/O              0          0          0          0
> Kswapd reclaim write file sync I/O               0          0          0          0
> Kswapd reclaim write anon sync I/O               0          0          0          0
> Time stalled direct reclaim (seconds)         7.60       3.03       3.24       3.43
> Time kswapd awake (seconds)                  12.46       9.46       9.56       9.40
>
> Total pages scanned                        4717478   4749472   4760335   4756569
> Total pages reclaimed                      2239041   2237763   2221062   2235708
> %age total pages scanned/reclaimed          47.46%    47.12%    46.66%    47.00%
> %age total pages scanned/written             0.00%     0.00%     0.00%     0.00%
> %age  file pages scanned/written             0.00%     0.00%     0.00%     0.00%
> Percentage Time Spent Direct Reclaim        43.80%    21.38%    22.34%    23.46%
> Percentage Time kswapd Awake                79.92%    79.56%    79.20%    80.48%


There is a nitpick about stalled reclaim time.
For example, In direct reclaim

===
       trace_mm_vmscan_direct_reclaim_begin(order,
                               sc.may_writepage,
                               gfp_mask);

       nr_reclaimed = do_try_to_free_pages(zonelist, &sc);

       trace_mm_vmscan_direct_reclaim_end(nr_reclaimed);
===

In this case, Isn't this time accumulated value?
My point is following as.

Process A                                                       Process B
direct reclaim begin
do_try_to_free_pages
cond_resched

                direct reclaim begin

                do_try_to_free_pages

                direct reclaim end
direct reclaim end


So A's result includes B's time so total stall time would be bigger than real.


-- 
Kind regards,
Minchan Kim
