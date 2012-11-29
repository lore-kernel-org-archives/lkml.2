Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab2K2CBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:01:19 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48284 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab2K2CBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:01:17 -0500
Subject: Re: [PATCH V3 RFC 1/2] sched: Bail out of yield_to when source and
 target runqueue has one task
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Chegu Vinod <chegu_vinod@hp.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
In-Reply-To: <50B68F94.3080907@hp.com>
References: <20121126120740.2595.33651.sendpatchset@codeblue>
	 <20121126120754.2595.37316.sendpatchset@codeblue>
	 <20121126133501.GA9830@turtle.usersys.redhat.com>
	 <50B49658.7080507@linux.vnet.ibm.com> <50B4CCC8.60401@hp.com>
	 <50B68F94.3080907@hp.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 28 Nov 2012 20:00:54 -0600
Message-ID: <1354154454.31820.912.camel@oc6622382223.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112902-7606-0000-0000-000005E624AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-28 at 14:26 -0800, Chegu Vinod wrote:
> On 11/27/2012 6:23 AM, Chegu Vinod wrote:
> 
> > On 11/27/2012 2:30 AM, Raghavendra K T wrote: 
> > > On 11/26/2012 07:05 PM, Andrew Jones wrote: 
> > > > On Mon, Nov 26, 2012 at 05:37:54PM +0530, Raghavendra K T
> > > > wrote: 
> > > > > From: Peter Zijlstra <peterz@infradead.org> 
> > > > > 
> > > > > In case of undercomitted scenarios, especially in large
> > > > > guests 
> > > > > yield_to overhead is significantly high. when run queue length
> > > > > of 
> > > > > source and target is one, take an opportunity to bail out and
> > > > > return 
> > > > > -ESRCH. This return condition can be further exploited to
> > > > > quickly come 
> > > > > out of PLE handler. 
> > > > > 
> > > > > (History: Raghavendra initially worked on break out of kvm ple
> > > > > handler upon 
> > > > >   seeing source runqueue length = 1, but it had to export rq
> > > > > length). 
> > > > >   Peter came up with the elegant idea of return -ESRCH in
> > > > > scheduler core. 
> > > > > 
> > > > > Signed-off-by: Peter Zijlstra <peterz@infradead.org> 
> > > > > Raghavendra, Checking the rq length of target vcpu condition
> > > > > added.(thanks Avi) 
> > > > > Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com> 
> > > > > Signed-off-by: Raghavendra K T
> > > > > <raghavendra.kt@linux.vnet.ibm.com> 
> > > > > --- 
> > > > > 
> > > > >   kernel/sched/core.c |   25 +++++++++++++++++++------ 
> > > > >   1 file changed, 19 insertions(+), 6 deletions(-) 
> > > > > 
> > > > > diff --git a/kernel/sched/core.c b/kernel/sched/core.c 
> > > > > index 2d8927f..fc219a5 100644 
> > > > > --- a/kernel/sched/core.c 
> > > > > +++ b/kernel/sched/core.c 
> > > > > @@ -4289,7 +4289,10 @@ EXPORT_SYMBOL(yield); 
> > > > >    * It's the caller's job to ensure that the target task
> > > > > struct 
> > > > >    * can't go away on us before we can do any checks. 
> > > > >    * 
> > > > > - * Returns true if we indeed boosted the target task. 
> > > > > + * Returns: 
> > > > > + *    true (>0) if we indeed boosted the target task. 
> > > > > + *    false (0) if we failed to boost the target. 
> > > > > + *    -ESRCH if there's no task to yield to. 
> > > > >    */ 
> > > > >   bool __sched yield_to(struct task_struct *p, bool preempt) 
> > > > >   { 
> > > > > @@ -4303,6 +4306,15 @@ bool __sched yield_to(struct
> > > > > task_struct *p, bool preempt) 
> > > > > 
> > > > >   again: 
> > > > >       p_rq = task_rq(p); 
> > > > > +    /* 
> > > > > +     * If we're the only runnable task on the rq and target
> > > > > rq also 
> > > > > +     * has only one task, there's absolutely no point in
> > > > > yielding. 
> > > > > +     */ 
> > > > > +    if (rq->nr_running == 1 && p_rq->nr_running == 1) { 
> > > > > +        yielded = -ESRCH; 
> > > > > +        goto out_irq; 
> > > > > +    } 
> > > > > + 
> > > > >       double_rq_lock(rq, p_rq); 
> > > > >       while (task_rq(p) != p_rq) { 
> > > > >           double_rq_unlock(rq, p_rq); 
> > > > > @@ -4310,13 +4322,13 @@ again: 
> > > > >       } 
> > > > > 
> > > > >       if (!curr->sched_class->yield_to_task) 
> > > > > -        goto out; 
> > > > > +        goto out_unlock; 
> > > > > 
> > > > >       if (curr->sched_class != p->sched_class) 
> > > > > -        goto out; 
> > > > > +        goto out_unlock; 
> > > > > 
> > > > >       if (task_running(p_rq, p) || p->state) 
> > > > > -        goto out; 
> > > > > +        goto out_unlock; 
> > > > > 
> > > > >       yielded = curr->sched_class->yield_to_task(rq, p,
> > > > > preempt); 
> > > > >       if (yielded) { 
> > > > > @@ -4329,11 +4341,12 @@ again: 
> > > > >               resched_task(p_rq->curr); 
> > > > >       } 
> > > > > 
> > > > > -out: 
> > > > > +out_unlock: 
> > > > >       double_rq_unlock(rq, p_rq); 
> > > > > +out_irq: 
> > > > >       local_irq_restore(flags); 
> > > > > 
> > > > > -    if (yielded) 
> > > > > +    if (yielded > 0) 
> > > > >           schedule(); 
> > > > > 
> > > > >       return yielded; 
> > > > > 
> > > > 
> > > > Acked-by: Andrew Jones <drjones@redhat.com> 
> > > > 
> > > 
> > > Thank you Drew. 
> > > 
> > > Marcelo Gleb.. Please let me know if you have comments / concerns
> > > on the patches.. 
> > > 
> > > Andrew, Vinod, IMO, the patch set looks good for undercommit
> > > scenarios 
> > > especially for large guests where we do have overhead of vcpu
> > > iteration 
> > > of ple handler.. 
> > > 
> > > . 
> > > 
> > Thanks Raghu. Will try to get this latest patch set evaluated and
> > get back to you. 
> > 
> > 
> Hi Raghu,
> 
> Here is some preliminary data with your latest set of  PLE patches (&
> also with Andrew's throttled yield_to() change).
> 
> Ran a single guest on a 80 core Westmere platform. [Note: Host and
> Guest had the latest kernel from kvm.git and also using the latest
>  qemu from qemu.git as of yesterday morning]. 
> 
> The guest was running a AIM7 high_systime workload. (Note:
> high_systime is a kernel intensive micro-benchmark but in this case it
> was run just as a workload in the guest to trigger spinlock etc.
> contention in the guest OS and hence PLE (i.e. this is not a real
> benchmark run). 'have run this workload with a constant # (i.e. 2000)
> users with 100 jobs per user. The numbers below represent the # of
> jobs per minute (JPM) -  higher the better) .
> 
>                              40VCPU  60VCPU  80VCPU 
> 
> a) 3.7.0-rc6+ w/ ple_gap=0   ~102K   ~88K    ~81K
> 
> b) 3.7.0-rc6+                 ~53K   ~25K    ~18-20K

> c) 3.7.0-rc6+ w/ PLE patches ~100K   ~81K    ~48K-69K  <- lot of variation from run to run.
> 
> d) 3.7.0-rc6+ w/  throttled  ~101K   ~87K    ~78K
>           yield_to() change
> 

FYI here's the latest throttled yield_to() patch (the one Vinod tested).

Signed-off-by: Andrew Theurer <habanero@linux.vnet.ibm.com>

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ecc5543..61d12ea 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -192,6 +192,7 @@ struct kvm_vcpu {
 	int mode;
 	unsigned long requests;
 	unsigned long guest_debug;
+	unsigned long last_yield_to;
 
 	struct mutex mutex;
 	struct kvm_run *run;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index be70035..987a339 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -49,6 +49,7 @@
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/bsearch.h>
+#include <linux/jiffies.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -222,6 +223,7 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
 	vcpu->pid = NULL;
+	vcpu->last_yield_to = 0;
 	init_waitqueue_head(&vcpu->wq);
 	kvm_async_pf_vcpu_init(vcpu);
 
@@ -1708,29 +1710,38 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 
 	kvm_vcpu_set_in_spin_loop(me, true);
 	/*
+	 * A yield_to() can be quite expensive, so we try to limit
+	 * its use to just 1 per jiffie.
+	 */
+	if (me->last_yield_to == jiffies)
+		yield();
+	else {
+	/*
 	 * We boost the priority of a VCPU that is runnable but not
 	 * currently running, because it got preempted by something
 	 * else and called schedule in __vcpu_run.  Hopefully that
 	 * VCPU is holding the lock that we need and will release it.
 	 * We approximate round-robin by starting at the last boosted VCPU.
 	 */
-	for (pass = 0; pass < 2 && !yielded; pass++) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			if (!pass && i <= last_boosted_vcpu) {
-				i = last_boosted_vcpu;
-				continue;
-			} else if (pass && i > last_boosted_vcpu)
-				break;
-			if (vcpu == me)
-				continue;
-			if (waitqueue_active(&vcpu->wq))
-				continue;
-			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
-				continue;
-			if (kvm_vcpu_yield_to(vcpu)) {
-				kvm->last_boosted_vcpu = i;
-				yielded = 1;
-				break;
+		for (pass = 0; pass < 2 && !yielded; pass++) {
+			kvm_for_each_vcpu(i, vcpu, kvm) {
+				if (!pass && i <= last_boosted_vcpu) {
+					i = last_boosted_vcpu;
+					continue;
+				} else if (pass && i > last_boosted_vcpu)
+					break;
+				if (vcpu == me)
+					continue;
+				if (waitqueue_active(&vcpu->wq))
+					continue;
+				if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
+					continue;
+				if (kvm_vcpu_yield_to(vcpu)) {
+					kvm->last_boosted_vcpu = i;
+					me->last_yield_to = jiffies;
+					yielded = 1;
+					break;
+				}
 			}
 		}
 	}



