Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543Ab2EUX7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:59:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:38254 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab2EUX7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:59:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155409300"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: agordeev@redhat.com
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        gorcunov@openvz.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 1/2] x86, irq: update irq_cfg domain unless the new affinity is a subset of the current domain
Date: Mon, 21 May 2012 16:58:01 -0700
Message-Id: <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, irq_cfg domain is mostly static. Either all cpu's (used by flat
mode) or one cpu (first cpu in the irq afffinity mask) to which irq is being
migrated (this is used by the rest of apic modes).

Upcoming x2apic cluster mode optimization patch allows the irq to be sent
to any cpu in the x2apic cluster (if supported by the HW). So irq_cfg
domain changes on the fly (depending on which cpu in the x2apic cluster
is online).

Instead of checking for any intersection between the new irq affinity
mask and the current irq_cfg domain, check if the new irq affinity mask
is a subset of the current irq_cfg domain. Otherwise proceed with
updating the irq_cfg domain aswell as assigning vector's on all the cpu's
specified in the new mask.

This also cleans up a workaround in updating irq_cfg domain for legacy irq's
that are handled by the IO-APIC.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ffdc152..bbf8c43 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1137,8 +1137,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	old_vector = cfg->vector;
 	if (old_vector) {
 		cpumask_and(tmp_mask, mask, cpu_online_mask);
-		cpumask_and(tmp_mask, cfg->domain, tmp_mask);
-		if (!cpumask_empty(tmp_mask)) {
+		if (cpumask_subset(tmp_mask, cfg->domain)) {
 			free_cpumask_var(tmp_mask);
 			return 0;
 		}
@@ -1152,6 +1151,11 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 
 		apic->vector_allocation_domain(cpu, tmp_mask);
 
+		if (cpumask_subset(tmp_mask, cfg->domain)) {
+			free_cpumask_var(tmp_mask);
+			return 0;
+		}
+
 		vector = current_vector;
 		offset = current_offset;
 next:
@@ -1357,13 +1361,6 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 
 	if (!IO_APIC_IRQ(irq))
 		return;
-	/*
-	 * For legacy irqs, cfg->domain starts with cpu 0 for legacy
-	 * controllers like 8259. Now that IO-APIC can handle this irq, update
-	 * the cfg->domain.
-	 */
-	if (irq < legacy_pic->nr_legacy_irqs && cpumask_test_cpu(0, cfg->domain))
-		apic->vector_allocation_domain(0, cfg->domain);
 
 	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
 		return;
-- 
1.7.6.5

