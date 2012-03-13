Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906Ab2CMH2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:28:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28300 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab2CMH2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:28:09 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/12] PCI: Add addon_resource support for pci_dev
Date: Tue, 13 Mar 2012 00:26:27 -0700
Message-Id: <1331623594-30543-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
References: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F5EF705.0057,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will add addon_resources list in pci_dev, it will be used for resources
other than stand, rom, sriov, bridges.
Some could be same as std reg, but using different register.
Some could have own way to read/write to them.

Kernel using different way to hack those resources like abusing
pci bridge resource spot on non bridge pci device.

With this patch, will treat addon-resource like standard resource with
special ops.

Also adding bunch of for_each... helpers to make resource loop easier.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci.c       |    7 +++
 drivers/pci/probe.c     |  108 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/setup-res.c |   24 ++++++++---
 include/linux/pci.h     |   77 ++++++++++++++++++++++++++++++++-
 4 files changed, 207 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 32ab301..af84abf 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3545,6 +3545,13 @@ int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
 		reg = pci_iov_resource_bar(dev, resno, type);
 		if (reg)
 			return reg;
+	} else if (resno >= PCI_NUM_RESOURCES) {
+		struct resource *res = pci_dev_resource_n(dev, resno);
+
+		if (res) {
+			*type = pci_bar_unknown;
+			return to_pci_dev_addon_resource(res)->reg_addr;
+		}
 	}
 
 	dev_err(&dev->dev, "BAR %d: invalid resource\n", resno);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 972553b..dac829f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -75,6 +75,111 @@ static int __init pcibus_class_init(void)
 }
 postcore_initcall(pcibus_class_init);
 
+struct resource *pci_dev_resource_n(struct pci_dev *dev, int n)
+{
+	struct pci_dev_addon_resource *addon_res;
+
+	if (n < PCI_NUM_RESOURCES)
+		return &dev->resource[n];
+
+	n -= PCI_NUM_RESOURCES;
+	list_for_each_entry(addon_res, &dev->addon_resources, list) {
+		if (n-- == 0)
+			return &addon_res->res;
+	}
+	return NULL;
+}
+
+int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res)
+{
+	int i;
+	struct resource *r;
+
+	for_each_pci_dev_all_resource(dev, r, i)
+		if (r == res)
+			return i;
+
+	return -1;
+}
+
+struct pci_dev_addon_resource *__add_pci_dev_addon_resource(
+		 struct pci_dev *dev, int addr, char *name)
+{
+	struct pci_dev_addon_resource *addon_res;
+
+	addon_res = kzalloc(sizeof(*addon_res), GFP_KERNEL);
+
+	if (!addon_res)
+		return NULL;
+
+	addon_res->reg_addr = addr;
+
+	if (name)
+		addon_res->res.name = name;
+	else
+		addon_res->res.name = pci_name(dev);
+
+	list_add_tail(&addon_res->list, &dev->addon_resources);
+
+	return addon_res;
+}
+
+struct pci_dev_addon_resource *add_pci_dev_addon_fixed_resource(
+		 struct pci_dev *dev, int start, int size, int flags,
+		 int addr, char *name)
+{
+	struct pci_dev_addon_resource *addon_res;
+	struct resource *res;
+
+	addon_res = __add_pci_dev_addon_resource(dev, addr, name);
+	if (addon_res)
+		return NULL;
+
+	res = &addon_res->res;
+	res->start = start;
+	res->end = start + size - 1;
+	res->flags = flags | IORESOURCE_PCI_FIXED;
+
+	dev_printk(KERN_DEBUG, &dev->dev,
+		   "addon fixed resource %s %pR added\n", res->name, res);
+
+	return addon_res;
+}
+
+struct pci_dev_addon_resource *add_pci_dev_addon_resource(struct pci_dev *dev,
+		 int addr, int size, struct resource_ops *ops, char *name)
+{
+	struct pci_dev_addon_resource *addon_res;
+	struct resource *res;
+
+	addon_res = __add_pci_dev_addon_resource(dev, addr, name);
+	if (!addon_res)
+		return NULL;
+
+	res = &addon_res->res;
+	if (ops) {
+		addon_res->ops = ops;
+		addon_res->size = size;
+		ops->read(dev, res, addr);
+	} else
+		__pci_read_base(dev, pci_bar_unknown, res, addr);
+
+	dev_printk(KERN_DEBUG, &dev->dev,
+		   "addon resource %s %pR added\n", res->name, res);
+
+	return addon_res;
+}
+
+static void pci_release_dev_addon_res(struct pci_dev *dev)
+{
+	struct pci_dev_addon_resource *addon_res, *tmp;
+
+	list_for_each_entry_safe(addon_res, tmp, &dev->addon_resources, list) {
+		list_del(&addon_res->list);
+		kfree(addon_res);
+	}
+}
+
 static u64 pci_size(u64 base, u64 maxbase, u64 mask)
 {
 	u64 size = mask & maxbase;	/* Find the significant bits */
@@ -1283,6 +1388,7 @@ static void pci_release_dev(struct device *dev)
 	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
 	pci_release_of_node(pci_dev);
+	pci_release_dev_addon_res(pci_dev);
 	kfree(pci_dev);
 }
 
@@ -1362,11 +1468,13 @@ struct pci_dev *alloc_pci_dev(void)
 		return NULL;
 
 	INIT_LIST_HEAD(&dev->bus_list);
+	INIT_LIST_HEAD(&dev->addon_resources);
 
 	return dev;
 }
 EXPORT_SYMBOL(alloc_pci_dev);
 
+
 bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *l,
 				 int crs_timeout)
 {
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index eea85da..48251e3 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -33,7 +33,7 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 	u32 new, check, mask;
 	int reg;
 	enum pci_bar_type type;
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 
 	/*
 	 * Ignore resources for unimplemented BARs and unused resource slots
@@ -50,6 +50,21 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 	if (res->flags & IORESOURCE_PCI_FIXED)
 		return;
 
+	if (resno >= PCI_NUM_RESOURCES) {
+		struct pci_dev_addon_resource *addon_res;
+
+		addon_res = to_pci_dev_addon_resource(res);
+		reg = addon_res->reg_addr;
+		if (addon_res->ops) {
+			addon_res->ops->write(dev, res, reg);
+			return;
+		}
+	} else
+		reg = pci_resource_bar(dev, resno, &type);
+
+	if (!reg)
+		return;
+
 	pcibios_resource_to_bus(dev, &region, res);
 
 	new = region.start | (res->flags & PCI_REGION_FLAG_MASK);
@@ -58,9 +73,6 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 	else
 		mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
 
-	reg = pci_resource_bar(dev, resno, &type);
-	if (!reg)
-		return;
 	if (type != pci_bar_unknown) {
 		if (!(res->flags & IORESOURCE_ROM_ENABLE))
 			return;
@@ -257,7 +269,7 @@ int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsiz
 	if (!ret) {
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		dev_info(&dev->dev, "BAR %d: reassigned %pR\n", resno, res);
-		if (resno < PCI_BRIDGE_RESOURCES)
+		if (!resno_is_for_bridge(resno))
 			pci_update_resource(dev, resno);
 	}
 	return ret;
@@ -292,7 +304,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	if (!ret) {
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		dev_info(&dev->dev, "BAR %d: assigned %pR\n", resno, res);
-		if (resno < PCI_BRIDGE_RESOURCES)
+		if (!resno_is_for_bridge(resno))
 			pci_update_resource(dev, resno);
 	}
 	return ret;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 161f6c0..173b8fe 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -299,6 +299,7 @@ struct pci_dev {
 	 */
 	unsigned int	irq;
 	struct resource resource[DEVICE_COUNT_RESOURCE]; /* I/O and memory regions + expansion ROMs */
+	struct list_head addon_resources; /* addon I/O and memory resource */
 
 	/* These fields are used by common fixups */
 	unsigned int	transparent:1;	/* Transparent PCI bridge */
@@ -347,6 +348,76 @@ struct pci_dev {
 #endif
 };
 
+struct resource_ops {
+	int (*read)(struct pci_dev *dev, struct resource *res, int addr);
+	int (*write)(struct pci_dev *dev, struct resource *res, int addr);
+};
+
+struct pci_dev_addon_resource {
+	struct list_head list;
+	int reg_addr;
+	int size;
+	struct resource res;
+	struct resource_ops *ops;
+};
+#define	to_pci_dev_addon_resource(n) container_of(n, struct pci_dev_addon_resource, res)
+
+struct resource *pci_dev_resource_n(struct pci_dev *dev, int n);
+int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res);
+struct pci_dev_addon_resource *add_pci_dev_addon_fixed_resource(
+		 struct pci_dev *dev, int start, int size, int flags,
+		 int addr, char *name);
+struct pci_dev_addon_resource *add_pci_dev_addon_resource(struct pci_dev *dev,
+		 int addr, int size, struct resource_ops *ops, char *name);
+
+#define resno_is_for_bridge(n) ((n)>=PCI_BRIDGE_RESOURCES && (n)<=PCI_BRIDGE_RESOURCE_END)
+
+/* all (include bridge) resources */
+#define for_each_pci_dev_all_resource(dev, res, i)			\
+	for (i = 0;							\
+	     (res = pci_dev_resource_n(dev, i)) || i < PCI_NUM_RESOURCES; \
+	     i++)
+/* exclude bridge resources */
+#define for_each_pci_dev_nobridge_resource(dev, res, i)			\
+	for (i = 0;							\
+	     (res = pci_dev_resource_n(dev, i)) || i < PCI_NUM_RESOURCES; \
+	     i = (i != (PCI_BRIDGE_RESOURCES - 1)) ? (i+1) : PCI_NUM_RESOURCES)
+/* exclude bridge and IOV resources */
+#define for_each_pci_dev_base_resource(dev, res, i)			\
+	for (i = 0;							\
+	     (res = pci_dev_resource_n(dev, i)) || i < PCI_NUM_RESOURCES; \
+	     i = (i != PCI_ROM_RESOURCE) ? (i+1) : PCI_NUM_RESOURCES)
+/* exclude ROM and bridge and IOV resources */
+#define for_each_pci_dev_base_norom_resource(dev, res, i)		\
+	for (i = 0;							\
+	     (res = pci_dev_resource_n(dev, i)) || i < PCI_NUM_RESOURCES; \
+	     i = (i != (PCI_ROM_RESOURCE-1)) ? (i+1) : PCI_NUM_RESOURCES)
+/* exclude IOV resources */
+#define for_each_pci_dev_noiov_resource(dev, res, i)			\
+	for (i = 0;							\
+	     (res = pci_dev_resource_n(dev, i)) || i < PCI_NUM_RESOURCES; \
+	     i = (i != PCI_ROM_RESOURCE) ? (i+1) : PCI_BRIDGE_RESOURCES)
+/* only std resources */
+#define for_each_pci_dev_std_resource(dev, res, i)			\
+	for (i = PCI_STD_RESOURCES;					\
+	   (res = pci_dev_resource_n(dev, i)) && i < (PCI_STD_RESOURCE_END+1); \
+	     i++)
+/* only IOV resources */
+#define for_each_pci_dev_iov_resource(dev, res, i)			\
+	for (i = PCI_IOV_RESOURCES;					\
+	   (res = pci_dev_resource_n(dev, i)) && i < (PCI_IOV_RESOURCE_END+1); \
+	     i++)
+/* only bridge resources */
+#define for_each_pci_dev_bridge_resource(dev, res, i)			\
+	for (i = PCI_BRIDGE_RESOURCES;					\
+	(res = pci_dev_resource_n(dev, i)) && i < (PCI_BRIDGE_RESOURCE_END+1); \
+	     i++)
+/* only addon resources */
+#define for_each_pci_dev_addon_resource(dev, res, i)			\
+	for (i = PCI_NUM_RESOURCES;					\
+	     (res = pci_dev_resource_n(dev, i));			\
+	     i++)
+
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
 {
 #ifdef CONFIG_PCI_IOV
@@ -1348,9 +1419,9 @@ static inline int pci_domain_nr(struct pci_bus *bus)
 
 /* these helpers provide future and backwards compatibility
  * for accessing popular PCI BAR info */
-#define pci_resource_start(dev, bar)	((dev)->resource[(bar)].start)
-#define pci_resource_end(dev, bar)	((dev)->resource[(bar)].end)
-#define pci_resource_flags(dev, bar)	((dev)->resource[(bar)].flags)
+#define pci_resource_start(dev, bar)	(pci_dev_resource_n(dev, (bar))->start)
+#define pci_resource_end(dev, bar)	(pci_dev_resource_n(dev, (bar))->end)
+#define pci_resource_flags(dev, bar)	(pci_dev_resource_n(dev, (bar))->flags)
 #define pci_resource_len(dev,bar) \
 	((pci_resource_start((dev), (bar)) == 0 &&	\
 	  pci_resource_end((dev), (bar)) ==		\
-- 
1.7.7

