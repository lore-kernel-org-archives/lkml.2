Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967489Ab2EQREQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:04:16 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47439 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967351Ab2EQREO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:04:14 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v5 4/5] cpusets: Update tasks' cpus_allowed mask upon updates
 to root cpuset
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, rientjes@google.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Thu, 17 May 2012 22:33:24 +0530
Message-ID: <20120517170055.3011.18690.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120517165839.3011.98723.stgit@srivatsabhat.in.ibm.com>
References: <20120517165839.3011.98723.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12051706-1618-0000-0000-0000019CD86C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The root cpuset's cpus_allowed mask can get updated during CPU hotplug.
However, during those updates, the tasks belonging to the root cpuset
aren't touched at all - their cpus_allowed masks aren't updated to reflect
the change in the configuration of the cpuset they belong to.

Fix this by moving the update of top_cpuset.cpus_allowed to
scan_cpusets_upon_hotplug() and ensure that the call to update_tasks_cpumask()
is not missed out for the root cpuset, including for cpu online events.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
---
David, I updated this code slightly (added the cpumask_equal() check
in CPUSET_CPU_ONLINE case) but retained your ack. Let me know if you have
objections.

 kernel/cpuset.c |   39 +++++++++++++++++++++++++++++++--------
 1 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 276a35a..e44db78 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -150,6 +150,7 @@ typedef enum {
 /* the type of hotplug event */
 enum hotplug_event {
 	CPUSET_CPU_OFFLINE,
+	CPUSET_CPU_ONLINE,
 	CPUSET_MEM_OFFLINE,
 };
 
@@ -2066,10 +2067,14 @@ scan_cpusets_upon_hotplug(struct cpuset *root, enum hotplug_event event)
 			if (cpumask_subset(cp->cpus_allowed, cpu_active_mask))
 				continue;
 
-			/* Remove offline cpus from this cpuset. */
 			mutex_lock(&callback_mutex);
-			cpumask_and(cp->cpus_allowed, cp->cpus_allowed,
-							cpu_active_mask);
+			/* top_cpuset.cpus_allowed must track cpu_active_mask */
+			if (cp == &top_cpuset)
+				cpumask_copy(cp->cpus_allowed, cpu_active_mask);
+			else
+				/* Remove offline cpus from this cpuset. */
+				cpumask_and(cp->cpus_allowed, cp->cpus_allowed,
+							      cpu_active_mask);
 			mutex_unlock(&callback_mutex);
 
 			/* Move tasks from the empty cpuset to a parent */
@@ -2080,6 +2085,24 @@ scan_cpusets_upon_hotplug(struct cpuset *root, enum hotplug_event event)
 		}
 		break;
 
+	case CPUSET_CPU_ONLINE:
+		/*
+		 * Restore only the top_cpuset because it has to track
+		 * cpu_active_mask always.
+		 * (We don't need to do anything if we come here during resume
+		 * from suspend, since top_cpuset.cpus_allowed will already be
+		 * equal to cpu_active_mask.)
+		 */
+		if (root == &top_cpuset && !cpumask_equal(root->cpus_allowed,
+							  cpu_active_mask)) {
+			mutex_lock(&callback_mutex);
+			cpumask_copy(root->cpus_allowed, cpu_active_mask);
+			mutex_unlock(&callback_mutex);
+			update_tasks_cpumask(root, NULL);
+		}
+		list_del(queue.next);
+		break;
+
 	case CPUSET_MEM_OFFLINE:
 		while ((cp = cpuset_next(&queue)) != NULL) {
 
@@ -2115,7 +2138,8 @@ scan_cpusets_upon_hotplug(struct cpuset *root, enum hotplug_event event)
  * modify cpusets at all.
  *
  * This routine ensures that top_cpuset.cpus_allowed tracks
- * cpu_active_mask on each CPU hotplug (cpuhp) event.
+ * cpu_active_mask on each CPU hotplug (cpuhp) event. (This maintenance
+ * is actually implemented in scan_cpusets_upon_hotplug().)
  *
  * Called within get_online_cpus().  Needs to call cgroup_lock()
  * before calling generate_sched_domains().
@@ -2130,11 +2154,10 @@ void cpuset_update_active_cpus(bool cpu_online)
 	int ndoms;
 
 	cgroup_lock();
-	mutex_lock(&callback_mutex);
-	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
-	mutex_unlock(&callback_mutex);
 
-	if (!cpu_online)
+	if (cpu_online)
+		scan_cpusets_upon_hotplug(&top_cpuset, CPUSET_CPU_ONLINE);
+	else
 		scan_cpusets_upon_hotplug(&top_cpuset, CPUSET_CPU_OFFLINE);
 
 	ndoms = generate_sched_domains(&doms, &attr);

