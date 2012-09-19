Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2ISP0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:26:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52931 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab2ISP0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:26:21 -0400
Date: Wed, 19 Sep 2012 08:26:02 -0700
From: "tip-bot for Yan, Zheng" <zheng.z.yan@intel.com>
Message-ID: <tip-314d9f63f385096580e9e2a06eaa0745d92fe4ac@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, zheng.z.yan@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <1347263631-23175-2-git-send-email-zheng.z.yan@intel.com>
References: <1347263631-23175-2-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Add cpumask for uncore pmu
Git-Commit-ID: 314d9f63f385096580e9e2a06eaa0745d92fe4ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 08:26:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  314d9f63f385096580e9e2a06eaa0745d92fe4ac
Gitweb:     http://git.kernel.org/tip/314d9f63f385096580e9e2a06eaa0745d92fe4ac
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Mon, 10 Sep 2012 15:53:49 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 17 Sep 2012 13:11:43 -0300

perf/x86: Add cpumask for uncore pmu

This patch adds a cpumask file to the uncore pmu sysfs directory.  The
cpumask file contains one active cpu for every socket.

Signed-off-by: "Yan, Zheng" <zheng.z.yan@intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Link: http://lkml.kernel.org/r/1347263631-23175-2-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   28 ++++++++++++++++++++++--
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |    6 +++-
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 0a55710..62ec3e6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2341,6 +2341,27 @@ int uncore_pmu_event_init(struct perf_event *event)
 	return ret;
 }
 
+static ssize_t uncore_get_attr_cpumask(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &uncore_cpu_mask);
+
+	buf[n++] = '\n';
+	buf[n] = '\0';
+	return n;
+}
+
+static DEVICE_ATTR(cpumask, S_IRUGO, uncore_get_attr_cpumask, NULL);
+
+static struct attribute *uncore_pmu_attrs[] = {
+	&dev_attr_cpumask.attr,
+	NULL,
+};
+
+static struct attribute_group uncore_pmu_attr_group = {
+	.attrs = uncore_pmu_attrs,
+};
+
 static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
 {
 	int ret;
@@ -2378,8 +2399,8 @@ static void __init uncore_type_exit(struct intel_uncore_type *type)
 		free_percpu(type->pmus[i].box);
 	kfree(type->pmus);
 	type->pmus = NULL;
-	kfree(type->attr_groups[1]);
-	type->attr_groups[1] = NULL;
+	kfree(type->events_group);
+	type->events_group = NULL;
 }
 
 static void __init uncore_types_exit(struct intel_uncore_type **types)
@@ -2431,9 +2452,10 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 		for (j = 0; j < i; j++)
 			attrs[j] = &type->event_descs[j].attr.attr;
 
-		type->attr_groups[1] = events_group;
+		type->events_group = events_group;
 	}
 
+	type->pmu_group = &uncore_pmu_attr_group;
 	type->pmus = pmus;
 	return 0;
 fail:
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 5b81c18..e68a455 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -369,10 +369,12 @@ struct intel_uncore_type {
 	struct intel_uncore_pmu *pmus;
 	struct intel_uncore_ops *ops;
 	struct uncore_event_desc *event_descs;
-	const struct attribute_group *attr_groups[3];
+	const struct attribute_group *attr_groups[4];
 };
 
-#define format_group attr_groups[0]
+#define pmu_group attr_groups[0]
+#define format_group attr_groups[1]
+#define events_group attr_groups[2]
 
 struct intel_uncore_ops {
 	void (*init_box)(struct intel_uncore_box *);
