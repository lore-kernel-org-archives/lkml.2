Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab1EWR3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:29:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080Ab1EWR3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:29:13 -0400
Date: Mon, 23 May 2011 19:29:06 +0200
From: Jan Kara <jack@suse.cz>
To: Alex Bligh <alex@alex.org.uk>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: BUG: Failure to send REQ_FLUSH on unmount on ext3, ext4, and
 FS in general
Message-ID: <20110523172906.GH4716@quack.suse.cz>
References: <959E4E25EAEC544D31199E6F@nimrod.local>
 <20110523155550.GE4716@quack.suse.cz>
 <EC63F9E077B362A0FDCF3527@Ximines.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EC63F9E077B362A0FDCF3527@Ximines.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 23-05-11 18:09:17, Alex Bligh wrote:
> Jan,
> 
> --On 23 May 2011 17:55:50 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> >>But quite aside from the question of whether the FS supports barriers,
> >>should the kernel itself (rather than the FS) not be sending REQ_FLUSH on
> >>an unmount as the last thing that happens? IE shouldn't we see a flush
> >>even on (say) ext2 which is never going to support barriers. If the
> >>kernel itself generated a REQ_FLUSH for the block device, this would keep
> >>filesystems that don't support barriers safe provided the unmount
> >>completed successfully and would have no impact on ones that had already
> >>flushed the write-behind cache.
> >
> >  Yes, I think that generic VFS helpers should send barriers in cases
> >where it makes sense and umount is one of them. There even have been some
> >attempts to do so if I recall right but they didn't go anywhere.
> 
> Indeed I think even doing sync() on ext3 with default options does not
> send a flush to the write cache. I had a quick look at the code (which
  Yes, but that's rather a deficiency in default mount options of ext3
which is kept for backward buggy-for-performance compatibility. Anywone who
seriously cares about the data should use barrier=1 and BTW SUSE or RH
distros change the default to be barrier=1. Anyway, this is a seperate
issue.

> has got rather more complicated since the umount syscall moved from
> super.c to namespace.c) and it seemed to me the best thing to do would
> be for sync() on a block device to send a REQ_FLUSH to that device at
> the end (assuming the comment about sync actually completing I/O rather
> than merely initiating it still holds), and to ensure umount is calling
> sync.
  I wish it was this simple ;) The trouble is that clever filesystems -
e.g. xfs, ext4 - will send the flush when it's needed (after a transaction
commit). So sending it after flushing the device (which happens from
generic sync code) would result in two flushes instead of one - not good
for performance (although these days when we do merging of flush requests
the result need not be that bad).

The fs might indicate whether it handles barriers itself or whether it
wants VFS to handle it but that's where it's gets a bit complicated /
controversial ;).

> Would there be any interested in these patches if I cooked them up,
> or did they die because of opposition before rather than apathy?
  I guess you might come with some proposal and post it to linux-fsdevel
(include Al Viro and Christoph Hellwig in CC) and see what happens...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
