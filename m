Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab0JKMl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 08:41:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab0JKMl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 08:41:57 -0400
Date: Mon, 11 Oct 2010 14:37:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
Message-ID: <20101011123704.GA3519@redhat.com>
References: <1285330688.2179.305.camel@holzheu-laptop> <20100926181127.GA26985@redhat.com> <20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com> <20100927165133.GA23535@redhat.com> <20100929191916.21E1840038@magilla.sf.frob.com> <1285854460.1856.14.camel@holzheu-laptop> <20101005085751.4490A401B2@magilla.sf.frob.com> <1286357350.1888.25.camel@holzheu-laptop> <20101006152609.GA21169@redhat.com> <1286464017.1849.120.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286464017.1849.120.camel@holzheu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07, Michael Holzheu wrote:
>
> On Wed, 2010-10-06 at 17:26 +0200, Oleg Nesterov wrote:
> >
> > I am not sure I understand the "correct accounting" above. ->acct_parent
> > adds the "parallel" hierarchy.
>
> Correct. The patch adds a "parallel" hierarchy that IMHO is better
> suited for accounting purposes. For me the correct accounting hierarchy
> means that cumulative time is passed along the real relationship tree.
> That means if you have two task snapshots it is clear which tasks
> inherited the time of the dead children. Example:
>
> P1 is parent of P2 is parent of P3
>
> Snapshot 1: P1 -> P2 -> P3
> Snapshot 2: P1
>
> We know that P2 and P3 died in the last interval. With the current
> cumulative time accounting we can't say, if P1 got the CPU time of P3
> (if P3 died before P2) or if init got the time (if P2 died before P3).
> With my patch we know that P1 got all the CPU time of P2 and P3.

Yes, I see what the patch does.

(but "P1 got all the CPU time of P2 and P3" doesn't look 100% right,
 see below).

Still I am not sure. First of all, again, this complicates the core
kernel code for top. And note that this parallel hierarchy is not
visible to userspace (it can only see the "side effects" in cdata_acct).

But more importanly, I do not understand why this is always better.
Say, if the task does daemonize(), it wants to become the child
of init, and imho in this case it should be accounted accordinly.

> > > @@ -90,6 +156,24 @@ static void __exit_signal(struct task_st
> > >
> > >  	posix_cpu_timers_exit(tsk);
> > >  	if (group_dead) {
> > > +		if (!tsk->exit_accounting_done) {
> > > +#ifdef __s390x__
> > > +		/*
> > > +		 * FIXME: On s390 we can call account_process_tick to update
> > > +		 * CPU time information. This is probably not valid on other
> > > +		 * architectures.
> > > +		 */
> > > +			if (current == tsk)
> > > +				account_process_tick(current, 1);
> > > +#endif
> > > +			/*
> > > +			 * FIXME: This somehow has to be moved to
> > > +			 * finish_task_switch(), because otherwise
> > > +			 * if the process accounts itself, the CPU time
> > > +			 * that is used for this code will be lost.
> > > +			 */
> > > +			__account_to_parent(tsk, 0);
> >
> > We hold the wrong ->siglock here.
>
> Right, we hold the siglock of the exiting task, but we should hold the
> lock of the parent, correct?

Yes. __account_to_parent() should be caller later, after spin_unlock(siglock),
__exit_signal() has another "if (group_dead)" check below.

This also means __account_to_parent() should take ->siglock itself.

Probably this is a matter of taste, but I do not understand why
__account_to_parent() takes the boolean "wait" argument. The caller
can just pass the correct task_struct* which is either ->real_parent
or ->acct_parent.

> > Also, the logic behind ->exit_accounting_done looks wrong (and unneeded)
> > but I am not sure...
>
> I think the logic is correct,

OK, I misread the patch as if we always account the exited task in
parent's cdata_acct,

	+       struct cdata cdata_wait; /* parents have done sys_wait() */
	+       struct cdata cdata_acct; /* complete cumulative data from acct tree */

while in fact the "complete" data is cdata_wait + cdata_acct.

Hmm. Let's return to your example above,

	> Snapshot 1: P1 -> P2 -> P3
	> Snapshot 2: P1
	> ...
	> P1 got all the CPU time of P2 and P3

Suppose that P2 dies before P3. Then P3 dies, /sbin/init does wait and
accounts this task. This means it is not accounted in P1->signal->cdata_acct,
no?

> > > @@ -772,6 +869,15 @@ static void forget_original_parent(struc
> > >  	LIST_HEAD(dead_children);
> > >
> > >  	write_lock_irq(&tasklist_lock);
> > > +	list_for_each_entry_safe(p, n, &father->children_acct, sibling_acct) {
> > > +		struct task_struct *t = p;
> > > +		do {
> > > +			t->acct_parent = t->acct_parent->acct_parent;
> > > +		} while_each_thread(p, t);
> > > +		list_move_tail(&p->sibling_acct,
> > > +			       &p->acct_parent->children_acct);
> >
> > This is certainly wrong if there are other live threads in father's
> > thread-group.
>
> Sorry for my ignorance. Probably I have not understood what happens, if
> a thread group leader dies. My assumption was that then the whole thread
> group dies.

No. A thread group dies when the last thread dies. If a leader exits
it becomes a zombie until all other sub-threads exit.

> Also I assumed that a parent can only be a thread group
> leader.

No. If a thread T does fork(), the child's ->real_parent is T, not
T->group_leader. If T exits, we do not reparent its children to init
(unless it is the last thread, of course), we pick another live
thread in this thread group for reparenting.

> > Also, you need to change de_thread() if it changes the leader.
>
> Something like the following?
>
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -850,6 +850,7 @@ static int de_thread(struct task_struct
>
>                 list_replace_rcu(&leader->tasks, &tsk->tasks);
>                 list_replace_init(&leader->sibling, &tsk->sibling);
> +               list_replace_init(&leader->sibling_acct, &tsk->sibling_acct);

Yes.

> > > +		list_del_init(&p->sibling_acct);
> >
> > This list_del() can race with ->acct_parent if it in turn exits and
> > does forget_original_parent() -> list_move_tail(sibling_acct).
>
> Ok, to fix this I could move the list_del_init(&p->sibling_acct) to
> reparent_leader():
>
> @@ -761,6 +868,7 @@ static void reparent_leader(struct task_
>                 if (task_detached(p)) {
>                         p->exit_state = EXIT_DEAD;
>                         list_move_tail(&p->sibling, dead);
> +                       list_del_init(&p->sibling_acct);

Probably yes... Well, currently I do not really understand how this
all looks with this patch applied, but perhaps this list_del() is
not needed at all? We are going to call release_task(p), and it
should remove p from ->children_acct and ->children anyway?

Oleg.

