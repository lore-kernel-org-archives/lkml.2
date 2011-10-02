Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab1JBTpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:45:07 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:55507 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab1JBTpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:45:01 -0400
Message-ID: <4E88BF33.10407@linux.vnet.ibm.com>
Date: Mon, 03 Oct 2011 01:14:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: pavel@ucw.cz, len.brown@intel.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@lists.linux-foundation.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] CPU hotplug, freezer: Fix bugs in CPU hotplug call path
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the CPU hotplug infrastructure to offline/online CPUs,
the cpu_up() and cpu_down() functions are used, which internally
call _cpu_up() and _cpu_down() with the second argument *always*
set to 0. The second argument is "tasks_frozen", which should be
correctly set to 1 when tasks have been frozen, even when the freezing
of tasks may be due to an event unrelated to CPU hotplug, such as
a suspend operation in progress, in which case the freezer subsystem
freezes all the freezable tasks.

Not giving the correct value for the 'tasks_frozen' argument can potentially
lead to a lot of issues since this will send a wrong notification via the
notifier mechanism leading to the execution of inappropriate code
by the callbacks registered for the notifiers. That is, instead of
CPU_ONLINE_FROZEN and CPU_OFFLINE_FROZEN notifications, it results in
CPU_ONLINE and CPU_OFFLINE notifications to be sent all the time,
irrespective of the actual state of the system (i.e., whether tasks
are frozen or not).

This patch adds a check in cpu_up() and cpu_down() to see whether
the tasks have been frozen (by any event) so that they can call
_cpu_up() and _cpu_down() respectively by supplying the correct
value as the second argument based on the state of the system.
This in turn means that the correct notifications are sent, thus
ensuring that all the registered callbacks do the right thing.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/freezer.h |    4 ++++
 kernel/cpu.c            |    9 +++++++--
 kernel/power/process.c  |   24 +++++++++++++++++++++++-
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 1effc8b..3a37d8b 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -51,6 +51,10 @@ extern void refrigerator(void);
 extern int freeze_processes(void);
 extern void thaw_processes(void);
 
+extern void set_tasks_frozen_flag(void);
+extern void clear_tasks_frozen_flag(void);
+extern int tasks_are_frozen(void);
+
 static inline int try_to_freeze(void)
 {
 	if (freezing(current)) {
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 12b7458..e4530ea 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -15,6 +15,7 @@
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
 #include <linux/gfp.h>
+#include <linux/freezer.h>
 
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
@@ -272,6 +273,7 @@ out_release:
 int __ref cpu_down(unsigned int cpu)
 {
 	int err;
+	int tasks_frozen;
 
 	cpu_maps_update_begin();
 
@@ -280,7 +282,8 @@ int __ref cpu_down(unsigned int cpu)
 		goto out;
 	}
 
-	err = _cpu_down(cpu, 0);
+	tasks_frozen = tasks_are_frozen();
+	err = _cpu_down(cpu, tasks_frozen);
 
 out:
 	cpu_maps_update_done();
@@ -328,6 +331,7 @@ out_notify:
 int __cpuinit cpu_up(unsigned int cpu)
 {
 	int err = 0;
+	int tasks_frozen;
 
 #ifdef	CONFIG_MEMORY_HOTPLUG
 	int nid;
@@ -373,7 +377,8 @@ int __cpuinit cpu_up(unsigned int cpu)
 		goto out;
 	}
 
-	err = _cpu_up(cpu, 0);
+	tasks_frozen = tasks_are_frozen();
+	err = _cpu_up(cpu, tasks_frozen);
 
 out:
 	cpu_maps_update_done();
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 0cf3a27..7642314 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -17,11 +17,30 @@
 #include <linux/delay.h>
 #include <linux/workqueue.h>
 
-/* 
+/*
  * Timeout for stopping processes
  */
 #define TIMEOUT	(20 * HZ)
 
+static atomic_t tasks_frozen = ATOMIC_INIT(0);
+
+void set_tasks_frozen_flag(void)
+{
+	atomic_set(&tasks_frozen, 1);
+}
+
+void clear_tasks_frozen_flag(void)
+{
+	atomic_set(&tasks_frozen, 0);
+}
+
+int tasks_are_frozen(void)
+{
+	int ret;
+	ret = atomic_read(&tasks_frozen);
+	return ret;
+}
+
 static inline int freezable(struct task_struct * p)
 {
 	if ((p == current) ||
@@ -153,6 +172,8 @@ int freeze_processes(void)
 		goto Exit;
 	printk("done.");
 
+	set_tasks_frozen_flag();
+
 	oom_killer_disable();
  Exit:
 	BUG_ON(in_atomic());
@@ -191,5 +212,6 @@ void thaw_processes(void)
 	thaw_tasks(false);
 	schedule();
 	printk("done.\n");
+	clear_tasks_frozen_flag();
 }
 


