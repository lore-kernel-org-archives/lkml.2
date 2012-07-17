Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2GQRMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:12:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53181 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2GQRMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:12:37 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, peterz@infradead.org, tglx@linutronix.de,
        linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/9] workqueue: perform cpu down operations from low priority cpu_notifier()
Date: Tue, 17 Jul 2012 10:12:21 -0700
Message-Id: <1342545149-3515-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1342545149-3515-1-git-send-email-tj@kernel.org>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, all workqueue cpu hotplug operations run off
CPU_PRI_WORKQUEUE which is higher than normal notifiers.  This is to
ensure that workqueue is up and running while bringing up a CPU before
other notifiers try to use workqueue on the CPU.

Per-cpu workqueues are supposed to remain working and bound to the CPU
for normal CPU_DOWN_PREPARE notifiers.  This holds mostly true even
with workqueue offlining running with higher priority because
workqueue CPU_DOWN_PREPARE only creates a bound trustee thread which
runs the per-cpu workqueue without concurrency management without
explicitly detaching the existing workers.

However, if the trustee needs to create new workers, it creates
unbound workers which may wander off to other CPUs while
CPU_DOWN_PREPARE notifiers are in progress.  Furthermore, if the CPU
down is cancelled, the per-CPU workqueue may end up with workers which
aren't bound to the CPU.

While reliably reproducible with a convoluted artificial test-case
involving scheduling and flushing CPU burning work items from CPU down
notifiers, this isn't very likely to happen in the wild, and, even
when it happens, the effects are likely to be hidden by the following
successful CPU down.

Fix it by using different priorities for up and down notifiers - high
priority for up operations and low priority for down operations.

Workqueue cpu hotplug operations will soon go through further cleanup.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
---
 include/linux/cpu.h |    5 +++--
 kernel/workqueue.c  |   38 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 2e9b9eb..ce7a074 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -73,8 +73,9 @@ enum {
 	/* migration should happen before other stuff but after perf */
 	CPU_PRI_PERF		= 20,
 	CPU_PRI_MIGRATION	= 10,
-	/* prepare workqueues for other notifiers */
-	CPU_PRI_WORKQUEUE	= 5,
+	/* bring up workqueues before normal notifiers and down after */
+	CPU_PRI_WORKQUEUE_UP	= 5,
+	CPU_PRI_WORKQUEUE_DOWN	= -5,
 };
 
 #define CPU_ONLINE		0x0002 /* CPU (unsigned)v is up */
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4fa9e35..f59b7fd 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3644,6 +3644,41 @@ err_destroy:
 	return NOTIFY_BAD;
 }
 
+/*
+ * Workqueues should be brought up before normal priority CPU notifiers.
+ * This will be registered high priority CPU notifier.
+ */
+static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
+					       unsigned long action,
+					       void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_CANCELED:
+	case CPU_DOWN_FAILED:
+	case CPU_ONLINE:
+		return workqueue_cpu_callback(nfb, action, hcpu);
+	}
+	return NOTIFY_OK;
+}
+
+/*
+ * Workqueues should be brought down after normal priority CPU notifiers.
+ * This will be registered as low priority CPU notifier.
+ */
+static int __devinit workqueue_cpu_down_callback(struct notifier_block *nfb,
+						 unsigned long action,
+						 void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_DOWN_PREPARE:
+	case CPU_DYING:
+	case CPU_POST_DEAD:
+		return workqueue_cpu_callback(nfb, action, hcpu);
+	}
+	return NOTIFY_OK;
+}
+
 #ifdef CONFIG_SMP
 
 struct work_for_cpu {
@@ -3839,7 +3874,8 @@ static int __init init_workqueues(void)
 	unsigned int cpu;
 	int i;
 
-	cpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);
+	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
+	cpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
 
 	/* initialize gcwqs */
 	for_each_gcwq_cpu(cpu) {
-- 
1.7.7.3

