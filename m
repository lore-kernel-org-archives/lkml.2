Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab2IUSef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:34:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36807 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab2IUSc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:32:29 -0400
From: morten.rasmussen@arm.com
To: paulmck@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        suresh.b.siddha@intel.com
Cc: morten.rasmussen@arm.com, linaro-sched-sig@lists.linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 05/10] ARM: Add HMP scheduling support for ARM architecture
Date: Fri, 21 Sep 2012 19:32:20 +0100
Message-Id: <1348252345-5642-6-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 21 Sep 2012 18:32:25.0601 (UTC) FILETIME=[7283F710:01CD9827]
X-MC-Unique: 112092119322705401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8LIZBCU011376

From: Morten Rasmussen <morten.rasmussen@arm.com>

Adds Kconfig entries to enable HMP scheduling on ARM platforms.
Currently, it disables CPU level sched_domain load-balacing in order
to simplify things. This needs fixing in a later revision. HMP
scheduling will do the load-balancing at this level instead.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 arch/arm/Kconfig                |   14 ++++++++++++++
 arch/arm/include/asm/topology.h |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 05de193..cb80846 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1584,6 +1584,20 @@ config SCHED_HMP_PRIO_FILTER_VAL
 	default 5
 	depends on SCHED_HMP_PRIO_FILTER
 
+config HMP_FAST_CPU_MASK
+	string "HMP scheduler fast CPU mask"
+	depends on SCHED_HMP
+	help
+          Specify the cpuids of the fast CPUs in the system as a list string,
+	  e.g. cpuid 0+1 should be specified as 0-1.
+
+config HMP_SLOW_CPU_MASK
+	string "HMP scheduler slow CPU mask"
+	depends on SCHED_HMP
+	help
+	  Specify the cpuids of the slow CPUs in the system as a list string,
+	  e.g. cpuid 0+1 should be specified as 0-1.
+
 config HAVE_ARM_SCU
 	bool
 	help
diff --git a/arch/arm/include/asm/topology.h b/arch/arm/include/asm/topology.h
index 58b8b84..13a03de 100644
--- a/arch/arm/include/asm/topology.h
+++ b/arch/arm/include/asm/topology.h
@@ -27,6 +27,38 @@ void init_cpu_topology(void);
 void store_cpu_topology(unsigned int cpuid);
 const struct cpumask *cpu_coregroup_mask(int cpu);
 
+#ifdef CONFIG_DISABLE_CPU_SCHED_DOMAIN_BALANCE
+/* Common values for CPUs */
+#ifndef SD_CPU_INIT
+#define SD_CPU_INIT (struct sched_domain) {				\
+	.min_interval		= 1,					\
+	.max_interval		= 4,					\
+	.busy_factor		= 64,					\
+	.imbalance_pct		= 125,					\
+	.cache_nice_tries	= 1,					\
+	.busy_idx		= 2,					\
+	.idle_idx		= 1,					\
+	.newidle_idx		= 0,					\
+	.wake_idx		= 0,					\
+	.forkexec_idx		= 0,					\
+									\
+	.flags			= 0*SD_LOAD_BALANCE			\
+				| 1*SD_BALANCE_NEWIDLE			\
+				| 1*SD_BALANCE_EXEC			\
+				| 1*SD_BALANCE_FORK			\
+				| 0*SD_BALANCE_WAKE			\
+				| 1*SD_WAKE_AFFINE			\
+				| 0*SD_PREFER_LOCAL			\
+				| 0*SD_SHARE_CPUPOWER			\
+				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 0*SD_SERIALIZE			\
+				,					\
+	.last_balance		 = jiffies,				\
+	.balance_interval	= 1,					\
+}
+#endif
+#endif /* CONFIG_DISABLE_CPU_SCHED_DOMAIN_BALANCE */
+
 #else
 
 static inline void init_cpu_topology(void) { }
-- 
1.7.9.5


