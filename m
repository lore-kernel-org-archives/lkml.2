Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab2AFGZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 01:25:37 -0500
Received: from lo.gmane.org ([80.91.229.12]:42935 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab2AFGZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 01:25:36 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with
 unregistration]
Date: Fri, 6 Jan 2012 12:25:15 +0600
Message-ID: <20120106122515.60e7a9aa@home>
References: <m1ehvecf23.fsf@fess.ebiederm.org>
	<Pine.LNX.4.44L0.1201051133490.1434-100000@iolanthe.rowland.org>
	<20120105182752.GC26382@thunk.org>
	<20120105183602.GE18486@google.com>
	<20120105192822.GD26382@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 31.162.102.54
In-Reply-To: <20120105192822.GD26382@thunk.org>
X-Newsreader: Claws Mail 3.7.10 (GTK+ 2.24.5; i686-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Ts'o <tytso@mit.edu> wrote:

> On Thu, Jan 05, 2012 at 10:36:02AM -0800, Tejun Heo wrote:
> > Hello, Ted.
> > 
> > On Thu, Jan 05, 2012 at 01:27:52PM -0500, Ted Ts'o wrote:
> > > So it's really more of a filesystem force-umount method.  I could
> > > imagine that this could also be used to extend the functionality
> > > of umount(2) so that the MNT_FORCE flag could be used with
> > > non-NFS file systems as well as NFS file systems.
> > 
> > I think these are two separate mechanisms.  Filesystems need to be
> > able to handle IO errors no matter what and underlying device going
> > away is the same situation.  There's no reason to mix that with
> > force unmount.  That's a separate feature and whether to force
> > unmount filesystem on device removal or permanent failure is a
> > policy decision which belongs to userland - ie. if such behavior is
> > desired, it should be implemented via udev/udisk instead of hard
> > coded logic in kernel.
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

+1, but with a different motivation. It just has to be done in the
kernel, because the userspace does not have all the needed information
to do it properly. Here are some testcases to think of, but, honestly,
I have tested only the first one and consider that it is sufficient to
prove my point.

Testcase 1: lazy unmount in progress. Plug in your USB flash drive,
mount it (or let it be automounted, say, in /media/DEVICE), open two
shells. In the first one, cd /media/DEVICE, and, after that, in the
second one, umount -l /media/DEVICE. Now look at /proc/mounts in the
second shell - there is no trace of your flash drive, so how would your
userspace guess that /media/DEVICE has to be force-unmounted if you
unplug the device now?

Testcase 2: mount namespaces. Same issue - are you going to traverse
all of /proc/???/mounts files, unscalably?

Testcase 3 (unsure): a filesystem bind-mounted several times on
different directories. What is the correct order of unmounting?

OTOH, I won't be surprised if anyone finds a case that clearly shows
that it cannot be done correctly in the kernel, either (and actually
want you to think about it). In that case, we are screwed :( Here are
some ideas for someone else to investigate if they are a problem:

1) Strange DM mappings on top of the device (LUKS?)
2) Something else mounted in /media/DEVICE/somedir - what to do with it?

-- 
Alexander E. Patrakov

