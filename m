Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab2IUSei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:34:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36767 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab2IUSc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:32:29 -0400
From: morten.rasmussen@arm.com
To: paulmck@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        suresh.b.siddha@intel.com
Cc: morten.rasmussen@arm.com, linaro-sched-sig@lists.linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 04/10] sched: Introduce priority-based task migration filter
Date: Fri, 21 Sep 2012 19:32:19 +0100
Message-Id: <1348252345-5642-5-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 21 Sep 2012 18:32:25.0116 (UTC) FILETIME=[7239F5C0:01CD9827]
X-MC-Unique: 112092119322700601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8LIYi6O011368

From: Morten Rasmussen <morten.rasmussen@arm.com>

Introduces a priority threshold which prevents low priority task
from migrating to faster hmp_domains (cpus). This is useful for
user-space software which assigns lower task priority to background
task.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 arch/arm/Kconfig    |   13 +++++++++++++
 kernel/sched/fair.c |   15 +++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5b09684..05de193 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1571,6 +1571,19 @@ config SCHED_HMP
 	  !SCHED_AUTOGROUP. Furthermore, normal load-balancing must be disabled
 	  between cpus of different type (DISABLE_CPU_SCHED_DOMAIN_BALANCE).
 
+config SCHED_HMP_PRIO_FILTER
+	bool "(EXPERIMENTAL) Filter HMP migrations by task priority"
+	depends on SCHED_HMP
+	help
+	  Enables task priority based HMP migration filter. Any task with
+	  a NICE value above the threshold will always be on low-power cpus
+	  with less compute capacity.
+
+config SCHED_HMP_PRIO_FILTER_VAL
+	int "NICE priority threshold"
+	default 5
+	depends on SCHED_HMP_PRIO_FILTER
+
 config HAVE_ARM_SCU
 	bool
 	help
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 490f1f0..8f0f3b9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3129,9 +3129,12 @@ static int __init hmp_cpu_mask_setup(void)
  * hmp_down_threshold: max. load allowed for tasks migrating to a slower cpu
  * The default values (512, 256) offer good responsiveness, but may need
  * tweaking suit particular needs.
+ *
+ * hmp_up_prio: Only up migrate task with high priority (<hmp_up_prio)
  */
 unsigned int hmp_up_threshold = 512;
 unsigned int hmp_down_threshold = 256;
+unsigned int hmp_up_prio = NICE_TO_PRIO(CONFIG_SCHED_HMP_PRIO_FILTER_VAL);
 
 static unsigned int hmp_up_migration(int cpu, struct sched_entity *se);
 static unsigned int hmp_down_migration(int cpu, struct sched_entity *se);
@@ -5491,6 +5494,12 @@ static unsigned int hmp_up_migration(int cpu, struct sched_entity *se)
 	if (hmp_cpu_is_fastest(cpu))
 		return 0;
 
+#ifdef CONFIG_SCHED_HMP_PRIO_FILTER
+	/* Filter by task priority */
+	if (p->prio >= hmp_up_prio)
+		return 0;
+#endif
+
 	if (cpumask_intersects(&hmp_faster_domain(cpu)->cpus,
 					tsk_cpus_allowed(p))
 		&& se->avg.load_avg_ratio > hmp_up_threshold) {
@@ -5507,6 +5516,12 @@ static unsigned int hmp_down_migration(int cpu, struct sched_entity *se)
 	if (hmp_cpu_is_slowest(cpu))
 		return 0;
 
+#ifdef CONFIG_SCHED_HMP_PRIO_FILTER
+	/* Filter by task priority */
+	if (p->prio >= hmp_up_prio)
+		return 1;
+#endif
+
 	if (cpumask_intersects(&hmp_slower_domain(cpu)->cpus,
 					tsk_cpus_allowed(p))
 		&& se->avg.load_avg_ratio < hmp_down_threshold) {
-- 
1.7.9.5


