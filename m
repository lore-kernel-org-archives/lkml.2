Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1HXWcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:32:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41297 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab1HXWcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:32:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=bbP7ogl1dxiQG4MXt/7ZGq/QhWu/9JZY9FjvdQD3IJ71ZUBHH2mk2Vvlo5QXdmLFJ
	l9/1ehAjbIJZ+Z34LSsLQ==
Date: Wed, 24 Aug 2011 15:31:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Josh Boyer <jwboyer@gmail.com>
cc: Dave Chinner <david@fromorbit.com>, Miles Lane <miles.lane@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.1.0-rc3 -- INFO: possible circular locking dependency
 detected
In-Reply-To: <CA+5PVA7fHAsSGFo4hcTtegT8a4K3xk=XTNYC7GzSYDbgRKc1ug@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1108241452120.2091@sister.anvils>
References: <CAHFgRy_7XQkoU3uY72Eve_X-FfXOuUm2Ydhyheo4bf53P3K=zQ@mail.gmail.com> <CA+5PVA47Pa14Sk5-VZuQhXk1db6KK13_3uSk1QMKVwsZyPmj_A@mail.gmail.com> <20110823114931.GC3162@dastard> <CA+5PVA4bLOSOQ=Pvt25xY=8L_b07XnM-8UetHOxnbtgtY0o4_Q@mail.gmail.com>
 <20110823130451.GD3162@dastard> <CA+5PVA7fHAsSGFo4hcTtegT8a4K3xk=XTNYC7GzSYDbgRKc1ug@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-838204144-1314225082=:2091"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-838204144-1314225082=:2091
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 23 Aug 2011, Josh Boyer wrote:
> On Tue, Aug 23, 2011 at 9:04 AM, Dave Chinner <david@fromorbit.com> wrote=
:
> > On Tue, Aug 23, 2011 at 07:59:20AM -0400, Josh Boyer wrote:
> >> On Tue, Aug 23, 2011 at 7:49 AM, Dave Chinner <david@fromorbit.com> wr=
ote:
> >> >> > =A0Possible unsafe locking scenario:
> >> >> >
> >> >> > =A0 =A0 =A0 CPU0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CPU1
> >> >> > =A0 =A0 =A0 ---- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0----
> >> >> > =A0lock(&mm->mmap_sem);
> >> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lock(=
&sb->s_type->i_mutex_key);
> >> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lock(=
&mm->mmap_sem);
> >> >> > =A0lock(&sb->s_type->i_mutex_key);
> >> >> >
> >> >> > =A0*** DEADLOCK ***
> >> >>
> >> >> This one was reported yesterday: https://lkml.org/lkml/2011/8/21/16=
3
> >> >> and we're hoping Ted (or someone else from the ext4 camp) can comme=
nt
> >> >> on why ext4_evict_inode is holding i_mutex.
> >> >
> >> > Actually, the problem has nothing to do with ext4. the problem is
> >> > that remove_vma() is holding the mmap_sem while calling fput(). The
> >> > correct locking order is i_mutex->mmap_sem, as documented in
> >> > mm/filemap.c:
> >> >
> >> > =A0* =A0->i_mutex =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (generic_file_=
buffered_write)
> >> > =A0* =A0 =A0->mmap_sem =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(fault_in_page=
s_readable->do_page_fault)
> >> >
> >> >
> >> > The way remove_vma() calls fput() also triggers lockdep reports in
> >> > XFS and it will do so with any filesystem that takes an inode
> >> > specific lock in it's evict() processing. IOWs, remove_vma() needs
> >> > fixing, not ext4....
> >>
> >> Er... ok. =A0So the remove_vma code hasn't changed since 2008. =A0We'r=
e
> >> only seeing this issue now because the debugging code has improved,
> >> or?
> >
> > The problem has been there since at least 2008. =A0Here's an early
> > XFS report from 2.6.24:
> >
> > http://oss.sgi.com/archives/xfs/2008-02/msg00931.html
> >
> > Here's an XFS report
> > to match the ext4 one in this thread from 2009:
> >
> > http://oss.sgi.com/archives/xfs/2009-03/msg00149.html
> >
> > You won't find reports much older than this - it only started to be
> > reported when lockdep support in XFS matured and it started to be
> > widely used....
> >
> >> At any rate, the proposed solution is to make remove_vma drop mmap_sem
> >> before calling fput, or make it not call fput, or?
> >
> > Ask the VM folk - this is the only response I can remember from them
> > is this:
> >
> > http://oss.sgi.com/archives/xfs/2009-03/msg00224.html
> >
> > Maybe now that ext4 is hitting the problem something will be done
> > about it...
>=20
> OK.  I've CC'd Andrew and Hugh, so maybe we can get a discussion going.

My first reaction would be that this is quite simply a filesystem bug.
Apparently a long-standing bug in the XFS case, but one in which ext4
has just now (3.1-rc) joined it.

The mm/fs locking hierarchy has been that way forever: mm does not assume
that the fs will not take any inode-specific lock in its fput(), but yes,
it does expect fput() not to take the i_mutex.

In this new ext4 case, it appears to be just an issue on final eviction
of the inode, which I think makes actual deadlock (when writing to file
needs to fault in a page from mm) impossible - we wouldn't be evicting
it if there were still references.  Just needs some lockdep notation?

Dropping mmap_sem while doing fput() in munmap() doesn't sound appealing
to me: although we have converted a number of paths to drop mmap_sem in
strategic places, getting back to the (possibly changed) vma sequence
afterwards is tiresome (when the munmap covers multiple vmas), and
instinct says that munmap() might be a more difficult case to get
right than most.  Leave the fput()s to a workqueue instead?

Hugh
--8323584-838204144-1314225082=:2091--
