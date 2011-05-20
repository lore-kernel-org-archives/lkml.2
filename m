Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528Ab1ETNlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:41:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:36131 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934137Ab1ETNls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:41:48 -0400
Date: Fri, 20 May 2011 13:41:37 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Message-ID: <tip-a39d1f3f67f6a3d72b24f0d8bf9a295a27ea448e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110519234637.421800999@sbsiddha-MOBL3.sc.intel.com>
References: <20110519234637.421800999@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, x2apic: Track the x2apic cluster sibling map
Git-Commit-ID: a39d1f3f67f6a3d72b24f0d8bf9a295a27ea448e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 13:41:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a39d1f3f67f6a3d72b24f0d8bf9a295a27ea448e
Gitweb:     http://git.kernel.org/tip/a39d1f3f67f6a3d72b24f0d8bf9a295a27ea448e
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Thu, 19 May 2011 16:45:48 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 13:41:08 +0200

x86, x2apic: Track the x2apic cluster sibling map

In the case of x2apic cluster mode, we can group IPI register
writes based on the cluster group instead of individual per-cpu
destination messages.

For this purpose, track the cpu's that belong to the same x2apic
cluster.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: steiner@sgi.com
Cc: yinghai@kernel.org
Link: http://lkml.kernel.org/r/20110519234637.421800999@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_cluster.c |   72 ++++++++++++++++++++++++++++++++-
 1 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index b261799..4b2bb13 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -11,6 +11,7 @@
 #include <asm/ipi.h>
 
 static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
+static DEFINE_PER_CPU(cpumask_var_t, cpus_in_cluster);
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
@@ -48,6 +49,11 @@ static void
 	native_x2apic_icr_write(cfg, apicid);
 }
 
+static inline u32 x2apic_cluster(int cpu)
+{
+	return per_cpu(x86_cpu_to_logical_apicid, cpu) >> 16;
+}
+
 /*
  * for now, we send the IPI's one by one in the cpumask.
  * TBD: Based on the cpu mask, we can send the IPI's to the cluster group
@@ -163,14 +169,76 @@ static void x2apic_send_IPI_self(int vector)
 
 static void init_x2apic_ldr(void)
 {
+	unsigned int this_cpu = smp_processor_id();
+	unsigned int cpu;
+
+	per_cpu(x86_cpu_to_logical_apicid, this_cpu) = apic_read(APIC_LDR);
+
+	__cpu_set(this_cpu, per_cpu(cpus_in_cluster, this_cpu));
+	for_each_online_cpu(cpu) {
+		if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
+			continue;
+		__cpu_set(this_cpu, per_cpu(cpus_in_cluster, cpu));
+		__cpu_set(cpu, per_cpu(cpus_in_cluster, this_cpu));
+	}
+}
+
+ /*
+  * At CPU state changes, update the x2apic cluster sibling info.
+  */
+static int __cpuinit
+update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	unsigned int this_cpu = (unsigned long)hcpu;
+	unsigned int cpu;
+	int err = 0;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+		if (!zalloc_cpumask_var(&per_cpu(cpus_in_cluster, this_cpu),
+					GFP_KERNEL)) {
+			err = -ENOMEM;
+		}
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+	case CPU_DEAD:
+		for_each_online_cpu(cpu) {
+			if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
+				continue;
+			__cpu_clear(this_cpu, per_cpu(cpus_in_cluster, cpu));
+			__cpu_clear(cpu, per_cpu(cpus_in_cluster, this_cpu));
+		}
+		free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
+		break;
+	}
+
+	return notifier_from_errno(err);
+}
+
+static struct notifier_block __refdata x2apic_cpu_notifier = {
+	.notifier_call = update_clusterinfo,
+};
+
+static int x2apic_init_cpu_notifier(void)
+{
 	int cpu = smp_processor_id();
 
-	per_cpu(x86_cpu_to_logical_apicid, cpu) = apic_read(APIC_LDR);
+	zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
+
+	BUG_ON(!per_cpu(cpus_in_cluster, cpu));
+
+	__cpu_set(cpu, per_cpu(cpus_in_cluster, cpu));
+	register_hotcpu_notifier(&x2apic_cpu_notifier);
+	return 1;
 }
 
 static int x2apic_cluster_probe(void)
 {
-	return x2apic_mode;
+	if (x2apic_mode)
+		return x2apic_init_cpu_notifier();
+	else
+		return 0;
 }
 
 struct apic apic_x2apic_cluster = {
