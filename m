Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825Ab2AEQr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:47:56 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46441 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964772Ab2AEQry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:47:54 -0500
Date: Thu, 5 Jan 2012 11:47:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Tejun Heo <tj@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with
 unregistration]
In-Reply-To: <m1ehvecf23.fsf@fess.ebiederm.org>
Message-ID: <Pine.LNX.4.44L0.1201051133490.1434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jan 2012, Eric W. Biederman wrote:

> > Ummm.... I could be missing something but filesystems need to be able
> > to deal with partial device failures (ie. some block can't be read)
> > and hot-unplug or handling full failure is a logical extension of
> > that.  That's how it already works, so I don't really think that is a
> > particularly good application for the revoke mechanism.
> 
> Well the choices are really:
> a) On a block device hotunplug keep the device and have it simply report
>    everything as errors, to the filesystem.  Maybe with a hint to the
>    filesystem that something is wrong.
> b) Have a filesystem revoke method so that we don't have to keep the
>    unplugged block device structure around indefinitely.

When I asked Ted about this, he strongly indicated that he preferred 
b).

> It seems clear that we are neither doing (a) or (b) which results in
> periodic and spectacular failures when block devices are unplugged,
> because we try and access block devices that no longer exist.

Actually we are doing a).  But we aren't doing it well enough.

One problem (which was reported by a user last spring) is that
del_gendisk() calls device_del() for the disk and bdi_unregister() for
the disk's backing_dev_info structure.  Now, del_gendisk will leave the
data structure in memory until the disk's refcount drops to 0, but
bdi_unregister ignores refcounts and simply erases the bdi->dev
pointer.  Once this happens, any attempt to call mark_buffer_dirty()
(for example, by ext4_commit_super) will cause an oops.

Alan Stern

