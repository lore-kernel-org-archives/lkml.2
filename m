Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab1BJGqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:46:08 -0500
Received: from smtp-out.google.com ([74.125.121.67]:20094 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab1BJGoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:44:04 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 09/15] ARM: tegra: irq: Implement retrigger
Date: Wed,  9 Feb 2011 22:43:18 -0800
Message-Id: <1297320204-31882-10-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297320204-31882-1-git-send-email-ccross@android.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/irq.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index 7fb7349..dfbc219 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -48,6 +48,7 @@ static u32 tegra_lp0_wake_level_any;
 
 static void (*tegra_gic_mask_irq)(struct irq_data *d);
 static void (*tegra_gic_unmask_irq)(struct irq_data *d);
+static void (*tegra_gic_ack_irq)(struct irq_data *d);
 
 /* ensures that sufficient time is passed for a register write to
  * serialize into the 32KHz domain */
@@ -112,10 +113,24 @@ static void tegra_unmask(struct irq_data *d)
 	tegra_legacy_unmask_irq(d->irq);
 }
 
+static void tegra_ack(struct irq_data *d)
+{
+	tegra_legacy_force_irq_clr(d->irq);
+	tegra_gic_ack_irq(d);
+}
+
+static int tegra_retrigger(struct irq_data *d)
+{
+	tegra_legacy_force_irq_set(d->irq);
+	return 1;
+}
+
 static struct irq_chip tegra_irq = {
 	.name			= "PPI",
+	.irq_ack		= tegra_ack,
 	.irq_mask		= tegra_mask,
 	.irq_unmask		= tegra_unmask,
+	.irq_retrigger		= tegra_retrigger,
 };
 
 void __init tegra_init_irq(void)
@@ -132,7 +147,7 @@ void __init tegra_init_irq(void)
 	gic = get_irq_chip(29);
 	tegra_gic_unmask_irq = gic->irq_unmask;
 	tegra_gic_mask_irq = gic->irq_mask;
-	tegra_irq.irq_ack = gic->irq_ack;
+	tegra_gic_ack_irq = gic->irq_ack;
 #ifdef CONFIG_SMP
 	tegra_irq.irq_set_affinity = gic->irq_set_affinity;
 #endif
-- 
1.7.3.1

