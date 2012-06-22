Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab2FVOcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:32:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43722 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932421Ab2FVOc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:32:28 -0400
Date: Fri, 22 Jun 2012 10:32:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dave Chinner <david@fromorbit.com>
cc: Dima Tisnek <dimaqq@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, USB list <linux-usb@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: mount stuck, khubd blocked
In-Reply-To: <20120622032206.GV19223@dastard>
Message-ID: <Pine.LNX.4.44L0.1206221022370.1578-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012, Dave Chinner wrote:

> On Thu, Jun 21, 2012 at 10:25:02AM -0400, Alan Stern wrote:
> > On Thu, 21 Jun 2012, Dave Chinner wrote:
> > 
> > > > > As it is, I think that invalidate_partition() is doing something
> > > > > somewhat insane for a block device that has been removed - you can't
> > > > > write to it so fsync_bdev() is useless.
> > > > 
> > > > That depends.  If by "removed" you mean physically disconnected from
> > > > the computer, then yes.  But if "removed" means merely unregistered
> > > > from the device core then writes can still succeed.  
> > > > invalidate_partition() doesn't know which has happened.
> > > 
> > > Which means the lower layers probably need to pass that distinction
> > > up to the invalidation function.
> > 
> > I don't think that information is passed anywhere in the kernel.  And 
> > in any case, it's not really important.  When a device is unregistered, 
> > the upper layers shouldn't care about the reason why.
> 
> Then why have filesystem developers been asking for notifications
> from the block layer that the device has been disconected for the
> past couple of LSF summits? :)

I don't know -- I don't attend LSF summits (and I can't read the 
filesystem developers' minds).  :-)

Still, I have nothing _against_ such notifications.  I'm just saying 
that things should work properly even in their absence.

> Because we'd much prefer to know that part of the filesystem has
> just disappeared and can't be used, rather than get back errors
> every time we try to send an IO to the region that of the filesytem.
> IO errors can be transient - disconnected block devices are not -
> and so being able to tell the difference is important to handling
> storage errors in a robust manner.
> 
> Think about BTRFS - knowing that a leg of an internal mirror has
> been pulled out means it can select the other leg for all it's
> metadata IO rather than just getting IO errors to it, and that it
> can perhaps allocate a region on another device to mirror all new
> metadata and avoid the problem altogether.
> 
> IOWs, there's plenty of good reasons for knowing that a device has
> been disconnected at the higher layers of the storage stack....

There was a discussion about this about half a year ago (although from 
a somewhat different point of view):

	http://marc.info/?t=132577666300004&r=1&w=2

Ted Ts'o took your position and Tejun Heo took mine.  But nobody 
mentioned the mirroring example, or even anything like it.

> > > Except the unregister path appears to assume that a valid block
> > > device available when it is unregistered.
> > 
> > It may very well be available during the unregistration procedure.  
> > There's nothing wrong with assuming it is -- if it isn't, I/O attempts 
> > will simply fail.
> 
> It's clear that it isn't available, and you're assuming that IO
> attempts are possible and that they will fail. If that assumption
> was always valid, then we wouldn't have got this bug report....

Not true.  This particular bug has nothing to do with device removal.  
It was caused by mount getting trapped in a loop (presumably while 
holding a lock).

> > No; a bad assumption would be if the code assumed the device was 
> > available _after_ the unregistration call had completed.
> 
> It's known to be unavaiable *during* the unregistration call, and
> that code is assuming it is available.  When a device is forcible
> unplugged from underenath an active filesytem, there is no guarantee
> that it can extract itself from the mess that this leaves behind,
> and assuming that it can is just wrong...

Filesystems _have_ to be able to extricate themselves from this sort 
of mess.  If they can't then they are broken, period.  See Greg KH's 
comment in the thread mentioned above.

Alan Stern

