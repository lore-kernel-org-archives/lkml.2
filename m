Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab1DZU7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:59:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756548Ab1DZU7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:59:46 -0400
Date: Tue, 26 Apr 2011 13:59:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "mgorman@suse.de" <mgorman@suse.de>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH] fix get_scan_count for working well with small targets
Message-Id: <20110426135934.c1992c3e.akpm@linux-foundation.org>
In-Reply-To: <20110426181724.f8cdad57.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110426181724.f8cdad57.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 18:17:24 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> At memory reclaim, we determine the number of pages to be scanned
> per zone as
> 	(anon + file) >> priority.
> Assume 
> 	scan = (anon + file) >> priority.
> 
> If scan < SWAP_CLUSTER_MAX, shlink_list will be skipped for this
> priority and results no-sacn.  This has some problems.
> 
>   1. This increases priority as 1 without any scan.
>      To do scan in DEF_PRIORITY always, amount of pages should be larger than
>      512M. If pages>>priority < SWAP_CLUSTER_MAX, it's recorded and scan will be
>      batched, later. (But we lose 1 priority.)
>      But if the amount of pages is smaller than 16M, no scan at priority==0
>      forever.
> 
>   2. If zone->all_unreclaimabe==true, it's scanned only when priority==0.
>      So, x86's ZONE_DMA will never be recoverred until the user of pages
>      frees memory by itself.
> 
>   3. With memcg, the limit of memory can be small. When using small memcg,
>      it gets priority < DEF_PRIORITY-2 very easily and need to call
>      wait_iff_congested().
>      For doing scan before priorty=9, 64MB of memory should be used.
> 
> This patch tries to scan SWAP_CLUSTER_MAX of pages in force...when
> 
>   1. the target is enough small.
>   2. it's kswapd or memcg reclaim.
> 
> Then we can avoid rapid priority drop and may be able to recover
> all_unreclaimable in a small zones.

What about simply removing the nr_saved_scan logic and permitting small
scans?  That simplifies the code and I bet it makes no measurable
performance difference.

(A good thing to do here would be to instrument the code and determine
the frequency with which we perform short scans, as well as their
shortness.  ie: a histogram).

