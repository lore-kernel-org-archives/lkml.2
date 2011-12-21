Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1LULuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:50:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab1LULuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:50:06 -0500
Date: Wed, 21 Dec 2011 03:49:43 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-pqeog465zo5hsimtkfz73f27@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        asharma@fb.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, asharma@fb.com, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/fast] perf, x86:
  Provide means for disabling userspace RDPMC
Git-Commit-ID: 0c9d42ed4cee2aa1dfc3a260b741baae8615744f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:49:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c9d42ed4cee2aa1dfc3a260b741baae8615744f
Gitweb:     http://git.kernel.org/tip/0c9d42ed4cee2aa1dfc3a260b741baae8615744f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sun, 20 Nov 2011 23:30:47 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 11:01:11 +0100

perf, x86: Provide means for disabling userspace RDPMC

Allow the disabling of RDPMC via a pmu specific attribute:

  echo 0 > /sys/bus/event_source/devices/cpu/rdpmc

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arun Sharma <asharma@fb.com>
Link: http://lkml.kernel.org/n/tip-pqeog465zo5hsimtkfz73f27@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   55 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event.h |    8 +++++
 include/linux/perf_event.h       |    1 +
 kernel/events/core.c             |    1 +
 4 files changed, 64 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 53b5699..116b040 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
+#include <linux/device.h>
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
@@ -1210,7 +1211,8 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 		break;
 
 	case CPU_STARTING:
-		set_in_cr4(X86_CR4_PCE);
+		if (x86_pmu.attr_rdpmc)
+			set_in_cr4(X86_CR4_PCE);
 		if (x86_pmu.cpu_starting)
 			x86_pmu.cpu_starting(cpu);
 		break;
@@ -1320,6 +1322,8 @@ static int __init init_hw_perf_events(void)
 		}
 	}
 
+	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
+
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
 	pr_info("... generic registers:      %d\n",     x86_pmu.num_counters);
@@ -1555,10 +1559,59 @@ static int x86_pmu_event_idx(struct perf_event *event)
 	return idx + 1;
 }
 
+static ssize_t get_attr_rdpmc(struct device *cdev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	return snprintf(buf, 40, "%d\n", x86_pmu.attr_rdpmc);
+}
+
+static void change_rdpmc(void *info)
+{
+	bool enable = !!(unsigned long)info;
+
+	if (enable)
+		set_in_cr4(X86_CR4_PCE);
+	else
+		clear_in_cr4(X86_CR4_PCE);
+}
+
+static ssize_t set_attr_rdpmc(struct device *cdev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	unsigned long val = simple_strtoul(buf, NULL, 0);
+
+	if (!!val != !!x86_pmu.attr_rdpmc) {
+		x86_pmu.attr_rdpmc = !!val;
+		smp_call_function(change_rdpmc, (void *)val, 1);
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
+
+static struct attribute *x86_pmu_attrs[] = {
+	&dev_attr_rdpmc.attr,
+	NULL,
+};
+
+static struct attribute_group x86_pmu_attr_group = {
+	.attrs = x86_pmu_attrs,
+};
+
+static const struct attribute_group *x86_pmu_attr_groups[] = {
+	&x86_pmu_attr_group,
+	NULL,
+};
+
 static struct pmu pmu = {
 	.pmu_enable	= x86_pmu_enable,
 	.pmu_disable	= x86_pmu_disable,
 
+	.attr_groups	= x86_pmu_attr_groups,
+
 	.event_init	= x86_pmu_event_init,
 
 	.add		= x86_pmu_add,
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 8944062..513d617 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -307,6 +307,14 @@ struct x86_pmu {
 	struct x86_pmu_quirk *quirks;
 	int		perfctr_second_write;
 
+	/*
+	 * sysfs attrs
+	 */
+	int		attr_rdpmc;
+
+	/*
+	 * CPU Hotplug hooks
+	 */
 	int		(*cpu_prepare)(int cpu);
 	void		(*cpu_starting)(int cpu);
 	void		(*cpu_dying)(int cpu);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 02545e6..5311b79 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -615,6 +615,7 @@ struct pmu {
 	struct list_head		entry;
 
 	struct device			*dev;
+	const struct attribute_group	**attr_groups;
 	char				*name;
 	int				type;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 05affc3..dcd4049 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5505,6 +5505,7 @@ static int pmu_dev_alloc(struct pmu *pmu)
 	if (!pmu->dev)
 		goto out;
 
+	pmu->dev->groups = pmu->attr_groups;
 	device_initialize(pmu->dev);
 	ret = dev_set_name(pmu->dev, "%s", pmu->name);
 	if (ret)
