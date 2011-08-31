Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab1HaV3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:29:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110Ab1HaV2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:28:33 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, Mark Salter <msalter@redhat.com>
Subject: [PATCH 23/24] C6X: Power and Sleep Controller
Date: Wed, 31 Aug 2011 17:26:58 -0400
Message-Id: <1314826019-22330-24-git-send-email-msalter@redhat.com>
In-Reply-To: <1314826019-22330-1-git-send-email-msalter@redhat.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides support for the Power/Sleep controller found on some SoCs.
The PSC controls two basic things: power domains and peripheral clock gating
and resets. The device tree is parsed at setup_arch tree to find any PSC node.
The number and controllability of the power domains and peripheral reset/gating
varies quite a bit from SoC to SoC. This driver tries to encapsulate the common
bits and provide an API for the SoC specific code to use.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/platforms/psc.c |  181 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/c6x/platforms/psc.h |   25 +++++++
 2 files changed, 206 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/platforms/psc.c
 create mode 100644 arch/c6x/platforms/psc.h

diff --git a/arch/c6x/platforms/psc.c b/arch/c6x/platforms/psc.c
new file mode 100644
index 0000000..c3fd52c
--- /dev/null
+++ b/arch/c6x/platforms/psc.c
@@ -0,0 +1,181 @@
+/*
+ *  Power/Sleep Controller
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
+#include <linux/delay.h>
+#include <asm/soc.h>
+#include "psc.h"
+
+#define PSC_PTCMD	0x0120
+#define PSC_PTSTAT	0x0128
+
+#define PSC_PDSTAT0	0x0200
+#define PSC_PDCTL0	0x0300
+
+#define PSC_MDSTAT0	0x0800
+#define PSC_MDCTL0	0x0a00
+
+#define PD_NEXT_DISABLE       2
+#define PD_NEXT_ENABLE        3
+
+#define MD_NEXT_SWRST_DISABLE	0
+#define MD_NEXT_SYNCRST		1
+#define MD_NEXT_DISABLE		2
+#define MD_NEXT_ENABLE		3
+#define MD_NEXT_MASK		0x1f
+
+#define LRSTZ	0x100
+
+struct psc_data {
+	u32		phys_base;
+	void __iomem	*base;
+	int		num_domains;
+	int		num_modules;
+	u8		module_domains[MAX_PSC_MODULES];
+};
+
+static struct psc_data psc;
+
+static inline void psc_write(int offset, unsigned int val)
+{
+	if (psc.base)
+		soc_writel(val, psc.base + offset);
+}
+
+static inline unsigned int psc_read(int offset)
+{
+	if (!psc.base)
+		return 0;
+	return soc_readl(psc.base + offset);
+}
+
+static void __wait_for_gostat(int domain_mask)
+{
+	while (psc_read(PSC_PTSTAT) & domain_mask)
+		;
+}
+
+void psc_domain_on(int domain)
+{
+	int reg = PSC_PDCTL0 + (domain * 4);
+
+	if (domain < 0 || domain >= psc.num_domains)
+		return;
+
+	__wait_for_gostat(1 << domain);
+	psc_write(reg, psc_read(reg) | 1);
+}
+
+void psc_domain_off(int domain)
+{
+	int reg = PSC_PDCTL0 + (domain * 4);
+
+	if (domain < 0 || domain >= psc.num_domains)
+		return;
+
+	__wait_for_gostat(1 << domain);
+	psc_write(reg, psc_read(reg) & ~1);
+}
+
+void psc_transition_domains(int domain_mask)
+{
+	domain_mask &= (1 << psc.num_domains) - 1;
+	if (domain_mask == 0)
+		return;
+
+	__wait_for_gostat(domain_mask);
+	psc_write(PSC_PTCMD, domain_mask);
+}
+
+void psc_module_on(int module)
+{
+	u32 reg, val;
+
+	if (module < 0 || module >= psc.num_modules)
+		return;
+
+	__wait_for_gostat(1 << psc.module_domains[module]);
+
+	reg = PSC_MDCTL0 + (module * 4);
+	val = psc_read(reg) & ~MD_NEXT_MASK;
+	psc_write(reg, val | MD_NEXT_ENABLE);
+}
+
+void psc_module_off(int module)
+{
+	u32 reg, val;
+
+	if (module < 0 || module >= psc.num_modules)
+		return;
+
+	__wait_for_gostat(1 << psc.module_domains[module]);
+
+	reg = PSC_MDCTL0 + (module * 4);
+	val = psc_read(reg) & ~MD_NEXT_MASK;
+	psc_write(reg, val | MD_NEXT_DISABLE);
+}
+
+void psc_module_reset(int module)
+{
+	int reg = PSC_MDCTL0 + module * 4;
+
+	if (module < 0 || module >= psc.num_modules)
+		return;
+
+	psc_write(reg, psc_read(reg) & ~LRSTZ);
+}
+
+void psc_module_reset_release(int module)
+{
+	int reg = PSC_MDCTL0 + module * 4;
+
+	if (module < 0 || module >= psc.num_modules)
+		return;
+
+	psc_write(reg, psc_read(reg) | LRSTZ);
+}
+
+void __init psc_init(void)
+{
+	struct device_node *node;
+	const __be32 *p;
+	int i, len;
+
+	node = of_find_compatible_node(NULL, NULL, "ti,c64x+psc");
+	if (!node)
+		return;
+
+	psc.base = of_iomap(node, 0);
+	if (!psc.base) {
+		of_node_put(node);
+		return;
+	}
+
+	p = of_get_property(node, "ti,number-psc-domains", &len);
+	if (p && len == sizeof(u32))
+		psc.num_domains = be32_to_cpup(p);
+
+	p = of_get_property(node, "ti,number-psc-modules", &len);
+	if (p && len == sizeof(u32))
+		psc.num_modules = be32_to_cpup(p);
+
+	p = of_get_property(node, "ti,module-domain-map", &len);
+	if (p) {
+		len /= sizeof(u32);
+		if (len > MAX_PSC_MODULES)
+			len = MAX_PSC_MODULES;
+		for (i = 0; i <= len; i++)
+			psc.module_domains[i] = be32_to_cpup(&p[i]);
+	}
+
+	of_node_put(node);
+}
diff --git a/arch/c6x/platforms/psc.h b/arch/c6x/platforms/psc.h
new file mode 100644
index 0000000..7f4bd1d
--- /dev/null
+++ b/arch/c6x/platforms/psc.h
@@ -0,0 +1,25 @@
+/*
+ *  C6X Power/Sleep Controller
+ *
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _C6X_PSC_H
+#define _C6X_PSC_H
+
+#define MAX_PSC_MODULES 16
+
+extern void psc_init(void);
+extern void psc_domain_on(int domain);
+extern void psc_domain_off(int domain);
+extern void psc_transition_domains(int domain_mask);
+extern void psc_module_on(int module);
+extern void psc_module_off(int module);
+extern void psc_module_reset(int module);
+extern void psc_module_reset_release(int module);
+
+#endif /* _C6X_PSC_H */
-- 
1.7.6

