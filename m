Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab2AESir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:38:47 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41362
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753099Ab2AESiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:38:46 -0500
Date: Thu, 5 Jan 2012 13:38:32 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>, Alan Stern <stern@rowland.harvard.edu>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with
 unregistration]
Message-ID: <20120105183831.GA21565@infradead.org>
References: <m1ehvecf23.fsf@fess.ebiederm.org>
 <Pine.LNX.4.44L0.1201051133490.1434-100000@iolanthe.rowland.org>
 <20120105182752.GC26382@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105182752.GC26382@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 01:27:52PM -0500, Ted Ts'o wrote:
> Ideally, we should do both.  The block device should call a
> notification function (probably run out of a workqueue context, to
> avoid locking issues) which tells the file system, "the block device
> is _gone_ and isn't coming back".  Any attempts to read or write to
> the block device should return errors, since there maybe writeback
> happening in the background while the file system is shutting down
> file system mount.  Once the file system is done, it can all a
> function which tells the block device layer that it's OK to release
> the block device and its related structures.

FYI: we have all the functionality for that available in XFS and would
just need to wire it up.  It's also triggered if we get a write I/O
error for metadata (typically the log), so with a minim delay we
actually provide that behaviour already.

> In order for the file system to shut down the file system cleanly, it
> will need to access VFS-level revoke functionality that replaces file
> descriptors with ones that returns an error on reads and writes, and
> which does the right thing with mmap's[1], etc.

And that part is close to impossible to get right.

