Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0ETGsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 02:48:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab0ETGsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 02:48:15 -0400
Date: Thu, 20 May 2010 16:48:08 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100520064808.GF2516@laptop>
References: <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
 <20100514072219.GC4706@laptop>
 <20100514083821.GL13617@dastard>
 <20100518063647.GD2516@laptop>
 <20100518080503.GF2150@dastard>
 <20100518104351.GF2516@laptop>
 <20100518122714.GG2150@dastard>
 <20100518150912.GI2516@laptop>
 <20100519235054.GS8120@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519235054.GS8120@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 09:50:54AM +1000, Dave Chinner wrote:
> > As I said, we can have a dumb fallback path for filesystems that
> > don't implement hole punching. Clear the blocks past i size, and
> > zero out the allocated but not initialized blocks.
> > 
> > There does not have to be pagecache allocated in order to do this,
> > you could do direct IO from the zero page in order to do it.
> 
> I don't see that as a good solution - it's once again a fairly
> complex way of dealing with the problem, especially as it now means
> that direct io would fall back to buffered which would fall back to
> direct IO....

Well it wouldn't use the full direct IO path. It has the block, just
build a bio with the source zero page and write it out. If the fs
requires anything more fancy than that, tough, it should just
implement hole punching.

 
> > Hole punching is not only useful there, it is already exposed to
> > userspace via MADV_REMOVE.
> 
> That interface is *totally broken*.

Why?

> It has all the same problems as
> vmtruncate() for removing file blocks (because it uses vmtruncate).
> It also has the fundamental problem of being called un the mmap_sem,
> which means that inode locks and therefore de-allocation cannot be
> executed without the possibility of deadlocks.

None of that is an API problem, it's all implementation. Yes fadivse
would be a much better API, but the madvise API is still there.
Implementation wise: it does not use vmtruncate; it has no mmap_sem
problem.


> Fundamentally, hole
> punching is an inode operation, not a VM operation....

VM acts as a handle to inode operations. It's no big deal.


> > An API that doesn't require that, though, should be less overhead
> > and simpler.
> > 
> > Is it really going to be a problem to implement block hole punching
> > in ext4 and gfs2?
> 
> I can't follow the ext4 code - it's an intricate maze of weird entry
> and exit points, so I'm not even going to attempt to comment on it.
> 
> The gfs2 code is easier to follow and it looks like it would require
> a redesign and rewrite of the block truncation implementation as it
> appears to assume that blocks are only ever removed from the end of
> the file - I don't think the recursive algorithms for trimming the
> indirect block trees can be easily modified for punching out
> arbitrary ranges of blocks easily. I could be wrong, though, as I'm
> not a gfs2 expert....

I'm far more in favour of doing the interfaces right, and making
the filesystems fix themselves to use it.

