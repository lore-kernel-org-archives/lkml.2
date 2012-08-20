Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab2HTN53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:57:29 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:25167
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756030Ab2HTN40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:56:26 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah11b5h)
X-WSS-ID: 0M9241J-02-F0R-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/19] x86, irq: Move irq_remapped() check into free_remapped_irq
Date: Mon, 20 Aug 2012 15:56:01 +0200
Message-ID: <1345470965-24410-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
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
index e95325f..6022e4c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2981,8 +2981,8 @@ void destroy_irq(unsigned int irq)
 
 	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
 
-	if (irq_remapped(cfg))
-		free_remapped_irq(irq);
+	free_remapped_irq(irq);
+
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq, cfg);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 3957fb2..f2affc7 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -229,10 +229,13 @@ int set_remapped_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 
 void free_remapped_irq(int irq)
 {
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
+
 	if (!remap_ops || !remap_ops->free_irq)
 		return;
 
-	remap_ops->free_irq(irq);
+	if (cfg && irq_remapped(cfg))
+		remap_ops->free_irq(irq);
 }
 
 void compose_remapped_msi_msg(struct pci_dev *pdev,
-- 
1.7.9.5


