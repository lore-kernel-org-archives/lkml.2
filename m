Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab0JOOeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:34:15 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:56408 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab0JOOeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:34:13 -0400
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
In-Reply-To: <20101014134716.GA5187@redhat.com>
References: <20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com>
	 <20100927165133.GA23535@redhat.com>
	 <20100929191916.21E1840038@magilla.sf.frob.com>
	 <1285854460.1856.14.camel@holzheu-laptop>
	 <20101005085751.4490A401B2@magilla.sf.frob.com>
	 <1286357350.1888.25.camel@holzheu-laptop>
	 <20101006152609.GA21169@redhat.com>
	 <1286464017.1849.120.camel@holzheu-laptop>
	 <20101011123704.GA3519@redhat.com>
	 <1286889057.1932.77.camel@holzheu-laptop>
	 <20101014134716.GA5187@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Fri, 15 Oct 2010 16:34:05 +0200
Message-ID: <1287153246.1896.231.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

On Thu, 2010-10-14 at 15:47 +0200, Oleg Nesterov wrote:

[snip]

> > +static void __account_to_parent(struct task_struct *p, int wait)
> > +{
> > +       if (wait)
> > +               __account_ctime(p, &p->real_parent->signal->cdata_wait,
> > +                               &p->signal->cdata_wait);
> > +       __account_ctime(p, &p->acct_parent->signal->cdata_acct,
> > +                       &p->signal->cdata_acct);
> > +       p->exit_accounting_done = 1;
> >
> > If a tasks reaps itself, only cdata_acct is updated.
> 
> Yes. But __account_to_parent() always sets p->exit_accounting_done = 1.
> And __exit_signal() calls __account_to_parent() only if it is not set.
> 
> This means that we update either cdata_wait (if the child was reaped
> by parent) or cdata_acct (the process auto-reaps itself).

No. The accounting of cdata_acct is done unconditionally in
__account_to_parent(). It is done for both cases wait=0 and wait=1,
therefore no CPU time gets lost. Accounting of cdata_wait is done only
on the sys_wait() path, where "wait" is "1".

> That is why I thought that ->exit_accounting_done should die, and
> __exit_signal() should always call __account_to_parent() to update
> cdata_acct.

"exit_accounting_done" is used to find out, if cumulative accounting has
already been done in the sys_wait() path. If it has not done and the
process reaps itself, __account_to_parent() is called in signal_exit().

I think it works as it currently is. But as already said, this probably
could be done better. At least your confusion seems to prove that :-)

>  > > Sorry for my ignorance. Probably I have not understood what happens, if
> > > > a thread group leader dies. My assumption was that then the whole thread
> > > > group dies.
> > >
> > > No. A thread group dies when the last thread dies. If a leader exits
> > > it becomes a zombie until all other sub-threads exit.
> >
> > That brought me to another question: Does this mean that the thread
> > group leader never changes and is always alive (at least as zombie) as
> > long as the thread group lives?
> 
> Yes. Except de_thread() can change the leader. The new leader is the
> thread which calls exec.

de_thread() is also a very interesting spot for accounting. The thread
that calls exec() gets a bit of the identity of the old thread group
leader e.g. PID and start time, but it keeps the old CPU times. This
looks strange to me.

Wouldn't it be better to either exchange the accounting data between old
and new leader or add the current accounting data of the new leader to
the signal struct and initialize them with zero again? Regarding the
implementation of my top command I would prefer the first solution.

What do you think?

> > > > Also I assumed that a parent can only be a thread group
> > > > leader.
> > >
> > > No. If a thread T does fork(), the child's ->real_parent is T, not
> > > T->group_leader. If T exits, we do not reparent its children to init
> > > (unless it is the last thread, of course), we pick another live
> > > thread in this thread group for reparenting.
> >
> > Ok, I hope that I understand now. So either we could set the acct_parent
> > to the thread group leader in fork(), or we use the new parent in the
> > thread group if there are live threads left, when a thread exits.
> >
> > Something like the following:
> >
> >  static void forget_original_parent(struct task_struct *father)
> >  {
> > +       struct pid_namespace *pid_ns = task_active_pid_ns(father);
> >         struct task_struct *p, *n, *reaper;
> >         LIST_HEAD(dead_children);
> >
> >         exit_ptrace(father);
> >
> >         reaper = find_new_reaper(father);
> >
> > +       list_for_each_entry_safe(p, n, &father->children_acct, sibling_acct) {
> > +               struct task_struct *t = p;
> > +               do {
> > +                       if (pid_ns->child_reaper == reaper)
> > +                               t->acct_parent = t->acct_parent->acct_parent;
> > +                       else
> > +                               t->acct_parent = reaper;
> > +               } while_each_thread(p, t);
> > +               list_move_tail(&p->sibling_acct,
> > +                              &p->acct_parent->children_acct);
> > +       }
> > +
> 
> I think you can simplify this, but  I am not sure right now.
> 
> First of all, ->acct_parent should be moved from task_struct to
> signal_struct. No need to initialize t->acct_parent unless t is
> the group leader (this means we can avoid do/while_each_thread
> loop during re-parenting, but de_thread needs another trivial
> change).
> No need to change forget_original_parent() at all, instead we
> can the single line
> 
> 	p->signal->acct_parent = father->signal->acct_parent;
> 
> to reparent_leader(), after the "if (same_thread_group())" check.
> 
> What do you think?

I think it is not that easy because we still have to maintain the
children_acct list. This list is used to reparent all the accounting
children to the new accounting parent.

But in principle you are right that acct_parent could be moved to the
signal_struct because we only have to change it, when a thread group
leader dies. Not sure if the code gets easier by this change because we
might have to do a lot of signal_struct locking. Let me check...

Michael

