Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0HIDKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 23:10:37 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:45683 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab0HIDKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 23:10:35 -0400
Date: Sun, 8 Aug 2010 23:10:30 -0400
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] sparc: break out some PROM device-tree building code
 out into drivers/of
Message-ID: <20100808231030.1d555250@dev.queued.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Transitioning into making this useful for architectures other than sparc.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/sparc/kernel/prom_common.c |  190 +----------------------------------
 drivers/of/pdt.c                |  217 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 218 insertions(+), 189 deletions(-)
 create mode 100644 drivers/of/pdt.c

diff --git a/arch/sparc/kernel/prom_common.c b/arch/sparc/kernel/prom_common.c
index 40123a6..7b454f6 100644
--- a/arch/sparc/kernel/prom_common.c
+++ b/arch/sparc/kernel/prom_common.c
@@ -26,8 +26,6 @@
 
 #include "prom.h"
 
-void (*prom_build_more)(struct device_node *dp, struct device_node ***nextp);
-
 struct device_node *of_console_device;
 EXPORT_SYMBOL(of_console_device);
 
@@ -119,192 +117,6 @@ int of_find_in_proplist(const char *list, const char *match, int len)
 }
 EXPORT_SYMBOL(of_find_in_proplist);
 
-unsigned int prom_unique_id;
-
-static struct property * __init build_one_prop(phandle node, char *prev,
-					       char *special_name,
-					       void *special_val,
-					       int special_len)
-{
-	static struct property *tmp = NULL;
-	struct property *p;
-	const char *name;
-
-	if (tmp) {
-		p = tmp;
-		memset(p, 0, sizeof(*p) + 32);
-		tmp = NULL;
-	} else {
-		p = prom_early_alloc(sizeof(struct property) + 32);
-		p->unique_id = prom_unique_id++;
-	}
-
-	p->name = (char *) (p + 1);
-	if (special_name) {
-		strcpy(p->name, special_name);
-		p->length = special_len;
-		p->value = prom_early_alloc(special_len);
-		memcpy(p->value, special_val, special_len);
-	} else {
-		if (prev == NULL) {
-			name = prom_firstprop(node, p->name);
-		} else {
-			name = prom_nextprop(node, prev, p->name);
-		}
-
-		if (!name || strlen(name) == 0) {
-			tmp = p;
-			return NULL;
-		}
-#ifdef CONFIG_SPARC32
-		strcpy(p->name, name);
-#endif
-		p->length = prom_getproplen(node, p->name);
-		if (p->length <= 0) {
-			p->length = 0;
-		} else {
-			int len;
-
-			p->value = prom_early_alloc(p->length + 1);
-			len = prom_getproperty(node, p->name, p->value,
-					       p->length);
-			if (len <= 0)
-				p->length = 0;
-			((unsigned char *)p->value)[p->length] = '\0';
-		}
-	}
-	return p;
-}
-
-static struct property * __init build_prop_list(phandle node)
-{
-	struct property *head, *tail;
-
-	head = tail = build_one_prop(node, NULL,
-				     ".node", &node, sizeof(node));
-
-	tail->next = build_one_prop(node, NULL, NULL, NULL, 0);
-	tail = tail->next;
-	while(tail) {
-		tail->next = build_one_prop(node, tail->name,
-					    NULL, NULL, 0);
-		tail = tail->next;
-	}
-
-	return head;
-}
-
-static char * __init get_one_property(phandle node, const char *name)
-{
-	char *buf = "<NULL>";
-	int len;
-
-	len = prom_getproplen(node, name);
-	if (len > 0) {
-		buf = prom_early_alloc(len);
-		len = prom_getproperty(node, name, buf, len);
-	}
-
-	return buf;
-}
-
-static struct device_node * __init prom_create_node(phandle node,
-						    struct device_node *parent)
-{
-	struct device_node *dp;
-
-	if (!node)
-		return NULL;
-
-	dp = prom_early_alloc(sizeof(*dp));
-	dp->unique_id = prom_unique_id++;
-	dp->parent = parent;
-
-	kref_init(&dp->kref);
-
-	dp->name = get_one_property(node, "name");
-	dp->type = get_one_property(node, "device_type");
-	dp->phandle = node;
-
-	dp->properties = build_prop_list(node);
-
-	irq_trans_init(dp);
-
-	return dp;
-}
-
-char * __init build_full_name(struct device_node *dp)
-{
-	int len, ourlen, plen;
-	char *n;
-
-	plen = strlen(dp->parent->full_name);
-	ourlen = strlen(dp->path_component_name);
-	len = ourlen + plen + 2;
-
-	n = prom_early_alloc(len);
-	strcpy(n, dp->parent->full_name);
-	if (!of_is_root_node(dp->parent)) {
-		strcpy(n + plen, "/");
-		plen++;
-	}
-	strcpy(n + plen, dp->path_component_name);
-
-	return n;
-}
-
-static struct device_node * __init prom_build_tree(struct device_node *parent,
-						   phandle node,
-						   struct device_node ***nextp)
-{
-	struct device_node *ret = NULL, *prev_sibling = NULL;
-	struct device_node *dp;
-
-	while (1) {
-		dp = prom_create_node(node, parent);
-		if (!dp)
-			break;
-
-		if (prev_sibling)
-			prev_sibling->sibling = dp;
-
-		if (!ret)
-			ret = dp;
-		prev_sibling = dp;
-
-		*(*nextp) = dp;
-		*nextp = &dp->allnext;
-
-		dp->path_component_name = build_path_component(dp);
-		dp->full_name = build_full_name(dp);
-
-		dp->child = prom_build_tree(dp, prom_getchild(node), nextp);
-
-		if (prom_build_more)
-			prom_build_more(dp, nextp);
-
-		node = prom_getsibling(node);
-	}
-
-	return ret;
-}
-
 unsigned int prom_early_allocated __initdata;
 
-void __init prom_build_devicetree(void)
-{
-	struct device_node **nextp;
-
-	allnodes = prom_create_node(prom_root_node, NULL);
-	allnodes->path_component_name = "";
-	allnodes->full_name = "/";
-
-	nextp = &allnodes->allnext;
-	allnodes->child = prom_build_tree(allnodes,
-					  prom_getchild(allnodes->phandle),
-					  &nextp);
-	of_console_init();
-
-	printk("PROM: Built device tree with %u bytes of memory.\n",
-	       prom_early_allocated);
-}
+#include "../../../drivers/of/pdt.c"
diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
new file mode 100644
index 0000000..61d9477
--- /dev/null
+++ b/drivers/of/pdt.c
@@ -0,0 +1,217 @@
+/* prom_common.c: OF device tree support common code.
+ *
+ * Paul Mackerras	August 1996.
+ * Copyright (C) 1996-2005 Paul Mackerras.
+ *
+ *  Adapted for 64bit PowerPC by Dave Engebretsen and Peter Bergner.
+ *    {engebret|bergner}@us.ibm.com
+ *
+ *  Adapted for sparc by David S. Miller davem@davemloft.net
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <asm/prom.h>
+#include <asm/oplib.h>
+#include <asm/leon.h>
+
+void (*prom_build_more)(struct device_node *dp, struct device_node ***nextp);
+
+unsigned int prom_unique_id;
+
+static struct property * __init build_one_prop(phandle node, char *prev,
+					       char *special_name,
+					       void *special_val,
+					       int special_len)
+{
+	static struct property *tmp = NULL;
+	struct property *p;
+	const char *name;
+
+	if (tmp) {
+		p = tmp;
+		memset(p, 0, sizeof(*p) + 32);
+		tmp = NULL;
+	} else {
+		p = prom_early_alloc(sizeof(struct property) + 32);
+		p->unique_id = prom_unique_id++;
+	}
+
+	p->name = (char *) (p + 1);
+	if (special_name) {
+		strcpy(p->name, special_name);
+		p->length = special_len;
+		p->value = prom_early_alloc(special_len);
+		memcpy(p->value, special_val, special_len);
+	} else {
+		if (prev == NULL) {
+			name = prom_firstprop(node, p->name);
+		} else {
+			name = prom_nextprop(node, prev, p->name);
+		}
+
+		if (!name || strlen(name) == 0) {
+			tmp = p;
+			return NULL;
+		}
+#ifdef CONFIG_SPARC32
+		strcpy(p->name, name);
+#endif
+		p->length = prom_getproplen(node, p->name);
+		if (p->length <= 0) {
+			p->length = 0;
+		} else {
+			int len;
+
+			p->value = prom_early_alloc(p->length + 1);
+			len = prom_getproperty(node, p->name, p->value,
+					       p->length);
+			if (len <= 0)
+				p->length = 0;
+			((unsigned char *)p->value)[p->length] = '\0';
+		}
+	}
+	return p;
+}
+
+static struct property * __init build_prop_list(phandle node)
+{
+	struct property *head, *tail;
+
+	head = tail = build_one_prop(node, NULL,
+				     ".node", &node, sizeof(node));
+
+	tail->next = build_one_prop(node, NULL, NULL, NULL, 0);
+	tail = tail->next;
+	while(tail) {
+		tail->next = build_one_prop(node, tail->name,
+					    NULL, NULL, 0);
+		tail = tail->next;
+	}
+
+	return head;
+}
+
+static char * __init get_one_property(phandle node, const char *name)
+{
+	char *buf = "<NULL>";
+	int len;
+
+	len = prom_getproplen(node, name);
+	if (len > 0) {
+		buf = prom_early_alloc(len);
+		len = prom_getproperty(node, name, buf, len);
+	}
+
+	return buf;
+}
+
+static struct device_node * __init prom_create_node(phandle node,
+						    struct device_node *parent)
+{
+	struct device_node *dp;
+
+	if (!node)
+		return NULL;
+
+	dp = prom_early_alloc(sizeof(*dp));
+	dp->unique_id = prom_unique_id++;
+	dp->parent = parent;
+
+	kref_init(&dp->kref);
+
+	dp->name = get_one_property(node, "name");
+	dp->type = get_one_property(node, "device_type");
+	dp->phandle = node;
+
+	dp->properties = build_prop_list(node);
+
+	irq_trans_init(dp);
+
+	return dp;
+}
+
+char * __init build_full_name(struct device_node *dp)
+{
+	int len, ourlen, plen;
+	char *n;
+
+	plen = strlen(dp->parent->full_name);
+	ourlen = strlen(dp->path_component_name);
+	len = ourlen + plen + 2;
+
+	n = prom_early_alloc(len);
+	strcpy(n, dp->parent->full_name);
+	if (!of_is_root_node(dp->parent)) {
+		strcpy(n + plen, "/");
+		plen++;
+	}
+	strcpy(n + plen, dp->path_component_name);
+
+	return n;
+}
+
+static struct device_node * __init prom_build_tree(struct device_node *parent,
+						   phandle node,
+						   struct device_node ***nextp)
+{
+	struct device_node *ret = NULL, *prev_sibling = NULL;
+	struct device_node *dp;
+
+	while (1) {
+		dp = prom_create_node(node, parent);
+		if (!dp)
+			break;
+
+		if (prev_sibling)
+			prev_sibling->sibling = dp;
+
+		if (!ret)
+			ret = dp;
+		prev_sibling = dp;
+
+		*(*nextp) = dp;
+		*nextp = &dp->allnext;
+
+		dp->path_component_name = build_path_component(dp);
+		dp->full_name = build_full_name(dp);
+
+		dp->child = prom_build_tree(dp, prom_getchild(node), nextp);
+
+		if (prom_build_more)
+			prom_build_more(dp, nextp);
+
+		node = prom_getsibling(node);
+	}
+
+	return ret;
+}
+
+void __init prom_build_devicetree(void)
+{
+	struct device_node **nextp;
+
+	allnodes = prom_create_node(prom_root_node, NULL);
+	allnodes->path_component_name = "";
+	allnodes->full_name = "/";
+
+	nextp = &allnodes->allnext;
+	allnodes->child = prom_build_tree(allnodes,
+			prom_getchild(allnodes->phandle),
+			&nextp);
+
+	of_console_init();
+
+	printk("PROM: Built device tree with %u bytes of memory.\n",
+	       prom_early_allocated);
+}
+
-- 
1.5.6.5

