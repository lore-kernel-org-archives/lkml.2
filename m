Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1HWNFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:05:10 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:19263 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133Ab1HWNFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:05:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkDACKiU055LIxDgWdsb2JhbABBqBsVAQEWJiWBQAEBBAEnCwEjIwULCAMOCi4UJQMhExuHVgS5ag6FW18EpCU
Date: Tue, 23 Aug 2011 23:04:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: 3.1.0-rc3 -- INFO: possible circular locking dependency detected
Message-ID: <20110823130451.GD3162@dastard>
References: <CAHFgRy_7XQkoU3uY72Eve_X-FfXOuUm2Ydhyheo4bf53P3K=zQ@mail.gmail.com>
 <CA+5PVA47Pa14Sk5-VZuQhXk1db6KK13_3uSk1QMKVwsZyPmj_A@mail.gmail.com>
 <20110823114931.GC3162@dastard>
 <CA+5PVA4bLOSOQ=Pvt25xY=8L_b07XnM-8UetHOxnbtgtY0o4_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+5PVA4bLOSOQ=Pvt25xY=8L_b07XnM-8UetHOxnbtgtY0o4_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 07:59:20AM -0400, Josh Boyer wrote:
> On Tue, Aug 23, 2011 at 7:49 AM, Dave Chinner <david@fromorbit.com> wrote:
> >> >  Possible unsafe locking scenario:
> >> >
> >> >       CPU0                    CPU1
> >> >       ----                    ----
> >> >  lock(&mm->mmap_sem);
> >> >                               lock(&sb->s_type->i_mutex_key);
> >> >                               lock(&mm->mmap_sem);
> >> >  lock(&sb->s_type->i_mutex_key);
> >> >
> >> >  *** DEADLOCK ***
> >>
> >> This one was reported yesterday: https://lkml.org/lkml/2011/8/21/163
> >> and we're hoping Ted (or someone else from the ext4 camp) can comment
> >> on why ext4_evict_inode is holding i_mutex.
> >
> > Actually, the problem has nothing to do with ext4. the problem is
> > that remove_vma() is holding the mmap_sem while calling fput(). The
> > correct locking order is i_mutex->mmap_sem, as documented in
> > mm/filemap.c:
> >
> >  *  ->i_mutex                   (generic_file_buffered_write)
> >  *    ->mmap_sem                (fault_in_pages_readable->do_page_fault)
> >
> >
> > The way remove_vma() calls fput() also triggers lockdep reports in
> > XFS and it will do so with any filesystem that takes an inode
> > specific lock in it's evict() processing. IOWs, remove_vma() needs
> > fixing, not ext4....
> 
> Er... ok.  So the remove_vma code hasn't changed since 2008.  We're
> only seeing this issue now because the debugging code has improved,
> or?

The problem has been there since at least 2008.  Here's an early
XFS report from 2.6.24:

http://oss.sgi.com/archives/xfs/2008-02/msg00931.html

Here's an XFS report
to match the ext4 one in this thread from 2009:

http://oss.sgi.com/archives/xfs/2009-03/msg00149.html

You won't find reports much older than this - it only started to be
reported when lockdep support in XFS matured and it started to be
widely used....

> At any rate, the proposed solution is to make remove_vma drop mmap_sem
> before calling fput, or make it not call fput, or?

Ask the VM folk - this is the only response I can remember from them
is this:

http://oss.sgi.com/archives/xfs/2009-03/msg00224.html

Maybe now that ext4 is hitting the problem something will be done
about it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
