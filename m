Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab2IKS2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:28:03 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50913 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab2IKS17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:27:59 -0400
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE
 handler
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
In-Reply-To: <504ED54E.6040608@linux.vnet.ibm.com>
References: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com>
	 <500D2162.8010209@redhat.com>
	 <1347023509.10325.53.camel@oc6622382223.ibm.com>
	 <504A37B0.7020605@linux.vnet.ibm.com>
	 <1347046931.7332.51.camel@oc2024037011.ibm.com>
	 <20120908084345.GU30238@linux.vnet.ibm.com>
	 <1347283005.10325.55.camel@oc6622382223.ibm.com>
	 <1347293035.2124.22.camel@twins>
	 <20120910165653.GA28033@linux.vnet.ibm.com>
	 <1347297124.2124.42.camel@twins>
	 <1347307972.7332.78.camel@oc2024037011.ibm.com>
	 <504ED54E.6040608@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Sep 2012 13:27:41 -0500
Message-ID: <1347388061.19098.20.camel@oc2024037011.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091118-5806-0000-0000-0000197C7E5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-11 at 11:38 +0530, Raghavendra K T wrote:
> On 09/11/2012 01:42 AM, Andrew Theurer wrote:
> > On Mon, 2012-09-10 at 19:12 +0200, Peter Zijlstra wrote:
> >> On Mon, 2012-09-10 at 22:26 +0530, Srikar Dronamraju wrote:
> >>>> +static bool __yield_to_candidate(struct task_struct *curr, struct task_struct *p)
> >>>> +{
> >>>> +     if (!curr->sched_class->yield_to_task)
> >>>> +             return false;
> >>>> +
> >>>> +     if (curr->sched_class != p->sched_class)
> >>>> +             return false;
> >>>
> >>>
> >>> Peter,
> >>>
> >>> Should we also add a check if the runq has a skip buddy (as pointed out
> >>> by Raghu) and return if the skip buddy is already set.
> >>
> >> Oh right, I missed that suggestion.. the performance improvement went
> >> from 81% to 139% using this, right?
> >>
> >> It might make more sense to keep that separate, outside of this
> >> function, since its not a strict prerequisite.
> >>
> >>>>
> >>>> +     if (task_running(p_rq, p) || p->state)
> >>>> +             return false;
> >>>> +
> >>>> +     return true;
> >>>> +}
> >>
> >>
> >>>> @@ -4323,6 +4340,10 @@ bool __sched yield_to(struct task_struct *p,
> >>> bool preempt)
> >>>>        rq = this_rq();
> >>>>
> >>>>   again:
> >>>> +     /* optimistic test to avoid taking locks */
> >>>> +     if (!__yield_to_candidate(curr, p))
> >>>> +             goto out_irq;
> >>>> +
> >>
> >> So add something like:
> >>
> >> 	/* Optimistic, if we 'raced' with another yield_to(), don't bother */
> >> 	if (p_rq->cfs_rq->skip)
> >> 		goto out_irq;
> >>>
> >>>
> >>>>        p_rq = task_rq(p);
> >>>>        double_rq_lock(rq, p_rq);
> >>>
> >>>
> >> But I do have a question on this optimization though,.. Why do we check
> >> p_rq->cfs_rq->skip and not rq->cfs_rq->skip ?
> >>
> >> That is, I'd like to see this thing explained a little better.
> >>
> >> Does it go something like: p_rq is the runqueue of the task we'd like to
> >> yield to, rq is our own, they might be the same. If we have a ->skip,
> >> there's nothing we can do about it, OTOH p_rq having a ->skip and
> >> failing the yield_to() simply means us picking the next VCPU thread,
> >> which might be running on an entirely different cpu (rq) and could
> >> succeed?
> >
> > Here's two new versions, both include a __yield_to_candidate(): "v3"
> > uses the check for p_rq->curr in guest mode, and "v4" uses the cfs_rq
> > skip check.  Raghu, I am not sure if this is exactly what you want
> > implemented in v4.
> >
> 
> Andrew, Yes that is what I had. I think there was a mis-understanding. 
> My intention was to if there is a directed_yield happened in runqueue 
> (say rqA), do not bother to directed yield to that. But unfortunately as 
> PeterZ pointed that would have resulted in setting next buddy of a 
> different run queue than rqA.
> So we can drop this "skip" idea. Pondering more over what to do? can we 
> use next buddy itself ... thinking..

As I mentioned earlier today, I did not have your changes from kvm.git
tree when I tested my changes.  Here are your changes and my changes
compared:

			  throughput in MB/sec

kvm_vcpu_on_spin changes:  4636 +/- 15.74%
yield_to changes:	   4515 +/- 12.73%

I would be inclined to stick with your changes which are kept in kvm
code.  I did try both combined, and did not get good results:

both changes:		   4074 +/- 19.12%

So, having both is probably not a good idea.  However, I feel like
there's more work to be done.  With no over-commit (10 VMs), total
throughput is 23427 +/- 2.76%.  A 2x over-commit will no doubt have some
overhead, but a reduction to ~4500 is still terrible.  By contrast,
8-way VMs with 2x over-commit have a total throughput roughly 10% less
than 8-way VMs with no overcommit (20 vs 10 8-way VMs on 80 cpu-thread
host).  We still have what appears to be scalability problems, but now
it's not so much in runqueue locks for yield_to(), but now
get_pid_task():

perf on host:

32.10% 320131 qemu-system-x86 [kernel.kallsyms] [k] get_pid_task
11.60% 115686 qemu-system-x86 [kernel.kallsyms] [k] _raw_spin_lock
10.28% 102522 qemu-system-x86 [kernel.kallsyms] [k] yield_to
 9.17%  91507 qemu-system-x86 [kvm]             [k] kvm_vcpu_on_spin
 7.74%  77257 qemu-system-x86 [kvm]             [k] kvm_vcpu_yield_to
 3.56%  35476 qemu-system-x86 [kernel.kallsyms] [k] __srcu_read_lock
 3.00%  29951 qemu-system-x86 [kvm]             [k] __vcpu_run
 2.93%  29268 qemu-system-x86 [kvm_intel]       [k] vmx_vcpu_run
 2.88%  28783 qemu-system-x86 [kvm]             [k] vcpu_enter_guest
 2.59%  25827 qemu-system-x86 [kernel.kallsyms] [k] __schedule
 1.40%  13976 qemu-system-x86 [kernel.kallsyms] [k] _raw_spin_lock_irq
 1.28%  12823 qemu-system-x86 [kernel.kallsyms] [k] resched_task
 1.14%  11376 qemu-system-x86 [kvm_intel]       [k] vmcs_writel
 0.85%   8502 qemu-system-x86 [kernel.kallsyms] [k] pick_next_task_fair
 0.53%   5315 qemu-system-x86 [kernel.kallsyms] [k] native_write_msr_safe
 0.46%   4553 qemu-system-x86 [kernel.kallsyms] [k] native_load_tr_desc

get_pid_task() uses some rcu fucntions, wondering how scalable this
is....  I tend to think of rcu as -not- having issues like this... is
there a rcu stat/tracing tool which would help identify potential
problems?

-Andrew

