Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762719Ab2ERKhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:37:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42558 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762338Ab2ERKhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:37:36 -0400
Date: Fri, 18 May 2012 03:37:07 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-jssl8t34ho7afo6w4xufmhrs@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        bharata.rao@gmail.com, aarcange@redhat.com, Lee.Schermerhorn@hp.com,
        suresh.b.siddha@intel.com, danms@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa: Implement hotplug callbacks
Git-Commit-ID: 47d30cf50b1ceb09dc1a920262d80e621b307ae3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:37:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47d30cf50b1ceb09dc1a920262d80e621b307ae3
Gitweb:     http://git.kernel.org/tip/47d30cf50b1ceb09dc1a920262d80e621b307ae3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 6 Mar 2012 17:37:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:23 +0200

sched/numa: Implement hotplug callbacks

start/stop numa balance threads on-demand using cpu-hotplug.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-jssl8t34ho7afo6w4xufmhrs@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/numa.c |   62 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
index c9ec90d..99585d5 100644
--- a/kernel/sched/numa.c
+++ b/kernel/sched/numa.c
@@ -710,31 +710,79 @@ static int numad_thread(void *data)
 	return 0;
 }
 
+static int __cpuinit
+numa_hotplug(struct notifier_block *nb, unsigned long action, void *hcpu)
+{
+	int cpu = (long)hcpu;
+	int node = cpu_to_node(cpu);
+	struct node_queue *nq = nq_of(node);
+	struct task_struct *numad;
+	int err = 0;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		if (nq->numad)
+			break;
+
+		numad = kthread_create_on_node(numad_thread,
+				nq, node, "numad/%d", node);
+		if (IS_ERR(numad)) {
+			err = PTR_ERR(numad);
+			break;
+		}
+
+		nq->numad = numad;
+		nq->next_schedule = jiffies + HZ; // XXX sync-up?
+		break;
+
+	case CPU_ONLINE:
+		wake_up_process(nq->numad);
+		break;
+
+	case CPU_DEAD:
+	case CPU_UP_CANCELED:
+		if (!nq->numad)
+			break;
+
+		if (cpumask_any_and(cpu_online_mask,
+				    cpumask_of_node(node)) >= nr_cpu_ids) {
+			kthread_stop(nq->numad);
+			nq->numad = NULL;
+		}
+		break;
+	}
+
+	return notifier_from_errno(err);
+}
+
 static __init int numa_init(void)
 {
-	int node;
+	int node, cpu, err;
 
 	nqs = kzalloc(sizeof(struct node_queue*) * nr_node_ids, GFP_KERNEL);
 	BUG_ON(!nqs);
 
-	for_each_node(node) { // XXX hotplug
+	for_each_node(node) {
 		struct node_queue *nq = kmalloc_node(sizeof(*nq),
 				GFP_KERNEL | __GFP_ZERO, node);
 		BUG_ON(!nq);
 
-		nq->numad = kthread_create_on_node(numad_thread,
-				nq, node, "numad/%d", node);
-		BUG_ON(IS_ERR(nq->numad));
-
 		spin_lock_init(&nq->lock);
 		INIT_LIST_HEAD(&nq->entity_list);
 
 		nq->next_schedule = jiffies + HZ;
 		nq->node = node;
 		nqs[node] = nq;
+	}
 
-		wake_up_process(nq->numad);
+	get_online_cpus();
+	cpu_notifier(numa_hotplug, 0);
+	for_each_online_cpu(cpu) {
+		err = numa_hotplug(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
+		BUG_ON(notifier_to_errno(err));
+		numa_hotplug(NULL, CPU_ONLINE, (void *)(long)cpu);
 	}
+	put_online_cpus();
 
 	return 0;
 }
