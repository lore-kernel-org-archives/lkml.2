Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab2GEMnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:43:37 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:32482
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932494Ab2GEMhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:03 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPD-02-6N4-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
        <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 02/28] x86/irq: Introduce irq_cfg->remapped
Date: Thu, 5 Jul 2012 14:36:22 +0200
Message-ID: <1341491808-23083-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag will show whether the interrupt is remapped in a
way that works for VT-d and AMD-Vi.

Cc: x86@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/hw_irq.h       |    1 +
 arch/x86/kernel/apic/io_apic.c      |    2 +-
 drivers/iommu/intel_irq_remapping.c |    4 ++++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index b6171e6..71bb327 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -132,6 +132,7 @@ struct irq_cfg {
 	u8			vector;
 	u8			move_in_progress : 1;
 #ifdef CONFIG_IRQ_REMAP
+	bool			remapped;
 	union irq_remap_info    irq_remap_info;
 #endif
 };
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 08f666c..d5bccc0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -72,7 +72,7 @@
 static void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 static inline bool irq_remapped(struct irq_cfg *cfg)
 {
-	return cfg->irq_remap_info.irq_2_iommu.iommu != NULL;
+	return cfg->remapped;
 }
 #else
 static inline bool irq_remapped(struct irq_cfg *cfg)
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index e4e4334..29411ed 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -68,6 +68,7 @@ static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
 	u16 index, start_index;
 	unsigned int mask = 0;
 	unsigned long flags;
@@ -115,6 +116,7 @@ static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	for (i = index; i < index + count; i++)
 		table->base[i].present = 1;
 
+	cfg->remapped = true;
 	irq_iommu->iommu = iommu;
 	irq_iommu->irte_index =  index;
 	irq_iommu->sub_handle = 0;
@@ -155,6 +157,7 @@ static int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 static int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
 	unsigned long flags;
 
 	if (!irq_iommu)
@@ -162,6 +165,7 @@ static int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subha
 
 	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
 
+	cfg->remapped = true;
 	irq_iommu->iommu = iommu;
 	irq_iommu->irte_index = index;
 	irq_iommu->sub_handle = subhandle;
-- 
1.7.9.5


