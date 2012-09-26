Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2IZKqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:46:30 -0400
Received: from [216.32.181.182] ([216.32.181.182]:32235 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752874Ab2IZKq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:46:27 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MAYDV3-01-D4Y-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/19] x86, hpet: Introduce x86_msi_ops.setup_hpet_msi
Date: Wed, 26 Sep 2012 12:44:37 +0200
Message-ID: <1348656291-10375-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
References: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function pointer can be overwritten by the IRQ
remapping code. The irq_remapping_enabled check can be
removed from default_setup_hpet_msi.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/hpet.h     |    5 +++--
 arch/x86/include/asm/x86_init.h |    1 +
 arch/x86/kernel/apic/io_apic.c  |    7 +------
 arch/x86/kernel/hpet.c          |    2 +-
 arch/x86/kernel/x86_init.c      |   10 ++++++----
 drivers/iommu/irq_remapping.c   |    3 ++-
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index 2c392d6..ad2dae0 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -82,9 +82,9 @@ extern void hpet_msi_write(struct hpet_dev *hdev, struct msi_msg *msg);
 extern void hpet_msi_read(struct hpet_dev *hdev, struct msi_msg *msg);
 
 #ifdef CONFIG_PCI_MSI
-extern int arch_setup_hpet_msi(unsigned int irq, unsigned int id);
+extern int default_setup_hpet_msi(unsigned int irq, unsigned int id);
 #else
-static inline int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
+static inline int default_setup_hpet_msi(unsigned int irq, unsigned int id)
 {
 	return -EINVAL;
 }
@@ -113,6 +113,7 @@ extern void hpet_unregister_irq_handler(rtc_irq_handler handler);
 static inline int hpet_enable(void) { return 0; }
 static inline int is_hpet_enabled(void) { return 0; }
 #define hpet_readl(a) 0
+#define default_setup_hpet_msi	NULL
 
 #endif
 #endif /* _ASM_X86_HPET_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index be8e9a6..1f49c8a 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -186,6 +186,7 @@ struct x86_msi_ops {
 	void (*teardown_msi_irq)(unsigned int irq);
 	void (*teardown_msi_irqs)(struct pci_dev *dev);
 	void (*restore_msi_irqs)(struct pci_dev *dev, int irq);
+	int  (*setup_hpet_msi)(unsigned int irq, unsigned int id);
 };
 
 struct x86_io_apic_ops {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8c6260f..ab07371 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3307,17 +3307,12 @@ static struct irq_chip hpet_msi_type = {
 	.irq_retrigger = ioapic_retrigger_irq,
 };
 
-int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
+int default_setup_hpet_msi(unsigned int irq, unsigned int id)
 {
 	struct irq_chip *chip = &hpet_msi_type;
 	struct msi_msg msg;
 	int ret;
 
-	if (irq_remapping_enabled) {
-		if (!setup_hpet_msi_remapped(irq, id))
-			return -1;
-	}
-
 	ret = msi_compose_msg(NULL, irq, &msg, id);
 	if (ret < 0)
 		return ret;
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 1460a5d..22d4fe5 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -478,7 +478,7 @@ static int hpet_msi_next_event(unsigned long delta,
 
 static int hpet_setup_msi_irq(unsigned int irq)
 {
-	if (arch_setup_hpet_msi(irq, hpet_blockid)) {
+	if (x86_msi.setup_hpet_msi(irq, hpet_blockid)) {
 		destroy_irq(irq);
 		return -EINVAL;
 	}
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index dc19c50..339e108 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -19,6 +19,7 @@
 #include <asm/time.h>
 #include <asm/irq.h>
 #include <asm/io_apic.h>
+#include <asm/hpet.h>
 #include <asm/pat.h>
 #include <asm/tsc.h>
 #include <asm/iommu.h>
@@ -113,10 +114,11 @@ struct x86_platform_ops x86_platform = {
 
 EXPORT_SYMBOL_GPL(x86_platform);
 struct x86_msi_ops x86_msi = {
-	.setup_msi_irqs = native_setup_msi_irqs,
-	.teardown_msi_irq = native_teardown_msi_irq,
-	.teardown_msi_irqs = default_teardown_msi_irqs,
-	.restore_msi_irqs = default_restore_msi_irqs,
+	.setup_msi_irqs		= native_setup_msi_irqs,
+	.teardown_msi_irq	= native_teardown_msi_irq,
+	.teardown_msi_irqs	= default_teardown_msi_irqs,
+	.restore_msi_irqs	= default_restore_msi_irqs,
+	.setup_hpet_msi		= default_setup_hpet_msi,
 };
 
 struct x86_io_apic_ops x86_io_apic_ops = {
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index f72a5e8..f439151 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -36,7 +36,8 @@ static void irq_remapping_disable_io_apic(void)
 
 static void __init irq_remapping_modify_x86_ops(void)
 {
-	x86_io_apic_ops.disable	=	irq_remapping_disable_io_apic;
+	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
+	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
 }
 
 static __init int setup_nointremap(char *str)
-- 
1.7.9.5


