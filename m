Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab1ADHMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 02:12:21 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:26205 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757Ab1ADHMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 02:12:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANJWIk15Ldpx/2dsb2JhbACkNXS7PIVKBJAq
Date: Tue, 4 Jan 2011 18:12:12 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com,
        joel.becker@oracle.com
Subject: Re: [patch 7/8] fs: fix or note I_DIRTY handling bugs in
 filesystems
Message-ID: <20110104071212.GG3402@amd>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.652706340@kernel.dk>
 <20101229150108.GA13358@infradead.org>
 <1294067009.2429.109.camel@dolmen>
 <20110103165821.GA1336@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110103165821.GA1336@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 11:58:21AM -0500, Christoph Hellwig wrote:
> On Mon, Jan 03, 2011 at 03:03:29PM +0000, Steven Whitehouse wrote:
> > 
> >  - With "journaled data" files
> >    - Do a log flush conditional upon the inode's glock
> >    - The core code then writes back any dirty pages
> 
> Any data writeback is done before calling ->fsync.
> 
> >  - With regular files/directories
> >   - If datasync is not set, we need to write back the metadata including
> > timestamp updates, so that is done via ->write_inode. Note that an extra
> > complication here is that we need to get the glock on the inode if we
> > don't already have it in order to check and conditionally update the
> > atime.The call to ->write_inode includes an implicit (conditional) log
> > flush.
> >  - If datasync is set, we assume that only the data pages need to be
> > written out. My understanding of datasync was that it was only supposed
> > to write out data and never any of the metadata. The reason for the call
> > to flush the log for "stuffed" files is that the data shares a disk
> > block with the inode metadata, so we cannot avoid the log flush in this
> > case, since we must unpin the block to write it back.
> 
> What happens to indirect blocks, inode size updates, etc?  In general
> the only correct form to use the datasync argument is along the lines
> of:
> 
> 	if ((inode->i_state & I_DIRTY_DATASYNC) ||
> 	    ((inode->i_state & I_DIRTY_SYNC) && !datasync)) {
> 		/* write out the inode */
> 	} else {
> 		/*
> 		 * VFS inode not dirty, no need to write it out.
> 		 *
> 		 * If the filesystem support asynchronous inode writes,
> 		 * we may have to wait for them here.
> 		 */
> 	}
> 
> or rather mostly correct, as pointed out by Nick in this series, that's
> why the above gets replaced with an equivalent check that also
> participates in the writeback locking protocol in this series.

Just to recap, basically we have 2 main problems in vfs/filesystems:

- i_state dirtyness is checked outside the correct synchronization
  protcol, so it may be seen as clean before a concurrent writer
  has finished.

- .write_inode is only guaranteed to be called once regardless of sync
  or async mode, for a dirty inode at a sync point. Many filesystems
  were incorrectly assuming they would be called once *in synchronous
  mode*.

  The optimal approach for .write_inode seems to be clean the struct
  inode so that it may be eventually reclaimed. Then have your .fsync and
  .sync_fs implementations enforce the actual data integrity.

  Note that "clean struct inode" often means to copy the metadata
  somewhere else to be scheduled for asynch writeout. You have to be
  careful to note that if you allow the inode to be evicted at this
  point without data integrity point also in .evict_inode, then you need
  to keep in mind that .sync_fs (and subsequent .fsync, if the inode is
  re opened) need to still enforce integrity for these potentially
  evicted inodes.

Everyone happy with this? Please review your filesystems and look at
my patches :)

Thanks,
Nick

