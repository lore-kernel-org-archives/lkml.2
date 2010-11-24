Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0KXMj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 07:39:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:43610 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab0KXMj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 07:39:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,247,1288594800"; 
   d="scan'208";a="629895099"
Date: Wed, 24 Nov 2010 20:39:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/13] writeback: reduce per-bdi dirty threshold ramp
 up time
Message-ID: <20101124123923.GB10413@localhost>
References: <20101117042720.033773013@intel.com>
 <20101117042850.361893350@intel.com>
 <1290597341.2072.456.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290597341.2072.456.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 07:15:41PM +0800, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 12:27 +0800, Wu Fengguang wrote:
> > plain text document attachment
> > (writeback-speedup-per-bdi-threshold-ramp-up.patch)
> > Reduce the dampening for the control system, yielding faster
> > convergence.
> > 
> > Currently it converges at a snail's pace for slow devices (in order of
> > minutes).  For really fast storage, the convergence speed should be fine.
> > 
> > It makes sense to make it reasonably fast for typical desktops.
> > 
> > After patch, it converges in ~10 seconds for 60MB/s writes and 4GB mem.
> > So expect ~1s for a fast 600MB/s storage under 4GB mem, or ~4s under
> > 16GB mem, which seems reasonable.
> > 
> > $ while true; do grep BdiDirtyThresh /debug/bdi/8:0/stats; sleep 1; done
> > BdiDirtyThresh:            0 kB
> > BdiDirtyThresh:       118748 kB
> > BdiDirtyThresh:       214280 kB
> > BdiDirtyThresh:       303868 kB
> > BdiDirtyThresh:       376528 kB
> > BdiDirtyThresh:       411180 kB
> > BdiDirtyThresh:       448636 kB
> > BdiDirtyThresh:       472260 kB
> > BdiDirtyThresh:       490924 kB
> > BdiDirtyThresh:       499596 kB
> > BdiDirtyThresh:       507068 kB
> > ...
> > DirtyThresh:          530392 kB
> > 
> > CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > CC: Richard Kennedy <richard@rsk.demon.co.uk>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  mm/page-writeback.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- linux-next.orig/mm/page-writeback.c	2010-11-15 13:08:16.000000000 +0800
> > +++ linux-next/mm/page-writeback.c	2010-11-15 13:08:28.000000000 +0800
> > @@ -125,7 +125,7 @@ static int calc_period_shift(void)
> >  	else
> >  		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
> >  				100;
> > -	return 2 + ilog2(dirty_total - 1);
> > +	return ilog2(dirty_total - 1) - 1;
> >  }
> >  
> >  /*
> 
> You could actually improve upon this now that you have per-bdi bandwidth
> estimations, simply set the period to (seconds * bandwidth) to get
> convergence in @seconds.

I'd like to, but there is the global vs. bdi discrepancy to be
addressed first :)

How about doing this simple fix first, and then revisit doing per-bdi
vm_dirties after the bandwidth estimation goes upstream?

Thanks,
Fengguang
