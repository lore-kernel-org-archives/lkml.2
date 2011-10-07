Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1JGU4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:56:49 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:46549 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab1JGU4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:56:47 -0400
Message-ID: <4E8F6785.2010104@linux.vnet.ibm.com>
Date: Sat, 08 Oct 2011 02:26:37 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, len.brown@intel.com,
        mingo@elte.hu, akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@lists.linux-foundation.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] CPU hotplug, freezer: Fix bugs in CPU hotplug call
 path
References: <4E88BF33.10407@linux.vnet.ibm.com> <1317636215.12973.16.camel@twins> <4E8B07EA.4020307@linux.vnet.ibm.com> <4E8B09F3.4080800@linux.vnet.ibm.com> <1317735440.32543.4.camel@twins>
In-Reply-To: <1317735440.32543.4.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 07:07 PM, Peter Zijlstra wrote:
> On Tue, 2011-10-04 at 18:58 +0530, Srivatsa S. Bhat wrote:
>> +static int tasks_frozen;
>> +
>> +void set_tasks_frozen_flag(void)
>> +{
>> +       tasks_frozen = 1;
>> +       smp_mb();
>> +}
>> +
>> +void clear_tasks_frozen_flag(void)
>> +{
>> +       tasks_frozen = 0;
>> +       smp_mb();
>> +}
>> +
>> +int tasks_are_frozen(void)
>> +{
>> +       return tasks_frozen;
>> +} 
> 
> See Documentation/memory-barriers.txt, memory barriers always come in
> pairs, furthermore memory barriers always should have a comment
> explaining the ordering and referring to the pair match.
> 
Thank you for the pointer. I'll go through it (though now I think we
wouldn't need any of this, see below).

> I think you want at least an smp_rmb() before reading tasks_frozen,
> possible you also want to use ACCESS_ONCE() to force the compiler to
> emit the read.
> 
> Furthermore, do you really need this? isn't it both set and read from
> the same task context, all under pm_mutex?

I found that the cpu hotplug path that is triggered by writing to sysfs file
is not under pm_mutex. [The cpu hotplug path via disable/enable_nonboot_cpus()
is under pm_mutex, but in this patch we are not touching that path at all.]

By the way, this patch needs much more than just a flag set/reset by the
freezer and then the cpu hotplug code looking it up before calling _cpu_*()
functions. Because, we will have to ensure that while the registered
callbacks are being executed for the event notified, the state of the system
doesn't change (with respect to the tasks being frozen or not).
For example, while a callback for CPU_ONLINE is running, suddenly the tasks
must not get frozen (in which state it should have rather run callback for
CPU_ONLINE_FROZEN).

So, we should mutually exclude cpu hotplugging and freezing/thawing to
ensure that during the entire duration that the callbacks for the notified
event are running, the state introduced by that event holds good.

So the following patch tries to achieve this goal. It has not been tested.
I have posted it here just to generate discussion about the approach used.
I'll test it with lockdep enabled and find out if there are any problems.


---

 include/linux/freezer.h |    7 +++++++
 kernel/cpu.c            |    9 +++++++--
 kernel/power/process.c  |   27 ++++++++++++++++++++++++++-
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 1effc8b..75c65d6 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -7,6 +7,9 @@
 #include <linux/wait.h>
 
 #ifdef CONFIG_FREEZER
+
+extern struct mutex freezer_lock;
+
 /*
  * Check if a process has been frozen
  */
@@ -51,6 +54,10 @@ extern void refrigerator(void);
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
index 12b7458..b94c8f6 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -15,6 +15,7 @@
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
 #include <linux/gfp.h>
+#include <linux/freezer.h>
 
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
@@ -280,7 +281,9 @@ int __ref cpu_down(unsigned int cpu)
 		goto out;
 	}
 
-	err = _cpu_down(cpu, 0);
+	mutex_lock(&freezer_lock);
+	err = _cpu_down(cpu, tasks_are_frozen());
+	mutex_unlock(&freezer_lock);
 
 out:
 	cpu_maps_update_done();
@@ -373,7 +376,9 @@ int __cpuinit cpu_up(unsigned int cpu)
 		goto out;
 	}
 
-	err = _cpu_up(cpu, 0);
+	mutex_lock(&freezer_lock);
+	err = _cpu_up(cpu, tasks_are_frozen());
+	mutex_unlock(&freezer_lock);
 
 out:
 	cpu_maps_update_done();
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 0cf3a27..1285da2 100644
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
 
+DEFINE_MUTEX(freezer_lock);
+
+static int tasks_frozen;
+
+void set_tasks_frozen_flag(void)
+{
+	tasks_frozen = 1;
+}
+
+void clear_tasks_frozen_flag(void)
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
@@ -141,6 +160,7 @@ int freeze_processes(void)
 {
 	int error;
 
+	mutex_lock(&freezer_lock);
 	printk("Freezing user space processes ... ");
 	error = try_to_freeze_tasks(true);
 	if (error)
@@ -151,10 +171,12 @@ int freeze_processes(void)
 	error = try_to_freeze_tasks(false);
 	if (error)
 		goto Exit;
+	set_tasks_frozen_flag();
 	printk("done.");
 
 	oom_killer_disable();
  Exit:
+	mutex_unlock(&freezer_lock);
 	BUG_ON(in_atomic());
 	printk("\n");
 
@@ -183,6 +205,7 @@ static void thaw_tasks(bool nosig_only)
 
 void thaw_processes(void)
 {
+	mutex_lock(&freezer_lock);
 	oom_killer_enable();
 
 	printk("Restarting tasks ... ");
@@ -190,6 +213,8 @@ void thaw_processes(void)
 	thaw_tasks(true);
 	thaw_tasks(false);
 	schedule();
+	clear_tasks_frozen_flag();
+	mutex_unlock(&freezer_lock);
 	printk("done.\n");
 }


