Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2GVSnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 14:43:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44786 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752234Ab2GVSnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 14:43:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+YJQgcCcaYSaWBC2ZMKcUi5aDe8Qj69u6kQs+3vE
	xcIjcLVi5DHwJf
Message-ID: <1342982589.7210.25.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com, Steven Rostedt <rostedt@goodmis.org>
Date: Sun, 22 Jul 2012 20:43:09 +0200
In-Reply-To: <1342856835.7739.19.camel@marge.simpson.net>
References: <20120711133735.GA8122@quack.suse.cz>
	 <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
	 <20120711201601.GB9779@quack.suse.cz>
	 <alpine.LFD.2.02.1207121552111.32033@ionos>
	 <20120713123318.GB20361@quack.suse.cz>
	 <alpine.LFD.2.02.1207131444490.32033@ionos>
	 <20120713144622.GB28715@quack.suse.cz>
	 <alpine.LFD.2.02.1207151057010.32033@ionos>
	 <1342343673.28142.2.camel@marge.simpson.net>
	 <1342405366.7659.35.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207161058550.32033@ionos>
	 <1342432094.7659.39.camel@marge.simpson.net>
	 <1342433303.7659.42.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207161216200.32033@ionos>
	 <1342530621.7353.116.camel@marge.simpson.net>
	 <1342586692.7321.45.camel@marge.simpson.net>
	 <1342589411.7321.59.camel@marge.simpson.net>
	 <1342856835.7739.19.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-21 at 09:47 +0200, Mike Galbraith wrote: 
> On Wed, 2012-07-18 at 07:30 +0200, Mike Galbraith wrote: 
> > On Wed, 2012-07-18 at 06:44 +0200, Mike Galbraith wrote:
> > 
> > > The patch in question for missing Cc.  Maybe should be only mutex, but I
> > > see no reason why IO dependency can only possibly exist for mutexes...
> > 
> > Well that was easy, box quickly said "nope, mutex only does NOT cut it".
> 
> And I also learned (ouch) that both doesn't cut it either.  Ksoftirqd
> (or sirq-blk) being nailed by q->lock in blk_done_softirq() is.. not
> particularly wonderful.  As long as that doesn't happen, IO deadlock
> doesn't happen, troublesome filesystems just work.  If it does happen
> though, you've instantly got a problem.

That problem being slab_lock in practice btw, though I suppose it could
do the same with any number of others.  In encountered case, ksoftirqd
(or sirq-blk) blocks on slab_lock while holding q->queue_lock, while a
userspace task (dbench) blocks on q->queue_lock while holding slab_lock
on the same cpu.  Game over.

Odd is that it doesn't seem to materialize if you have rt_mutex deadlock
detector enabled, not that that matters.  My 64 core box beat on ext3
for 35 hours without ever hitting it with no deadlock detector (this
time.. other long runs on top thereof, totaling lots of hours), and my
x3550 beat crap out of several fs for a very long day week without
hitting it with deadlock detector, but hits it fairly easily without.  

Hohum, regardless of fickle timing gods mood of the moment, deadlocks
are most definitely possible, and will happen, which leaves us with at
least two filesystems needing strategically placed -rt unplug points,
with no guarantee that this is really solving anything at all (other
than empirical evidence that the bad thing ain't happening 'course).

-Mike

