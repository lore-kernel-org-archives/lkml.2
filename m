Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab2AEUwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:52:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37847 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab2AEUwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:52:16 -0500
Date: Thu, 5 Jan 2012 12:52:11 -0800
From: Tejun Heo <tj@kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with
 unregistration]
Message-ID: <20120105205211.GA2934@google.com>
References: <m1ehvecf23.fsf@fess.ebiederm.org>
 <Pine.LNX.4.44L0.1201051133490.1434-100000@iolanthe.rowland.org>
 <20120105182752.GC26382@thunk.org>
 <20120105183602.GE18486@google.com>
 <20120105192822.GD26382@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105192822.GD26382@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 05, 2012 at 02:28:22PM -0500, Ted Ts'o wrote:
> > I think these are two separate mechanisms.  Filesystems need to be
> > able to handle IO errors no matter what and underlying device going
> > away is the same situation.  There's no reason to mix that with force
> > unmount.  That's a separate feature and whether to force unmount
> > filesystem on device removal or permanent failure is a policy decision
> > which belongs to userland - ie. if such behavior is desired, it should
> > be implemented via udev/udisk instead of hard coded logic in kernel.
> 
> I think it's needless complexity to loop this into userspace.  If the
> block device is gone, it's *gone*.  What else could userspace do with
> this information that block device has disappeared?  Right now, once
> gone, it's never coming back.  Even if the luser plugs the USB device
> back in, it's going to be coming back as a new block device node.
> 
> So we might as well automatically forcibly unmount the file system at
> this point.  I can imagine sending an optional notification that such
> a thing has happened, perhaps via a netlink socket, but why not have
> the kernel do the right thing automatically?

* If this was the one method to deal with hotunplug, sure, but it's
  not.  We already have (supposedly) working failure mode for hot
  device removal.

* Any modern linux distro already has all the infrastructure to handle
  this.  You can't handle hotplug without userland provided poicies
  and the same mechanism is used for hotunplugging too, *today*.  If
  force umount is decided to be the action to take on block device
  removal, that would be several line changes in userland.  Userland
  is already responsible for taking actions for those events.

* Such automation might look like a good idea now but we really don't
  know how it would end up in the longer run or for different use case
  scenarios.  I think a good example of this is the cdrom driver.  It
  implents tons of automatic behaviors, and then had to be augmented
  with ioctls to turn on and off them as they no longer fit new
  hardware, new userland behavior and changing user expectations.

So, regardless of whether adding revoking is a good idea or not, I
believe that force umount should be a separate thing from internal
block error handling.

> The other use case would be a system administrator who doesn't want to
> figure out which random shell is still cd'ed into a directory of a
> file system he/she wants to unmount, he can still force the umount.
> (Other Unix systems have had this feature in the past, and the result
> is the same as what happens if you are cd'ed into a directory which is
> later rmdir'ed.)  It's an ungraceful way of running things, but
> sometimes it's the easist way to go.

More importantly, I can't really see valid use cases other than
scenarios like the above for using revocation for usual hot unplug.
For most users, it wouldn't matter one way or the other.  It's not
like sync + lazy umount can't achieve (note that all the desktop stuff
knows about "filesystem is going away" and will gracefully step aside)
most of forced umount anyway.  It could be nice to cli aficionados or
grumpy admins but for the vast majority of userbase, it just wouldn't
matter.  Given that, I'm not convinced this is a worthwhile thing to
have.

Thanks.

-- 
tejun
