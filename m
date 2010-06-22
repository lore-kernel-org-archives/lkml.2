Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0FVUoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 16:44:38 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56843 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab0FVUoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 16:44:37 -0400
Date: Tue, 22 Jun 2010 13:44:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, daniel.blueman@gmail.com,
       lizf@cn.fujitsu.com, miles.lane@gmail.com, manfred@colorfullife.com
Subject: Re: [GIT PULL rcu/urgent] yet more lockdep-RCU splat fixes
Message-ID: <20100622204433.GJ2290@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100616042224.GA3892@linux.vnet.ibm.com>
 <20100616055358.GB17936@elte.hu>
 <1276669431.1745.595.camel@laptop>
 <20100616224110.GI2457@linux.vnet.ibm.com>
 <1276764554.27822.26.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276764554.27822.26.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 10:49:14AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-06-16 at 15:41 -0700, Paul E. McKenney wrote:
> 
> > Hello, Peter!
> > 
> > Here is the story as I understand it:
> > 
> > o	wake_affine() calls task_group() and uses the resulting
> > 	pointer, for example, passing it to effective_load().
> > 
> > 	This pointer is to a struct task_group, which contains
> > 	a struct rcu_head, which is passed to call_rcu in
> > 	sched_destroy_group().  So some protection really is
> > 	needed -- or is it enough that wake_affine seems to be
> > 	invoked on the current task?  If the latter, we would
> > 	need to add a "task == current" check to task_subsys_state().
> > 
> > o	task_group() calls task_subsys_state(), returning a pointer to
> > 	the enclosing task_group structure.
> > 
> > o	task_subsys_state() returns an rcu_dereference_check()ed
> > 	pointer.  The caller must either be in an RCU read-side
> > 	critical section, hold the ->alloc_lock, or hold the
> > 	cgroup lock.
> > 
> > Now wake_affine() appears to be doing load calculations, so it does not
> > seem reasonable to acquire the lock.  Hence the use of RCU.
> > 
> > So, what should we be doing instead?  ;-)
> 
> Well, start by writing a sane changlog ;-)

As soon as I learn the relevant definition of "sane" for this context.  ;-)

> I realise you didn't actually wrote these patches, but you should push
> back to the people feeding you these things (esp when you get gems like:
> 
>   tg = task_group();
>   rcu_read_unlock();
> 
> which is obvious utter garbage).

Agreed.  If you prefer, I can combine the two patches to avoid the
appearance of insanity.  (The second patch of the pair adjusts the
rcu_read_unlock() to cover all uses of the "tg" pointer.)

> There's _two_ task_group() users in wake_affine(), at least one should
> be covered by the rq->lock we're holding. It should then explain why the
> other isn't covered (and which the other is).

I am probably missing something, but I see wake_affine() only called
from select_task_rq_fair(), which is one of the possible values for
->select_task_rq().  This can be called from select_task_rq(), which
claims that it can be called without holding rq->lock.  I do not see
any rq->lock acquisition on the path from select_task_rq() to the
call to wake_affine().

(I am looking at 2.6.34, FWIW.)

> It should also explain why using RCU read lock is the right solution,
> and doesn't result in funny races. That is, the current changelog reads
> like: "It whines, this makes it quiet." -- which I totally distrust
> because we already found at least two actual bugs in this area
> (sched-cgroup rcu usage).

The usage appears to be heuristic in nature, so that processing old
data should be non-fatal.

> That said, the two patches together might not be wrong, but its very
> hard to verify without more information.

Left to myself, I would combine the two patches and use the changelog
shown below.  Does this work for you?

							Thanx, Paul

rcu: apply RCU protection to wake_affine()

The task_group() function returns a pointer that must be protected
by either RCU, the ->alloc_lock, or the cgroup lock (see the
rcu_dereference_check() in task_subsys_state(), which is invoked by
task_group()).  The wake_affine() function currently does none of these,
which means that a concurrent update would be within its rights to free
the structure returned by task_group().  Because wake_affine() uses this
structure only to compute load-balancing heuristics, there is no reason
to acquire either of the two locks.

Therefore, this commit introduces an RCU read-side critical section that
starts before the first call to task_group() and ends after the last use
of the "tg" pointer returned from task_group().  Thanks to Li Zefan for
pointing out the need to extend the RCU read-side critical section from
that proposed by the original patch.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
