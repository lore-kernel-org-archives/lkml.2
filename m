Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781Ab2KHUYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:24:46 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43412 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab2KHUYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:24:45 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>, Yang Bai <hamo.by@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: gic: use BUG_ON where possible
Date: Thu,  8 Nov 2012 15:23:05 -0500
Message-Id: <1352406191-14303-3-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
References: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use BUG_ON() instead of constructions such as:

	if (...)
		BUG()

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@
- if (e) BUG();
+ BUG_ON(e);
// </smpl>

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/arm/common/gic.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index aa52699..f0b8a10 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -336,10 +336,8 @@ static struct irq_chip gic_chip = {
 
 void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 {
-	if (gic_nr >= MAX_GIC_NR)
-		BUG();
-	if (irq_set_handler_data(irq, &gic_data[gic_nr]) != 0)
-		BUG();
+	BUG_ON(gic_nr >= MAX_GIC_NR);
+	BUG_ON(irq_set_handler_data(irq, &gic_data[gic_nr]) != 0);
 	irq_set_chained_handler(irq, gic_handle_cascade_irq);
 }
 
@@ -421,8 +419,7 @@ static void gic_dist_save(unsigned int gic_nr)
 	void __iomem *dist_base;
 	int i;
 
-	if (gic_nr >= MAX_GIC_NR)
-		BUG();
+	BUG_ON(gic_nr >= MAX_GIC_NR);
 
 	gic_irqs = gic_data[gic_nr].gic_irqs;
 	dist_base = gic_data_dist_base(&gic_data[gic_nr]);
@@ -456,8 +453,7 @@ static void gic_dist_restore(unsigned int gic_nr)
 	unsigned int i;
 	void __iomem *dist_base;
 
-	if (gic_nr >= MAX_GIC_NR)
-		BUG();
+	BUG_ON(gic_nr >= MAX_GIC_NR);
 
 	gic_irqs = gic_data[gic_nr].gic_irqs;
 	dist_base = gic_data_dist_base(&gic_data[gic_nr]);
@@ -493,8 +489,7 @@ static void gic_cpu_save(unsigned int gic_nr)
 	void __iomem *dist_base;
 	void __iomem *cpu_base;
 
-	if (gic_nr >= MAX_GIC_NR)
-		BUG();
+	BUG_ON(gic_nr >= MAX_GIC_NR);
 
 	dist_base = gic_data_dist_base(&gic_data[gic_nr]);
 	cpu_base = gic_data_cpu_base(&gic_data[gic_nr]);
@@ -519,8 +514,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
 	void __iomem *dist_base;
 	void __iomem *cpu_base;
 
-	if (gic_nr >= MAX_GIC_NR)
-		BUG();
+	BUG_ON(gic_nr >= MAX_GIC_NR);
 
 	dist_base = gic_data_dist_base(&gic_data[gic_nr]);
 	cpu_base = gic_data_cpu_base(&gic_data[gic_nr]);
-- 
1.7.10.4

