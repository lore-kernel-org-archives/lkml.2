Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2IZKrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:47:17 -0400
Received: from [216.32.181.186] ([216.32.181.186]:4412 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754444Ab2IZKqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:46:31 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MAYDV6-01-D5B-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/19] x86, irq: Move irq_remapped() check into free_remapped_irq
Date: Wed, 26 Sep 2012 12:44:47 +0200
Message-ID: <1348656291-10375-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
References: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is called unconditionally now in IO-APIC code
removing another irq_remapped() check from x86 core code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 drivers/iommu/irq_remapping.c  |    5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index dd555e7..87a0fd1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2991,8 +2991,8 @@ void destroy_irq(unsigned int irq)
 
 	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
 
-	if (irq_remapped(cfg))
-		free_remapped_irq(irq);
+	free_remapped_irq(irq);
+
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq, cfg);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index f0ac30a..165ac14 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -222,10 +222,13 @@ int set_remapped_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 
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


