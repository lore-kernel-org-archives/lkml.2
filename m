Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab2KZNnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:43:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab2KZNnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:43:17 -0500
Date: Mon, 26 Nov 2012 14:43:02 +0100
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, riel@redhat.com
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH V3 RFC 2/2] kvm: Handle yield_to failure return code for
 potential undercommit case
Message-ID: <20121126134301.GB9830@turtle.usersys.redhat.com>
References: <20121126120740.2595.33651.sendpatchset@codeblue>
 <20121126120804.2595.20280.sendpatchset@codeblue>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126120804.2595.20280.sendpatchset@codeblue>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 05:38:04PM +0530, Raghavendra K T wrote:
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> 
> yield_to returns -ESRCH, When source and target of yield_to
> run queue length is one. When we see three successive failures of
> yield_to we assume we are in potential undercommit case and abort
> from PLE handler.
> The assumption is backed by low probability of wrong decision
> for even worst case scenarios such as average runqueue length
> between 1 and 2.
> 
> note that we do not update last boosted vcpu in failure cases.
> Thank Avi for raising question on aborting after first fail from yield_to.
> 
> Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  virt/kvm/kvm_main.c |   26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index be70035..053f494 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1639,6 +1639,7 @@ bool kvm_vcpu_yield_to(struct kvm_vcpu *target)
>  {
>  	struct pid *pid;
>  	struct task_struct *task = NULL;
> +	bool ret = false;
>  
>  	rcu_read_lock();
>  	pid = rcu_dereference(target->pid);
> @@ -1646,17 +1647,15 @@ bool kvm_vcpu_yield_to(struct kvm_vcpu *target)
>  		task = get_pid_task(target->pid, PIDTYPE_PID);
>  	rcu_read_unlock();
>  	if (!task)
> -		return false;
> +		return ret;
>  	if (task->flags & PF_VCPU) {
>  		put_task_struct(task);
> -		return false;
> -	}
> -	if (yield_to(task, 1)) {
> -		put_task_struct(task);
> -		return true;
> +		return ret;
>  	}
> +	ret = yield_to(task, 1);
>  	put_task_struct(task);
> -	return false;
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_yield_to);
>  
> @@ -1697,12 +1696,14 @@ bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
>  	return eligible;
>  }
>  #endif
> +
>  void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>  {
>  	struct kvm *kvm = me->kvm;
>  	struct kvm_vcpu *vcpu;
>  	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
>  	int yielded = 0;
> +	int try = 3;
>  	int pass;
>  	int i;
>  
> @@ -1714,7 +1715,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>  	 * VCPU is holding the lock that we need and will release it.
>  	 * We approximate round-robin by starting at the last boosted VCPU.
>  	 */
> -	for (pass = 0; pass < 2 && !yielded; pass++) {
> +	for (pass = 0; pass < 2 && !yielded && try; pass++) {
>  		kvm_for_each_vcpu(i, vcpu, kvm) {
>  			if (!pass && i <= last_boosted_vcpu) {
>  				i = last_boosted_vcpu;
> @@ -1727,10 +1728,15 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>  				continue;
>  			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
>  				continue;
> -			if (kvm_vcpu_yield_to(vcpu)) {
> +
> +			yielded = kvm_vcpu_yield_to(vcpu);
> +			if (yielded > 0) {
>  				kvm->last_boosted_vcpu = i;
> -				yielded = 1;
>  				break;
> +			} else if (yielded < 0) {
> +				try--;
> +				if (!try)
> +					break;
>  			}
>  		}
>  	}
> 

The check done in patch 1/2 is done before the double_rq_lock, so it's
cheap. Now, this patch is to avoid doing too many get_pid_task calls. I
wonder if it would make more sense to change the vcpu state from tracking
the pid to tracking the task. If that was done, then I don't believe this
patch is necessary.

Rik,
for 34bb10b79de7 was there a reason pid was used instead of task?

Drew
