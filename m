Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab1JCOvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:51:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42678 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab1JCOuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:50:50 -0400
From: Jon Mason <mason@myri.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 3/3] PCI: Disable MPS configuration by default
Date: Mon,  3 Oct 2011 09:50:20 -0500
Message-Id: <1317653420-21404-4-git-send-email-mason@myri.com>
X-Mailer: git-send-email 1.7.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ability to disable PCI-E MPS turning and using the BIOS
configured MPS defaults.  Due to the number of issues recently
discovered on some x86 chipsets, make this the default behavior.

Also, add the option for peer to peer DMA MPS configuration.  Peer to
peer DMA is outside the scope of this patch, but MPS configuration could
prevent it from working by having the MPS on one root port different
than the MPS on another.  To work around this, simply make the system
wide MPS the smallest possible value (128B).

Signed-off-by: Jon Mason <mason@myri.com>
---
 drivers/pci/pci.c   |    6 +++++-
 drivers/pci/probe.c |   14 +++++++++++++-
 include/linux/pci.h |    3 ++-
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d369316..5db5986 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -77,7 +77,7 @@ unsigned long pci_cardbus_mem_size = DEFAULT_CARDBUS_MEM_SIZE;
 unsigned long pci_hotplug_io_size  = DEFAULT_HOTPLUG_IO_SIZE;
 unsigned long pci_hotplug_mem_size = DEFAULT_HOTPLUG_MEM_SIZE;
 
-enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_SAFE;
+enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_TUNE_OFF;
 
 /*
  * The default CLS is used if arch didn't set CLS explicitly and not
@@ -3582,10 +3582,14 @@ static int __init pci_setup(char *str)
 				pci_hotplug_io_size = memparse(str + 9, &str);
 			} else if (!strncmp(str, "hpmemsize=", 10)) {
 				pci_hotplug_mem_size = memparse(str + 10, &str);
+			} else if (!strncmp(str, "pcie_bus_tune_off", 17)) {
+				pcie_bus_config = PCIE_BUS_TUNE_OFF;
 			} else if (!strncmp(str, "pcie_bus_safe", 13)) {
 				pcie_bus_config = PCIE_BUS_SAFE;
 			} else if (!strncmp(str, "pcie_bus_perf", 13)) {
 				pcie_bus_config = PCIE_BUS_PERFORMANCE;
+			} else if (!strncmp(str, "pcie_bus_peer2peer", 18)) {
+				pcie_bus_config = PCIE_BUS_PEER2PEER;
 			} else {
 				printk(KERN_ERR "PCI: Unknown option `%s'\n",
 						str);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a919db2..4829424 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1451,12 +1451,24 @@ static int pcie_bus_configure_set(struct pci_dev *dev, void *data)
  */
 void pcie_bus_configure_settings(struct pci_bus *bus, u8 mpss)
 {
-	u8 smpss = mpss;
+	u8 smpss;
 
 	if (!pci_is_pcie(bus->self))
 		return;
 
+	if (pcie_bus_config == PCIE_BUS_TUNE_OFF)
+		return;
+
+	/* FIXME - Peer to peer DMA is possible, though the endpoint would need
+	 * to be aware to the MPS of the destination.  To work around this,
+	 * simply force the MPS of the entire system to the smallest possible.
+	 */
+	if (pcie_bus_config == PCIE_BUS_PEER2PEER)
+		smpss = 0;
+
 	if (pcie_bus_config == PCIE_BUS_SAFE) {
+		smpss = mpss;
+
 		pcie_find_smpss(bus->self, &smpss);
 		pci_walk_bus(bus, pcie_find_smpss, &smpss);
 	}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8c230cb..9fc0122 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -621,8 +621,9 @@ struct pci_driver {
 extern void pcie_bus_configure_settings(struct pci_bus *bus, u8 smpss);
 
 enum pcie_bus_config_types {
-	PCIE_BUS_PERFORMANCE,
+	PCIE_BUS_TUNE_OFF,
 	PCIE_BUS_SAFE,
+	PCIE_BUS_PERFORMANCE,
 	PCIE_BUS_PEER2PEER,
 };
 
-- 
1.7.6.2

