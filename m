Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab1KLBuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 20:50:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52361 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab1KLBu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 20:50:27 -0500
From: ddaney.cavm@gmail.com
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        tglx@linutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH 2/2] MIPS: Octeon: Add irq_create_of_mapping() and GPIO interrupts.
Date: Fri, 11 Nov 2011 17:50:16 -0800
Message-Id: <1321062616-28317-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1321062616-28317-1-git-send-email-ddaney.cavm@gmail.com>
References: <1321062616-28317-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

This is needed for Octeon to use the Device Tree.

The GPIO interrupts are configured based on Device Tree properties

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/Kconfig                    |    1 +
 arch/mips/cavium-octeon/octeon-irq.c |  279 +++++++++++++++++++++++++++++++++-
 2 files changed, 279 insertions(+), 1 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index d46f1da..97c2cf2 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1404,6 +1404,7 @@ config CPU_CAVIUM_OCTEON
 	select WEAK_ORDERING
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_HUGEPAGES
+	select IRQ_DOMAIN
 	help
 	  The Cavium Octeon processor is a highly integrated chip containing
 	  many ethernet hardware widgets for networking tasks. The processor
diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index ffd4ae6..5e08590 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -7,12 +7,16 @@
  */
 
 #include <linux/interrupt.h>
+#include <linux/irqdomain.h>
 #include <linux/bitops.h>
+#include <linux/module.h>
 #include <linux/percpu.h>
+#include <linux/of_irq.h>
 #include <linux/irq.h>
 #include <linux/smp.h>
 
 #include <asm/octeon/octeon.h>
+#include <asm/octeon/cvmx-gpio-defs.h>
 
 static DEFINE_RAW_SPINLOCK(octeon_irq_ciu0_lock);
 static DEFINE_RAW_SPINLOCK(octeon_irq_ciu1_lock);
@@ -58,6 +62,178 @@ static void __init octeon_irq_set_ciu_mapping(int irq, int line, int bit,
 	octeon_irq_ciu_to_irq[line][bit] = irq;
 }
 
+static int octeon_irq_gpio_dt_translate(struct irq_domain *d,
+				       struct device_node *node,
+				       const u32 *intspec,
+				       unsigned int intsize,
+				       unsigned int *out_hwirq,
+				       unsigned int *out_type)
+{
+	unsigned int irq;
+	unsigned int type;
+	unsigned int ciu = 0, bit = 0;
+	unsigned int pin;
+	unsigned int trigger;
+	bool set_edge_handler = false;
+
+	if (intsize < 2)
+		return -EINVAL;
+
+	pin = be32_to_cpup(intspec);
+	if (pin >= 16)
+		return -EINVAL;
+
+	trigger = be32_to_cpup(intspec + 1);
+
+	switch (trigger) {
+	case 1:
+		type = IRQ_TYPE_EDGE_RISING;
+		set_edge_handler = true;
+		break;
+	case 2:
+		type = IRQ_TYPE_EDGE_FALLING;
+		set_edge_handler = true;
+		break;
+	case 4:
+		type = IRQ_TYPE_LEVEL_HIGH;
+		break;
+	case 8:
+		type = IRQ_TYPE_LEVEL_LOW;
+		break;
+	default:
+		WARN(1, "hello");
+		pr_err("Error: (%s) Invalid irq trigger specification: %x\n",
+		       node->name,
+		       trigger);
+		type = IRQ_TYPE_LEVEL_LOW;
+		break;
+	}
+	*out_type = type;
+	*out_hwirq = d->hwirq_base + pin;
+
+	ciu = *out_hwirq >> 6;
+	bit = *out_hwirq & 0x3f;
+
+	irq = octeon_irq_ciu_to_irq[ciu][bit];
+
+	if (set_edge_handler)
+		__irq_set_handler(irq, handle_edge_irq, 0, NULL);
+
+
+	return 0;
+}
+
+/*
+ * octeon_irq_ciu_dt_translate - Hook to resolve OF irq specifier into a Linux irq#
+ *
+ * Octeon irq maps are a pair of indexes.  The first selects either
+ * ciu0 or ciu1, the second is the bit within the ciu register.
+ */
+static int octeon_irq_ciu_dt_translate(struct irq_domain *d,
+				       struct device_node *node,
+				       const u32 *intspec,
+				       unsigned int intsize,
+				       unsigned int *out_hwirq,
+				       unsigned int *out_type)
+{
+	unsigned int ciu, bit;
+
+	ciu = be32_to_cpup(intspec);
+	bit = be32_to_cpup(intspec + 1);
+
+	if (ciu > 1 || bit > 63)
+		return -EINVAL;
+
+	if (octeon_irq_ciu_to_irq[ciu][bit] == 0)
+		return -EINVAL;
+
+	*out_hwirq = (ciu << 6) | bit;
+	*out_type = 0;
+
+	return 0;
+}
+
+static unsigned int octeon_irq_ciu_to_irqf(struct irq_domain *d,
+					   unsigned int hwirq)
+{
+	unsigned int ciu, bit;
+
+	ciu = (hwirq >> 6) & 1;
+	bit = hwirq & 0x3f;
+	return octeon_irq_ciu_to_irq[ciu][bit];
+}
+
+static bool octeon_irq_ciu_in_domain(unsigned int irq)
+{
+	return (irq != 0) &&
+		!(irq >= OCTEON_IRQ_GPIO0 && irq < OCTEON_IRQ_GPIO0 + 16);
+}
+
+static int octeon_irq_ciu_each_irq(struct irq_domain *d,
+				   int (*cb)(struct irq_domain *d,
+					     unsigned int irq,
+					     unsigned int hwirq))
+{
+	int ciu, bit;
+	int ret = 0;
+	unsigned int irq, hwirq;
+
+	for (ciu = 0; ciu <=1; ciu++)
+		for (bit = 0; bit <= 63; bit++) {
+			irq = octeon_irq_ciu_to_irq[ciu][bit];
+			hwirq = (ciu << 6) | bit;
+			if (octeon_irq_ciu_in_domain(irq)) {
+				ret = cb(d, irq, hwirq);
+				if (ret)
+					return ret;
+			}
+		}
+	return 0;
+}
+
+static int octeon_irq_ciu_each_hwirq(struct irq_domain *d,
+				     int (*cb)(struct irq_domain *d,
+					       unsigned int hwirq))
+{
+	int ciu, bit;
+	int ret = 0;
+	unsigned int irq, hwirq;
+
+	for (ciu = 0; ciu <=1; ciu++)
+		for (bit = 0; bit <= 63; bit++) {
+			irq = octeon_irq_ciu_to_irq[ciu][bit];
+			hwirq = (ciu << 6) | bit;
+			if (octeon_irq_ciu_in_domain(irq)) {
+				ret = cb(d, hwirq);
+				if (ret)
+					return ret;
+			}
+		}
+	return 0;
+}
+
+static const struct irq_domain_ops octeon_irq_ciu_domain_ops = {
+	.to_irq = octeon_irq_ciu_to_irqf,
+	.each_irq = octeon_irq_ciu_each_irq,
+	.each_hwirq = octeon_irq_ciu_each_hwirq,
+	.dt_translate = octeon_irq_ciu_dt_translate,
+};
+
+static const struct irq_domain_ops octeon_irq_gpio_domain_ops = {
+	.to_irq = octeon_irq_ciu_to_irqf,
+	.dt_translate = octeon_irq_gpio_dt_translate,
+};
+
+static struct irq_domain octeon_irq_ciu_domain  = {
+	.ops = &octeon_irq_ciu_domain_ops
+};
+
+static struct irq_domain octeon_irq_gpio_domain  = {
+	.irq_base = OCTEON_IRQ_GPIO0,
+	.nr_irq = 16,
+	.ops = &octeon_irq_gpio_domain_ops
+};
+
 static int octeon_coreid_for_cpu(int cpu)
 {
 #ifdef CONFIG_SMP
@@ -505,6 +681,72 @@ static void octeon_irq_ciu_enable_all_v2(struct irq_data *data)
 	}
 }
 
+static void octeon_irq_gpio_setup(struct irq_data *data)
+{
+	union cvmx_gpio_bit_cfgx cfg;
+	int bit = data->irq - OCTEON_IRQ_GPIO0;
+	u32 t = irqd_get_trigger_type(data);
+
+	cfg.u64 = 0;
+	cfg.s.int_en = 1;
+	cfg.s.int_type = (t & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) != 0;
+	cfg.s.rx_xor = (t & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_EDGE_FALLING)) != 0;
+
+	/* 1 uS glitch filter*/
+	cfg.s.fil_cnt = 7;
+	cfg.s.fil_sel = 3;
+
+	cvmx_write_csr(CVMX_GPIO_BIT_CFGX(bit), cfg.u64);
+}
+
+static void octeon_irq_ciu_enable_gpio_v2(struct irq_data *data)
+{
+	octeon_irq_gpio_setup(data);
+	octeon_irq_ciu_enable_v2(data);
+}
+
+static void octeon_irq_ciu_enable_gpio(struct irq_data *data)
+{
+	octeon_irq_gpio_setup(data);
+	octeon_irq_ciu_enable(data);
+}
+
+static int octeon_irq_ciu_gpio_set_type(struct irq_data *data, unsigned int t)
+{
+	u32 current_type = irqd_get_trigger_type(data);
+
+	/* If the type has been set, don't change it */
+	if (current_type && current_type != t)
+		return -EINVAL;
+
+	irqd_set_trigger_type(data, t);
+	return IRQ_SET_MASK_OK;
+}
+
+static void octeon_irq_ciu_disable_gpio_v2(struct irq_data *data)
+{
+	int bit = data->irq - OCTEON_IRQ_GPIO0;
+	cvmx_write_csr(CVMX_GPIO_BIT_CFGX(bit), 0);
+
+	octeon_irq_ciu_disable_all_v2(data);
+}
+
+static void octeon_irq_ciu_disable_gpio(struct irq_data *data)
+{
+	int bit = data->irq - OCTEON_IRQ_GPIO0;
+	cvmx_write_csr(CVMX_GPIO_BIT_CFGX(bit), 0);
+
+	octeon_irq_ciu_disable_all(data);
+}
+
+static void octeon_irq_ciu_gpio_ack(struct irq_data *data)
+{
+	int bit = data->irq - OCTEON_IRQ_GPIO0;
+	u64 mask = 1ull << bit;
+
+	cvmx_write_csr(CVMX_GPIO_INT_CLR, mask);
+}
+
 #ifdef CONFIG_SMP
 
 static void octeon_irq_cpu_offline_ciu(struct irq_data *data)
@@ -717,6 +959,31 @@ static struct irq_chip octeon_irq_chip_ciu_mbox = {
 	.flags = IRQCHIP_ONOFFLINE_ENABLED,
 };
 
+static struct irq_chip octeon_irq_chip_ciu_gpio_v2 = {
+	.name = "CIU-GPIO",
+	.irq_enable = octeon_irq_ciu_enable_gpio_v2,
+	.irq_disable = octeon_irq_ciu_disable_gpio_v2,
+	.irq_ack = octeon_irq_ciu_gpio_ack,
+	.irq_mask = octeon_irq_ciu_disable_local_v2,
+	.irq_unmask = octeon_irq_ciu_enable_v2,
+	.irq_set_type = octeon_irq_ciu_gpio_set_type,
+#ifdef CONFIG_SMP
+	.irq_set_affinity = octeon_irq_ciu_set_affinity_v2,
+#endif
+};
+
+static struct irq_chip octeon_irq_chip_ciu_gpio = {
+	.name = "CIU-GPIO",
+	.irq_enable = octeon_irq_ciu_enable_gpio,
+	.irq_disable = octeon_irq_ciu_disable_gpio,
+	.irq_mask = octeon_irq_dummy_mask,
+	.irq_ack = octeon_irq_ciu_gpio_ack,
+	.irq_set_type = octeon_irq_ciu_gpio_set_type,
+#ifdef CONFIG_SMP
+	.irq_set_affinity = octeon_irq_ciu_set_affinity,
+#endif
+};
+
 /*
  * Watchdog interrupts are special.  They are associated with a single
  * core, so we hardwire the affinity to that core.
@@ -890,6 +1157,7 @@ static void __init octeon_irq_init_ciu(void)
 	struct irq_chip *chip_edge;
 	struct irq_chip *chip_mbox;
 	struct irq_chip *chip_wd;
+	struct irq_chip *chip_gpio;
 
 	octeon_irq_init_ciu_percpu();
 	octeon_irq_setup_secondary = octeon_irq_setup_secondary_ciu;
@@ -904,6 +1172,7 @@ static void __init octeon_irq_init_ciu(void)
 		chip_edge = &octeon_irq_chip_ciu_edge_v2;
 		chip_mbox = &octeon_irq_chip_ciu_mbox_v2;
 		chip_wd = &octeon_irq_chip_ciu_wd_v2;
+		chip_gpio = &octeon_irq_chip_ciu_gpio_v2;
 	} else {
 		octeon_irq_ip2 = octeon_irq_ip2_v1;
 		octeon_irq_ip3 = octeon_irq_ip3_v1;
@@ -911,6 +1180,7 @@ static void __init octeon_irq_init_ciu(void)
 		chip_edge = &octeon_irq_chip_ciu_edge;
 		chip_mbox = &octeon_irq_chip_ciu_mbox;
 		chip_wd = &octeon_irq_chip_ciu_wd;
+		chip_gpio = &octeon_irq_chip_ciu_gpio;
 	}
 	octeon_irq_ip4 = octeon_irq_ip4_mask;
 
@@ -921,7 +1191,7 @@ static void __init octeon_irq_init_ciu(void)
 	for (i = 0; i < 16; i++)
 		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_WORKQ0, 0, i + 0, chip, handle_level_irq);
 	for (i = 0; i < 16; i++)
-		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_GPIO0, 0, i + 16, chip, handle_level_irq);
+		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_GPIO0, 0, i + 16, chip_gpio, handle_level_irq);
 
 	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX0, 0, 32, chip_mbox, handle_percpu_irq);
 	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX1, 0, 33, chip_mbox, handle_percpu_irq);
@@ -995,6 +1265,13 @@ static void __init octeon_irq_init_ciu(void)
 	octeon_irq_set_ciu_mapping(OCTEON_IRQ_DFM, 1, 56, chip, handle_level_irq);
 	octeon_irq_set_ciu_mapping(OCTEON_IRQ_RST, 1, 63, chip, handle_level_irq);
 
+	octeon_irq_ciu_domain.of_node = of_find_compatible_node(NULL, NULL, "cavium,octeon-3860-ciu");
+	irq_domain_add(&octeon_irq_ciu_domain);
+
+	octeon_irq_gpio_domain.of_node = of_find_compatible_node(NULL, NULL, "cavium,octeon-3860-gpio");
+	octeon_irq_gpio_domain.hwirq_base = ((0 << 6) | 16);
+	irq_domain_add(&octeon_irq_gpio_domain);
+
 	/* Enable the CIU lines */
 	set_c0_status(STATUSF_IP3 | STATUSF_IP2);
 	clear_c0_status(STATUSF_IP4);
-- 
1.7.2.3

