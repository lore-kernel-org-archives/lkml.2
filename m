Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab0H0JeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:34:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41869 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab0H0JeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:34:10 -0400
Date: Fri, 27 Aug 2010 10:33:55 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] writeback: Do not congestion sleep when there are
	no congested BDIs
Message-ID: <20100827093355.GC19556@csn.ul.ie>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie> <1282835656-5638-4-git-send-email-mel@csn.ul.ie> <20100827051316.GH705@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100827051316.GH705@dastard>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 03:13:16PM +1000, Dave Chinner wrote:
> On Thu, Aug 26, 2010 at 04:14:16PM +0100, Mel Gorman wrote:
> > If congestion_wait() is called with no BDIs congested, the caller will
> > sleep for the full timeout and this is an unnecessary sleep.
> 
> That, I think, is an invalid assumption. congestion_wait is used in
> some places as a backoff mechanism that waits for some IO work to be
> done, with congestion disappearing being a indication that progress
> has been made and so we can retry sooner than the entire timeout.
> 

As it's write IO rather than some IO, I wonder if that's really the
right thing to do. However, I accept your (and others) point that
converting all congestion_wait() callers may be too much of a change.

> For example, if _xfs_buf_lookup_pages() fails to allocate page cache
> pages for a buffer, it will kick the xfsbufd to writeback dirty
> buffers (so they can be freed) and immediately enter
> congestion_wait(). If there isn't congestion when we enter
> congestion_wait(), we still want to give the xfsbufds a chance to
> clean some pages before we retry the allocation for the new buffer.
> Removing the congestion_wait() sleep behaviour will effectively
> _increase_ memory pressure with XFS on fast disk subsystems because
> it now won't backoff between failed allocation attempts...
> 
> Perhaps a congestion_wait_iff_congested() variant is needed for the
> VM? I can certainly see how it benefits the VM from a latency
> perspective, but it is the opposite behaviour that is expected in
> other places...
> 

I'm added a wait_iff_congested() and updated a few of the VM callers. I changed
a fairly minimum number of what appeared to be the obvious ones to change.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
