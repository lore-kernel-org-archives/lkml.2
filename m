Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0LEM4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 07:56:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895Ab0LEM4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 07:56:46 -0500
Message-ID: <4CFB8BFA.4040100@redhat.com>
Date: Sun, 05 Dec 2010 14:56:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 3/3] kvm: use yield_to instead of sleep in kvm_vcpu_on_spin
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101202144516.45a0385d@annuminas.surriel.com>
In-Reply-To: <20101202144516.45a0385d@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2010 09:45 PM, Rik van Riel wrote:
> Instead of sleeping in kvm_vcpu_on_spin, which can cause gigantic
> slowdowns of certain workloads, we instead use yield_to to hand
> the rest of our timeslice to another vcpu in the same KVM guest.
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 80f17db..a6eeafc 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1880,18 +1880,53 @@ void kvm_resched(struct kvm_vcpu *vcpu)
>   }
>   EXPORT_SYMBOL_GPL(kvm_resched);
>
> -void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu)
> +void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>   {
> -	ktime_t expires;
> -	DEFINE_WAIT(wait);
> +	struct kvm *kvm = me->kvm;
> +	struct kvm_vcpu *vcpu;
> +	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
> +	int first_round = 1;
> +	int i;
>
> -	prepare_to_wait(&vcpu->wq,&wait, TASK_INTERRUPTIBLE);
> +	me->spinning = 1;
> +
> +	/*
> +	 * We boost the priority of a VCPU that is runnable but not
> +	 * currently running, because it got preempted by something
> +	 * else and called schedule in __vcpu_run.  Hopefully that
> +	 * VCPU is holding the lock that we need and will release it.
> +	 * We approximate round-robin by starting at the last boosted VCPU.
> +	 */
> + again:
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		struct task_struct *task = vcpu->task;
> +		if (first_round&&  i<  last_boosted_vcpu) {
> +			i = last_boosted_vcpu;
> +			continue;
> +		} else if (!first_round&&  i>  last_boosted_vcpu)
> +			break;
> +		if (vcpu == me)
> +			continue;
> +		if (vcpu->spinning)
> +			continue;

You may well want to wake up a spinner.  Suppose

   A takes a lock
   B preempts A
   B grabs a ticket, starts spinning, yields to A
   A releases lock
   A grabs ticket, starts spinning

at this point, we want A to yield to B, but it won't because of this check.

> +		if (!task)
> +			continue;
> +		if (waitqueue_active(&vcpu->wq))
> +			continue;
> +		if (task->flags&  PF_VCPU)
> +			continue;
> +		kvm->last_boosted_vcpu = i;
> +		yield_to(task);
> +		break;
> +	}

I think a random selection algorithm will be a better fit against 
special guest behaviour.

>
> -	/* Sleep for 100 us, and hope lock-holder got scheduled */
> -	expires = ktime_add_ns(ktime_get(), 100000UL);
> -	schedule_hrtimeout(&expires, HRTIMER_MODE_ABS);
> +	if (first_round&&  last_boosted_vcpu == kvm->last_boosted_vcpu) {
> +		/* We have not found anyone yet. */
> +		first_round = 0;
> +		goto again;

Need to guarantee termination.


-- 
error compiling committee.c: too many arguments to function

