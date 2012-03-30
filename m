Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609Ab2C3PUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:20:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43953 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab2C3PUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:20:30 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@huawei.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>, Cliff Wickman <cpw@sgi.com>,
        x86@kernel.org, Jiang Liu <liuj97@gmail.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] IRQ,x86: normalize return value of chip->irq_set_affinity() method
Date: Fri, 30 Mar 2012 23:11:35 +0800
Message-Id: <1333120296-13563-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333120296-13563-1-git-send-email-jiang.liu@huawei.com>
References: <1333120296-13563-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86 platforms, interrupt controller chip's irq_set_affinity() method
always copies affinity mask to irq_data->affinity field but still returns
0(IRQ_SET_MASK_OK). That return value causes the interrupt core logic
unnecessarily copies the mask to irq_data->affinity field again.
So return IRQ_SET_MASK_OK_NOCOPY instead of IRQ_SET_MASK_OK to get rid of
the duplicated copy operation.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/x86/kernel/apic/io_apic.c |   11 ++++++-----
 arch/x86/platform/uv/uv_irq.c  |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6d10a66..092a715 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2346,6 +2346,7 @@ ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
 		__target_IO_APIC_irq(irq, dest, data->chip_data);
+		ret = IRQ_SET_MASK_OK_NOCOPY;
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	return ret;
@@ -2404,7 +2405,7 @@ ir_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		send_cleanup_vector(cfg);
 
 	cpumask_copy(data->affinity, mask);
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 #else
@@ -3209,7 +3210,7 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 
 	__write_msi_msg(data->msi_desc, &msg);
 
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 #endif /* CONFIG_SMP */
 
@@ -3366,7 +3367,7 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 
 	dmar_msi_write(irq, &msg);
 
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 #endif /* CONFIG_SMP */
@@ -3419,7 +3420,7 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 
 	hpet_msi_write(data->handler_data, &msg);
 
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 #endif /* CONFIG_SMP */
@@ -3499,7 +3500,7 @@ ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 		return -1;
 
 	target_ht_irq(data->irq, dest, cfg->vector);
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 #endif
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index f25c276..a22c416 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -222,7 +222,7 @@ uv_set_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 /*
-- 
1.7.5.4

