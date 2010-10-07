Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab0JGPHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:07:07 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:59677 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab0JGPHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:07:04 -0400
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Oleg Nesterov <oleg@redhat.com>
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
In-Reply-To: <20101006152609.GA21169@redhat.com>
References: <1285250541.1837.95.camel@holzheu-laptop>
	 <20100923171025.GA26623@redhat.com>
	 <1285330688.2179.305.camel@holzheu-laptop>
	 <20100926181127.GA26985@redhat.com>
	 <20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com>
	 <20100927165133.GA23535@redhat.com>
	 <20100929191916.21E1840038@magilla.sf.frob.com>
	 <1285854460.1856.14.camel@holzheu-laptop>
	 <20101005085751.4490A401B2@magilla.sf.frob.com>
	 <1286357350.1888.25.camel@holzheu-laptop>
	 <20101006152609.GA21169@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 07 Oct 2010 17:06:57 +0200
Message-ID: <1286464017.1849.120.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

On Wed, 2010-10-06 at 17:26 +0200, Oleg Nesterov wrote:
> > The patch also approaches another ugly Unix behavior regarding process
> > accounting. If a parent process dies before his children, the children
> > get the reaper process (init) as new parent. If we want to determine the
> > CPU usage of a process tree with cumulative time, this is very
> > suboptimal. To fix this I added a new process relationship tree for
> > accounting.
> 
> Well, I must admit, I can't say I like the complications this change adds ;)
> In any case, imho this change needs a separate patch/discussion.

Well, to be honest, I have not expected that people will love this
patch. At least not immediately :-)

I just wanted to show one idea how we could solve my problem with the
lost time.

> > Besides of that the patch adds an "acct_parent" pointer next to the parent
> > pointer and a "children_acct" list next to the children list to the
> > task_struct in order to remember the correct accounting task relationship.
> 
> I am not sure I understand the "correct accounting" above. ->acct_parent
> adds the "parallel" hierarchy.

Correct. The patch adds a "parallel" hierarchy that IMHO is better
suited for accounting purposes. For me the correct accounting hierarchy
means that cumulative time is passed along the real relationship tree.
That means if you have two task snapshots it is clear which tasks
inherited the time of the dead children. Example:

P1 is parent of P2 is parent of P3

Snapshot 1: P1 -> P2 -> P3
Snapshot 2: P1

We know that P2 and P3 died in the last interval. With the current
cumulative time accounting we can't say, if P1 got the CPU time of P3
(if P3 died before P2) or if init got the time (if P2 died before P3).
With my patch we know that P1 got all the CPU time of P2 and P3.

Without the patch a top command had somehow to receive the "reparent to
init" events or it had to receive all task exit events. The latter is
probably very CPU intensive for workloads that create many short-running
processes.

> In the simplest case, suppose that some
> process P forks the child C and exits. Then C->acct_parent == P->real_parent
> (P->acct_parent in general). I am not sure this is always good.

For most cases both trees are identical. Only, if reparent to init
happens, the trees become different. Maybe it is possible to optimize
the code that only if the trees differ the information is stored.

> Anyway,
> 
> > @@ -90,6 +156,24 @@ static void __exit_signal(struct task_st
> >  
> >  	posix_cpu_timers_exit(tsk);
> >  	if (group_dead) {
> > +		if (!tsk->exit_accounting_done) {
> > +#ifdef __s390x__
> > +		/*
> > +		 * FIXME: On s390 we can call account_process_tick to update
> > +		 * CPU time information. This is probably not valid on other
> > +		 * architectures.
> > +		 */
> > +			if (current == tsk)
> > +				account_process_tick(current, 1);
> > +#endif
> > +			/*
> > +			 * FIXME: This somehow has to be moved to
> > +			 * finish_task_switch(), because otherwise
> > +			 * if the process accounts itself, the CPU time
> > +			 * that is used for this code will be lost.
> > +			 */
> > +			__account_to_parent(tsk, 0);
> 
> We hold the wrong ->siglock here.

Right, we hold the siglock of the exiting task, but we should hold the
lock of the parent, correct?

> Also, the logic behind ->exit_accounting_done looks wrong (and unneeded)
> but I am not sure...

I think the logic is correct, but probably a better implementation is
possible. The member "exit_accounting_done" is used for the following
two cases:

1. Process becomes a zombie and parent waits for it:
   * wait_task_zombie() calls __account_to_parent(p, 1) that sets 
     exit_accounting_done = 1
   * Then release_task()/__exit_signal() is called that does no
     accounting, because exit_accounting_done is already set to 1
2. Process reaps itself:
   * release_task()/__exit_signal() is called, exit_accounting_done is
     still 0, therefore __account_to_parent(tsk, 0) is called

> > @@ -772,6 +869,15 @@ static void forget_original_parent(struc
> >  	LIST_HEAD(dead_children);
> >  
> >  	write_lock_irq(&tasklist_lock);
> > +	list_for_each_entry_safe(p, n, &father->children_acct, sibling_acct) {
> > +		struct task_struct *t = p;
> > +		do {
> > +			t->acct_parent = t->acct_parent->acct_parent;
> > +		} while_each_thread(p, t);
> > +		list_move_tail(&p->sibling_acct,
> > +			       &p->acct_parent->children_acct);
> 
> This is certainly wrong if there are other live threads in father's
> thread-group.

Sorry for my ignorance. Probably I have not understood what happens, if
a thread group leader dies. My assumption was that then the whole thread
group dies. Also I assumed that a parent can only be a thread group
leader.

So what you are saying is that when a thread group leader dies and there
are other live threads in his thread group, his children will NOT get
init as new parent? Instead they get the new thread group leader as
parent?

> Also, you need to change de_thread() if it changes the leader.

Something like the following?

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -850,6 +850,7 @@ static int de_thread(struct task_struct 

                list_replace_rcu(&leader->tasks, &tsk->tasks);
                list_replace_init(&leader->sibling, &tsk->sibling);
+               list_replace_init(&leader->sibling_acct, &tsk->sibling_acct);

                tsk->group_leader = tsk;
                leader->group_leader = tsk;


> 
> >  	list_for_each_entry_safe(p, n, &dead_children, sibling) {
> >  		list_del_init(&p->sibling);
> > +		list_del_init(&p->sibling_acct);
> 
> This list_del() can race with ->acct_parent if it in turn exits and
> does forget_original_parent() -> list_move_tail(sibling_acct).

Ok, to fix this I could move the list_del_init(&p->sibling_acct) to
reparent_leader():

@@ -761,6 +868,7 @@ static void reparent_leader(struct task_
                if (task_detached(p)) {
                        p->exit_state = EXIT_DEAD;
                        list_move_tail(&p->sibling, dead);
+                       list_del_init(&p->sibling_acct);
                }
        }


Michael

