Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab2CTRou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 13:44:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57673 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2CTRos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 13:44:48 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: linus.walleij@linaro.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linus.walleij@stericsson.com, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com, sjg@chromium.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH V2 1/6] dt: add property iteration helpers
Date: Tue, 20 Mar 2012 11:44:34 -0600
Message-Id: <1332265479-1260-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds macros of_property_for_each_u32() and
of_property_for_each_string(), which iterate over an array of values
within a device-tree property. Usage is for example:

struct property *prop;
const __be32 *p;
u32 u;
of_property_for_each_u32(np, "propname", prop, p, u)
	printk("U32 value: %x\n", u);

struct property *prop;
const char *s;
of_property_for_each_string(np, "propname", prop, s)
	printk("String value: %s\n", s);

Based on work by Rob Herring <robherring2@gmail.com>

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
v2: Simplified the implementation per suggestion by Rob Herring.
---
 include/linux/of_iter_prop.h |  101 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 101 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/of_iter_prop.h

diff --git a/include/linux/of_iter_prop.h b/include/linux/of_iter_prop.h
new file mode 100644
index 0000000..e3df23c
--- /dev/null
+++ b/include/linux/of_iter_prop.h
@@ -0,0 +1,101 @@
+/*
+ * Copyright (c) 2011-2012 NVIDIA CORPORATION. All rights reserved.
+ *
+ * Iterate over properties that store arrays.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __OF_ITER_PROP_H__
+#define __OF_ITER_PROP_H__
+
+#include <linux/of.h>
+
+#ifdef CONFIG_OF
+static inline const __be32 *of_prop_next_u32(struct property *prop,
+					     const __be32 *cur, u32 *pu)
+{
+	const void *curv = cur;
+
+	if (!prop)
+		return NULL;
+
+	if (!cur) {
+		curv = prop->value;
+		goto out_val;
+	}
+
+	curv += sizeof(*cur);
+	if (curv >= prop->value + prop->length)
+		return NULL;
+
+out_val:
+	*pu = be32_to_cpup(curv);
+	return curv;
+}
+
+/*
+ * struct property *prop;
+ * const __be32 *p;
+ * u32 u;
+ *
+ * of_property_for_each_u32(np, "propname", prop, p, u)
+ *         printk("U32 value: %x\n", u);
+ */
+#define of_property_for_each_u32(np, propname, prop, p, u)	\
+	for (prop = of_find_property(np, propname, NULL),	\
+		p = of_prop_next_u32(prop, NULL, &u);		\
+		p;						\
+		p = of_prop_next_u32(prop, p, &u))
+
+static inline const char *of_prop_next_string(struct property *prop,
+					      const char *cur)
+{
+	const void *curv = cur;
+
+	if (!prop)
+		return NULL;
+
+	if (!cur)
+		return prop->value;
+
+	curv += strlen(cur) + 1;
+	if (curv >= prop->value + prop->length)
+		return NULL;
+
+	return curv;
+}
+
+/*
+ * struct property *prop;
+ * const char *s;
+ *
+ * of_property_for_each_string(np, "propname", prop, s)
+ *         printk("String value: %s\n", s);
+ */
+#define of_property_for_each_string(np, propname, prop, s)	\
+	for (prop = of_find_property(np, propname, NULL),	\
+		s = of_prop_next_string(prop, NULL);		\
+		s;						\
+		s = of_prop_next_string(prop, s))
+
+#else
+
+#define of_property_for_each_u32(np, propname, prop, p, u) \
+	while (0)
+
+#define of_property_for_each_string(np, propname, prop, s) \
+	while (0)
+
+#endif /* CONFIG_OF */
+
+#endif /* __OF_ITER_PROP_H__ */
-- 
1.7.0.4

