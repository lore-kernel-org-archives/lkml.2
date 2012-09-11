Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab2IKHIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 03:08:41 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:45260 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab2IKHIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 03:08:39 -0400
Date: Tue, 11 Sep 2012 12:34:48 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: habanero@linux.vnet.ibm.com,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE
 handler
Message-ID: <20120911070448.GB28033@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1347297124.2124.42.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12091107-5816-0000-0000-00000466E340
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> 

Oh this made me look back at yield_to() again.  I had misread the
yield_to_task_fair() code. I had wrongly thought that both ->skip and
->next buddies for the p_rq would be set. But it looks like only ->next
for the p_rq is set and ->skip is set for rq.

This should also explains why Andrew saw a regression when checking for
->skip flag instead of PF_VCPU.

Can we check for p_rq->cfs.next and bail out if 


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
+	/* if next buddy is set, assume yield is in progress */
+	if (p_rq->cfs.next)
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


