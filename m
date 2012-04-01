Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab2DAQgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:36:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62598 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2DAQgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:36:12 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        Keping Chen <chenkeping@huawei.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] IRQ,x86: remove redundant memory copy operations in chip->irq_set_affinity()
Date: Mon,  2 Apr 2012 00:33:49 +0800
Message-Id: <1333298032-4047-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <4F772F2A.9020903@gmail.com>
References: <4F772F2A.9020903@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changeset 3b8249e7 has introduced standard return value IRQ_SET_MASK_OK(0) and
IRQ_SET_MASK_OK_NOCOPY(1) for interrupt controller chip's set_irq_affinity()
method. If chip->irq_set_affinity() doesn't change the affinity mask passed in,
it should return IRQ_SET_MASK_OK and the core logic will copy the affinity
mask to irq_data->affinity field.

Several xxx_irq_set_affinity() methods for x86 platforms still return
0(IRQ_SET_MASK_OK) after copying the affinity mask to irq_data->affinity field,
so remove the redundant memory copy operations.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/x86/kernel/apic/io_apic.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6d10a66..c68954e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2326,9 +2326,8 @@ int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	if (assign_irq_vector(data->irq, data->chip_data, mask))
 		return -1;
 
-	cpumask_copy(data->affinity, mask);
-
 	*dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);
+
 	return 0;
 }
 
@@ -2403,7 +2402,6 @@ ir_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
-	cpumask_copy(data->affinity, mask);
 	return 0;
 }
 
@@ -3832,6 +3830,8 @@ void __init setup_ioapic_dest(void)
 			ir_ioapic_set_affinity(idata, mask, false);
 		else
 			ioapic_set_affinity(idata, mask, false);
+
+		cpumask_copy(idata->affinity, mask);
 	}
 
 }
-- 
1.7.5.4

