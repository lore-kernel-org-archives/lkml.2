Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0FGXYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 19:24:12 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:51138 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752772Ab0FGXYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 19:24:10 -0400
Date: Tue, 8 Jun 2010 09:23:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <josef@redhat.com>
Cc: Jeffrey Merkey <jeffmerkey@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: 2.6.34 echo j > /proc/sysrq-trigger causes inifnite
 unfreeze/Thaw event
Message-ID: <20100607232350.GA6965@dastard>
References: <AANLkTim74SREZDq7VQhq6Z1hKXZLINoq0t8rkyQecmM1@mail.gmail.com>
 <20100607010542.GB27325@dastard>
 <20100607213631.GE2336@localhost.localdomain>
 <20100607215925.GF2336@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100607215925.GF2336@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 05:59:25PM -0400, Josef Bacik wrote:
> On Mon, Jun 07, 2010 at 05:36:31PM -0400, Josef Bacik wrote:
> > On Mon, Jun 07, 2010 at 11:05:42AM +1000, Dave Chinner wrote:
> > > On Thu, Jun 03, 2010 at 11:30:30PM -0600, Jeffrey Merkey wrote:
> > > > causes the FS Thaw stuff in fs/buffer.c to enter an infinite loop
> > > > filling the /var/log/messages with junk and causing the hard drive to
> > > > crank away endlessly.
> > > 
> > > Hmmm, looks pretty obvious what the 2.6.34 bug is:
> > > 
> > >         while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
> > >                 printk(KERN_WARNING "Emergency Thaw on %s\n",
> > >                        bdevname(sb->s_bdev, b));
> > > 
> > > thaw_bdev() returns 0 on success or not frozen, and returns non-zero
> > > only if the unfreeze failed. Looks like it was broken from the start
> > > to me.
> > > 
> > > Fixing that endless loop shows some other problems on 2.6.35,
> > > though: the emergency unfreeze is not unfreezing frozen XFS
> > > filesystems.  This appears to be caused by
> > > 18e9e5104fcd9a973ffe3eed3816c87f2a1b6cd2 ("Introduce freeze_super
> > > and thaw_super for the fsfreeze ioctl").
> > > 
> > > It appears that this introduces a significant mismatch between the
> > > bdev freeze/thaw and the super freze/thaw. That is, if you freeze
> > > with the sb method, you can only unfreeze via the sb method.
> > > however, if you freeze via the bdev method, you can unfreeze by
> > > either the bdev or sb method.  This breaks the nesting of the
> > > freeze/thaw operations between dm and userspace, which can lead to
> > > premature thawing of the filesystem.
> > > 
> > > Then there is this deadlock:
> > > 
> > > iterate_supers(do_thaw_one) does:
> > > 
> > > 	down_read(&sb->s_umount);
> > > 	do_thaw_one(sb)
> > > 	  thaw_bdev(sb->s_bdev, sb))
> > > 	    thaw_super(sb)
> > > 	      down_write(&sb->s_umount);
> > > 
> > > Which is an instant deadlock.
> > > 
> > > These problems were hidden by the fact that the emergency thaw code
> > > was not getting past the thaw_bdev guards and so not triggering
> > > this deadlock.
> > > 
> > > Al, Josef, what's the best way to fix this mess?
> > > 
> > 
> > Well we can do something like the following
> > 
> > 1) Make a __thaw_super() that just does all the work currently in thaw_super(),
> > just without taking the s_umount semaphore.
> > 2) Make an thaw_bdev_force or something like that that just sets
> > bd_fsfreeze_count to 0 and calls __thaw_super().  The original intent was to
> > make us call thaw until the thaw actually occured, so might as well just make it
> > quick and painless.

Makes sense.  Only problem I can see for emergency thaws is that
we'd call __thaw_super() under a down_read(&sb->s_umount) instead of
the down_write(&sb->s_umount) lock we are currently supposed to hold
for it. I don't think this is a problem because thaw_bdev is
serialised by the bd_fsfreeze_mutex and it would still lock out new
cals to freeze_super.

> > 3) Make do_thaw_one() call __thaw_super if sb->s_bdev doesn't exist.  I'm not
> > sure if this happens currently, but it's nice just in case.

It doesn't happen currently, not sure what sort of kaboom might
occur if we do :/

What about btrfs - wasn't freeze/thaw_super added so it could
avoid the bdev interfaces as s_bdev is not reliable? Doesn't that
mean we need to call thaw_super() in that case, even though we have
a non-null sb->s_bdev?

> > This takes care of the s_umount problem and makes sure that do_thaw_one does
> > actually thaw the device.  Does this sound kosher to everybody?  Thanks,

It will fix the emergency thaw problems, I think, but it doesn't
solve the nesting problem. i.e.  freeze_bdev, followed by
ioctl_fsfreeze(), followed by ioctl_fsthaw() will result in the
filesystem being unfrozen while the caller for freeze_bdev (e.g.
dm-snapshot) still needs the filesystem to be frozen.

Basically the change to the ioctls to call freeze/thaw_super() is
the problem here - to work with dm-snapshot corectly they need to
call freeze/thaw_bdev.  Perhaps we need some other way of signalling
whether to use the bdev or sb level freeze/thaw interface as I think
it needs to be consistent across a given superblock (dm, ioctl, fs
and emergency thaw), not a mix of both...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
