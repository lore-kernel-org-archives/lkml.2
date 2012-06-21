Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab2FUBfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:35:05 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:46231 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756678Ab2FUBfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:35:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwKAEp54k95LOQs/2dsb2JhbABFDrQXA4EvgQiCGAEBBAE6DQ8jEAgDGC4UJQMhE4gGBKpsjywUixocdYUKA4shigiGQ4k/giZLgUU
Date: Thu, 21 Jun 2012 11:34:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dima Tisnek <dimaqq@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, USB list <linux-usb@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: mount stuck, khubd blocked
Message-ID: <20120621013457.GQ30705@dastard>
References: <20120619214130.GO25389@dastard>
 <Pine.LNX.4.44L0.1206201020450.1804-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1206201020450.1804-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 10:31:37AM -0400, Alan Stern wrote:
> On Wed, 20 Jun 2012, Dave Chinner wrote:
> 
> > On Tue, Jun 19, 2012 at 10:45:10AM -0400, Alan Stern wrote:
> > > On Tue, 19 Jun 2012, Dima Tisnek wrote:
> > > 
> > > > I made a microsd flash with 2 partitions, sdb1 is data partition, and
> > > > sdb2 is a sentinel partition, 1 block in size.
> > > > 
> > > > I attached the usb-microsd reader with that card in it and by mistake
> > > > tried to mount the sentinel partition, I ran:
> > > > mount /dev/sdb2 /mnt/flash/
> > > > 
> > > > mount got stuck, I was not able to kill or strace it, I pulled the usb
> > > > reader from the port, mount was still stuck, here's the dmesg log:
> > 
> > So where is the mount process stuck? It's holding the lock that
> > khubd is stuck on....
> 
> Yes, that's most likely the right explanation.

.....

> > > As can be seen from the stack entries above, this problem lies in the 
> > > block or filesystem layer and not in USB or SCSI.
> > 
> > Don't blame the higher layers as the cause of the problem simply
> > because they are the ones that show the visible symptoms ;)
> 
> Okay, point taken.  It's always good to have a new point of view when 
> tackling a tough problem.
> 
> > The problem lies in the fact that the error handling callback that
> > is run when the device is removed triggers IO to the block device
> > that was just removed.  If all outstanding IOs have been error'd out
> > correctly, and all new IOs return errors, then there is no reason
> > for the fsync to block here. i.e. the mount process should have
> > received an error.
> > 
> > However, the mount could have hung because underlying device has not
> > been cleaned up properly before the device disconnect has proceeded.
> > i.e. that it is possible that the cause is a SCSI or USB issue, not a
> > filesystem issue. :)
> 
> But the mount got stuck _before_ the device was unplugged.  Hence
> failure to clean up cannot be the underlying cause.

Perhaps. It might not be stuck - sometimes mount does a lot of IO
(e.g. due to journal recovery or quota checks) and it can't be
killed when this is occurring, and it's only a single system call so
strace won't return anything. Hence the filesystem -could- have been
actively issuing IO whenteh device was pulled.

Only stack traces of all the blocked tasks will tell us any
different...

> > So, what other blocked tasks are there in the system (echo w >
> > /proc/sysrq-trigger)?
> > 
> > As it is, I think that invalidate_partition() is doing something
> > somewhat insane for a block device that has been removed - you can't
> > write to it so fsync_bdev() is useless.
> 
> That depends.  If by "removed" you mean physically disconnected from
> the computer, then yes.  But if "removed" means merely unregistered
> from the device core then writes can still succeed.  
> invalidate_partition() doesn't know which has happened.

Which means the lower layers probably need to pass that distinction
up to the invalidation function.

> >  And cleaning up the dentry
> > and inode caches is something that should be done when unmounting
> > the filesystem, not when the block device goes away as they can
> > trigger more IO and potentially deadlock with other operations that
> > have not handled the IO errors properly. Yes, shut a filesystem down
> > that has had it's block device removed, but filesystem level cleanup
> > should be left to the filesystem, not this error handling path.
> > 
> > And another question - why doesn't having an active filesystem on a
> > block device (i.e. an active reference to the gendisk) prevent the
> > block device from being removed from underneath it?
> 
> References prevent data structures from being deallocated, not from 
> being unregistered (or as James Bottomley likes to call it, "removed 
> from visibility").

Except the unregister path appears to assume that a valid block
device available when it is unregistered. That seems to me like
there is a bad assumption being made in this error handling path...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
