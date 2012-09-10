Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab2IJQEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:04:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51066 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab2IJQEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:04:14 -0400
Message-ID: <1347293035.2124.22.camel@twins>
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE
 handler
From: Peter Zijlstra <peterz@infradead.org>
To: habanero@linux.vnet.ibm.com
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Date: Mon, 10 Sep 2012 18:03:55 +0200
In-Reply-To: <1347283005.10325.55.camel@oc6622382223.ibm.com>
References: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com>
	 <500D2162.8010209@redhat.com>
	 <1347023509.10325.53.camel@oc6622382223.ibm.com>
	 <504A37B0.7020605@linux.vnet.ibm.com>
	 <1347046931.7332.51.camel@oc2024037011.ibm.com>
	 <20120908084345.GU30238@linux.vnet.ibm.com>
	 <1347283005.10325.55.camel@oc6622382223.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 08:16 -0500, Andrew Theurer wrote:
> > > @@ -4856,8 +4859,6 @@ again:
> > >     if (curr->sched_class != p->sched_class)
> > >             goto out;
> > > 
> > > -   if (task_running(p_rq, p) || p->state)
> > > -           goto out;
> > 
> > Is it possible that by this time the current thread takes double rq
> > lock, thread p could actually be running?  i.e is there merit to keep
> > this check around even with your similar check above?
> 
> I think that's a good idea.  I'll add that back in. 

Right, it needs to still be there, the test before acquiring p_rq is an
optimistic test to avoid work, but you have to still test it once you
acquire p_rq since the rest of the code relies on this not being so.

How about something like this instead.. ?

---
 kernel/sched/core.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c46a011..c9ecab2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4300,6 +4300,23 @@ void __sched yield(void)
 }
 EXPORT_SYMBOL(yield);
 
+/*
+ * Tests preconditions required for sched_class::yield_to().
+ */
+static bool __yield_to_candidate(struct task_struct *curr, struct task_struct *p)
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
@@ -4323,6 +4340,10 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
 	rq = this_rq();
 
 again:
+	/* optimistic test to avoid taking locks */
+	if (!__yield_to_candidate(curr, p))
+		goto out_irq;
+
 	p_rq = task_rq(p);
 	double_rq_lock(rq, p_rq);
 	while (task_rq(p) != p_rq) {
@@ -4330,14 +4351,9 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
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
+	if (!__yield_to_candidate(curr, p))
+		goto out_unlock;
 
 	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
 	if (yielded) {
@@ -4350,8 +4366,9 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
 			resched_task(p_rq->curr);
 	}
 
-out:
+out_unlock:
 	double_rq_unlock(rq, p_rq);
+out_irq:
 	local_irq_restore(flags);
 
 	if (yielded)

