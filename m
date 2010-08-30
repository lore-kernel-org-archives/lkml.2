Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0H3D6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 23:58:53 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:49345 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618Ab0H3D6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 23:58:51 -0400
Date: Mon, 30 Aug 2010 00:00:40 -0400
From: Andres Salomon <dilinger@queued.net>
To: devicetree-discuss@lists.ozlabs.org
Cc: sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, cjb@laptop.org,
        Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        grant.likely@secretlab.ca,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: [PATCH 5/9] of: no longer call prom_ functions directly; use an ops
 structure
Message-ID: <20100830000040.6390b7ad@debxo>
In-Reply-To: <20100829235100.6dcedcb8@debxo>
References: <20100628215407.2017bf2f@debian>
	<20100829235100.6dcedcb8@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rather than assuming an architecture defines prom_getchild and friends,
define an ops struct with hooks for the various prom functions that
pdt.c needs.  This ops struct is filled in by the
arch-(and sometimes firmware-)specific code, and passed to
of_pdt_build_devicetree.

Update sparc code to define the ops struct as well.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/sparc/kernel/prom_common.c |   37 ++++++++++++++++++++++++++++++++++++-
 drivers/of/pdt.c                |   39 ++++++++++++++++++---------------------
 include/linux/of_pdt.h          |   20 +++++++++++++++++++-
 3 files changed, 73 insertions(+), 23 deletions(-)

diff --git a/arch/sparc/kernel/prom_common.c b/arch/sparc/kernel/prom_common.c
index fe84d56..0972b39 100644
--- a/arch/sparc/kernel/prom_common.c
+++ b/arch/sparc/kernel/prom_common.c
@@ -118,11 +118,46 @@ int of_find_in_proplist(const char *list, const char *match, int len)
 }
 EXPORT_SYMBOL(of_find_in_proplist);
 
+/*
+ * SPARC32 and SPARC64's prom_nextprop() do things differently
+ * here, despite sharing the same interface.  SPARC32 doesn't fill in 'buf',
+ * returning NULL on an error.  SPARC64 fills in 'buf', but sets it to an
+ * empty string upon error.
+ */
+static int __init handle_nextprop_quirks(char *buf, const char *name)
+{
+	if (!name || strlen(name) == 0)
+		return -1;
+
+#ifdef CONFIG_SPARC32
+	strcpy(buf, name);
+#endif
+	return 0;
+}
+
+static int __init prom_common_nextprop(phandle node, const char *prev,
+		char *buf)
+{
+	const char *name;
+
+	buf[0] = '\0';
+	name = prom_nextprop(node, prev, buf);
+	return handle_nextprop_quirks(buf, name);
+}
+
 unsigned int prom_early_allocated __initdata;
 
+static struct of_pdt_ops prom_sparc_ops __initdata = {
+	.nextprop = prom_common_nextprop,
+	.getproplen = prom_getproplen,
+	.getproperty = prom_getproperty,
+	.getchild = prom_getchild,
+	.getsibling = prom_getsibling,
+};
+
 void __init prom_build_devicetree(void)
 {
-	of_pdt_build_devicetree(prom_root_node);
+	of_pdt_build_devicetree(prom_root_node, &prom_sparc_ops);
 	of_console_init();
 
 	pr_info("PROM: Built device tree with %u bytes of memory.\n",
diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index f0872b6..fd02fc1 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -24,6 +24,8 @@
 #include <linux/of_pdt.h>
 #include <asm/prom.h>
 
+static struct of_pdt_ops *of_pdt_prom_ops __initdata;
+
 void __initdata (*prom_build_more)(struct device_node *dp,
 		struct device_node ***nextp);
 
@@ -58,7 +60,7 @@ static struct property * __init build_one_prop(phandle node, char *prev,
 {
 	static struct property *tmp = NULL;
 	struct property *p;
-	const char *name;
+	int err;
 
 	if (tmp) {
 		p = tmp;
@@ -76,28 +78,20 @@ static struct property * __init build_one_prop(phandle node, char *prev,
 		p->value = prom_early_alloc(special_len);
 		memcpy(p->value, special_val, special_len);
 	} else {
-		if (prev == NULL) {
-			name = prom_firstprop(node, p->name);
-		} else {
-			name = prom_nextprop(node, prev, p->name);
-		}
-
-		if (!name || strlen(name) == 0) {
+		err = of_pdt_prom_ops->nextprop(node, prev, p->name);
+		if (err) {
 			tmp = p;
 			return NULL;
 		}
-#ifdef CONFIG_SPARC32
-		strcpy(p->name, name);
-#endif
-		p->length = prom_getproplen(node, p->name);
+		p->length = of_pdt_prom_ops->getproplen(node, p->name);
 		if (p->length <= 0) {
 			p->length = 0;
 		} else {
 			int len;
 
 			p->value = prom_early_alloc(p->length + 1);
-			len = prom_getproperty(node, p->name, p->value,
-					       p->length);
+			len = of_pdt_prom_ops->getproperty(node, p->name,
+					p->value, p->length);
 			if (len <= 0)
 				p->length = 0;
 			((unsigned char *)p->value)[p->length] = '\0';
@@ -129,10 +123,10 @@ static char * __init get_one_property(phandle node, const char *name)
 	char *buf = "<NULL>";
 	int len;
 
-	len = prom_getproplen(node, name);
+	len = of_pdt_prom_ops->getproplen(node, name);
 	if (len > 0) {
 		buf = prom_early_alloc(len);
-		len = prom_getproperty(node, name, buf, len);
+		len = of_pdt_prom_ops->getproperty(node, name, buf, len);
 	}
 
 	return buf;
@@ -210,21 +204,25 @@ static struct device_node * __init prom_build_tree(struct device_node *parent,
 #endif
 		dp->full_name = build_full_name(dp);
 
-		dp->child = prom_build_tree(dp, prom_getchild(node), nextp);
+		dp->child = prom_build_tree(dp,
+				of_pdt_prom_ops->getchild(node), nextp);
 
 		if (prom_build_more)
 			prom_build_more(dp, nextp);
 
-		node = prom_getsibling(node);
+		node = of_pdt_prom_ops->getsibling(node);
 	}
 
 	return ret;
 }
 
-void __init of_pdt_build_devicetree(phandle root_node)
+void __init of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops)
 {
 	struct device_node **nextp;
 
+	BUG_ON(!ops);
+	of_pdt_prom_ops = ops;
+
 	allnodes = prom_create_node(root_node, NULL);
 #if defined(CONFIG_SPARC)
 	allnodes->path_component_name = "";
@@ -233,6 +231,5 @@ void __init of_pdt_build_devicetree(phandle root_node)
 
 	nextp = &allnodes->allnext;
 	allnodes->child = prom_build_tree(allnodes,
-					  prom_getchild(allnodes->phandle),
-					  &nextp);
+			of_pdt_prom_ops->getchild(allnodes->phandle), &nextp);
 }
diff --git a/include/linux/of_pdt.h b/include/linux/of_pdt.h
index c0a8774..7acabff 100644
--- a/include/linux/of_pdt.h
+++ b/include/linux/of_pdt.h
@@ -13,10 +13,28 @@
 #ifndef _LINUX_OF_PDT_H
 #define _LINUX_OF_PDT_H
 
+/* overridable operations for calling into the PROM */
+struct of_pdt_ops {
+	/*
+	 * buf should be 32 bytes; return 0 on success.
+	 * If prev is NULL, the first property will be returned.
+	 */
+	int (*nextprop)(phandle node, const char *prev, char *buf);
+
+	/* for both functions, return proplen on success; -1 on error */
+	int (*getproplen)(phandle node, const char *prop);
+	int (*getproperty)(phandle node, const char *prop, char *buf,
+			int bufsize);
+
+	/* phandles are 0 if no child or sibling exists */
+	phandle (*getchild)(phandle parent);
+	phandle (*getsibling)(phandle node);
+};
+
 extern void *prom_early_alloc(unsigned long size);
 
 /* for building the device tree */
-extern void of_pdt_build_devicetree(phandle root_node);
+extern void of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops);
 
 extern void (*prom_build_more)(struct device_node *dp,
 		struct device_node ***nextp);
-- 
1.5.6.5

