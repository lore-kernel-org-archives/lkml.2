Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0JSOWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:22:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab0JSOWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:22:36 -0400
Date: Tue, 19 Oct 2010 16:17:25 +0200
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
Message-ID: <20101019141725.GA32361@redhat.com>
References: <20100929191916.21E1840038@magilla.sf.frob.com> <1285854460.1856.14.camel@holzheu-laptop> <20101005085751.4490A401B2@magilla.sf.frob.com> <1286357350.1888.25.camel@holzheu-laptop> <20101006152609.GA21169@redhat.com> <1286464017.1849.120.camel@holzheu-laptop> <20101011123704.GA3519@redhat.com> <1286889057.1932.77.camel@holzheu-laptop> <20101014134716.GA5187@redhat.com> <1287153246.1896.231.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287153246.1896.231.camel@holzheu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15, Michael Holzheu wrote:
>
> On Thu, 2010-10-14 at 15:47 +0200, Oleg Nesterov wrote:
>
> > Yes. But __account_to_parent() always sets p->exit_accounting_done = 1.
> > And __exit_signal() calls __account_to_parent() only if it is not set.
> >
> > This means that we update either cdata_wait (if the child was reaped
> > by parent) or cdata_acct (the process auto-reaps itself).
>
> No. The accounting of cdata_acct is done unconditionally in
> __account_to_parent(). It is done for both cases wait=0 and wait=1,
> therefore no CPU time gets lost. Accounting of cdata_wait is done only
> on the sys_wait() path, where "wait" is "1".

Ah, got it, I didn't notice this detail.

Thanks.

> I think it works as it currently is. But as already said, this probably
> could be done better. At least your confusion seems to prove that :-)

Perhaps ;)

To me, it would be cleaner and simpler if you kill ->exit_accounting_done.
Both wait_task_zombie() and __exit_signal() could just call
__account_to_parent(parent_for_accounting) unconditionally passing
either real_parent or acct_parent as an argument. This also saves a
word in task_struct.

> de_thread() is also a very interesting spot for accounting. The thread
> that calls exec() gets a bit of the identity of the old thread group
> leader e.g. PID and start time, but it keeps the old CPU times. This
> looks strange to me.

Well, the main thread represents the whole process for ps/etc, that
is why we update ->start_time.

But,

> Wouldn't it be better to either exchange the accounting data between old
> and new leader

I dunno. The exiting old leader will update sig->utime/etc, so we do not
lose this info from the "whole process" pov. But yes, if user-space
looks at the single thread with that TGID it can notice that, say, utime
goes backward.

> or add the current accounting data of the new leader to
> the signal struct and initialize them with zero again?

Sorry, I don't understand this "initialize them with zero". What
is "them" ?

> > I think you can simplify this, but  I am not sure right now.
> >
> > First of all, ->acct_parent should be moved from task_struct to
> > signal_struct. No need to initialize t->acct_parent unless t is
> > the group leader (this means we can avoid do/while_each_thread
> > loop during re-parenting, but de_thread needs another trivial
> > change).
> > No need to change forget_original_parent() at all, instead we
> > can the single line
> >
> > 	p->signal->acct_parent = father->signal->acct_parent;
> >
> > to reparent_leader(), after the "if (same_thread_group())" check.
> >
> > What do you think?
>
> I think it is not that easy because we still have to maintain the
> children_acct list. This list is used to reparent all the accounting
> children to the new accounting parent.

Yes, sure, reparent_leader() should also do list_move_tail(acct_sibling),
I forget to mention this.

I guess you already understand this, but just in case. Please look at
sibling/children relationship. We do not add the sub-threads on
->children list, only the main thread.

However, every thread has its own ->parent and ->children, this is
because we have __WNOTHREAD. But acct-parenting doesn't have this
problem, only the main thread needs the properly initialized
->acct_parent, it is never needed until the whole process dies.

> But in principle you are right that acct_parent could be moved to the
> signal_struct because we only have to change it, when a thread group
> leader dies.

Yes. And if we move it into signal_struct, then we shouldn't worry
about updating it in de_thread().

However, de_thread() should do list_replace_init(leader->acct_sibling)
to add the new leader to acct_children.

I am not sure this really makes sense, but in fact you can move
->acct_sibling and ->acct_childen from task_struct to signal_struct
as well, note that you can trivially find the group leader looking
at signal->leader_pid. (actually, ->group_leader should be moved
to signal_struct, but this is another story). In this case de_thread()
needs no changes, and we save the space in task_struct.

Oleg.

