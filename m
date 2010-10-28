Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750Ab0J1ULp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:11:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934348Ab0J1ULg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:11:36 -0400
Date: Thu, 28 Oct 2010 13:10:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, wad@chromium.org, olofj@chromium.org,
        hughd@chromium.org
Subject: Re: [PATCH] RFC: vmscan: add min_filelist_kbytes sysctl for
 protecting the working set
Message-Id: <20101028131029.ee0aadc0.akpm@linux-foundation.org>
In-Reply-To: <20101028191523.GA14972@google.com>
References: <20101028191523.GA14972@google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010 12:15:23 -0700
Mandeep Singh Baines <msb@chromium.org> wrote:

> On ChromiumOS, we do not use swap.

Well that's bad.  Why not?

> When memory is low, the only way to
> free memory is to reclaim pages from the file list. This results in a
> lot of thrashing under low memory conditions. We see the system become
> unresponsive for minutes before it eventually OOMs. We also see very
> slow browser tab switching under low memory. Instead of an unresponsive
> system, we'd really like the kernel to OOM as soon as it starts to
> thrash. If it can't keep the working set in memory, then OOM.
> Losing one of many tabs is a better behaviour for the user than an
> unresponsive system.
> 
> This patch create a new sysctl, min_filelist_kbytes, which disables reclaim
> of file-backed pages when when there are less than min_filelist_bytes worth
> of such pages in the cache. This tunable is handy for low memory systems
> using solid-state storage where interactive response is more important
> than not OOMing.
> 
> With this patch and min_filelist_kbytes set to 50000, I see very little
> block layer activity during low memory. The system stays responsive under
> low memory and browser tab switching is fast. Eventually, a process a gets
> killed by OOM. Without this patch, the system gets wedged for minutes
> before it eventually OOMs. Below is the vmstat output from my test runs.
> 
> BEFORE (notice the high bi and wa, also how long it takes to OOM):

That's an interesting result.

Having the machine "wedged for minutes" thrashing away paging
executable text is pretty bad behaviour.  I wonder how to fix it. 
Perhaps simply declaring oom at an earlier stage.

Your patch is certainly simple enough but a bit sad.  It says "the VM
gets this wrong, so lets just disable it all".  And thereby reduces the
motivation to fix it for real.

But the patch definitely improves the situation in real-world
situations and there's a case to be made that it should be available at
least as an interim thing until the VM gets fixed for real.  Which
means that the /proc tunable might disappear again (or become a no-op)
some time in the future.


