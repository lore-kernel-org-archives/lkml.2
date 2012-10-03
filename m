Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab2JCC6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 22:58:08 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41345 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab2JCC6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 22:58:03 -0400
Message-ID: <506BA9B5.2040201@linux.vnet.ibm.com>
Date: Tue, 02 Oct 2012 21:57:57 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: devicetree-discuss@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 3/5] Add of node/property notification chain for adds and
 removes
References: <506B2E63.5090900@linux.vnet.ibm.com>
In-Reply-To: <506B2E63.5090900@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12100302-8974-0000-0000-00000EDD388E
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00179333; UDB=6.00040614; UTC=2012-10-03
 02:58:00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the notification chain for updates to the device tree
from the powerpc/pseries code to the base OF code. This makes this
functionality available to all architectures.

Additionally the notification chain is updated to allow notifications
for property add/remove/update. To make this work a pointer to a new
struct (of_prop_reconfig) is passed to the routines in the notification chain.
The of_prop_reconfig property contains a pointer to the node containing the
property and a pointer to the property itself. In the case of property
updates, the property pointer refers to the new property.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/pSeries_reconfig.h     |   32 ----------
 arch/powerpc/kernel/prom.c                      |    6 -
 arch/powerpc/platforms/pseries/dlpar.c          |   14 ++--
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |    8 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c |   60 +++++++++++++------
 arch/powerpc/platforms/pseries/iommu.c          |    6 -
 arch/powerpc/platforms/pseries/reconfig.c       |   65 ---------------------
 arch/powerpc/platforms/pseries/setup.c          |    6 -
 drivers/of/base.c                               |   74 ++++++++++++++++++++++--
 include/linux/of.h                              |   20 +++++-
 10 files changed, 154 insertions(+), 137 deletions(-)

Index: dt-next/arch/powerpc/platforms/pseries/reconfig.c
===================================================================
--- dt-next.orig/arch/powerpc/platforms/pseries/reconfig.c	2012-10-02 08:40:51.000000000 -0500
+++ dt-next/arch/powerpc/platforms/pseries/reconfig.c	2012-10-02 08:45:12.000000000 -0500
@@ -16,11 +16,11 @@
 #include <linux/notifier.h>
 #include <linux/proc_fs.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/uaccess.h>
-#include <asm/pSeries_reconfig.h>
 #include <asm/mmu.h>
 
 /**
@@ -55,28 +55,6 @@
 	return parent;
 }
 
-static BLOCKING_NOTIFIER_HEAD(pSeries_reconfig_chain);
-
-int pSeries_reconfig_notifier_register(struct notifier_block *nb)
-{
-	return blocking_notifier_chain_register(&pSeries_reconfig_chain, nb);
-}
-EXPORT_SYMBOL_GPL(pSeries_reconfig_notifier_register);
-
-void pSeries_reconfig_notifier_unregister(struct notifier_block *nb)
-{
-	blocking_notifier_chain_unregister(&pSeries_reconfig_chain, nb);
-}
-EXPORT_SYMBOL_GPL(pSeries_reconfig_notifier_unregister);
-
-int pSeries_reconfig_notify(unsigned long action, void *p)
-{
-	int err = blocking_notifier_call_chain(&pSeries_reconfig_chain,
-						action, p);
-
-	return notifier_to_errno(err);
-}
-
 static int pSeries_reconfig_add_node(const char *path, struct property *proplist)
 {
 	struct device_node *np;
@@ -100,13 +78,12 @@
 		goto out_err;
 	}
 
-	err = pSeries_reconfig_notify(PSERIES_RECONFIG_ADD, np);
+	err = of_attach_node(np);
 	if (err) {
 		printk(KERN_ERR "Failed to add device node %s\n", path);
 		goto out_err;
 	}
 
-	of_attach_node(np);
 	of_node_put(np->parent);
 
 	return 0;
@@ -134,9 +111,7 @@
 		return -EBUSY;
 	}
 
-	pSeries_reconfig_notify(PSERIES_RECONFIG_REMOVE, np);
 	of_detach_node(np);
-
 	of_node_put(parent);
 	of_node_put(np); /* Must decrement the refcount */
 	return 0;
@@ -381,7 +356,6 @@
 static int do_update_property(char *buf, size_t bufsize)
 {
 	struct device_node *np;
-	struct pSeries_reconfig_prop_update upd_value;
 	unsigned char *value;
 	char *name, *end, *next_prop;
 	int rc, length;
@@ -410,41 +384,8 @@
 		return -ENODEV;
 	}
 
-	upd_value.node = np;
-	upd_value.property = newprop;
-	pSeries_reconfig_notify(PSERIES_UPDATE_PROPERTY, &upd_value);
-
 	rc = prom_update_property(np, newprop, oldprop);
-	if (rc)
-		return rc;
-
-	/* For memory under the ibm,dynamic-reconfiguration-memory node
-	 * of the device tree, adding and removing memory is just an update
-	 * to the ibm,dynamic-memory property instead of adding/removing a
-	 * memory node in the device tree.  For these cases we still need to
-	 * involve the notifier chain.
-	 */
-	if (!strcmp(name, "ibm,dynamic-memory")) {
-		int action;
-
-		next_prop = parse_next_property(next_prop, end, &name,
-						&length, &value);
-		if (!next_prop)
-			return -EINVAL;
-
-		if (!strcmp(name, "add"))
-			action = PSERIES_DRCONF_MEM_ADD;
-		else
-			action = PSERIES_DRCONF_MEM_REMOVE;
-
-		rc = pSeries_reconfig_notify(action, value);
-		if (rc) {
-			prom_update_property(np, oldprop, newprop);
-			return rc;
-		}
-	}
-
-	return 0;
+	return rc;
 }
 
 /**
Index: dt-next/drivers/of/base.c
===================================================================
--- dt-next.orig/drivers/of/base.c	2012-10-02 08:40:51.000000000 -0500
+++ dt-next/drivers/of/base.c	2012-10-02 08:58:55.000000000 -0500
@@ -978,6 +978,24 @@
 }
 EXPORT_SYMBOL(of_parse_phandle_with_args);
 
+#if defined(CONFIG_OF_DYNAMIC)
+static int of_property_notify(int action, struct device_node *np,
+			      struct property *prop)
+{
+	struct of_prop_reconfig pr;
+
+	pr.dn = np;
+	pr.prop = prop;
+	return of_reconfig_notify(action, &pr);
+}
+#else
+static int of_property_notify(int action, struct device_node *np,
+			      struct property *prop)
+{
+	return 0;
+}
+#endif
+
 /**
  * prom_add_property - Add a property to a node
  */
@@ -985,6 +1003,11 @@
 {
 	struct property **next;
 	unsigned long flags;
+	int rc;
+
+	rc = of_property_notify(OF_RECONFIG_ADD_PROPERTY, np, prop);
+	if (rc)
+		return rc;
 
 	prop->next = NULL;
 	write_lock_irqsave(&devtree_lock, flags);
@@ -1022,6 +1045,11 @@
 	struct property **next;
 	unsigned long flags;
 	int found = 0;
+	int rc;
+
+	rc = of_property_notify(OF_RECONFIG_REMOVE_PROPERTY, np, prop);
+	if (rc)
+		return rc;
 
 	write_lock_irqsave(&devtree_lock, flags);
 	next = &np->properties;
@@ -1064,7 +1092,11 @@
 {
 	struct property **next;
 	unsigned long flags;
-	int found = 0;
+	int rc, found = 0;
+
+	rc = of_property_notify(OF_RECONFIG_UPDATE_PROPERTY, np, newprop);
+	if (rc)
+		return rc;
 
 	write_lock_irqsave(&devtree_lock, flags);
 	next = &np->properties;
@@ -1103,6 +1135,26 @@
  * device tree nodes.
  */
 
+static BLOCKING_NOTIFIER_HEAD(of_reconfig_chain);
+
+int of_reconfig_notifier_register(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&of_reconfig_chain, nb);
+}
+
+int of_reconfig_notifier_unregister(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&of_reconfig_chain, nb);
+}
+
+int of_reconfig_notify(unsigned long action, void *p)
+{
+	int rc;
+
+	rc = blocking_notifier_call_chain(&of_reconfig_chain, action, p);
+	return notifier_to_errno(rc);
+}
+
 #ifdef CONFIG_PROC_DEVICETREE
 static void of_add_proc_dt_entry(struct device_node *dn)
 {
@@ -1122,9 +1174,14 @@
 /**
  * of_attach_node - Plug a device node into the tree and global list.
  */
-void of_attach_node(struct device_node *np)
+int of_attach_node(struct device_node *np)
 {
 	unsigned long flags;
+	int rc;
+
+	rc = of_reconfig_notify(OF_RECONFIG_ATTACH_NODE, np);
+	if (rc)
+		return rc;
 
 	write_lock_irqsave(&devtree_lock, flags);
 	np->sibling = np->parent->child;
@@ -1134,6 +1191,7 @@
 	write_unlock_irqrestore(&devtree_lock, flags);
 
 	of_add_proc_dt_entry(np);
+	return 0;
 }
 
 #ifdef CONFIG_PROC_DEVICETREE
@@ -1163,23 +1221,28 @@
  * The caller must hold a reference to the node.  The memory associated with
  * the node is not freed until its refcount goes to zero.
  */
-void of_detach_node(struct device_node *np)
+int of_detach_node(struct device_node *np)
 {
 	struct device_node *parent;
 	unsigned long flags;
+	int rc = 0;
+
+	rc = of_reconfig_notify(OF_RECONFIG_DETACH_NODE, np);
+	if (rc)
+		return rc;
 
 	write_lock_irqsave(&devtree_lock, flags);
 
 	if (of_node_check_flag(np, OF_DETACHED)) {
 		/* someone already detached it */
 		write_unlock_irqrestore(&devtree_lock, flags);
-		return;
+		return rc;
 	}
 
 	parent = np->parent;
 	if (!parent) {
 		write_unlock_irqrestore(&devtree_lock, flags);
-		return;
+		return rc;
 	}
 
 	if (allnodes == np)
@@ -1208,6 +1271,7 @@
 	write_unlock_irqrestore(&devtree_lock, flags);
 
 	of_remove_proc_dt_entry(np);
+	return rc;
 }
 #endif /* defined(CONFIG_OF_DYNAMIC) */
 
Index: dt-next/arch/powerpc/include/asm/pSeries_reconfig.h
===================================================================
--- dt-next.orig/arch/powerpc/include/asm/pSeries_reconfig.h	2012-10-02 08:30:21.000000000 -0500
+++ dt-next/arch/powerpc/include/asm/pSeries_reconfig.h	2012-10-02 08:43:40.000000000 -0500
@@ -2,43 +2,11 @@
 #define _PPC64_PSERIES_RECONFIG_H
 #ifdef __KERNEL__
 
-#include <linux/notifier.h>
-
-/*
- * Use this API if your code needs to know about OF device nodes being
- * added or removed on pSeries systems.
- */
-
-#define PSERIES_RECONFIG_ADD		0x0001
-#define PSERIES_RECONFIG_REMOVE		0x0002
-#define PSERIES_DRCONF_MEM_ADD		0x0003
-#define PSERIES_DRCONF_MEM_REMOVE	0x0004
-#define PSERIES_UPDATE_PROPERTY		0x0005
-
-/**
- * pSeries_reconfig_notify - Notifier value structure for OFDT property updates
- *
- * @node: Device tree node which owns the property being updated
- * @property: Updated property
- */
-struct pSeries_reconfig_prop_update {
-	struct device_node *node;
-	struct property *property;
-};
-
 #ifdef CONFIG_PPC_PSERIES
-extern int pSeries_reconfig_notifier_register(struct notifier_block *);
-extern void pSeries_reconfig_notifier_unregister(struct notifier_block *);
-extern int pSeries_reconfig_notify(unsigned long action, void *p);
 /* Not the best place to put this, will be fixed when we move some
  * of the rtas suspend-me stuff to pseries */
 extern void pSeries_coalesce_init(void);
 #else /* !CONFIG_PPC_PSERIES */
-static inline int pSeries_reconfig_notifier_register(struct notifier_block *nb)
-{
-	return 0;
-}
-static inline void pSeries_reconfig_notifier_unregister(struct notifier_block *nb) { }
 static inline void pSeries_coalesce_init(void) { }
 #endif /* CONFIG_PPC_PSERIES */
 
Index: dt-next/arch/powerpc/platforms/pseries/hotplug-cpu.c
===================================================================
--- dt-next.orig/arch/powerpc/platforms/pseries/hotplug-cpu.c	2012-10-02 08:30:23.000000000 -0500
+++ dt-next/arch/powerpc/platforms/pseries/hotplug-cpu.c	2012-10-02 08:43:40.000000000 -0500
@@ -23,12 +23,12 @@
 #include <linux/delay.h>
 #include <linux/sched.h>	/* for idle_task_exit */
 #include <linux/cpu.h>
+#include <linux/of.h>
 #include <asm/prom.h>
 #include <asm/rtas.h>
 #include <asm/firmware.h>
 #include <asm/machdep.h>
 #include <asm/vdso_datapage.h>
-#include <asm/pSeries_reconfig.h>
 #include <asm/xics.h>
 #include "plpar_wrappers.h"
 #include "offline_states.h"
@@ -333,10 +333,10 @@
 	int err = 0;
 
 	switch (action) {
-	case PSERIES_RECONFIG_ADD:
+	case OF_RECONFIG_ATTACH_NODE:
 		err = pseries_add_processor(node);
 		break;
-	case PSERIES_RECONFIG_REMOVE:
+	case OF_RECONFIG_DETACH_NODE:
 		pseries_remove_processor(node);
 		break;
 	}
@@ -399,7 +399,7 @@
 
 	/* Processors can be added/removed only on LPAR */
 	if (firmware_has_feature(FW_FEATURE_LPAR)) {
-		pSeries_reconfig_notifier_register(&pseries_smp_nb);
+		of_reconfig_notifier_register(&pseries_smp_nb);
 		cpu_maps_update_begin();
 		if (cede_offline_enabled && parse_cede_parameters() == 0) {
 			default_offline_state = CPU_STATE_INACTIVE;
Index: dt-next/arch/powerpc/platforms/pseries/hotplug-memory.c
===================================================================
--- dt-next.orig/arch/powerpc/platforms/pseries/hotplug-memory.c	2012-10-02 08:30:04.000000000 -0500
+++ dt-next/arch/powerpc/platforms/pseries/hotplug-memory.c	2012-10-02 08:43:40.000000000 -0500
@@ -16,7 +16,6 @@
 
 #include <asm/firmware.h>
 #include <asm/machdep.h>
-#include <asm/pSeries_reconfig.h>
 #include <asm/sparsemem.h>
 
 static unsigned long get_memblock_size(void)
@@ -181,42 +180,69 @@
 	return (ret < 0) ? -EINVAL : 0;
 }
 
-static int pseries_drconf_memory(unsigned long *base, unsigned int action)
+static int pseries_update_drconf_memory(struct of_prop_reconfig *pr)
 {
+	struct of_drconf_cell *new_drmem, *old_drmem;
 	unsigned long memblock_size;
-	int rc;
+	u32 entries;
+	u32 *p;
+	int i, rc = -EINVAL;
 
 	memblock_size = get_memblock_size();
 	if (!memblock_size)
 		return -EINVAL;
 
-	if (action == PSERIES_DRCONF_MEM_ADD) {
-		rc = memblock_add(*base, memblock_size);
-		rc = (rc < 0) ? -EINVAL : 0;
-	} else if (action == PSERIES_DRCONF_MEM_REMOVE) {
-		rc = pseries_remove_memblock(*base, memblock_size);
-	} else {
-		rc = -EINVAL;
+	p = (u32 *)of_get_property(pr->dn, "ibm,dynamic-memory", NULL);
+	if (!p)
+		return -EINVAL;
+
+	/* The first int of the property is the number of lmb's described
+	 * by the property. This is followed by an array of of_drconf_cell
+	 * entries. Get the niumber of entries and skip to the array of
+	 * of_drconf_cell's.
+	 */
+	entries = *p++;
+	old_drmem = (struct of_drconf_cell *)p;
+
+	p = (u32 *)pr->prop->value;
+	p++;
+	new_drmem = (struct of_drconf_cell *)p;
+
+	for (i = 0; i < entries; i++) {
+		if ((old_drmem[i].flags & DRCONF_MEM_ASSIGNED) &&
+		    (!(new_drmem[i].flags & DRCONF_MEM_ASSIGNED))) {
+			rc = pseries_remove_memblock(old_drmem[i].base_addr,
+						     memblock_size);
+			break;
+		} else if ((!(old_drmem[i].flags & DRCONF_MEM_ASSIGNED)) &&
+			   (new_drmem[i].flags & DRCONF_MEM_ASSIGNED)) {
+			rc = memblock_add(old_drmem[i].base_addr,
+					  memblock_size);
+			rc = (rc < 0) ? -EINVAL : 0;
+			break;
+		}
 	}
 
 	return rc;
 }
 
 static int pseries_memory_notifier(struct notifier_block *nb,
-				unsigned long action, void *node)
+				   unsigned long action, void *node)
 {
+	struct of_prop_reconfig *pr;
 	int err = 0;
 
 	switch (action) {
-	case PSERIES_RECONFIG_ADD:
+	case OF_RECONFIG_ATTACH_NODE:
 		err = pseries_add_memory(node);
 		break;
-	case PSERIES_RECONFIG_REMOVE:
+	case OF_RECONFIG_DETACH_NODE:
 		err = pseries_remove_memory(node);
 		break;
-	case PSERIES_DRCONF_MEM_ADD:
-	case PSERIES_DRCONF_MEM_REMOVE:
-		err = pseries_drconf_memory(node, action);
+	case OF_RECONFIG_UPDATE_PROPERTY:
+		pr = (struct of_prop_reconfig *)node;
+		if (!strcmp(pr->prop->name, "ibm,dynamic-memory"))
+			err = pseries_update_drconf_memory(pr);
 		break;
 	}
 	return notifier_from_errno(err);
@@ -229,7 +255,7 @@
 static int __init pseries_memory_hotplug_init(void)
 {
 	if (firmware_has_feature(FW_FEATURE_LPAR))
-		pSeries_reconfig_notifier_register(&pseries_mem_nb);
+		of_reconfig_notifier_register(&pseries_mem_nb);
 
 	return 0;
 }
Index: dt-next/include/linux/of.h
===================================================================
--- dt-next.orig/include/linux/of.h	2012-10-02 08:31:08.000000000 -0500
+++ dt-next/include/linux/of.h	2012-10-02 08:50:22.000000000 -0500
@@ -21,6 +21,7 @@
 #include <linux/kref.h>
 #include <linux/mod_devicetable.h>
 #include <linux/spinlock.h>
+#include <linux/notifier.h>
 
 #include <asm/byteorder.h>
 #include <asm/errno.h>
@@ -270,8 +271,23 @@
 
 #if defined(CONFIG_OF_DYNAMIC)
 /* For updating the device tree at runtime */
-extern void of_attach_node(struct device_node *);
-extern void of_detach_node(struct device_node *);
+#define OF_RECONFIG_ATTACH_NODE		0x0001
+#define OF_RECONFIG_DETACH_NODE		0x0002
+#define OF_RECONFIG_ADD_PROPERTY	0x0003
+#define OF_RECONFIG_REMOVE_PROPERTY	0x0004
+#define OF_RECONFIG_UPDATE_PROPERTY	0x0005
+
+struct of_prop_reconfig {
+	struct device_node	*dn;
+	struct property		*prop;
+};
+
+extern int of_reconfig_notifier_register(struct notifier_block *);
+extern int of_reconfig_notifier_unregister(struct notifier_block *);
+extern int of_reconfig_notify(unsigned long, void *);
+
+extern int of_attach_node(struct device_node *);
+extern int of_detach_node(struct device_node *);
 #endif
 
 #define of_match_ptr(_ptr)	(_ptr)
Index: dt-next/arch/powerpc/kernel/prom.c
===================================================================
--- dt-next.orig/arch/powerpc/kernel/prom.c	2012-10-02 08:30:22.000000000 -0500
+++ dt-next/arch/powerpc/kernel/prom.c	2012-10-02 08:43:40.000000000 -0500
@@ -32,6 +32,7 @@
 #include <linux/debugfs.h>
 #include <linux/irq.h>
 #include <linux/memblock.h>
+#include <linux/of.h>
 
 #include <asm/prom.h>
 #include <asm/rtas.h>
@@ -49,7 +50,6 @@
 #include <asm/btext.h>
 #include <asm/sections.h>
 #include <asm/machdep.h>
-#include <asm/pSeries_reconfig.h>
 #include <asm/pci-bridge.h>
 #include <asm/kexec.h>
 #include <asm/opal.h>
@@ -802,7 +802,7 @@
 	int err;
 
 	switch (action) {
-	case PSERIES_RECONFIG_ADD:
+	case OF_RECONFIG_ATTACH_NODE:
 		err = of_finish_dynamic_node(node);
 		if (err < 0)
 			printk(KERN_ERR "finish_node returned %d\n", err);
@@ -821,7 +821,7 @@
 
 static int __init prom_reconfig_setup(void)
 {
-	return pSeries_reconfig_notifier_register(&prom_reconfig_nb);
+	return of_reconfig_notifier_register(&prom_reconfig_nb);
 }
 __initcall(prom_reconfig_setup);
 #endif
Index: dt-next/arch/powerpc/platforms/pseries/iommu.c
===================================================================
--- dt-next.orig/arch/powerpc/platforms/pseries/iommu.c	2012-10-02 08:30:23.000000000 -0500
+++ dt-next/arch/powerpc/platforms/pseries/iommu.c	2012-10-02 08:43:40.000000000 -0500
@@ -35,6 +35,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/crash_dump.h>
 #include <linux/memory.h>
+#include <linux/of.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/rtas.h>
@@ -42,7 +43,6 @@
 #include <asm/pci-bridge.h>
 #include <asm/machdep.h>
 #include <asm/abs_addr.h>
-#include <asm/pSeries_reconfig.h>
 #include <asm/firmware.h>
 #include <asm/tce.h>
 #include <asm/ppc-pci.h>
@@ -1211,7 +1211,7 @@
 	struct direct_window *window;
 
 	switch (action) {
-	case PSERIES_RECONFIG_REMOVE:
+	case OF_RECONFIG_DETACH_NODE:
 		if (pci && pci->iommu_table)
 			iommu_free_table(pci->iommu_table, np->full_name);
 
@@ -1274,7 +1274,7 @@
 	}
 
 
-	pSeries_reconfig_notifier_register(&iommu_reconfig_nb);
+	of_reconfig_notifier_register(&iommu_reconfig_nb);
 	register_memory_notifier(&iommu_mem_nb);
 
 	set_pci_dma_ops(&dma_iommu_ops);
Index: dt-next/arch/powerpc/platforms/pseries/setup.c
===================================================================
--- dt-next.orig/arch/powerpc/platforms/pseries/setup.c	2012-10-02 08:30:23.000000000 -0500
+++ dt-next/arch/powerpc/platforms/pseries/setup.c	2012-10-02 08:43:40.000000000 -0500
@@ -40,6 +40,7 @@
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 #include <linux/cpuidle.h>
+#include <linux/of.h>
 
 #include <asm/mmu.h>
 #include <asm/processor.h>
@@ -63,7 +64,6 @@
 #include <asm/smp.h>
 #include <asm/firmware.h>
 #include <asm/eeh.h>
-#include <asm/pSeries_reconfig.h>
 
 #include "plpar_wrappers.h"
 #include "pseries.h"
@@ -258,7 +258,7 @@
 	int err = NOTIFY_OK;
 
 	switch (action) {
-	case PSERIES_RECONFIG_ADD:
+	case OF_RECONFIG_ATTACH_NODE:
 		pci = np->parent->data;
 		if (pci) {
 			update_dn_pci_info(np, pci->phb);
@@ -390,7 +390,7 @@
 	init_pci_config_tokens();
 	eeh_pseries_init();
 	find_and_init_phbs();
-	pSeries_reconfig_notifier_register(&pci_dn_reconfig_nb);
+	of_reconfig_notifier_register(&pci_dn_reconfig_nb);
 	eeh_init();
 
 	pSeries_nvram_init();
Index: dt-next/arch/powerpc/platforms/pseries/dlpar.c
===================================================================
--- dt-next.orig/arch/powerpc/platforms/pseries/dlpar.c	2012-10-02 08:40:51.000000000 -0500
+++ dt-next/arch/powerpc/platforms/pseries/dlpar.c	2012-10-02 08:43:40.000000000 -0500
@@ -16,13 +16,13 @@
 #include <linux/spinlock.h>
 #include <linux/cpu.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 #include "offline_states.h"
 
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/uaccess.h>
 #include <asm/rtas.h>
-#include <asm/pSeries_reconfig.h>
 
 struct cc_workarea {
 	u32	drc_index;
@@ -262,24 +262,26 @@
 	if (!dn->parent)
 		return -ENOMEM;
 
-	rc = pSeries_reconfig_notify(PSERIES_RECONFIG_ADD, dn);
+	rc = of_attach_node(dn);
 	if (rc) {
 		printk(KERN_ERR "Failed to add device node %s\n",
 		       dn->full_name);
 		return rc;
 	}
 
-	of_attach_node(dn);
 	of_node_put(dn->parent);
 	return 0;
 }
 
 int dlpar_detach_node(struct device_node *dn)
 {
-	pSeries_reconfig_notify(PSERIES_RECONFIG_REMOVE, dn);
-	of_detach_node(dn);
-	of_node_put(dn); /* Must decrement the refcount */
+	int rc;
 
+	rc = of_detach_node(dn);
+	if (rc)
+		return rc;
+
+	of_node_put(dn); /* Must decrement the refcount */
 	return 0;
 }
 

