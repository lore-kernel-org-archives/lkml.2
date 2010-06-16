Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477Ab0FPWlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 18:41:15 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40753 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab0FPWlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 18:41:13 -0400
Date: Wed, 16 Jun 2010 15:41:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, daniel.blueman@gmail.com,
       lizf@cn.fujitsu.com, miles.lane@gmail.com, manfred@colorfullife.com
Subject: Re: [GIT PULL rcu/urgent] yet more lockdep-RCU splat fixes
Message-ID: <20100616224110.GI2457@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100616042224.GA3892@linux.vnet.ibm.com>
 <20100616055358.GB17936@elte.hu>
 <1276669431.1745.595.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276669431.1745.595.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 08:23:51AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-06-16 at 07:53 +0200, Ingo Molnar wrote:
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > Hello, Ingo,
> > > 
> > > Here are a few more fixes for RCU-lockdep splats.
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent
> > > 
> > > This is based off of v2.6.35-rc3.
> > > 
> > > 							Thanx, Paul
> > > 
> > > ------------------>
> > > Daniel J Blueman (1):
> > >       rcu: fix lockdep splat in wake_affine()
> > > 
> > > Paul E. McKenney (2):
> > >       rcu: fix scope of wake_affine()'s new RCU read-side critical section
> > >       idr: fix RCU lockdep splat in idr_get_next()
> > > 
> > >  kernel/sched_fair.c |    2 ++
> > >  lib/idr.c           |    4 ++--
> > >  2 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > Pulled, thanks a lot Paul!
> 
> I'm not at all sure of those two wake_affine() ones..

Hello, Peter!

Here is the story as I understand it:

o	wake_affine() calls task_group() and uses the resulting
	pointer, for example, passing it to effective_load().

	This pointer is to a struct task_group, which contains
	a struct rcu_head, which is passed to call_rcu in
	sched_destroy_group().  So some protection really is
	needed -- or is it enough that wake_affine seems to be
	invoked on the current task?  If the latter, we would
	need to add a "task == current" check to task_subsys_state().

o	task_group() calls task_subsys_state(), returning a pointer to
	the enclosing task_group structure.

o	task_subsys_state() returns an rcu_dereference_check()ed
	pointer.  The caller must either be in an RCU read-side
	critical section, hold the ->alloc_lock, or hold the
	cgroup lock.

Now wake_affine() appears to be doing load calculations, so it does not
seem reasonable to acquire the lock.  Hence the use of RCU.

So, what should we be doing instead?  ;-)

							Thanx, Paul
