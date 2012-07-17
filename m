Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab2GQEot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 00:44:49 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:58758 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751257Ab2GQEor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 00:44:47 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/icQdfy03i7c+0vk7pOzGXb10+eVw+2yDZYxG97R
	/BXIFBmzphYyKu
Message-ID: <1342500283.7353.46.camel@marge.simpson.net>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "Chris L. Mason" <clmason@fusionio.com>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 17 Jul 2012 06:44:43 +0200
In-Reply-To: <1342499278.24525.13.camel@gandalf.stny.rr.com>
References: <1342072060.7338.102.camel@marge.simpson.net>
	 <20120713125043.GH30128@shiny> <1342260883.7368.30.camel@marge.simpson.net>
	 <20120715175612.GF25961@shiny.int.fusionio.com>
	 <1342404140.7659.27.camel@marge.simpson.net>
	 <1342454547.5410.3.camel@gandalf.stny.rr.com>
	 <1342455968.7659.93.camel@marge.simpson.net>
	 <1342456567.7659.97.camel@marge.simpson.net>
	 <1342458195.2783.5.camel@acer.local.home>
	 <1342498722.7353.37.camel@marge.simpson.net>
	 <1342499278.24525.13.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 00:27 -0400, Steven Rostedt wrote: 
> On Tue, 2012-07-17 at 06:18 +0200, Mike Galbraith wrote:
> >  
> > > There's that too. But the issue I was talking about is with all trylock
> > > loops. As holding an rt-mutex now disables migration, if a high priority
> > > process preempts a task that holds the lock, and then the high prio task
> > > starts spinning waiting for that lock to release, the lower priority
> > > process will never get to run to release it. The cpu_chill() doesn't
> > > help.
> > 
> > Hrm.  I better go make a testcase, this one definitely wants pounding
> > through thick skull.
> 
> Actually, I was mistaken. I forgot that we defined 'cpu_chill()' as
> msleep(1) on RT, which would keep a deadlock from happening.

Whew!  There are no stars and moons on my pointy hat, just plain white
cone, so you had me worried I was missing something critical there.

> It doesn't explain the performance enhancement you get :-/

No, it doesn't.  The only thing I can think of is that while folks are
timed sleeping, they aren't preempting and interleaving IO as much, but
I'm pulling that out of thin air.  Timed sleep should be a lot longer
than regular wakeup, so to my mind, there should be less interleave due
to more thumb twiddling.

-Mike

