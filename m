Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab1BJXiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:11 -0500
Received: from www.tglx.de ([62.245.132.106]:44411 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286Ab1BJXiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:07 -0500
Message-Id: <20110210223259.706389516@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 56/75] genirq: Reuse existing can set affinty check
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline;
	filename=genirq-remove-duplicate-balancing-checks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a !desc check while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    4 ++--
 kernel/irq/proc.c   |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -73,8 +73,8 @@ int irq_can_set_affinity(unsigned int ir
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	if (!irqd_can_balance(&desc->irq_data) || !desc->irq_data.chip ||
-	    !desc->irq_data.chip->irq_set_affinity)
+	if (!desc || !irqd_can_balance(&desc->irq_data) ||
+	    !desc->irq_data.chip || !desc->irq_data.chip->irq_set_affinity)
 		return 0;
 
 	return 1;
Index: linux-2.6-tip/kernel/irq/proc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/proc.c
+++ linux-2.6-tip/kernel/irq/proc.c
@@ -66,8 +66,7 @@ static ssize_t irq_affinity_proc_write(s
 	cpumask_var_t new_value;
 	int err;
 
-	if (!irq_to_desc(irq)->irq_data.chip->irq_set_affinity || no_irq_affinity ||
-	    irq_balancing_disabled(irq))
+	if (!irq_can_set_affinity(irq) || no_irq_affinity)
 		return -EIO;
 
 	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))


