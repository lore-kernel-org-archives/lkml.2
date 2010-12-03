Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab0LCCZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 21:25:15 -0500
Received: from sous-sol.org ([216.99.217.87]:43583 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755654Ab0LCCZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 21:25:13 -0500
Date: Thu, 2 Dec 2010 18:24:18 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 3/3] kvm: use yield_to instead of sleep in
 kvm_vcpu_on_spin
Message-ID: <20101203022418.GW10050@sequoia.sous-sol.org>
References: <20101202144129.4357fe00@annuminas.surriel.com>
 <20101202144516.45a0385d@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202144516.45a0385d@annuminas.surriel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel (riel@redhat.com) wrote:
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1880,18 +1880,53 @@ void kvm_resched(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_resched);
>  
> -void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu)
> +void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>  {
> -	ktime_t expires;
> -	DEFINE_WAIT(wait);
> +	struct kvm *kvm = me->kvm;
> +	struct kvm_vcpu *vcpu;
> +	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;

s/me->//

> +	int first_round = 1;
> +	int i;
>  
> -	prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
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
> +		if (first_round && i < last_boosted_vcpu) {
> +			i = last_boosted_vcpu;
> +			continue;
> +		} else if (!first_round && i > last_boosted_vcpu)
> +			break;
> +		if (vcpu == me)
> +			continue;
> +		if (vcpu->spinning)
> +			continue;
> +		if (!task)
> +			continue;
> +		if (waitqueue_active(&vcpu->wq))
> +			continue;
> +		if (task->flags & PF_VCPU)
> +			continue;

I wonder if you set vcpu->task in sched_out and then NULL it in sched_in
if you'd get what you want you could simplify the checks.  Basically
that would be only the preempted runnable vcpus.

> +		kvm->last_boosted_vcpu = i;
> +		yield_to(task);

Just trying to think of ways to be sure this doesn't become just
yield() (although I thnk PF_VCPU is enough to catch that).
