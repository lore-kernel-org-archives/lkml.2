Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab2B1CPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:15:44 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:48885 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab2B1CLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:11:18 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/18] PCI: Add busn_res operation functions
Date: Mon, 27 Feb 2012 18:09:54 -0800
Message-Id: <1330395009-29260-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
References: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A020206.4F4C37BD.00DB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will use them insert/update busn res in pci_bus

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    3 +++
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 675d7ed..3c0eecb 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1678,6 +1678,53 @@ err_out:
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

