Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0F2QXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:23:41 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51551 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab0F2QXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:23:39 -0400
Date: Tue, 29 Jun 2010 09:23:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, john stultz <johnstul@us.ibm.com>,
       Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sanitize task->comm to avoid leaking escape codes
Message-ID: <20100629162334.GE2765@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100623181129.GM5876@outflux.net>
 <20100623194145.GA19628@redhat.com>
 <1277787505.3599.25.camel@localhost.localdomain>
 <20100629133131.GB5237@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629133131.GB5237@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 03:31:31PM +0200, Oleg Nesterov wrote:
> On 06/29, Artem Bityutskiy wrote:
> >
> > On Wed, 2010-06-23 at 21:41 +0200, Oleg Nesterov wrote:
> > > On 06/23, Kees Cook wrote:
> > > >
> > > > @@ -956,7 +957,15 @@ void set_task_comm(struct task_struct *tsk, char *buf)
> > > >  	 */
> > > >  	memset(tsk->comm, 0, TASK_COMM_LEN);
> > > >  	wmb();
> > >
> > > Off-topic. I'd wish I could understand this barrier. Since the lockless
> > > reader doesn't do rmb() I don't see how this can help.
> >
> > This wmb() looks wrong to me as well. To achieve what the comment in
> > this function says, it should be smp_wmb() and we should have smp_rmb()
> > in the reading side, AFAIU.
> >
> > >  OTOH, I don't
> > > understand why it is needed, we never change ->comm[TASK_COMM_LEN-1] == '0'.
> >
> > I think the idea was that readers can see incomplete names, but not
> > messed up names, consisting of old and new ones.
> 
> OK, agreed, comm[TASK_COMM_LEN-1] == '0' can't help to avoid the
> messed names.
> 
> But nether can help smp_rmb() in the reading (lockless) side?
> 
> Say,
> 
> 	printk("comm=%s\n", current->comm);
> 
> if we add rmb() before printk, it can't make any difference. The lockless
> code should do something like
> 
> 	get_comm_lockless(char *to, char *comm)
> 	{
> 		while (*comm++ = *to++)
> 			rmb();
> 	}
> 
> to ensure it sees the result of
> 
> 	memset(tsk->comm, 0, TASK_COMM_LEN);
> 	wmb();
> 	strcpy(tsk->comm, buf);
> 
> in the right order.
> 
> otherwise printk("comm=%s\n", current->comm) can read, say, comm[1]
> before set_task_comm->memset(), and comm[0] after set_task_comm->strcpy().
> 
> So, afaics, set_task_comm()->wmb() buys nothing and should be removed.
> The last zero char in task_struct->comm[] is always here, at least this
> guarantees that strcpy(char *dest, tsk->comm) is always safe.
> 
> (I cc'ed the expert, Paul can correct me)

First, all of the implementations that I can see do task_lock(tsk), which
should prevent readers from seeing any changes.  So I am guessing that
you guys want to allow readers to get at ->comm without having to acquire
this lock.

So if the reader uses no mutual exclusion, then that reader could be
preempted/interrupted/NMIed/cache-missed/whatever for quite some time.
The task's ->comm field might change once, twice, ten times in the
meantime.  The reader might then to so far as to get one character from
each of the multiple names that happened in the meantime.  So, how to fix?

Here are some approaches that come to mind off-hand:

1.	Use RCU (always my favorite, of course, but in this case...):

	The task structure adds a char* named ->commp that normally
	points to ->comm in the same task structure.  The updater
	changes the name as follows:

	a.	Allocate a chunk of memory to hold the new name.

	b.	Copy the desired string into this newly allocated
		chunk of memory.

	c.	rcu_assign_pointer() ->commp to point to this
		newly allocated chunk of memory.

	d.	synchronize_rcu().

	e.	Now all readers are looking at the new name, so
		copy the new name into ->comm.

	f.	rcu_assign_pointer() ->commp to point to ->comm.

	g.	synchronize_rcu().

	h.	free up the newly assigned chunk of memory.

	Then the reader does:

		rcu_read_lock()
		p = rcu_dereference(tsk->commp);
		do_something_with(p);
		rcu_read_unlock();

	This works, but is a bit complex, and adds not one but two
	grace periods to the updater.  Yes, it is possible to optimize
	the second grace period away in the case of back-to-back
	updaters, but...

2.	Use sequence locks:

	The updater just does the update under the sequence lock.

	The reader does the usual:

		do {
			seq = read_seqbegin(&tsk->commseqlock);
			do_something_with(tsk->comm);
		} while (read_seqretry(&tsk->commseqlock, seq));

	Of course, this can starve readers, which can retaliate
	using something like the following:

		i = 0;
		do {
			seq = read_seqbegin(&tsk->commseqlock);
			do_something_with(tsk->comm);
		} while (read_seqretry(&tsk->commseqlock, seq) && ++i < 3);
		if (i >= 3) {
			write_seqlock(&tsk->commseqlock);
			do_something_with(tsk->comm);
			write_sequnlock(&tsk->commseqlock);
		}

	Readers might also need rcu_read_lock() to keep the task from
	disappearing out from under them:

		rcu_read_lock();
		tsk = ...
		...
		i = 0;
		do {
			seq = read_seqbegin(&tsk->commseqlock);
			do_something_with(tsk->comm);
		} while (read_seqretry(&tsk->commseqlock, seq) && ++i < 3);
		if (i >= 3) {
			write_seqlock(&tsk->commseqlock);
			do_something_with(tsk->comm);
			write_sequnlock(&tsk->commseqlock);
		}
		rcu_read_unlock();

	But I have to defer to you guys on this one.  For example, in the
	case where tsk==current, I do not believe that rcu_read_lock()
	is needed.

3.	Various forms of reader-writer locks -- none of which seem to
	me to work very well in this case.

4.	Your approach here!  ;-)

							Thanx, Paul
