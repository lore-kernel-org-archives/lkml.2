Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423463Ab2LGRla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:41:30 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:56973 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423447Ab2LGRlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:41:25 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 7/9] yield_to(),
 cpu-hotplug: Prevent offlining of other CPUs properly
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        oleg@redhat.com
Cc: sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        srivatsa.bhat@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 23:09:53 +0530
Message-ID: <20121207173950.27305.39499.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com>
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120717-8256-0000-0000-00000557C0D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once stop_machine() is gone from the CPU offline path, we won't be able to
depend on local_irq_save() to prevent CPUs from going offline from under us.

Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going offline,
while invoking from atomic context.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/sched/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index cff7656..4b982bf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4312,6 +4312,7 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
 	unsigned long flags;
 	bool yielded = 0;
 
+	get_online_cpus_atomic();
 	local_irq_save(flags);
 	rq = this_rq();
 
@@ -4339,13 +4340,14 @@ again:
 		 * Make p's CPU reschedule; pick_next_entity takes care of
 		 * fairness.
 		 */
-		if (preempt && rq != p_rq)
+		if (preempt && rq != p_rq && cpu_online(task_cpu(p)))
 			resched_task(p_rq->curr);
 	}
 
 out:
 	double_rq_unlock(rq, p_rq);
 	local_irq_restore(flags);
+	put_online_cpus_atomic();
 
 	if (yielded)
 		schedule();

