Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab2BEHCA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 02:02:00 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:61855 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab2BEHAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 02:00:42 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 22/24] PCI: Add pci_bus_add_single_device()
Date: Sat,  4 Feb 2012 22:58:06 -0800
Message-Id: <1328425088-6562-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F2E2912.0014,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will use it to pci_bus_bridge_scan_resize(0 to make bridge will
have pci_bus directory created.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/bus.c   |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    1 +
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 398f5d8..7b2ae85 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -247,6 +247,46 @@ void pci_bus_add_devices(const struct pci_bus *bus)
 	}
 }
 
+void pci_bus_add_single_device(struct pci_dev *dev)
+{
+	struct pci_bus *child;
+	int retval;
+
+	/* Skip already-added devices */
+	if (!dev->is_added) {
+		retval = pci_bus_add_device(dev);
+		if (retval)
+			dev_err(&dev->dev, "Error adding device, continuing\n");
+	}
+
+	BUG_ON(!dev->is_added);
+
+	child = dev->subordinate;
+	/*
+	 * If there is an unattached subordinate bus, attach
+	 * it and then scan for unattached PCI devices.
+	 */
+	if (child) {
+		if (list_empty(&child->node)) {
+			down_write(&pci_bus_sem);
+			list_add_tail(&child->node, &dev->bus->children);
+			up_write(&pci_bus_sem);
+		}
+		pci_bus_add_devices(child);
+
+		/*
+		 * register the bus with sysfs as the parent is now
+		 * properly registered.
+		 */
+		if (!child->is_added) {
+			retval = pci_bus_add_child(child);
+			if (retval)
+				dev_err(&dev->dev, "Error adding bus, continuing\n");
+		}
+	}
+}
+
+
 void pci_enable_bridges(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d5b6786..8061031 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -659,6 +659,7 @@ void pci_fixup_cardbus(struct pci_bus *);
 void pcibios_scan_specific_bus(int busn);
 extern struct pci_bus *pci_find_bus(int domain, int busnr);
 void pci_bus_add_devices(const struct pci_bus *bus);
+void pci_bus_add_single_device(struct pci_dev *dev);
 struct pci_bus *pci_scan_bus_parented(struct device *parent, int bus,
 				      struct pci_ops *ops, void *sysdata);
 struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
-- 
1.7.7

