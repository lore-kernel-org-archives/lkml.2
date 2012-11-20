Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab2KTNO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:14:56 -0500
Received: from 8bytes.org ([85.214.48.195]:58374 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab2KTNNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:13:15 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 15/19] x86, irq: Move irq_remapped() check into free_remapped_irq
Date: Tue, 20 Nov 2012 14:12:52 +0100
Message-Id: <1353417176-18945-16-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353417176-18945-1-git-send-email-joro@8bytes.org>
References: <1353417176-18945-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Nov 20 14:13:14 2012
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50ab81ea22971627016188
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is called unconditionally now in IO-APIC code
removing another irq_remapped() check from x86 core code.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 drivers/iommu/irq_remapping.c  |    5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f8c290b..73f1bf2 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2994,8 +2994,8 @@ void destroy_irq(unsigned int irq)
 
 	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
 
-	if (irq_remapped(cfg))
-		free_remapped_irq(irq);
+	free_remapped_irq(irq);
+
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq, cfg);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 97b5023..5053482 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -227,10 +227,13 @@ int set_remapped_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 
 void free_remapped_irq(int irq)
 {
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
+
 	if (!remap_ops || !remap_ops->free_irq)
 		return;
 
-	remap_ops->free_irq(irq);
+	if (irq_remapped(cfg))
+		remap_ops->free_irq(irq);
 }
 
 void compose_remapped_msi_msg(struct pci_dev *pdev,
-- 
1.7.9.5


