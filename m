Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266Ab2CPUyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:54:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36558 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965082Ab2CPUyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:54:47 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 1/8] dt: add property iteration helpers
Date: Fri, 16 Mar 2012 14:54:22 -0600
Message-Id: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds macros for_each_u32_property_value and
for_each_string_property_value, which iterate over an array of values
within a device-tree property. Usage is for example:

struct of_iter_string_prop iter;
for_each_string_property_value(iter, np, "pins")
        printk("Got value %s\n", iter.value);

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
 include/linux/of_iter_prop.h |  139 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 139 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/of_iter_prop.h

diff --git a/include/linux/of_iter_prop.h b/include/linux/of_iter_prop.h
new file mode 100644
index 0000000..57e9e6a
--- /dev/null
+++ b/include/linux/of_iter_prop.h
@@ -0,0 +1,139 @@
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
+struct of_iter_u32_prop {
+	const struct property *prop;
+	int len;
+	const __be32 *pvalue;
+	u32 value;
+};
+
+static inline void of_iter_u32_next(struct of_iter_u32_prop *iter)
+{
+	if (!iter->len)
+		return;
+
+	iter->len--;
+	if (iter->len)
+		iter->value = be32_to_cpup(iter->pvalue++);
+}
+
+static inline void of_iter_u32_init(struct of_iter_u32_prop *iter,
+				    const struct device_node *np,
+				    const char *name)
+{
+	iter->prop = of_find_property(np, name, &iter->len);
+	if (!iter->prop) {
+		iter->len = 0;
+		return;
+	}
+
+	iter->pvalue = iter->prop->value;
+	if (!iter->pvalue) {
+		iter->len = 0;
+		return;
+	}
+
+	iter->len /= sizeof(*iter->pvalue);
+
+	if (iter->len)
+		iter->value = be32_to_cpup(iter->pvalue++);
+}
+
+static inline bool of_iter_u32_test(struct of_iter_u32_prop *iter)
+{
+	return iter->len > 0;
+}
+
+#define for_each_u32_property_value(iter, np, prop_name) \
+	for (of_iter_u32_init(&iter, np, prop_name); \
+	     of_iter_u32_test(&iter); \
+	     of_iter_u32_next(&iter))
+
+struct of_iter_string_prop {
+	const struct property *prop;
+	int len;
+	const char *value;
+	const char *after;
+};
+
+static inline void of_iter_string_init(struct of_iter_string_prop *iter,
+				       const struct device_node *np,
+				       const char *name)
+{
+	iter->prop = of_find_property(np, name, &iter->len);
+	if (!iter->prop) {
+		iter->value = NULL;
+		return;
+	}
+
+	iter->value = iter->prop->value;
+	if (!iter->value)
+		return;
+
+	iter->after = iter->value + iter->len;
+}
+
+static inline bool of_iter_string_test(struct of_iter_string_prop *iter)
+{
+	if (!iter->value)
+		return false;
+
+	return iter->value < iter->after;
+}
+
+static inline void of_iter_string_next(struct of_iter_string_prop *iter)
+{
+	int len;
+
+	if (!iter->value)
+		return;
+
+	len = strnlen(iter->value, iter->len);
+	iter->len -= len + 1;
+	iter->value += len + 1;
+}
+
+#define for_each_string_property_value(iter, np, prop_name) \
+	for (of_iter_string_init(&iter, np, prop_name); \
+	     of_iter_string_test(&iter); \
+	     of_iter_string_next(&iter))
+
+#else
+struct of_iter_u32_prop {
+	u32 value;
+};
+
+#define for_each_u32_property_value(iter, np, prop_name) \
+	while (0)
+
+struct of_iter_string_prop {
+	const char *value;
+};
+
+#define for_each_string_property_value(iter, np, prop_name) \
+	while (0)
+
+#endif /* CONFIG_OF */
+
+#endif /* __OF_ITER_PROP_H__ */
-- 
1.7.0.4

