Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0LEXKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:10:19 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37709 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab0LEXKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:10:16 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/21] ARM: tegra: irq: Add set_wake and set_type support for suspend
Date: Sun,  5 Dec 2010 15:09:00 -0800
Message-Id: <1291590548-7341-14-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291590548-7341-1-git-send-email-ccross@android.com>
References: <1291590548-7341-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/include/mach/legacy_irq.h |    3 +-
 arch/arm/mach-tegra/irq.c                     |  106 +++++++++++++++++++++++++
 arch/arm/mach-tegra/legacy_irq.c              |    4 +-
 3 files changed, 110 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/legacy_irq.h b/arch/arm/mach-tegra/include/mach/legacy_irq.h
index d898c0e..3a2bfab 100644
--- a/arch/arm/mach-tegra/include/mach/legacy_irq.h
+++ b/arch/arm/mach-tegra/include/mach/legacy_irq.h
@@ -31,5 +31,6 @@ int tegra_legacy_irq_set_wake(int irq, int enable);
 void tegra_legacy_irq_set_lp1_wake_mask(void);
 void tegra_legacy_irq_restore_mask(void);
 void tegra_init_legacy_irq(void);
-
+void tegra_legacy_irq_suspend(void);
+void tegra_legacy_irq_resume(void);
 #endif
diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index 8f47a9c..ced7007 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -54,6 +54,51 @@ static void pmc_32kwritel(u32 val, unsigned long offs)
 	udelay(130);
 }
 
+int tegra_set_lp0_wake(int irq, int enable)
+{
+	int wake = tegra_irq_to_wake(irq);
+
+	if (wake < 0)
+		return -EINVAL;
+
+	if (enable)
+		tegra_lp0_wake_enb |= 1 << wake;
+	else
+		tegra_lp0_wake_enb &= ~(1 << wake);
+
+	return 0;
+}
+
+int tegra_set_lp0_wake_type(int irq, int flow_type)
+{
+	int wake = tegra_irq_to_wake(irq);
+
+	if (wake < 0)
+		return 0;
+
+	switch (flow_type) {
+	case IRQF_TRIGGER_FALLING:
+	case IRQF_TRIGGER_LOW:
+		tegra_lp0_wake_level &= ~(1 << wake);
+		tegra_lp0_wake_level_any &= ~(1 << wake);
+		break;
+	case IRQF_TRIGGER_HIGH:
+	case IRQF_TRIGGER_RISING:
+		tegra_lp0_wake_level |= 1 << wake;
+		tegra_lp0_wake_level_any &= ~(1 << wake);
+		break;
+
+	case IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING:
+		tegra_lp0_wake_level_any |= 1 << wake;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+
 int tegra_set_lp1_wake(int irq, int enable)
 {
 	return tegra_legacy_irq_set_wake(irq, enable);
@@ -97,6 +142,33 @@ void tegra_set_lp0_wake_pads(u32 wake_enb, u32 wake_level, u32 wake_any)
 	writel(wake_enb, pmc + PMC_WAKE_MASK);
 }
 
+static void tegra_irq_handle_wake(void)
+{
+	int wake;
+	int irq;
+	struct irq_desc *desc;
+
+	unsigned long wake_status = readl(pmc + PMC_WAKE_STATUS);
+	for_each_set_bit(wake, &wake_status, sizeof(wake_status) * 8) {
+		irq = tegra_wake_to_irq(wake);
+		if (!irq) {
+			pr_info("Resume caused by WAKE%d\n", wake);
+			continue;
+		}
+
+		desc = irq_to_desc(irq);
+		if (!desc || !desc->action || !desc->action->name) {
+			pr_info("Resume caused by WAKE%d, irq %d\n", wake, irq);
+			continue;
+		}
+
+		pr_info("Resume caused by WAKE%d, %s\n", wake,
+			desc->action->name);
+
+		generic_handle_irq(irq);
+	}
+}
+
 static void tegra_mask(unsigned int irq)
 {
 	gic_mask_irq(irq);
@@ -109,11 +181,34 @@ static void tegra_unmask(unsigned int irq)
 	tegra_legacy_unmask_irq(irq);
 }
 
+static int tegra_set_wake(unsigned int irq, unsigned int enable)
+{
+	int ret;
+	ret = tegra_set_lp1_wake(irq, enable);
+	if (ret)
+		return ret;
+
+	if (tegra_get_suspend_mode() == TEGRA_SUSPEND_LP0)
+		return tegra_set_lp0_wake(irq, enable);
+
+	return 0;
+}
+
+static int tegra_set_type(unsigned int irq, unsigned int flow_type)
+{
+	if (tegra_get_suspend_mode() == TEGRA_SUSPEND_LP0)
+		return tegra_set_lp0_wake_type(irq, flow_type);
+
+	return 0;
+}
+
 static struct irq_chip tegra_irq = {
 	.name		= "PPI",
 	.ack		= gic_ack_irq,
 	.mask		= tegra_mask,
 	.unmask		= tegra_unmask,
+	.set_wake	= tegra_set_wake,
+	.set_type	= tegra_set_type,
 #ifdef CONFIG_SMP
 	.set_affinity	= gic_set_cpu,
 #endif
@@ -136,3 +231,14 @@ void __init tegra_init_irq(void)
 		set_irq_flags(irq, IRQF_VALID);
 	}
 }
+
+void tegra_irq_suspend(void)
+{
+	tegra_legacy_irq_suspend();
+}
+
+void tegra_irq_resume(void)
+{
+	tegra_legacy_irq_resume();
+	tegra_irq_handle_wake();
+}
diff --git a/arch/arm/mach-tegra/legacy_irq.c b/arch/arm/mach-tegra/legacy_irq.c
index 38eb719..5a6197b 100644
--- a/arch/arm/mach-tegra/legacy_irq.c
+++ b/arch/arm/mach-tegra/legacy_irq.c
@@ -179,7 +179,7 @@ static u32 cop_ier[NUM_ICTLRS];
 static u32 cpu_ier[NUM_ICTLRS];
 static u32 cpu_iep[NUM_ICTLRS];
 
-void tegra_irq_suspend(void)
+void tegra_legacy_irq_suspend(void)
 {
 	unsigned long flags;
 	int i;
@@ -195,7 +195,7 @@ void tegra_irq_suspend(void)
 	local_irq_restore(flags);
 }
 
-void tegra_irq_resume(void)
+void tegra_legacy_irq_resume(void)
 {
 	unsigned long flags;
 	int i;
-- 
1.7.3.1

