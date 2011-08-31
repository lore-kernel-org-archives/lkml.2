Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1HaV2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:28:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110Ab1HaV22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:28:28 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, Mark Salter <msalter@redhat.com>
Subject: [PATCH 22/24] C6X: EMIF - External Memory Interface
Date: Wed, 31 Aug 2011 17:26:57 -0400
Message-Id: <1314826019-22330-23-git-send-email-msalter@redhat.com>
In-Reply-To: <1314826019-22330-1-git-send-email-msalter@redhat.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several SoC parts provide a simple bridge to support external memory mapped
devices. This code probes the device tree for an EMIF node and sets up the
bridge registers if such a node is found. Beyond initial set up, there is no
further need to access the bridge control registers. External devices on the
bus are accessed through their MMIO registers using suitable drivers. The
bridge hardware does provide for timeout and other error interrupts, but these
are not yet supported.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/platforms/emif.c |   77 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/platforms/emif.c

diff --git a/arch/c6x/platforms/emif.c b/arch/c6x/platforms/emif.c
new file mode 100644
index 0000000..2d9a35d
--- /dev/null
+++ b/arch/c6x/platforms/emif.c
@@ -0,0 +1,77 @@
+/*
+ *  External Memory Interface
+ *
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+#include <asm/soc.h>
+
+#define NUM_EMIFA_CHIP_ENABLES 4
+
+struct emifa_regs {
+	u32	midr;
+	u32	stat;
+	u32	reserved1[6];
+	u32	bprio;
+	u32	reserved2[23];
+	u32	ce_config;
+	u32	cecfg[NUM_EMIFA_CHIP_ENABLES];
+	u32	reserved3[4];
+	u32	awcc;
+	u32	reserved4[7];
+	u32	intraw;
+	u32	intmsk;
+	u32	intmskset;
+	u32	intmskclr;
+};
+
+/*
+ * Parse device tree for existence of an EMIF (External Memory Interface)
+ * and initialize it if found.
+ */
+static int __init c6x_emifa_init(void)
+{
+	struct emifa_regs __iomem *regs;
+	struct device_node *node;
+	const __be32 *p;
+	int i, len;
+
+	node = of_find_compatible_node(NULL, NULL, "ti,c64x+emifa");
+	if (!node)
+		return 0;
+
+	regs = of_iomap(node, 0);
+	if (!regs)
+		return 0;
+
+	/* emif power/clocks */
+	soc_dev_enable(SOC_DEV_EMIF, 0);
+
+	p = of_get_property(node, "ti,emifa-ce-config", &len);
+	if (p) {
+		len /= sizeof(u32);
+		if (len > NUM_EMIFA_CHIP_ENABLES)
+			len = NUM_EMIFA_CHIP_ENABLES;
+		for (i = 0; i <= len; i++)
+			soc_writel(be32_to_cpup(&p[i]), &regs->cecfg[i]);
+	}
+
+	p = of_get_property(node, "ti,emifa-burst-priority", &len);
+	if (p && len == sizeof(u32))
+		soc_writel(be32_to_cpup(p), &regs->bprio);
+
+	p = of_get_property(node, "ti,emifa-async-wait-control", &len);
+	if (p && len == sizeof(u32))
+		soc_writel(be32_to_cpup(p), &regs->awcc);
+
+	of_node_put(node);
+	return 0;
+}
+pure_initcall(c6x_emifa_init);
-- 
1.7.6

