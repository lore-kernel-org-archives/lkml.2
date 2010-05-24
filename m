Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab0EXSmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:42:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65136 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab0EXSma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:42:30 -0400
Date: Mon, 24 May 2010 11:40:25 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
       Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100524184024.GA9905@mail.oracle.com>
Mail-Followup-To: Nick Piggin <npiggin@suse.de>,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20100514010042.GI13617@dastard>
 <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
 <20100514072219.GC4706@laptop>
 <20100521151518.GA12752@infradead.org>
 <20100522023102.GP2516@laptop>
 <20100522083703.GA12087@dastard>
 <20100524030943.GQ2516@laptop>
 <20100524055329.GD12087@dastard>
 <20100524065519.GT2516@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100524065519.GT2516@laptop>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090201.4BFAC851.017C:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 04:55:19PM +1000, Nick Piggin wrote:
> On Mon, May 24, 2010 at 03:53:29PM +1000, Dave Chinner wrote:
> > Because if we fail after the allocation then ensuring we handle the
> > error *correctly* and *without further failures* is *fucking hard*.
> 
> I don't think you really answered my question. Let me put it in concrete
> terms. In your proposal, why not just do the reserve+allocate *after*
> the pagecache copy? What does the "reserve" part add?

	In ocfs2, we can't just crash our filesystem.  We have to be
safe not just with respect to the local machine, we have to leave the
filesystem in a consistent state - structure *and* data - for the other
nodes.
	The ordering and locking of allocation in get_block(s)() is so
bad that we just Don't Do It.  By the time get_block(s)() is called, we
require our filesystem to have the allocation done.  We do our
allocation in write_begin().   By the time we get to the page copy, we
can't ENOSPC or EDQUOT.  O_DIRECT I/O falls back to sync buffered I/O if
it must allocate, pushing us through write_begin() forcing other nodes
to honor what we've done.
	This is easily extended to the reserve multipage operation.
It's not delalloc, because we actually allocate in the reserve
operation.  We handle it just like a large case of the single page
operation.  Someday we hope to add delalloc, and it would actually do
better here.
	I guess you could call this "copy middle" like Dave describes in
his followup to your mail.  Copy Middle also has the property that it
can handle short writes without any error handling.  Copy First has to
discover it can only get half the allocation and drop the latter half of
the pagecache.  Copy Last has to discover it can only do half the page
copy and drop the latter half of the allocation.

> > IMO, the fundamental issue with using hole punching or direct IO
> > from the zero page to handle errors is that they are complex enough
> > that there is *no guarantee that they will succeed*. e.g. Both can
> > get ENOSPC/EDQUOT because they may end up with metadata allocation
> > requirements above and beyond what was originally reserved. If the
> > error handling fails to handle the error, then where do we go from
> > there?
> 
> There are already fundamental issues that seems like they are not
> handled properly if your filesystem may allocate uninitialized blocks
> over holes for writeback cache without somehow marking them as
> uninitialized.
> 
> If you get a power failure or IO error before the pagecache can be
> written out, you're left with uninitialized data there, aren't you?
> Simple buffer head based filesystems are already subject to this.

	Sure, ext2 does this.  But don't most filesystems guaranteeing
state actually make sure to order such I/Os?  If you run ext3 in
data=writeback, you get what you pay for.  This sounds like a red
herring.
	Dave's original point stands.  ocfs2 supports unwritten extents
and punching holes.  In fact, we directly copied the XFS ioctl(2)s.  But
when we do punch holes, we have to adjust our tree.  That may require
additional metadata, and *that* can fail with ENOSPC or EDQUOT.

Joel

-- 

"I always thought the hardest questions were those I could not answer.
 Now I know they are the ones I can never ask."
			- Charlie Watkins

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
