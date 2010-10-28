Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab0J1FEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 01:04:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44339 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab0J1FEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 01:04:05 -0400
Date: Thu, 28 Oct 2010 14:03:54 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] arm: GIC: Use the irq_to_desc for SPARSE IRQ
To: linux@arm.linux.org.uk, rmk@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, rabin.vincent@stericsson.com,
        linus.walleij@stericsson.com
Cc: linux-kernel@vger.kernel.org
Message-id: <20101028050354.GA23284@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 28 Oct 2010 05:04:02.0557 (UTC)
 FILETIME=[89C44AD0:01CB765D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

When enable SPARSE_IRQ, there's compiler error at gic.c
Fix it by using the irq_to_desc to get the proper irq desc.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 7dfa9a8..1ca3c0d 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -158,15 +158,19 @@ static int gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
 {
 	void __iomem *reg = gic_dist_base(irq) + GIC_DIST_TARGET + (gic_irq(irq) & ~3);
 	unsigned int shift = (irq % 4) * 8;
-	unsigned int cpu = cpumask_first(mask_val);
+	unsigned int node = cpumask_first(mask_val);
+	struct irq_desc *desc;
 	u32 val;
 
-	spin_lock(&irq_controller_lock);
-	irq_desc[irq].node = cpu;
-	val = readl(reg) & ~(0xff << shift);
-	val |= 1 << (cpu + shift);
-	writel(val, reg);
-	spin_unlock(&irq_controller_lock);
+	desc = irq_to_desc(irq);
+	if (desc) {
+		spin_lock(&irq_controller_lock);
+		desc->node = node;
+		val = readl(reg) & ~(0xff << shift);
+		val |= 1 << (node + shift);
+		writel(val, reg);
+		spin_unlock(&irq_controller_lock);
+	}
 
 	return 0;
 }
