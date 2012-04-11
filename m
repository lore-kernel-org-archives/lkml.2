Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732Ab2DKQ4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:56:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35894 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab2DKQ4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:56:18 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: implement devm_pinctrl_get()/put()
Date: Wed, 11 Apr 2012 10:56:10 -0600
Message-Id: <1334163370-21991-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

These functions allow the driver core to automatically clean up any
allocations made by drivers, thus leading to simplified drivers.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Note: this hasn't been tested beyond a compile-test.

 drivers/pinctrl/core.c           |   56 ++++++++++++++++++++++++++++++++++++++
 include/linux/pinctrl/consumer.h |   12 ++++++++
 2 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 3ae00ab..c5c7000 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -23,6 +23,7 @@
 #include <linux/sysfs.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/machine.h>
 #include "core.h"
@@ -801,6 +802,61 @@ int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
 }
 EXPORT_SYMBOL_GPL(pinctrl_select_state);
 
+static void devm_pinctrl_release(struct device *dev, void *res)
+{
+	pinctrl_put(*(struct pinctrl **)res);
+}
+
+/**
+ * struct devm_pinctrl_get() - Resource managed pinctrl_get()
+ * @dev: the device to obtain the handle for
+ *
+ * If there is a need to explicitly destroy the returned struct pinctrl,
+ * devm_pinctrl_put() should be used, rather than plain pinctrl_put().
+ */
+struct pinctrl *devm_pinctrl_get(struct device *dev)
+{
+	struct pinctrl **ptr, *p;
+
+	ptr = devres_alloc(devm_pinctrl_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	p = pinctrl_get(dev);
+	if (!IS_ERR(p)) {
+		*ptr = p;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return p;
+}
+EXPORT_SYMBOL_GPL(devm_pinctrl_get);
+
+static int devm_pinctrl_match(struct device *dev, void *res, void *data)
+{
+	struct pinctrl **p = res;
+
+	return *p == data;
+}
+
+/**
+ * devm_pinctrl_put() - Resource managed pinctrl_put()
+ * @p: the pinctrl handle to release
+ *
+ * Deallocate a struct pinctrl obtained via devm_pinctrl_get(). Normally
+ * this function will not need to be called and the resource management
+ * code will ensure that the resource is freed.
+ */
+void devm_pinctrl_put(struct pinctrl *p)
+{
+	WARN_ON(devres_destroy(p->dev, devm_pinctrl_release,
+			       devm_pinctrl_match, p));
+	pinctrl_put(p);
+}
+EXPORT_SYMBOL_GPL(devm_pinctrl_put);
+
 int pinctrl_register_map(struct pinctrl_map const *maps, unsigned num_maps,
 			 bool dup, bool locked)
 {
diff --git a/include/linux/pinctrl/consumer.h b/include/linux/pinctrl/consumer.h
index 191e726..e873f21 100644
--- a/include/linux/pinctrl/consumer.h
+++ b/include/linux/pinctrl/consumer.h
@@ -36,6 +36,9 @@ extern struct pinctrl_state * __must_check pinctrl_lookup_state(
 							const char *name);
 extern int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *s);
 
+extern struct pinctrl * __must_check devm_pinctrl_get(struct device *dev);
+extern void devm_pinctrl_put(struct pinctrl *p);
+
 #else /* !CONFIG_PINCTRL */
 
 static inline int pinctrl_request_gpio(unsigned gpio)
@@ -79,6 +82,15 @@ static inline int pinctrl_select_state(struct pinctrl *p,
 	return 0;
 }
 
+static inline struct pinctrl * __must_check devm_pinctrl_get(struct device *dev)
+{
+	return NULL;
+}
+
+static inline void devm_pinctrl_put(struct pinctrl *p)
+{
+}
+
 #endif /* CONFIG_PINCTRL */
 
 static inline struct pinctrl * __must_check pinctrl_get_select(
-- 
1.7.0.4

