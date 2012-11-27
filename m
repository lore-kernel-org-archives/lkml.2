Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab2K0NWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:22:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab2K0NWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:22:52 -0500
Date: Tue, 27 Nov 2012 14:22:27 +0100
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: riel@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH V3 RFC 2/2] kvm: Handle yield_to failure return code for
 potential undercommit case
Message-ID: <20121127132218.GA5336@turtle.usersys.redhat.com>
References: <20121126120740.2595.33651.sendpatchset@codeblue>
 <20121126120804.2595.20280.sendpatchset@codeblue>
 <20121126134301.GB9830@turtle.usersys.redhat.com>
 <50B4958D.104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B4958D.104@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 03:57:25PM +0530, Raghavendra K T wrote:
> On 11/26/2012 07:13 PM, Andrew Jones wrote:
> >On Mon, Nov 26, 2012 at 05:38:04PM +0530, Raghavendra K T wrote:
> >>From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> >>
> >>yield_to returns -ESRCH, When source and target of yield_to
> >>run queue length is one. When we see three successive failures of
> >>yield_to we assume we are in potential undercommit case and abort
> >>from PLE handler.
> >>The assumption is backed by low probability of wrong decision
> >>for even worst case scenarios such as average runqueue length
> >>between 1 and 2.
> >>
> >>note that we do not update last boosted vcpu in failure cases.
> >>Thank Avi for raising question on aborting after first fail from
> yield_to.
> >>
> >>Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> >>Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> >>---
> >>  virt/kvm/kvm_main.c |   26 ++++++++++++++++----------
> >>  1 file changed, 16 insertions(+), 10 deletions(-)
> >>
> >>diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >>index be70035..053f494 100644
> >>--- a/virt/kvm/kvm_main.c
> >>+++ b/virt/kvm/kvm_main.c
> >>@@ -1639,6 +1639,7 @@ bool kvm_vcpu_yield_to(struct kvm_vcpu *target)
> >>  {
> >>  	struct pid *pid;
> >>  	struct task_struct *task = NULL;
> >>+	bool ret = false;
> >>
> >>  	rcu_read_lock();
> >>  	pid = rcu_dereference(target->pid);
> >>@@ -1646,17 +1647,15 @@ bool kvm_vcpu_yield_to(struct kvm_vcpu *target)
> >>  		task = get_pid_task(target->pid, PIDTYPE_PID);
> >>  	rcu_read_unlock();
> >>  	if (!task)
> >>-		return false;
> >>+		return ret;
> >>  	if (task->flags & PF_VCPU) {
> >>  		put_task_struct(task);
> >>-		return false;
> >>-	}
> >>-	if (yield_to(task, 1)) {
> >>-		put_task_struct(task);
> >>-		return true;
> >>+		return ret;
> >>  	}
> >>+	ret = yield_to(task, 1);
> >>  	put_task_struct(task);
> >>-	return false;
> >>+
> >>+	return ret;
> >>  }
> >>  EXPORT_SYMBOL_GPL(kvm_vcpu_yield_to);
> >>
> >>@@ -1697,12 +1696,14 @@ bool
> kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
> >>  	return eligible;
> >>  }
> >>  #endif
> >>+
> >>  void kvm_vcpu_on_spin(struct kvm_vcpu *me)
> >>  {
> >>  	struct kvm *kvm = me->kvm;
> >>  	struct kvm_vcpu *vcpu;
> >>  	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
> >>  	int yielded = 0;
> >>+	int try = 3;
> >>  	int pass;
> >>  	int i;
> >>
> >>@@ -1714,7 +1715,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
> >>  	 * VCPU is holding the lock that we need and will release it.
> >>  	 * We approximate round-robin by starting at the last boosted VCPU.
> >>  	 */
> >>-	for (pass = 0; pass < 2 && !yielded; pass++) {
> >>+	for (pass = 0; pass < 2 && !yielded && try; pass++) {
> >>  		kvm_for_each_vcpu(i, vcpu, kvm) {
> >>  			if (!pass && i <= last_boosted_vcpu) {
> >>  				i = last_boosted_vcpu;
> >>@@ -1727,10 +1728,15 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
> >>  				continue;
> >>  			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
> >>  				continue;
> >>-			if (kvm_vcpu_yield_to(vcpu)) {
> >>+
> >>+			yielded = kvm_vcpu_yield_to(vcpu);
> >>+			if (yielded > 0) {
> >>  				kvm->last_boosted_vcpu = i;
> >>-				yielded = 1;
> >>  				break;
> >>+			} else if (yielded < 0) {
> >>+				try--;
> >>+				if (!try)
> >>+					break;
> >>  			}
> >>  		}
> >>  	}
> >>
> 
> Drew, Thanks for reviewing this.
> >
> >The check done in patch 1/2 is done before the double_rq_lock, so it's
> >cheap. Now, this patch is to avoid doing too many get_pid_task calls.I
> >wonder if it would make more sense to change the vcpu state from tracking
> >the pid to tracking the task. If that was done, then I don't believe this
> >patch is necessary.
> 
> We would need a logic not to break upon first failure of yield_to.
> (which happens otherwise with patch1 alone). Breaking upon first
> failure out of ple handler resulted in degradation in moderate
> overcommits due to false exits even when we have more than one task in
> other cpu run queues.
> 
> But your suggestion triggered an idea to me, what would be the cost of
> iterating over all vcpus despite of yield_to failure?
> 
> (Where we breakout of PLE handler only if we have successful yield
> i.e yielded > 0) with something like this:
> 
> -       for (pass = 0; pass < 2 && !yielded; pass++) {
> +       for (pass = 0; pass < 2 && yielded <=0 ; pass++) {
>                 kvm_for_each_vcpu(i, vcpu, kvm) {
>                         if (!pass && i <= last_boosted_vcpu) {
>                                 i = last_boosted_vcpu;
> @@ -1727,11 +1727,12 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>                                 continue;
>                         if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
>                                 continue;
> -                       if (kvm_vcpu_yield_to(vcpu)) {
> +
> +                       yielded = kvm_vcpu_yield_to(vcpu);
> +                       if (yielded > 0) {
>                                 kvm->last_boosted_vcpu = i;
> -                               yielded = 1;
>                                 break;
> 

OK, I had actually assumed that the first round of testing had been
implemented this way, but then the cost of get_pid_task() forced the
introduction of a try limit.

> Here is the result of the above patch w.r.t to base and current patch
> series.
> 
> benchmark     improvement w.r.t base   improvement w.r.t current patch
> ebizzy_1x      131.22287               -9.76%
> ebizzy_4x      -7.97198                -21.1%
> 
> dbench_1x       25.67077               -25.55%
> dbench_4x       -69.19086              -122.46%
> 
> 
> Current patches perform better. So this means iterating over vcpus
> has some overhead.  Though we have IMO for bigger machine with large
> guests, this is
> significant..
> 
> Let me know if this patch sounds good to you..
> 

It does was it advertises - reduces the impact of the vcpu-on-spin
loop for undercommit scenarios, so I'm ok with it.
