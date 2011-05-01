Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1EAW14 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 18:27:56 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10623 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1EAW1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 18:27:53 -0400
From: Colin Cross <ccross@android.com>
To: lakml <linux-arm-kernel@lists.infradead.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCHv2 4/4] ARM: tegra: irq: Add tegra_eoi
Date: Sun,  1 May 2011 15:27:34 -0700
Message-Id: <1304288854-11011-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304284213-11950-5-git-send-email-ccross@android.com>
References: <1304284213-11950-5-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement irq_eoi to allow the GIC irq chip flow controller to
be changed to fasteoi.

Signed-off-by: Colin Cross <ccross@android.com>
---
v2: Add tegra_eoi without removing tegra_ack, patch can now be
    merged safely before Will Deacon's gic fasteoi patch

 arch/arm/mach-tegra/irq.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index da17491..4956c3c 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -95,6 +95,14 @@ static void tegra_ack(struct irq_data *d)
 	tegra_irq_write_mask(d->irq, ICTLR_CPU_IEP_FIR_CLR);
 }
 
+static void tegra_eoi(struct irq_data *d)
+{
+	if (d->irq < FIRST_LEGACY_IRQ)
+		return;
+
+	tegra_irq_write_mask(d->irq, ICTLR_CPU_IEP_FIR_CLR);
+}
+
 static int tegra_retrigger(struct irq_data *d)
 {
 	if (d->irq < FIRST_LEGACY_IRQ)
@@ -116,6 +124,7 @@ void __init tegra_init_irq(void)
 	}
 
 	gic_arch_extn.irq_ack = tegra_ack;
+	gic_arch_extn.irq_eoi = tegra_eoi;
 	gic_arch_extn.irq_mask = tegra_mask;
 	gic_arch_extn.irq_unmask = tegra_unmask;
 	gic_arch_extn.irq_retrigger = tegra_retrigger;
-- 
1.7.4.1

