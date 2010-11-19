Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab0KSDLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 22:11:23 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:32784 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751340Ab0KSDLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 22:11:22 -0500
Date: Fri, 19 Nov 2010 14:11:05 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/13] IO-less dirty throttling v2
Message-ID: <20101119031105.GC13830@dastard>
References: <20101117042720.033773013@intel.com>
 <20101117150330.139251f9.akpm@linux-foundation.org>
 <20101118020640.GS22876@dastard>
 <20101117180912.38541ca4.akpm@linux-foundation.org>
 <20101118032141.GP13830@dastard>
 <20101117193431.ec1f4547.akpm@linux-foundation.org>
 <20101118072706.GW13830@dastard>
 <20101117233350.321f9935.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117233350.321f9935.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 11:33:50PM -0800, Andrew Morton wrote:
> On Thu, 18 Nov 2010 18:27:06 +1100 Dave Chinner <david@fromorbit.com> wrote:
> 
> > > > Indeed, nobody has
> > > > realised (until now) just how inefficient it really is because of
> > > > the fact that the overhead is mostly hidden in user process system
> > > > time.
> > > 
> > > "hidden"?  You do "time dd" and look at the output!
> > > 
> > > _now_ it's hidden.  You do "time dd" and whee, no system time!
> > 
> > What I meant is that the cost of foreground writeback was hidden in
> > the process system time. Now we have separated the two of them, we
> > can see exactly how much it was costing us because it is no longer
> > hidden inside the process system time.
> 
> About a billion years ago I wrote the "cyclesoak" thingy which measures
> CPU utilisation the other way around: run a lowest-priority process on
> each CPU in the background, while running your workload, then find out
> how much CPU time cyclesoak *didn't* consume.  That way you account for
> everything: user time, system time, kernel threads, interrupts,
> softirqs, etc.  It turned out to be pretty accurate, despite the
> then-absence of SCHED_IDLE.

Yeah, I just use PCP to tell me what the CPU usage is in a nice
graph. The link below is an image of the "overview" monitoring tab I
have - total CPU, IOPS, bandwidth, XFS directory ops and context
switches. Here's the behaviour an increasing number of dd's with
this series looks like:

http://userweb.kernel.org/~dgc/io-less-throttle-dd.png

Left to right, that 1 dd, 2, 4, 8, 16 and 32 dd's, then a gap, then
the 8-way fs_mark workload running. These are all taken at a 5s
sample period.

FWIW, on the 32 thread dd (the right most of the set of pillars),
you can see the sudden increase in system CPU usage in the last few
samples (which corresponds to the first few dd's completing and
exiting) that I mentioned previously.

Basically, I'm always looking at the total CPU usage of a workload,
memory usage of caches, etc, in this manner.  Sure, I use stuff like
time to get numbers to drop out of test scripts, but most of my
behavioural analysis is done through observing differences between
two charts and then looking deeper to work out what changed...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
