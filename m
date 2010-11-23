Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab0KWOZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:25:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:33641 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab0KWOZM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:25:12 -0500
Subject: Re: [RFC][PATCH 05/22] sched: SCHED_DEADLINE policy implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289724847.6632.33.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333814.8661.146.camel@Palantir>  <1289724847.6632.33.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Nov 2010 15:24:47 +0100
Message-ID: <1290522287.2072.409.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-14 at 09:54 +0100, Raistlin wrote:
> On Fri, 2010-10-29 at 08:30 +0200, Raistlin wrote:
> > +static void task_fork_dl(struct task_struct *p)
> > +{
> > +	/*
> > +	 * The child of a -deadline task will be SCHED_DEADLINE, but
> > +	 * as a throttled task. This means the parent (or someone else)
> > +	 * must call sched_setscheduler_ex() on it, or it won't even
> > +	 * start.
> > +	 */
> > +	p->dl.dl_throttled = 1;
> > +	p->dl.dl_new = 0;
> > +}
> > +
> So, this is also something we only discussed once without reaching a
> conclusive statement... Are we ok with this behaviour?
> 
> I'm not, actually, but I'm not sure how to do better, considering:
>  - resetting task to SCHED_OTHER on fork is useless and confusing, since
>    RESET_ON_FORK already exists and allows for this.
>  - cloning the parent's bandwidth and try to see if it fits might be
>    nice, but what if the check fails? fork fails as well? If yes, what
>    should the parent do, lower its own bandwidth (since it's being
>    cloned) and try forking again? If yes, lowering it by how much? 
>    Mmm... Not sure it would fly... :-(
>  - splitting the bandwidth of the parent in two would make sense
>    to me, but then it has to be returned at some point, or a poor
>    -deadline shell will reach zero bandwidth after a few `ls'! So, when
>    are we giving the bandwidth back to the parent? When the child dies?
>    What if the child is sched_setscheduled_ex()-ed (either to -deadline 
>    or to something else), we return the bw back (if the call succeeds)
>    as well?
> 
> I was thinking wither to force RESET_ON_FORK for SCHED_DEADLINE or to
> try to pursue the 3rd solution (provided I figure out what to do on
> detaching, parent dying, and such things... :-P).
> 
> Comments very very welcome!

Right, so either this, or we could make sched_deadline tasks fail
fork() ;-)

from a RT perspective such tasks shouldn't fork() anyway, fork()
includes a lot of implicit memory allocations which definitely are not
deterministic (page reclaim etc.).

So yeah, I'm fine with this, it causes some pain, but then, you've
earned this pain by doing this in the first place.
