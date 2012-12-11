Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2LKWJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:09:50 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:45785 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753627Ab2LKWJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:09:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmMOALqux1B5LO66/2dsb2JhbABFhU6ycYYQF3OCHgEBBAE6HCMFCwgDDgouFCUDIROICwW7bxSMNoNiYQOWBpBJgwc
Date: Wed, 12 Dec 2012 09:09:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121211220944.GB16353@dastard>
References: <20121207011628.GB16373@gmail.com>
 <50C22923.90102@redhat.com>
 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
 <20121207190306.GB14972@shiny>
 <20121208001705.GO27172@dastard>
 <20121210173739.GA1359@thunk.org>
 <1355162759.2704.50.camel@menhir>
 <20121210181328.GB7516@thunk.org>
 <20121210182053.GC7516@thunk.org>
 <1355228163.2721.32.camel@menhir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355228163.2721.32.camel@menhir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 12:16:03PM +0000, Steven Whitehouse wrote:
> On Mon, 2012-12-10 at 13:20 -0500, Theodore Ts'o wrote:
> > A sentence or two got chopped out during an editing pass.  Let me try
> > that again so it's a bit clearer what I was trying to say....
> > 
> > Sure, but if the block device supports WRITE_SAME or persistent
> > discard, then presumably fallocate() should do this automatically all
> > the time, and not require a flag to request this behavior.  The only
> > reason why you might not is if the WRITE_SAME is more costly.  That is
> > when a seek plus writing 1MB does take more time than the amount of
> > disk time fraction that it consumes if you compare it to a seek plus
> > writing 4k or 32k.
> > 
> Well there are two cases here I think....

/me nods

> The other case is ext4/XFS type case where the metadata does support
> "these blocks are allocated but zero" which means that the metadata
> needs to be changed twice. Once to "these blocks are allocated but zero"
> at fallocate time and again to "these blocks have valid content" at
> write time. As I understand the issue, the problem is that this second
> metadata change is what is causing the performance issue.

Apparently so ;)

> > Ext4 currently uses a threshold of 32k for this break point (below
> > that, we will use sb_issue_zeroout; above that, we will break apart an
> > uninitialized extent when writing into a preallocated region).  It may
> > be that 32k is too low, especailly for certain types of devices (i.e.,
> > SSD's versus RAID 5, where it should be aligned on a RAID strip,
> > etc.).  More of an issue might be that there will be some disagreement
> > about whether people want to the system to automatically tune for
> > average throughput vs 99.9 percentile latency.
> > 
> > Regardless, this is actually something which I think the file system
> > should try to do automatically if at all possible, via some kind of
> > auto-tuning hueristic, instead of using an explicit fallocate(2) flag.
> > (See, I don't propose using a new fallocate flag for everything.  :-)

Preallocation is primarily there for the application to optimise
file layout when the filesystem heuristics fail to do the right
thing.  IOWs, we should not be adding heuristics to "tune" fallocate
behaviour automatically because a) we are guaranteed to get
heuristics wrong for some applications, and b) fallocate is for
direct application control and hence avoid filesystem hueristic
based problems.

> It sounds like it might well be worth experimenting with the thresholds
> as you suggest, 32k is really pretty small. I guess that the real
> question here is what is the cost of the metadata change (to say what is
> written and what remains unwritten) vs. simply zeroing out the unwritten
> blocks in the extent when the write occurs.

Exactly my concern. 32k is a range that is arbitrary, and if it
cannot be changed to suit your workload then if it sucks....  Given
that fallocate is supposed to allow applications to avoid such
allocation heuristics if they are sub-optimal, this fixed
"zero-around" range seems like a bad
model to follow.

If I implement a zero-around for direct IO on unwritten extents for
XFS, I'll use the per-inode extent granularity hint that is held in
the inode to determine the range to write zeros to.  That will
enable us to have a per-file configurable allocation/unwritten
extent conversion granularity and hence bound the maximum size of
the extent tree for a given workload+data set.

The real problem is that to do zero-around efficiently, the zeroing
needs to be done as part of the direct IO submission process. That
code only supports block size zeroing rather than arbitrary ranges,
and it's already very messy because of the rat's nest of
micro-optimisations.

However, doing the zero-around as part of IO submission would
certainly remove a significant amount of the ongoing extent
conversion overhead from the workloads Chris has pointed out as
troublesome...

> There are likely to be a number of factors affecting that, and the
> answer doesn't appear straightforward,

Right, which is where making it per-file configurable makes sense.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
