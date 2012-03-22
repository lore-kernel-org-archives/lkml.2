Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab2CVS1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:27:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40258 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2CVS1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:27:32 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: linus.walleij@linaro.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linus.walleij@stericsson.com, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com, sjg@chromium.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH V3 1/6] dt: add property iteration helpers
Date: Thu, 22 Mar 2012 12:27:17 -0600
Message-Id: <1332440842-1098-1-git-send-email-swarren@wwwdotorg.org>
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
Acked-by: Rob Herring <rob.herring@calxeda.com>
---
v3: Moved code in base.c, defines/prototypes into of.h.
v2: Simplified the implementation per suggestion by Rob Herring.
---
 drivers/of/base.c  |   41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/of.h |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 5806449..d9bfd49 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1260,3 +1260,44 @@ int of_alias_get_id(struct device_node *np, const char *stem)
 	return id;
 }
 EXPORT_SYMBOL_GPL(of_alias_get_id);
+
+const __be32 *of_prop_next_u32(struct property *prop, const __be32 *cur,
+			       u32 *pu)
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
+EXPORT_SYMBOL_GPL(of_prop_next_u32);
+
+const char *of_prop_next_string(struct property *prop, const char *cur)
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
+EXPORT_SYMBOL_GPL(of_prop_next_string);
diff --git a/include/linux/of.h b/include/linux/of.h
index ba5d849..7c58550 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -269,6 +269,37 @@ extern void of_detach_node(struct device_node *);
 #endif
 
 #define of_match_ptr(_ptr)	(_ptr)
+
+/*
+ * struct property *prop;
+ * const __be32 *p;
+ * u32 u;
+ *
+ * of_property_for_each_u32(np, "propname", prop, p, u)
+ *         printk("U32 value: %x\n", u);
+ */
+const __be32 *of_prop_next_u32(struct property *prop, const __be32 *cur,
+			       u32 *pu);
+#define of_property_for_each_u32(np, propname, prop, p, u)	\
+	for (prop = of_find_property(np, propname, NULL),	\
+		p = of_prop_next_u32(prop, NULL, &u);		\
+		p;						\
+		p = of_prop_next_u32(prop, p, &u))
+
+/*
+ * struct property *prop;
+ * const char *s;
+ *
+ * of_property_for_each_string(np, "propname", prop, s)
+ *         printk("String value: %s\n", s);
+ */
+const char *of_prop_next_string(struct property *prop, const char *cur);
+#define of_property_for_each_string(np, propname, prop, s)	\
+	for (prop = of_find_property(np, propname, NULL),	\
+		s = of_prop_next_string(prop, NULL);		\
+		s;						\
+		s = of_prop_next_string(prop, s))
+
 #else /* CONFIG_OF */
 
 static inline bool of_have_populated_dt(void)
@@ -359,6 +390,10 @@ static inline int of_machine_is_compatible(const char *compat)
 
 #define of_match_ptr(_ptr)	NULL
 #define of_match_node(_matches, _node)	NULL
+#define of_property_for_each_u32(np, propname, prop, p, u) \
+	while (0)
+#define of_property_for_each_string(np, propname, prop, s) \
+	while (0)
 #endif /* CONFIG_OF */
 
 /**
-- 
1.7.0.4

