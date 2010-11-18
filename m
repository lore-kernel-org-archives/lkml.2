Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0KRCup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 21:50:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:37847 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab0KRCuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 21:50:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,214,1288594800"; 
   d="scan'208";a="858796912"
Date: Thu, 18 Nov 2010 10:50:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/13] IO-less dirty throttling
Message-ID: <20101118025039.GA15479@localhost>
References: <20101117035821.000579293@intel.com>
 <20101117072538.GO22876@dastard>
 <20101117100655.GA26501@localhost>
 <20101118014051.GR22876@dastard>
 <20101117175900.0d7878e5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117175900.0d7878e5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 09:59:00AM +0800, Andrew Morton wrote:
> On Thu, 18 Nov 2010 12:40:51 +1100 Dave Chinner <david@fromorbit.com> wrote:
> 
> > 
> > There's no point
> > waking a dirtier if all they can do is write a single page before
> > they are throttled again - IO is most efficient when done in larger
> > batches...
> 
> That assumes the process was about to do another write.  That's
> reasonable on average, but a bit sad for interactive/rtprio tasks.  At
> some stage those scheduler things should be brought into the equation.

The interactive/rtprio tasks are given 1/4 bonus in
global_dirty_limits(). So when there are lots of heavy dirtiers,
the interactive/rtprio tasks will get soft throttled at
(6~8)*bdi_bandwidth. We can increase that to (12~16)*bdi_bandwidth
or whatever.

> >
> > ...
> >
> > Yeah, sorry, should have posted them - I didn't because I snapped
> > the numbers before the run had finished. Without series:
> > 
> > 373.19user 14940.49system 41:42.17elapsed 612%CPU (0avgtext+0avgdata 82560maxresident)k
> > 0inputs+0outputs (403major+2599763minor)pagefaults 0swaps
> > 
> > With your series:
> > 
> > 359.64user 5559.32system 40:53.23elapsed 241%CPU (0avgtext+0avgdata 82496maxresident)k
> > 0inputs+0outputs (312major+2598798minor)pagefaults 0swaps
> > 
> > So the wall time with your series is lower, and system CPU time is
> > way down (as I've already noted) for this workload on XFS.
> 
> How much of that benefit is an accounting artifact, moving work away
> from the calling process's CPU and into kernel threads?

The elapsed time won't cheat, and it's going down from 41:42 to 40:53.

For the CPU time, I have system wide numbers collected from iostat.
Citing from the changelog of the first patch:

- 1 dirtier case:    the same
- 10 dirtiers case:  CPU system time is reduced to 50%
- 100 dirtiers case: CPU system time is reduced to 10%, IO size and throughput increases by 10%

                        2.6.37-rc2                              2.6.37-rc1-next-20101115+
        ----------------------------------------        ----------------------------------------
        %system         wkB/s           avgrq-sz        %system         wkB/s           avgrq-sz
100dd   30.916          37843.000       748.670         3.079           41654.853       822.322
100dd   30.501          37227.521       735.754         3.744           41531.725       820.360

10dd    39.442          47745.021       900.935         20.756          47951.702       901.006
10dd    39.204          47484.616       899.330         20.550          47970.093       900.247

1dd     13.046          57357.468       910.659         13.060          57632.715       909.212
1dd     12.896          56433.152       909.861         12.467          56294.440       909.644

Those are real CPU savings :)

Thanks,
Fengguang
