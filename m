Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1GNAdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 20:33:44 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:4150 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758Ab1GNAdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 20:33:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqcCALs4Hk55LCkBgWdsb2JhbABTG6cmFQEBFiYliHrCKw6GLASjQw
Date: Thu, 14 Jul 2011 10:33:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC PATCH 0/5] Reduce filesystem writeback from page reclaim
 (again)
Message-ID: <20110714003340.GZ23038@dastard>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310567487-15367-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 03:31:22PM +0100, Mel Gorman wrote:
> (Revisting this from a year ago and following on from the thread
> "Re: [PATCH 03/27] xfs: use write_cache_pages for writeback
> clustering". Posting an prototype to see if anything obvious is
> being missed)

Hi Mel,

Thanks for picking this up again. The results are definitely
promising, but I'd like to see a comparison against simply not doing
IO from memory reclaim at all combined with the enhancements in this
patchset. After all, that's what I keep asking for (so we can get
rid of .writepage altogether), and if the numbers don't add up, then
I'll shut up about it. ;)

.....

> use-once LRU logic). The command line for fs_mark looked something like
> 
> ./fs_mark  -d  /tmp/fsmark-2676  -D  100  -N  150  -n  150  -L  25  -t  1  -S0  -s  10485760
> 
> The machine was booted with "nr_cpus=1 mem=512M" as according to Dave
> this triggers the worst behaviour.
....
> During testing, a number of monitors were running to gather information
> from ftrace in particular. This disrupts the results of course because
> recording the information generates IO in itself but I'm ignoring
> that for the moment so the effect of the patches can be seen.
> 
> I've posted the raw reports for each filesystem at
> 
> http://www.csn.ul.ie/~mel/postings/reclaim-20110713/writeback-ext3/sandy/comparison.html
> http://www.csn.ul.ie/~mel/postings/reclaim-20110713/writeback-ext4/sandy/comparison.html
> http://www.csn.ul.ie/~mel/postings/reclaim-20110713/writeback-btrfs/sandy/comparison.html
> http://www.csn.ul.ie/~mel/postings/reclaim-20110713/writeback-xfs/sandy/comparison.html
.....
> Average files per second is increased by a nice percentage albeit
> just within the standard deviation. Consider the type of test this is,
> variability was inevitable but will double check without monitoring.
> 
> The overhead (time spent in non-filesystem-related activities) is
> reduced a *lot* and is a lot less variable.

Given that userspace is doing the same amount of work in all test
runs, that implies that the userspace process is retaining it's
working set hot in the cache over syscalls with this patchset.

> Direct reclaim work is significantly reduced going from 37% of all
> pages scanned to 1% with all patches applied. This implies that
> processes are getting stalled less.

And that directly implicates page scanning during direct reclaim as
the prime contributor to turfing the application's working set out
of the CPU cache....

> Page writes by reclaim is what is motivating this series. It goes
> from 14511 pages to 4084 which is a big improvement. We'll see later
> if these were anonymous or file-backed pages.

Which were anon pages, so this is a major improvement. However,
given that there were no dirty pages writen directly by memory
reclaim, perhaps we don't need to do IO at all from here and
throttling is all that is needed?  ;)

> Direct reclaim writes were never a problem according to this.

That's true. but we disable direct reclaim for other reasons, namely
that writeback from direct reclaim blows the stack.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
