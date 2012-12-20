Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab2LTUFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 15:05:37 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:65363 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2LTUFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 15:05:32 -0500
MIME-Version: 1.0
In-Reply-To: <20121220070323.GU15182@dastard>
References: <CALCETrXs15M-cJRGD_R7fXBxOXR=Pyqsh2dVC78DgShxwn60nA@mail.gmail.com>
 <20121218015705.GH4939@ZenIV.linux.org.uk> <CALCETrUHF40CJYi1=aWpqhW9qkxUDQNt9LAAGoWA57YXowdr_w@mail.gmail.com>
 <20121218213043.GF15182@dastard> <CALCETrV9fEfTVbiSzai2dvk6MWwDhsD_nAKs7Z1JP0ZkF-eruw@mail.gmail.com>
 <20121220070323.GU15182@dastard>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 20 Dec 2012 12:05:09 -0800
Message-ID: <CALCETrUxFHHVPO=EC0jmV9SSKJiOm-mc-xwsd6Ruk3p5nC4fFQ@mail.gmail.com>
Subject: Re: Are there u32 atomic bitops? (or dealing w/ i_flags)
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 11:03 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> The fact you are conerned about this function tells me something
> important - that you aren't having problems with i_mutex (show me
> where i_mutex is taken on the page_mkwrite path ;), but you are
> having latency problems with the ext4 .dirty_inode method starting a
> new transaction when it is called from mark_inode_dirty_sync().
>
> So, a filesystem specific problem, perhaps?

i_mutex isn't involved.  On ext4, it looks like this (from latencytop):

start_this_handle jbd2__journal_start jbd2_journal_start
ext4_journal_start_sb ext4_dirty_inode __mark_inode_dirty update_time
file_update_time ext4_page_mkwrite do_wp_page handle_pte_fault
handle_mm_fault

This is a showstopper for my software -- I'm running on a kernel with
the call to file_update_time commented out.

>
>> Filesystems that haven't been converted can will continue to update
>> times in ->page_mkwrite.
>
> You don't need to change this at all. If you have ext4
> implement .update_timestamp to do whatever timestamp trickery you
> want and avoid ext4 starting a new transaction in .dirty_inode for
> pure timestamp updates, you can move the timestamp update into the
> ext4 writeback path. The ext4 writeback path is already quite
> special, so I'm sure people would welcome another weird behaviour
> being added to it :)
>
> IOWs, what you want to do doesn't seem to require any changes to the
> generic code.  Just make it do timestamp updates in a manner similar
> to XFS and btrfs, and you can handle it all completely internally to
> the filesystem...

Are XFS and btrfs really better?  XFS does:

	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
	if (error) {
		xfs_trans_cancel(tp, 0);
		return -error;
	}

	xfs_ilock(ip, XFS_ILOCK_EXCL);

This looks like it could sleep in a couple of places.  I admit I
haven't actually tried it.


In any case, I have an alternative approach that I'm currently playing
with.  If it survives a bit of testing, I'll send patches.

--Andy
