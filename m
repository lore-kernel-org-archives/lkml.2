Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1A1ARm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 19:17:42 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:8579 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753894Ab1A1ARk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 19:17:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtAEAI6ZQU15LN5mgWdsb2JhbACkfBYBARYiJLxXDYVCBA
Date: Fri, 28 Jan 2011 11:17:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110128001735.GO21311@dastard>
References: <4D40C8D1.8090202@teksavvy.com>
 <20110127033011.GH21311@dastard>
 <4D40EB2F.2050809@teksavvy.com>
 <4D418B57.1000501@teksavvy.com>
 <alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
 <4D419765.4070805@teksavvy.com>
 <4D41CA16.8070001@hardwarefreak.com>
 <4D41EA04.7010506@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D41EA04.7010506@teksavvy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 04:56:20PM -0500, Mark Lord wrote:
> On 11-01-27 02:40 PM, Stan Hoeppner wrote:
> ..
> > You need to use the mkfs.xfs defaults for any single drive filesystem, and trust
> > the allocator to do the right thing.
> 
> But it did not do the right thing when I used the defaults.
> Big files ended up with tons of (exactly) 64MB extents, ISTR.

Because your AG size is 64MB. An extent can't be larger than an AG.
Hence you are fragmenting your large files unnecessarily, as extents
can be up to 8GB in size on a 4k block size filesystem.

> With the increased number of ags, I saw much less fragmentation,
> and the drive was still very light on I/O despite multiple simultaneous
> recordings, commflaggers, and playback at once.

The allocsize mount option is the prefered method of keeping
fragemntation down for dvr style workloads.

> > Trust the defaults.
> 
> I imagine the defaults are designed to handle a typical Linux install,
> with 100,000 to 1,000,000 files varying from a few bytes to a few megabytes.

Why would we optimise a filesystem designed for use on high end
storage and large amounts of IO concurrency for what a typical Linux
desktop needs? For such storage (i.e. single spindle) mkfs optimises
the layout for minimal seeks and relatively low amounts of
concurrency. This gives _adequate_ performance on desktop machines
without compromising scalbility on high end storage.

In my experience with XFS, most people who tweak mkfs parameters end
up with some kind of problem they can't explain and don't know how
to solve. And they are typically problems that would not have
occurred had they simply used the defaults in the first place. What
you've done is a perfect example of this.

Yes, I know we are taking the fun out of tweaking knobs so you can
say it's 1% faster than the default, but that's our job: to
determine the right default settings so the filesystem works as well
as possible out of the box with no tweaking for most workloads on a
wide range of storage....

> That's not what this filesystem will have. It will have only a few thousand
> (max) inodes at any given time, but each file will be HUGE.

Which is exactly the use case XFS was designed for, and....

> XFS is fantastic at adapting to the workload, but I'd like to try and have
> it tuned more closely for the known workload this system is throwing at it.

.... as such the mkfs defaults are already tuned as well as they can
be for such usage.

> I'm now trying again, but with 8 ags instead of 8000+.

Why 8 AGs and not the default?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
