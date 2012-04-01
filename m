Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2DAQgW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:36:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62598 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab2DAQgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:36:17 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        Keping Chen <chenkeping@huawei.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] IRQ,x86: normalize return value of chip->irq_set_affinity() method
Date: Mon,  2 Apr 2012 00:33:50 +0800
Message-Id: <1333298032-4047-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333298032-4047-1-git-send-email-jiang.liu@huawei.com>
References: <1333298032-4047-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <4F772F2A.9020903@gmail.com>
References: <4F772F2A.9020903@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changeset 3b8249e7 has introduced standard return value IRQ_SET_MASK_OK(0) and
IRQ_SET_MASK_OK_NOCOPY(1) for interrupt controller chip's set_irq_affinity()
method.  So use IRQ_SET_MASK_OK instead of 0 for consistency.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/x86/kernel/apic/io_apic.c |   11 ++++++-----
 arch/x86/platform/uv/uv_irq.c  |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c68954e..18e73b3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2345,6 +2345,7 @@ ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
 		__target_IO_APIC_irq(irq, dest, data->chip_data);
+		ret = IRQ_SET_MASK_OK;
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	return ret;
@@ -2402,7 +2403,7 @@ ir_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
-	return 0;
+	return IRQ_SET_MASK_OK;
 }
 
 #else
@@ -3207,7 +3208,7 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 
 	__write_msi_msg(data->msi_desc, &msg);
 
-	return 0;
+	return IRQ_SET_MASK_OK;
 }
 #endif /* CONFIG_SMP */
 
@@ -3364,7 +3365,7 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 
 	dmar_msi_write(irq, &msg);
 
-	return 0;
+	return IRQ_SET_MASK_OK;
 }
 
 #endif /* CONFIG_SMP */
@@ -3417,7 +3418,7 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 
 	hpet_msi_write(data->handler_data, &msg);
 
-	return 0;
+	return IRQ_SET_MASK_OK;
 }
 
 #endif /* CONFIG_SMP */
@@ -3497,7 +3498,7 @@ ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 		return -1;
 
 	target_ht_irq(data->irq, dest, cfg->vector);
-	return 0;
+	return IRQ_SET_MASK_OK;
 }
 
 #endif
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index f25c276..67e3509 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -222,7 +222,7 @@ uv_set_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
-	return 0;
+	return IRQ_SET_MASK_OK;
 }
 
 /*
-- 
1.7.5.4

