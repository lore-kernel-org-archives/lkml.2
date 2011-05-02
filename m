Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab1EBGPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 02:15:32 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:41995 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab1EBGPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 02:15:31 -0400
Date: Mon, 2 May 2011 08:15:28 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Dave Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
        xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
        Alex Elder <aelder@sgi.com>, Dave Chinner <dchinner@redhat.com>,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110502061528.GA22538@x4.trippels.de>
References: <20110423224403.5fd1136a@neptune.home>
 <20110427050850.GG12436@dastard>
 <20110427182622.05a068a2@neptune.home>
 <20110428194528.GA1627@x4.trippels.de>
 <20110429011929.GA13542@dastard>
 <20110429151841.GA893@x4.trippels.de>
 <20110429213524.449e003b@neptune.home>
 <20110430161810.6ccd2c99@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110430161810.6ccd2c99@neptune.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.04.30 at 16:18 +0200, Bruno Prémont wrote:
> On Fri, 29 April 2011 Bruno Prémont wrote:
> > On Fri, 29 April 2011 Markus Trippelsdorf wrote:
> > > On 2011.04.29 at 11:19 +1000, Dave Chinner wrote:
> > > > OK, so the common elements here appears to be root filesystems
> > > > with small log sizes, which means they are tail pushing all the
> > > > time metadata operations are in progress. Definitely seems like a
> > > > race in the AIL workqueue trigger mechanism. I'll see if I can
> > > > reproduce this and cook up a patch to fix it.
> > > 
> > > Hmm, I'm wondering if this issue is somehow related to the hrtimer bug,
> > > that Thomas Gleixner fixed yesterday:
> > > http://git.us.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=ce31332d3c77532d6ea97ddcb475a2b02dd358b4
> > > http://thread.gmane.org/gmane.linux.kernel.mm/61909/
> > > 
> > > It also looks similar to the issue that James Bottomley reported
> > > earlier: http://thread.gmane.org/gmane.linux.kernel.mm/62185/ 
> > 
> > I'm going to see, I've applied Thomas' fix on the box seeing XFS freeze (without
> > other changes to kernel).
> > Going to run that kernel for the week-end and beyond if it survives to see what
> > happens.
> 
> Happened again (after a few hours of uptime), so it definitely is not
> caused by hrtimer bug that Thomas Gleixner fixed.

I've enabled lock debugging and this is what happened after a few hours
uptime. (I can't tell if this is a false positive):

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.39-rc5-00130-g3fd9952 #10
-------------------------------------------------------
kio_file/7364 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#5/2){+.+...}, at: [<ffffffff81151e4e>] generic_file_splice_write+0xce/0x180

but task is already holding lock:
 (xfs_iolock_active){++++++}, at: [<ffffffff811d7d05>] xfs_ilock+0x125/0x1f0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (xfs_iolock_active){++++++}:
       [<ffffffff810ae8a2>] lock_acquire+0x92/0x1f0
       [<ffffffff8109d9bf>] down_write_nested+0x2f/0x60
       [<ffffffff811d7d05>] xfs_ilock+0x125/0x1f0
       [<ffffffff812061d6>] xfs_file_buffered_aio_write+0x66/0x290
       [<ffffffff81206561>] xfs_file_aio_write+0x161/0x300
       [<ffffffff811261f2>] do_sync_write+0xd2/0x110
       [<ffffffff811262df>] vfs_write+0xaf/0x160
       [<ffffffff8112646a>] sys_write+0x4a/0x90
       [<ffffffff8154cc6b>] system_call_fastpath+0x16/0x1b

-> #1 (&sb->s_type->i_mutex_key#5){+.+.+.}:
       [<ffffffff810ae8a2>] lock_acquire+0x92/0x1f0
       [<ffffffff81549981>] mutex_lock_nested+0x51/0x370
       [<ffffffff81135afd>] vfs_rename+0xed/0x420
       [<ffffffff81136037>] sys_renameat+0x207/0x230
       [<ffffffff8113607b>] sys_rename+0x1b/0x20
       [<ffffffff8154cc6b>] system_call_fastpath+0x16/0x1b

-> #0 (&sb->s_type->i_mutex_key#5/2){+.+...}:
       [<ffffffff810ac21f>] __lock_acquire+0x169f/0x1b90
       [<ffffffff810ae8a2>] lock_acquire+0x92/0x1f0
       [<ffffffff81549981>] mutex_lock_nested+0x51/0x370
       [<ffffffff81151e4e>] generic_file_splice_write+0xce/0x180
       [<ffffffff81205334>] xfs_file_splice_write+0xf4/0x250
       [<ffffffff8115024e>] do_splice_from+0x7e/0xb0
       [<ffffffff811502a0>] direct_splice_actor+0x20/0x30
       [<ffffffff81151fde>] splice_direct_to_actor+0xbe/0x1c0
       [<ffffffff81152158>] do_splice_direct+0x78/0x90
       [<ffffffff81125f72>] do_sendfile+0x182/0x1d0
       [<ffffffff81126f1a>] sys_sendfile64+0x5a/0xb0
       [<ffffffff8154cc6b>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

1 lock held by kio_file/7364:
 #0:  (xfs_iolock_active){++++++}, at: [<ffffffff811d7d05>] xfs_ilock+0x125/0x1f0

stack backtrace:
Pid: 7364, comm: kio_file Not tainted 2.6.39-rc5-00130-g3fd9952 #10
Call Trace:
 [<ffffffff81543f4c>] print_circular_bug+0xb8/0xc7
 [<ffffffff810ac21f>] __lock_acquire+0x169f/0x1b90
 [<ffffffff8115153d>] ? __generic_file_splice_read+0x1cd/0x5c0
 [<ffffffff810ae8a2>] lock_acquire+0x92/0x1f0
 [<ffffffff81151e4e>] ? generic_file_splice_write+0xce/0x180
 [<ffffffff8148de90>] ? sock_def_write_space+0x140/0x140
 [<ffffffff81549981>] mutex_lock_nested+0x51/0x370
 [<ffffffff81151e4e>] ? generic_file_splice_write+0xce/0x180
 [<ffffffff81151e4e>] generic_file_splice_write+0xce/0x180
 [<ffffffff81205334>] xfs_file_splice_write+0xf4/0x250
 [<ffffffff8120510f>] ? xfs_file_splice_read+0xef/0x220
 [<ffffffff8115024e>] do_splice_from+0x7e/0xb0
 [<ffffffff811502a0>] direct_splice_actor+0x20/0x30
 [<ffffffff81151fde>] splice_direct_to_actor+0xbe/0x1c0
 [<ffffffff81150280>] ? do_splice_from+0xb0/0xb0
 [<ffffffff81152158>] do_splice_direct+0x78/0x90
 [<ffffffff81125f72>] do_sendfile+0x182/0x1d0
 [<ffffffff81126f1a>] sys_sendfile64+0x5a/0xb0
 [<ffffffff8154cc6b>] system_call_fastpath+0x16/0x1b


-- 
Markus
