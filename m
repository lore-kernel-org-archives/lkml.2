Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1JHU2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 16:28:16 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:53560 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab1JHU2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 16:28:13 -0400
Message-ID: <4E90B254.9010604@linux.vnet.ibm.com>
Date: Sun, 09 Oct 2011 01:58:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        pavel@ucw.cz, len.brown@intel.com, mingo@elte.hu,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] CPU hotplug, freezer: Fix bugs in CPU hotplug call
 path
References: <4E88BF33.10407@linux.vnet.ibm.com> <1317636215.12973.16.camel@twins>	<4E8B07EA.4020307@linux.vnet.ibm.com> <4E8B09F3.4080800@linux.vnet.ibm.com>	<1317735440.32543.4.camel@twins> <4E8F6785.2010104@linux.vnet.ibm.com> <CAM_iQpXDDeOzZ0L8MYFPhi_5rJJvinOD57nWWKfnCRxa_Jtx6Q@mail.gmail.com>
In-Reply-To: <CAM_iQpXDDeOzZ0L8MYFPhi_5rJJvinOD57nWWKfnCRxa_Jtx6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2011 06:22 PM, Américo Wang wrote:
> On Sat, Oct 8, 2011 at 4:56 AM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
>> index 1effc8b..75c65d6 100644
>> --- a/include/linux/freezer.h
>> +++ b/include/linux/freezer.h
>> @@ -7,6 +7,9 @@
>>  #include <linux/wait.h>
>>
>>  #ifdef CONFIG_FREEZER
>> +
>> +extern struct mutex freezer_lock;
>> +
> [...]
>>  static inline int try_to_freeze(void)
>>  {
>>        if (freezing(current)) {
>> diff --git a/kernel/cpu.c b/kernel/cpu.c
>> index 12b7458..b94c8f6 100644
>> --- a/kernel/cpu.c
>> +++ b/kernel/cpu.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/stop_machine.h>
>>  #include <linux/mutex.h>
>>  #include <linux/gfp.h>
>> +#include <linux/freezer.h>
>>
>>  #ifdef CONFIG_SMP
>>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
>> @@ -280,7 +281,9 @@ int __ref cpu_down(unsigned int cpu)
>>                goto out;
>>        }
>>
>> -       err = _cpu_down(cpu, 0);
>> +       mutex_lock(&freezer_lock);
>> +       err = _cpu_down(cpu, tasks_are_frozen());
>> +       mutex_unlock(&freezer_lock);
>>
> 
> Can this even be compiled when CONFIG_FREEZER=n?
> 
Oh! That's a mistake.. Thank you for pointing it out.

This one should fix it:

---

 include/linux/freezer.h |   22 ++++++++++++++++++++++
 kernel/cpu.c            |    9 +++++++--
 kernel/power/process.c  |   27 ++++++++++++++++++++++++++-
 3 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 1effc8b..3d80ddb 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -7,6 +7,19 @@
 #include <linux/wait.h>
 
 #ifdef CONFIG_FREEZER
+
+extern struct mutex freezer_lock;
+
+static inline void lock_freezer(void)
+{
+	mutex_lock(&freezer_lock);
+}
+
+static inline void unlock_freezer(void)
+{
+	mutex_unlock(&freezer_lock);
+}
+
 /*
  * Check if a process has been frozen
  */
@@ -51,6 +64,10 @@ extern void refrigerator(void);
 extern int freeze_processes(void);
 extern void thaw_processes(void);
 
+extern void set_tasks_frozen_flag(void);
+extern void clear_tasks_frozen_flag(void);
+extern int tasks_are_frozen(void);
+
 static inline int try_to_freeze(void)
 {
 	if (freezing(current)) {
@@ -164,6 +181,8 @@ static inline void set_freezable_with_signal(void)
 	__retval;							\
 })
 #else /* !CONFIG_FREEZER */
+static inline void lock_freezer(void) {}
+static inline void unlock_freezer(void) {}
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
 static inline void set_freeze_flag(struct task_struct *p) {}
@@ -173,6 +192,9 @@ static inline int thaw_process(struct task_struct *p) { return 1; }
 static inline void refrigerator(void) {}
 static inline int freeze_processes(void) { BUG(); return 0; }
 static inline void thaw_processes(void) {}
+static inline void set_tasks_frozen_flag(void) {}
+static inline void clear_tasks_frozen_flag(void) {}
+static inline int tasks_are_frozen(void) { return 0; }
 
 static inline int try_to_freeze(void) { return 0; }
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 12b7458..d81ceea 100644
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
+	lock_freezer();
+	err = _cpu_down(cpu, tasks_are_frozen());
+	unlock_freezer();
 
 out:
 	cpu_maps_update_done();
@@ -373,7 +376,9 @@ int __cpuinit cpu_up(unsigned int cpu)
 		goto out;
 	}
 
-	err = _cpu_up(cpu, 0);
+	lock_freezer();
+	err = _cpu_up(cpu, tasks_are_frozen());
+	unlock_freezer();
 
 out:
 	cpu_maps_update_done();
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 0cf3a27..9da3369 100644
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
 
+	lock_freezer();
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
+	unlock_freezer();
 	BUG_ON(in_atomic());
 	printk("\n");
 
@@ -183,6 +205,7 @@ static void thaw_tasks(bool nosig_only)
 
 void thaw_processes(void)
 {
+	lock_freezer();
 	oom_killer_enable();
 
 	printk("Restarting tasks ... ");
@@ -190,6 +213,8 @@ void thaw_processes(void)
 	thaw_tasks(true);
 	thaw_tasks(false);
 	schedule();
+	clear_tasks_frozen_flag();
+	unlock_freezer();
 	printk("done.\n");
 }
 

