Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2HBGvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:51:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60433 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2HBGvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:51:24 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Grant Likely <grant.likely@secretlab.ca>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86/ioapic: Fix fallout from IRQ domain conversion
Date: Thu,  2 Aug 2012 08:51:10 +0200
Message-Id: <1343890270-13007-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.11.3
X-Provags-ID: V02:K0:665mFqT/Yd9f/38XnUKkvwjtIQfn9Kg6TxBS8ibu5h7
 Wr6PRvfVaUCDwp6TnBbxDpYnPhJRGkUm+QslkRlF07AebwERZI
 qwmozMec1BnWwRP6mS/Ji/3tSSIIoOT0Fn7Htcd2l1PzF1R3Pr
 aWw4DN5Pr+74IulE8oIKViaaeoWuy5UbPu8s4sWBsUFq/hDjFe
 X9bLkYjjqDXJ+iwNJr9k+awAQhBDr3Y6SFtv33M7VBeV6PBjIs
 yWP4r98iN6WqfFWO1swM4pXOzYLswBvYqnne5Ia1743kb6FQKu
 j/o6CHy0mvb43vZInYac7Cit9unCeIu2hqK87tGBw07xQtHfMj
 e67rrB86iXXpJdbhoHLVLyEoo2Cy/+iNdcRjLBLpyL8NRGZQO1
 OBicPMIyUfb2OV9UWEPVp7FX8+Nc+3BH20hWucQnq2cNYoDWpt
 OG1O/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I/O APIC support was converted to the generic IRQ domain code,
various things were broken. First, the number of interrupts required for
an I/O APIC can be dynamically obtained from the mp_ioapic_gsi structure
instead of hardcoded to 32. Furthermore, the legacy IRQ domain requires
the irq_domain_ops.map() function to be implemented, which it currently
isn't. This function can be empty because all the programming is done in
io_apic_setup_irq_pin_once().

Another issue is that the number of interrupts reserved is currently
determined by the value of the NR_IRQS_LEGACY macro (16). However the
legacy IRQ domain mapping needs at least the number of interrupts
provided by the I/O APIC. If an I/O APIC has been registered that number
is dynamically computed and used instead of NR_IRQS_LEGACY.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/x86/kernel/apic/io_apic.c |  5 +++++
 arch/x86/kernel/devicetree.c   | 13 +++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5f0ff59..2674ab0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3465,6 +3465,7 @@ int get_nr_irqs_gsi(void)
 
 int __init arch_probe_nr_irqs(void)
 {
+	struct mp_ioapic_gsi *gsi_cfg;
 	int nr;
 
 	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
@@ -3480,6 +3481,10 @@ int __init arch_probe_nr_irqs(void)
 	if (nr < nr_irqs)
 		nr_irqs = nr;
 
+	gsi_cfg = mp_ioapic_gsi_routing(0);
+	if (gsi_cfg)
+		return gsi_cfg->gsi_end - gsi_cfg->gsi_base;
+
 	return NR_IRQS_LEGACY;
 }
 
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 3ae2ced..ecc405a 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -338,8 +338,15 @@ static int ioapic_xlate(struct irq_domain *domain,
 	return 0;
 }
 
+static int ioapic_map(struct irq_domain *domain, unsigned int virq,
+		      irq_hw_number_t hw)
+{
+	return 0;
+}
+
 const struct irq_domain_ops ioapic_irq_domain_ops = {
 	.xlate = ioapic_xlate,
+	.map = ioapic_map,
 };
 
 static void __init ioapic_add_ofnode(struct device_node *np)
@@ -358,11 +365,13 @@ static void __init ioapic_add_ofnode(struct device_node *np)
 		if (r.start == mpc_ioapic_addr(i)) {
 			struct irq_domain *id;
 			struct mp_ioapic_gsi *gsi_cfg;
+			unsigned int num;
 
 			gsi_cfg = mp_ioapic_gsi_routing(i);
+			num = gsi_cfg->gsi_end - gsi_cfg->gsi_base;
 
-			id = irq_domain_add_legacy(np, 32, gsi_cfg->gsi_base, 0,
-						   &ioapic_irq_domain_ops,
+			id = irq_domain_add_legacy(np, num, gsi_cfg->gsi_base,
+						   0, &ioapic_irq_domain_ops,
 						   (void*)i);
 			BUG_ON(!id);
 			return;
-- 
1.7.11.3

