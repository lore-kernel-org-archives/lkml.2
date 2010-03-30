Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab0C3SPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:15:00 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:59487 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab0C3SO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:14:59 -0400
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: Russell King <linux@arm.linux.org.uk>,
       Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
       Ralf Baechle <ralf@linux-mips.org>, Eric Miao <eric.y.miao@gmail.com>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Manuel Lauss <manuel.lauss@gmail.com>,
       Dmitry Artamonow <mad_soft@inbox.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org,
       Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: [PATCH] ARM: pcmcia: Adds nanoEngine PCMCIA support.
Date: Tue, 30 Mar 2010 15:14:39 -0300
Message-Id: <1269972879-27400-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds nanoEngine PCMCIA support, with support for two sockets.

In order to have a fully functional pcmcia subsystem in a BSE nanoEngine board
you should carefully read this:

http://cambuca.ldhs.cetuc.puc-rio.br/nanoengine/

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 arch/arm/mach-sa1100/include/mach/nanoengine.h |   30 ++++
 arch/arm/mach-sa1100/nanoengine.c              |    2 +-
 drivers/pcmcia/Makefile                        |    1 +
 drivers/pcmcia/sa1100_generic.c                |    3 +
 drivers/pcmcia/sa1100_generic.h                |    1 +
 drivers/pcmcia/sa1100_nanoengine.c             |  218 ++++++++++++++++++++++++
 6 files changed, 254 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-sa1100/include/mach/nanoengine.h
 create mode 100644 drivers/pcmcia/sa1100_nanoengine.c

diff --git a/arch/arm/mach-sa1100/include/mach/nanoengine.h b/arch/arm/mach-sa1100/include/mach/nanoengine.h
new file mode 100644
index 0000000..0537766
--- /dev/null
+++ b/arch/arm/mach-sa1100/include/mach/nanoengine.h
@@ -0,0 +1,30 @@
+/*
+ * arch/arm/mach-sa1100/include/mach/nanoengine.h
+ *
+ * This file contains the hardware specific definitions for nanoEngine.
+ * Only include this file from SA1100-specific files.
+ *
+ * Copyright (C) 2010 Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#ifndef __ASM_ARCH_NANOENGINE_H
+#define __ASM_ARCH_NANOENGINE_H
+
+#define GPIO_PC_READY0	GPIO_GPIO(11) /* ready for socket 0 (active high)*/
+#define GPIO_PC_READY1	GPIO_GPIO(12) /* ready for socket 1 (active high) */
+#define GPIO_PC_CD0	GPIO_GPIO(13) /* detect for socket 0 (active low) */
+#define GPIO_PC_CD1	GPIO_GPIO(14) /* detect for socket 1 (active low) */
+#define GPIO_PC_RESET0	GPIO_GPIO(15) /* reset socket 0 */
+#define GPIO_PC_RESET1	GPIO_GPIO(16) /* reset socket 1 */
+
+#define NANOENGINE_IRQ_GPIO_PC_READY0	IRQ_GPIO11
+#define NANOENGINE_IRQ_GPIO_PC_READY1	IRQ_GPIO12
+#define NANOENGINE_IRQ_GPIO_PC_CD0	IRQ_GPIO13
+#define NANOENGINE_IRQ_GPIO_PC_CD1	IRQ_GPIO14
+
+#endif
+
diff --git a/arch/arm/mach-sa1100/nanoengine.c b/arch/arm/mach-sa1100/nanoengine.c
index 73a7922..36cdc8a 100644
--- a/arch/arm/mach-sa1100/nanoengine.c
+++ b/arch/arm/mach-sa1100/nanoengine.c
@@ -3,7 +3,7 @@
  *
  * Bright Star Engineering's nanoEngine board init code.
  *
- * Copyright (C) 2009 Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
+ * Copyright (C) 2010 Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/pcmcia/Makefile b/drivers/pcmcia/Makefile
index 381b031..bb9fa64 100644
--- a/drivers/pcmcia/Makefile
+++ b/drivers/pcmcia/Makefile
@@ -50,6 +50,7 @@ sa1100_cs-$(CONFIG_SA1100_ASSABET)		+= sa1100_assabet.o
 sa1100_cs-$(CONFIG_SA1100_CERF)			+= sa1100_cerf.o
 sa1100_cs-$(CONFIG_SA1100_COLLIE)              += pxa2xx_sharpsl.o
 sa1100_cs-$(CONFIG_SA1100_H3600)		+= sa1100_h3600.o
+sa1100_cs-$(CONFIG_SA1100_NANOENGINE)		+= sa1100_nanoengine.o
 sa1100_cs-$(CONFIG_SA1100_SHANNON)		+= sa1100_shannon.o
 sa1100_cs-$(CONFIG_SA1100_SIMPAD)		+= sa1100_simpad.o
 
diff --git a/drivers/pcmcia/sa1100_generic.c b/drivers/pcmcia/sa1100_generic.c
index 5188962..a1fce5d 100644
--- a/drivers/pcmcia/sa1100_generic.c
+++ b/drivers/pcmcia/sa1100_generic.c
@@ -54,6 +54,9 @@ static int (*sa11x0_pcmcia_hw_init[])(struct device *dev) = {
 #if defined(CONFIG_SA1100_H3100) || defined(CONFIG_SA1100_H3600)
 	pcmcia_h3600_init,
 #endif
+#ifdef CONFIG_SA1100_NANOENGINE
+	pcmcia_nanoengine_init,
+#endif
 #ifdef CONFIG_SA1100_SHANNON
 	pcmcia_shannon_init,
 #endif
diff --git a/drivers/pcmcia/sa1100_generic.h b/drivers/pcmcia/sa1100_generic.h
index 794f96a..adb08db 100644
--- a/drivers/pcmcia/sa1100_generic.h
+++ b/drivers/pcmcia/sa1100_generic.h
@@ -13,6 +13,7 @@ extern int pcmcia_freebird_init(struct device *);
 extern int pcmcia_gcplus_init(struct device *);
 extern int pcmcia_graphicsmaster_init(struct device *);
 extern int pcmcia_h3600_init(struct device *);
+extern int pcmcia_nanoengine_init(struct device *);
 extern int pcmcia_pangolin_init(struct device *);
 extern int pcmcia_pfs168_init(struct device *);
 extern int pcmcia_shannon_init(struct device *);
diff --git a/drivers/pcmcia/sa1100_nanoengine.c b/drivers/pcmcia/sa1100_nanoengine.c
new file mode 100644
index 0000000..2f164e6
--- /dev/null
+++ b/drivers/pcmcia/sa1100_nanoengine.c
@@ -0,0 +1,218 @@
+/*
+ * drivers/pcmcia/sa1100_nanoengine.c
+ *
+ * PCMCIA implementation routines for BSI nanoEngine.
+ *
+ * In order to have a fully functional pcmcia subsystem in a BSE nanoEngine
+ * board you should carefully read this:
+ * http://cambuca.ldhs.cetuc.puc-rio.br/nanoengine/
+ *
+ * Copyright (C) 2010 Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/signal.h>
+
+#include <asm/mach-types.h>
+#include <asm/irq.h>
+
+#include <mach/hardware.h>
+#include <mach/nanoengine.h>
+
+#include "sa1100_generic.h"
+
+static struct pcmcia_irqs irqs_skt0[] = {
+	/* socket, IRQ, name */
+	{ 0, NANOENGINE_IRQ_GPIO_PC_CD0, "PC CD0" },
+};
+
+static struct pcmcia_irqs irqs_skt1[] = {
+	/* socket, IRQ, name */
+	{ 1, NANOENGINE_IRQ_GPIO_PC_CD1, "PC CD1" },
+};
+
+struct nanoengine_pins {
+	unsigned input_pins;
+	unsigned output_pins;
+	unsigned clear_outputs;
+	unsigned transition_pins;
+	unsigned pci_irq;
+	struct pcmcia_irqs *pcmcia_irqs;
+	unsigned pcmcia_irqs_size;
+};
+
+static struct nanoengine_pins nano_skts[] = {
+	{
+		.input_pins		= GPIO_PC_READY0 | GPIO_PC_CD0,
+		.output_pins		= GPIO_PC_RESET0,
+		.clear_outputs		= GPIO_PC_RESET0,
+		.transition_pins	= NANOENGINE_IRQ_GPIO_PC_CD0,
+		.pci_irq		= NANOENGINE_IRQ_GPIO_PC_READY0,
+		.pcmcia_irqs		= irqs_skt0,
+		.pcmcia_irqs_size	= ARRAY_SIZE(irqs_skt0)
+	}, {
+		.input_pins		= GPIO_PC_READY1 | GPIO_PC_CD1,
+		.output_pins		= GPIO_PC_RESET1,
+		.clear_outputs		= GPIO_PC_RESET1,
+		.transition_pins	= NANOENGINE_IRQ_GPIO_PC_CD1,
+		.pci_irq		= NANOENGINE_IRQ_GPIO_PC_READY1,
+		.pcmcia_irqs		= irqs_skt1,
+		.pcmcia_irqs_size	= ARRAY_SIZE(irqs_skt1)
+	}
+};
+
+unsigned num_nano_pcmcia_sockets = ARRAY_SIZE(nano_skts);
+
+static int nanoengine_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
+{
+	unsigned i = skt->nr;
+
+	if (i >= num_nano_pcmcia_sockets)
+		return -ENXIO;
+
+	GPDR &= ~nano_skts[i].input_pins;
+	GPDR |=  nano_skts[i].output_pins;
+	GPCR =   nano_skts[i].clear_outputs;
+	set_irq_type(nano_skts[i].transition_pins, IRQ_TYPE_EDGE_BOTH);
+	skt->socket.pci_irq = nano_skts[i].pci_irq;
+
+	return soc_pcmcia_request_irqs(skt,
+		nano_skts[i].pcmcia_irqs, nano_skts[i].pcmcia_irqs_size);
+}
+
+/*
+ * Release all resources.
+ */
+static void nanoengine_pcmcia_hw_shutdown(struct soc_pcmcia_socket *skt)
+{
+	unsigned i = skt->nr;
+
+	if (i >= num_nano_pcmcia_sockets)
+		return;
+
+	soc_pcmcia_free_irqs(skt,
+		nano_skts[i].pcmcia_irqs, nano_skts[i].pcmcia_irqs_size);
+}
+
+static int nanoengine_pcmcia_configure_socket(
+	struct soc_pcmcia_socket *skt, const socket_state_t *state)
+{
+	unsigned reset;
+	unsigned i = skt->nr;
+
+	if (i >= num_nano_pcmcia_sockets)
+		return -ENXIO;
+
+	switch (i) {
+	case 0:
+		reset = GPIO_PC_RESET0;
+		break;
+	case 1:
+		reset = GPIO_PC_RESET1;
+		break;
+	default:
+		return -ENXIO;
+	}
+
+	if (state->flags & SS_RESET)
+		GPSR = reset;
+	else
+		GPCR = reset;
+
+	return 0;
+}
+
+static void nanoengine_pcmcia_socket_state(
+	struct soc_pcmcia_socket *skt, struct pcmcia_state *state)
+{
+	unsigned long levels = GPLR;
+	unsigned i = skt->nr;
+
+	if (i >= num_nano_pcmcia_sockets)
+		return;
+
+	memset(state, 0, sizeof(struct pcmcia_state));
+	switch (i) {
+	case 0:
+		state->ready	=  (levels & GPIO_PC_READY0)	? 1 : 0;
+		state->detect	= !(levels & GPIO_PC_CD0)	? 1 : 0;
+		break;
+	case 1:
+		state->ready	=  (levels & GPIO_PC_READY1)	? 1 : 0;
+		state->detect	= !(levels & GPIO_PC_CD1)	? 1 : 0;
+		break;
+	default:
+		return;
+	}
+	state->bvd1	= 1;
+	state->bvd2	= 1;
+	state->wrprot	= 0; /* Not available */
+	state->vs_3v	= 1; /* Can only apply 3.3V */
+	state->vs_Xv	= 0;
+}
+
+/*
+ * Enable card status IRQs on (re-)initialisation.  This can
+ * be called at initialisation, power management event, or
+ * pcmcia event.
+ */
+static void nanoengine_pcmcia_socket_init(struct soc_pcmcia_socket *skt)
+{
+	unsigned i = skt->nr;
+
+	if (i >= num_nano_pcmcia_sockets)
+		return;
+
+	soc_pcmcia_enable_irqs(skt,
+		nano_skts[i].pcmcia_irqs, nano_skts[i].pcmcia_irqs_size);
+}
+
+/*
+ * Disable card status IRQs on suspend.
+ */
+static void nanoengine_pcmcia_socket_suspend(struct soc_pcmcia_socket *skt)
+{
+	unsigned i = skt->nr;
+
+	if (i >= num_nano_pcmcia_sockets)
+		return;
+
+	soc_pcmcia_disable_irqs(skt,
+		nano_skts[i].pcmcia_irqs, nano_skts[i].pcmcia_irqs_size);
+}
+
+static struct pcmcia_low_level nanoengine_pcmcia_ops = {
+	.owner			= THIS_MODULE,
+
+	.hw_init		= nanoengine_pcmcia_hw_init,
+	.hw_shutdown		= nanoengine_pcmcia_hw_shutdown,
+
+	.configure_socket	= nanoengine_pcmcia_configure_socket,
+	.socket_state		= nanoengine_pcmcia_socket_state,
+	.socket_init		= nanoengine_pcmcia_socket_init,
+	.socket_suspend		= nanoengine_pcmcia_socket_suspend,
+};
+
+int pcmcia_nanoengine_init(struct device *dev)
+{
+	int ret = -ENODEV;
+
+	printk(KERN_INFO "BSE nanoEngine pcmcia support by "
+		"Miguel Freitas & Marcelo Jimenez.\n");
+	if (machine_is_nanoengine())
+		ret = sa11xx_drv_pcmcia_probe(
+			dev, &nanoengine_pcmcia_ops, 0, 2);
+
+	return ret;
+}
+
-- 
1.7.0.3

