Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762163Ab2EQRAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:00:55 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52776 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758759Ab2EQRAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:00:52 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v5 1/5] CPU hotplug, cpusets,
 suspend: Don't modify cpusets during suspend/resume
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, rientjes@google.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Thu, 17 May 2012 22:29:55 +0530
Message-ID: <20120517165925.3011.68624.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120517165839.3011.98723.stgit@srivatsabhat.in.ibm.com>
References: <20120517165839.3011.98723.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12051706-7014-0000-0000-0000012D89F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the event of CPU hotplug, the kernel modifies the cpusets' cpus_allowed
masks as and when necessary to ensure that the tasks belonging to the cpusets
have some place (online CPUs) to run on. And regular CPU hotplug is
destructive in the sense that the kernel doesn't remember the original cpuset
configurations set by the user, across hotplug operations.

However, suspend/resume (which uses CPU hotplug) is a special case in which
the kernel has the responsibility to restore the system (during resume), to
exactly the same state it was in before suspend.

In order to achieve that, do the following:

1. Don't modify cpusets during suspend/resume. At all.
   In particular, don't move the tasks from one cpuset to another, and
   don't modify any cpuset's cpus_allowed mask. So, simply ignore cpusets
   during the CPU hotplug operations that are carried out in the
   suspend/resume path.

2. However, cpusets and sched domains are related. We just want to avoid
   altering cpusets alone. So, to keep the sched domains updated, build
   a single sched domain (containing all active cpus) during each of the
   CPU hotplug operations carried out in s/r path, effectively ignoring
   the cpusets' cpus_allowed masks.

   (Since userspace is frozen while doing all this, it will go unnoticed.)

3. During the last CPU online operation during resume, build the sched
   domains by looking up the (unaltered) cpusets' cpus_allowed masks.
   That will bring back the system to the same original state as it was in
   before suspend.

Ultimately, this will not only solve the cpuset problem related to suspend
resume (ie., restores the cpusets to exactly what it was before suspend, by
not touching it at all) but also speeds up suspend/resume because we avoid
running cpuset update code for every CPU being offlined/onlined.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---

 kernel/cpuset.c     |    3 +++
 kernel/sched/core.c |   40 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 14f7070..5fc1570 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2065,6 +2065,9 @@ static void scan_for_empty_cpusets(struct cpuset *root)
  * (of no affect) on systems that are actively using CPU hotplug
  * but making no active use of cpusets.
  *
+ * The only exception to this is suspend/resume, where we don't
+ * modify cpusets at all.
+ *
  * This routine ensures that top_cpuset.cpus_allowed tracks
  * cpu_active_mask on each CPU hotplug (cpuhp) event.
  *
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0533a68..9c6ce0c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6801,34 +6801,66 @@ int __init sched_create_sysfs_power_savings_entries(struct device *dev)
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
+static int num_cpus_frozen;	/* used to mark begin/end of suspend/resume */
+
 /*
  * Update cpusets according to cpu_active mask.  If cpusets are
  * disabled, cpuset_update_active_cpus() becomes a simple wrapper
  * around partition_sched_domains().
+ *
+ * If we come here as part of a suspend/resume, don't touch cpusets because we
+ * want to restore it back to its original state upon resume anyway.
  */
 static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
 			     void *hcpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
+	switch (action) {
+	case CPU_ONLINE_FROZEN:
+	case CPU_DOWN_FAILED_FROZEN:
+
+		/*
+		 * num_cpus_frozen tracks how many CPUs are involved in suspend
+		 * resume sequence. As long as this is not the last online
+		 * operation in the resume sequence, just build a single sched
+		 * domain, ignoring cpusets.
+		 */
+		num_cpus_frozen--;
+		if (likely(num_cpus_frozen)) {
+			partition_sched_domains(1, NULL, NULL);
+			break;
+		}
+
+		/*
+		 * This is the last CPU online operation. So fall through and
+		 * restore the original sched domains by considering the
+		 * cpuset configurations.
+		 */
+
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
 		cpuset_update_active_cpus();
-		return NOTIFY_OK;
+		break;
 	default:
 		return NOTIFY_DONE;
 	}
+	return NOTIFY_OK;
 }
 
 static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
 			       void *hcpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
+	switch (action) {
 	case CPU_DOWN_PREPARE:
 		cpuset_update_active_cpus();
-		return NOTIFY_OK;
+		break;
+	case CPU_DOWN_PREPARE_FROZEN:
+		num_cpus_frozen++;
+		partition_sched_domains(1, NULL, NULL);
+		break;
 	default:
 		return NOTIFY_DONE;
 	}
+	return NOTIFY_OK;
 }
 
 void __init sched_init_smp(void)

