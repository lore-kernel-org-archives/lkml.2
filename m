Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab0KICtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:49:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34774 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab0KICtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:49:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] RFC: vmscan: add min_filelist_kbytes sysctl for protecting the working set
Cc: kosaki.motohiro@jp.fujitsu.com, Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, wad@chromium.org, olofj@chromium.org,
        hughd@chromium.org
In-Reply-To: <4CD2D18C.9080407@redhat.com>
References: <20101103224055.GC19646@google.com> <4CD2D18C.9080407@redhat.com>
Message-Id: <20101109114610.BC39.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 11:49:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 11/03/2010 06:40 PM, Mandeep Singh Baines wrote:
> 
> > I've created a patch which takes a slightly different approach.
> > Instead of limiting how fast pages get reclaimed, the patch limits
> > how fast the active list gets scanned. This should result in the
> > active list being a better measure of the working set. I've seen
> > fairly good results with this patch and a scan inteval of 1
> > centisecond. I see no thrashing when the scan interval is non-zero.
> >
> > I've made it a tunable because I don't know what to set the scan
> > interval. The final patch could set the value based on HZ and some
> > other system parameters. Maybe relate it to sched_period?
> 
> I like your approach. For file pages it looks like it
> could work fine, since new pages always start on the
> inactive file list.
> 
> However, for anonymous pages I could see your patch
> leading to problems, because all anonymous pages start
> on the active list.  With a scan interval of 1
> centiseconds, that means there would be a limit of 3200
> pages, or 12MB of anonymous memory that can be moved to
> the inactive list a second.
> 
> I have seen systems with single SATA disks push out
> several times that to swap per second, which matters
> when someone starts up a program that is just too big
> to fit in memory and requires that something is pushed
> out.
> 
> That would reduce the size of the inactive list to
> zero, reducing our page replacement to a slow FIFO
> at best, causing false OOM kills at worst.
> 
> Staying with a default of 0 would of course not do
> anything, which would make merging the code not too
> useful.
> 
> I believe we absolutely need to preserve the ability
> to evict pages quickly, when new pages are brought
> into memory or allocated quickly.
> 
> However, speed limits are probably a very good idea
> once a cache has been reduced to a smaller size, or
> when most IO bypasses the reclaim-speed-limited cache.

Yeah.

But I doubt fixed rate limit is good thing. When playing movie case
(aka streaming I/O case), We don't want any throttle. I think.
Also, I don't like jiffies dependency. CPU hardware improvement naturally
will break such heuristics.


btw, now congestion_wait() already has jiffies dependency. but we should
kill such strange timeout eventually. I think.


