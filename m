Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab2JANY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:24:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45112 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab2JANY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:24:57 -0400
Date: Mon, 1 Oct 2012 15:24:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic changes for v3.7
Message-ID: <20121001132452.GA22739@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-apic-for-linus

   HEAD: 57c078ce13983d27c83f962b3e9722887209005c x86/api: Rename mp_register_lapic in a comment

Smaller fixes and cleanups.

 Thanks,

	Ingo

------------------>
Sebastian Andrzej Siewior (1):
      x86: dt: Use linear irq domain for ioapic(s)

Yasuaki Ishimatsu (1):
      x86/api: Rename mp_register_lapic in a comment

Yuanhan Liu (1):
      x86/irq/i8259: Fix incorrect comment


 arch/x86/kernel/acpi/boot.c  |  2 +-
 arch/x86/kernel/devicetree.c | 51 ++++++++++++++++++++++++++++++++++++--------
 arch/x86/kernel/i8259.c      |  2 +-
 3 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b2297e5..e651f7a 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -656,7 +656,7 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 	acpi_register_lapic(physid, ACPI_MADT_ENABLED);
 
 	/*
-	 * If mp_register_lapic successfully generates a new logical cpu
+	 * If acpi_register_lapic successfully generates a new logical cpu
 	 * number, then the following will get us exactly what was mapped
 	 */
 	cpumask_andnot(new_map, cpu_present_mask, tmp_map);
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 3ae2ced..b158152 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -342,6 +342,47 @@ const struct irq_domain_ops ioapic_irq_domain_ops = {
 	.xlate = ioapic_xlate,
 };
 
+static void dt_add_ioapic_domain(unsigned int ioapic_num,
+		struct device_node *np)
+{
+	struct irq_domain *id;
+	struct mp_ioapic_gsi *gsi_cfg;
+	int ret;
+	int num;
+
+	gsi_cfg = mp_ioapic_gsi_routing(ioapic_num);
+	num = gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
+
+	id = irq_domain_add_linear(np, num, &ioapic_irq_domain_ops,
+			(void *)ioapic_num);
+	BUG_ON(!id);
+	if (gsi_cfg->gsi_base == 0) {
+		/*
+		 * The first NR_IRQS_LEGACY irq descs are allocated in
+		 * early_irq_init() and need just a mapping. The
+		 * remaining irqs need both. All of them are preallocated
+		 * and assigned so we can keep the 1:1 mapping which the ioapic
+		 * is having.
+		 */
+		ret = irq_domain_associate_many(id, 0, 0, NR_IRQS_LEGACY);
+		if (ret)
+			pr_err("Error mapping legacy IRQs: %d\n", ret);
+
+		if (num > NR_IRQS_LEGACY) {
+			ret = irq_create_strict_mappings(id, NR_IRQS_LEGACY,
+					NR_IRQS_LEGACY, num - NR_IRQS_LEGACY);
+			if (ret)
+				pr_err("Error creating mapping for the "
+						"remaining IRQs: %d\n", ret);
+		}
+		irq_set_default_host(id);
+	} else {
+		ret = irq_create_strict_mappings(id, gsi_cfg->gsi_base, 0, num);
+		if (ret)
+			pr_err("Error creating IRQ mapping: %d\n", ret);
+	}
+}
+
 static void __init ioapic_add_ofnode(struct device_node *np)
 {
 	struct resource r;
@@ -356,15 +397,7 @@ static void __init ioapic_add_ofnode(struct device_node *np)
 
 	for (i = 0; i < nr_ioapics; i++) {
 		if (r.start == mpc_ioapic_addr(i)) {
-			struct irq_domain *id;
-			struct mp_ioapic_gsi *gsi_cfg;
-
-			gsi_cfg = mp_ioapic_gsi_routing(i);
-
-			id = irq_domain_add_legacy(np, 32, gsi_cfg->gsi_base, 0,
-						   &ioapic_irq_domain_ops,
-						   (void*)i);
-			BUG_ON(!id);
+			dt_add_ioapic_domain(i, np);
 			return;
 		}
 	}
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 36d1853..9a5c460 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -263,7 +263,7 @@ static void i8259A_shutdown(void)
 	 * out of.
 	 */
 	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
-	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-1 */
+	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
 }
 
 static struct syscore_ops i8259_syscore_ops = {
