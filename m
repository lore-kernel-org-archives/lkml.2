Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab1BCM57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 07:57:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:49917 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab1BCM5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 07:57:48 -0500
Subject: Re: [PATCH -v8a 4/7] sched: Add yield_to(task, preempt)
 functionality
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
In-Reply-To: <20110201095051.4ddb7738@annuminas.surriel.com>
References: <20110201094433.72829892@annuminas.surriel.com>
	 <20110201095051.4ddb7738@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Feb 2011 13:58:38 +0100
Message-ID: <1296737918.26581.366.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 09:50 -0500, Rik van Riel wrote:
> +bool __sched yield_to(struct task_struct *p, bool preempt)
> +{
> +       struct task_struct *curr = current;
> +       struct rq *rq, *p_rq;
> +       unsigned long flags;
> +       bool yielded = 0;
> +
> +       local_irq_save(flags);
> +       rq = this_rq();
> +
> +again:
> +       p_rq = task_rq(p);
> +       double_rq_lock(rq, p_rq);
> +       while (task_rq(p) != p_rq) {
> +               double_rq_unlock(rq, p_rq);
> +               goto again;
> +       }
> +
> +       if (!curr->sched_class->yield_to_task)
> +               goto out;
> +
> +       if (curr->sched_class != p->sched_class)
> +               goto out;
> +
> +       if (task_running(p_rq, p) || p->state)
> +               goto out;
> +
> +       yielded = curr->sched_class->yield_to_task(rq, p, preempt);
> +
> +       if (yielded) {
> +               schedstat_inc(rq, yld_count);
> +               current->sched_class->yield_task(rq);
> +       }
> +
> +out:
> +       double_rq_unlock(rq, p_rq);
> +       local_irq_restore(flags);
> +
> +       if (yielded)
> +               schedule();
> +
> +       return yielded;
> +}
> +EXPORT_SYMBOL_GPL(yield_to); 


This also wants the below bit to successfully build on SMP=n,

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1686,6 +1686,39 @@ static void double_rq_unlock(struct rq *
 		__release(rq2->lock);
 }
 
+#else /* CONFIG_SMP */
+
+/*
+ * double_rq_lock - safely lock two runqueues
+ *
+ * Note this does not disable interrupts like task_rq_lock,
+ * you need to do so manually before calling.
+ */
+static void double_rq_lock(struct rq *rq1, struct rq *rq2)
+	__acquires(rq1->lock)
+	__acquires(rq2->lock)
+{
+	BUG_ON(!irqs_disabled());
+	BUG_ON(rq1 != rq2);
+	raw_spin_lock(&rq1->lock);
+	__acquire(rq2->lock);	/* Fake it out ;) */
+}
+
+/*
+ * double_rq_unlock - safely unlock two runqueues
+ *
+ * Note this does not restore interrupts like task_rq_unlock,
+ * you need to do so manually after calling.
+ */
+static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
+	__releases(rq1->lock)
+	__releases(rq2->lock)
+{
+	BUG_ON(rq1 != rq2);
+	raw_spin_unlock(&rq1->lock);
+	__release(rq2->lock);
+}
+
 #endif
 
 static void calc_load_account_idle(struct rq *this_rq);

