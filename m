Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab1JKRDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:03:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab1JKRDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:03:51 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:09 2011
Message-Id: <20111011165709.236967330@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:16 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jon Mason <mason@myri.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [06/38] PCI: Disable MPS configuration by default
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jon Mason <mason@myri.com>

commit 5f39e6705faade2e89d119958a8c51b9b6e2c53c upstream.

Add the ability to disable PCI-E MPS turning and using the BIOS
configured MPS defaults.  Due to the number of issues recently
discovered on some x86 chipsets, make this the default behavior.

Also, add the option for peer to peer DMA MPS configuration.  Peer to
peer DMA is outside the scope of this patch, but MPS configuration could
prevent it from working by having the MPS on one root port different
than the MPS on another.  To work around this, simply make the system
wide MPS the smallest possible value (128B).

Signed-off-by: Jon Mason <mason@myri.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci.c   |    6 +++++-
 drivers/pci/probe.c |   14 +++++++++++++-
 include/linux/pci.h |    3 ++-
 3 files changed, 20 insertions(+), 3 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -77,7 +77,7 @@ unsigned long pci_cardbus_mem_size = DEF
 unsigned long pci_hotplug_io_size  = DEFAULT_HOTPLUG_IO_SIZE;
 unsigned long pci_hotplug_mem_size = DEFAULT_HOTPLUG_MEM_SIZE;
 
-enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_SAFE;
+enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_TUNE_OFF;
 
 /*
  * The default CLS is used if arch didn't set CLS explicitly and not
@@ -3568,10 +3568,14 @@ static int __init pci_setup(char *str)
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
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1459,12 +1459,24 @@ static int pcie_bus_configure_set(struct
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
 


