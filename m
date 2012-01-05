Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab2AEPNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:13:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46285 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754399Ab2AEPNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:13:32 -0500
Date: Thu, 5 Jan 2012 10:13:31 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: "Theodore Ts'o" <tytso@mit.edu>, Tejun Heo <tj@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Revoking filesystems [was Re: Sysfs attributes racing with
 unregistration]
In-Reply-To: <m1boqietiv.fsf@fess.ebiederm.org>
Message-ID: <Pine.LNX.4.44L0.1201051001360.1434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jan 2012, Eric W. Biederman wrote:

> > Ted Ts'o has been talking about something similar but not the same -- a
> > way to revoke an entire filesystem.  For example, see commit
> > 7c2e70879fc0949b4220ee61b7c4553f6976a94d (ext4: add ext4-specific
> > kludge to avoid an oops after the disk disappears).
> >
> > The use case for that is obvious and widespread: Somebody yanks out a
> > USB drive without unmounting it first.
> 
> Agreed.  The best I have at the moment is a library that can wrap
> filesystem methods to implement the hotplug bits.
> 
> Do you know how hard it is to remove event up to the filesystem that
> sits on top of a block device?

I don't have a clear idea of what's involved (in particular, how to go
from a block_device structure to a mounted filesystem).  But the place
to do it would probably be block/genhd.c:invalidate_partition().  Ted
can tell you if there's a better alternative.

> Do you know how hard it is to detect at mount time if a block device
> might be hot-plugable?  We can always use a mount option here and
> make userspace figure it out, but being to have a good default would
> be nice.

I don't think it's possible to tell if a device is hot-unpluggable.  
For example, the device itself might not be removable from its parent, 
but the parent might be hot-unpluggable.  You'll probably have to 
assume that every device can potentially be unplugged, one way or 
another.

Also, even devices that aren't hot-unpluggable can fail.  The end 
result should be pretty much the same.

> If it isn't too hard to get the event up from the block device to the
> filesystem when the block device is uncermoniously removed I might just
> make the time to have hotunplug trigger a filesystem wide revoke on a
> filesystem like ext4.
> 
> In addition to sysfs we need the same logic in proc, sysctl, and uio.
> So it makes sense to move towards a common library that can do all of
> the hard bits.

Ted mentioned the need for a new "device removed" superblock method.  
Then each filesystem can add its own implementation as people get
around to it.

Alan Stern

