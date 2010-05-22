Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab0EVIhO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:37:14 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:53486 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753318Ab0EVIhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:37:09 -0400
Date: Sat, 22 May 2010 18:37:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100522083703.GA12087@dastard>
References: <20100512212403.GE3597@localhost.localdomain>
 <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
 <20100514010042.GI13617@dastard>
 <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
 <20100514072219.GC4706@laptop>
 <20100521151518.GA12752@infradead.org>
 <20100522023102.GP2516@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100522023102.GP2516@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 12:31:02PM +1000, Nick Piggin wrote:
> On Fri, May 21, 2010 at 11:15:18AM -0400, Christoph Hellwig wrote:
> > Nick, what exactly is the problem with the reserve + allocate design?
> > 
> > In a delalloc filesystem (which is all those that will care about high
> > performance large writes) the write path fundamentally consists of those
> > two operations.  Getting rid of the get_blocks mess and replacing it
> > with a dedicated operations vector will simplify things a lot.
> 
> Nothing wrong with it, I think it's a fine idea (although you may still
> need a per-bh call to connect the fs metadata to each page).
> 
> I just much prefer to have operations after the copy not able to fail,
> otherwise you get into all those pagecache corner cases.
> 
> BTW. when you say reserve + allocate, this is in the page-dirty path,
> right? I thought delalloc filesystems tend to do the actual allocation
> in the page-cleaning path? Or am I confused?

See my reply to Jan - delayed allocate has two parts to it - space
reservation (accounting for ENOSPC) and recording of the delalloc extents
(allocate). This is separate to the writeback path where we convert
delalloc extents to real extents....

> > Punching holes is a rather problematic operation, and as mentioned not
> > actually implemented for most filesystems - just decrementing counters
> > on errors increases the chances that our error handling will actually
> > work massively.
> 
> It's just harder for the pagecache. Invalidating and throwing out old
> pagecache and splicing in new pages seems a bit of a hack.

Hardly a hack - it turns a buffered write into an operation that
does not expose transient page state and hence prevents torn writes.
That will allow us to use DIF enabled storage paths for buffered
filesystem IO(*), perhaps even allow us to generate checksums during
copy-in to do end-to-end checksum protection of data....

Cheers,

Dave.

(*) Yes, I know that mmap writes will still break DIF even if we do
writes this way.
-- 
Dave Chinner
david@fromorbit.com
