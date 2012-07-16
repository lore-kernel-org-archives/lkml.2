Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2GPPnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:43:10 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:36617 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab2GPPnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:43:07 -0400
X-ASG-Debug-ID: 1342453386-03d6a50cb61b08a0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Mon, 16 Jul 2012 11:43:04 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Mike Galbraith <efault@gmx.de>
CC: "Chris L. Mason" <clmason@fusionio.com>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
Message-ID: <20120716154304.GG25961@shiny.int.fusionio.com>
X-ASG-Orig-Subj: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Mike Galbraith <efault@gmx.de>,
	"Chris L. Mason" <clmason@fusionio.com>,
	"linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>
References: <1342072060.7338.102.camel@marge.simpson.net>
 <20120713125043.GH30128@shiny>
 <1342260883.7368.30.camel@marge.simpson.net>
 <1342436144.7659.58.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1342436144.7659.58.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1342453386
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0026 1.0000 -2.0042
X-Barracuda-Spam-Score: -1.40
X-Barracuda-Spam-Status: No, SCORE=-1.40 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC5_SA210e, MARKETING_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.102875
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 MARKETING_SUBJECT      Subject contains popular marketing words
	0.00 BSF_SC5_SA210e         Custom Rule SA210e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 04:55:44AM -0600, Mike Galbraith wrote:
> On Sat, 2012-07-14 at 12:14 +0200, Mike Galbraith wrote: 
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
> Seems btrfs isn't entirely convinced either.
> 
> [ 2292.336229] use_block_rsv: 1810 callbacks suppressed
> [ 2292.336231] ------------[ cut here ]------------
> [ 2292.336255] WARNING: at fs/btrfs/extent-tree.c:6344 use_block_rsv+0x17d/0x190 [btrfs]()
> [ 2292.336257] Hardware name: System x3550 M3 -[7944K3G]-
> [ 2292.336259] btrfs: block rsv returned -28

This is unrelated.  You got far enough into the benchmark to hit an
ENOSPC warning.  This can be ignored (I just deleted it when we used 3.0
for oracle).

re: dbench performance.  dbench tends to penalize fairness.  I can
imagine RT making it slower in general.

It also triggers lots of lock contention in btrfs because the dataset is
fairly small and the trees don't fan out a lot.

-chris

