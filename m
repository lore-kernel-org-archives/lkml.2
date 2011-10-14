Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab1JNEeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:34:19 -0400
Received: from smtp-out.google.com ([74.125.121.67]:49733 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab1JNE1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:27:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=I22/LAHcJZs7y+DAof3x06Dq+s3+8/yM5mMRC3430d4PqlegiAJXvIrH5/sAv6r6k
	tIvJITAeoZbEAKxkZHrrw==
Subject: [PATCH v2 03/29] PCI: add pci_scan_root_bus(),
	deprecate pci_scan_bus() and pci_scan_bus_parented()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:27:22 -0600
Message-ID: <20111014042722.23504.2041.stgit@bhelgaas.mtv.corp.google.com>
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

"Early" and "header" quirks use incorrect bus resources because they see
the default resources assigned by pci_create_bus(), before the architecture
fixes them up (typically in pcibios_fixup_bus()).  Regions reserved by
these quirks end up with the wrong parents.

Here's the standard path for scanning a PCI root bus:

  pci_scan_bus or pci_scan_bus_parented
    pci_create_bus                     <-- A create with default resources
    pci_scan_child_bus
      pci_scan_slot
        pci_scan_single_device
          pci_scan_device
            pci_setup_device
              pci_fixup_device(early)  <-- B
          pci_device_add
            pci_fixup_device(header)   <-- C
      pcibios_fixup_bus                <-- D fill in correct resources

Early and header quirks at B and C use the default (incorrect) root bus
resources rather than those filled in at D.

This patch adds a new pci_scan_root_bus() function that sets the bus
resources correctly from a supplied list of resources.  It also marks
pci_scan_bus() and pci_scan_bus_parented() as deprecated.

Callers of pci_scan_bus() should switch to pci_scan_root_bus().  Callers of
pci_scan_bus_parented() should use pci_create_root_bus() followed by
pci_scan_child_bus().  In both cases, root bus resource fixups, e.g.,
in pcibios_fixup_bus(), should be removed.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |   39 +++++++++++++++++++++++++++++++++++++--
 include/linux/pci.h |   19 ++++++++-----------
 2 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 20d2d40..9cb7158 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1624,18 +1624,53 @@ struct pci_bus *pci_create_bus(struct device *parent,
 	return pci_create_root_bus(parent, bus, ops, sysdata, NULL);
 }
 
+/*
+ * Deprecated; use pci_create_root_bus() with non-NULL resources and
+ * pci_scan_child_bus() instead
+ */
 struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
 {
 	struct pci_bus *b;
 
 	b = pci_create_root_bus(parent, bus, ops, sysdata, NULL);
-	if (b)
-		b->subordinate = pci_scan_child_bus(b);
+	if (!b)
+		return NULL;
+
+	b->subordinate = pci_scan_child_bus(b);
 	return b;
 }
 EXPORT_SYMBOL(pci_scan_bus_parented);
 
+/* Deprecated; use pci_scan_root_bus() with non-NULL resources instead */
+struct pci_bus * __devinit pci_scan_bus(int bus, struct pci_ops *ops,
+		void *sysdata)
+{
+	struct pci_bus *b;
+
+	b = pci_create_root_bus(NULL, bus, ops, sysdata, NULL);
+	if (!b)
+		return NULL;
+
+	b->subordinate = pci_scan_child_bus(b);
+	pci_bus_add_devices(b);
+	return b;
+}
+
+struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus_num,
+		struct pci_ops *ops, void *sysdata, struct list_head *resources)
+{
+	struct pci_bus *bus;
+
+	bus = pci_create_root_bus(parent, bus_num, ops, sysdata, resources);
+	if (!bus)
+		return NULL;
+
+	bus->subordinate = pci_scan_child_bus(bus);
+	pci_bus_add_devices(bus);
+	return bus;
+}
+
 #ifdef CONFIG_HOTPLUG
 /**
  * pci_rescan_bus - scan a PCI bus for devices.
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6bdf854..03c6089 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -655,20 +655,17 @@ void pci_fixup_cardbus(struct pci_bus *);
 void pcibios_scan_specific_bus(int busn);
 extern struct pci_bus *pci_find_bus(int domain, int busnr);
 void pci_bus_add_devices(const struct pci_bus *bus);
-struct pci_bus *pci_scan_bus_parented(struct device *parent, int bus,
-				      struct pci_ops *ops, void *sysdata);
-static inline struct pci_bus * __devinit pci_scan_bus(int bus, struct pci_ops *ops,
-					   void *sysdata)
-{
-	struct pci_bus *root_bus;
-	root_bus = pci_scan_bus_parented(NULL, bus, ops, sysdata);
-	if (root_bus)
-		pci_bus_add_devices(root_bus);
-	return root_bus;
-}
+struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
+					     struct pci_ops *ops, void *sysdata,
+					     struct list_head *resources);
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 				    struct pci_ops *ops, void *sysdata,
 				    struct list_head *resources);
+struct pci_bus *pci_scan_bus_parented(struct device *parent, int bus,
+				      struct pci_ops *ops, void *sysdata)
+				      __deprecated;
+struct pci_bus * __devinit pci_scan_bus(int bus, struct pci_ops *ops,
+					void *sysdata) __deprecated;
 struct pci_bus *pci_create_bus(struct device *parent, int bus,
 			       struct pci_ops *ops, void *sysdata) __deprecated;
 struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,

