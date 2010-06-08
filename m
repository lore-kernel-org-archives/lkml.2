Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab0FHC1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 22:27:19 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:59683 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750897Ab0FHC1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 22:27:18 -0400
Date: Tue, 8 Jun 2010 12:26:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <josef@redhat.com>
Cc: Jeffrey Merkey <jeffmerkey@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: 2.6.34 echo j > /proc/sysrq-trigger causes inifnite
 unfreeze/Thaw event
Message-ID: <20100608022652.GC6965@dastard>
References: <AANLkTim74SREZDq7VQhq6Z1hKXZLINoq0t8rkyQecmM1@mail.gmail.com>
 <20100607010542.GB27325@dastard>
 <20100607213631.GE2336@localhost.localdomain>
 <20100607215925.GF2336@localhost.localdomain>
 <20100607232350.GA6965@dastard>
 <20100608020741.GG2336@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100608020741.GG2336@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 10:07:41PM -0400, Josef Bacik wrote:
> On Tue, Jun 08, 2010 at 09:23:50AM +1000, Dave Chinner wrote:
> > On Mon, Jun 07, 2010 at 05:59:25PM -0400, Josef Bacik wrote:
> > > On Mon, Jun 07, 2010 at 05:36:31PM -0400, Josef Bacik wrote:
> > > > 1) Make a __thaw_super() that just does all the work currently in thaw_super(),
> > > > just without taking the s_umount semaphore.
> > > > 2) Make an thaw_bdev_force or something like that that just sets
> > > > bd_fsfreeze_count to 0 and calls __thaw_super().  The original intent was to
> > > > make us call thaw until the thaw actually occured, so might as well just make it
> > > > quick and painless.
> > 
> > Makes sense.  Only problem I can see for emergency thaws is that
> > we'd call __thaw_super() under a down_read(&sb->s_umount) instead of
> > the down_write(&sb->s_umount) lock we are currently supposed to hold
> > for it. I don't think this is a problem because thaw_bdev is
> > serialised by the bd_fsfreeze_mutex and it would still lock out new
> > cals to freeze_super.
> > 
> 
> Urgh yeah you're right.
> 
> > > > 3) Make do_thaw_one() call __thaw_super if sb->s_bdev doesn't exist.  I'm not
> > > > sure if this happens currently, but it's nice just in case.
> > 
> > It doesn't happen currently, not sure what sort of kaboom might
> > occur if we do :/
> > 
> > What about btrfs - wasn't freeze/thaw_super added so it could
> > avoid the bdev interfaces as s_bdev is not reliable? Doesn't that
> > mean we need to call thaw_super() in that case, even though we have
> > a non-null sb->s_bdev?
> > 
> 
> Yeah, thats why I made it unconditionally call thaw_super(), it should work out
> fine for btrfs.
> 
> > > > This takes care of the s_umount problem and makes sure that do_thaw_one does
> > > > actually thaw the device.  Does this sound kosher to everybody?  Thanks,
> > 
> > It will fix the emergency thaw problems, I think, but it doesn't
> > solve the nesting problem. i.e.  freeze_bdev, followed by
> > ioctl_fsfreeze(), followed by ioctl_fsthaw() will result in the
> > filesystem being unfrozen while the caller for freeze_bdev (e.g.
> > dm-snapshot) still needs the filesystem to be frozen.
> > 
> > Basically the change to the ioctls to call freeze/thaw_super() is
> > the problem here - to work with dm-snapshot corectly they need to
> > call freeze/thaw_bdev.  Perhaps we need some other way of signalling
> > whether to use the bdev or sb level freeze/thaw interface as I think
> > it needs to be consistent across a given superblock (dm, ioctl, fs
> > and emergency thaw), not a mix of both...
> > 
> 
> Well damnit.  I guess what we need to do is get rid of the freeze_bdev/thaw_bdev
> interface altogether, and move the count stuff down to the super.  Anybody who
> calls freeze_bdev/thaw_bdev knows the sb anyway, so if we get rid of
> bd_fsfreeze_count and move it to sb->s_fsfreeze_count and do the same with
> bd_fsfreeze_mutex then we could solve this altogether and simplify the
> interface.  It grows the sb struct, but hey it shrinks the bdev struct :).  How
> horrible of an idea is that?  Thanks,

Kind of what I was thinking of. I wasn't sure about what btrfs
required, but you've cleared that up. I'll put a patch together and
see how it looks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
