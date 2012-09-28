Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab2I1GUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:20:32 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:51265 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2I1GUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:20:31 -0400
Message-ID: <506540C7.9070105@linux.vnet.ibm.com>
Date: Fri, 28 Sep 2012 11:46:39 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jiannan Ouyang <ouyang@cs.pitt.edu>
CC: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com> <5060851E.1030404@redhat.com> <506166B4.4010207@linux.vnet.ibm.com> <5061713D.5060406@redhat.com> <CAJocwcf+8u84_yDC-PK0Yni93YSTWzYvr69nq6b3pNv1MwVJzQ@mail.gmail.com> <50641356.5070008@redhat.com> <CAJocwcc19F+PtsQ5okGMvYeVnkEigpZRpwWY9JgeRPFqfcVoXA@mail.gmail.com>
In-Reply-To: <CAJocwcc19F+PtsQ5okGMvYeVnkEigpZRpwWY9JgeRPFqfcVoXA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092806-8878-0000-0000-0000042C41AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 02:37 AM, Jiannan Ouyang wrote:
>
>
> On Thu, Sep 27, 2012 at 4:50 AM, Avi Kivity <avi@redhat.com
> <mailto:avi@redhat.com>> wrote:
>
>     On 09/25/2012 04:43 PM, Jiannan Ouyang wrote:
>      > I've actually implemented this preempted_bitmap idea.
>
>     Interesting, please share the code if you can.
>
>      > However, I'm doing this to expose this information to the guest,
>     so the
>      > guest is able to know if the lock holder is preempted or not before
>      > spining. Right now, I'm doing experiment to show that this idea
>     works.
>      >
>      > I'm wondering what do you guys think of the relationship between the
>      > pv_ticketlock approach and PLE handler approach. Are we going to
>     adopt
>      > PLE instead of the pv ticketlock, and why?
>
>     Right now we're searching for the best solution.  The tradeoffs are more
>     or less:
>
>     PLE:
>     - works for unmodified / non-Linux guests
>     - works for all types of spins (e.g. smp_call_function*())
>     - utilizes an existing hardware interface (PAUSE instruction) so likely
>     more robust compared to a software interface
>
>     PV:
>     - has more information, so it can perform better
>
>     Given these tradeoffs, if we can get PLE to work for moderate amounts of
>     overcommit then I'll prefer it (even if it slightly underperforms PV).
>     If we are unable to make it work well, then we'll have to add PV.
>
>     --
>     error compiling committee.c: too many arguments to function
>
>
> FYI. The preempted_bitmap patch.
>
> I delete some unrelated code in the generated patch file and seems
> broken the patch file format... I hope anyone could teach me some
> solutions.
> However, it's pretty straight forward, four things: declaration,
> initialization, set and clear. I think you guys can figure it out easily!
>
> As Avi sugguested, you could check task state TASK_RUNNING in sched_out.
>
> Signed-off-by: Jiannan Ouyang <ouyang@cs.pitt.edu
> <mailto:ouyang@cs.pitt.edu>>
>
> diff --git a/arch/x86/include/asm/
>
>     paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
>     index 8613cbb..4fcb648 100644
>     --- a/arch/x86/include/asm/paravirt_types.h
>     +++ b/arch/x86/include/asm/paravirt_types.h
>     @@ -73,6 +73,16 @@ struct pv_info {
>              const char *name;
>       };

I suppose we need this in common place since s390 also should have this,
if we are using this information in vcpu_on_spin()..

>
>     +struct pv_sched_info {
>     +       unsigned long   sched_bitmap;

Thinking, whether we need something similar to cpumask here?
Only thing is we are representing guest (v)cpumask.

>     +} __attribute__((__packed__));
>     +
>       struct pv_init_ops {
>              /*
>               * Patch may replace one of the defined code sequences with
>     diff --git a/arch/x86/kernel/paravirt-spinlocks.c
>     b/arch/x86/kernel/paravirt-spinlocks.c
>     index 676b8c7..2242d22 100644
>     --- a/arch/x86/kernel/paravirt-spinlocks.c
>     +++ b/arch/x86/kernel/paravirt-spinlocks.c
>
>     +struct pv_sched_info pv_sched_info = {
>     +        .sched_bitmap = (unsigned long)-1,
>     +};
>     diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>     index 44ee712..3eb277e 100644
>     --- a/virt/kvm/kvm_main.c
>     +++ b/virt/kvm/kvm_main.c
>     @@ -494,6 +494,11 @@ static struct kvm *kvm_create_vm(unsigned long
>     type)
>              mutex_init(&kvm->slots_lock);
>              atomic_set(&kvm->users_count, 1);
>
>     +#ifdef CONFIG_PARAVIRT_SPINLOCKS
>     +        kvm->pv_sched_info.sched_bitmap = (unsigned long)-1;
>     +#endif
>     +
>              r = kvm_init_mmu_notifier(kvm);
>              if (r)
>                      goto out_err;
>     @@ -2697,7 +2702,13 @@ struct kvm_vcpu
>     *preempt_notifier_to_vcpu(struct preempt_notifier *pn)
>       static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
>       {
>              struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
>
>     +       set_bit(vcpu->vcpu_id, &vcpu->kvm->pv_sched_info.sched_bitmap);
>              kvm_arch_vcpu_load(vcpu, cpu);
>       }
>
>     @@ -2705,7 +2716,13 @@ static void kvm_sched_out(struct
>     preempt_notifier *pn,
>                                struct task_struct *next)
>       {
>              struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
>
>     +       clear_bit(vcpu->vcpu_id,
>     &vcpu->kvm->pv_sched_info.sched_bitmap);
>              kvm_arch_vcpu_put(vcpu);
>       }

