Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab2D1Bge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 21:36:34 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:23893 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757726Ab2D1Bgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 21:36:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EABtJm095LNEo/2dsb2JhbABEshOBCIIJAQEEATocIwULCAMYLhQlAyETiAgEumETkQoElXyJWYZogno
Date: Sat, 28 Apr 2012 11:36:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
Message-ID: <20120428013628.GJ9541@dastard>
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org>
 <1335289787-11089-3-git-send-email-john.stultz@linaro.org>
 <20120427003953.GC9541@dastard>
 <4F9ABA74.8040404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9ABA74.8040404@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 08:25:40AM -0700, Dave Hansen wrote:
> On 04/26/2012 05:39 PM, Dave Chinner wrote:
> > As it is, I'm still not sold on these being an fadvise() interface
> > because all it really is a delayed hole punching interface whose
> > functionailty is currently specific to tmpfs. The behaviour cannot
> > be implemented sanely by anything else at this point.
> ...
> > IOWs, the specification you are describing means that FADV_VOLATILE
> > could be correctly implemented as an immediate hole punch by every
> > filesystem that supports hole punching.
> 
> Ahhh, I think I see where you're going with this.
> 
> 1. Data written to a file somehow (mmap(), write()) and is on disk
> 2. mmap() the data, and fault it in
> 3. Do a small write to it
> 4. set FADV_VOLATILE on it
> 
> Now we've got a dirty page which can theoretically be tossed out.  But,
> we've got old data on the disk and no real way to tell that it was old
> if it got faulted in again.  It's a much cleaner situation to just drop
> that data off the disk (hole punch) than to leave it around.  Is that
> the concern?

Right - if you are using a persistent filesystem then just dropping
the pages in memory does not do what the interface expects it to do.
rather than having a hole in the file, there is stale data. That
sounds like a recipe for security problems to me.

> But, we have other APIs that act this way, tossing out dirty data
> without reflecting that on-disk (MADV_DONTNEED at least). 

But that's a mmap() operation, not a file operation.  mmap()/
madvise() implies you are workng with memory pages, fadvise()
implies you are working with *file data*. The mmap() functionality is
designed really for anonymous memory, to be able to toss it out when
finished with, not for manipulating data files. Yes, it works with
data files, but that leaves unknown stale data behind on disk....

> Is it really
> a stretch to define the FADV_VOLATILE to behave the same way?  IOW,
> Should the behavior _really_ be hole punching?  That'll cost us I/O to
> throw away data during memory reclaim since we have to go write the
> information about the hole.

Not for tmpfs, which is what this is initially aimed at. And for
filesystems, we already do IO in shrinkers during reclaim, so at a
stretch hole punching in a shrinker is possible, though undesirable
and possible to avoid.

> Seems like a much more appropriate thing to
> just toss the data out since the app can handle it.

On tmpfs, re-reading the data range that was tossed will return
zeros. Easy to detect and handle, and has no security implications.
On a real filesystem, it will return stale data. Not only is that
much harder to detect - it may not even be possible depending on how
the application tracks data in it's files. If the filesystem punches
holes, it will return zeros just like tmpfs will.

That's my concern - that persistent filesystems will have different
behaviour to in-memory filesystems. They *must* be consistent in
behaviour w.r.t. to stale data exposure, otherwise we are in a world
of pain when applications start to use this. Quite frankly, I don't
care about performance of VOLATILE ranges, but I care greatly
about ensuring filesystems don't expose stale data to user
applications....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
