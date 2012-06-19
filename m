Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2FSBWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 21:22:02 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:39445 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656Ab2FSBWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 21:22:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMMAL/S3095LF7Z/2dsb2JhbABFsSCDHQOBLoEIghgBAQQBOhwPFAULCAMOCi4UJQMhExuHawS4exSLFRULboULA5Ujj36CcoFF
Date: Tue, 19 Jun 2012 11:20:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
        xfs@oss.sgi.com, LKML List <linux-kernel@vger.kernel.org>
Subject: Re: XFS status update for May 2012
Message-ID: <20120619012035.GG25389@dastard>
References: <20120618120853.GA15480@infradead.org>
 <AD997E9D-2C1E-4EE4-80D7-2A5C998B6E9E@dilger.ca>
 <20120618184344.GV4721@sgi.com>
 <1005E3D5-D9F4-42F9-8BAE-9FB40A8AFA57@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1005E3D5-D9F4-42F9-8BAE-9FB40A8AFA57@dilger.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 02:36:27PM -0600, Andreas Dilger wrote:
> On 2012-06-18, at 12:43 PM, Ben Myers wrote:
> > On Mon, Jun 18, 2012 at 12:25:37PM -0600, Andreas Dilger wrote:
> >> On 2012-06-18, at 6:08 AM, Christoph Hellwig wrote:
> >>> May saw the release of Linux 3.4, including a decent sized XFS update.
> >>> Remarkable XFS features in Linux 3.4 include moving over all metadata
> >>> updates to use transactions, the addition of a work queue for the
> >>> low-level allocator code to avoid stack overflows due to extreme stack
> >>> use in the Linux VM/VFS call chain,
> >> 
> >> This is essentially a workaround for too-small stacks in the kernel,
> >> which we've had to do at times as well, by doing work in a separate
> >> thread (with a new stack) and waiting for the results?  This is a
> >> generic problem that any reasonably-complex filesystem will have when
> >> running under memory pressure on a complex storage stack (e.g. LVM +
> >> iSCSI), but causes unnecessary context switching.
> >> 
> >> Any thoughts on a better way to handle this, or will there continue
> >> to be a 4kB stack limit and hack around this with repeated kmalloc
> >> on callpaths for any struct over a few tens of bytes, implementing
> >> memory pools all over the place, and "forking" over to other threads
> >> to continue the stack consumption for another 4kB to work around
> >> the small stack limit?
> > 
> > FWIW, I think your characterization of the problem as a 'workaround for
> > too-small stacks in the kernel' is about right.  I don't think any of
> > the XFS folk were very happy about having to do this, but in the near
> > term it doesn't seem that we have a good alternative.  I'm glad to see
> > that there are others with the same pain, so maybe we can build some
> > support for upping the stack limit.
> 
> Is this problem mostly hit in XFS with dedicated service threads like
> kNFSd and similar, or is it a problem with any user thread perhaps
> entering the filesystem for memory reclaim inside an already-deep
> stack?

When you have the flusher thread using 2-2.5k of stack before it
enters the filesystem, DM and MD below the filesystem using 1-1.5k
of stack, and the scsi driver doing a mempool allocation taking 3k
of stack, there's basically nothing left for the filesystem.

We took this action because the flusher thread (i.e. the thread with
the lowest top level stack usage) was blowing the stack during
delayed allocation.

> For dedicated service threads I was wondering about allocating larger
> stacks for just those processes (16kB would be safe), and then doing
> something special at thread startup to use this larger stack.  If
> the problem is for any potential thread, then the solution would be
> much more complex in all likelihood.

Anything that does a filemap_fdatawrite() call is susceptible to a
stack overrun. i having seen a O_SYNC write(2) call overrun a stack
yet, but it was only a matter of time. I certainly have seen the
same write call from an NFSD overrun the stack. It's lucky we have
te IO-less throttling now, otherwise any thread that enters
balance_dirty_pages() was a candidate for a stack overrun....

IOWs,the only solution that would fix the problem was to split
allocations into a different stack so that we have the approximately
4k of stack space needed for the worst case XFS stack usage (double
btree split requiring metadata IO) and still have enough space left
for the DM/MD/SCSI stack underneath it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
