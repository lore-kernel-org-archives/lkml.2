Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0EXDJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 23:09:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:33092 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab0EXDJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 23:09:54 -0400
Date: Mon, 24 May 2010 13:09:43 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100524030943.GQ2516@laptop>
References: <20100512212403.GE3597@localhost.localdomain>
 <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
 <20100514010042.GI13617@dastard>
 <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
 <20100514072219.GC4706@laptop>
 <20100521151518.GA12752@infradead.org>
 <20100522023102.GP2516@laptop>
 <20100522083703.GA12087@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100522083703.GA12087@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 06:37:03PM +1000, Dave Chinner wrote:
> On Sat, May 22, 2010 at 12:31:02PM +1000, Nick Piggin wrote:
> > On Fri, May 21, 2010 at 11:15:18AM -0400, Christoph Hellwig wrote:
> > > Nick, what exactly is the problem with the reserve + allocate design?
> > > 
> > > In a delalloc filesystem (which is all those that will care about high
> > > performance large writes) the write path fundamentally consists of those
> > > two operations.  Getting rid of the get_blocks mess and replacing it
> > > with a dedicated operations vector will simplify things a lot.
> > 
> > Nothing wrong with it, I think it's a fine idea (although you may still
> > need a per-bh call to connect the fs metadata to each page).
> > 
> > I just much prefer to have operations after the copy not able to fail,
> > otherwise you get into all those pagecache corner cases.
> > 
> > BTW. when you say reserve + allocate, this is in the page-dirty path,
> > right? I thought delalloc filesystems tend to do the actual allocation
> > in the page-cleaning path? Or am I confused?
> 
> See my reply to Jan - delayed allocate has two parts to it - space
> reservation (accounting for ENOSPC) and recording of the delalloc extents
> (allocate). This is separate to the writeback path where we convert
> delalloc extents to real extents....

Yes I saw that. I'm sure we'll want clearer terminology in the core
code. But I don't quite know why you need to do it in 2 parts
(reserve, then "allocate"). Surely even reservation failures are
very rare, and obviously the error handling is required, so why not
just do a single call?

 
> > > Punching holes is a rather problematic operation, and as mentioned not
> > > actually implemented for most filesystems - just decrementing counters
> > > on errors increases the chances that our error handling will actually
> > > work massively.
> > 
> > It's just harder for the pagecache. Invalidating and throwing out old
> > pagecache and splicing in new pages seems a bit of a hack.
> 
> Hardly a hack - it turns a buffered write into an operation that
> does not expose transient page state and hence prevents torn writes.
> That will allow us to use DIF enabled storage paths for buffered
> filesystem IO(*), perhaps even allow us to generate checksums during
> copy-in to do end-to-end checksum protection of data....

It is a hack. Invalidating is inherently racy and isn't guaranteed
to succeed.

You do not need to invalidate the pagecache to do this (which as I said
is racy). You need to lock the page to prevent writes, and then unmap
user mappings. You'd also need to have done some magic so writable mmaps
don't leak into get_user_pages.

But this should be a different discussion anyway. Don't forget, your
approach is forced into the invalidation requirement because of
downsides in its error handling sequence. That cannot be construed as
positive, because you are forced into it, wheras other approaches
*could* use it, but do not have to.

