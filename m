Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1E0SYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:24:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42970 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab1E0SYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:24:14 -0400
Date: Fri, 27 May 2011 13:24:06 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Christoph Hellwig <hch@infradead.org>,
        Anton Salikhmetov <alexo@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: hfsplus mount regression in 2.6.38
Message-ID: <20110527182406.GB13908@thinkpad-t410>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Anton Salikhmetov <alexo@tuxera.com>, linux-kernel@vger.kernel.org
References: <20110525142521.GA32511@thinkpad-t410>
 <20110527092522.GA11600@infradead.org>
 <20110527132356.GA13908@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527132356.GA13908@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 08:23:56AM -0500, Seth Forshee wrote:
> On Fri, May 27, 2011 at 05:25:22AM -0400, Christoph Hellwig wrote:
> > On Wed, May 25, 2011 at 09:25:21AM -0500, Seth Forshee wrote:
> > > Reverting commits 52399b1 (hfsplus: use raw bio access for the volume
> > > headers) and 358f26d5 (hfsplus: use raw bio access for partition tables)
> > > fixes the problems. It appears the problems are due to hfsplus
> > > submitting 512 byte bios to a block device whose sector size is larger
> > > than 512 byts (2 KB in the log above), and the block driver is quite
> > > reasonably rejecting any requests without proper sector alignment.
> > > 
> > > How would you suggest fixing this?  Most file systems are using
> > > sb_bread() for this sort of thing, but since the offending patches are
> > > intended to stop using buffer_heads I'm assuming that's not an option.
> > 
> > Basically all hardcoded uses of HFSPLUS_SECTOR_SIZE need to be replaced
> > with a use of bdev_logical_block_size, or a per-sb variable derived from
> > it, and the addressing needs to be accomodated to fit it.  I'd need to
> > look into a bit more detail in what form the sectors we pass into it
> > are in - we might have to convert them from 512byte to large units,
> > or they might already be in it.  If they happen to be in 512 byte units
> > we might have to do read-modify write cycles.
> 
> It seems reasonable to use sb->s_blocksize for this, as it shouldn't get
> set to anything larger than the logical block size. That's what
> sb_bread() uses in fact.

I started looking into this, and it seems like one aspect of it is a
little nasty. My knowledge here is rudimentary at best though, so maybe
you can comment on whether or not this situation is possible.

It looks like some of the metadata accessed via bio can reside in blocks
adjacent to blocks containing file data, in which case it would be
possible for some of this metadata to be present in the page cache.
This could potentially lead to races where metadata changes are
committed and later overwritten by stale data in the page cache. Is this
a valid concern?

I'm also not fully understanding why using buffer_heads caused the issue
these patches were intended to fix. It looks to me like the bios
submitted by sb_bread() to read the alternate volume header should be
the maximum of 512 bytes and the logical block size set by the block
driver. So unless the block driver is setting this size incorrectly I
don't see how the I/O size gets forced to 4 KB. Am I missing something?

Thanks,
Seth
