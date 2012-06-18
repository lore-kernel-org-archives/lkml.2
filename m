Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2FRLal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:30:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48874 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab2FRLah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:30:37 -0400
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
Subject: [RFC PATCH 1/8] ARM: gic: Support forcing cpumask for possible cpus in the system
Date: Mon, 18 Jun 2012 13:30:04 +0200
Message-Id: <1340019011-18642-2-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gic_set_affinity doesn't support force option. Force option
should work with all possible cpus in the system not only with
online cpus.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/arm/common/gic.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index aa52699..4003cc2 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -235,9 +235,14 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 {
 	void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + (gic_irq(d) & ~3);
 	unsigned int shift = (gic_irq(d) % 4) * 8;
-	unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);
+	unsigned int cpu;
 	u32 val, mask, bit;
 
+	if (force)
+		cpu = cpumask_any_and(mask_val, cpu_possible_mask);
+	else
+		cpu = cpumask_any_and(mask_val, cpu_online_mask);
+
 	if (cpu >= 8 || cpu >= nr_cpu_ids)
 		return -EINVAL;
 
-- 
1.7.0.4

