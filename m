Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab2IZM5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 08:57:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab2IZM5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 08:57:45 -0400
Date: Wed, 26 Sep 2012 14:57:28 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
Message-ID: <20120926125727.GA7633@turtle.usersys.redhat.com>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
 <1348486479.11847.46.camel@twins>
 <50604988.2030506@linux.vnet.ibm.com>
 <1348490165.11847.58.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348490165.11847.58.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 02:36:05PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-09-24 at 17:22 +0530, Raghavendra K T wrote:
> > On 09/24/2012 05:04 PM, Peter Zijlstra wrote:
> > > On Fri, 2012-09-21 at 17:29 +0530, Raghavendra K T wrote:
> > >> In some special scenarios like #vcpu<= #pcpu, PLE handler may
> > >> prove very costly, because there is no need to iterate over vcpus
> > >> and do unsuccessful yield_to burning CPU.
> > >
> > > What's the costly thing? The vm-exit, the yield (which should be a nop
> > > if its the only task there) or something else entirely?
> > >
> > Both vmexit and yield_to() actually,
> > 
> > because unsuccessful yield_to() overall is costly in PLE handler.
> > 
> > This is because when we have large guests, say 32/16 vcpus, and one
> > vcpu is holding lock, rest of the vcpus waiting for the lock, when they
> > do PL-exit, each of the vcpu try to iterate over rest of vcpu list in
> > the VM and try to do directed yield (unsuccessful). (O(n^2) tries).
> > 
> > this results is fairly high amount of cpu burning and double run queue
> > lock contention.
> > 
> > (if they were spinning probably lock progress would have been faster).
> > As Avi/Chegu Vinod had felt it is better to avoid vmexit itself, which
> > seems little complex to achieve currently.
> 
> OK, so the vmexit stays and we need to improve yield_to.

Can't we do this check sooner as well, as it only requires per-cpu data?
If we do it way back in kvm_vcpu_on_spin, then we avoid get_pid_task()
and a bunch of read barriers from kvm_for_each_vcpu. Also, moving the test
into kvm code would allow us to do other kvm things as a result of the
check in order to avoid some vmexits. It looks like we should be able to
avoid some without much complexity by just making a per-vm ple_window
variable, and then, when we hit the nr_running == 1 condition, also doing
vmcs_write32(PLE_WINDOW, (kvm->ple_window += PLE_WINDOW_BUMP))
Reset the window to the default value when we successfully yield (and
maybe we should limit the number of bumps).

Drew

> 
> How about something like the below, that would allow breaking out of the
> for-each-vcpu loop and simply going back into the vm, right?
> 
> ---
>  kernel/sched/core.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b38f00e..5d5b355 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4272,7 +4272,10 @@ EXPORT_SYMBOL(yield);
>   * It's the caller's job to ensure that the target task struct
>   * can't go away on us before we can do any checks.
>   *
> - * Returns true if we indeed boosted the target task.
> + * Returns:
> + *   true (>0) if we indeed boosted the target task.
> + *   false (0) if we failed to boost the target.
> + *   -ESRCH if there's no task to yield to.
>   */
>  bool __sched yield_to(struct task_struct *p, bool preempt)
>  {
> @@ -4284,6 +4287,15 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
>  	local_irq_save(flags);
>  	rq = this_rq();
>  
> +	/*
> +	 * If we're the only runnable task on the rq, there's absolutely no
> +	 * point in yielding.
> +	 */
> +	if (rq->nr_running == 1) {
> +		yielded = -ESRCH;
> +		goto out_irq;
> +	}
> +
>  again:
>  	p_rq = task_rq(p);
>  	double_rq_lock(rq, p_rq);
> @@ -4293,13 +4305,13 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
>  	}
>  
>  	if (!curr->sched_class->yield_to_task)
> -		goto out;
> +		goto out_unlock;
>  
>  	if (curr->sched_class != p->sched_class)
> -		goto out;
> +		goto out_unlock;
>  
>  	if (task_running(p_rq, p) || p->state)
> -		goto out;
> +		goto out_unlock;
>  
>  	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
>  	if (yielded) {
> @@ -4312,11 +4324,12 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
>  			resched_task(p_rq->curr);
>  	}
>  
> -out:
> +out_unlock:
>  	double_rq_unlock(rq, p_rq);
> +out_irq:
>  	local_irq_restore(flags);
>  
> -	if (yielded)
> +	if (yielded > 0)
>  		schedule();
>  
>  	return yielded;
> 
