Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1EAVKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 17:10:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58125 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1EAVKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 17:10:43 -0400
From: Colin Cross <ccross@android.com>
To: lakml <linux-arm-kernel@lists.infradead.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ARM: tegra: irq: convert to gic arch extensions
Date: Sun,  1 May 2011 14:10:10 -0700
Message-Id: <1304284213-11950-2-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304284213-11950-1-git-send-email-ccross@android.com>
References: <1304284213-11950-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the ugly hack that inserts legacy irq controller calls
into the irq call paths by reading and replacing the gic irq
chip with the new gic arch extensions.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/irq.c |   54 +++++++++++++-------------------------------
 1 files changed, 16 insertions(+), 38 deletions(-)

diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index 4330d89..567b75c 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -1,8 +1,8 @@
 /*
- * Copyright (C) 2010 Google, Inc.
+ * Copyright (C) 2011 Google, Inc.
  *
  * Author:
- *	Colin Cross <ccross@google.com>
+ *	Colin Cross <ccross@android.com>
  *
  * Copyright (C) 2010, NVIDIA Corporation
  *
@@ -46,10 +46,6 @@ static u32 tegra_lp0_wake_enb;
 static u32 tegra_lp0_wake_level;
 static u32 tegra_lp0_wake_level_any;
 
-static void (*tegra_gic_mask_irq)(struct irq_data *d);
-static void (*tegra_gic_unmask_irq)(struct irq_data *d);
-static void (*tegra_gic_ack_irq)(struct irq_data *d);
-
 /* ensures that sufficient time is passed for a register write to
  * serialize into the 32KHz domain */
 static void pmc_32kwritel(u32 val, unsigned long offs)
@@ -103,58 +99,40 @@ void tegra_set_lp0_wake_pads(u32 wake_enb, u32 wake_level, u32 wake_any)
 
 static void tegra_mask(struct irq_data *d)
 {
-	tegra_gic_mask_irq(d);
-	tegra_legacy_mask_irq(d->irq);
+	if (d->irq >= 32)
+		tegra_legacy_mask_irq(d->irq);
 }
 
 static void tegra_unmask(struct irq_data *d)
 {
-	tegra_gic_unmask_irq(d);
-	tegra_legacy_unmask_irq(d->irq);
+	if (d->irq >= 32)
+		tegra_legacy_unmask_irq(d->irq);
 }
 
 static void tegra_ack(struct irq_data *d)
 {
-	tegra_legacy_force_irq_clr(d->irq);
-	tegra_gic_ack_irq(d);
+	if (d->irq >= 32)
+		tegra_legacy_force_irq_clr(d->irq);
 }
 
 static int tegra_retrigger(struct irq_data *d)
 {
+	if (d->irq < 32)
+		return 0;
+
 	tegra_legacy_force_irq_set(d->irq);
 	return 1;
 }
 
-static struct irq_chip tegra_irq = {
-	.name			= "PPI",
-	.irq_ack		= tegra_ack,
-	.irq_mask		= tegra_mask,
-	.irq_unmask		= tegra_unmask,
-	.irq_retrigger		= tegra_retrigger,
-};
-
 void __init tegra_init_irq(void)
 {
-	struct irq_chip *gic;
-	unsigned int i;
-	int irq;
-
 	tegra_init_legacy_irq();
 
+	gic_arch_extn.irq_ack = tegra_ack;
+	gic_arch_extn.irq_mask = tegra_mask;
+	gic_arch_extn.irq_unmask = tegra_unmask;
+	gic_arch_extn.irq_retrigger = tegra_retrigger;
+
 	gic_init(0, 29, IO_ADDRESS(TEGRA_ARM_INT_DIST_BASE),
 		 IO_ADDRESS(TEGRA_ARM_PERIF_BASE + 0x100));
-
-	gic = irq_get_chip(29);
-	tegra_gic_unmask_irq = gic->irq_unmask;
-	tegra_gic_mask_irq = gic->irq_mask;
-	tegra_gic_ack_irq = gic->irq_ack;
-#ifdef CONFIG_SMP
-	tegra_irq.irq_set_affinity = gic->irq_set_affinity;
-#endif
-
-	for (i = 0; i < INT_MAIN_NR; i++) {
-		irq = INT_PRI_BASE + i;
-		irq_set_chip_and_handler(irq, &tegra_irq, handle_level_irq);
-		set_irq_flags(irq, IRQF_VALID);
-	}
 }
-- 
1.7.4.1

