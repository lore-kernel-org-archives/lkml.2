Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab2BXDt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:49:57 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37350 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab2BXDtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:49:49 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Henrik Kretzschmar <henne@nachtwindheim.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 04/13] x86, irq: pre-reserve irq range that are used by ioapic
Date: Thu, 23 Feb 2012 19:48:50 -0800
Message-Id: <1330055339-11662-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
References: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F4708C7.0036,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

realloc_irq_and_cfg_at already can handle pre-reserved case.

those for non-hot add ioapic, but make them to share same code path that
will be used by hot add ioapic.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/apic/io_apic.c |  133 ++++++++++++++++++++++++++--------------
 2 files changed, 88 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 690d1cc..f2a83ae 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -164,6 +164,7 @@ extern void setup_ioapic_ids_from_mpc_nocheck(void);
 struct mp_ioapic_gsi{
 	u32 gsi_base;
 	u32 gsi_end;
+	u32 irq_base;
 };
 extern struct mp_ioapic_gsi  mp_gsi_routing[];
 extern u32 gsi_top;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4d62f0f..0702998 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -184,51 +184,6 @@ static struct irq_pin_list *alloc_irq_pin_list(int node)
 	return kzalloc_node(sizeof(struct irq_pin_list), GFP_KERNEL, node);
 }
 
-
-/* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
-static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
-
-int __init arch_early_irq_init(void)
-{
-	struct irq_cfg *cfg;
-	int count, node, i;
-
-	if (!legacy_pic->nr_legacy_irqs)
-		io_apic_irqs = ~0UL;
-
-	for (i = 0; i < nr_ioapics; i++) {
-		ioapics[i].saved_registers =
-			kzalloc(sizeof(struct IO_APIC_route_entry) *
-				ioapics[i].nr_registers, GFP_KERNEL);
-		if (!ioapics[i].saved_registers)
-			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
-	}
-
-	cfg = irq_cfgx;
-	count = ARRAY_SIZE(irq_cfgx);
-	node = cpu_to_node(0);
-
-	/* Make sure the legacy interrupts are marked in the bitmap */
-	irq_reserve_irqs(0, legacy_pic->nr_legacy_irqs);
-
-	for (i = 0; i < count; i++) {
-		INIT_LIST_HEAD(&cfg[i].irq_2_pin);
-		irq_set_chip_data(i, &cfg[i]);
-		zalloc_cpumask_var_node(&cfg[i].domain, GFP_KERNEL, node);
-		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_KERNEL, node);
-		/*
-		 * For legacy IRQ's, start with assigning irq0 to irq15 to
-		 * IRQ0_VECTOR to IRQ15_VECTOR on cpu 0.
-		 */
-		if (i < legacy_pic->nr_legacy_irqs) {
-			cfg[i].vector = IRQ0_VECTOR + i;
-			cpumask_set_cpu(0, cfg[i].domain);
-		}
-	}
-
-	return 0;
-}
-
 static struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	return irq_get_chip_data(irq);
@@ -331,6 +286,91 @@ static struct irq_cfg *realloc_irq_and_cfg_at(unsigned int at, int node)
 	return alloc_irq_and_cfg_at(at, node);
 }
 
+static int reserve_ioapic_gsi_irq_base(int idx)
+{
+	int irq;
+	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(idx);
+	int cnt = gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
+
+	irq = __irq_reserve_irqs(-1, gsi_cfg->gsi_base, cnt);
+	if (irq >= 0) {
+		gsi_cfg->irq_base = irq;
+		printk(KERN_INFO
+		"IOAPIC[%d]: apic_id %d, GSI %d-%d ==> irq %d-%d reserved\n",
+			idx, mpc_ioapic_id(idx),
+			gsi_cfg->gsi_base, gsi_cfg->gsi_end,
+			irq, irq + cnt - 1);
+	} else
+		printk(KERN_INFO
+		"IOAPIC[%d]: apic_id %d, GSI %d-%d ==> irq reserve failed\n",
+			idx, mpc_ioapic_id(idx),
+			gsi_cfg->gsi_base, gsi_cfg->gsi_end);
+
+	return irq;
+}
+
+static void __init reserve_ioapic_gsi_irq_extra(void)
+{
+	int irq;
+
+	/* to prevent hot add ioapic taking those slots */
+	if (gsi_top) {
+		irq = irq_reserve_irqs(gsi_top, NR_IRQS_LEGACY);
+		if (irq >= 0)
+			printk(KERN_INFO
+			"IOAPIC[extra]: GSI %d-%d ==> irq %d-%d reserved\n",
+				gsi_top, gsi_top + NR_IRQS_LEGACY - 1,
+				irq, irq + NR_IRQS_LEGACY - 1);
+		else
+			printk(KERN_INFO
+			"IOAPIC[extra]: GSI %d-%d ==> irq reserve failed\n",
+				gsi_top, gsi_top + NR_IRQS_LEGACY - 1);
+	}
+}
+
+static void alloc_ioapic_saved_registers(int idx)
+{
+	if (ioapics[idx].saved_registers)
+		return;
+
+	ioapics[idx].saved_registers =
+			kzalloc(sizeof(struct IO_APIC_route_entry) *
+				ioapics[idx].nr_registers, GFP_KERNEL);
+
+	if (!ioapics[idx].saved_registers)
+		pr_err("IOAPIC %d: suspend/resume impossible!\n", idx);
+}
+
+int __init arch_early_irq_init(void)
+{
+	int node = cpu_to_node(0);
+	struct irq_cfg *cfg;
+	int i;
+
+	if (!legacy_pic->nr_legacy_irqs)
+		io_apic_irqs = ~0UL;
+
+	for (i = 0; i < nr_ioapics; i++)
+		alloc_ioapic_saved_registers(i);
+
+	for (i = 0; i < nr_ioapics; i++)
+		reserve_ioapic_gsi_irq_base(i);
+
+	reserve_ioapic_gsi_irq_extra();
+
+	/*
+	 * For legacy IRQ's, start with assigning irq0 to irq15 to
+	 * IRQ0_VECTOR to IRQ15_VECTOR on cpu 0.
+	 */
+	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++) {
+		cfg = realloc_irq_and_cfg_at(i, node);
+		cfg->vector = IRQ0_VECTOR + i;
+		cpumask_set_cpu(0, cfg->domain);
+	}
+
+	return 0;
+}
+
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -3672,7 +3712,8 @@ int __init arch_probe_nr_irqs(void)
 	if (nr < nr_irqs)
 		nr_irqs = nr;
 
-	return NR_IRQS_LEGACY;
+	/* x86 arch code will allocate irq_desc/cfg */
+	return 0;
 }
 
 int io_apic_set_pci_routing(struct device *dev, int irq,
-- 
1.7.7

