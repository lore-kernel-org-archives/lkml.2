Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab2LFHtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:49:31 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5210 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2LFHta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:49:30 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6917"; a="12030463"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Brown <davidb@codeaurora.org>, mbohan@codeaurora.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH v2] of: Output devicetree alias names in uevent
Date: Wed,  5 Dec 2012 23:49:25 -0800
Message-Id: <1354780165-872-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <20121205230318.013053E0E22@localhost>
References: <20121205230318.013053E0E22@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some situations, userspace may want to resolve a
device by function and logical number (ie, "serial0")
rather than by the base address or full device path. Being
able to resolve a device by alias frees userspace from the
burden of otherwise having to maintain a mapping between
device addresses and their logical assignments on each
platform when multiple instances of the same hardware block
are present in the system.

Although the uevent device attribute contains devicetree
compatible information and the full device path, the uevent
does not list the alises that may have been defined for the
device.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
v2: Create of_private.h and move struct alias_prop there
    Add alias uevent variables from of_device_uevent
    Use app->alias instead of app->stem / app->id directly
    Expose alias_lookup and of_alias_mutex

 drivers/of/base.c       |   23 +++--------------------
 drivers/of/device.c     |   17 +++++++++++++++++
 drivers/of/of_private.h |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 20 deletions(-)
 create mode 100644 drivers/of/of_private.h

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 5806449..715aef2 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -24,32 +24,15 @@
 #include <linux/slab.h>
 #include <linux/proc_fs.h>

-/**
- * struct alias_prop - Alias property in 'aliases' node
- * @link:	List node to link the structure in aliases_lookup list
- * @alias:	Alias property name
- * @np:		Pointer to device_node that the alias stands for
- * @id:		Index value from end of alias name
- * @stem:	Alias string without the index
- *
- * The structure represents one alias property of 'aliases' node as
- * an entry in aliases_lookup list.
- */
-struct alias_prop {
-	struct list_head link;
-	const char *alias;
-	struct device_node *np;
-	int id;
-	char stem[0];
-};
+#include "of_private.h"

-static LIST_HEAD(aliases_lookup);
+LIST_HEAD(aliases_lookup);

 struct device_node *allnodes;
 struct device_node *of_chosen;
 struct device_node *of_aliases;

-static DEFINE_MUTEX(of_aliases_mutex);
+DEFINE_MUTEX(of_aliases_mutex);

 /* use when traversing tree through the allnext, child, sibling,
  * or parent members of struct device_node.
diff --git a/drivers/of/device.c b/drivers/of/device.c
index 4c74e4f..b8d31db 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>

 #include <asm/errno.h>
+#include "of_private.h"

 /**
  * of_match_device - Tell if a struct device matches an of_device_id list
@@ -131,6 +132,7 @@ ssize_t of_device_get_modalias(struct device *dev, char *str, ssize_t len)
 void of_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	const char *compat;
+	struct alias_prop *app;
 	int seen = 0, cplen, sl;

 	if ((!dev) || (!dev->of_node))
@@ -153,6 +155,21 @@ void of_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 		seen++;
 	}
 	add_uevent_var(env, "OF_COMPATIBLE_N=%d", seen);
+
+	seen = 0;
+	mutex_lock(&of_aliases_mutex);
+	list_for_each_entry(app, &aliases_lookup, link) {
+		if (dev->of_node == app->np) {
+			add_uevent_var(env, "OF_ALIAS_%d=%s", seen,
+				       app->alias);
+			seen++;
+		}
+	}
+
+	if (seen)
+		add_uevent_var(env, "OF_ALIAS_N=%d", seen);
+
+	mutex_unlock(&of_aliases_mutex);
 }

 int of_device_uevent_modalias(struct device *dev, struct kobj_uevent_env *env)
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
new file mode 100644
index 0000000..031608f
--- /dev/null
+++ b/drivers/of/of_private.h
@@ -0,0 +1,33 @@
+/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/**
+ * struct alias_prop - Alias property in 'aliases' node
+ * @link:	List node to link the structure in aliases_lookup list
+ * @alias:	Alias property name
+ * @np:		Pointer to device_node that the alias stands for
+ * @id:		Index value from end of alias name
+ * @stem:	Alias string without the index
+ *
+ * The structure represents one alias property of 'aliases' node as
+ * an entry in aliases_lookup list.
+ */
+struct alias_prop {
+	struct list_head link;
+	const char *alias;
+	struct device_node *np;
+	int id;
+	char stem[0];
+};
+
+extern struct mutex of_aliases_mutex;
+extern struct list_head aliases_lookup;
--
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

