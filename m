Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab2GEMqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:46:14 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:47881
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932476Ab2GEMhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:01 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPE-02-6NA-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
        <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 01/28] x86/irq: Add data structure to keep AMD specific irq remapping information
Date: Thu, 5 Jul 2012 14:36:21 +0200
Message-ID: <1341491808-23083-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a data structure to store information the IOMMU driver
can use to get from a 'struct irq_cfg' to the remapping
entry.

Cc: x86@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/hw_irq.h       |   14 +++++++++++++-
 arch/x86/kernel/apic/io_apic.c      |    2 +-
 drivers/iommu/intel_irq_remapping.c |    2 +-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index eb92a6e..b6171e6 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -101,6 +101,7 @@ static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
 	irq_attr->polarity	= polarity;
 }
 
+/* Intel specific interrupt remapping information */
 struct irq_2_iommu {
 	struct intel_iommu *iommu;
 	u16 irte_index;
@@ -108,6 +109,17 @@ struct irq_2_iommu {
 	u8  irte_mask;
 };
 
+/* AMD specific interrupt remapping information */
+struct irq_2_irte {
+	u16 devid; /* Device ID for IRTE table */
+	u16 index; /* Index into IRTE table*/
+};
+
+union irq_remap_info {
+	struct irq_2_iommu irq_2_iommu;
+	struct irq_2_irte  irq_2_irte;
+};
+
 /*
  * This is performance-critical, we want to do it O(1)
  *
@@ -120,7 +132,7 @@ struct irq_cfg {
 	u8			vector;
 	u8			move_in_progress : 1;
 #ifdef CONFIG_IRQ_REMAP
-	struct irq_2_iommu	irq_2_iommu;
+	union irq_remap_info    irq_remap_info;
 #endif
 };
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5f0ff59..08f666c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -72,7 +72,7 @@
 static void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 static inline bool irq_remapped(struct irq_cfg *cfg)
 {
-	return cfg->irq_2_iommu.iommu != NULL;
+	return cfg->irq_remap_info.irq_2_iommu.iommu != NULL;
 }
 #else
 static inline bool irq_remapped(struct irq_cfg *cfg)
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 6d34706..e4e4334 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -43,7 +43,7 @@ static DEFINE_RAW_SPINLOCK(irq_2_ir_lock);
 static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
 {
 	struct irq_cfg *cfg = irq_get_chip_data(irq);
-	return cfg ? &cfg->irq_2_iommu : NULL;
+	return cfg ? &cfg->irq_remap_info.irq_2_iommu : NULL;
 }
 
 int get_irte(int irq, struct irte *entry)
-- 
1.7.9.5


