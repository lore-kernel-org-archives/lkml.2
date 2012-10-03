Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2JCC4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 22:56:23 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36597 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab2JCCzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 22:55:43 -0400
Message-ID: <506BA905.4090000@linux.vnet.ibm.com>
Date: Tue, 02 Oct 2012 21:55:01 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: devicetree-discuss@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/5] Add /proc device tree updating to of node add/remove
References: <506B2E63.5090900@linux.vnet.ibm.com>
In-Reply-To: <506B2E63.5090900@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12100302-5930-0000-0000-00000CB21D93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When adding or removing a device tree node we should also update
the device tree in /proc/device-tree. This action is already done in the
generic OF code for adding/removing properties of a node. This patch adds
this functionality for nodes.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com> 
---
 arch/powerpc/platforms/pseries/dlpar.c    |   24 -------------
 arch/powerpc/platforms/pseries/reconfig.c |   47 -------------------------
 drivers/of/base.c                         |   55 +++++++++++++++++++++++++++---
 3 files changed, 51 insertions(+), 75 deletions(-)

Index: dt-next/arch/powerpc/platforms/pseries/dlpar.c
===================================================================
--- dt-next.orig/arch/powerpc/platforms/pseries/dlpar.c	2012-10-02 08:30:23.000000000 -0500
+++ dt-next/arch/powerpc/platforms/pseries/dlpar.c	2012-10-02 08:40:51.000000000 -0500
@@ -13,7 +13,6 @@
 #include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/notifier.h>
-#include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/cpu.h>
 #include <linux/slab.h>
@@ -255,9 +254,6 @@
 
 int dlpar_attach_node(struct device_node *dn)
 {
-#ifdef CONFIG_PROC_DEVICETREE
-	struct proc_dir_entry *ent;
-#endif
 	int rc;
 
 	of_node_set_flag(dn, OF_DYNAMIC);
@@ -274,32 +270,12 @@
 	}
 
 	of_attach_node(dn);
-
-#ifdef CONFIG_PROC_DEVICETREE
-	ent = proc_mkdir(strrchr(dn->full_name, '/') + 1, dn->parent->pde);
-	if (ent)
-		proc_device_tree_add_node(dn, ent);
-#endif
-
 	of_node_put(dn->parent);
 	return 0;
 }
 
 int dlpar_detach_node(struct device_node *dn)
 {
-#ifdef CONFIG_PROC_DEVICETREE
-	struct device_node *parent = dn->parent;
-	struct property *prop = dn->properties;
-
-	while (prop) {
-		remove_proc_entry(prop->name, dn->pde);
-		prop = prop->next;
-	}
-
-	if (dn->pde)
-		remove_proc_entry(dn->pde->name, parent->pde);
-#endif
-
 	pSeries_reconfig_notify(PSERIES_RECONFIG_REMOVE, dn);
 	of_detach_node(dn);
 	of_node_put(dn); /* Must decrement the refcount */
Index: dt-next/arch/powerpc/platforms/pseries/reconfig.c
===================================================================
--- dt-next.orig/arch/powerpc/platforms/pseries/reconfig.c	2012-10-02 08:30:23.000000000 -0500
+++ dt-next/arch/powerpc/platforms/pseries/reconfig.c	2012-10-02 08:40:51.000000000 -0500
@@ -23,48 +23,6 @@
 #include <asm/pSeries_reconfig.h>
 #include <asm/mmu.h>
 
-
-
-/*
- * Routines for "runtime" addition and removal of device tree nodes.
- */
-#ifdef CONFIG_PROC_DEVICETREE
-/*
- * Add a node to /proc/device-tree.
- */
-static void add_node_proc_entries(struct device_node *np)
-{
-	struct proc_dir_entry *ent;
-
-	ent = proc_mkdir(strrchr(np->full_name, '/') + 1, np->parent->pde);
-	if (ent)
-		proc_device_tree_add_node(np, ent);
-}
-
-static void remove_node_proc_entries(struct device_node *np)
-{
-	struct property *pp = np->properties;
-	struct device_node *parent = np->parent;
-
-	while (pp) {
-		remove_proc_entry(pp->name, np->pde);
-		pp = pp->next;
-	}
-	if (np->pde)
-		remove_proc_entry(np->pde->name, parent->pde);
-}
-#else /* !CONFIG_PROC_DEVICETREE */
-static void add_node_proc_entries(struct device_node *np)
-{
-	return;
-}
-
-static void remove_node_proc_entries(struct device_node *np)
-{
-	return;
-}
-#endif /* CONFIG_PROC_DEVICETREE */
-
 /**
  *	derive_parent - basically like dirname(1)
  *	@path:  the full_name of a node to be added to the tree
@@ -149,9 +107,6 @@
 	}
 
 	of_attach_node(np);
-
-	add_node_proc_entries(np);
-
 	of_node_put(np->parent);
 
 	return 0;
@@ -179,8 +134,6 @@
 		return -EBUSY;
 	}
 
-	remove_node_proc_entries(np);
-
 	pSeries_reconfig_notify(PSERIES_RECONFIG_REMOVE, np);
 	of_detach_node(np);
 
Index: dt-next/drivers/of/base.c
===================================================================
--- dt-next.orig/drivers/of/base.c	2012-10-02 08:30:47.000000000 -0500
+++ dt-next/drivers/of/base.c	2012-10-02 08:40:51.000000000 -0500
@@ -1103,6 +1103,22 @@
  * device tree nodes.
  */
 
+#ifdef CONFIG_PROC_DEVICETREE
+static void of_add_proc_dt_entry(struct device_node *dn)
+{
+	struct proc_dir_entry *ent;
+
+	ent = proc_mkdir(strrchr(dn->full_name, '/') + 1, dn->parent->pde);
+	if (ent)
+		proc_device_tree_add_node(dn, ent);
+}
+#else
+static void of_add_proc_dt_entry(struct device_node *dn)
+{
+	return;
+}
+#endif
+
 /**
  * of_attach_node - Plug a device node into the tree and global list.
  */
@@ -1116,7 +1132,30 @@
 	np->parent->child = np;
 	allnodes = np;
 	write_unlock_irqrestore(&devtree_lock, flags);
+
+	of_add_proc_dt_entry(np);
+}
+
+#ifdef CONFIG_PROC_DEVICETREE
+static void of_remove_proc_dt_entry(struct device_node *dn)
+{
+	struct device_node *parent = dn->parent;
+	struct property *prop = dn->properties;
+
+	while (prop) {
+		remove_proc_entry(prop->name, dn->pde);
+		prop = prop->next;
+	}
+
+	if (dn->pde)
+		remove_proc_entry(dn->pde->name, parent->pde);
+}
+#else
+static void of_remove_proc_dt_entry(struct device_node *dn)
+{
+	return;
 }
+#endif
 
 /**
  * of_detach_node - "Unplug" a node from the device tree.
@@ -1131,9 +1170,17 @@
 
 	write_lock_irqsave(&devtree_lock, flags);
 
+	if (of_node_check_flag(np, OF_DETACHED)) {
+		/* someone already detached it */
+		write_unlock_irqrestore(&devtree_lock, flags);
+		return;
+	}
+
 	parent = np->parent;
-	if (!parent)
-		goto out_unlock;
+	if (!parent) {
+		write_unlock_irqrestore(&devtree_lock, flags);
+		return;
+	}
 
 	if (allnodes == np)
 		allnodes = np->allnext;
@@ -1158,9 +1205,9 @@
 	}
 
 	of_node_set_flag(np, OF_DETACHED);
-
-out_unlock:
 	write_unlock_irqrestore(&devtree_lock, flags);
+
+	of_remove_proc_dt_entry(np);
 }
 #endif /* defined(CONFIG_OF_DYNAMIC) */

