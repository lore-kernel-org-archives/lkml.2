Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab1DBGXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 02:23:48 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:54087 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab1DBGXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 02:23:44 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 08/18] cpuidle: create bootparam "cpuidle.off=1"
Date: Sat, 02 Apr 2011 02:22:50 -0400
Message-id: <d0d4b0749cf60042ce56636fdb019ab496fb45ff.1301724243.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.5.rc0
In-reply-to: <1301725380-10579-1-git-send-email-lenb@kernel.org>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
 <1301725380-10579-1-git-send-email-lenb@kernel.org>
In-reply-to: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
References: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

useful for disabling cpuidle to fall back
to architecture-default idle loop

cpuidle drivers and governors will fail to register.
on x86 they'll say so:

intel_idle: intel_idle yielding to (null)
ACPI: acpi_idle yielding to (null)

Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/kernel-parameters.txt |    3 +++
 drivers/cpuidle/cpuidle.c           |   10 ++++++++++
 drivers/cpuidle/cpuidle.h           |    1 +
 drivers/cpuidle/driver.c            |    3 +++
 drivers/cpuidle/governor.c          |    3 +++
 5 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index f4a04c0..08e8a22 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -546,6 +546,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			/proc/<pid>/coredump_filter.
 			See also Documentation/filesystems/proc.txt.
 
+	cpuidle.off=1	[CPU_IDLE]
+			disable the cpuidle sub-system
+
 	cpcihp_generic=	[HW,PCI] Generic port I/O CompactPCI driver
 			Format:
 			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index bf50924..faae2c3 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -28,6 +28,12 @@ LIST_HEAD(cpuidle_detected_devices);
 static void (*pm_idle_old)(void);
 
 static int enabled_devices;
+static int off __read_mostly;
+
+int cpuidle_disabled(void)
+{
+	return off;
+}
 
 #if defined(CONFIG_ARCH_HAS_CPU_IDLE_WAIT)
 static void cpuidle_kick_cpus(void)
@@ -427,6 +433,9 @@ static int __init cpuidle_init(void)
 {
 	int ret;
 
+	if (cpuidle_disabled())
+		return -ENODEV;
+
 	pm_idle_old = pm_idle;
 
 	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
@@ -438,4 +447,5 @@ static int __init cpuidle_init(void)
 	return 0;
 }
 
+module_param(off, int, 0444);
 core_initcall(cpuidle_init);
diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
index 33e50d5..38c3fd8 100644
--- a/drivers/cpuidle/cpuidle.h
+++ b/drivers/cpuidle/cpuidle.h
@@ -13,6 +13,7 @@ extern struct list_head cpuidle_governors;
 extern struct list_head cpuidle_detected_devices;
 extern struct mutex cpuidle_lock;
 extern spinlock_t cpuidle_driver_lock;
+extern int cpuidle_disabled(void);
 
 /* idle loop */
 extern void cpuidle_install_idle_handler(void);
diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index fd1601e..3f7e3ce 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -26,6 +26,9 @@ int cpuidle_register_driver(struct cpuidle_driver *drv)
 	if (!drv)
 		return -EINVAL;
 
+	if (cpuidle_disabled())
+		return -ENODEV;
+
 	spin_lock(&cpuidle_driver_lock);
 	if (cpuidle_curr_driver) {
 		spin_unlock(&cpuidle_driver_lock);
diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
index 724c164..ea2f8e7 100644
--- a/drivers/cpuidle/governor.c
+++ b/drivers/cpuidle/governor.c
@@ -81,6 +81,9 @@ int cpuidle_register_governor(struct cpuidle_governor *gov)
 	if (!gov || !gov->select)
 		return -EINVAL;
 
+	if (cpuidle_disabled())
+		return -ENODEV;
+
 	mutex_lock(&cpuidle_lock);
 	if (__cpuidle_find_governor(gov->name) == NULL) {
 		ret = 0;
-- 
1.7.5.rc0

