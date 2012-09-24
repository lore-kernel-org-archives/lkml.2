Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab2IXDGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 23:06:22 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61757 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2IXDGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 23:06:21 -0400
MIME-Version: 1.0
Date: Mon, 24 Sep 2012 12:06:19 +0900
Message-ID: <CAOAMb1DEKrgjtq-xRB+Qy1+_8D-G+6g2v9QSLMisVNbKa8+jSA@mail.gmail.com>
Subject: [PATCH] ARM: gic: fix irq affinity mismatch.
From: Chanho Min <chanho0207@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if we set affinity to multiple cpus via procfs, gic_set_affinity
allows to set one target only. But, '/proc/irq/xxx/smp_affinity' shows
as we are successful in the setting of multiple affinity. Thus irq_data->
affinity mismatches with the GICD_ITARGETSRs.

fix it as bellows.
- Set the default affinity to the boot cpu in gic_dist_init. thereafter,
irq_data->affinity will be set to default 1-bit affinity.
- Even if we write multiple bits to smp_affinity, both irq_data and gic
register will be set one cpu. procfs will show 1 bit affinity as well.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 arch/arm/common/gic.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index aa52699..fb8ac8e 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -249,6 +249,12 @@ static int gic_set_affinity(struct irq_data *d,
const struct cpumask *mask_val,
 	writel_relaxed(val | bit, reg);
 	raw_spin_unlock(&irq_controller_lock);

+	if (cpumask_next_and(cpu, mask_val, cpu_present_mask) < nr_cpu_ids) {
+		cpumask_clear(d->affinity);
+		cpumask_set_cpu(cpu, d->affinity);
+		return IRQ_SET_MASK_OK_NOCOPY;
+	}
+
 	return IRQ_SET_MASK_OK;
 }
 #endif
@@ -355,6 +361,12 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
 	cpumask |= cpumask << 8;
 	cpumask |= cpumask << 16;

+#ifdef CONFIG_SMP
+	/* Set the default affinity to the boot cpu. */
+	cpumask_clear(irq_default_affinity);
+	cpumask_set_cpu(cpu, irq_default_affinity);
+#endif
+
 	writel_relaxed(0, base + GIC_DIST_CTRL);

 	/*
-- 
1.7.9.5
