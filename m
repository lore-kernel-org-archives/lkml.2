Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab2LLNcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 08:32:51 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38156 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab2LLNch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 08:32:37 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com
Cc: alex.shi@intel.com, preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, viresh.kumar@linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC PATCH v2 6/6] ARM: sched: clear SD_SHARE_POWERLINE
Date: Wed, 12 Dec 2012 14:31:32 +0100
Message-Id: <1355319092-30980-7-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org>
References: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM platforms take advantage of packing small tasks on few cores.
This is true even when the cores of a cluster can't be power gated
independantly. So we clear SD_SHARE_POWERDOMAIN at MC and CPU level.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/arm/kernel/topology.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 79282eb..f89a4a2 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -201,6 +201,15 @@ static inline void update_cpu_power(unsigned int cpuid, unsigned int mpidr) {}
  */
 struct cputopo_arm cpu_topology[NR_CPUS];
 
+int arch_sd_local_flags(int level)
+{
+	/* Powergate at threading level doesn't make sense */
+	if (level & SD_SHARE_CPUPOWER)
+		return 1*SD_SHARE_POWERDOMAIN;
+
+	return 0*SD_SHARE_POWERDOMAIN;
+}
+
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {
 	return &cpu_topology[cpu].core_sibling;
-- 
1.7.9.5

