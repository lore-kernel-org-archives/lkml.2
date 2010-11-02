Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab0KBDMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 23:12:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab0KBDL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 23:11:57 -0400
Message-ID: <4CCF8151.3010202@redhat.com>
Date: Mon, 01 Nov 2010 23:11:13 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Mandeep Singh Baines <msb@chromium.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, wad@chromium.org, olofj@chromium.org,
        hughd@chromium.org
Subject: Re: [PATCH] RFC: vmscan: add min_filelist_kbytes sysctl for protecting
 the working set
References: <20101028191523.GA14972@google.com>	<20101101012322.605C.A69D9226@jp.fujitsu.com>	<20101101182416.GB31189@google.com>	<4CCF0BE3.2090700@redhat.com> <AANLkTi=src1L0gAFsogzCmejGOgg5uh=9O4Uw+ZmfBg4@mail.gmail.com>
In-Reply-To: <AANLkTi=src1L0gAFsogzCmejGOgg5uh=9O4Uw+ZmfBg4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 03:43 PM, Mandeep Singh Baines wrote:

> Yes, this prevents you from reclaiming the active list all at once. But if the
> memory pressure doesn't go away, you'll start to reclaim the active list
> little by little. First you'll empty the inactive list, and then
> you'll start scanning
> the active list and pulling pages from inactive to active. The problem is that
> there is no minimum time limit to how long a page will sit in the inactive list
> before it is reclaimed. Just depends on scan rate which does not depend
> on time.
>
> In my experiments, I saw the active list get smaller and smaller
> over time until eventually it was only a few MB at which point the system came
> grinding to a halt due to thrashing.

I believe that changing the active/inactive ratio has other
potential thrashing issues.  Specifically, when the inactive
list is too small, pages may not stick around long enough to
be accessed multiple times and get promoted to the active
list, even when they are in active use.

I prefer a more flexible solution, that automatically does
the right thing.

The problem you see is that the file list gets reclaimed
very quickly, even when it is already very small.

I wonder if a possible solution would be to limit how fast
file pages get reclaimed, when the page cache is very small.
Say, inactive_file * active_file < 2 * zone->pages_high ?

At that point, maybe we could slow down the reclaiming of
page cache pages to be significantly slower than they can
be refilled by the disk.  Maybe 100 pages a second - that
can be refilled even by an actual spinning metal disk
without even the use of readahead.

That can be rounded up to one batch of SWAP_CLUSTER_MAX
file pages every 1/4 second, when the number of page cache
pages is very low.

This way HPC and virtual machine hosting nodes can still
get rid of totally unused page cache, but on any system
that actually uses page cache, some minimal amount of
cache will be protected under heavy memory pressure.

Does this sound like a reasonable approach?

I realize the threshold may have to be tweaked...

The big question is, how do we integrate this with the
OOM killer?  Do we pretend we are out of memory when
we've hit our file cache eviction quota and kill something?

Would there be any downsides to this approach?

Are there any volunteers for implementing this idea?
(Maybe someone who needs the feature?)

-- 
All rights reversed
