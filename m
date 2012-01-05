Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab2AES2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:28:06 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:57038 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757793Ab2AES2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:28:05 -0500
Date: Thu, 5 Jan 2012 13:27:52 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with
 unregistration]
Message-ID: <20120105182752.GC26382@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Alan Stern <stern@rowland.harvard.edu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Tejun Heo <tj@kernel.org>,
	Kernel development list <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Kay Sievers <kay.sievers@vrfy.org>
References: <m1ehvecf23.fsf@fess.ebiederm.org>
 <Pine.LNX.4.44L0.1201051133490.1434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201051133490.1434-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 11:47:54AM -0500, Alan Stern wrote:
> > Well the choices are really:
> > a) On a block device hotunplug keep the device and have it simply report
> >    everything as errors, to the filesystem.  Maybe with a hint to the
> >    filesystem that something is wrong.
> > b) Have a filesystem revoke method so that we don't have to keep the
> >    unplugged block device structure around indefinitely.
> 
> When I asked Ted about this, he strongly indicated that he preferred 
> b).

Ideally, we should do both.  The block device should call a
notification function (probably run out of a workqueue context, to
avoid locking issues) which tells the file system, "the block device
is _gone_ and isn't coming back".  Any attempts to read or write to
the block device should return errors, since there maybe writeback
happening in the background while the file system is shutting down
file system mount.  Once the file system is done, it can all a
function which tells the block device layer that it's OK to release
the block device and its related structures.

In order for the file system to shut down the file system cleanly, it
will need to access VFS-level revoke functionality that replaces file
descriptors with ones that returns an error on reads and writes, and
which does the right thing with mmap's[1], etc.

So it's really more of a filesystem force-umount method.  I could
imagine that this could also be used to extend the functionality of
umount(2) so that the MNT_FORCE flag could be used with non-NFS file
systems as well as NFS file systems.

				- Ted

[1] Interesting question: do we convert an mmap region to an anonymous
region and perhaps notify the user out of band this has happened?  Or
do we just make the mapping disappear and nuke the process with a SEGV
if it attempts to access it?
