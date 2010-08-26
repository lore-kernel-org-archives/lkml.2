Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0HZSRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:17:42 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:34842 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab0HZSRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:17:39 -0400
Date: Thu, 26 Aug 2010 20:17:35 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] writeback: Do not congestion sleep when there are no
 congested BDIs
Message-ID: <20100826181735.GB6805@cmpxchg.org>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
 <1282835656-5638-4-git-send-email-mel@csn.ul.ie>
 <20100826173843.GD6873@barrios-desktop>
 <20100826174245.GJ20944@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826174245.GJ20944@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 06:42:45PM +0100, Mel Gorman wrote:
> On Fri, Aug 27, 2010 at 02:38:43AM +0900, Minchan Kim wrote:
> > On Thu, Aug 26, 2010 at 04:14:16PM +0100, Mel Gorman wrote:
> > > If congestion_wait() is called with no BDIs congested, the caller will
> > > sleep for the full timeout and this is an unnecessary sleep. This patch
> > > checks if there are BDIs congested. If so, it goes to sleep as normal.
> > > If not, it calls cond_resched() to ensure the caller is not hogging the
> > > CPU longer than its quota but otherwise will not sleep.
> > > 
> > > This is aimed at reducing some of the major desktop stalls reported during
> > > IO. For example, while kswapd is operating, it calls congestion_wait()
> > > but it could just have been reclaiming clean page cache pages with no
> > > congestion. Without this patch, it would sleep for a full timeout but after
> > > this patch, it'll just call schedule() if it has been on the CPU too long.
> > > Similar logic applies to direct reclaimers that are not making enough
> > > progress.
> > > 
> > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > > ---
> > >  mm/backing-dev.c |   20 ++++++++++++++------
> > >  1 files changed, 14 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> > > index a49167f..6abe860 100644
> > > --- a/mm/backing-dev.c
> > > +++ b/mm/backing-dev.c
> > 
> > Function's decripton should be changed since we don't wait next write any more. 
> > 
> 
> My bad. I need to check that "next write" thing. It doesn't appear to be
> happening but maybe that side of things just broke somewhere in the
> distant past. I lack context of how this is meant to work so maybe
> someone will educate me.

On every retired io request the congestion state on the bdi is checked
and the congestion waitqueue woken up.

So without congestion, we still only wait until the next write
retires, but without any IO, we sleep the full timeout.

Check __freed_requests() in block/blk-core.c.
