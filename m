Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0H3D5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 23:57:25 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:49331 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618Ab0H3D5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 23:57:24 -0400
Date: Sun, 29 Aug 2010 23:59:13 -0400
From: Andres Salomon <dilinger@queued.net>
To: devicetree-discuss@lists.ozlabs.org
Cc: sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, cjb@laptop.org,
        Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        grant.likely@secretlab.ca,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: [PATCH 4/9] sparc: make drivers/of/pdt.c no longer sparc-only
Message-ID: <20100829235913.30df023c@debxo>
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


Clean up pdt.c:
 - make build dependent upon config OF_PROMTREE
 - #ifdef out the sparc-specific stuff
 - create pdt-specific header

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/sparc/Kconfig              |    1 +
 arch/sparc/include/asm/prom.h   |    5 ++-
 arch/sparc/kernel/prom.h        |    6 ----
 arch/sparc/kernel/prom_common.c |   10 ++++++-
 drivers/of/Kconfig              |    5 +++-
 drivers/of/Makefile             |    1 +
 drivers/of/pdt.c                |   55 +++++++++++++++++++++++++++-----------
 include/linux/of_pdt.h          |   24 +++++++++++++++++
 8 files changed, 81 insertions(+), 26 deletions(-)
 create mode 100644 include/linux/of_pdt.h

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 491e9d6..a06c959 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -19,6 +19,7 @@ config SPARC
 	bool
 	default y
 	select OF
+	select OF_PROMTREE
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB if !SMP || SPARC64
diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index 291f125..56bbaad 100644
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
@@ -67,8 +68,8 @@ extern struct device_node *of_console_device;
 extern char *of_console_path;
 extern char *of_console_options;
 
-extern void (*prom_build_more)(struct device_node *dp, struct device_node ***nextp);
-extern char *build_full_name(struct device_node *dp);
+extern void irq_trans_init(struct device_node *dp);
+extern char *build_path_component(struct device_node *dp);
 
 #endif /* __KERNEL__ */
 #endif /* _SPARC_PROM_H */
diff --git a/arch/sparc/kernel/prom.h b/arch/sparc/kernel/prom.h
index eeb04a7..cf5fe1c 100644
--- a/arch/sparc/kernel/prom.h
+++ b/arch/sparc/kernel/prom.h
@@ -4,12 +4,6 @@
 #include <linux/spinlock.h>
 #include <asm/prom.h>
 
-extern void * prom_early_alloc(unsigned long size);
-extern void irq_trans_init(struct device_node *dp);
-
-extern unsigned int prom_unique_id;
-
-extern char *build_path_component(struct device_node *dp);
 extern void of_console_init(void);
 
 extern unsigned int prom_early_allocated;
diff --git a/arch/sparc/kernel/prom_common.c b/arch/sparc/kernel/prom_common.c
index 7b454f6..fe84d56 100644
--- a/arch/sparc/kernel/prom_common.c
+++ b/arch/sparc/kernel/prom_common.c
@@ -20,6 +20,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/of_pdt.h>
 #include <asm/prom.h>
 #include <asm/oplib.h>
 #include <asm/leon.h>
@@ -119,4 +120,11 @@ EXPORT_SYMBOL(of_find_in_proplist);
 
 unsigned int prom_early_allocated __initdata;
 
-#include "../../../drivers/of/pdt.c"
+void __init prom_build_devicetree(void)
+{
+	of_pdt_build_devicetree(prom_root_node);
+	of_console_init();
+
+	pr_info("PROM: Built device tree with %u bytes of memory.\n",
+			prom_early_allocated);
+}
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 6acbff3..aa675eb 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -4,7 +4,7 @@ config DTC
 config OF
 	bool
 
-menu "Flattened Device Tree and Open Firmware support"
+menu "Device Tree and Open Firmware support"
 	depends on OF
 
 config PROC_DEVICETREE
@@ -19,6 +19,9 @@ config OF_FLATTREE
 	bool
 	select DTC
 
+config OF_PROMTREE
+	bool
+
 config OF_DYNAMIC
 	def_bool y
 	depends on PPC_OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index 0052c40..7888155 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -1,5 +1,6 @@
 obj-y = base.o
 obj-$(CONFIG_OF_FLATTREE) += fdt.o
+obj-$(CONFIG_OF_PROMTREE) += pdt.o
 obj-$(CONFIG_OF_ADDRESS)  += address.o
 obj-$(CONFIG_OF_IRQ)    += irq.o
 obj-$(CONFIG_OF_DEVICE) += device.o platform.o
diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index c3c2d70..f0872b6 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -1,4 +1,4 @@
-/* prom_common.c: OF device tree support common code.
+/* pdt.c: OF PROM device tree support code.
  *
  * Paul Mackerras	August 1996.
  * Copyright (C) 1996-2005 Paul Mackerras.
@@ -7,6 +7,7 @@
  *    {engebret|bergner}@us.ibm.com
  *
  *  Adapted for sparc by David S. Miller davem@davemloft.net
+ *  Adapted for multiple architectures by Andres Salomon <dilinger@queued.net>
  *
  *      This program is free software; you can redistribute it and/or
  *      modify it under the terms of the GNU General Public License
@@ -20,13 +21,35 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/of_pdt.h>
 #include <asm/prom.h>
-#include <asm/oplib.h>
-#include <asm/leon.h>
 
-void (*prom_build_more)(struct device_node *dp, struct device_node ***nextp);
+void __initdata (*prom_build_more)(struct device_node *dp,
+		struct device_node ***nextp);
 
-unsigned int prom_unique_id;
+#if defined(CONFIG_SPARC)
+unsigned int of_pdt_unique_id __initdata;
+
+#define of_pdt_incr_unique_id(p) do { \
+	(p)->unique_id = of_pdt_unique_id++; \
+} while (0)
+
+static inline const char *of_pdt_node_name(struct device_node *dp)
+{
+	return dp->path_component_name;
+}
+
+#else
+
+static inline void of_pdt_incr_unique_id(void *p) { }
+static inline void irq_trans_init(struct device_node *dp) { }
+
+static inline const char *of_pdt_node_name(struct device_node *dp)
+{
+	return dp->name;
+}
+
+#endif /* !CONFIG_SPARC */
 
 static struct property * __init build_one_prop(phandle node, char *prev,
 					       char *special_name,
@@ -43,7 +66,7 @@ static struct property * __init build_one_prop(phandle node, char *prev,
 		tmp = NULL;
 	} else {
 		p = prom_early_alloc(sizeof(struct property) + 32);
-		p->unique_id = prom_unique_id++;
+		of_pdt_incr_unique_id(p);
 	}
 
 	p->name = (char *) (p + 1);
@@ -124,7 +147,7 @@ static struct device_node * __init prom_create_node(phandle node,
 		return NULL;
 
 	dp = prom_early_alloc(sizeof(*dp));
-	dp->unique_id = prom_unique_id++;
+	of_pdt_incr_unique_id(dp);
 	dp->parent = parent;
 
 	kref_init(&dp->kref);
@@ -140,13 +163,13 @@ static struct device_node * __init prom_create_node(phandle node,
 	return dp;
 }
 
-char * __init build_full_name(struct device_node *dp)
+static char * __init build_full_name(struct device_node *dp)
 {
 	int len, ourlen, plen;
 	char *n;
 
 	plen = strlen(dp->parent->full_name);
-	ourlen = strlen(dp->path_component_name);
+	ourlen = strlen(of_pdt_node_name(dp));
 	len = ourlen + plen + 2;
 
 	n = prom_early_alloc(len);
@@ -155,7 +178,7 @@ char * __init build_full_name(struct device_node *dp)
 		strcpy(n + plen, "/");
 		plen++;
 	}
-	strcpy(n + plen, dp->path_component_name);
+	strcpy(n + plen, of_pdt_node_name(dp));
 
 	return n;
 }
@@ -182,7 +205,9 @@ static struct device_node * __init prom_build_tree(struct device_node *parent,
 		*(*nextp) = dp;
 		*nextp = &dp->allnext;
 
+#if defined(CONFIG_SPARC)
 		dp->path_component_name = build_path_component(dp);
+#endif
 		dp->full_name = build_full_name(dp);
 
 		dp->child = prom_build_tree(dp, prom_getchild(node), nextp);
@@ -196,20 +221,18 @@ static struct device_node * __init prom_build_tree(struct device_node *parent,
 	return ret;
 }
 
-void __init prom_build_devicetree(void)
+void __init of_pdt_build_devicetree(phandle root_node)
 {
 	struct device_node **nextp;
 
-	allnodes = prom_create_node(prom_root_node, NULL);
+	allnodes = prom_create_node(root_node, NULL);
+#if defined(CONFIG_SPARC)
 	allnodes->path_component_name = "";
+#endif
 	allnodes->full_name = "/";
 
 	nextp = &allnodes->allnext;
 	allnodes->child = prom_build_tree(allnodes,
 					  prom_getchild(allnodes->phandle),
 					  &nextp);
-	of_console_init();
-
-	printk("PROM: Built device tree with %u bytes of memory.\n",
-	       prom_early_allocated);
 }
diff --git a/include/linux/of_pdt.h b/include/linux/of_pdt.h
new file mode 100644
index 0000000..c0a8774
--- /dev/null
+++ b/include/linux/of_pdt.h
@@ -0,0 +1,24 @@
+/*
+ * Definitions for building a device tree by calling into the
+ * Open Firmware PROM.
+ *
+ * Copyright (C) 2010  Andres Salomon <dilinger@queued.net>
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
+extern void *prom_early_alloc(unsigned long size);
+
+/* for building the device tree */
+extern void of_pdt_build_devicetree(phandle root_node);
+
+extern void (*prom_build_more)(struct device_node *dp,
+		struct device_node ***nextp);
+
+#endif /* _LINUX_OF_PDT_H */
-- 
1.5.6.5

