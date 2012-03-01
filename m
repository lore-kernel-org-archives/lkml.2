Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966213Ab2CAA6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:58:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51218 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab2CAA5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:57:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ddaney.cavm@gmail.com designates 10.236.92.228 as permitted sender) smtp.mail=ddaney.cavm@gmail.com; dkim=pass header.i=ddaney.cavm@gmail.com
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v6 3/5] MIPS: Octeon: Add irq handlers for GPIO interrupts.
Date: Wed, 29 Feb 2012 16:57:00 -0800
Message-Id: <1330563422-14078-4-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1330563422-14078-1-git-send-email-ddaney.cavm@gmail.com>
References: <1330563422-14078-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

This is needed for follow-on on patches for Octeon to use the Device
Tree to configure GPIO interrupts.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/cavium-octeon/octeon-irq.c |   96 +++++++++++++++++++++++++++++++++-
 1 files changed, 95 insertions(+), 1 deletions(-)

diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index ffd4ae6..bdcedd3 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -505,6 +505,72 @@ static void octeon_irq_ciu_enable_all_v2(struct irq_data *data)
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
@@ -717,6 +783,31 @@ static struct irq_chip octeon_irq_chip_ciu_mbox = {
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
@@ -890,6 +981,7 @@ static void __init octeon_irq_init_ciu(void)
 	struct irq_chip *chip_edge;
 	struct irq_chip *chip_mbox;
 	struct irq_chip *chip_wd;
+	struct irq_chip *chip_gpio;
 
 	octeon_irq_init_ciu_percpu();
 	octeon_irq_setup_secondary = octeon_irq_setup_secondary_ciu;
@@ -904,6 +996,7 @@ static void __init octeon_irq_init_ciu(void)
 		chip_edge = &octeon_irq_chip_ciu_edge_v2;
 		chip_mbox = &octeon_irq_chip_ciu_mbox_v2;
 		chip_wd = &octeon_irq_chip_ciu_wd_v2;
+		chip_gpio = &octeon_irq_chip_ciu_gpio_v2;
 	} else {
 		octeon_irq_ip2 = octeon_irq_ip2_v1;
 		octeon_irq_ip3 = octeon_irq_ip3_v1;
@@ -911,6 +1004,7 @@ static void __init octeon_irq_init_ciu(void)
 		chip_edge = &octeon_irq_chip_ciu_edge;
 		chip_mbox = &octeon_irq_chip_ciu_mbox;
 		chip_wd = &octeon_irq_chip_ciu_wd;
+		chip_gpio = &octeon_irq_chip_ciu_gpio;
 	}
 	octeon_irq_ip4 = octeon_irq_ip4_mask;
 
@@ -921,7 +1015,7 @@ static void __init octeon_irq_init_ciu(void)
 	for (i = 0; i < 16; i++)
 		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_WORKQ0, 0, i + 0, chip, handle_level_irq);
 	for (i = 0; i < 16; i++)
-		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_GPIO0, 0, i + 16, chip, handle_level_irq);
+		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_GPIO0, 0, i + 16, chip_gpio, handle_level_irq);
 
 	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX0, 0, 32, chip_mbox, handle_percpu_irq);
 	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX1, 0, 33, chip_mbox, handle_percpu_irq);
-- 
1.7.2.3

