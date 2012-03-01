Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab2CADKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 22:10:42 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:32216 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab2CADCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 22:02:07 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 16/36] PCI: Add busn_res operation functions
Date: Wed, 29 Feb 2012 19:00:17 -0800
Message-Id: <1330570837-26638-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
References: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090209.4F4EE67A.0145,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will use them insert/update busn res in pci_bus

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    3 +++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 675d7ed..ed82369 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1678,6 +1678,56 @@ err_out:
 	return NULL;
 }
 
+void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus_max)
+{
+	struct resource *res = &b->busn_res;
+	struct resource *parent_res;
+	int ret;
+
+	res->start = bus;
+	res->end = bus_max;
+	res->flags = IORESOURCE_BUS;
+
+	/* no parent for root bus' busn_res */
+	if (!pci_is_root_bus(b)) {
+		parent_res = &b->parent->busn_res;
+
+		ret = insert_resource(parent_res, res);
+
+		dev_printk(KERN_DEBUG, &b->dev,
+			"busn_res: %pR %s inserted under %pR\n",
+			res, ret ? "can not be" : "is", parent_res);
+	} else
+		dev_printk(KERN_DEBUG, &b->dev,
+			"busn_res: %pR for root bus\n",
+			res);
+}
+
+void pci_bus_update_busn_res_end(struct pci_bus *b, int bus_max)
+{
+	struct resource *res = &b->busn_res;
+	struct resource old_res = *res;
+
+	res->end = bus_max;
+	dev_printk(KERN_DEBUG, &b->dev,
+			"busn_res: %pR end updated to %pR\n",
+			&old_res, res);
+}
+
+void pci_bus_release_busn_res(struct pci_bus *b)
+{
+	struct resource *res = &b->busn_res;
+	int ret;
+
+	if (!res->flags)
+		return;
+
+	ret = release_resource(res);
+	dev_printk(KERN_DEBUG, &b->dev,
+			"busn_res: %pR %s released\n",
+			res, ret ? "can not be" : "is");
+}
+
 struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 		struct pci_ops *ops, void *sysdata, struct list_head *resources)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7c03852..e494759 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -669,6 +669,9 @@ struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 				    struct pci_ops *ops, void *sysdata,
 				    struct list_head *resources);
+void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
+void pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
+void pci_bus_release_busn_res(struct pci_bus *b);
 struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 					     struct pci_ops *ops, void *sysdata,
 					     struct list_head *resources);
-- 
1.7.7

