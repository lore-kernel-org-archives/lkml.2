Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab1HYADQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 20:03:16 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:44614 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915Ab1HYADP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 20:03:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuUCADmPVU55LIxDgWdsb2JhbABCqAAVAQEWJiWBQAEBBAEnCwEjIwULCAMYLhQlAyETG4dWBLl7DoY7BKQm
Date: Thu, 25 Aug 2011 10:03:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: Hugh Dickins <hughd@google.com>
Cc: Josh Boyer <jwboyer@gmail.com>, Miles Lane <miles.lane@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.1.0-rc3 -- INFO: possible circular locking dependency detected
Message-ID: <20110825000310.GI3162@dastard>
References: <CAHFgRy_7XQkoU3uY72Eve_X-FfXOuUm2Ydhyheo4bf53P3K=zQ@mail.gmail.com>
 <CA+5PVA47Pa14Sk5-VZuQhXk1db6KK13_3uSk1QMKVwsZyPmj_A@mail.gmail.com>
 <20110823114931.GC3162@dastard>
 <CA+5PVA4bLOSOQ=Pvt25xY=8L_b07XnM-8UetHOxnbtgtY0o4_Q@mail.gmail.com>
 <20110823130451.GD3162@dastard>
 <CA+5PVA7fHAsSGFo4hcTtegT8a4K3xk=XTNYC7GzSYDbgRKc1ug@mail.gmail.com>
 <alpine.LSU.2.00.1108241452120.2091@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.00.1108241452120.2091@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 03:31:14PM -0700, Hugh Dickins wrote:
> On Tue, 23 Aug 2011, Josh Boyer wrote:
> > On Tue, Aug 23, 2011 at 9:04 AM, Dave Chinner <david@fromorbit.com> wrote:
> > > On Tue, Aug 23, 2011 at 07:59:20AM -0400, Josh Boyer wrote:
> > >> On Tue, Aug 23, 2011 at 7:49 AM, Dave Chinner <david@fromorbit.com> wrote:
> > >> >> >  Possible unsafe locking scenario:
> > >> >> >
> > >> >> >       CPU0                    CPU1
> > >> >> >       ----                    ----
> > >> >> >  lock(&mm->mmap_sem);
> > >> >> >                               lock(&sb->s_type->i_mutex_key);
> > >> >> >                               lock(&mm->mmap_sem);
> > >> >> >  lock(&sb->s_type->i_mutex_key);
> > >> >> >
> > >> >> >  *** DEADLOCK ***
> > >> >>
> > >> >> This one was reported yesterday: https://lkml.org/lkml/2011/8/21/163
> > >> >> and we're hoping Ted (or someone else from the ext4 camp) can comment
> > >> >> on why ext4_evict_inode is holding i_mutex.
> > >> >
> > >> > Actually, the problem has nothing to do with ext4. the problem is
> > >> > that remove_vma() is holding the mmap_sem while calling fput(). The
> > >> > correct locking order is i_mutex->mmap_sem, as documented in
> > >> > mm/filemap.c:
> > >> >
> > >> >  *  ->i_mutex                   (generic_file_buffered_write)
> > >> >  *    ->mmap_sem                (fault_in_pages_readable->do_page_fault)
> > >> >
> > >> >
> > >> > The way remove_vma() calls fput() also triggers lockdep reports in
> > >> > XFS and it will do so with any filesystem that takes an inode
> > >> > specific lock in it's evict() processing. IOWs, remove_vma() needs
> > >> > fixing, not ext4....
> > >>
> > >> Er... ok.  So the remove_vma code hasn't changed since 2008.  We're
> > >> only seeing this issue now because the debugging code has improved,
> > >> or?
> > >
> > > The problem has been there since at least 2008.  Here's an early
> > > XFS report from 2.6.24:
> > >
> > > http://oss.sgi.com/archives/xfs/2008-02/msg00931.html
> > >
> > > Here's an XFS report
> > > to match the ext4 one in this thread from 2009:
> > >
> > > http://oss.sgi.com/archives/xfs/2009-03/msg00149.html
> > >
> > > You won't find reports much older than this - it only started to be
> > > reported when lockdep support in XFS matured and it started to be
> > > widely used....
> > >
> > >> At any rate, the proposed solution is to make remove_vma drop mmap_sem
> > >> before calling fput, or make it not call fput, or?
> > >
> > > Ask the VM folk - this is the only response I can remember from them
> > > is this:
> > >
> > > http://oss.sgi.com/archives/xfs/2009-03/msg00224.html
> > >
> > > Maybe now that ext4 is hitting the problem something will be done
> > > about it...
> > 
> > OK.  I've CC'd Andrew and Hugh, so maybe we can get a discussion going.
> 
> My first reaction would be that this is quite simply a filesystem bug.
> Apparently a long-standing bug in the XFS case, but one in which ext4
> has just now (3.1-rc) joined it.
> 
> The mm/fs locking hierarchy has been that way forever:

That doesn't make it right - the XFS people have been complaining
about this mmap_sem/fput problem for as long as I can remember.

> mm does not assume
> that the fs will not take any inode-specific lock in its fput(), but yes,
> it does expect fput() not to take the i_mutex.

I think that is a broken assumption. Looking at teh documentation
for the file operations, Documentation/filesystems/vfs.txt has this
comment:

	Again, all methods are called without any locks being held, unless
	otherwise noted.

And from Documentation/filesystems/Locking:

	locking rules:
		All may block except for ->setlease.
		No VFS locks held on entry except for ->setlease.

So given that fput() can call both f_ops->async and f_ops->release,
which according to the above documentation should be called without
any locks held and. That implies that fput() should not be called
with locks held.

There is nothing to say any of the file operations methods cannot
take i_mutex or other inode locks. The implication that they are
called without locks held is clear - it is supposed to be safe for
filesystems to take locks in these file operation methods.

And from mm/filemap.c where lock orders are defined:

 *  ->i_mutex                   (generic_file_buffered_write)
 *    ->mmap_sem                (fault_in_pages_readable->do_page_fault)

It's pretty clear that calling fput() with the mmap_sem held
violates this order....

Similarly, fput() calls dput(), which is how we're ending up in
.evict

> 
> In this new ext4 case, it appears to be just an issue on final eviction
> of the inode, which I think makes actual deadlock (when writing to file
> needs to fault in a page from mm) impossible - we wouldn't be evicting
> it if there were still references.  Just needs some lockdep notation?

For evict, that's necessary for the shrinkers not to throw lockdep
woarnings.

But that's not the only case that the mmap_sem/fput inversion can
trigger: .release is another. We've had to place try lock semantics
in the XFS code to avoid deadlocks there because inodes are not
being reclaimed when .release is called....

> Dropping mmap_sem while doing fput() in munmap() doesn't sound appealing
> to me: although we have converted a number of paths to drop mmap_sem in
> strategic places, getting back to the (possibly changed) vma sequence
> afterwards is tiresome (when the munmap covers multiple vmas), and
> instinct says that munmap() might be a more difficult case to get
> right than most.  Leave the fput()s to a workqueue instead?

Some kind of deferred processing is needed, I guess. I don't know
what is the best way to do it. perhaps an operation that will drop
all but the last filp reference in line, but push the last one to a
workqueue. eg. fput_background()?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
