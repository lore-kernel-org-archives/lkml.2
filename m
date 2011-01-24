Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab1AXCHg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 21:07:36 -0500
Received: from smtp-out.google.com ([216.239.44.51]:43093 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1AXCCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 21:02:15 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/28] ARM: tegra: irq: Rename gic pointers to avoid conflicts
Date: Sun, 23 Jan 2011 18:01:06 -0800
Message-Id: <1295834493-5019-2-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1295834493-5019-1-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A future patch will export gic_mask_irq and gic_unmask_irq.
Rename the pointers in arch/arm/mach-tegra/irq.c to avoid
a compile error.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/irq.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index de7dfad..17c74d2 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -46,24 +46,24 @@
 #define ICTLR_COP_IER_CLR	0x38
 #define ICTLR_COP_IEP_CLASS	0x3c
 
-static void (*gic_mask_irq)(struct irq_data *d);
-static void (*gic_unmask_irq)(struct irq_data *d);
+static void (*tegra_gic_mask_irq)(struct irq_data *d);
+static void (*tegra_gic_unmask_irq)(struct irq_data *d);
 
-#define irq_to_ictlr(irq) (((irq)-32) >> 5)
+#define irq_to_ictlr(irq) (((irq) - 32) >> 5)
 static void __iomem *tegra_ictlr_base = IO_ADDRESS(TEGRA_PRIMARY_ICTLR_BASE);
-#define ictlr_to_virt(ictlr) (tegra_ictlr_base + (ictlr)*0x100)
+#define ictlr_to_virt(ictlr) (tegra_ictlr_base + (ictlr) * 0x100)
 
 static void tegra_mask(struct irq_data *d)
 {
 	void __iomem *addr = ictlr_to_virt(irq_to_ictlr(d->irq));
-	gic_mask_irq(d);
-	writel(1<<(d->irq&31), addr+ICTLR_CPU_IER_CLR);
+	tegra_gic_mask_irq(d);
+	writel(1 << (d->irq & 31), addr+ICTLR_CPU_IER_CLR);
 }
 
 static void tegra_unmask(struct irq_data *d)
 {
 	void __iomem *addr = ictlr_to_virt(irq_to_ictlr(d->irq));
-	gic_unmask_irq(d);
+	tegra_gic_unmask_irq(d);
 	writel(1<<(d->irq&31), addr+ICTLR_CPU_IER_SET);
 }
 
@@ -98,8 +98,8 @@ void __init tegra_init_irq(void)
 		 IO_ADDRESS(TEGRA_ARM_PERIF_BASE + 0x100));
 
 	gic = get_irq_chip(29);
-	gic_unmask_irq = gic->irq_unmask;
-	gic_mask_irq = gic->irq_mask;
+	tegra_gic_unmask_irq = gic->irq_unmask;
+	tegra_gic_mask_irq = gic->irq_mask;
 	tegra_irq.irq_ack = gic->irq_ack;
 #ifdef CONFIG_SMP
 	tegra_irq.irq_set_affinity = gic->irq_set_affinity;
-- 
1.7.3.1

