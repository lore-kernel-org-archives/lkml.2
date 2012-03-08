Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab2CHVIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:08:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15568 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2CHVIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:08:04 -0500
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=jFmsFhbHx9KQPhuePR8A:9 a=Vtjm5KJ3LB474vflpMMA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331240882.25686.499.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 08 Mar 2012 16:08:02 -0500
In-Reply-To: <1331238369.11248.426.camel@twins>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>
	 <1331230991.25686.452.camel@gandalf.stny.rr.com>
	 <1331231287.11248.396.camel@twins>
	 <1331232159.25686.456.camel@gandalf.stny.rr.com>
	 <1331235579.11248.402.camel@twins>
	 <1331237441.25686.469.camel@gandalf.stny.rr.com>
	 <1331238369.11248.426.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 21:26 +0100, Peter Zijlstra wrote:
> On Thu, 2012-03-08 at 15:10 -0500, Steven Rostedt wrote:
> > 
> > By doing a spin_trydeadlock() while still holding the d_lock, if the
> > holder of the i_lock was blocked on that d_lock then it would detect the
> > failure, and release the lock and continue the loop. This doesn't solve
> > anything. Just because we released the lock, we are still preempting the
> > holder of the d_lock
> 
> ->i_lock, right?


The dvorak key layout has the 'i' and 'd' right next to each other (the
'g' and 'h' key respectively of the qwerty layout). It makes it easy to
get confused :-)


> 
> > , and if we are higher in priority, we will never let the owner run.
> 
> So, suppose:
> 
> task-A				task-B
> 
> lock ->i_lock
> 				lock ->d_lock
> lock ->d_lock <blocks>
> 				trylock ->i_lock
> 
> In this case B's trylock will insta-fail (with -EDEADLK) and we unlock
> ->d_lock in the existing retry logic. That dropping of ->d_lock will
> then wake A, but since B is higher prio A we don't actually run A and
> B's retry loop will re-acquire ->d_lock.
> 
> Crap.. there's also the fact that A doesn't get (or stays) boosted.

Yep. I'm surprised that virtual machines don't have the same issue. Lets
say you are running two CPUs virtual machine that gets pinned to a
single CPU for some reason. Then unless the one vCPU gets preempted
after it releases the i_lock and before it grabs it again, I can see a
virtual machine going in the same loop.

Maybe it does, but eventually the vCPU gets preempted in the right place
and things move forward again. No one notices because people just expect
virtual machines to have long latencies.

Hmm, I bet a -rt kernel would probably run better than a normal kernel
on virtual machines, as spinlocks probably hurt virtual machines more
than mutexes do.

> 
> I can only think of ugly things to do, like on the deadlock scan, force
> assign the first waiter of the inverted lock to owner (in this case the
> deadlock is on ->d_lock so assign A), so that the moment we release
> ->d_lock our re-acquisition fails because its already owned by A, at
> that point B will block and boost A.

Hmm, perhaps we need a way to attach a priority to a lock. Maybe we just
need a way to set a priority of a lock with.. "A task of priority X
needs the lock, set the owner to at least X while it holds the lock",
where it doesn't care about the high priority task, it just cares about
the lock. That is, give locks a priority too (like priority ceiling). On
doing spin_trylock_rt() (no need for deadlock detection) if it fails,
gives a lock the priority of the task trying to take it. The lock will
be given a temporary priority for the duration it is held. The owner of
the lock will get that priority unless its already higher in priority.
When the lock is released, both the owner and the lock lose the
priority.

Note, spin_trylock_rt() continues to run even on failure.

Have cpu_chill() do a "sched_yield()" (the good kind, to put the current
FIFO task behind another FIFO task of the same priority). Then the owner
of the lock will get to run.

The sched_yield in cpu_chill() would be needed if the owner of the lock
is blocked on the lock the high priority task has. After the high
priority task releases its lock, and calls cpu_chill(), the
sched_yield() allows the owner of the lock to run if it happens to be
blocked on the lock the high prio task held. As the cpu_chill() will be
called after that lock is released.

This shouldn't be too hard to implement, as the boosting by the lock
priority lasts only as long as the lock is held. It would not require
implementing any kind of proxy waiter. If a higher prio task comes along
and wants the lock, it will just up the locks priority. The lock
priority still only lasts as long as the lock is held. If the lock isn't
own, the task asking for it will simply get the lock.

I'm really starting to like this idea, and unless you can point holes
into it, I'll go ahead and start implementing it. The worse that can
happen is that the owner of the lock may get a high prio and the
original task that wanted the lock loses its priority for some reason,
that wont affect the owner of the lock. But as its only a temporary
priority, the effect of the boost wont last long (lost on release of the
lock).

If the task that tried to get the lock gets is priority boosted, as the
task is just doing a loop anyway (never blocked as the spin_trylock_rt()
never blocks), even if it preempts the owner of the lock (now that it
has a higher priority), on the next grab of the spin_trylock_rt() it
will boost the lock priority again, as well as the owner of the lock.


Thoughts?

-- Steve


