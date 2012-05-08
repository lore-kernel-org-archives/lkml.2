Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab2EHOGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 10:06:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:20841 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867Ab2EHOF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 10:05:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140343620"
From: Alex Shi <alex.shi@intel.com>
To: mgorman@suse.de, npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, alex.shi@intel.com, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        borislav.petkov@amd.com, yinghai@kernel.org, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/7] x86/tlb: add tlb_flushall_factor into sysfs for user change
Date: Tue,  8 May 2012 22:03:10 +0800
Message-Id: <1336485790-30902-8-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336485790-30902-1-git-send-email-alex.shi@intel.com>
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel will replace cr3 rewrite with invlpg when
	tlb flush entries <= 1/tlb_flushall_factor
if tlb_flushall_factor is 0, kernel won't do this replace.

User can modify its value according to specific applications.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/kernel/cpu/intel.c |   35 +++++++++++++++++++++++++++++++++++
 drivers/base/cpu.c          |    2 ++
 include/linux/cpu.h         |    2 ++
 3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 42480c6..8a14081 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -662,6 +662,41 @@ void intel_cpu_detect_tlb(struct cpuinfo_x86 *c)
 	intel_tlb_flushall_factor_set(c);
 }
 
+static ssize_t __tlb_flushall_factor_store(const char *buf,
+					size_t count, int smt)
+{
+	unsigned int factor = 0;
+
+	if (sscanf(buf, "%u", &factor) != 1)
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
+	return sprintf(buf, "%u\n", tlb_flushall_factor);
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
+
 static const struct cpu_dev __cpuinitconst intel_cpu_dev = {
 	.c_vendor	= "Intel",
 	.c_ident	= { "GenuineIntel" },
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index adf937b..b46e1b9 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -331,6 +331,8 @@ void __init cpu_dev_init(void)
 
 	cpu_dev_register_generic();
 
+	create_sysfs_tlb_flushall_factor(cpu_subsys.dev_root);
+
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 	sched_create_sysfs_power_savings_entries(cpu_subsys.dev_root);
 #endif
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ee28844..5c953b0 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -36,6 +36,8 @@ extern void cpu_remove_dev_attr(struct device_attribute *attr);
 extern int cpu_add_dev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_dev_attr_group(struct attribute_group *attrs);
 
+extern int create_sysfs_tlb_flushall_factor(struct device *dev);
+
 extern int sched_create_sysfs_power_savings_entries(struct device *dev);
 
 #ifdef CONFIG_HOTPLUG_CPU
-- 
1.7.5.4

