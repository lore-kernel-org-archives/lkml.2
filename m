Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0JNNvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 09:51:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab0JNNvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 09:51:48 -0400
Date: Thu, 14 Oct 2010 15:47:16 +0200
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
Message-ID: <20101014134716.GA5187@redhat.com>
References: <20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com> <20100927165133.GA23535@redhat.com> <20100929191916.21E1840038@magilla.sf.frob.com> <1285854460.1856.14.camel@holzheu-laptop> <20101005085751.4490A401B2@magilla.sf.frob.com> <1286357350.1888.25.camel@holzheu-laptop> <20101006152609.GA21169@redhat.com> <1286464017.1849.120.camel@holzheu-laptop> <20101011123704.GA3519@redhat.com> <1286889057.1932.77.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286889057.1932.77.camel@holzheu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael, sorry for delay...

On 10/12, Michael Holzheu wrote:
>
> On Mon, 2010-10-11 at 14:37 +0200, Oleg Nesterov wrote:
> >
> > > > Also, the logic behind ->exit_accounting_done looks wrong (and unneeded)
> > > > but I am not sure...
> > >
> > > I think the logic is correct,
> >
> > OK, I misread the patch as if we always account the exited task in
> > parent's cdata_acct,
> >
> > 	+       struct cdata cdata_wait; /* parents have done sys_wait() */
> > 	+       struct cdata cdata_acct; /* complete cumulative data from acct tree */
> >
> > while in fact the "complete" data is cdata_wait + cdata_acct.
>
> No. The complete data is in cdata_acct. It contains both, the task times
> where sys_wait() has been done and the task times, where the tasks have
> reaped themselves.

Hmm. This means my first understanding was correct. But now I am
confused again, see below.

> > Hmm. Let's return to your example above,
> >
> > 	> Snapshot 1: P1 -> P2 -> P3
> > 	> Snapshot 2: P1
> > 	> ...
> > 	> P1 got all the CPU time of P2 and P3
> >
> > Suppose that P2 dies before P3. Then P3 dies, /sbin/init does wait and
> > accounts this task. This means it is not accounted in P1->signal->cdata_acct,
> > no?
>
> No. __account_to_parent() with wait=1 is called when init waits for P3.
> Then both sets are updated cdata_acct and cdata_wait:
>
> +static void __account_to_parent(struct task_struct *p, int wait)
> +{
> +       if (wait)
> +               __account_ctime(p, &p->real_parent->signal->cdata_wait,
> +                               &p->signal->cdata_wait);
> +       __account_ctime(p, &p->acct_parent->signal->cdata_acct,
> +                       &p->signal->cdata_acct);
> +       p->exit_accounting_done = 1;
>
> If a tasks reaps itself, only cdata_acct is updated.

Yes. But __account_to_parent() always sets p->exit_accounting_done = 1.
And __exit_signal() calls __account_to_parent() only if it is not set.

This means that we update either cdata_wait (if the child was reaped
by parent) or cdata_acct (the process auto-reaps itself).

That is why I thought that ->exit_accounting_done should die, and
__exit_signal() should always call __account_to_parent() to update
cdata_acct.

Or I missed something? Confused ;)

 > > Sorry for my ignorance. Probably I have not understood what happens, if
> > > a thread group leader dies. My assumption was that then the whole thread
> > > group dies.
> >
> > No. A thread group dies when the last thread dies. If a leader exits
> > it becomes a zombie until all other sub-threads exit.
>
> That brought me to another question: Does this mean that the thread
> group leader never changes and is always alive (at least as zombie) as
> long as the thread group lives?

Yes. Except de_thread() can change the leader. The new leader is the
thread which calls exec.

> > > Also I assumed that a parent can only be a thread group
> > > leader.
> >
> > No. If a thread T does fork(), the child's ->real_parent is T, not
> > T->group_leader. If T exits, we do not reparent its children to init
> > (unless it is the last thread, of course), we pick another live
> > thread in this thread group for reparenting.
>
> Ok, I hope that I understand now. So either we could set the acct_parent
> to the thread group leader in fork(), or we use the new parent in the
> thread group if there are live threads left, when a thread exits.
>
> Something like the following:
>
>  static void forget_original_parent(struct task_struct *father)
>  {
> +       struct pid_namespace *pid_ns = task_active_pid_ns(father);
>         struct task_struct *p, *n, *reaper;
>         LIST_HEAD(dead_children);
>
>         exit_ptrace(father);
>
>         reaper = find_new_reaper(father);
>
> +       list_for_each_entry_safe(p, n, &father->children_acct, sibling_acct) {
> +               struct task_struct *t = p;
> +               do {
> +                       if (pid_ns->child_reaper == reaper)
> +                               t->acct_parent = t->acct_parent->acct_parent;
> +                       else
> +                               t->acct_parent = reaper;
> +               } while_each_thread(p, t);
> +               list_move_tail(&p->sibling_acct,
> +                              &p->acct_parent->children_acct);
> +       }
> +

I think you can simplify this, but  I am not sure right now.

First of all, ->acct_parent should be moved from task_struct to
signal_struct. No need to initialize t->acct_parent unless t is
the group leader (this means we can avoid do/while_each_thread
loop during re-parenting, but de_thread needs another trivial
change).


No need to change forget_original_parent() at all, instead we
can the single line

	p->signal->acct_parent = father->signal->acct_parent;

to reparent_leader(), after the "if (same_thread_group())" check.

What do you think?

Oleg.

