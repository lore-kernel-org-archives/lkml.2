Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031295Ab2CSFvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:51:47 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25573 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162070Ab2CSFuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:50:01 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 21/26] PCI: Add helpers for add addon_resource
Date: Sun, 18 Mar 2012 22:48:44 -0700
Message-Id: <1332136129-14010-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F66C906.0097,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    5 +++
 2 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6dbad5b..9d544c9 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -103,6 +103,74 @@ int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res)
 	return -1;
 }
 
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
 static void pci_release_dev_addon_res(struct pci_dev *dev)
 {
 	struct pci_dev_addon_resource *addon_res, *tmp;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2c8b1a4..faaffe7 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -365,6 +365,11 @@ struct pci_dev_addon_resource {
 
 struct resource *pci_dev_resource_n(struct pci_dev *dev, int n);
 int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res);
+struct pci_dev_addon_resource *add_pci_dev_addon_fixed_resource(
+		 struct pci_dev *dev, int start, int size, int flags,
+		 int addr, char *name);
+struct pci_dev_addon_resource *add_pci_dev_addon_resource(struct pci_dev *dev,
+		 int addr, int size, struct resource_ops *ops, char *name);
 
 #define resno_is_for_bridge(n)						\
 	((n) >= PCI_BRIDGE_RESOURCES && (n) <= PCI_BRIDGE_RESOURCE_END)
-- 
1.7.7

