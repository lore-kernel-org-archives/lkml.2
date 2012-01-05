Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab2AET2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:28:30 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:37989 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151Ab2AET23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:28:29 -0500
Date: Thu, 5 Jan 2012 14:28:22 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with
 unregistration]
Message-ID: <20120105192822.GD26382@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Kernel development list <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Kay Sievers <kay.sievers@vrfy.org>
References: <m1ehvecf23.fsf@fess.ebiederm.org>
 <Pine.LNX.4.44L0.1201051133490.1434-100000@iolanthe.rowland.org>
 <20120105182752.GC26382@thunk.org>
 <20120105183602.GE18486@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105183602.GE18486@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 10:36:02AM -0800, Tejun Heo wrote:
> Hello, Ted.
> 
> On Thu, Jan 05, 2012 at 01:27:52PM -0500, Ted Ts'o wrote:
> > So it's really more of a filesystem force-umount method.  I could
> > imagine that this could also be used to extend the functionality of
> > umount(2) so that the MNT_FORCE flag could be used with non-NFS file
> > systems as well as NFS file systems.
> 
> I think these are two separate mechanisms.  Filesystems need to be
> able to handle IO errors no matter what and underlying device going
> away is the same situation.  There's no reason to mix that with force
> unmount.  That's a separate feature and whether to force unmount
> filesystem on device removal or permanent failure is a policy decision
> which belongs to userland - ie. if such behavior is desired, it should
> be implemented via udev/udisk instead of hard coded logic in kernel.

I think it's needless complexity to loop this into userspace.  If the
block device is gone, it's *gone*.  What else could userspace do with
this information that block device has disappeared?  Right now, once
gone, it's never coming back.  Even if the luser plugs the USB device
back in, it's going to be coming back as a new block device node.

So we might as well automatically forcibly unmount the file system at
this point.  I can imagine sending an optional notification that such
a thing has happened, perhaps via a netlink socket, but why not have
the kernel do the right thing automatically?

> I don't know enough to decide whether such forced unmount is a useful
> feature tho.  It can be neat for development but is there any real
> necessity for the feature?

Well, if you want to complicate matters by having this go via a
notification up to userspace, and then have the userspace thoughtfully
consider (after looking up all sorts of complex rules stored in XML
files whose schema is documented nowhere but in the source code) that
the file system should go away because the block device has gone away,
the userspace code will then have to send a forced unmount.

The other use case would be a system administrator who doesn't want to
figure out which random shell is still cd'ed into a directory of a
file system he/she wants to unmount, he can still force the umount.
(Other Unix systems have had this feature in the past, and the result
is the same as what happens if you are cd'ed into a directory which is
later rmdir'ed.)  It's an ungraceful way of running things, but
sometimes it's the easist way to go.

     	   	       	  	    - Ted
