Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab1JUMZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:25:07 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47440 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab1JUMZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:25:04 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 1/3] CPU hotplug,
 Freezer: Don't hardcode 'tasks_frozen' argument in _cpu_*()
To: a.p.zijlstra@chello.nl
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, mingo@elte.hu,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@vger.kernel.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@xenotime.net
Date: Fri, 21 Oct 2011 17:54:57 +0530
Message-ID: <20111021122444.14321.57691.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111021122401.14321.45857.stgit@srivatsabhat.in.ibm.com>
References: <20111021122401.14321.45857.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a 'tasks_frozen' flag that is set whenever tasks are
frozen by the freezer and reset whenever the tasks are thawed. The value of
this flag is then checked by the CPU hotplug code in order to pass the
correct argument to the _cpu_up() and _cpu_down() functions, thereby
reflecting the correct state of the system.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/freezer.h |    2 ++
 kernel/cpu.c            |    5 +++--
 kernel/power/process.c  |   22 +++++++++++++++++++++-
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 1effc8b..a5283ce 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -50,6 +50,7 @@ extern int thaw_process(struct task_struct *p);
 extern void refrigerator(void);
 extern int freeze_processes(void);
 extern void thaw_processes(void);
+extern int tasks_are_frozen(void);
 
 static inline int try_to_freeze(void)
 {
@@ -173,6 +174,7 @@ static inline int thaw_process(struct task_struct *p) { return 1; }
 static inline void refrigerator(void) {}
 static inline int freeze_processes(void) { BUG(); return 0; }
 static inline void thaw_processes(void) {}
+static inline int tasks_are_frozen(void) { return 0; }
 
 static inline int try_to_freeze(void) { return 0; }
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 12b7458..e889ffd 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -15,6 +15,7 @@
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
 #include <linux/gfp.h>
+#include <linux/freezer.h>
 
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
@@ -280,7 +281,7 @@ int __ref cpu_down(unsigned int cpu)
 		goto out;
 	}
 
-	err = _cpu_down(cpu, 0);
+	err = _cpu_down(cpu, tasks_are_frozen());
 
 out:
 	cpu_maps_update_done();
@@ -373,7 +374,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 		goto out;
 	}
 
-	err = _cpu_up(cpu, 0);
+	err = _cpu_up(cpu, tasks_are_frozen());
 
 out:
 	cpu_maps_update_done();
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 0cf3a27..230bf96 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -17,11 +17,28 @@
 #include <linux/delay.h>
 #include <linux/workqueue.h>
 
-/* 
+/*
  * Timeout for stopping processes
  */
 #define TIMEOUT	(20 * HZ)
 
+static int tasks_frozen;
+
+static void set_tasks_frozen_flag(void)
+{
+	tasks_frozen = 1;
+}
+
+static void clear_tasks_frozen_flag(void)
+{
+	tasks_frozen = 0;
+}
+
+int tasks_are_frozen(void)
+{
+	return tasks_frozen;
+}
+
 static inline int freezable(struct task_struct * p)
 {
 	if ((p == current) ||
@@ -151,6 +168,8 @@ int freeze_processes(void)
 	error = try_to_freeze_tasks(false);
 	if (error)
 		goto Exit;
+
+	set_tasks_frozen_flag();
 	printk("done.");
 
 	oom_killer_disable();
@@ -189,6 +208,7 @@ void thaw_processes(void)
 	thaw_workqueues();
 	thaw_tasks(true);
 	thaw_tasks(false);
+	clear_tasks_frozen_flag();
 	schedule();
 	printk("done.\n");
 }

