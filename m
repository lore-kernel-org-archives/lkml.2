Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab2IJUNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:13:24 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58610 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178Ab2IJUNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:13:22 -0400
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE
 handler
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
In-Reply-To: <1347297124.2124.42.camel@twins>
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
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Sep 2012 15:12:52 -0500
Message-ID: <1347307972.7332.78.camel@oc2024037011.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091020-7408-0000-0000-000008635D6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 19:12 +0200, Peter Zijlstra wrote:
> On Mon, 2012-09-10 at 22:26 +0530, Srikar Dronamraju wrote:
> > > +static bool __yield_to_candidate(struct task_struct *curr, struct task_struct *p)
> > > +{
> > > +     if (!curr->sched_class->yield_to_task)
> > > +             return false;
> > > +
> > > +     if (curr->sched_class != p->sched_class)
> > > +             return false;
> > 
> > 
> > Peter, 
> > 
> > Should we also add a check if the runq has a skip buddy (as pointed out
> > by Raghu) and return if the skip buddy is already set. 
> 
> Oh right, I missed that suggestion.. the performance improvement went
> from 81% to 139% using this, right?
> 
> It might make more sense to keep that separate, outside of this
> function, since its not a strict prerequisite.
> 
> > > 
> > > +     if (task_running(p_rq, p) || p->state)
> > > +             return false;
> > > +
> > > +     return true;
> > > +} 
> 
> 
> > > @@ -4323,6 +4340,10 @@ bool __sched yield_to(struct task_struct *p,
> > bool preempt)
> > >       rq = this_rq();
> > >  
> > >  again:
> > > +     /* optimistic test to avoid taking locks */
> > > +     if (!__yield_to_candidate(curr, p))
> > > +             goto out_irq;
> > > +
> 
> So add something like:
> 
> 	/* Optimistic, if we 'raced' with another yield_to(), don't bother */
> 	if (p_rq->cfs_rq->skip)
> 		goto out_irq;
> > 
> > 
> > >       p_rq = task_rq(p);
> > >       double_rq_lock(rq, p_rq);
> > 
> > 
> But I do have a question on this optimization though,.. Why do we check
> p_rq->cfs_rq->skip and not rq->cfs_rq->skip ?
> 
> That is, I'd like to see this thing explained a little better.
> 
> Does it go something like: p_rq is the runqueue of the task we'd like to
> yield to, rq is our own, they might be the same. If we have a ->skip,
> there's nothing we can do about it, OTOH p_rq having a ->skip and
> failing the yield_to() simply means us picking the next VCPU thread,
> which might be running on an entirely different cpu (rq) and could
> succeed?

Here's two new versions, both include a __yield_to_candidate(): "v3"
uses the check for p_rq->curr in guest mode, and "v4" uses the cfs_rq
skip check.  Raghu, I am not sure if this is exactly what you want
implemented in v4.

Results:
> ple on:           2552 +/- .70%
> ple on: w/fixv1:  4621 +/- 2.12%  (81% improvement)
> ple on: w/fixv2:  6115           (139% improvement)
               v3:  5735           (124% improvement)
	       v4:  4524	   (  3% regression)

Both patches included below

-Andrew

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fbf1fd0..0d98a67 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4820,6 +4820,23 @@ void __sched yield(void)
 }
 EXPORT_SYMBOL(yield);
 
+/*
+ * Tests preconditions required for sched_class::yield_to().
+ */
+static bool __yield_to_candidate(struct task_struct *curr, struct task_struct *p, struct rq *p_rq)
+{
+	if (!curr->sched_class->yield_to_task)
+		return false;
+
+	if (curr->sched_class != p->sched_class)
+		return false;
+
+	if (task_running(p_rq, p) || p->state)
+		return false;
+
+	return true;
+}
+
 /**
  * yield_to - yield the current processor to another thread in
  * your thread group, or accelerate that thread toward the
@@ -4844,20 +4861,27 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
 
 again:
 	p_rq = task_rq(p);
+
+	/* optimistic test to avoid taking locks */
+	if (!__yield_to_candidate(curr, p, p_rq))
+		goto out_irq;
+
+	/*
+	 * if the target task is not running, then only yield if the
+	 * current task is in guest mode
+	 */
+	if (!(p_rq->curr->flags & PF_VCPU))
+		goto out_irq;
+
 	double_rq_lock(rq, p_rq);
 	while (task_rq(p) != p_rq) {
 		double_rq_unlock(rq, p_rq);
 		goto again;
 	}
 
-	if (!curr->sched_class->yield_to_task)
-		goto out;
-
-	if (curr->sched_class != p->sched_class)
-		goto out;
-
-	if (task_running(p_rq, p) || p->state)
-		goto out;
+	/* validate state, holding p_rq ensures p's state cannot change */
+	if (!__yield_to_candidate(curr, p, p_rq))
+		goto out_unlock;
 
 	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
 	if (yielded) {
@@ -4877,8 +4901,9 @@ again:
 		rq->skip_clock_update = 0;
 	}
 
-out:
+out_unlock:
 	double_rq_unlock(rq, p_rq);
+out_irq:
 	local_irq_restore(flags);
 
 	if (yielded)



****************
v4:


diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fbf1fd0..2bec2ed 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4820,6 +4820,23 @@ void __sched yield(void)
 }
 EXPORT_SYMBOL(yield);
 
+/*
+ * Tests preconditions required for sched_class::yield_to().
+ */
+static bool __yield_to_candidate(struct task_struct *curr, struct task_struct *p, struct rq *p_rq)
+{
+	if (!curr->sched_class->yield_to_task)
+		return false;
+
+	if (curr->sched_class != p->sched_class)
+		return false;
+
+	if (task_running(p_rq, p) || p->state)
+		return false;
+
+	return true;
+}
+
 /**
  * yield_to - yield the current processor to another thread in
  * your thread group, or accelerate that thread toward the
@@ -4844,20 +4861,24 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
 
 again:
 	p_rq = task_rq(p);
+
+	/* optimistic test to avoid taking locks */
+	if (!__yield_to_candidate(curr, p, p_rq))
+		goto out_irq;
+
+	/* if a yield is in progress, skip */
+	if (p_rq->cfs.skip)
+		goto out_irq;
+
 	double_rq_lock(rq, p_rq);
 	while (task_rq(p) != p_rq) {
 		double_rq_unlock(rq, p_rq);
 		goto again;
 	}
 
-	if (!curr->sched_class->yield_to_task)
-		goto out;
-
-	if (curr->sched_class != p->sched_class)
-		goto out;
-
-	if (task_running(p_rq, p) || p->state)
-		goto out;
+	/* validate state, holding p_rq ensures p's state cannot change */
+	if (!__yield_to_candidate(curr, p, p_rq))
+		goto out_unlock;
 
 	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
 	if (yielded) {
@@ -4877,8 +4898,9 @@ again:
 		rq->skip_clock_update = 0;
 	}
 
-out:
+out_unlock:
 	double_rq_unlock(rq, p_rq);
+out_irq:
 	local_irq_restore(flags);
 
 	if (yielded)


