Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab2LTXgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 18:36:36 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:59120 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352Ab2LTXg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 18:36:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsKAGCf01B5LG3x/2dsb2JhbABFt3SFexdzgh4BAQQBJxMcIwULCAMOCi4UJQMhE4gNBbhFFIxDhEMDlgqJToZ7gwg
Date: Fri, 21 Dec 2012 10:36:24 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: Are there u32 atomic bitops? (or dealing w/ i_flags)
Message-ID: <20121220233624.GX15182@dastard>
References: <CALCETrXs15M-cJRGD_R7fXBxOXR=Pyqsh2dVC78DgShxwn60nA@mail.gmail.com>
 <20121218015705.GH4939@ZenIV.linux.org.uk>
 <CALCETrUHF40CJYi1=aWpqhW9qkxUDQNt9LAAGoWA57YXowdr_w@mail.gmail.com>
 <20121218213043.GF15182@dastard>
 <CALCETrV9fEfTVbiSzai2dvk6MWwDhsD_nAKs7Z1JP0ZkF-eruw@mail.gmail.com>
 <20121220070323.GU15182@dastard>
 <CALCETrUxFHHVPO=EC0jmV9SSKJiOm-mc-xwsd6Ruk3p5nC4fFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUxFHHVPO=EC0jmV9SSKJiOm-mc-xwsd6Ruk3p5nC4fFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 12:05:09PM -0800, Andy Lutomirski wrote:
> On Wed, Dec 19, 2012 at 11:03 PM, Dave Chinner <david@fromorbit.com> wrote:
> start_this_handle jbd2__journal_start jbd2_journal_start
> ext4_journal_start_sb ext4_dirty_inode __mark_inode_dirty update_time
> file_update_time ext4_page_mkwrite do_wp_page handle_pte_fault
> handle_mm_fault

Yup, as I suspected. It's a filesystem specific problem.

> This is a showstopper for my software -- I'm running on a kernel with
> the call to file_update_time commented out.

Which means you are effectively running with O_CMTIME on all mmapped
files....

> >> Filesystems that haven't been converted can will continue to update
> >> times in ->page_mkwrite.
> >
> > You don't need to change this at all. If you have ext4
> > implement .update_timestamp to do whatever timestamp trickery you
> > want and avoid ext4 starting a new transaction in .dirty_inode for
> > pure timestamp updates, you can move the timestamp update into the
> > ext4 writeback path. The ext4 writeback path is already quite
> > special, so I'm sure people would welcome another weird behaviour
> > being added to it :)
> >
> > IOWs, what you want to do doesn't seem to require any changes to the
> > generic code.  Just make it do timestamp updates in a manner similar
> > to XFS and btrfs, and you can handle it all completely internally to
> > the filesystem...
> 
> Are XFS and btrfs really better?  XFS does:
> 
> 	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
> 	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
> 	if (error) {
> 		xfs_trans_cancel(tp, 0);
> 		return -error;
> 	}
> 
> 	xfs_ilock(ip, XFS_ILOCK_EXCL);
> 
> This looks like it could sleep in a couple of places.  I admit I
> haven't actually tried it.

It certainly can if there is no log space available, but that's a
filesystem specific problem, not a problem with the way the VFS does
timestamp updates.

Indeed, it was only recently we changed this code to use a
transaction, previously it was doing exactly what you are proposing
completely internally to XFS. i.e. it copied the timestamp and set a
dirty flag that then trigger the next transaction that dirtied the
inode or triggered inode writeback to copy the new timestamps into
the inode with a transaction.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
