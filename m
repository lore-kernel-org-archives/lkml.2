Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2CEHKC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 02:10:02 -0500
Received: from mga01.intel.com ([192.55.52.88]:10532 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab2CEHKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 02:10:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="133441387"
Message-ID: <4F5466C4.2090808@intel.com>
Date: Mon, 05 Mar 2012 15:09:56 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: [PATCH V3] cpuidle: Add a sysfs entry to disable specific C state
 for debug purpose.
References: <C6CB66606345BC4B80CBE69D22ABFBB1021C7F@SHSMSX101.ccr.corp.intel.com>	<1330647453.1916.7.camel@ymzhang> <20120302142303.648285a7.akpm@linux-foundation.org> <C6CB66606345BC4B80CBE69D22ABFBB10220E1@SHSMSX101.ccr.corp.intel.com> <4F545A4E.8010801@linux.vnet.ibm.com>
In-Reply-To: <4F545A4E.8010801@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年03月05日 14:16, Deepthi Dharwar wrote:
> Hi,
>
> On 03/05/2012 08:52 AM, Liu, ShuoX wrote:
>
>>>> It's useful to help developers debug some issues.
>>>
>>> It would help developers more if it was documented a bit.  As it
>>> stands, they'd be lucky if they even knew it existed.
>>>
>>> Looky:
>>>
>>> akpm:/usr/src/linux-3.3-rc5>  grep -ril cpuidle Documentation
>>> Documentation/trace/events-power.txt
>>> Documentation/ABI/testing/sysfs-devices-system-cpu
>>> Documentation/kernel-parameters.txt
>>> Documentation/00-INDEX
>>> Documentation/cpuidle/core.txt
>>> Documentation/cpuidle/sysfs.txt
>>> Documentation/cpuidle/driver.txt
>>> Documentation/cpuidle/governor.txt
>>
>> Thanks Andrew's advice and Yanmin's review. Here is the new patch.
>>
>> From: ShuoX Liu<shuox.liu@intel.com>
>>
>> Some C states of new CPU might be not good. One reason is BIOS might configure
>> them incorrectly. To help developers root cause it quickly, the patch adds a
>> new sysfs entry, so developers could disable specific C state manually.
>>
>> In addition, C state might have much impact on performance tuning, as it takes
>> much time to enter/exit C states, which might delay interrupt processing. With
>> the new debug option, developers could check if a deep C state could  impact
>> performance and how much impact it could cause.
>>
>> Also add this option in Documentation/cpuidle/sysfs.txt.
>
>
>
> Enabling/Disabling particular C-states from sysfs entry is really
> helpful for cpuidle developers for general debugging and performance
> tuning for not just x86 but for all platforms that support cpuidle,
> like arm, powerpc etc .
>
>>
>
>> Signed-off-by: ShuoX Liu<shuox.liu@intel.com>
>> Reviewed-by: Yanmin Zhang<yanmin_zhang@linux.intel.com>

>
> Please update the documentation, rw fields are valid
> for disable flag
> /sys/devices/system/cpu/cpu2/cpuidle/state1 # ls -l
> total 0
I will do so.

>>   static void cpuidle_state_sysfs_release(struct kobject *kobj)
>> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
>> index 712abcc..eb150a5 100644
>> --- a/include/linux/cpuidle.h
>> +++ b/include/linux/cpuidle.h
>> @@ -45,6 +45,7 @@ struct cpuidle_state {
>>        unsigned int    exit_latency; /* in US */
>>        unsigned int    power_usage; /* in mW */
>>        unsigned int    target_residency; /* in US */
>> +     unsigned int    disable;
>>
>>        int (*enter)    (struct cpuidle_device *dev,
>>                        struct cpuidle_driver *drv,
>>

Thanks Deepthi. below is the new patch.

From: ShuoX Liu <shuox.liu@intel.com>

Some C states of new CPU might be not good. One reason is BIOS might 
configure
them incorrectly. To help developers root cause it quickly, the patch adds a
new sysfs entry, so developers could disable specific C state manually.

In addition, C state might have much impact on performance tuning, as it 
takes
much time to enter/exit C states, which might delay interrupt 
processing. With
the new debug option, developers could check if a deep C state could  impact
performance and how much impact it could cause.

Also add this option in Documentation/cpuidle/sysfs.txt.

Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
Reviewed-by: Yanmin Zhang <yanmin_zhang@intel.com>
Reviewed-and-Tested-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
  Documentation/cpuidle/sysfs.txt  |    5 +++++
  drivers/cpuidle/cpuidle.c        |    1 +
  drivers/cpuidle/governors/menu.c |    5 ++++-
  drivers/cpuidle/sysfs.c          |   34 ++++++++++++++++++++++++++++++++++
  include/linux/cpuidle.h          |    1 +
  5 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/Documentation/cpuidle/sysfs.txt 
b/Documentation/cpuidle/sysfs.txt
index 50d7b16..9d28a34 100644
--- a/Documentation/cpuidle/sysfs.txt
+++ b/Documentation/cpuidle/sysfs.txt
@@ -36,6 +36,7 @@ drwxr-xr-x 2 root root 0 Feb  8 10:42 state3
  /sys/devices/system/cpu/cpu0/cpuidle/state0:
  total 0
  -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
  -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
  -r--r--r-- 1 root root 4096 Feb  8 10:42 name
  -r--r--r-- 1 root root 4096 Feb  8 10:42 power
@@ -45,6 +46,7 @@ total 0
  /sys/devices/system/cpu/cpu0/cpuidle/state1:
  total 0
  -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
  -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
  -r--r--r-- 1 root root 4096 Feb  8 10:42 name
  -r--r--r-- 1 root root 4096 Feb  8 10:42 power
@@ -54,6 +56,7 @@ total 0
  /sys/devices/system/cpu/cpu0/cpuidle/state2:
  total 0
  -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
  -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
  -r--r--r-- 1 root root 4096 Feb  8 10:42 name
  -r--r--r-- 1 root root 4096 Feb  8 10:42 power
@@ -63,6 +66,7 @@ total 0
  /sys/devices/system/cpu/cpu0/cpuidle/state3:
  total 0
  -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
  -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
  -r--r--r-- 1 root root 4096 Feb  8 10:42 name
  -r--r--r-- 1 root root 4096 Feb  8 10:42 power
@@ -72,6 +76,7 @@ total 0


  * desc : Small description about the idle state (string)
+* disable : Option to disable this idle state (bool)
  * latency : Latency to exit out of this idle state (in microseconds)
  * name : Name of the idle state (string)
  * power : Power consumed while in this idle state (in milliwatts)
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 59f4261..7d66d3e 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -197,6 +197,7 @@ static void poll_idle_init(struct cpuidle_driver *drv)
  	state->power_usage = -1;
  	state->flags = 0;
  	state->enter = poll_idle;
+	state->disable = 0;
  }
  #else
  static void poll_idle_init(struct cpuidle_driver *drv) {}
diff --git a/drivers/cpuidle/governors/menu.c 
b/drivers/cpuidle/governors/menu.c
index ad09526..5c17ca1 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -280,7 +280,8 @@ static int menu_select(struct cpuidle_driver *drv, 
struct cpuidle_device *dev)
  	 * We want to default to C1 (hlt), not to busy polling
  	 * unless the timer is happening really really soon.
  	 */
-	if (data->expected_us > 5)
+	if (data->expected_us > 5 &&
+		drv->states[CPUIDLE_DRIVER_STATE_START].disable == 0)
  		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;

  	/*
@@ -290,6 +291,8 @@ static int menu_select(struct cpuidle_driver *drv, 
struct cpuidle_device *dev)
  	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
  		struct cpuidle_state *s = &drv->states[i];

+		if (s->disable)
+			continue;
  		if (s->target_residency > data->predicted_us)
  			continue;
  		if (s->exit_latency > latency_req)
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 3fe41fe..1eae29a 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -222,6 +222,9 @@ struct cpuidle_state_attr {
  #define define_one_state_ro(_name, show) \
  static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0444, 
show, NULL)

+#define define_one_state_rw(_name, show, store) \
+static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644, 
show, store)
+
  #define define_show_state_function(_name) \
  static ssize_t show_state_##_name(struct cpuidle_state *state, \
  			 struct cpuidle_state_usage *state_usage, char *buf) \
@@ -229,6 +232,19 @@ static ssize_t show_state_##_name(struct 
cpuidle_state *state, \
  	return sprintf(buf, "%u\n", state->_name);\
  }

+#define define_store_state_function(_name) \
+static ssize_t store_state_##_name(struct cpuidle_state *state, \
+		const char *buf, size_t size) \
+{ \
+	int value; \
+	sscanf(buf, "%d", &value); \
+	if (value) \
+		state->disable = 1; \
+	else \
+		state->disable = 0; \
+	return size; \
+}
+
  #define define_show_state_ull_function(_name) \
  static ssize_t show_state_##_name(struct cpuidle_state *state, \
  			struct cpuidle_state_usage *state_usage, char *buf) \
@@ -251,6 +267,8 @@ define_show_state_ull_function(usage)
  define_show_state_ull_function(time)
  define_show_state_str_function(name)
  define_show_state_str_function(desc)
+define_show_state_function(disable)
+define_store_state_function(disable)

  define_one_state_ro(name, show_state_name);
  define_one_state_ro(desc, show_state_desc);
@@ -258,6 +276,7 @@ define_one_state_ro(latency, show_state_exit_latency);
  define_one_state_ro(power, show_state_power_usage);
  define_one_state_ro(usage, show_state_usage);
  define_one_state_ro(time, show_state_time);
+define_one_state_rw(disable, show_state_disable, store_state_disable);

  static struct attribute *cpuidle_state_default_attrs[] = {
  	&attr_name.attr,
@@ -266,6 +285,7 @@ static struct attribute 
*cpuidle_state_default_attrs[] = {
  	&attr_power.attr,
  	&attr_usage.attr,
  	&attr_time.attr,
+	&attr_disable.attr,
  	NULL
  };

@@ -287,8 +307,22 @@ static ssize_t cpuidle_state_show(struct kobject * 
kobj,
  	return ret;
  }

+static ssize_t cpuidle_state_store(struct kobject *kobj,
+	struct attribute *attr, const char *buf, size_t size)
+{
+	int ret = -EIO;
+	struct cpuidle_state *state = kobj_to_state(kobj);
+	struct cpuidle_state_attr *cattr = attr_to_stateattr(attr);
+
+	if (cattr->store)
+		ret = cattr->store(state, buf, size);
+
+	return ret;
+}
+
  static const struct sysfs_ops cpuidle_state_sysfs_ops = {
  	.show = cpuidle_state_show,
+	.store = cpuidle_state_store,
  };

  static void cpuidle_state_sysfs_release(struct kobject *kobj)
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 712abcc..eb150a5 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -45,6 +45,7 @@ struct cpuidle_state {
  	unsigned int	exit_latency; /* in US */
  	unsigned int	power_usage; /* in mW */
  	unsigned int	target_residency; /* in US */
+	unsigned int    disable;

  	int (*enter)	(struct cpuidle_device *dev,
  			struct cpuidle_driver *drv,
-- 

