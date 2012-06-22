Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049Ab2FVDWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 23:22:14 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:9454 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757483Ab2FVDWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 23:22:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwKAAbk4095LOQs/2dsb2JhbABFDrQlA4EqgQiCGAEBBAE6HCMQCAMYLhQlAyETiAYEuj4Uixogc4RvA4sjigiGQ4k/giZLgUU
Date: Fri, 22 Jun 2012 13:22:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dima Tisnek <dimaqq@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, USB list <linux-usb@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: mount stuck, khubd blocked
Message-ID: <20120622032206.GV19223@dastard>
References: <20120621013457.GQ30705@dastard>
 <Pine.LNX.4.44L0.1206211020450.1164-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1206211020450.1164-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 10:25:02AM -0400, Alan Stern wrote:
> On Thu, 21 Jun 2012, Dave Chinner wrote:
> 
> > > > As it is, I think that invalidate_partition() is doing something
> > > > somewhat insane for a block device that has been removed - you can't
> > > > write to it so fsync_bdev() is useless.
> > > 
> > > That depends.  If by "removed" you mean physically disconnected from
> > > the computer, then yes.  But if "removed" means merely unregistered
> > > from the device core then writes can still succeed.  
> > > invalidate_partition() doesn't know which has happened.
> > 
> > Which means the lower layers probably need to pass that distinction
> > up to the invalidation function.
> 
> I don't think that information is passed anywhere in the kernel.  And 
> in any case, it's not really important.  When a device is unregistered, 
> the upper layers shouldn't care about the reason why.

Then why have filesystem developers been asking for notifications
from the block layer that the device has been disconected for the
past couple of LSF summits? :)

Because we'd much prefer to know that part of the filesystem has
just disappeared and can't be used, rather than get back errors
every time we try to send an IO to the region that of the filesytem.
IO errors can be transient - disconnected block devices are not -
and so being able to tell the difference is important to handling
storage errors in a robust manner.

Think about BTRFS - knowing that a leg of an internal mirror has
been pulled out means it can select the other leg for all it's
metadata IO rather than just getting IO errors to it, and that it
can perhaps allocate a region on another device to mirror all new
metadata and avoid the problem altogether.

IOWs, there's plenty of good reasons for knowing that a device has
been disconnected at the higher layers of the storage stack....

> > > > And another question - why doesn't having an active filesystem on a
> > > > block device (i.e. an active reference to the gendisk) prevent the
> > > > block device from being removed from underneath it?
> > > 
> > > References prevent data structures from being deallocated, not from 
> > > being unregistered (or as James Bottomley likes to call it, "removed 
> > > from visibility").
> > 
> > Except the unregister path appears to assume that a valid block
> > device available when it is unregistered.
> 
> It may very well be available during the unregistration procedure.  
> There's nothing wrong with assuming it is -- if it isn't, I/O attempts 
> will simply fail.

It's clear that it isn't available, and you're assuming that IO
attempts are possible and that they will fail. If that assumption
was always valid, then we wouldn't have got this bug report....

> > That seems to me like
> > there is a bad assumption being made in this error handling path...
> 
> No; a bad assumption would be if the code assumed the device was 
> available _after_ the unregistration call had completed.

It's known to be unavaiable *during* the unregistration call, and
that code is assuming it is available.  When a device is forcible
unplugged from underenath an active filesytem, there is no guarantee
that it can extract itself from the mess that this leaves behind,
and assuming that it can is just wrong...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
