Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2FRLar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:30:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36293 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2FRLap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:30:45 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>,
        Michal Simek <monstr@monstr.eu>
Subject: [RFC PATCH 3/8] ARM: gic: Introduce new gic_set_cpu
Date: Mon, 18 Jun 2012 13:30:06 +0200
Message-Id: <1340019011-18642-4-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gic_set_cpu enable option to forward specific IRQ to choosen
ARM core.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/arm/common/gic.c               |   11 +++++++++++
 arch/arm/include/asm/hardware/gic.h |    2 ++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index b8e7202..2998d9e 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -257,6 +257,17 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 
 	return IRQ_SET_MASK_OK;
 }
+
+void gic_set_cpu(unsigned int cpu, unsigned int irq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+	struct cpumask mask;
+
+	cpumask_clear(&mask);
+	cpumask_set_cpu(cpu, &mask);
+	gic_set_affinity(d, &mask, true);
+}
+EXPORT_SYMBOL(gic_set_cpu);
 #endif
 
 #ifdef CONFIG_PM
diff --git a/arch/arm/include/asm/hardware/gic.h b/arch/arm/include/asm/hardware/gic.h
index 4b1ce6c..8aa9631 100644
--- a/arch/arm/include/asm/hardware/gic.h
+++ b/arch/arm/include/asm/hardware/gic.h
@@ -46,6 +46,8 @@ void gic_handle_irq(struct pt_regs *regs);
 void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
 void gic_raise_softirq(const struct cpumask *mask, unsigned int irq);
 
+void gic_set_cpu(unsigned int cpu, unsigned int irq);
+
 static inline void gic_init(unsigned int nr, int start,
 			    void __iomem *dist , void __iomem *cpu)
 {
-- 
1.7.0.4

