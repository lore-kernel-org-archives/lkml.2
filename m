Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0LEXKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:10:04 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37608 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0LEXKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:10:02 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Daniel Walker <dwalker@codeaurora.org>, Gary King <gking@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/21] ARM: gic: Export irq chip functions
Date: Sun,  5 Dec 2010 15:08:50 -0800
Message-Id: <1291590548-7341-4-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291590548-7341-1-git-send-email-ccross@android.com>
References: <1291590548-7341-1-git-send-email-ccross@android.com>
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
 arch/arm/common/gic.c               |   10 +++++-----
 arch/arm/include/asm/hardware/gic.h |    8 ++++++++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 9deb34f..5c11dab 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -75,7 +75,7 @@ static inline unsigned int gic_irq(unsigned int irq)
 /*
  * Routines to acknowledge, disable and enable interrupts
  */
-static void gic_ack_irq(unsigned int irq)
+void gic_ack_irq(unsigned int irq)
 {
 
 	spin_lock(&irq_controller_lock);
@@ -83,7 +83,7 @@ static void gic_ack_irq(unsigned int irq)
 	spin_unlock(&irq_controller_lock);
 }
 
-static void gic_mask_irq(unsigned int irq)
+void gic_mask_irq(unsigned int irq)
 {
 	u32 mask = 1 << (irq % 32);
 
@@ -92,7 +92,7 @@ static void gic_mask_irq(unsigned int irq)
 	spin_unlock(&irq_controller_lock);
 }
 
-static void gic_unmask_irq(unsigned int irq)
+void gic_unmask_irq(unsigned int irq)
 {
 	u32 mask = 1 << (irq % 32);
 
@@ -101,7 +101,7 @@ static void gic_unmask_irq(unsigned int irq)
 	spin_unlock(&irq_controller_lock);
 }
 
-static int gic_set_type(unsigned int irq, unsigned int type)
+int gic_set_type(unsigned int irq, unsigned int type)
 {
 	void __iomem *base = gic_dist_base(irq);
 	unsigned int gicirq = gic_irq(irq);
@@ -147,7 +147,7 @@ static int gic_set_type(unsigned int irq, unsigned int type)
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
1.7.3.1

