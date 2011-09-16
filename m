Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750906Ab1IPA0C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 20:26:02 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36730 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab1IPA0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 20:26:00 -0400
Date: Thu, 15 Sep 2011 17:25:57 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Stalls during writeback for mmaped I/O on XFS in 3.0
Message-ID: <20110916002557.GN11984@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110915144755.GB2235@BohrerMBP.rgmadvisors.com> <20110915145556.GA19902@infradead.org> <20110915154748.GC2235@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915154748.GC2235@BohrerMBP.rgmadvisors.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 10:47:48AM -0500, Shawn Bohrer wrote:
> Thanks Christoph,
> 
> On Thu, Sep 15, 2011 at 10:55:57AM -0400, Christoph Hellwig wrote:
> > On Thu, Sep 15, 2011 at 09:47:55AM -0500, Shawn Bohrer wrote:
> > > I've got a workload that is latency sensitive that writes data to a
> > > memory mapped file on XFS.  With the 3.0 kernel I'm seeing stalls of
> > > up to 100ms that occur during writeback that we did not see with older
> > > kernels.  I've traced the stalls and it looks like they are blocking
> > > on wait_on_page_writeback() introduced in
> > > d76ee18a8551e33ad7dbd55cac38bc7b094f3abb "fs: block_page_mkwrite
> > > should wait for writeback to finish"
> > > 
> > > Reading the commit description doesn't really explain to me why this
> > > change was needed.
> > 
> > It it there to avoid pages beeing modified while they are under
> > writeback, which defeats various checksumming like DIF/DIX, the iscsi
> > CRCs, or even just the RAID parity calculations.  All of these either
> > failed before, or had to work around it by copying all data was
> > written.
> 
> I'm assuming you mean software RAID here?  We do have a hardware RAID

Yes.

> controller.  Also for anything that was working around this issue
> before by copying the data, are those workarounds still in place?

I suspect iscsi and md-raid5 are still making shadow copies of data blocks
before writing them out.  However, there was no previous workaround for DIF/DIX
errors -- this ("*_page_mkwrite should wait...") patch series _is_ the fix for
DIF/DIX.  I recall that we rejected the shadow buffer approach for DIF/DIX
because allocating new pages is expensive if we do it for each disk write in
anticipation of future page writes...

> > If you don't use any of these you can remove the call and things
> > will work like they did before.
> 
> I may do this for now.
> 
> In the longer term is there any chance this could be made better?  I'm
> not an expert here so my suggestions may be naive.  Could a mechanism
> be made to check if the page needs to be checksummed and only block in

...however, one could replace that wait_on_page_writeback with some sort of
call that would duplicate the page, update each program's page table to point
to the new page, and then somehow reap the page that's under IO when the IO
completes.  That might also be complicated to implement, I don't know.  If
there aren't any free pages, then this scheme (and the one I mentioned in the
previous paragraph) will block a thread while the system tries to reclaim some
pages.

I think we also talked about a block device flag to signal that the device
requires stable page writes, which would let us turn off the waits on devices
that don't care.  That at least could defer this discussion until you encounter
one of these devices that wants stable page writes.

I'm curious, is this program writing to the mmap region while another program
is trying to fsync/fdatasync/sync dirty pages to disk?  Is that how you noticed
the jittery latency?  We'd figured that not many programs would notice the
latency unless there was something that was causing a lot of dirty page writes
concurrent to something else dirtying a lot of pages.  Clearly we failed in
your case.  Sorry. :/

That said, imagine if we revert to the pre-3.0 mechanism (or add that flag): if
we start transferring page A to the disk for writing and your program comes in
and changes A to A' before that transfer completes, then the disk will see a
data blob that is partly A and partly A', and the proportions of A/A' are
ill-defined.  I agree that ~100ms latency is not good, however. :(

What are your program's mmap write latency requirements?

> that case?  Or perhaps some mount option, madvise() flag or other hint
> from user-mode to disable this, or hint that I'm going to be touching
> that page again soon?

--D
