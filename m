Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1HYXpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:45:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43133 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1HYXoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:44:22 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v3 11/13] of: add property iteration helpers
Date: Thu, 25 Aug 2011 17:43:42 -0600
Message-Id: <1314315824-9687-12-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds macros for_each_u32_property_value and
for_each_string_property_value, which iterate over an array of values
within a device-tree property. Usage is for example:

struct of_iter_string_prop iter;
for_each_string_property_value(iter, np, "pins")
        printk("Got value %s\n", iter.value);

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 include/linux/of_iter_prop.h |  135 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 135 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/of_iter_prop.h

diff --git a/include/linux/of_iter_prop.h b/include/linux/of_iter_prop.h
new file mode 100644
index 0000000..c7fb2bf
--- /dev/null
+++ b/include/linux/of_iter_prop.h
@@ -0,0 +1,135 @@
+/*
+ * Copyright (c) 2011 NVIDIA Inc.
+ *
+ * Iterate over properties that store arrays.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
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
+	if (iter->len < 0)
+		return;
+
+	iter->value = be32_to_cpup(iter->pvalue++);
+	iter->len--;
+}
+
+static inline void of_iter_u32_init(struct of_iter_u32_prop *iter,
+				    const struct device_node *np,
+				    const char *name)
+{
+	iter->prop = of_find_property(np, name, &iter->len);
+	if (!iter->prop) {
+		iter->len = -1;
+		return;
+	}
+
+	iter->pvalue = iter->prop->value;
+	if (!iter->pvalue) {
+		iter->len = -1;
+		return;
+	}
+
+	iter->len /= sizeof(*iter->pvalue);
+
+	of_iter_u32_next(iter);
+}
+
+static inline bool of_iter_u32_test(struct of_iter_u32_prop *iter)
+{
+	return iter->len >= 0;
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
+	iter->len -= len;
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

