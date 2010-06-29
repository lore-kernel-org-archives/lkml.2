Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab0F2CAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 22:00:45 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:59780 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab0F2CAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 22:00:41 -0400
Date: Mon, 28 Jun 2010 22:00:37 -0400
From: Andres Salomon <dilinger@queued.net>
To: devicetree-discuss@lists.ozlabs.org
Cc: sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, cjb@laptop.org,
       Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       grant.likely@secretlab.ca
Subject: [PATCH 2/4] sparc: break out some prom device-tree building code
 out into drivers/of
Message-ID: <20100628220037.5744c207@debian>
In-Reply-To: <20100628215407.2017bf2f@debian>
References: <20100628215407.2017bf2f@debian>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stick code into drivers/of/pdt.c (Prom Device Tree) that other
architectures with OpenFirmware resident in memory can make use of.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/sparc/Kconfig              |    1 +
 arch/sparc/include/asm/prom.h   |   15 +++-
 arch/sparc/kernel/prom.h        |   14 ---
 arch/sparc/kernel/prom_common.c |  173 +------------------------------
 drivers/of/Kconfig              |    4 +
 drivers/of/Makefile             |    1 +
 drivers/of/pdt.c                |  225 +++++++++++++++++++++++++++++++++++++++
 include/linux/of_pdt.h          |   37 +++++++
 8 files changed, 282 insertions(+), 188 deletions(-)
 create mode 100644 drivers/of/pdt.c
 create mode 100644 include/linux/of_pdt.h

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 6f1470b..b4cb63b 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -150,6 +150,7 @@ config ARCH_NO_VIRT_TO_BUS
 
 config OF
 	def_bool y
+	select OF_PROMTREE
 
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y if SPARC64
diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index f845828..0834c2a 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -18,6 +18,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 #include <linux/types.h>
+#include <linux/of_pdt.h>
 #include <linux/proc_fs.h>
 #include <linux/mutex.h>
 #include <asm/atomic.h>
@@ -65,8 +66,18 @@ extern struct device_node *of_console_device;
 extern char *of_console_path;
 extern char *of_console_options;
 
-extern void (*prom_build_more)(struct device_node *dp, struct device_node ***nextp);
-extern char *build_full_name(struct device_node *dp);
+/* stuff used by of/pdt */
+extern void * prom_early_alloc(unsigned long size);
+extern void irq_trans_init(struct device_node *dp);
+extern char *build_path_component(struct device_node *dp);
+
+extern char *prom_firstprop(int node, char *buffer);
+extern char *prom_nextprop(int node, const char *oprop, char *buffer);
+extern int prom_getproplen(int node, const char *prop);
+extern int prom_getproperty(int node, const char *prop,
+			    char *buffer, int bufsize);
+extern int prom_getchild(int node);
+extern int prom_getsibling(int node);
 
 #endif /* __KERNEL__ */
 #endif /* _SPARC_PROM_H */
diff --git a/arch/sparc/kernel/prom.h b/arch/sparc/kernel/prom.h
index a8591ef..cf5fe1c 100644
--- a/arch/sparc/kernel/prom.h
+++ b/arch/sparc/kernel/prom.h
@@ -4,20 +4,6 @@
 #include <linux/spinlock.h>
 #include <asm/prom.h>
 
-extern void * prom_early_alloc(unsigned long size);
-extern void irq_trans_init(struct device_node *dp);
-
-extern unsigned int prom_unique_id;
-
-static inline int is_root_node(const struct device_node *dp)
-{
-	if (!dp)
-		return 0;
-
-	return (dp->parent == NULL);
-}
-
-extern char *build_path_component(struct device_node *dp);
 extern void of_console_init(void);
 
 extern unsigned int prom_early_allocated;
diff --git a/arch/sparc/kernel/prom_common.c b/arch/sparc/kernel/prom_common.c
index 57ac9e2..fc990e1 100644
--- a/arch/sparc/kernel/prom_common.c
+++ b/arch/sparc/kernel/prom_common.c
@@ -20,14 +20,13 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/of_pdt.h>
 #include <asm/prom.h>
 #include <asm/oplib.h>
 #include <asm/leon.h>
 
 #include "prom.h"
 
-void (*prom_build_more)(struct device_node *dp, struct device_node ***nextp);
-
 struct device_node *of_console_device;
 EXPORT_SYMBOL(of_console_device);
 
@@ -119,176 +118,6 @@ int of_find_in_proplist(const char *list, const char *match, int len)
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
-	if (!is_root_node(dp->parent)) {
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
 
 void __init prom_build_devicetree(void)
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 7cecc8f..41921a8 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -2,6 +2,10 @@ config OF_FLATTREE
 	bool
 	depends on OF
 
+config OF_PROMTREE
+	bool
+	depends on OF
+
 config OF_DYNAMIC
 	def_bool y
 	depends on OF && PPC_OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index f232cc9..54e8517 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -1,5 +1,6 @@
 obj-y = base.o
 obj-$(CONFIG_OF_FLATTREE) += fdt.o
+obj-$(CONFIG_OF_PROMTREE) += pdt.o
 obj-$(CONFIG_OF_DEVICE) += device.o platform.o
 obj-$(CONFIG_OF_GPIO)   += gpio.o
 obj-$(CONFIG_OF_I2C)	+= of_i2c.o
diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
new file mode 100644
index 0000000..b24167f
--- /dev/null
+++ b/drivers/of/pdt.c
@@ -0,0 +1,225 @@
+/*
+ * Paul Mackerras	August 1996.
+ * Copyright (C) 1996-2005 Paul Mackerras.
+ *
+ *  Adapted for 64bit PowerPC by Dave Engebretsen and Peter Bergner.
+ *    {engebret|bergner}@us.ibm.com
+ *
+ *  Adapted for sparc by David S. Miller davem@davemloft.net
+ *  Adapted for multiple architectures by Andres Salomon <dilinger@queued.net>
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
+#include <linux/of_pdt.h>
+#include <asm/prom.h>
+
+/* TODO: mark this stuff as __initdata */
+void (*prom_build_more)(struct device_node *dp, struct device_node ***nextp);
+
+#if defined(CONFIG_SPARC)
+static unsigned int prom_unique_id;
+
+#define inc_unique_id(p) do { \
+	(p)->unique_id = prom_unique_id++; \
+} while (0)
+
+static inline const char *fetch_node_name(struct device_node *dp)
+{
+	return dp->path_component_name;
+}
+
+#else
+
+#define inc_unique_id(p)	do { } while(0)
+
+static inline const char *fetch_node_name(struct device_node *dp)
+{
+	return dp->name;
+}
+
+static inline void irq_trans_init(struct device_node *dp)
+{
+	/* unused on non-SPARC architectures */
+}
+
+#endif /* !CONFIG_SPARC */
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
+		inc_unique_id(p);
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
+struct device_node * __init prom_create_node(phandle node,
+					     struct device_node *parent)
+{
+	struct device_node *dp;
+
+	if (!node)
+		return NULL;
+
+	dp = prom_early_alloc(sizeof(*dp));
+	inc_unique_id(dp);
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
+static char * __init build_full_name(struct device_node *dp)
+{
+	int len, ourlen, plen;
+	char *n;
+
+	plen = strlen(dp->parent->full_name);
+	ourlen = strlen(fetch_node_name(dp));
+	len = ourlen + plen + 2;
+
+	n = prom_early_alloc(len);
+	strcpy(n, dp->parent->full_name);
+	if (!is_root_node(dp->parent)) {
+		strcpy(n + plen, "/");
+		plen++;
+	}
+	strcpy(n + plen, fetch_node_name(dp));
+
+	return n;
+}
+
+struct device_node * __init prom_build_tree(struct device_node *parent,
+					    phandle node,
+					    struct device_node ***nextp)
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
+#if defined(CONFIG_SPARC)
+		dp->path_component_name = build_path_component(dp);
+#endif
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
diff --git a/include/linux/of_pdt.h b/include/linux/of_pdt.h
new file mode 100644
index 0000000..f62616e
--- /dev/null
+++ b/include/linux/of_pdt.h
@@ -0,0 +1,37 @@
+#include <linux/of.h>	/* linux/of.h gets to determine #include ordering */
+/*
+ * Definitions for building a device tree by calling into the
+ * Open Firmware PROM.
+ *
+ * Copyright (C) 1996-2005 Paul Mackerras.
+ * Copyright (C) 2010  Andres Salomon <dilinger@queued.net>
+ *
+ * Updates for PPC64 by Peter Bergner & David Engebretsen, IBM Corp.
+ * Updates for SPARC by David S. Miller
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_OF_PDT_H
+#define _LINUX_OF_PDT_H
+
+extern struct device_node *prom_create_node(phandle node,
+					    struct device_node *parent);
+extern struct device_node *prom_build_tree(struct device_node *parent,
+					   phandle node,
+					   struct device_node ***nextp);
+
+extern void (*prom_build_more)(struct device_node *dp, struct device_node ***nextp);
+
+static inline int is_root_node(const struct device_node *dp)
+{
+	if (!dp)
+		return 0;
+
+	return (dp->parent == NULL);
+}
+
+#endif /* _LINUX_OF_PDT_H */
-- 
1.5.6.5

