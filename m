Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0EGW3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:29:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:41315 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab0EGW3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:29:42 -0400
Subject: Re: [PATCH/RFC] mutex: Fix optimistic spinning vs. BKL
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tony Breeds <tonyb@au1.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20100507212909.GD5401@nowhere>
References: <1272429513.24542.83.camel@pasglop>
	 <201004281406.04080.arnd@arndb.de> <1272494121.24542.113.camel@pasglop>
	 <20100507042010.GR12389@ozlabs.org> <20100507053023.GF8069@nowhere>
	 <1273212116.4861.61.camel@pasglop>  <20100507212909.GD5401@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 May 2010 08:27:42 +1000
Message-ID: <1273271262.4861.134.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Yeah, I was considering only the deadlock issue.
> 
> Ok it's an problem on power consumption. That said I wonder if we have
> so much places where a task can hold a mutex for two jiffies without
> sleeping in-between, since when the owner goes to sleep, spinning is
> stopped.
> 
> If that's an issue for power saving, it means we have places to fix.
> Also I wonder if we should disable adaptive spinning for people who want
> agressive power saving. At least it would be worth the test to check the
> result.

I don't think it's only about agressive power saving. I'm not sure this
is directly related but somebody recently reported a case where pretty
much every CPU in the machine gets to spin on one holding the mutex, the
power consumption skyrockets and everything heats up at once. Not nice
even on servers on workloads where otherwise everybody would have gone
to sleep.

My feeling is that spinning should last only a very small amount of
time, ideally using a better clock than jiffies, maybe a few dozen ms at
max. But I decided to compromise for code simplicity and less overhead
by using jiffies instead. Maybe 1 jiffy delta would have been enough,
not two tho (which means a random timeout between 0 and 1 jiffie).

> Also, to solve this problem when several cpus may spin on the owner,
> I wonder adaptive spinning is doing the right thing here. We should
> have only one spinner I think, and the rest should go to sleep as the
> time to spin on several subsequent owners would be much better gained
> to do something else (schedule something else or power saving).
> In fact, that too could deserve some tests.

Right, the problem is due to the fact that we skip spinning if there's
already a waiter but we don't know that there is already a spinner so we
can end up with multiple spinners.

I don't see a non invasive way to fix that.. we could add a spinner
counter to the mutex but that sucks a bit. Might still be worthwhile,
not sure. Peter, what do you reckon ?

> Ok. But even under this power saving angle, I think this heuristic based on
> timeout is still only hidding the problem. Or it lowers it more than it
> solves it, which is quite better than keeping the things as is of course.
> But if the real source is in places that hold mutexes without sleeping for
> too much time, I think we should rather identify these places and solve
> the ugly locking there.

That's a job for lockdep or something similar :-) Doing so is
orthogonal, I don't see this contradicting with limiting the spinning
time. Again, I tend to have a different "view" of it as: spinning is an
oportunistic optimization based on the idea that the owner will release
the mutex soon, I don't see the point of spinning for a long time :-)

Note that power management is one side of the story. Another one is
relinguishing the CPU to the hypervisor so some other partition gets
some time. Etc... There's more than one consequence to ending up with
CPUs spinning instead of sleeping and they are not all trivial, so by
letting mutexes spin for potentially a "long time", we quite
fundamentally change the semantics of those mutexes with impacts in othe
areas that we don't necessarily see. This goes beyond the scope of a
simple optimization and becomes problematic.

Yes, we can to try to find all of these areas and address them one by
one, or we can use my simpler approach which is to keep the overall
semantic of mutexes which is to sleep ... and bound the optimisation to
what it should be: a short term spin to speed up short lived contention
cases.

But yeah, the argument is very valid that maybe we should spin even less
long and that maybe we should use a finer grained clock to limit the
spin to a few microseconds at most. The exact number remains to be
determined :-)

> Plus may be allowing only one spinner at the time.
> 
> But yeah until we reach a good solution for that, may be this timeout
> would be worth.

Cheers,
Ben.

> 
> 
> > > Moreover that adds some unnessary (small) overhead in this path.
> > 
> > Uh ? So ? This is the contended path where we are .. spinning :-) The
> > overhead of reading jiffies and comparing here is simply never going to
> > show on any measurement I bet you :-)
> 
> 
> 
> Yeah, probably in fact :)
> 
> 
> 
> > > May be can we have it as a debugging option, something that would
> > > be part of lockdep, which would require CONFIG_DEBUG_MUTEX to
> > > support mutex adaptive spinning.
> > 
> > No, what I would potentially add as part of lockdep however is a way to
> > instrument how often we get out of the spin via the timeout. That might
> > be a useful information to figure out some of those runaway code path,
> > but they may well happen for very legit reasons and aren't a bug per-se.
> 
> 
> 
> We could make a trace event for that.
> 
> Thanks.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


