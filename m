Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab0LEM6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 07:58:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380Ab0LEM6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 07:58:35 -0500
Message-ID: <4CFB8C66.9090508@redhat.com>
Date: Sun, 05 Dec 2010 14:58:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 3/3] kvm: use yield_to instead of sleep in kvm_vcpu_on_spin
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101202144516.45a0385d@annuminas.surriel.com> <20101203022418.GW10050@sequoia.sous-sol.org>
In-Reply-To: <20101203022418.GW10050@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 04:24 AM, Chris Wright wrote:
> * Rik van Riel (riel@redhat.com) wrote:
> >  --- a/virt/kvm/kvm_main.c
> >  +++ b/virt/kvm/kvm_main.c
> >  @@ -1880,18 +1880,53 @@ void kvm_resched(struct kvm_vcpu *vcpu)
> >   }
> >   EXPORT_SYMBOL_GPL(kvm_resched);
> >
> >  -void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu)
> >  +void kvm_vcpu_on_spin(struct kvm_vcpu *me)
> >   {
> >  -	ktime_t expires;
> >  -	DEFINE_WAIT(wait);
> >  +	struct kvm *kvm = me->kvm;
> >  +	struct kvm_vcpu *vcpu;
> >  +	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
>
> s/me->//
>
> >  +	int first_round = 1;
> >  +	int i;
> >
> >  -	prepare_to_wait(&vcpu->wq,&wait, TASK_INTERRUPTIBLE);
> >  +	me->spinning = 1;
> >  +
> >  +	/*
> >  +	 * We boost the priority of a VCPU that is runnable but not
> >  +	 * currently running, because it got preempted by something
> >  +	 * else and called schedule in __vcpu_run.  Hopefully that
> >  +	 * VCPU is holding the lock that we need and will release it.
> >  +	 * We approximate round-robin by starting at the last boosted VCPU.
> >  +	 */
> >  + again:
> >  +	kvm_for_each_vcpu(i, vcpu, kvm) {
> >  +		struct task_struct *task = vcpu->task;
> >  +		if (first_round&&  i<  last_boosted_vcpu) {
> >  +			i = last_boosted_vcpu;
> >  +			continue;
> >  +		} else if (!first_round&&  i>  last_boosted_vcpu)
> >  +			break;
> >  +		if (vcpu == me)
> >  +			continue;
> >  +		if (vcpu->spinning)
> >  +			continue;
> >  +		if (!task)
> >  +			continue;
> >  +		if (waitqueue_active(&vcpu->wq))
> >  +			continue;
> >  +		if (task->flags&  PF_VCPU)
> >  +			continue;
>
> I wonder if you set vcpu->task in sched_out and then NULL it in sched_in
> if you'd get what you want you could simplify the checks.  Basically
> that would be only the preempted runnable vcpus.

They may be sleeping due to some other reason (HLT, major page fault).

Better check is that the task is runnable but not running.  Can we get 
this information from a task?

-- 
error compiling committee.c: too many arguments to function

