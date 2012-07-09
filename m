Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab2GIUcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:32:42 -0400
Received: from mail-gh0-f202.google.com ([209.85.160.202]:47760 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab2GIUcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:32:10 -0400
Subject: [PATCH 2/3] PCI: reimplement P2P bridge 1K I/O windows (Intel P64H2)
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Daniel Yeisley <dan.yeisley@unisys.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date: Mon, 09 Jul 2012 14:32:09 -0600
Message-ID: <20120709203208.28178.94320.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20120709202308.28178.58942.stgit@bhelgaas.mtv.corp.google.com>
References: <20120709202308.28178.58942.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

9d265124d051 and 15a260d53f7c added quirks for P2P bridges that support
I/O windows that start/end at 1K boundaries, not just the 4K boundaries
defined by the PCI spec.  For details, see the IOBL_ADR register and the
EN1K bit in the CNF register in the Intel 82870P2 (P64H2).

These quirks complicate the code that reads P2P bridge windows
(pci_read_bridge_io() and pci_cfg_fake_ranges()) because the bridge
I/O resource is updated in the HEADER quirk, in pci_read_bridge_io(),
in pci_setup_bridge(), and again in the FINAL quirk.  This is confusing
and makes it impossible to reassign the bridge windows after FINAL
quirks are run.

This patch adds support for 1K windows in the generic paths, so the
HEADER quirk only has to enable this support.  The FINAL quirk, which
used to undo damage done by pci_setup_bridge(), is no longer needed.

This removes "if (!res->start) res->start = ..." from pci_read_bridge_io();
that was part of 9d265124d051 to avoid overwriting the resource filled in
by the quirk.  Since pci_read_bridge_io() itself now knows about
granularity, the quirk no longer updates the resource and this test is no
longer needed.

Note that the bridge window assignment code, e.g., pbus_size_io(), should
pay attention to dev->io_window_1k, too, but I didn't fix that.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c      |   25 ++++++++++++++-----------
 drivers/pci/quirks.c     |   39 +--------------------------------------
 drivers/pci/setup-bus.c  |   11 +++++++++--
 include/linux/pci.h      |    1 +
 include/linux/pci_regs.h |    3 ++-
 5 files changed, 27 insertions(+), 52 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 9c5d2a9..ef24cf7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -269,15 +269,23 @@ static void __devinit pci_read_bridge_io(struct pci_bus *child)
 {
 	struct pci_dev *dev = child->self;
 	u8 io_base_lo, io_limit_lo;
-	unsigned long base, limit;
+	unsigned long io_mask, io_granularity, base, limit;
 	struct pci_bus_region region;
-	struct resource *res, res2;
+	struct resource *res;
+
+	io_mask = PCI_IO_RANGE_MASK;
+	io_granularity = 0x1000;
+	if (dev->io_window_1k) {
+		/* Support 1K I/O space granularity */
+		io_mask = PCI_IO_1K_RANGE_MASK;
+		io_granularity = 0x400;
+	}
 
 	res = child->resource[0];
 	pci_read_config_byte(dev, PCI_IO_BASE, &io_base_lo);
 	pci_read_config_byte(dev, PCI_IO_LIMIT, &io_limit_lo);
-	base = (io_base_lo & PCI_IO_RANGE_MASK) << 8;
-	limit = (io_limit_lo & PCI_IO_RANGE_MASK) << 8;
+	base = (io_base_lo & io_mask) << 8;
+	limit = (io_limit_lo & io_mask) << 8;
 
 	if ((io_base_lo & PCI_IO_RANGE_TYPE_MASK) == PCI_IO_RANGE_TYPE_32) {
 		u16 io_base_hi, io_limit_hi;
@@ -289,14 +297,9 @@ static void __devinit pci_read_bridge_io(struct pci_bus *child)
 
 	if (base <= limit) {
 		res->flags = (io_base_lo & PCI_IO_RANGE_TYPE_MASK) | IORESOURCE_IO;
-		res2.flags = res->flags;
 		region.start = base;
-		region.end = limit + 0xfff;
-		pcibios_bus_to_resource(dev, &res2, &region);
-		if (!res->start)
-			res->start = res2.start;
-		if (!res->end)
-			res->end = res2.end;
+		region.end = limit + io_granularity - 1;
+		pcibios_bus_to_resource(dev, res, &region);
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
 	}
 }
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 2a75216..356846b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1938,53 +1938,16 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NCR, PCI_DEVICE_ID_NCR_53C810, fixup_rev1
 static void __devinit quirk_p64h2_1k_io(struct pci_dev *dev)
 {
 	u16 en1k;
-	u8 io_base_lo, io_limit_lo;
-	unsigned long base, limit;
-	struct resource *res = dev->resource + PCI_BRIDGE_RESOURCES;
 
 	pci_read_config_word(dev, 0x40, &en1k);
 
 	if (en1k & 0x200) {
 		dev_info(&dev->dev, "Enable I/O Space to 1KB granularity\n");
-
-		pci_read_config_byte(dev, PCI_IO_BASE, &io_base_lo);
-		pci_read_config_byte(dev, PCI_IO_LIMIT, &io_limit_lo);
-		base = (io_base_lo & (PCI_IO_RANGE_MASK | 0x0c)) << 8;
-		limit = (io_limit_lo & (PCI_IO_RANGE_MASK | 0x0c)) << 8;
-
-		if (base <= limit) {
-			res->start = base;
-			res->end = limit + 0x3ff;
-		}
+		dev->io_window_1k = 1;
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	0x1460,		quirk_p64h2_1k_io);
 
-/* Fix the IOBL_ADR for 1k I/O space granularity on the Intel P64H2
- * The IOBL_ADR gets re-written to 4k boundaries in pci_setup_bridge()
- * in drivers/pci/setup-bus.c
- */
-static void __devinit quirk_p64h2_1k_io_fix_iobl(struct pci_dev *dev)
-{
-	u16 en1k, iobl_adr, iobl_adr_1k;
-	struct resource *res = dev->resource + PCI_BRIDGE_RESOURCES;
-
-	pci_read_config_word(dev, 0x40, &en1k);
-
-	if (en1k & 0x200) {
-		pci_read_config_word(dev, PCI_IO_BASE, &iobl_adr);
-
-		iobl_adr_1k = iobl_adr | (res->start >> 8) | (res->end & 0xfc00);
-
-		if (iobl_adr != iobl_adr_1k) {
-			dev_info(&dev->dev, "Fixing P64H2 IOBL_ADR from 0x%x to 0x%x for 1KB granularity\n",
-				iobl_adr,iobl_adr_1k);
-			pci_write_config_word(dev, PCI_IO_BASE, iobl_adr_1k);
-		}
-	}
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x1460,		quirk_p64h2_1k_io_fix_iobl);
-
 /* Under some circumstances, AER is not linked with extended capabilities.
  * Force it to be linked by setting the corresponding control bit in the
  * config space.
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 8fa2d4b..dad5425 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -469,16 +469,23 @@ static void pci_setup_bridge_io(struct pci_bus *bus)
 	struct pci_dev *bridge = bus->self;
 	struct resource *res;
 	struct pci_bus_region region;
+	unsigned long io_mask;
+	u8 io_base_lo, io_limit_lo;
 	u32 l, io_upper16;
 
+	io_mask = PCI_IO_RANGE_MASK;
+	if (bridge->io_window_1k)
+		io_mask = PCI_IO_1K_RANGE_MASK;
+
 	/* Set up the top and bottom of the PCI I/O segment for this bus. */
 	res = bus->resource[0];
 	pcibios_resource_to_bus(bridge, &region, res);
 	if (res->flags & IORESOURCE_IO) {
 		pci_read_config_dword(bridge, PCI_IO_BASE, &l);
 		l &= 0xffff0000;
-		l |= (region.start >> 8) & 0x00f0;
-		l |= region.end & 0xf000;
+		io_base_lo = (region.start >> 8) & io_mask;
+		io_limit_lo = (region.end >> 8) & io_mask;
+		l |= ((u32) io_limit_lo << 8) | io_base_lo;
 		/* Set up upper 16 bits of I/O base/limit. */
 		io_upper16 = (region.end & 0xffff0000) | (region.start >> 16);
 		dev_info(&bridge->dev, "  bridge window %pR\n", res);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d8c379d..89b46fd 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -324,6 +324,7 @@ struct pci_dev {
 	unsigned int    is_hotplug_bridge:1;
 	unsigned int    __aer_firmware_first_valid:1;
 	unsigned int	__aer_firmware_first:1;
+	unsigned int	io_window_1k:1;	/* Intel P2P bridge 1K I/O windows */
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 4b608f5..88c9ea5 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -125,7 +125,8 @@
 #define  PCI_IO_RANGE_TYPE_MASK	0x0fUL	/* I/O bridging type */
 #define  PCI_IO_RANGE_TYPE_16	0x00
 #define  PCI_IO_RANGE_TYPE_32	0x01
-#define  PCI_IO_RANGE_MASK	(~0x0fUL)
+#define  PCI_IO_RANGE_MASK	(~0x0fUL) /* Standard 4K I/O windows */
+#define  PCI_IO_1K_RANGE_MASK	(~0x03UL) /* Intel 1K I/O windows */
 #define PCI_SEC_STATUS		0x1e	/* Secondary status register, only bit 14 used */
 #define PCI_MEMORY_BASE		0x20	/* Memory range behind */
 #define PCI_MEMORY_LIMIT	0x22

