Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab2EJFDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 01:03:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:21455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab2EJFCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 01:02:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142177438"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        alex.shi@intel.com, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH v4 7/7] x86/tlb: add tlb_flushall_factor into sysfs for user testing/tuning
Date: Thu, 10 May 2012 13:00:13 +0800
Message-Id: <1336626013-28413-8-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel will replace cr3 rewrite with invlpg when
  tlb_flush_entries <= active_tlb_entries / 2^tlb_flushall_factor
if tlb_flushall_factor is -1, kernel won't do this replacement.

User can modify its value according to specific applications.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   12 ++++++
 arch/x86/Kconfig.debug                             |   11 ++++++
 arch/x86/kernel/cpu/common.c                       |   37 ++++++++++++++++++++
 drivers/base/cpu.c                                 |    4 ++
 include/linux/cpu.h                                |    4 ++
 5 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index e7be75b..05f8eb7 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -78,6 +78,18 @@ Description:	Dynamic addition and removal of CPU's.  This is not hotplug
 		the system.  Information writtento the file to remove CPU's
 		is architecture specific.
 
+What:		/sys/devices/system/cpu/tlb_flushall_factor
+Date:		May 2012
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	tlb_flushall_factor show and setting interface
+		tlb_flushall_factor shows the balance point in replacing cr3
+		writting with multiple 'invlpg'. It will do this replacement
+		when flush_tlb_lines <= active_lines/2^tlb_flushall_factor
+		If tlb_flushall_factor is -1, means the replacement will be
+		disabled.
+
+		User can set this for the specific CPU or application.
+
 What:		/sys/devices/system/cpu/cpu#/node
 Date:		October 2009
 Contact:	Linux memory management mailing list <linux-mm@kvack.org>
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index e46c214..5b87493 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -129,6 +129,17 @@ config DOUBLEFAULT
 	  option saves about 4k and might cause you much additional grey
 	  hair.
 
+config DEBUG_TLBFLUSH
+	bool "Enable user level tlb flush all setting"
+	depends on DEBUG_KERNEL && (X86_64 || X86_INVLPG)
+	---help---
+	  This option allows user tune tlb_flushall_factor knob that under
+	  /sys/devices/system/cpu, set to -1 means do tlb flush all for any
+	  multiple tlb lines evacuation demand. Otherwise kernel will use
+	  multiple 'invlpg' for the demand when
+	      flush_lines <= active_tlb_lines / 2^tlb_flushall_factor
+	  If in doubt, say "N"
+
 config IOMMU_DEBUG
 	bool "Enable IOMMU debugging"
 	depends on GART_IOMMU && DEBUG_KERNEL
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8879d20..d1986c6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -481,6 +481,43 @@ void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
 		tlb_flushall_factor);
 }
 
+#ifdef CONFIG_DEBUG_TLBFLUSH
+static ssize_t __tlb_flushall_factor_store(const char *buf,
+					size_t count, int smt)
+{
+	short factor = 0;
+
+	if (sscanf(buf, "%hd", &factor) != 1)
+		return -EINVAL;
+
+	tlb_flushall_factor = factor;
+
+	return count;
+}
+
+static ssize_t tlb_flushall_factor_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	return sprintf(buf, "%hd\n", tlb_flushall_factor);
+}
+static ssize_t tlb_flushall_factor_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	return __tlb_flushall_factor_store(buf, count, 0);
+}
+
+static DEVICE_ATTR(tlb_flushall_factor, 0644,
+		   tlb_flushall_factor_show,
+		   tlb_flushall_factor_store);
+
+int __init create_sysfs_tlb_flushall_factor(struct device *dev)
+{
+	return device_create_file(dev, &dev_attr_tlb_flushall_factor);
+}
+#endif
+
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index adf937b..dc0f77b 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -331,6 +331,10 @@ void __init cpu_dev_init(void)
 
 	cpu_dev_register_generic();
 
+#ifdef CONFIG_DEBUG_TLBFLUSH
+	create_sysfs_tlb_flushall_factor(cpu_subsys.dev_root);
+#endif
+
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 	sched_create_sysfs_power_savings_entries(cpu_subsys.dev_root);
 #endif
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ee28844..3eb85a5 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -36,6 +36,10 @@ extern void cpu_remove_dev_attr(struct device_attribute *attr);
 extern int cpu_add_dev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_dev_attr_group(struct attribute_group *attrs);
 
+#ifdef CONFIG_DEBUG_TLBFLUSH
+extern int create_sysfs_tlb_flushall_factor(struct device *dev);
+#endif
+
 extern int sched_create_sysfs_power_savings_entries(struct device *dev);
 
 #ifdef CONFIG_HOTPLUG_CPU
-- 
1.7.5.4

