Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab1JNE10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:27:26 -0400
Received: from smtp-out.google.com ([74.125.121.67]:49725 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1JNE1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:27:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=KFtQWR2fWlzDfnuCaxc+q02Uvu8R7NSrbs5iIMInwAwVB1S0wFq4tSk9OOk0JwvJn
	DcVHwU5te3hAa8ehgXz0g==
Subject: [PATCH v2 02/29] PCI: add pci_create_root_bus(),
	deprecate pci_create_bus()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, Deng-Cheng Zhu <dczhu@mips.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:27:17 -0600
Message-ID: <20111014042717.23504.68062.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_create_bus() assigns ioport_resource and iomem_resource as the default
bus resources, i.e., the entire address space.  Architectures fix these
later, typically in pcibios_fixup_bus() or after pci_scan_bus_parented()
returns, but code that runs in the interim sees incorrect resource
information.

This patch adds a new pci_create_root_bus() that sets the bus resources
correctly from a supplied list of resources and marks pci_create_bus() as
deprecated.

Most architectures use pci_scan_bus() or pci_scan_bus_parented() instead of
calling pci_create_bus() directly.  Those that use pci_create_bus()
directly (usually because they need different bus scanning than
pci_scan_child_bus()) should switch to pci_create_root_bus().

Based on original patch by Deng-Cheng Zhu.

Reference: http://www.spinics.net/lists/mips/msg41654.html
Reference: https://lkml.org/lkml/2011/8/26/88
Signed-off-by: Deng-Cheng Zhu <dczhu@mips.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |   36 ++++++++++++++++++++++++++++++------
 include/linux/pci.h |    5 ++++-
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6ab6bd3..20d2d40 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1528,12 +1528,14 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 	return max;
 }
 
-struct pci_bus * pci_create_bus(struct device *parent,
-		int bus, struct pci_ops *ops, void *sysdata)
+struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
+		struct pci_ops *ops, void *sysdata, struct list_head *resources)
 {
-	int error;
+	int error, i;
 	struct pci_bus *b, *b2;
 	struct device *dev;
+	struct pci_bus_resource *bus_res, *n;
+	struct resource *res;
 
 	b = pci_alloc_bus();
 	if (!b)
@@ -1583,8 +1585,23 @@ struct pci_bus * pci_create_bus(struct device *parent,
 	pci_create_legacy_files(b);
 
 	b->number = b->secondary = bus;
-	b->resource[0] = &ioport_resource;
-	b->resource[1] = &iomem_resource;
+
+	/* Add initial resources to the bus */
+	if (resources) {
+		list_for_each_entry_safe(bus_res, n, resources, list)
+			list_move_tail(&bus_res->list, &b->resources);
+	} else {
+		b->resource[0] = &ioport_resource;
+		b->resource[1] = &iomem_resource;
+	}
+
+	if (parent)
+		dev_info(parent, "PCI host bridge to %s\n",
+			 dev_name(&b->dev));
+	pci_bus_for_each_resource(b, res, i) {
+		if (res)
+			dev_info(&b->dev, "root bus resource %pR\n", res);
+	}
 
 	return b;
 
@@ -1600,12 +1617,19 @@ err_out:
 	return NULL;
 }
 
+/* Deprecated; use pci_create_root_bus() with non-NULL resources instead */
+struct pci_bus *pci_create_bus(struct device *parent,
+		int bus, struct pci_ops *ops, void *sysdata)
+{
+	return pci_create_root_bus(parent, bus, ops, sysdata, NULL);
+}
+
 struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
 {
 	struct pci_bus *b;
 
-	b = pci_create_bus(parent, bus, ops, sysdata);
+	b = pci_create_root_bus(parent, bus, ops, sysdata, NULL);
 	if (b)
 		b->subordinate = pci_scan_child_bus(b);
 	return b;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6841e7f..6bdf854 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -666,8 +666,11 @@ static inline struct pci_bus * __devinit pci_scan_bus(int bus, struct pci_ops *o
 		pci_bus_add_devices(root_bus);
 	return root_bus;
 }
+struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
+				    struct pci_ops *ops, void *sysdata,
+				    struct list_head *resources);
 struct pci_bus *pci_create_bus(struct device *parent, int bus,
-			       struct pci_ops *ops, void *sysdata);
+			       struct pci_ops *ops, void *sysdata) __deprecated;
 struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
 				int busnr);
 void pcie_update_link_speed(struct pci_bus *bus, u16 link_status);

