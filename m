Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1I0UbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:31:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1I0Uac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:30:32 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Mark Salter <msalter@redhat.com>
Subject: [PATCH v3 22/24] C6X: EMIF - External Memory Interface
Date: Tue, 27 Sep 2011 16:30:03 -0400
Message-Id: <1317155405-26235-23-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-1-git-send-email-msalter@redhat.com>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
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
 arch/c6x/platforms/emif.c |   88 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/platforms/emif.c

diff --git a/arch/c6x/platforms/emif.c b/arch/c6x/platforms/emif.c
new file mode 100644
index 0000000..6a0d4ff
--- /dev/null
+++ b/arch/c6x/platforms/emif.c
@@ -0,0 +1,88 @@
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
+#include <asm/dscr.h>
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
+static struct of_device_id emifa_match[] __initdata = {
+	{ .compatible = "ti,c64x+emifa"	},
+	{}
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
+	u32 val;
+	int i, len, err;
+
+	node = of_find_matching_node(NULL, emifa_match);
+	if (!node)
+		return 0;
+
+	regs = of_iomap(node, 0);
+	if (!regs)
+		return 0;
+
+	/* look for a dscr-based enable for emifa pin buffers */
+	err = of_property_read_u32_array(node, "ti,dscr-dev-enable", &val, 1);
+	if (!err)
+		dscr_set_devstate(val, DSCR_DEVSTATE_ENABLED);
+
+	/* set up the chip enables */
+	p = of_get_property(node, "ti,emifa-ce-config", &len);
+	if (p) {
+		len /= sizeof(u32);
+		if (len > NUM_EMIFA_CHIP_ENABLES)
+			len = NUM_EMIFA_CHIP_ENABLES;
+		for (i = 0; i <= len; i++)
+			soc_writel(be32_to_cpup(&p[i]), &regs->cecfg[i]);
+	}
+
+	err = of_property_read_u32_array(node, "ti,emifa-burst-priority", &val, 1);
+	if (!err)
+		soc_writel(val, &regs->bprio);
+
+	err = of_property_read_u32_array(node, "ti,emifa-async-wait-control", &val, 1);
+	if (!err)
+		soc_writel(val, &regs->awcc);
+
+	iounmap(regs);
+	of_node_put(node);
+	return 0;
+}
+pure_initcall(c6x_emifa_init);
-- 
1.7.6.2

