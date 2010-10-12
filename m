Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab0JLQfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:35:11 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30077 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab0JLQfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:35:09 -0400
X-IronPort-AV: E=Sophos;i="4.57,320,1283745600"; 
   d="scan'208";a="117744602"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad.wilk@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH v4 4/7] acpi: use indirect call to register gsi in different modes
Date: Tue, 12 Oct 2010 17:34:46 +0100
Message-Id: <1286901289-8156-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop>
X-OriginalArrivalTime: 12 Oct 2010 16:35:08.0936 (UTC) FILETIME=[6F0B9880:01CB6A2B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>

Rather than using a tree of conditionals, use function pointer
for acpi_register_gsi.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/acpi/boot.c |   59 ++++++++++++++++++++++++++++++------------
 1 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index c05872a..031f0c2 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -513,35 +513,61 @@ int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
 	return 0;
 }
 
-/*
- * success: return IRQ number (>=0)
- * failure: return < 0
- */
-int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
+static int acpi_register_gsi_pic(struct device *dev, u32 gsi,
+				 int trigger, int polarity)
 {
-	unsigned int irq;
-	unsigned int plat_gsi = gsi;
-
 #ifdef CONFIG_PCI
 	/*
 	 * Make sure all (legacy) PCI IRQs are set as level-triggered.
 	 */
-	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
-		if (trigger == ACPI_LEVEL_SENSITIVE)
-			eisa_set_level_irq(gsi);
-	}
+	if (trigger == ACPI_LEVEL_SENSITIVE)
+		eisa_set_level_irq(gsi);
 #endif
 
+	return gsi;
+}
+
+static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
+				    int trigger, int polarity)
+{
 #ifdef CONFIG_X86_IO_APIC
-	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC) {
-		plat_gsi = mp_register_gsi(dev, gsi, trigger, polarity);
-	}
+	gsi = mp_register_gsi(dev, gsi, trigger, polarity);
 #endif
+
+	return gsi;
+}
+
+static int (*__acpi_register_gsi)(struct device *dev, u32 gsi, int trigger, int polarity) = acpi_register_gsi_pic;
+
+/*
+ * success: return IRQ number (>=0)
+ * failure: return < 0
+ */
+int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
+{
+	unsigned int irq;
+	unsigned int plat_gsi = gsi;
+
+	plat_gsi = (*__acpi_register_gsi)(dev, gsi, trigger, polarity);
 	irq = gsi_to_irq(plat_gsi);
 
 	return irq;
 }
 
+void __init acpi_set_irq_model_pic(void)
+{
+	acpi_irq_model = ACPI_IRQ_MODEL_PIC;
+	__acpi_register_gsi = acpi_register_gsi_pic;
+	acpi_ioapic = 0;
+}
+
+void __init acpi_set_irq_model_ioapic(void)
+{
+	acpi_irq_model = ACPI_IRQ_MODEL_IOAPIC;
+	__acpi_register_gsi = acpi_register_gsi_ioapic;
+	acpi_ioapic = 1;
+}
+
 /*
  *  ACPI based hotplug support for CPU
  */
@@ -1259,8 +1285,7 @@ static void __init acpi_process_madt(void)
 			 */
 			error = acpi_parse_madt_ioapic_entries();
 			if (!error) {
-				acpi_irq_model = ACPI_IRQ_MODEL_IOAPIC;
-				acpi_ioapic = 1;
+				acpi_set_irq_model_ioapic();
 
 				smp_found_config = 1;
 			}
-- 
1.5.6.5

