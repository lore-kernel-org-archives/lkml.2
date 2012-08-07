Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030533Ab2HGWiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:38:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51918 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030495Ab2HGWij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:38:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 047/109] workqueue: perform cpu down operations from low priority cpu_notifier()
Date: Tue,  7 Aug 2012 15:35:06 -0700
Message-Id: <20120807222047.218154374@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 6575820221f7a4dd6eadecf7bf83cdd154335eda upstream.

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
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/cpu.h |    5 +++--
 kernel/workqueue.c  |   38 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 3 deletions(-)

--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -75,8 +75,9 @@ enum {
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
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3582,6 +3582,41 @@ static int __devinit workqueue_cpu_callb
 	return notifier_from_errno(0);
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
@@ -3775,7 +3810,8 @@ static int __init init_workqueues(void)
 	unsigned int cpu;
 	int i;
 
-	cpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);
+	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
+	cpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
 
 	/* initialize gcwqs */
 	for_each_gcwq_cpu(cpu) {


