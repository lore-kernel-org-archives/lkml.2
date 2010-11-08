Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0KHVzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:55:42 -0500
Received: from smtp-out.google.com ([216.239.44.51]:60963 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab0KHVzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:55:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=KMfYS7wCY9ldNk2ib4UmeOHnHnbdx+ATuKq55fStYcpukq9qFrBycvVOMC1anMoeNW
         Hbe60E9aUeVYBiYv/eEw==
Date: Mon, 8 Nov 2010 13:55:25 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Rik van Riel <riel@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, wad@chromium.org, olofj@chromium.org,
        hughd@chromium.org
Subject: Re: [PATCH] RFC: vmscan: add min_filelist_kbytes sysctl for
 protecting the working set
Message-ID: <20101108215524.GB7363@google.com>
References: <20101028191523.GA14972@google.com>
 <20101101012322.605C.A69D9226@jp.fujitsu.com>
 <20101101182416.GB31189@google.com>
 <4CCF0BE3.2090700@redhat.com>
 <AANLkTi=src1L0gAFsogzCmejGOgg5uh=9O4Uw+ZmfBg4@mail.gmail.com>
 <4CCF8151.3010202@redhat.com>
 <20101103224055.GC19646@google.com>
 <4CD2D18C.9080407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD2D18C.9080407@redhat.com>
X-Operating-System: Linux/2.6.32-gg252-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel (riel@redhat.com) wrote:
> On 11/03/2010 06:40 PM, Mandeep Singh Baines wrote:
> 
> >I've created a patch which takes a slightly different approach.
> >Instead of limiting how fast pages get reclaimed, the patch limits
> >how fast the active list gets scanned. This should result in the
> >active list being a better measure of the working set. I've seen
> >fairly good results with this patch and a scan inteval of 1
> >centisecond. I see no thrashing when the scan interval is non-zero.
> >
> >I've made it a tunable because I don't know what to set the scan
> >interval. The final patch could set the value based on HZ and some
> >other system parameters. Maybe relate it to sched_period?
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

Good point.

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

Agree.

Instead of doing one scan of SWAP_CLUSTER_MAX pages per vmscan_interval,
we could one "full" scan per vmscan_interval. You could do one full scan
all at once or scan SWAP_CLUSTER_MAX every scan until you've scanned
the whole list.

Psuedo code:

if (zone->to_scan[file] == 0 && !list_scanned_recently(zone, file))
	zone->to_scan[file] = list_get_size(zone, file);
if (zone->to_scan[file]) {
	shrink_active_list(nr_to_scan, zone, sc, priority, file);
	zone->to_scan[file] -= min(zone->to_scan[file], nr_to_scan);
}

> However, speed limits are probably a very good idea
> once a cache has been reduced to a smaller size, or
> when most IO bypasses the reclaim-speed-limited cache.
> 
> -- 
> All rights reversed
