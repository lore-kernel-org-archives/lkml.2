Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab2JKAQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:16:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59037 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932785Ab2JKAQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:16:19 -0400
X-Sasl-enc: FROJqQ/2xJUgzMgp+YmuR8WGnMlvGGqbifwS6TUH289j 1349914576
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: [ 120/133] CPU hotplug, cpusets, suspend: Dont modify cpusets during suspend/resume
Date: Thu, 11 Oct 2012 07:52:26 +0900
Message-Id: <20121010224916.130413597@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>

commit d35be8bab9b0ce44bed4b9453f86ebf64062721e upstream.

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20120524141611.3692.20155.stgit@srivatsabhat.in.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cpuset.c     |    3 +++
 kernel/sched/core.c |   40 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 39 insertions(+), 4 deletions(-)

--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2054,6 +2054,9 @@ static void scan_for_empty_cpusets(struc
  * (of no affect) on systems that are actively using CPU hotplug
  * but making no active use of cpusets.
  *
+ * The only exception to this is suspend/resume, where we don't
+ * modify cpusets at all.
+ *
  * This routine ensures that top_cpuset.cpus_allowed tracks
  * cpu_active_mask on each CPU hotplug (cpuhp) event.
  *
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7103,34 +7103,66 @@ match2:
 	mutex_unlock(&sched_domains_mutex);
 }
 
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


