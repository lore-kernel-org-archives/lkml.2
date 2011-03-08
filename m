Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1CHAFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 19:05:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:43298 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789Ab1CHAFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 19:05:04 -0500
Date: Tue, 8 Mar 2011 11:04:53 +1100
From: NeilBrown <neilb@suse.de>
To: James Bottomley <James.Bottomley@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] Fix over-zealous flush_disk when changing
 device size.
Message-ID: <20110308110453.0047307d@notabene.brown>
In-Reply-To: <1299538572.15955.90.camel@mulgrave.site>
References: <20110217165057.5c50e566@notabene.brown>
	<20110303143120.GA8134@infradead.org>
	<20110304111624.4be27aaf@notabene.brown>
	<1299259506.2118.24.camel@grinch>
	<20110306174755.49404c8e@notabene.brown>
	<1299471771.2228.11.camel@grinch>
	<1299516418.15258.4.camel@mulgrave.site>
	<20110308094412.1c45b277@notabene.brown>
	<1299538572.15955.90.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Mar 2011 16:56:12 -0600 James Bottomley <James.Bottomley@suse.de>
wrote:

> On Tue, 2011-03-08 at 09:44 +1100, NeilBrown wrote:
> > (linux-fsdevel added - seems relevant)
> 
> Heh, Christoph will be pleased.
> 
> > On Mon, 07 Mar 2011 10:46:58 -0600 James Bottomley <James.Bottomley@suse.de>
> > wrote:
> > 
> > > On Sun, 2011-03-06 at 21:22 -0700, Andrew Patterson wrote:
> > > > On Sun, 2011-03-06 at 17:47 +1100, NeilBrown wrote:
> > > > >  Would you be uncomfortable if I asked Linus to revert both my fix and your
> > > > >  original patch??
> > > > 
> > > > James Bottomley wanted me to put this functionality in. I have no
> > > > problem with reverting it myself, especially if it is causing other
> > > > problems.  I would have to say that you need to ask him (or rather, I am
> > > > not qualified to render an opinion here).
> > > 
> > > So it seems we have a couple of problems: the first being that
> > > flush_disk() doesn't actually do what it says (flush the disk).  If it's
> > > just discarding all data, dirty or clean, then its use in the
> > > grow/shrink interface is definitely wrong.
> > > 
> > > The idea is that before we complete the grow/shrink, we make sure that
> > > the device doesn't have any errors, so we want to try to write out all
> > > dirty buffers to make sure they still have a home.  If flush_disk()
> > > doesn't do that, then we need to use a different interface ... what's
> > > the interface to flush a disk?
> > > 
> > 
> > Hi James,
> > 
> > I *always* want to make sure that my device doesn't have any errors, not just
> > when it changes size... but I'm not sure that regularly flushing out data is
> > the right way to do it.
> > But maybe I still misunderstand what the real point of this is.
> 
> I actually have no idea what you're talking about now.  Let me start at
> the beginning:

Thanks!

> 
> The idea behind flushing a disk on size changes is to ensure we get
> immediate detection of screw ups. (screw ups specifically means dirty
> data in the lost region which we can no longer write back).
> 
> If the device is reducing in size and the FS supports this, some data
> migrates from the soon to be lost blocks at the end.  The point about
> running a full page cache flush for the device after it has been shrunk
> is supposed to be to detect a screw up (i.e. a dirty page that just lost
> its backing store).

Make sense.  So what you *really* want to do is actively tell the filesystem
that the device is now smaller and that is should complain loudly if that is
a problem.
You cannot directly do that, so a second best is to tell it to flush all
data in the hope that if there is a problem, then this has at least some
chance of causing it to be reported.

So you don't need to purge any caches - just flush them.

I'm having trouble seeing the relevant of the bit about "some data migrates
from the soon to be lost blocks at the end".
If you have previously requested the fs to resize downwards, then I would
expect all of this to be fully completed - maybe you are trying to detect
bugs in the filesystem's 'shrink' function?  Maybe it isn't directly relevant
and you are just providing it as general context ??

> 
> My original thought was that this only needed to be done on shrink, but
> HP had some pathological case where grow was implemented as shrink
> first, so it got done on all size changes.

I cannot see the relevance of this to the "flush caches" approach.
If the size of the device shrinks and then grows while data is in a cache,
and then you flush, it will simply result in random data appearing
in the "new" part of the device, with no reason to expect errors.

It could be relevant if you were purging caches as well as it makes sure
you don't see stale data from before a shrink.

So you seem to be saying that "purge" is important too - correct?

> 
> > As for the correct interface to flush a disk - there isn't one.
> > One doesn't flush a storage device, one flushes a cache - to a storage
> > device.  And there is not a 1-to-1 mapping.
> > 
> > A block device *is* associated with one cache - one which is used for
> > caching accesses through /dev/XXX and also by some filesystems to cache some
> > metadata.  You can flush this cache with sync_blockdev().  This just
> > flushes out dirty pages in that cache, it doesn't discard clean pages.
> > invalidate_bdev() can discard clean pages.  Call both, and get both outcomes.
> > 
> > If a filesystem is mounted directly on a given block_device, then it
> > should have a valid s_bdev pointer and it is possible to find that filesystem
> > from the block_device using get_active_super().  You could then call
> > sync_filesystem() to flush out dirty data.  There isn't really a good
> > interface to discard clean data. shrink_dcache_sb() does some of it, other
> > bits of code do other bits.
> > 
> > Note that a block_device also can have a pointer to a super_block (bd_super).
> > This does not seem to be widely used .... ext3 and ext4 use it so that memory
> > pressure felt by the block-device cache can transmitted to the fs, so the
> > fs can associate private data with the block device's cache I guess.
> > I don't think bd_super is sufficiently persistent reference to be usable
> > for sync_filesystems (it could race with unmount).
> > 
> > 
> > But if the block device is within a dm or md device, or is an external
> > journal for e.g. ext3, or is in some more complex relationship with a
> > filesystem, then there is no way to request that any particular cache get
> > flushed to the block device.  And if some user-space app has cached data
> > for the device .... there is no way to get at that either.
> > 
> > If we wanted a "proper" solution for this we probably need to leverage
> > the 'bd_claim' concept.  When a device is claimed, allow an 'operations'
> > structure to be provided with operations like:
> >    flush_caches  (writes out data)
> >    purge_caches  (discards clean data)
> >    discard_caches  (discards all data)
> >    prepare_resize (is allowed to fail)
> >    commit_resize
> >    freeze_io
> >    thaw_io
> 
> What makes you think we participate in the resize?  Most often we just
> get notified.  There may or may not have been some preparation, but it's
> mostly not something we participate in.

You may not participate in the resize, but dm and md do and the
"prepare_resize" part of the interface would be useful to them.  I agree
that it might not be useful to SCSI devices.

> 
> > But flush_disk is definitely a wrong interface.  It has a meaningless name
> > (as discussed above), and purges some caches while discarding others.
> > 
> > What do we *really* lose if we just revert that original patch?
> 
> Synchronous notification of errors.  If we don't try to write everything
> back immediately after the size change, we don't see dirty pages in
> zapped regions until the writeout/page cache management takes it into
> its head to try to clean the pages.
> 

So if you just want synchronous errors, I think you want:
    fsync_bdev()

which calls sync_filesystem() if it can find a filesystem, else
sync_blockdev();  (sync_filesystem itself calls sync_blockdev too).

However this doesn't purge clean pages from the caches so there
might be the stale data issue.

Do you see that as a real issue?

(Just a bit of clarification:  fsync_bdev flushes but does not purge.
 flush_disk purges but does not flush.  So with flush_disk there I don't
 think you will have been getting the errors you want.
 Also - fsync_bdev() takes a lot longer than flush_disk.  I hope
 revalidate_disk is only called from places where it is safe to block
 for FS writeout ... I think it is.).

Thanks,
NeilBrown
