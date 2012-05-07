Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab2EGUab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:30:31 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18472 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab2EGUa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:28 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/21] PCI: Add busn_res operation functions
Date: Mon,  7 May 2012 13:29:51 -0700
Message-Id: <1336422606-4244-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will use them insert/update busn res in pci_bus struct.

-v2: use update_resource() requested by Bjorn.
-v3: use domain_busn_res as root bus busn_res parent.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    3 ++
 2 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 674a477..bfbf064 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1714,6 +1714,69 @@ err_out:
 	return NULL;
 }
 
+int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus_max)
+{
+	struct resource *res = &b->busn_res;
+	struct resource *parent_res;
+	int ret;
+
+	res->start = bus;
+	res->end = bus_max;
+	res->flags = IORESOURCE_BUS;
+
+	if (!pci_is_root_bus(b))
+		parent_res = &b->parent->busn_res;
+	else {
+		parent_res = get_pci_domain_busn_res(pci_domain_nr(b));
+		res->flags |= IORESOURCE_PCI_FIXED;
+	}
+
+	ret = insert_resource(parent_res, res);
+
+	dev_printk(KERN_DEBUG, &b->dev,
+			"busn_res: %pR %s inserted under %s %pR\n",
+			res, ret ? "can not be" : "is",
+			pci_is_root_bus(b) ? "domain":"", parent_res);
+
+	return ret;
+}
+
+int pci_bus_update_busn_res_end(struct pci_bus *b, int bus_max)
+{
+	struct resource *res = &b->busn_res;
+	struct resource old_res = *res;
+	resource_size_t size;
+	int ret;
+
+	if (res->start > bus_max)
+		return -EINVAL;
+
+	size = bus_max - res->start + 1;
+	ret = adjust_resource(res, res->start, size);
+	dev_printk(KERN_DEBUG, &b->dev,
+			"busn_res: %pR end %s updated to %02x\n",
+			&old_res, ret ? "can not be" : "is", bus_max);
+
+	if (!ret && !res->parent)
+		pci_bus_insert_busn_res(b, res->start, res->end);
+
+	return ret;
+}
+
+void pci_bus_release_busn_res(struct pci_bus *b)
+{
+	struct resource *res = &b->busn_res;
+	int ret;
+
+	if (!res->flags || !res->parent)
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
index d588ef4..b5f2cc7 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -667,6 +667,9 @@ struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 				    struct pci_ops *ops, void *sysdata,
 				    struct list_head *resources);
+int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
+int pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
+void pci_bus_release_busn_res(struct pci_bus *b);
 struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 					     struct pci_ops *ops, void *sysdata,
 					     struct list_head *resources);
-- 
1.7.7

