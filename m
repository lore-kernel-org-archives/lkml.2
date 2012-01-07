Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2AJGaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 01:30:25 -0500
Received: from mail4.comsite.net ([205.238.176.238]:14275 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab2AJGaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 01:30:24 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
To: "Ted Ts'o" <tytso@mit.edu>
Cc: <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing withunregistration]
From: Milton Miller <miltonm@bga.com>
Date: Sat, 07 Jan 2012 15:01:39 -0600
X-Mail-Agent: vi
Message-Id: <delay-force-umount@mdm.bga.com>
In-Reply-To: <20120105192822.GD26382@thunk.org>
References: <20120105192822.GD26382@thunk.org>
	<Pine.LNX.4.44L0.1201051133490.1434-100000@iolanthe.rowland.org>
	<20120105182752.GC26382@thunk.org>
	<20120105183602.GE18486@google.com>
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resending with better headers]

On Thu Jan 05 2012 about 14:28:28 EST, Ted Ts'o wrote:
> On Thu, Jan 05, 2012 at 10:36:02AM -0800, Tejun Heo wrote:
> > Hello, Ted.
> >
> > On Thu, Jan 05, 2012 at 01:27:52PM -0500, Ted Ts'o wrote:
> > > So it's really more of a filesystem force-umount method. I could
> > > imagine that this could also be used to extend the functionality of
> > > umount(2) so that the MNT_FORCE flag could be used with non-NFS file
> > > systems as well as NFS file systems.
> >
> > I think these are two separate mechanisms. Filesystems need to be
> > able to handle IO errors no matter what and underlying device going
> > away is the same situation. There's no reason to mix that with force
> > unmount. That's a separate feature and whether to force unmount
> > filesystem on device removal or permanent failure is a policy decision
> > which belongs to userland - ie. if such behavior is desired, it should
> > be implemented via udev/udisk instead of hard coded logic in kernel.
> 
> I think it's needless complexity to loop this into userspace. If the
> block device is gone, it's *gone*. What else could userspace do with
> this information that block device has disappeared? Right now, once
> gone, it's never coming back. Even if the luser plugs the USB device
> back in, it's going to be coming back as a new block device node.


While user space has lost the ability to read that fs, there is lots
that can continue to work, espically if the system is not under memory
pressure.

First of all, what if the process I really care about is in a chroot
on another file system that was mounted under the failed filesystem?

I don't want the kernel killing my job and leaving a partial file on
some other file system just because some other disk went offline.

Second, as long as the file is cached in memory, I might be able
to use that busybox that is cached to shutdown my system or mount
the usb drive after it comes back as a new location, as long
as there isn't memory pressure.

> 
> So we might as well automatically forcibly unmount the file system at
> this point. I can imagine sending an optional notification that such
> a thing has happened, perhaps via a netlink socket, but why not have
> the kernel do the right thing automatically?
> 
> > I don't know enough to decide whether such forced unmount is a useful
> > feature tho. It can be neat for development but is there any real
> > necessity for the feature?
> 
> Well, if you want to complicate matters by having this go via a
> notification up to userspace, and then have the userspace thoughtfully
> consider (after looking up all sorts of complex rules stored in XML
> files whose schema is documented nowhere but in the source code) that
> the file system should go away because the block device has gone away,
> the userspace code will then have to send a forced unmount.
> 
> The other use case would be a system administrator who doesn't want to
> figure out which random shell is still cd'ed into a directory of a
> file system he/she wants to unmount, he can still force the umount.
> (Other Unix systems have had this feature in the past, and the result
> is the same as what happens if you are cd'ed into a directory which is
> later rmdir'ed.) It's an ungraceful way of running things, but
> sometimes it's the easist way to go.
> 
> - Ted

I can see something like this as an assist to userspace, but don't
forget that mounts are a tree.

milton
