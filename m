Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1D0Iyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:54:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51796 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab1D0Iyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:54:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Apr 2011 17:48:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [PATCHv3] memcg: fix get_scan_count for small targets
Message-Id: <20110427174813.8b34df90.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTin+rDOWGYq9dg-XcCWs+yT8Yw-VMw@mail.gmail.com>
References: <20110427164708.1143395e.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTin+rDOWGYq9dg-XcCWs+yT8Yw-VMw@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 17:48:18 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Wed, Apr 27, 2011 at 4:47 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > At memory reclaim, we determine the number of pages to be scanned
> > per zone as
> >        (anon + file) >> priority.
> > Assume
> >        scan = (anon + file) >> priority.
> >
> > If scan < SWAP_CLUSTER_MAX, the scan will be skipped for this time
> > and priority gets higher. This has some problems.
> >
> >  1. This increases priority as 1 without any scan.
> >     To do scan in this priority, amount of pages should be larger than 512M.
> >     If pages>>priority < SWAP_CLUSTER_MAX, it's recorded and scan will be
> >     batched, later. (But we lose 1 priority.)
> >     If memory size is below 16M, pages >> priority is 0 and no scan in
> >     DEF_PRIORITY forever.
> >
> >  2. If zone->all_unreclaimabe==true, it's scanned only when priority==0.
> >     So, x86's ZONE_DMA will never be recoverred until the user of pages
> >     frees memory by itself.
> >
> >  3. With memcg, the limit of memory can be small. When using small memcg,
> >     it gets priority < DEF_PRIORITY-2 very easily and need to call
> >     wait_iff_congested().
> >     For doing scan before priorty=9, 64MB of memory should be used.
> >
> > Then, this patch tries to scan SWAP_CLUSTER_MAX of pages in force...when
> >
> >  1. the target is enough small.
> >  2. it's kswapd or memcg reclaim.
> >
> > Then we can avoid rapid priority drop and may be able to recover
> > all_unreclaimable in a small zones. And this patch removes nr_saved_scan.
> > This will allow scanning in this priority even when pages >> priority
> > is very small.
> >
> > Changelog v2->v3
> >  - removed nr_saved_scan completely.
> >
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 
> The patch looks good to me but I have a nitpick about just coding style.
> How about this? I think below looks better but it's just my private
> opinion and I can't insist on my style. If you don't mind it, ignore.
> 

I did this at the 1st try and got bug.....a variable 'file' here is
reused and now broken. Renaming it with new variable will be ok, but it
seems there will be deep nesting of 'if' and long function names ;)
So, I did as posted. 

Thank you for review.
-Kame

