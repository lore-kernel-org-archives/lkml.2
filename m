Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab3AHSwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:52:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58455 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab3AHSwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:52:09 -0500
Date: Tue, 8 Jan 2013 18:52:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: mtk.manpages@gmail.com, Mike Frysinger <vapier@gentoo.org>,
        linux-man@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        lkml <linux-kernel@vger.kernel.org>, pschiffe@redhat.com
Subject: Re: [PATCH] open(2): document O_PATH
Message-ID: <20130108185202.GA22857@ZenIV.linux.org.uk>
References: <1335669917-23970-1-git-send-email-vapier@gentoo.org>
 <CAKgNAkgykZJV59WJXW9c9gVwXhn=WNYKxo_W1GM7ocHEEFqEXg@mail.gmail.com>
 <877gwxacti.fsf@skywalker.in.ibm.com>
 <CAKgNAkiRH8p=Dp1tqkb3D9oRVCOSnj2bofgFN5x2svntN7vtPg@mail.gmail.com>
 <87bom5xswc.fsf@skywalker.in.ibm.com>
 <20120503141156.GP6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503141156.GP6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 03:11:56PM +0100, Al Viro wrote:
> On Thu, May 03, 2012 at 07:34:35PM +0530, Aneesh Kumar K.V wrote:
> 
> > I looked at dnotify_flush, they remove markers on an inode.
> > But then it also checks for filp to match. So I am not sure
> > whether skipping dnotify_flush for O_PATH descriptor have any impact. We
> > can't use O_PATH descriptor for dnotify fcntl any way. So in
> > dnotify_flush we will not match the filp.
> > 
> > Viro,
> > 
> > Any reason why we skip dnotify_flush  ?
> 
> See your last sentence above - why bother finding the mark, scanning the
> list, etc. when we know that there won't be any matches?

[Apologies for replying to the wrong posting, but this is the closest thing
thread-wise to what I wanted to reply to that I've got sitting in my mailbox]

The rules are:
	* syscalls acting purely on descriptor level are allowed - close(),
dup(), dup2(), dup3(), fcntl(F_DUPFD{,_CLOEXEC}), fcntl(F_[SG]ETFD),
fcntl(F_GETFL), passing descriptors in SCM_RIGHTS datagrams)
	* syscalls using the descriptor just to indicate a location in
the tree - *at() family, fchdir(), fstat()
The list might get expanded - for example, fstatfs() arguably belongs to the
second group.  The approach had been conservative - the second group gets
expanded on per-case basis.  E.g. anything requiring the file to have
been opened for write is *not* a candidate, so it really has to be reviewed
separately for each syscall of that sort.

As far as dnotify and POSIX locks go, close() (and replacing dup2(), etc.)
are irrelevant - the rules are exactly as usual.  All dnotify watches or
POSIX locks associated with that opened file get evicted; it's just that
there is no way to *set* them on O_PATH descriptors in the first place.
We might eventually allow fcntl(F_NOTIFY) on them, but I'm not sure there's
any good reason to do so; allowing to use them for setting POSIX locks is
almost certainly a bad idea wrt security.

The test in filp_close() is just an optimization - if/when we allow F_NOTIFY
on O_PATH descriptors, the same commit will need to make the call of
dnotify_flush() in filp_open() unconditional.  All there is to it...
