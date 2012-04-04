Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab2DDP2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 11:28:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54420 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab2DDP17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 11:27:59 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH V4 REPOST 1/5] dt: add property iteration helpers
Date: Wed,  4 Apr 2012 09:27:46 -0600
Message-Id: <1333553270-9040-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

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

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Rob Herring <rob.herring@calxeda.com>
---
v3: Moved code in base.c, defines/prototypes into of.h.
v2: Simplified the implementation per suggestion by Rob Herring.

Linus, this series is my previously posted V4 rebased on top of
next-20120404 plus all the changes from your for-next branch plus the
Makefile fix I posted last night. Note that I didn't see any conflicts
during the rebase; were you expecting me to?

Grant, you asked me to remind you about this patch after the merge window
closed. Note that it's a dependency of patch 5 in this series, so needs
to go in through the pinctrl tree, or both there and the DT tree.

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
index fa7fb1d..e3f942d 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -259,6 +259,37 @@ extern void of_detach_node(struct device_node *);
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
@@ -349,6 +380,10 @@ static inline int of_machine_is_compatible(const char *compat)
 
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

