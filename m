Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab2C3MT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:19:28 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48688 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760680Ab2C3MSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:41 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ShuoX Liu <shuox.liu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 48/76] cpuidle: add a sysfs entry to disable specific C state
 for debug purpose.
Date: Fri, 30 Mar 2012 06:13:51 -0400
Message-id: <3a53396b0381ec9d5180fd8fe7a681c8ce95fd9a.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

Some C states of new CPU might be not good.  One reason is BIOS might
configure them incorrectly.  To help developers root cause it quickly, the
patch adds a new sysfs entry, so developers could disable specific C state
manually.

In addition, C state might have much impact on performance tuning, as it
takes much time to enter/exit C states, which might delay interrupt
processing.  With the new debug option, developers could check if a deep C
state could impact performance and how much impact it could cause.

Also add this option in Documentation/cpuidle/sysfs.txt.

[akpm@linux-foundation.org: check kstrtol return value]
Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
Reviewed-by: Yanmin Zhang <yanmin_zhang@intel.com>
Reviewed-and-Tested-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/cpuidle/sysfs.txt  |    5 +++++
 drivers/cpuidle/cpuidle.c        |    1 +
 drivers/cpuidle/governors/menu.c |    5 ++++-
 drivers/cpuidle/sysfs.c          |   40 ++++++++++++++++++++++++++++++++++++++
 include/linux/cpuidle.h          |    1 +
 5 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/Documentation/cpuidle/sysfs.txt b/Documentation/cpuidle/sysfs.txt
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
index 4869b55..77304b6 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -245,6 +245,7 @@ static void poll_idle_init(struct cpuidle_driver *drv)
 	state->power_usage = -1;
 	state->flags = 0;
 	state->enter = poll_idle;
+	state->disable = 0;
 }
 #else
 static void poll_idle_init(struct cpuidle_driver *drv) {}
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index ad09526..5c17ca1 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -280,7 +280,8 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	 * We want to default to C1 (hlt), not to busy polling
 	 * unless the timer is happening really really soon.
 	 */
-	if (data->expected_us > 5)
+	if (data->expected_us > 5 &&
+		drv->states[CPUIDLE_DRIVER_STATE_START].disable == 0)
 		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
 
 	/*
@@ -290,6 +291,8 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
 		struct cpuidle_state *s = &drv->states[i];
 
+		if (s->disable)
+			continue;
 		if (s->target_residency > data->predicted_us)
 			continue;
 		if (s->exit_latency > latency_req)
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 3fe41fe..88032b4 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -11,6 +11,7 @@
 #include <linux/sysfs.h>
 #include <linux/slab.h>
 #include <linux/cpu.h>
+#include <linux/capability.h>
 
 #include "cpuidle.h"
 
@@ -222,6 +223,9 @@ struct cpuidle_state_attr {
 #define define_one_state_ro(_name, show) \
 static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0444, show, NULL)
 
+#define define_one_state_rw(_name, show, store) \
+static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644, show, store)
+
 #define define_show_state_function(_name) \
 static ssize_t show_state_##_name(struct cpuidle_state *state, \
 			 struct cpuidle_state_usage *state_usage, char *buf) \
@@ -229,6 +233,24 @@ static ssize_t show_state_##_name(struct cpuidle_state *state, \
 	return sprintf(buf, "%u\n", state->_name);\
 }
 
+#define define_store_state_function(_name) \
+static ssize_t store_state_##_name(struct cpuidle_state *state, \
+		const char *buf, size_t size) \
+{ \
+	long value; \
+	int err; \
+	if (!capable(CAP_SYS_ADMIN)) \
+		return -EPERM; \
+	err = kstrtol(buf, 0, &value); \
+	if (err) \
+		return err; \
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
@@ -251,6 +273,8 @@ define_show_state_ull_function(usage)
 define_show_state_ull_function(time)
 define_show_state_str_function(name)
 define_show_state_str_function(desc)
+define_show_state_function(disable)
+define_store_state_function(disable)
 
 define_one_state_ro(name, show_state_name);
 define_one_state_ro(desc, show_state_desc);
@@ -258,6 +282,7 @@ define_one_state_ro(latency, show_state_exit_latency);
 define_one_state_ro(power, show_state_power_usage);
 define_one_state_ro(usage, show_state_usage);
 define_one_state_ro(time, show_state_time);
+define_one_state_rw(disable, show_state_disable, store_state_disable);
 
 static struct attribute *cpuidle_state_default_attrs[] = {
 	&attr_name.attr,
@@ -266,6 +291,7 @@ static struct attribute *cpuidle_state_default_attrs[] = {
 	&attr_power.attr,
 	&attr_usage.attr,
 	&attr_time.attr,
+	&attr_disable.attr,
 	NULL
 };
 
@@ -287,8 +313,22 @@ static ssize_t cpuidle_state_show(struct kobject * kobj,
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
index 927db28..ca4e498 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -46,6 +46,7 @@ struct cpuidle_state {
 	unsigned int	exit_latency; /* in US */
 	unsigned int	power_usage; /* in mW */
 	unsigned int	target_residency; /* in US */
+	unsigned int    disable;
 
 	int (*enter)	(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
-- 
1.7.10.rc2.19.gfae9d

