Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab2LKAwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 19:52:23 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:22334 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612Ab2LKAwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 19:52:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMOAMmCxlB5LO66/2dsb2JhbABFDoVAsxeGCRdzgh4BAQQBOhwoCwgDGC4UJQMhARKICwWoO5AiFIwrIYQiA5JTgzKQSYI1UoFR
Date: Tue, 11 Dec 2012 11:52:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121211005217.GR15784@dastard>
References: <20121126091202.GO32450@dastard>
 <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <20121206120532.GA14100@infradead.org>
 <20121207011628.GB16373@gmail.com>
 <50C22923.90102@redhat.com>
 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
 <20121207190306.GB14972@shiny>
 <20121208001705.GO27172@dastard>
 <20121210173739.GA1359@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210173739.GA1359@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 12:37:39PM -0500, Theodore Ts'o wrote:
> On Sat, Dec 08, 2012 at 11:17:05AM +1100, Dave Chinner wrote:
> > I wouldn't recommend XFS_IOC_ALLOCSP as a user-friendly interface.
> > The concept, however, implemented by a new fallocate()
> > flag (say FALLOC_FL_WRITE_ZEROS) so that the filesystem knows that
> > the application considers unwritten extents undesirable is exactly
> > the sort of thing that we should be considering implementing.
> 
> What's the point of using a new flag like this (or XFS's
> XFS_IOC_ALLOCSP) for writing zeros during preallocation as oppoised to
> simply doing a fallocate() followed by zeroing the data via a O_DIRECT
> write system call?

There is no window where stale data is exposed to userspace, which
is what you have to do if you are doing zeroing from userspace. If
the system crashes after allocation but before zeroing, how do you
recover that? The filesystem can ensure the allocation transactions
are not committed until the allocated extents are zeroed....

> > Indeed, if the filesystem is on something with WRITE_SAME or
> > discards to zero, no data would need to be written, you wouldn't
> > have any unwritten extent overhead, and no stale data exposure.
> 
> And if you have a storage device which supports WRITE_SAME or
> persistent discards, you can do this automatically at preallocation
> time without needing a new fallocate(2) flag.

Because there are cases where unwritten extents are preferrable or
WRITE_SAME functionality is unavailable.

Indeed, if we take the case of file-per-frame, uncompressed
real-time video ingest, I'm going to be wanting to use unwritten
extents to preallocate files in a known pattern with as little
latency as possible. If we are talking about 4k uncompressed video,
that's a data rate of 1.2GB/s for 24fps, and studios are now
shooting in 48fps in 3D, which gives a real-time data rate of
roughly 5GB/s.  This has an acceptible IO latency *per-frame* of
roughly 10-20ms, which we can do easily with unwritten extents. We
can preallocate thousands of files, look at their layout via fiemap
and select the order in which we write to them based on where they
were allocated.

There is no way in hell that WRITE_SAME can be used for these sorts
of workloads, because preallocation then places a load on the storage
device that affects the latency of the real-time data stream.
Unwritten extent conversion is an after-the-fact overhead in these
cases that doesn't impact on the data stream throughput or latency.

IOWs, there are clear cases where discard optimisations will be
actively harmful to the workload using preallocation for performance
reasons. Hence, I'm not about to make the existing fallocate code in
XFS stop using unwritten extents by default even if the underlying
device supports WRITE_SAME.

> I certainly don't
> oppose adding such optimizations to ext4 or any other file system (I'm
> not entirely convinced that it's worth it to do this optimization at
> the VFS level), but it doesn't help for storage devices that don't
> support this feature.

Sure, this optimisation is a per-filesystem decision. ext4 is
unlikely to be used in the sorts of high end enviroments we see XFS
being used in, so it might make sense for you to make it use
WRITE_SAME by default if it is supported.

This, however, does not change the fact that there are existing
applications using fallocate that absolutely do not want
preallocation to use WRITE_SAME semantics. It's not an optimisation
if it breaks a significant portion of your userbase's applications.
Hence adding a flag to allow applications to specify they want
WRITE_SAME preallocation behaviour rather than unwritten extents
makes sense.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
