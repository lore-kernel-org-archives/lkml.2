Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0JLNLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:11:04 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:36933 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab0JLNLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:11:02 -0400
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
In-Reply-To: <20101011123704.GA3519@redhat.com>
References: <1285330688.2179.305.camel@holzheu-laptop>
	 <20100926181127.GA26985@redhat.com>
	 <20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com>
	 <20100927165133.GA23535@redhat.com>
	 <20100929191916.21E1840038@magilla.sf.frob.com>
	 <1285854460.1856.14.camel@holzheu-laptop>
	 <20101005085751.4490A401B2@magilla.sf.frob.com>
	 <1286357350.1888.25.camel@holzheu-laptop>
	 <20101006152609.GA21169@redhat.com>
	 <1286464017.1849.120.camel@holzheu-laptop>
	 <20101011123704.GA3519@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Tue, 12 Oct 2010 15:10:57 +0200
Message-ID: <1286889057.1932.77.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

First of all many thanks for all your time that you have spent for
reviewing the patches and giving us useful feedback!

On Mon, 2010-10-11 at 14:37 +0200, Oleg Nesterov wrote: 
> On 10/07, Michael Holzheu wrote:
> >
> > On Wed, 2010-10-06 at 17:26 +0200, Oleg Nesterov wrote:
> > >
> > > I am not sure I understand the "correct accounting" above. ->acct_parent
> > > adds the "parallel" hierarchy.
> >
> > Correct. The patch adds a "parallel" hierarchy that IMHO is better
> > suited for accounting purposes. For me the correct accounting hierarchy
> > means that cumulative time is passed along the real relationship tree.
> > That means if you have two task snapshots it is clear which tasks
> > inherited the time of the dead children. Example:
> >
> > P1 is parent of P2 is parent of P3
> >
> > Snapshot 1: P1 -> P2 -> P3
> > Snapshot 2: P1
> >
> > We know that P2 and P3 died in the last interval. With the current
> > cumulative time accounting we can't say, if P1 got the CPU time of P3
> > (if P3 died before P2) or if init got the time (if P2 died before P3).
> > With my patch we know that P1 got all the CPU time of P2 and P3.
> 
> Yes, I see what the patch does.
> 
> (but "P1 got all the CPU time of P2 and P3" doesn't look 100% right,
>  see below).
> 
> Still I am not sure. First of all, again, this complicates the core
> kernel code for top. And note that this parallel hierarchy is not
> visible to userspace (it can only see the "side effects" in cdata_acct).

In order to make everything work with my top command, we have to make
the new hierarchy visible to userspace. We would have to include
acct_parent->tgid in taskstats. Maybe one more reason for not doing
it ...

> But more importanly, I do not understand why this is always better.
> Say, if the task does daemonize(), it wants to become the child
> of init, and imho in this case it should be accounted accordinly.

Hmmm, sure... You can say if a daemon detaches itself, it is explicitly
wanted that it should be accounted to init. My argumentation with the
parallel tree is that the tasks (and their older relatives) that started
other tasks are responsible for taking the CPU time of their children
and grandchildren. That might not be what is wanted in case of
daemonize().

The main advantage of the new hierarchy compared to the old one is that
if you have two snapshots, you can always clearly say which relative has
gotten the CPU time of dead tasks. As stated earlier we can achieve that
also by capturing the reparent events in userspace. Maybe I should make
a patch for that. Do you think that could be an acceptable alternative? 

If that also is not acceptable, we have to capture all task exit events
between two snapshots. But this can be a lot of overhead for accounting.

> This also means __account_to_parent() should take ->siglock itself.
> 
> Probably this is a matter of taste, but I do not understand why
> __account_to_parent() takes the boolean "wait" argument. The caller
> can just pass the correct task_struct* which is either ->real_parent
> or ->acct_parent.
> 
> > > Also, the logic behind ->exit_accounting_done looks wrong (and unneeded)
> > > but I am not sure...
> >
> > I think the logic is correct,
> 
> OK, I misread the patch as if we always account the exited task in
> parent's cdata_acct,
> 
> 	+       struct cdata cdata_wait; /* parents have done sys_wait() */
> 	+       struct cdata cdata_acct; /* complete cumulative data from acct tree */
> 
> while in fact the "complete" data is cdata_wait + cdata_acct.

No. The complete data is in cdata_acct. It contains both, the task times
where sys_wait() has been done and the task times, where the tasks have
reaped themselves.

> Hmm. Let's return to your example above,
> 
> 	> Snapshot 1: P1 -> P2 -> P3
> 	> Snapshot 2: P1
> 	> ...
> 	> P1 got all the CPU time of P2 and P3
> 
> Suppose that P2 dies before P3. Then P3 dies, /sbin/init does wait and
> accounts this task. This means it is not accounted in P1->signal->cdata_acct,
> no?

No. __account_to_parent() with wait=1 is called when init waits for P3.
Then both sets are updated cdata_acct and cdata_wait:

+static void __account_to_parent(struct task_struct *p, int wait)
+{
+       if (wait)
+               __account_ctime(p, &p->real_parent->signal->cdata_wait,
+                               &p->signal->cdata_wait);
+       __account_ctime(p, &p->acct_parent->signal->cdata_acct,
+                       &p->signal->cdata_acct);
+       p->exit_accounting_done = 1;

If a tasks reaps itself, only cdata_acct is updated.

> > > > @@ -772,6 +869,15 @@ static void forget_original_parent(struc
> > > >  	LIST_HEAD(dead_children);
> > > >
> > > >  	write_lock_irq(&tasklist_lock);
> > > > +	list_for_each_entry_safe(p, n, &father->children_acct, sibling_acct) {
> > > > +		struct task_struct *t = p;
> > > > +		do {
> > > > +			t->acct_parent = t->acct_parent->acct_parent;
> > > > +		} while_each_thread(p, t);
> > > > +		list_move_tail(&p->sibling_acct,
> > > > +			       &p->acct_parent->children_acct);
> > >
> > > This is certainly wrong if there are other live threads in father's
> > > thread-group.
> >
> > Sorry for my ignorance. Probably I have not understood what happens, if
> > a thread group leader dies. My assumption was that then the whole thread
> > group dies.
> 
> No. A thread group dies when the last thread dies. If a leader exits
> it becomes a zombie until all other sub-threads exit.

That brought me to another question: Does this mean that the thread
group leader never changes and is always alive (at least as zombie) as
long as the thread group lives?

> > Also I assumed that a parent can only be a thread group
> > leader.
> 
> No. If a thread T does fork(), the child's ->real_parent is T, not
> T->group_leader. If T exits, we do not reparent its children to init
> (unless it is the last thread, of course), we pick another live
> thread in this thread group for reparenting.

Ok, I hope that I understand now. So either we could set the acct_parent
to the thread group leader in fork(), or we use the new parent in the
thread group if there are live threads left, when a thread exits.

Something like the following:

 static void forget_original_parent(struct task_struct *father)
 {
+       struct pid_namespace *pid_ns = task_active_pid_ns(father);
        struct task_struct *p, *n, *reaper;
        LIST_HEAD(dead_children);

        exit_ptrace(father);

        reaper = find_new_reaper(father);

+       list_for_each_entry_safe(p, n, &father->children_acct, sibling_acct) {
+               struct task_struct *t = p;
+               do {
+                       if (pid_ns->child_reaper == reaper)
+                               t->acct_parent = t->acct_parent->acct_parent;
+                       else
+                               t->acct_parent = reaper;
+               } while_each_thread(p, t);
+               list_move_tail(&p->sibling_acct,
+                              &p->acct_parent->children_acct);
+       }
+

Michael

