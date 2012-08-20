Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab2HTOAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:00:20 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:34033
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755471Ab2HTN4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:56:17 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah11b5h)
X-WSS-ID: 0M9241J-02-F0N-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/19] x86, io_apic: Move irq_remapping_enabled checks out of check_timer()
Date: Mon, 20 Aug 2012 15:55:55 +0200
Message-ID: <1345470965-24410-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move these checks to IRQ remapping code by introducing the
panic_on_irq_remap() function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/irq_remapping.h |    5 +++++
 arch/x86/kernel/apic/io_apic.c       |    6 ++----
 drivers/iommu/irq_remapping.c        |    6 ++++++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index f1afa04..fb99a73 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -45,6 +45,7 @@ extern void compose_remapped_msi_msg(struct pci_dev *pdev,
 				     unsigned int irq, unsigned int dest,
 				     struct msi_msg *msg, u8 hpet_id);
 extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
+extern void panic_if_irq_remap(const char *msg);
 
 #else  /* CONFIG_IRQ_REMAP */
 
@@ -75,6 +76,10 @@ static inline int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
 {
 	return -ENODEV;
 }
+
+static inline void panic_if_irq_remap(const char *msg)
+{
+}
 #endif /* CONFIG_IRQ_REMAP */
 
 #endif /* __X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5d372be..8816280 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2776,8 +2776,7 @@ static inline void __init check_timer(void)
 	 * 8259A.
 	 */
 	if (pin1 == -1) {
-		if (irq_remapping_enabled)
-			panic("BIOS bug: timer not connected to IO-APIC");
+		panic_if_irq_remap("BIOS bug: timer not connected to IO-APIC");
 		pin1 = pin2;
 		apic1 = apic2;
 		no_pin1 = 1;
@@ -2809,8 +2808,7 @@ static inline void __init check_timer(void)
 				clear_IO_APIC_pin(0, pin1);
 			goto out;
 		}
-		if (irq_remapping_enabled)
-			panic("timer doesn't work through Interrupt-remapped IO-APIC");
+		panic_if_irq_remap("timer doesn't work through Interrupt-remapped IO-APIC");
 		local_irq_disable();
 		clear_IO_APIC_pin(apic1, pin1);
 		if (!no_pin1)
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 5b28e28..827f8a1 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -261,3 +261,9 @@ int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
 
 	return remap_ops->setup_hpet_msi(irq, id);
 }
+
+void panic_if_irq_remap(const char *msg)
+{
+	if (irq_remapping_enabled)
+		panic(msg);
+}
-- 
1.7.9.5


