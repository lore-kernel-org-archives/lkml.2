Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab2GPCC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 22:02:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36778 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751716Ab2GPCCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 22:02:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+27P1QZX62eKzRuR54OP7Z5zfVVE37DYFfHMEJ3o
	YZUKiB6o3sljEJ
Message-ID: <1342404140.7659.27.camel@marge.simpson.net>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
From: Mike Galbraith <efault@gmx.de>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "Chris L. Mason" <clmason@fusionio.com>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 16 Jul 2012 04:02:20 +0200
In-Reply-To: <20120715175612.GF25961@shiny.int.fusionio.com>
References: <1342072060.7338.102.camel@marge.simpson.net>
	 <20120713125043.GH30128@shiny> <1342260883.7368.30.camel@marge.simpson.net>
	 <20120715175612.GF25961@shiny.int.fusionio.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-15 at 13:56 -0400, Chris Mason wrote: 
> On Sat, Jul 14, 2012 at 04:14:43AM -0600, Mike Galbraith wrote:
> > On Fri, 2012-07-13 at 08:50 -0400, Chris Mason wrote: 
> > > On Wed, Jul 11, 2012 at 11:47:40PM -0600, Mike Galbraith wrote:
> > > > Greetings,
> > > 
> > > [ deadlocks with btrfs and the recent RT kernels ]
> > > 
> > > I talked with Thomas about this and I think the problem is the
> > > single-reader nature of the RW rwlocks.  The lockdep report below
> > > mentions that btrfs is calling:
> > > 
> > > > [  692.963099]  [<ffffffff811fabd2>] btrfs_clear_path_blocking+0x32/0x70
> > > 
> > > In this case, the task has a number of blocking read locks on the btrfs buffers,
> > > and we're trying to turn them back into spinning read locks.  Even
> > > though btrfs is taking the read rwlock, it doesn't think of this as a new
> > > lock operation because we were blocking out new writers.
> > > 
> > > If the second task has taken the spinning read lock, it is going to
> > > prevent that clear_path_blocking operation from progressing, even though
> > > it would have worked on a non-RT kernel.
> > > 
> > > The solution should be to make the blocking read locks in btrfs honor the
> > > single-reader semantics.  This means not allowing more than one blocking
> > > reader and not allowing a spinning reader when there is a blocking
> > > reader.  Strictly speaking btrfs shouldn't need recursive readers on a
> > > single lock, so I wouldn't worry about that part.
> > > 
> > > There is also a chunk of code in btrfs_clear_path_blocking that makes
> > > sure to strictly honor top down locking order during the conversion.  It
> > > only does this when lockdep is enabled because in non-RT kernels we
> > > don't need to worry about it.  For RT we'll want to enable that as well.
> > > 
> > > I'll give this a shot later today.
> > 
> > I took a poke at it.  Did I do something similar to what you had in
> > mind, or just hide behind performance stealing paranoid trylock loops?
> > Box survived 1000 x xfstests 006 and dbench [-s] massive right off the
> > bat, so it gets posted despite skepticism.
> 
> Great, thanks!  I got stuck in bug land on Friday.  You mentioned
> performance problems earlier on Saturday, did this improve performance?

Yeah, the read_trylock() seems to improve throughput.  That's not
heavily tested, but it certainly looks like it does.  No idea why.

WRT performance, dbench isn't thrilled, but btrfs seems to work just
fine for my routine usage, and spinning rust bucket is being all it can
be.  I hope I don't have to care overly much about dbench's opinon.  It
doesn't make happy multi-thread numbers with btrfs, but those numbers
suddenly look great if you rebase relative to xfs -rt throughput :)

> One other question:
> 
> >  again:
> > +#ifdef CONFIG_PREEMPT_RT_BASE
> > +	while (atomic_read(&eb->blocking_readers))
> > +		cpu_chill();
> > +	while(!read_trylock(&eb->lock))
> > +		cpu_chill();
> > +	if (atomic_read(&eb->blocking_readers)) {
> > +		read_unlock(&eb->lock);
> > +		goto again;
> > +	}
> 
> Why use read_trylock() in a loop instead of just trying to take the
> lock?  Is this an RTism or are there other reasons?

First stab paranoia.  It worked, so I removed it.  It still worked but
lost throughput, removed all my bits leaving only the lockdep bits, it
still worked.

-Mike

