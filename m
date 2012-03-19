Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162093Ab2CSFuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:50:04 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31381 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162063Ab2CSFt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:59 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 20/26] PCI: Add addon_resource support for pci_dev
Date: Sun, 18 Mar 2012 22:48:43 -0700
Message-Id: <1332136129-14010-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F66C904.00C5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will add addon_resources list in pci_dev, it will be used for resources
other than standard, rom, sriov, bridges.
Some could be same as std reg, but using different register.
Some could have own way to read/write to them.

Kernel using different way to hack those resources like abusing
pci bridge resource spot on non bridge pci device.

With this patch, will treat addon-resource like standard resource with
special ops.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   18 ++++++++++++++++++
 include/linux/pci.h |   16 ++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index dfa56fb..6dbad5b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -82,6 +82,12 @@ struct resource *pci_dev_resource_n(struct pci_dev *dev, int n)
 	if (n < PCI_NUM_RESOURCES)
 		return &dev->resource[n];
 
+	n -= PCI_NUM_RESOURCES;
+	list_for_each_entry(addon_res, &dev->addon_resources, list) {
+		if (n-- == 0)
+			return &addon_res->res;
+	}
+
 	return NULL;
 }
 
@@ -97,6 +103,16 @@ int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res)
 	return -1;
 }
 
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
@@ -1288,6 +1304,7 @@ static void pci_release_dev(struct device *dev)
 	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
 	pci_release_of_node(pci_dev);
+	pci_release_dev_addon_res(pci_dev);
 	kfree(pci_dev);
 }
 
@@ -1367,6 +1384,7 @@ struct pci_dev *alloc_pci_dev(void)
 		return NULL;
 
 	INIT_LIST_HEAD(&dev->bus_list);
+	INIT_LIST_HEAD(&dev->addon_resources);
 
 	return dev;
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c7a2806..2c8b1a4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -299,6 +299,7 @@ struct pci_dev {
 	 */
 	unsigned int	irq;
 	struct resource resource[DEVICE_COUNT_RESOURCE]; /* I/O and memory regions + expansion ROMs */
+	struct list_head addon_resources; /* addon I/O and memory resource */
 
 	/* These fields are used by common fixups */
 	unsigned int	transparent:1;	/* Transparent PCI bridge */
@@ -347,6 +348,21 @@ struct pci_dev {
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
+#define	to_pci_dev_addon_resource(n)					\
+	container_of(n, struct pci_dev_addon_resource, res)
+
 struct resource *pci_dev_resource_n(struct pci_dev *dev, int n);
 int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res);
 
-- 
1.7.7

