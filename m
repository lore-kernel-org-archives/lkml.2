Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab1JDN23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 09:28:29 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:50846 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab1JDN22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 09:28:28 -0400
Message-ID: <4E8B09F3.4080800@linux.vnet.ibm.com>
Date: Tue, 04 Oct 2011 18:58:19 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, len.brown@intel.com,
        mingo@elte.hu, akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@lists.linux-foundation.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] CPU hotplug, freezer: Fix bugs in CPU hotplug call
 path
References: <4E88BF33.10407@linux.vnet.ibm.com> <1317636215.12973.16.camel@twins> <4E8B07EA.4020307@linux.vnet.ibm.com>
In-Reply-To: <4E8B07EA.4020307@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
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
lead to a lot of issues since this will send wrong notifications via the
notifier mechanism leading to the execution of inappropriate code
by the callbacks registered for the notifiers. That is, instead of
CPU_ONLINE_FROZEN and CPU_DEAD_FROZEN notifications, it results in
CPU_ONLINE and CPU_DEAD notifications to be sent all the time,
irrespective of the actual state of the system (i.e., whether tasks
are frozen or not).
To give an example that CPU hotplug notifications that only differ with
respect to the task frozen status might actually trigger different actions
in the callbacks, the x86 microcode update driver has a callback registered
for CPU hotplug events, which takes different actions based on whether
a CPU_DEAD or a CPU_DEAD_FROZEN notification is received.

This patch introduces a flag to indicate whether the tasks are frozen are not
(by any event) and modifies cpu_up() and cpu_down() functions to check the
value of this flag and accordingly call _cpu_up() and _cpu_down()
respectively by supplying the correct value as the second argument based
on the state of the system. This in turn means that the correct notifications
are sent, thus ensuring that all the registered callbacks do the right thing.

v2: * Removed the atomic_t declaration of tasks_frozen flag and the
      atomic_[set|read] functions since they were unnecessary.
    * Updated the changelog to give an example scenario where things could go
      wrong due to the bug in the CPU hotplug call path.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/cpu.c           |    5 +++--
 kernel/power/process.c |   23 ++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 3 deletions(-)

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
index 0cf3a27..687f6fa 100644
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
 
+static int tasks_frozen;
+
+void set_tasks_frozen_flag(void)
+{
+	tasks_frozen = 1;
+	smp_mb();
+}
+
+void clear_tasks_frozen_flag(void)
+{
+	tasks_frozen = 0;
+	smp_mb();
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
@@ -151,6 +170,7 @@ int freeze_processes(void)
 	error = try_to_freeze_tasks(false);
 	if (error)
 		goto Exit;
+	set_tasks_frozen_flag();
 	printk("done.");
 
 	oom_killer_disable();
@@ -190,6 +210,7 @@ void thaw_processes(void)
 	thaw_tasks(true);
 	thaw_tasks(false);
 	schedule();
+	clear_tasks_frozen_flag();
 	printk("done.\n");
 }
 


