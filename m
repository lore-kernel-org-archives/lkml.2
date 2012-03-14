Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030767Ab2CNKbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:31:45 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:48760 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030747Ab2CNKbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:31:42 -0400
From: Gavin Shan <shangw@linux.vnet.ibm.com>
To: sfr@canb.auug.org.au, grant.likely@secretlab.ca, benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: [PATCH] EEH: remove eeh device from OF node
Date: Wed, 14 Mar 2012 18:31:26 +0800
Message-Id: <1331721086-4314-1-git-send-email-shangw@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 12031400-9264-0000-0000-0000010DCEEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally, the PCI sensitive OF node is tracing the eeh device
through struct device_node::edev. However, it was regarded as
bad idea.

The patch removes struct device_node::edev. In addition, the
global list of eeh devices is introduced, and do retrival of
eeh device according to the given OF node through the global
list.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/eeh.h           |    7 +++++++
 arch/powerpc/platforms/pseries/eeh_dev.c |   29 ++++++++++++++++++++++++++++-
 include/linux/of.h                       |   10 ----------
 3 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/include/asm/eeh.h b/arch/powerpc/include/asm/eeh.h
index d60f998..591e0a1 100644
--- a/arch/powerpc/include/asm/eeh.h
+++ b/arch/powerpc/include/asm/eeh.h
@@ -56,6 +56,7 @@ struct eeh_dev {
 	struct pci_controller *phb;	/* Associated PHB		*/
 	struct device_node *dn;		/* Associated device node	*/
 	struct pci_dev *pdev;		/* Associated PCI device	*/
+	struct list_head list;		/* Form the global link list	*/
 };
 
 static inline struct device_node *eeh_dev_to_of_node(struct eeh_dev *edev)
@@ -115,6 +116,7 @@ extern int eeh_subsystem_enabled;
  */
 #define EEH_MAX_ALLOWED_FREEZES 5
 
+struct eeh_dev *eeh_dev_from_of_node(struct device_node *dn);
 void * __devinit eeh_dev_init(struct device_node *dn, void *data);
 void __devinit eeh_dev_phb_init_dynamic(struct pci_controller *phb);
 void __init eeh_dev_phb_init(void);
@@ -132,6 +134,11 @@ void eeh_add_device_tree_early(struct device_node *);
 void eeh_add_device_tree_late(struct pci_bus *);
 void eeh_remove_bus_device(struct pci_dev *);
 
+static inline struct eeh_dev *of_node_to_eeh_dev(struct device_node *dn)
+{
+	return eeh_dev_from_of_node(dn);
+}
+
 /**
  * EEH_POSSIBLE_ERROR() -- test for possible MMIO failure.
  *
diff --git a/arch/powerpc/platforms/pseries/eeh_dev.c b/arch/powerpc/platforms/pseries/eeh_dev.c
index f3aed7d..925d3a3 100644
--- a/arch/powerpc/platforms/pseries/eeh_dev.c
+++ b/arch/powerpc/platforms/pseries/eeh_dev.c
@@ -34,6 +34,7 @@
 #include <linux/export.h>
 #include <linux/gfp.h>
 #include <linux/init.h>
+#include <linux/list.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/string.h>
@@ -41,6 +42,30 @@
 #include <asm/pci-bridge.h>
 #include <asm/ppc-pci.h>
 
+/* eeh device list */
+static LIST_HEAD(eeh_dev_list);
+
+/**
+ * eeh_dev_from_of_node - Retrieve EEH device according to OF node
+ * @dn: OF node
+ *
+ * All existing eeh devices have been put into the global list.
+ * In addition, the eeh device is tracing the corresponding
+ * OF node. The function is used to retrieve the corresponding
+ * eeh device according to the given OF node.
+ */
+struct eeh_dev *eeh_dev_from_of_node(struct device_node *dn)
+{
+	struct eeh_dev *edev = NULL;
+
+	list_for_each_entry(edev, &eeh_dev_list, list) {
+		if (edev->dn && edev->dn == dn)
+			return edev;
+	}
+
+	return NULL;
+}
+
 /**
  * eeh_dev_init - Create EEH device according to OF node
  * @dn: device node
@@ -62,10 +87,12 @@ void * __devinit eeh_dev_init(struct device_node *dn, void *data)
 	}
 
 	/* Associate EEH device with OF node */
-	dn->edev  = edev;
 	edev->dn  = dn;
 	edev->phb = phb;
 
+	/* Add to global list */
+	list_add_tail(&edev->list, &eeh_dev_list);
+
 	return NULL;
 }
 
diff --git a/include/linux/of.h b/include/linux/of.h
index 3e710d8..a75a831 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -58,9 +58,6 @@ struct device_node {
 	struct	kref kref;
 	unsigned long _flags;
 	void	*data;
-#if defined(CONFIG_EEH)
-	struct eeh_dev *edev;
-#endif
 #if defined(CONFIG_SPARC)
 	char	*path_component_name;
 	unsigned int unique_id;
@@ -75,13 +72,6 @@ struct of_phandle_args {
 	uint32_t args[MAX_PHANDLE_ARGS];
 };
 
-#if defined(CONFIG_EEH)
-static inline struct eeh_dev *of_node_to_eeh_dev(struct device_node *dn)
-{
-	return dn->edev;
-}
-#endif
-
 #if defined(CONFIG_SPARC) || !defined(CONFIG_OF)
 /* Dummy ref counting routines - to be implemented later */
 static inline struct device_node *of_node_get(struct device_node *node)
-- 
1.7.5.4

