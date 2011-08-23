Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1HWLtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 07:49:41 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:2408 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706Ab1HWLtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 07:49:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkDAKKQU055LIxDgWdsb2JhbABBqBsVAQEWJiWBQAEBBScLASMjEAgDDgouFA0YAyETh3W5Lw6FW18EnRCHFQ
Date: Tue, 23 Aug 2011 21:49:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: 3.1.0-rc3 -- INFO: possible circular locking dependency detected
Message-ID: <20110823114931.GC3162@dastard>
References: <CAHFgRy_7XQkoU3uY72Eve_X-FfXOuUm2Ydhyheo4bf53P3K=zQ@mail.gmail.com>
 <CA+5PVA47Pa14Sk5-VZuQhXk1db6KK13_3uSk1QMKVwsZyPmj_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+5PVA47Pa14Sk5-VZuQhXk1db6KK13_3uSk1QMKVwsZyPmj_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 07:35:00AM -0400, Josh Boyer wrote:
> On Tue, Aug 23, 2011 at 12:39 AM, Miles Lane <miles.lane@gmail.com> wrote:
> > [ INFO: possible circular locking dependency detected ]
> > 3.1.0-rc3 #2
> > -------------------------------------------------------
> > dconf-service/1836 is trying to acquire lock:
> >  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<ffffffff8116df1a>]
> > ext4_evict_inode+0x88/0x32b
> >
> >  but task is already holding lock:
> >  (&mm->mmap_sem){++++++}, at: [<ffffffff810d4393>] sys_munmap+0x36/0x5b
> >
> > which lock already depends on the new lock.
> >
> > the existing dependency chain (in reverse order) is:
> >
> > -> #1 (&mm->mmap_sem){++++++}:
> >       [<ffffffff8106933a>] lock_acquire+0x129/0x14e
> >       [<ffffffff810cddbd>] might_fault+0x68/0x8b
> >       [<ffffffff810fcf5e>] filldir+0x6a/0xc2
> >       [<ffffffff811651a1>] call_filldir+0x91/0xb8
> >       [<ffffffff811654bf>] ext4_readdir+0x1af/0x510
> >       [<ffffffff810fd1a4>] vfs_readdir+0x76/0xac
> >       [<ffffffff810fd2b6>] sys_getdents+0x79/0xc9
> >       [<ffffffff814162fb>] system_call_fastpath+0x16/0x1b
> >
> > -> #0 (&sb->s_type->i_mutex_key#12){+.+.+.}:
> >       [<ffffffff81068b10>] __lock_acquire+0xa5e/0xd52
> >       [<ffffffff8106933a>] lock_acquire+0x129/0x14e
> >       [<ffffffff8140f1a2>] __mutex_lock_common+0x64/0x413
> >       [<ffffffff8140f5b0>] mutex_lock_nested+0x16/0x18
> >       [<ffffffff8116df1a>] ext4_evict_inode+0x88/0x32b
> >       [<ffffffff81102d8a>] evict+0x94/0x14e
> >       [<ffffffff81102fd0>] iput+0x18c/0x195
> >       [<ffffffff810ffdd4>] dentry_kill+0x11e/0x140
> >       [<ffffffff8110019b>] dput+0xd4/0xe4
> >       [<ffffffff810efac3>] fput+0x1a5/0x1bd
> >       [<ffffffff810d3214>] remove_vma+0x37/0x5f
> >       [<ffffffff810d4239>] do_munmap+0x2ed/0x306
> >       [<ffffffff810d43a1>] sys_munmap+0x44/0x5b
> >       [<ffffffff814162fb>] system_call_fastpath+0x16/0x1b
> >
> > other info that might help us debug this:
> >
> >  Possible unsafe locking scenario:
> >
> >       CPU0                    CPU1
> >       ----                    ----
> >  lock(&mm->mmap_sem);
> >                               lock(&sb->s_type->i_mutex_key);
> >                               lock(&mm->mmap_sem);
> >  lock(&sb->s_type->i_mutex_key);
> >
> >  *** DEADLOCK ***
> 
> This one was reported yesterday: https://lkml.org/lkml/2011/8/21/163
> and we're hoping Ted (or someone else from the ext4 camp) can comment
> on why ext4_evict_inode is holding i_mutex.

Actually, the problem has nothing to do with ext4. the problem is
that remove_vma() is holding the mmap_sem while calling fput(). The
correct locking order is i_mutex->mmap_sem, as documented in
mm/filemap.c:

 *  ->i_mutex                   (generic_file_buffered_write)
 *    ->mmap_sem	        (fault_in_pages_readable->do_page_fault)


The way remove_vma() calls fput() also triggers lockdep reports in
XFS and it will do so with any filesystem that takes an inode
specific lock in it's evict() processing. IOWs, remove_vma() needs
fixing, not ext4....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
