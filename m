Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab0IXMST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:18:19 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:48730 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0IXMSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:18:17 -0400
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Oleg Nesterov <oleg@redhat.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100923171025.GA26623@redhat.com>
References: <1285249681.1837.28.camel@holzheu-laptop>
	 <1285250541.1837.95.camel@holzheu-laptop>
	 <20100923171025.GA26623@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Fri, 24 Sep 2010 14:18:08 +0200
Message-ID: <1285330688.2179.305.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

On Thu, 2010-09-23 at 19:10 +0200, Oleg Nesterov wrote:
> Sorry, I didn't look at other patches, but this one looks strange
> to me...
> 
> On 09/23, Michael Holzheu wrote:
> >
> > Currently there are code pathes (e.g. for kthreads) where the consumed
> > CPU time is not accounted to the parents cumulative counters.
> 
> Could you explain more?

I think one place was "khelper" (kmod.c). It is created with
kernel_thread() and it exits without having accounted the times with
sys_wait() to the parent's ctimes (see second kernel_thread() invocation
below in kmod.c):

        if (wait == UMH_WAIT_PROC)
                pid = kernel_thread(wait_for_helper, sub_info,
                                    CLONE_FS | CLONE_FILES | SIGCHLD);
        else
                pid = kernel_thread(____call_usermodehelper, sub_info,
                                    CLONE_VFORK | SIGCHLD);

<snip>

> >  void release_task(struct task_struct * p)
> >  {
> >  	struct task_struct *leader;
> >  	int zap_leader;
> > +
> > +	if (!p->exit_accounting_done)
> > +		account_to_parent(p);
> >  repeat:
> >  	tracehook_prepare_release_task(p);
> >  	/* don't need to get the RCU readlock here - the process is dead and
> > @@ -1279,6 +1313,7 @@
> >  			psig->cmaxrss = maxrss;
> >  		task_io_accounting_add(&psig->ioac, &p->ioac);
> >  		task_io_accounting_add(&psig->ioac, &sig->ioac);
> > +		p->exit_accounting_done = 1;
> 
> Can't understand.
> 
> Suppose that a thread T exits and reaps itself (calls release_task).
> Now we call account_to_parent() which accounts T->signal->XXX + T->XXX.
> After that T calls __exit_signal and does T->signal->XXX += T->XXX.
> 
> If another thread exits it does the same and we account the already
> exited thread T again?
> 
> When the last thread exits, wait_task_zombie() accounts T->signal
> once again.
> 
> IOW, this looks like the over-accounting to me, no?

I think you are right and this patch is not correct here.

I had the wrong idea, because I thought that for every exited thread the
parent will do a sys_wait() and the thread's CPU times will be added to
the parent's ctime. This happens only for the thread group leader,
correct? Other threads just exit and add their times to the signal
struct of the process in __exit_signal(). When a sys_wait() is done for
a dead thread group leader, all the times that have been accumulated in
the signal struct are added to the ctime fields of the waiting parent.

I wanted to use the cumulative times (cutime, cstime, csttime) for ptop
in order to show all consumed CPU time in the last interval.

E.g. for the case that between ptop snapshot 1 and 2 a task "X" forked
and also exited, ptop can't see this task, because it is neither in
snapshot 1 nor in snapshot 2. But ptop can still show X's consumed CPU
time in the interval by subtracting the cumulative times of X's parent.

If a task "Y" is in snapshot 1, but not in snapshot 2, we search for the
parent of "Y" and calculate it's ctimes for the last interval as follows
(user time in this example):

parent->cuser_diff =
  parent->snap2->cutime - Y->snap1->utime -                 
  Y->snap1->cutime - parent->snap1->cutime

The result is the CPU time that Y consumed in the last interval.

Example (ptop):

                          VVVVV  VVVV VVVV
   pid     user  sys  ste cuser  csys cste  total Elap+ Name
   (#)      (%)  (%)  (%)   (%)   (%)  (%)    (%)  (hm) (str)
   8374   75.48 0.41 1.34  0.00  0.00 0.00  77.24  0:01 loop
>> 10093   0.17 0.30 0.00 25.90 38.19 0.52  65.07  0:00 make <<

ptop shows cuser, csys and cste for the last interval. In this example
it is the time that dead children of "make" consumed in the last
interval.

Ok, the problem is that I did not consider exiting threads that are no
thread group leaders. When they exit the ctime of the parent is not
updated. Instead the time is accumulated in the signal struct.

To fix this we could also add the signal_struct times (e.g. tguser,
tgsys and tgste) to taskstats. When a task "Z" exits (is in snapshot 1,
but not in snapshot 2), we first check, if the thread group leader is
still in snapshot 2. If this is the case, we do the following
calculation:

tgleader->tguser_diff =
  tgleader->snap2->sig->utime - Z->snap1->utime -
  tgleader->snap1->sig->utime

If add CPU time diffs, cummulated parent diffs and thread group CPU time
diffs, we should get again 100% of the consumed CPU time in the last
ptop interval.

Does this make sense?

Michael

