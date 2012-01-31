Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab2AaHoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 02:44:19 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:47083 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab2AaHnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 02:43:20 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/14] PCI: Add busn_res operation functions
Date: Mon, 30 Jan 2012 23:42:41 -0800
Message-Id: <1327995772-11388-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327995772-11388-1-git-send-email-yinghai@kernel.org>
References: <1327995772-11388-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F279B91.008A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will use them insert/update busn res in pci_bus

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    3 +++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a114173..957c2bc 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1622,6 +1622,42 @@ err_out:
 	return NULL;
 }
 
+void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus_max)
+{
+	struct resource *res = &b->busn_res;
+	struct resource *parent_res = &iobusn_resource;
+	int ret;
+
+	res->start = (pci_domain_nr(b) << 8) | bus;
+	res->end = (pci_domain_nr(b) << 8) | bus_max;
+	res->flags = IORESOURCE_BUS;
+
+	if (!pci_is_root_bus(b))
+		parent_res = &b->parent->busn_res;
+
+	ret = insert_resource(parent_res, res);
+
+	dev_printk(KERN_DEBUG, &b->dev,
+			"busn_res: %pR %s inserted under %pR\n",
+			res, ret ? "can not be" : "is", parent_res);
+}
+
+void pci_bus_update_busn_res_end(struct pci_bus *b, int bus_max)
+{
+	struct resource *res = &b->busn_res;
+	struct resource old_res = *res;
+
+	res->end &= ~0xff;
+	res->end |= bus_max;
+	dev_printk(KERN_DEBUG, &b->dev, "busn_res: %pR end updated to %pR\n",
+			&old_res, res);
+}
+
+void pci_bus_release_busn_res(struct pci_bus *b)
+{
+	release_resource(&b->busn_res);
+}
+
 struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 		struct pci_ops *ops, void *sysdata, struct list_head *resources)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 94ad468..3da935c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -665,6 +665,9 @@ struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
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

