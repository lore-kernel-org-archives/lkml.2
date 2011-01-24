Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1AXCCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 21:02:41 -0500
Received: from smtp-out.google.com ([74.125.121.67]:57405 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1AXCCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 21:02:08 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Gary King <gking@nvidia.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/28] ARM: gic: Export irq chip functions
Date: Sun, 23 Jan 2011 18:01:08 -0800
Message-Id: <1295834493-5019-4-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1295834493-5019-1-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some systems combine the GIC with an external interrupt controller.
On these systems it may be necessary to update both the GIC registers
and the external controller's registers to control IRQ behavior.
Export the irq chip functions so that these systems can define a
custom irq chip that calls into the GIC handlers.

Signed-off-by: Colin Cross <ccross@android.com>
---
v2: Updated on top of irq_data changes

 arch/arm/common/gic.c               |   11 +++++------
 arch/arm/include/asm/hardware/gic.h |   10 ++++++++++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index a6f8c58..c11f478 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -78,14 +78,14 @@ static inline unsigned int gic_irq(struct irq_data *d)
 /*
  * Routines to acknowledge, disable and enable interrupts
  */
-static void gic_ack_irq(struct irq_data *d)
+void gic_ack_irq(struct irq_data *d)
 {
 	spin_lock(&irq_controller_lock);
 	writel(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
 	spin_unlock(&irq_controller_lock);
 }
 
-static void gic_mask_irq(struct irq_data *d)
+void gic_mask_irq(struct irq_data *d)
 {
 	u32 mask = 1 << (d->irq % 32);
 
@@ -94,7 +94,7 @@ static void gic_mask_irq(struct irq_data *d)
 	spin_unlock(&irq_controller_lock);
 }
 
-static void gic_unmask_irq(struct irq_data *d)
+void gic_unmask_irq(struct irq_data *d)
 {
 	u32 mask = 1 << (d->irq % 32);
 
@@ -103,7 +103,7 @@ static void gic_unmask_irq(struct irq_data *d)
 	spin_unlock(&irq_controller_lock);
 }
 
-static int gic_set_type(struct irq_data *d, unsigned int type)
+int gic_set_type(struct irq_data *d, unsigned int type)
 {
 	void __iomem *base = gic_dist_base(d);
 	unsigned int gicirq = gic_irq(d);
@@ -149,8 +149,7 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 }
 
 #ifdef CONFIG_SMP
-static int
-gic_set_cpu(struct irq_data *d, const struct cpumask *mask_val, bool force)
+int gic_set_cpu(struct irq_data *d, const struct cpumask *mask_val, bool force)
 {
 	void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + (gic_irq(d) & ~3);
 	unsigned int shift = (d->irq % 4) * 8;
diff --git a/arch/arm/include/asm/hardware/gic.h b/arch/arm/include/asm/hardware/gic.h
index d0c2ba9..2ab5cf0 100644
--- a/arch/arm/include/asm/hardware/gic.h
+++ b/arch/arm/include/asm/hardware/gic.h
@@ -33,6 +33,8 @@
 #define GIC_DIST_SOFTINT		0xf00
 
 #ifndef __ASSEMBLY__
+struct irq_data;
+
 extern void __iomem *gic_cpu_base_addr;
 
 void gic_init(unsigned int, unsigned int, void __iomem *, void __iomem *);
@@ -43,6 +45,14 @@ void gic_cpu_exit(unsigned int gic_nr);
 void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
 void gic_raise_softirq(const struct cpumask *mask, unsigned int irq);
 void gic_enable_ppi(unsigned int);
+
+void gic_ack_irq(struct irq_data *d);
+void gic_mask_irq(struct irq_data *d);
+void gic_unmask_irq(struct irq_data *d);
+int gic_set_type(struct irq_data *d, unsigned int type);
+#ifdef CONFIG_SMP
+int gic_set_cpu(struct irq_data *d, const struct cpumask *mask_val, bool force);
+#endif
 #endif
 
 #endif
-- 
1.7.3.1

