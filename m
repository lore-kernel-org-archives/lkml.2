Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0JACtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 22:49:20 -0400
Received: from smtp-out.google.com ([74.125.121.35]:24027 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab0JACtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 22:49:17 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] gic: Export irq chip functions
Date: Thu, 30 Sep 2010 19:48:54 -0700
Message-Id: <1285901335-26354-2-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285901335-26354-1-git-send-email-ccross@android.com>
References: <1285901335-26354-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some systems combine the GIC with an external interrupt controller.
On these systems it may be necessary to update both the GIC registers
and the external controller's registers to control IRQ behavior.
Export the irq chip functions so that these systems can define a
custom irq chip that calls into the GIC handlers.

Change-Id: I17fc4440fa2c91cc63004abf69c8e872b55c83c6
Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/common/gic.c               |   10 +++++-----
 arch/arm/include/asm/hardware/gic.h |    8 ++++++++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index cfbe8b1..48a70af 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -87,7 +87,7 @@ static inline unsigned int gic_irq(unsigned int irq)
  * our "acknowledge" routine disable the interrupt, then mark it as
  * complete.
  */
-static void gic_ack_irq(unsigned int irq)
+void gic_ack_irq(unsigned int irq)
 {
 	u32 mask = 1 << (irq % 32);
 
@@ -97,7 +97,7 @@ static void gic_ack_irq(unsigned int irq)
 	spin_unlock(&irq_controller_lock);
 }
 
-static void gic_mask_irq(unsigned int irq)
+void gic_mask_irq(unsigned int irq)
 {
 	u32 mask = 1 << (irq % 32);
 
@@ -106,7 +106,7 @@ static void gic_mask_irq(unsigned int irq)
 	spin_unlock(&irq_controller_lock);
 }
 
-static void gic_unmask_irq(unsigned int irq)
+void gic_unmask_irq(unsigned int irq)
 {
 	u32 mask = 1 << (irq % 32);
 
@@ -115,7 +115,7 @@ static void gic_unmask_irq(unsigned int irq)
 	spin_unlock(&irq_controller_lock);
 }
 
-static int gic_set_type(unsigned int irq, unsigned int type)
+int gic_set_type(unsigned int irq, unsigned int type)
 {
 	void __iomem *base = gic_dist_base(irq);
 	unsigned int gicirq = gic_irq(irq);
@@ -161,7 +161,7 @@ static int gic_set_type(unsigned int irq, unsigned int type)
 }
 
 #ifdef CONFIG_SMP
-static int gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
+int gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
 {
 	void __iomem *reg = gic_dist_base(irq) + GIC_DIST_TARGET + (gic_irq(irq) & ~3);
 	unsigned int shift = (irq % 4) * 8;
diff --git a/arch/arm/include/asm/hardware/gic.h b/arch/arm/include/asm/hardware/gic.h
index 0a198b0..5fd0ff2 100644
--- a/arch/arm/include/asm/hardware/gic.h
+++ b/arch/arm/include/asm/hardware/gic.h
@@ -41,6 +41,14 @@ void gic_cpu_init(unsigned int gic_nr, void __iomem *base);
 void gic_cpu_exit(unsigned int gic_nr);
 void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
 void gic_raise_softirq(const struct cpumask *mask, unsigned int irq);
+
+void gic_ack_irq(unsigned int irq);
+void gic_mask_irq(unsigned int irq);
+void gic_unmask_irq(unsigned int irq);
+int gic_set_type(unsigned int irq, unsigned int type);
+#ifdef CONFIG_SMP
+int gic_set_cpu(unsigned int irq, const struct cpumask *mask_val);
+#endif
 #endif
 
 #endif
-- 
1.7.1

