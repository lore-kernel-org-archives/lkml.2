Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2CLJT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 05:19:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:8658 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab2CLJTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 05:19:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117667473"
Message-ID: <4F5DBFA8.3080300@intel.com>
Date: Mon, 12 Mar 2012 17:19:36 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Valentin, Eduardo" <eduardo.valentin@ti.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Brown, Len" <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] cpuidle: Move cpuidle sysfs entry of each cpu to debugfs.
References: <C6CB66606345BC4B80CBE69D22ABFBB10220E1@SHSMSX101.ccr.corp.intel.com> <4F545A4E.8010801@linux.vnet.ibm.com> <4F5466C4.2090808@intel.com> <20120305101827.GA19408@khazad-dum.debian.net> <CAGF5oy_BUytjeDa8Oc62pRabaEqwqKCFuVJuzLd-XNZg34ne2w@mail.gmail.com> <1330998885.1916.89.camel@ymzhang> <20120306052236.GA19416@kroah.com> <1331013078.1916.103.camel@ymzhang> <20120306143935.GA23346@kroah.com> <1331082051.1916.124.camel@ymzhang> <20120308180106.GD26516@kroah.com>
In-Reply-To: <20120308180106.GD26516@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年03月09日 02:01, Greg KH wrote:
> On Wed, Mar 07, 2012 at 09:00:51AM +0800, Yanmin Zhang wrote:
>> On Tue, 2012-03-06 at 06:39 -0800, Greg KH wrote:
>>> On Tue, Mar 06, 2012 at 01:51:18PM +0800, Yanmin Zhang wrote:
>>>> On Mon, 2012-03-05 at 21:22 -0800, Greg KH wrote:
>>>>> On Tue, Mar 06, 2012 at 09:54:45AM +0800, Yanmin Zhang wrote:
>>>>>> On Mon, 2012-03-05 at 14:20 +0200, Valentin, Eduardo wrote:
>>>>>>> Hello,
>>>>>>>
>>>>>>>
>>>>>>> On Mon, Mar 5, 2012 at 12:18 PM, Henrique de Moraes Holschuh
>>>>>>> <hmh@hmh.eng.br>  wrote:
>>>>>>>> On Mon, 05 Mar 2012, ShuoX Liu wrote:
>>>>>>>>> @@ -45,6 +46,7 @@ total 0
>>>>>>>>>   /sys/devices/system/cpu/cpu0/cpuidle/state1:
>>>>>>>>>   total 0
>>>>>>>>>   -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
>>>>>>>>> +-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
>>>>>>>>>   -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
>>>>>>>>>   -r--r--r-- 1 root root 4096 Feb  8 10:42 name
>>>>>>>>>   -r--r--r-- 1 root root 4096 Feb  8 10:42 power
>>>>>>>>
>>>>>>>> ...
>>>>>>>>
>>>>>>>>> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
>>>>>>>>> index 3fe41fe..1eae29a 100644
>>>>>>>>> --- a/drivers/cpuidle/sysfs.c
>>>>>>>>> +++ b/drivers/cpuidle/sysfs.c
>>>>>>>>> @@ -222,6 +222,9 @@ struct cpuidle_state_attr {
>>>>>>>>>   #define define_one_state_ro(_name, show) \
>>>>>>>>>   static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0444,
>>>>>>>>> show, NULL)
>>>>>>>>>
>>>>>>>>> +#define define_one_state_rw(_name, show, store) \
>>>>>>>>> +static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644,
>>>>>>>>> show, store)
>>>>>>>>> +
>>>>>>>>>   #define define_show_state_function(_name) \
>>>>>>>>>   static ssize_t show_state_##_name(struct cpuidle_state *state, \
>>>>>>>>>                         struct cpuidle_state_usage *state_usage, char *buf) \
>>>>>>>>> @@ -229,6 +232,19 @@ static ssize_t show_state_##_name(struct
>>>>>>>>> cpuidle_state *state, \
>>>>>>>>>        return sprintf(buf, "%u\n", state->_name);\
>>>>>>>>>   }
>>>>>>>>>
>>>>>>>>> +#define define_store_state_function(_name) \
>>>>>>>>> +static ssize_t store_state_##_name(struct cpuidle_state *state, \
>>>>>>>>> +             const char *buf, size_t size) \
>>>>>>>>> +{ \
>>>>>>>>> +     int value; \
>>>>>>>>> +     sscanf(buf, "%d",&value); \
>>>>>>>>> +     if (value) \
>>>>>>>>> +             state->disable = 1; \
>>>>>>>>> +     else \
>>>>>>>>> +             state->disable = 0; \
>>>>>>>>> +     return size; \
>>>>>>>>> +}
>>>>>>>>
>>>>>>>> Isn't this missing a check for capabilities?  Disabling cpuidle states is
>>>>>>>> not something random Joe (and IMHO that does mean random capability-
>>>>>>>> restricted Joe root) should be doing...
>>>>>>>>
>>>>>>>> Also, maybe it would be best to use one of the lib helpers to parse that
>>>>>>>> value, so that it will be less annoying to userspace (trim blanks, complain
>>>>>>>> if there is trailing junk after trimming, etc)?
>>>>>>>
>>>>>>> I may be jumping the thread in the middle but, if it is for debug
>>>>>>> purposes, as states the subject, shouldn't this entry go to debugfs
>>>>>>> instead of sysfs? I know cpuidle has all the infrastructure there to
>>>>>>> simply add another sysfs entry, but if the intent is to create a debug
>>>>>>> capability, then I'd say it fits under debugfs instead.  Adding Greg
>>>>>>> KH here, as I suppose he may have strong opinion on using sysfs for
>>>>>>> debugging.
>>>>>> Thanks for the comments.
>>>>>>
>>>>>> IMHO, all entries under cpuidle directory are for debug purpose. End users
>>>>>> shouldn't care about them. If we rewrite codes around all the entries, I strongly
>>>>>> agree that we need move them to debugfs.
>>>>>
>>>>> I totally agree, they all need to move out of sysfs.
>>>>>
>>>>>> Here, we just add a new entry under same directory. If we create it under debugfs,
>>>>>> we need create the similar directory tree, which is a duplicate effort. In addition,
>>>>>> users might be confused that why we separate the entries under sysfs and debugfs.
>>>>>
>>>>> They should all be moved there, that will remove any confusion :)
>>>> Greg,
>>>>
>>>> Sorry. I might mislead you.
>>>>
>>>> Basically, we could move all the entries of cpuidle from sysfs to debugfs. But such
>>>> moving would change KBI. There might be many scripts used by end users to parse the
>>>> data. If we change them to debugfs, the scripts wouldn't work and users would
>>>> complain.
>>>>
>>>> What's your opinion about the KBI consistence?
>>>
>>> These files all are debugging files, right?  So they should be moved,
>>> especially as the violate the "one value per file" rule of sysfs.
>>>
>>> Do you know of any tools using these files?  I have never heard of them,
>>> and I was told we should move these files years ago.  So I don't think
>>> there should be any api issues.
>>>
>>> But, if there are, we need to know what they are, and work to preserve
>>> them.  The only way to find out is to move them :)
>> We would move all cpuidle entries to debugfs firstly.
>> 1) Create the similar directory tree on debugfs: cpu/cpuXXX, but just have cpuidle subdirectory;
>> 2) Move our cpuidle->disable patch to debugfs;
>> sysfs cpuXXX has other sub directories. We don't move them this time.
>>
>> The new directory under debugfs becomes:
>> cpu---cpu0---cpuidle
>> 	|
>> 	|
>>        cpu1---cpuidle
>> 	|
>>
>> Is it ok?
>
> Looks fine to me.
>
> greg k-h

I created a series to do this.

[PATCH 1/3] cpuidle: Move cpuidle sysfs entry of each cpu to debugfs.
[PATCH 2/3] cpuidle: Add a debugfs entry to disable specific C state for 
debug purpose.
[PATCH 3/3] cpupower: Update the cpupower tool for new debugfs entries 
of cpuidle.

Below are patches.
---
From: ShuoX Liu <shuox.liu@intel.com>

This patch move cpuidle sysfs entry into debugfs. That is
/sys/devices/system/cpu/cpuXX/cpuidle will be changed to
$(debugfs_mount_dir)/cpu/cpuXX/cpuidle.

Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
Reviewed-by: Yanmin Zhang <yanmin_zhang@intel.com>
---
  Documentation/cpuidle/debugfs.txt |   63 ++++++++++
  Documentation/cpuidle/sysfs.txt   |   59 ---------
  drivers/base/cpu.c                |   14 ++
  drivers/cpuidle/Makefile          |    1 +
  drivers/cpuidle/cpuidle.c         |   23 +---
  drivers/cpuidle/cpuidle.h         |   29 ++++-
  drivers/cpuidle/debugfs.c         |  176 +++++++++++++++++++++++++++
  drivers/cpuidle/sysfs.c           |  239 
-------------------------------------
  include/linux/cpuidle.h           |   10 +-
  9 files changed, 292 insertions(+), 322 deletions(-)
  create mode 100644 Documentation/cpuidle/debugfs.txt
  create mode 100644 drivers/cpuidle/debugfs.c

diff --git a/Documentation/cpuidle/debugfs.txt 
b/Documentation/cpuidle/debugfs.txt
new file mode 100644
index 0000000..7724a69
--- /dev/null
+++ b/Documentation/cpuidle/debugfs.txt
@@ -0,0 +1,63 @@
+
+		Supporting multiple CPU idle levels in kernel
+
+				cpuidle debugfs
+
+Per logical CPU specific cpuidle information are under
+/sys/kernel/debug/cpu/cpuX/cpuidle
+(when your system mounted debugfs at /sys/kernel/debug)
+for each online cpu X
+
+--------------------------------------------------------------------------------
+# ls -lR /sys/kernel/debug/cpu/cpu0/cpuidle/
+/sys/kernel/debug/cpu/cpu0/cpuidle/:
+total 0
+drwxr-xr-x 2 root root 0 Feb  8 10:42 state0
+drwxr-xr-x 2 root root 0 Feb  8 10:42 state1
+drwxr-xr-x 2 root root 0 Feb  8 10:42 state2
+drwxr-xr-x 2 root root 0 Feb  8 10:42 state3
+
+/sys/kernel/debug/cpu/cpu0/cpuidle/state0:
+total 0
+-r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-r--r--r-- 1 root root 4096 Feb  8 10:42 latency
+-r--r--r-- 1 root root 4096 Feb  8 10:42 name
+-r--r--r-- 1 root root 4096 Feb  8 10:42 power
+-r--r--r-- 1 root root 4096 Feb  8 10:42 time
+-r--r--r-- 1 root root 4096 Feb  8 10:42 usage
+
+/sys/kernel/debug/cpu/cpu0/cpuidle/state1:
+total 0
+-r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-r--r--r-- 1 root root 4096 Feb  8 10:42 latency
+-r--r--r-- 1 root root 4096 Feb  8 10:42 name
+-r--r--r-- 1 root root 4096 Feb  8 10:42 power
+-r--r--r-- 1 root root 4096 Feb  8 10:42 time
+-r--r--r-- 1 root root 4096 Feb  8 10:42 usage
+
+/sys/kernel/debug/cpu/cpu0/cpuidle/state2:
+total 0
+-r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-r--r--r-- 1 root root 4096 Feb  8 10:42 latency
+-r--r--r-- 1 root root 4096 Feb  8 10:42 name
+-r--r--r-- 1 root root 4096 Feb  8 10:42 power
+-r--r--r-- 1 root root 4096 Feb  8 10:42 time
+-r--r--r-- 1 root root 4096 Feb  8 10:42 usage
+
+/sys/kernel/debug/cpu/cpu0/cpuidle/state3:
+total 0
+-r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-r--r--r-- 1 root root 4096 Feb  8 10:42 latency
+-r--r--r-- 1 root root 4096 Feb  8 10:42 name
+-r--r--r-- 1 root root 4096 Feb  8 10:42 power
+-r--r--r-- 1 root root 4096 Feb  8 10:42 time
+-r--r--r-- 1 root root 4096 Feb  8 10:42 usage
+--------------------------------------------------------------------------------
+
+
+* desc : Small description about the idle state (string)
+* latency : Latency to exit out of this idle state (in microseconds)
+* name : Name of the idle state (string)
+* power : Power consumed while in this idle state (in milliwatts)
+* time : Total time spent in this idle state (in microseconds)
+* usage : Number of times this state was entered (count)
diff --git a/Documentation/cpuidle/sysfs.txt 
b/Documentation/cpuidle/sysfs.txt
index 50d7b16..588e40b 100644
--- a/Documentation/cpuidle/sysfs.txt
+++ b/Documentation/cpuidle/sysfs.txt
@@ -18,62 +18,3 @@ following objects are visible instead.
  * current_governor
  In this case users can switch the governor at run time by writing
  to current_governor.
-
-
-Per logical CPU specific cpuidle information are under
-/sys/devices/system/cpu/cpuX/cpuidle
-for each online cpu X
-
---------------------------------------------------------------------------------
-# ls -lR /sys/devices/system/cpu/cpu0/cpuidle/
-/sys/devices/system/cpu/cpu0/cpuidle/:
-total 0
-drwxr-xr-x 2 root root 0 Feb  8 10:42 state0
-drwxr-xr-x 2 root root 0 Feb  8 10:42 state1
-drwxr-xr-x 2 root root 0 Feb  8 10:42 state2
-drwxr-xr-x 2 root root 0 Feb  8 10:42 state3
-
-/sys/devices/system/cpu/cpu0/cpuidle/state0:
-total 0
--r--r--r-- 1 root root 4096 Feb  8 10:42 desc
--r--r--r-- 1 root root 4096 Feb  8 10:42 latency
--r--r--r-- 1 root root 4096 Feb  8 10:42 name
--r--r--r-- 1 root root 4096 Feb  8 10:42 power
--r--r--r-- 1 root root 4096 Feb  8 10:42 time
--r--r--r-- 1 root root 4096 Feb  8 10:42 usage
-
-/sys/devices/system/cpu/cpu0/cpuidle/state1:
-total 0
--r--r--r-- 1 root root 4096 Feb  8 10:42 desc
--r--r--r-- 1 root root 4096 Feb  8 10:42 latency
--r--r--r-- 1 root root 4096 Feb  8 10:42 name
--r--r--r-- 1 root root 4096 Feb  8 10:42 power
--r--r--r-- 1 root root 4096 Feb  8 10:42 time
--r--r--r-- 1 root root 4096 Feb  8 10:42 usage
-
-/sys/devices/system/cpu/cpu0/cpuidle/state2:
-total 0
--r--r--r-- 1 root root 4096 Feb  8 10:42 desc
--r--r--r-- 1 root root 4096 Feb  8 10:42 latency
--r--r--r-- 1 root root 4096 Feb  8 10:42 name
--r--r--r-- 1 root root 4096 Feb  8 10:42 power
--r--r--r-- 1 root root 4096 Feb  8 10:42 time
--r--r--r-- 1 root root 4096 Feb  8 10:42 usage
-
-/sys/devices/system/cpu/cpu0/cpuidle/state3:
-total 0
--r--r--r-- 1 root root 4096 Feb  8 10:42 desc
--r--r--r-- 1 root root 4096 Feb  8 10:42 latency
--r--r--r-- 1 root root 4096 Feb  8 10:42 name
--r--r--r-- 1 root root 4096 Feb  8 10:42 power
--r--r--r-- 1 root root 4096 Feb  8 10:42 time
--r--r--r-- 1 root root 4096 Feb  8 10:42 usage
---------------------------------------------------------------------------------
-
-
-* desc : Small description about the idle state (string)
-* latency : Latency to exit out of this idle state (in microseconds)
-* name : Name of the idle state (string)
-* power : Power consumed while in this idle state (in milliwatts)
-* time : Total time spent in this idle state (in microseconds)
-* usage : Number of times this state was entered (count)
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 4dabf50..cc4fa6f 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -12,6 +12,7 @@
  #include <linux/node.h>
  #include <linux/gfp.h>
  #include <linux/percpu.h>
+#include <linux/debugfs.h>

  #include "base.h"

@@ -22,6 +23,9 @@ struct bus_type cpu_subsys = {
  EXPORT_SYMBOL_GPL(cpu_subsys);

  static DEFINE_PER_CPU(struct device *, cpu_sys_devices);
+static struct dentry *cpu_debugfs_root;
+DEFINE_PER_CPU(struct dentry *, cpu_debugfs);
+EXPORT_PER_CPU_SYMBOL_GPL(cpu_debugfs);

  #ifdef CONFIG_HOTPLUG_CPU
  static ssize_t show_online(struct device *dev,
@@ -71,6 +75,8 @@ void unregister_cpu(struct cpu *cpu)
  {
  	int logical_cpu = cpu->dev.id;

+	debugfs_remove_recursive(per_cpu(cpu_debugfs, logical_cpu));
+
  	unregister_cpu_under_node(logical_cpu, cpu_to_node(logical_cpu));

  	device_remove_file(&cpu->dev, &dev_attr_online);
@@ -238,6 +244,7 @@ static void cpu_device_release(struct device *dev)
  int __cpuinit register_cpu(struct cpu *cpu, int num)
  {
  	int error;
+	struct dentry **debugfs = &per_cpu(cpu_debugfs, num);

  	cpu->node_id = cpu_to_node(num);
  	memset(&cpu->dev, 0x00, sizeof(struct device));
@@ -251,6 +258,9 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
  		per_cpu(cpu_sys_devices, num) = &cpu->dev;
  	if (!error)
  		register_cpu_under_node(num, cpu_to_node(num));
+	if (!error && cpu_debugfs_root)
+		*debugfs = debugfs_create_dir(dev_name(&cpu->dev),
+						cpu_debugfs_root);

  #ifdef CONFIG_KEXEC
  	if (!error)
@@ -323,4 +333,8 @@ void __init cpu_dev_init(void)
  #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
  	sched_create_sysfs_power_savings_entries(cpu_subsys.dev_root);
  #endif
+
+	cpu_debugfs_root = debugfs_create_dir("cpu", NULL);
+	if (cpu_debugfs_root == ERR_PTR(-ENODEV))
+		cpu_debugfs_root = NULL;
  }
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index 5634f88..a4640ed 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -3,3 +3,4 @@
  #

  obj-y += cpuidle.o driver.o governor.o sysfs.o governors/
+obj-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 59f4261..b4946bc 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -228,12 +228,9 @@ int cpuidle_enable_device(struct cpuidle_device *dev)

  	poll_idle_init(cpuidle_get_driver());

-	if ((ret = cpuidle_add_state_sysfs(dev)))
-		return ret;
-
  	if (cpuidle_curr_governor->enable &&
  	    (ret = cpuidle_curr_governor->enable(cpuidle_get_driver(), dev)))
-		goto fail_sysfs;
+		return ret;

  	for (i = 0; i < dev->state_count; i++) {
  		dev->states_usage[i].usage = 0;
@@ -243,15 +240,13 @@ int cpuidle_enable_device(struct cpuidle_device *dev)

  	smp_wmb();

+	cpuidle_add_state_debugfs(dev);
+
  	dev->enabled = 1;

  	enabled_devices++;
-	return 0;

-fail_sysfs:
-	cpuidle_remove_state_sysfs(dev);
-
-	return ret;
+	return 0;
  }

  EXPORT_SYMBOL_GPL(cpuidle_enable_device);
@@ -275,7 +270,7 @@ void cpuidle_disable_device(struct cpuidle_device *dev)
  	if (cpuidle_curr_governor->disable)
  		cpuidle_curr_governor->disable(cpuidle_get_driver(), dev);

-	cpuidle_remove_state_sysfs(dev);
+	cpuidle_remove_state_debugfs(dev);
  	enabled_devices--;
  }

@@ -290,7 +285,6 @@ EXPORT_SYMBOL_GPL(cpuidle_disable_device);
   */
  static int __cpuidle_register_device(struct cpuidle_device *dev)
  {
-	int ret;
  	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
  	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();

@@ -303,10 +297,7 @@ static int __cpuidle_register_device(struct 
cpuidle_device *dev)

  	per_cpu(cpuidle_devices, dev->cpu) = dev;
  	list_add(&dev->device_list, &cpuidle_detected_devices);
-	if ((ret = cpuidle_add_sysfs(cpu_dev))) {
-		module_put(cpuidle_driver->owner);
-		return ret;
-	}
+	cpuidle_add_debugfs(cpu_dev);

  	dev->registered = 1;
  	return 0;
@@ -354,7 +345,7 @@ void cpuidle_unregister_device(struct cpuidle_device 
*dev)

  	cpuidle_disable_device(dev);

-	cpuidle_remove_sysfs(cpu_dev);
+	cpuidle_remove_debugfs(cpu_dev);
  	list_del(&dev->device_list);
  	wait_for_completion(&dev->kobj_unregister);
  	per_cpu(cpuidle_devices, dev->cpu) = NULL;
diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
index 7db1866..890545c 100644
--- a/drivers/cpuidle/cpuidle.h
+++ b/drivers/cpuidle/cpuidle.h
@@ -25,9 +25,30 @@ extern int cpuidle_switch_governor(struct 
cpuidle_governor *gov);
  /* sysfs */
  extern int cpuidle_add_interface(struct device *dev);
  extern void cpuidle_remove_interface(struct device *dev);
-extern int cpuidle_add_state_sysfs(struct cpuidle_device *device);
-extern void cpuidle_remove_state_sysfs(struct cpuidle_device *device);
-extern int cpuidle_add_sysfs(struct device *dev);
-extern void cpuidle_remove_sysfs(struct device *dev);
+
+/* debugfs */
+#ifdef CONFIG_DEBUG_FS
+DECLARE_PER_CPU(struct dentry *, cpu_debugfs);
+extern int cpuidle_add_state_debugfs(struct cpuidle_device *device);
+extern void cpuidle_remove_state_debugfs(struct cpuidle_device *device);
+extern int cpuidle_add_debugfs(struct device *dev);
+extern void cpuidle_remove_debugfs(struct device *dev);
+#else
+static inline int cpuidle_add_state_debugfs(struct cpuidle_device *device)
+{
+	return 0;
+}
+static inline
+void cpuidle_remove_state_debugfs(struct cpuidle_device *device)
+{
+}
+static inline int cpuidle_add_debugfs(struct device *cpu_dev)
+{
+	return 0;
+}
+static inline void cpuidle_remove_debugfs(struct device *cpu_dev)
+{
+}
+#endif

  #endif /* __DRIVER_CPUIDLE_H */
diff --git a/drivers/cpuidle/debugfs.c b/drivers/cpuidle/debugfs.c
new file mode 100644
index 0000000..67ddc44
--- /dev/null
+++ b/drivers/cpuidle/debugfs.c
@@ -0,0 +1,176 @@
+/*
+ * debugfs.c - debugfs support
+ *
+ * (C) 2006-2007 Shaohua Li <shaohua.li@intel.com>
+ * (C) 2012 ShuoX Liu <shuox.liu@intel.com>
+ *
+ * This code is licenced under the GPL.
+ */
+
+#include <linux/kernel.h>
+#include <linux/cpuidle.h>
+#include <linux/slab.h>
+#include <linux/debugfs.h>
+
+#include "cpuidle.h"
+
+static int state_open_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t state_name_read(struct file *f, char __user *buf,
+				size_t count, loff_t *off)
+{
+	struct cpuidle_state *state = f->private_data;
+	char buffer[CPUIDLE_NAME_LEN];
+	int len;
+
+	len = snprintf(buffer, sizeof(buffer), "%s\n", state->name);
+
+	return simple_read_from_buffer(buf, count, off, buffer, len);
+}
+
+static const struct file_operations state_name_fops = {
+	.open	= state_open_generic,
+	.read	= state_name_read,
+};
+
+static ssize_t state_desc_read(struct file *f, char __user *buf,
+				size_t count, loff_t *off)
+{
+	struct cpuidle_state *state = f->private_data;
+	char buffer[CPUIDLE_DESC_LEN];
+	int len;
+
+	len = snprintf(buffer, sizeof(buffer), "%s\n", state->desc);
+
+	return simple_read_from_buffer(buf, count, off, buffer, len);
+}
+
+static const struct file_operations state_desc_fops = {
+	.open	= state_open_generic,
+	.read	= state_desc_read,
+};
+
+static void debugfs_add_state_attrs(struct cpuidle_dev_state *dev_state)
+{
+	struct dentry *parent = dev_state->debugfs;
+	struct cpuidle_state *state = dev_state->state;
+	struct cpuidle_state_usage *state_usage = dev_state->state_usage;
+
+	if (!parent)
+		return;
+
+	if (!debugfs_create_file("name", S_IRUGO,
+				parent, state, &state_name_fops))
+		goto error;
+
+	if (!debugfs_create_file("desc", S_IRUGO,
+				parent, state, &state_desc_fops))
+		goto error;
+
+	if (!debugfs_create_u32("latency", S_IRUGO,
+				parent, &state->exit_latency))
+		goto error;
+
+	if (!debugfs_create_u32("power", S_IRUGO,
+				parent, &state->power_usage))
+		goto error;
+
+	if (!debugfs_create_u64("usage", S_IRUGO,
+				parent, &state_usage->usage))
+		goto error;
+
+	if (!debugfs_create_u64("time", S_IRUGO,
+				parent, &state_usage->time))
+		goto error;
+
+	return;
+error:
+	debugfs_remove_recursive(parent);
+}
+
+static inline void cpuidle_free_dev_state(struct cpuidle_device 
*device, int i)
+{
+	struct cpuidle_dev_state *dev_state = device->dev_states[i];
+
+	if (!dev_state)
+		return ;
+	debugfs_remove_recursive(dev_state->debugfs);
+	kfree(dev_state);
+	dev_state = NULL;
+}
+
+int cpuidle_add_state_debugfs(struct cpuidle_device *device)
+{
+	int i, ret = -ENOMEM;
+	char buf[16];
+	struct cpuidle_dev_state *dev_state;
+	struct cpuidle_driver *drv = cpuidle_get_driver();
+	struct dentry *parent = device->debugfs;
+
+	if (!parent)
+		return -ENOENT;
+	/* state statistics */
+	for (i = 0; i < device->state_count; i++) {
+		dev_state =
+			kzalloc(sizeof(struct cpuidle_dev_state), GFP_KERNEL);
+		if (!dev_state)
+			goto error;
+		dev_state->state = &drv->states[i];
+		dev_state->state_usage = &device->states_usage[i];
+
+		sprintf(buf, "state%d", i);
+		dev_state->debugfs = debugfs_create_dir(buf, parent);
+		if (!dev_state->debugfs) {
+			kfree(dev_state);
+			dev_state = NULL;
+			goto error;
+		}
+		dev_state->dev = device;
+		device->dev_states[i] = dev_state;
+		debugfs_add_state_attrs(dev_state);
+	}
+
+	return 0;
+
+error:
+	for (i = i - 1; i >= 0; i--)
+		cpuidle_free_dev_state(device, i);
+	return ret;
+}
+
+void cpuidle_remove_state_debugfs(struct cpuidle_device *device)
+{
+	int i;
+
+	for (i = 0; i < device->state_count; i++)
+		cpuidle_free_dev_state(device, i);
+}
+
+int cpuidle_add_debugfs(struct device *cpu_dev)
+{
+	int cpu = cpu_dev->id;
+	struct cpuidle_device *device;
+	struct dentry *parent = per_cpu(cpu_debugfs, cpu);
+
+	if (!parent)
+		return -ENOENT;
+	device = per_cpu(cpuidle_devices, cpu);
+	device->debugfs = debugfs_create_dir("cpuidle", parent);
+	if (!device->debugfs)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void cpuidle_remove_debugfs(struct device *cpu_dev)
+{
+	int cpu = cpu_dev->id;
+	struct cpuidle_device *dev;
+
+	dev = per_cpu(cpuidle_devices, cpu);
+	debugfs_remove_recursive(dev->debugfs);
+}
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 3fe41fe..dd597a9 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -152,242 +152,3 @@ void cpuidle_remove_interface(struct device *dev)
  {
  	sysfs_remove_group(&dev->kobj, &cpuidle_attr_group);
  }
-
-struct cpuidle_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct cpuidle_device *, char *);
-	ssize_t (*store)(struct cpuidle_device *, const char *, size_t count);
-};
-
-#define define_one_ro(_name, show) \
-	static struct cpuidle_attr attr_##_name = __ATTR(_name, 0444, show, NULL)
-#define define_one_rw(_name, show, store) \
-	static struct cpuidle_attr attr_##_name = __ATTR(_name, 0644, show, store)
-
-#define kobj_to_cpuidledev(k) container_of(k, struct cpuidle_device, kobj)
-#define attr_to_cpuidleattr(a) container_of(a, struct cpuidle_attr, attr)
-static ssize_t cpuidle_show(struct kobject * kobj, struct attribute * 
attr ,char * buf)
-{
-	int ret = -EIO;
-	struct cpuidle_device *dev = kobj_to_cpuidledev(kobj);
-	struct cpuidle_attr * cattr = attr_to_cpuidleattr(attr);
-
-	if (cattr->show) {
-		mutex_lock(&cpuidle_lock);
-		ret = cattr->show(dev, buf);
-		mutex_unlock(&cpuidle_lock);
-	}
-	return ret;
-}
-
-static ssize_t cpuidle_store(struct kobject * kobj, struct attribute * 
attr,
-		     const char * buf, size_t count)
-{
-	int ret = -EIO;
-	struct cpuidle_device *dev = kobj_to_cpuidledev(kobj);
-	struct cpuidle_attr * cattr = attr_to_cpuidleattr(attr);
-
-	if (cattr->store) {
-		mutex_lock(&cpuidle_lock);
-		ret = cattr->store(dev, buf, count);
-		mutex_unlock(&cpuidle_lock);
-	}
-	return ret;
-}
-
-static const struct sysfs_ops cpuidle_sysfs_ops = {
-	.show = cpuidle_show,
-	.store = cpuidle_store,
-};
-
-static void cpuidle_sysfs_release(struct kobject *kobj)
-{
-	struct cpuidle_device *dev = kobj_to_cpuidledev(kobj);
-
-	complete(&dev->kobj_unregister);
-}
-
-static struct kobj_type ktype_cpuidle = {
-	.sysfs_ops = &cpuidle_sysfs_ops,
-	.release = cpuidle_sysfs_release,
-};
-
-struct cpuidle_state_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct cpuidle_state *, \
-					struct cpuidle_state_usage *, char *);
-	ssize_t (*store)(struct cpuidle_state *, const char *, size_t);
-};
-
-#define define_one_state_ro(_name, show) \
-static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0444, 
show, NULL)
-
-#define define_show_state_function(_name) \
-static ssize_t show_state_##_name(struct cpuidle_state *state, \
-			 struct cpuidle_state_usage *state_usage, char *buf) \
-{ \
-	return sprintf(buf, "%u\n", state->_name);\
-}
-
-#define define_show_state_ull_function(_name) \
-static ssize_t show_state_##_name(struct cpuidle_state *state, \
-			struct cpuidle_state_usage *state_usage, char *buf) \
-{ \
-	return sprintf(buf, "%llu\n", state_usage->_name);\
-}
-
-#define define_show_state_str_function(_name) \
-static ssize_t show_state_##_name(struct cpuidle_state *state, \
-			struct cpuidle_state_usage *state_usage, char *buf) \
-{ \
-	if (state->_name[0] == '\0')\
-		return sprintf(buf, "<null>\n");\
-	return sprintf(buf, "%s\n", state->_name);\
-}
-
-define_show_state_function(exit_latency)
-define_show_state_function(power_usage)
-define_show_state_ull_function(usage)
-define_show_state_ull_function(time)
-define_show_state_str_function(name)
-define_show_state_str_function(desc)
-
-define_one_state_ro(name, show_state_name);
-define_one_state_ro(desc, show_state_desc);
-define_one_state_ro(latency, show_state_exit_latency);
-define_one_state_ro(power, show_state_power_usage);
-define_one_state_ro(usage, show_state_usage);
-define_one_state_ro(time, show_state_time);
-
-static struct attribute *cpuidle_state_default_attrs[] = {
-	&attr_name.attr,
-	&attr_desc.attr,
-	&attr_latency.attr,
-	&attr_power.attr,
-	&attr_usage.attr,
-	&attr_time.attr,
-	NULL
-};
-
-#define kobj_to_state_obj(k) container_of(k, struct cpuidle_state_kobj, 
kobj)
-#define kobj_to_state(k) (kobj_to_state_obj(k)->state)
-#define kobj_to_state_usage(k) (kobj_to_state_obj(k)->state_usage)
-#define attr_to_stateattr(a) container_of(a, struct cpuidle_state_attr, 
attr)
-static ssize_t cpuidle_state_show(struct kobject * kobj,
-	struct attribute * attr ,char * buf)
-{
-	int ret = -EIO;
-	struct cpuidle_state *state = kobj_to_state(kobj);
-	struct cpuidle_state_usage *state_usage = kobj_to_state_usage(kobj);
-	struct cpuidle_state_attr * cattr = attr_to_stateattr(attr);
-
-	if (cattr->show)
-		ret = cattr->show(state, state_usage, buf);
-
-	return ret;
-}
-
-static const struct sysfs_ops cpuidle_state_sysfs_ops = {
-	.show = cpuidle_state_show,
-};
-
-static void cpuidle_state_sysfs_release(struct kobject *kobj)
-{
-	struct cpuidle_state_kobj *state_obj = kobj_to_state_obj(kobj);
-
-	complete(&state_obj->kobj_unregister);
-}
-
-static struct kobj_type ktype_state_cpuidle = {
-	.sysfs_ops = &cpuidle_state_sysfs_ops,
-	.default_attrs = cpuidle_state_default_attrs,
-	.release = cpuidle_state_sysfs_release,
-};
-
-static inline void cpuidle_free_state_kobj(struct cpuidle_device 
*device, int i)
-{
-	kobject_put(&device->kobjs[i]->kobj);
-	wait_for_completion(&device->kobjs[i]->kobj_unregister);
-	kfree(device->kobjs[i]);
-	device->kobjs[i] = NULL;
-}
-
-/**
- * cpuidle_add_driver_sysfs - adds driver-specific sysfs attributes
- * @device: the target device
- */
-int cpuidle_add_state_sysfs(struct cpuidle_device *device)
-{
-	int i, ret = -ENOMEM;
-	struct cpuidle_state_kobj *kobj;
-	struct cpuidle_driver *drv = cpuidle_get_driver();
-
-	/* state statistics */
-	for (i = 0; i < device->state_count; i++) {
-		kobj = kzalloc(sizeof(struct cpuidle_state_kobj), GFP_KERNEL);
-		if (!kobj)
-			goto error_state;
-		kobj->state = &drv->states[i];
-		kobj->state_usage = &device->states_usage[i];
-		init_completion(&kobj->kobj_unregister);
-
-		ret = kobject_init_and_add(&kobj->kobj, &ktype_state_cpuidle, 
&device->kobj,
-					   "state%d", i);
-		if (ret) {
-			kfree(kobj);
-			goto error_state;
-		}
-		kobject_uevent(&kobj->kobj, KOBJ_ADD);
-		device->kobjs[i] = kobj;
-	}
-
-	return 0;
-
-error_state:
-	for (i = i - 1; i >= 0; i--)
-		cpuidle_free_state_kobj(device, i);
-	return ret;
-}
-
-/**
- * cpuidle_remove_driver_sysfs - removes driver-specific sysfs attributes
- * @device: the target device
- */
-void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
-{
-	int i;
-
-	for (i = 0; i < device->state_count; i++)
-		cpuidle_free_state_kobj(device, i);
-}
-
-/**
- * cpuidle_add_sysfs - creates a sysfs instance for the target device
- * @dev: the target device
- */
-int cpuidle_add_sysfs(struct device *cpu_dev)
-{
-	int cpu = cpu_dev->id;
-	struct cpuidle_device *dev;
-	int error;
-
-	dev = per_cpu(cpuidle_devices, cpu);
-	error = kobject_init_and_add(&dev->kobj, &ktype_cpuidle, &cpu_dev->kobj,
-				     "cpuidle");
-	if (!error)
-		kobject_uevent(&dev->kobj, KOBJ_ADD);
-	return error;
-}
-
-/**
- * cpuidle_remove_sysfs - deletes a sysfs instance on the target device
- * @dev: the target device
- */
-void cpuidle_remove_sysfs(struct device *cpu_dev)
-{
-	int cpu = cpu_dev->id;
-	struct cpuidle_device *dev;
-
-	dev = per_cpu(cpuidle_devices, cpu);
-	kobject_put(&dev->kobj);
-}
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 712abcc..f605d28 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -76,11 +76,11 @@ cpuidle_set_statedata(struct cpuidle_state_usage 
*st_usage, void *data)
  	st_usage->driver_data = data;
  }

-struct cpuidle_state_kobj {
+struct cpuidle_dev_state {
  	struct cpuidle_state *state;
  	struct cpuidle_state_usage *state_usage;
-	struct completion kobj_unregister;
-	struct kobject kobj;
+	struct cpuidle_device *dev;
+	struct dentry *debugfs;
  };

  struct cpuidle_device {
@@ -91,12 +91,14 @@ struct cpuidle_device {
  	int			last_residency;
  	int			state_count;
  	struct cpuidle_state_usage	states_usage[CPUIDLE_STATE_MAX];
-	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
+	struct cpuidle_dev_state	*dev_states[CPUIDLE_STATE_MAX];

  	struct list_head 	device_list;
  	struct kobject		kobj;
  	struct completion	kobj_unregister;
  	void			*governor_data;
+
+	struct dentry		*debugfs;
  };

  DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
-- 
1.7.1
