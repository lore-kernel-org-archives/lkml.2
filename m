Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1AXCCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 21:02:39 -0500
Received: from smtp-out.google.com ([216.239.44.51]:43026 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab1AXCCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 21:02:08 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 16/28] ARM: tegra: irq: Implement retrigger
Date: Sun, 23 Jan 2011 18:01:21 -0800
Message-Id: <1295834493-5019-17-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1295834493-5019-1-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/irq.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index 12c62a8..2bd5be5 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -208,9 +208,21 @@ static int tegra_set_type(struct irq_data *d, unsigned int flow_type)
 	return 0;
 }
 
+static void tegra_ack(struct irq_data *d)
+{
+	tegra_legacy_force_irq_clr(d->irq);
+	gic_ack_irq(d);
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
-	.irq_ack		= gic_ack_irq,
+	.irq_ack		= tegra_ack,
 	.irq_mask		= tegra_mask,
 	.irq_unmask		= tegra_unmask,
 	.irq_set_wake		= tegra_set_wake,
@@ -218,6 +230,7 @@ static struct irq_chip tegra_irq = {
 #ifdef CONFIG_SMP
 	.irq_set_affinity	= gic_set_cpu,
 #endif
+	.irq_retrigger		= tegra_retrigger,
 };
 
 void __init tegra_init_irq(void)
-- 
1.7.3.1

