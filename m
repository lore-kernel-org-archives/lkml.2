Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab0F2CBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 22:01:07 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:59800 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab0F2CBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 22:01:03 -0400
Date: Mon, 28 Jun 2010 22:00:58 -0400
From: Andres Salomon <dilinger@queued.net>
To: devicetree-discuss@lists.ozlabs.org
Cc: sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, cjb@laptop.org,
       Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       grant.likely@secretlab.ca
Subject: [PATCH 4/4] x86: OLPC: add OLPC device-tree support
Message-ID: <20100628220058.19e8f143@debian>
In-Reply-To: <20100628215407.2017bf2f@debian>
References: <20100628215407.2017bf2f@debian>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make use of PROC_DEVICETREE to export the tree, and sparc's PROMTREE code to
call into OLPC's Open Firmware to build the tree.  

(Yes, I know this leaks memory by simply using kmalloc)

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/Kconfig                 |    5 ++
 arch/x86/include/asm/olpc_prom.h |   42 +++++++++++
 arch/x86/include/asm/prom.h      |    5 ++
 arch/x86/kernel/Makefile         |    1 +
 arch/x86/kernel/olpc_ofw.c       |   13 ++++
 arch/x86/kernel/olpc_prom.c      |  148 ++++++++++++++++++++++++++++++++++++++
 fs/proc/Kconfig                  |    2 +-
 7 files changed, 215 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/olpc_prom.h
 create mode 100644 arch/x86/include/asm/prom.h
 create mode 100644 arch/x86/kernel/olpc_prom.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 71c194d..7aea004 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2071,6 +2071,11 @@ config OLPC_OPENFIRMWARE
 	  that is used on the OLPC XO-1 Children's Machine.
 	  If unsure, say N here.
 
+config OF
+	def_bool y
+	depends on OLPC_OPENFIRMWARE
+	select OF_PROMTREE
+
 endif # X86_32
 
 config K8_NB
diff --git a/arch/x86/include/asm/olpc_prom.h b/arch/x86/include/asm/olpc_prom.h
new file mode 100644
index 0000000..96cdcee
--- /dev/null
+++ b/arch/x86/include/asm/olpc_prom.h
@@ -0,0 +1,42 @@
+#include <linux/of.h>	/* linux/of.h gets to determine #include ordering */
+/*
+ * Definitions for talking to the Open Firmware PROM on
+ * Power Macintosh computers.
+ *
+ * Copyright (C) 1996-2005 Paul Mackerras.
+ *
+ * Updates for PPC64 by Peter Bergner & David Engebretsen, IBM Corp.
+ * Updates for SPARC by David S. Miller
+ * Updates for x86/OLPC by Andres Salomon
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _X86_PROM_OLPC_H
+#define _X86_PROM_OLPC_H
+#ifdef __KERNEL__
+
+#define OF_ROOT_NODE_ADDR_CELLS_DEFAULT 2
+#define OF_ROOT_NODE_SIZE_CELLS_DEFAULT 1
+
+#define of_compat_cmp(s1, s2, l)	strncmp((s1), (s2), (l))
+#define of_prop_cmp(s1, s2)		strcasecmp((s1), (s2))
+#define of_node_cmp(s1, s2)		strcmp((s1), (s2))
+
+extern void prom_build_devicetree(void);
+
+extern void *prom_early_alloc(unsigned long size);
+
+extern char *prom_firstprop(phandle node, char *buf);
+extern char *prom_nextprop(phandle node, const char *prev, char *buf);
+extern int prom_getproplen(phandle node, const char *prop);
+extern int prom_getproperty(phandle node, const char *prop,
+                            char *buffer, int bufsize);
+extern phandle prom_getchild(phandle node);
+extern phandle prom_getsibling(phandle node);
+
+#endif /* __KERNEL__ */
+#endif /* _X86_PROM_OLPC_H */
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
new file mode 100644
index 0000000..7b561b2
--- /dev/null
+++ b/arch/x86/include/asm/prom.h
@@ -0,0 +1,5 @@
+#ifdef CONFIG_OLPC_OPENFIRMWARE
+# include <asm/olpc_prom.h>
+#else
+# error "No OFW prom defined for x86!"
+#endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..3d7e535 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -105,6 +105,7 @@ scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
 obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
+obj-$(CONFIG_PROC_DEVICETREE)	+= olpc_prom.o
 obj-$(CONFIG_X86_MRST)		+= mrst.o
 
 microcode-y				:= microcode_core.o
diff --git a/arch/x86/kernel/olpc_ofw.c b/arch/x86/kernel/olpc_ofw.c
index 3e13a4b..8838edb 100644
--- a/arch/x86/kernel/olpc_ofw.c
+++ b/arch/x86/kernel/olpc_ofw.c
@@ -6,6 +6,7 @@
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/olpc_ofw.h>
+#include <asm/prom.h>
 
 /* address of OFW callback interface; will be NULL if OFW isn't found */
 static int (*olpc_ofw_cif)(int *);
@@ -103,3 +104,15 @@ void __init olpc_ofw_detect(void)
 			(unsigned long)olpc_ofw_cif, (-start) >> 20);
 	reserve_top_address(-start);
 }
+
+#ifdef CONFIG_PROC_DEVICETREE
+static int __init olpc_ofw_build_devicetree(void)
+{
+	/* initialize the device-tree that proc uses */
+	if (olpc_ofw_cif)
+		prom_build_devicetree();
+
+	return 0;
+}
+arch_initcall(olpc_ofw_build_devicetree);
+#endif /* CONFIG_PROC_DEVICETREE */
diff --git a/arch/x86/kernel/olpc_prom.c b/arch/x86/kernel/olpc_prom.c
new file mode 100644
index 0000000..1128f3f
--- /dev/null
+++ b/arch/x86/kernel/olpc_prom.c
@@ -0,0 +1,148 @@
+/*
+ * olpc_prom.c: OLPC-specific OFW device tree support code.
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
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_pdt.h>
+#include <asm/olpc_ofw.h>
+#include <asm/prom.h>
+
+phandle prom_getsibling(phandle node)
+{
+	const void *args[] = { (void *)node };
+	void *res[] = { &node };
+
+	if (node == -1)
+		return -1;
+
+	if (olpc_ofw("peer", args, res) || node == -1)
+		return -1;
+
+	return node;
+}
+
+phandle prom_getchild(phandle node)
+{
+	const void *args[] = { (void *)node };
+	void *res[] = { &node };
+
+	if (node == -1)
+		return 0;
+
+	if (olpc_ofw("child", args, res) || node == -1) {
+		printk(KERN_ERR "PROM: %s: fetching child failed!\n", __func__);
+		return 0;
+	}
+
+	return node;
+}
+
+int prom_getproplen(phandle node, const char *prop)
+{
+	const void *args[] = { (void *)node, prop };
+	int len;
+	void *res[] = { &len };
+
+	if (node == -1)
+		return 0;
+
+	if (olpc_ofw("getproplen", args, res)) {
+		printk(KERN_ERR "PROM: %s: getproplen failed!\n", __func__);
+		return 0;
+	}
+
+	return len;
+}
+
+int prom_getproperty(phandle node, const char *prop, char *buf,
+		int bufsize)
+{
+	int plen;
+
+	plen = prom_getproplen(node, prop);
+	if (plen > bufsize || plen < 1)
+		return -1;
+	else {
+		const void *args[] = { (void *)node, prop, buf, (void *)plen };
+		void *res[] = { &plen };
+
+		if (olpc_ofw("getprop", args, res)) {
+			printk(KERN_ERR "PROM: %s: getprop failed!\n", __func__);
+			return -1;
+		}
+		//((unsigned char *)buf)[plen] = '\0';
+	}
+
+	return 0;
+}
+
+char *prom_firstprop(phandle node, char *buf)
+{
+	buf[0] = '\0';
+
+	if (node == -1)
+		return NULL;
+
+	return prom_nextprop(node, "", buf);
+}
+
+char *prom_nextprop(phandle node, const char *prev, char *buf)
+{
+	const void *args[] = { (void *)node, prev, buf };
+	int success;
+	void *res[] = { &success };
+
+	buf[0] = '\0';
+
+	if (node == -1)
+		return NULL;
+
+	if (olpc_ofw("nextprop", args, res) || success != 1) {
+		printk(KERN_ERR "PROM: %s: nextprop failed!\n", __func__);
+		return NULL;
+	}
+
+	return buf;
+}
+
+void * __init prom_early_alloc(unsigned long size)
+{
+	/* unlike SPARC, we don't bother keeping track of prom memory */
+	return kzalloc(size, GFP_KERNEL);
+}
+
+void __init prom_build_devicetree(void)
+{
+	struct device_node **nextp;
+	phandle root;
+
+	root = prom_getsibling(0);
+	if (root < 0) {
+		printk(KERN_ERR "PROM: unable to get root node from OFW!\n");
+		return;
+	}
+
+	allnodes = prom_create_node(root, NULL);
+	allnodes->full_name = "/";
+
+	nextp = &allnodes->allnext;
+	allnodes->child = prom_build_tree(allnodes,
+			prom_getchild(allnodes->phandle), &nextp);
+}
diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 858a859..86f67ce 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -41,7 +41,7 @@ config PROC_VMCORE
 
 config PROC_DEVICETREE
 	bool "Support for device tree in /proc"
-	depends on PROC_FS && (PPC || MICROBLAZE)
+	depends on PROC_FS && (PPC || MICROBLAZE || OLPC_OPENFIRMWARE)
 	help
 	  This option adds a device-tree directory under /proc which contains
 	  an image of the device tree that the kernel copies from Open
-- 
1.5.6.5

