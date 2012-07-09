Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab2GIUcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:32:20 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:48588 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2GIUcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:32:16 -0400
Subject: [PATCH 3/3] sparc/PCI: replace pci_cfg_fake_ranges() with
	pci_read_bridge_bases()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: sparclinux@vger.kernel.org, Daniel Yeisley <dan.yeisley@unisys.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 09 Jul 2012 14:32:14 -0600
Message-ID: <20120709203214.28178.71922.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20120709202308.28178.58942.stgit@bhelgaas.mtv.corp.google.com>
References: <20120709202308.28178.58942.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic code to read P2P bridge windows is functionally equivalent
to the sparc-specific pci_cfg_fake_ranges(), so use the generic code.

The "if (!res->start) res->start = ..." removed from the I/O window code
here was an artifact of the Intel 1K window support from 9d265124d051 and
is no longer necessary (it probably was just cloned from x86 and was never
useful on sparc).

CC: "David S. Miller" <davem@davemloft.net>
CC: sparclinux@vger.kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/sparc/kernel/pci.c |   89 +----------------------------------------------
 1 files changed, 1 insertions(+), 88 deletions(-)

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index fdaf218..fa53d55 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -375,93 +375,6 @@ static void __devinit apb_calc_first_last(u8 map, u32 *first_p, u32 *last_p)
 	*last_p = last;
 }
 
-/* For PCI bus devices which lack a 'ranges' property we interrogate
- * the config space values to set the resources, just like the generic
- * Linux PCI probing code does.
- */
-static void __devinit pci_cfg_fake_ranges(struct pci_dev *dev,
-					  struct pci_bus *bus,
-					  struct pci_pbm_info *pbm)
-{
-	struct pci_bus_region region;
-	struct resource *res, res2;
-	u8 io_base_lo, io_limit_lo;
-	u16 mem_base_lo, mem_limit_lo;
-	unsigned long base, limit;
-
-	pci_read_config_byte(dev, PCI_IO_BASE, &io_base_lo);
-	pci_read_config_byte(dev, PCI_IO_LIMIT, &io_limit_lo);
-	base = (io_base_lo & PCI_IO_RANGE_MASK) << 8;
-	limit = (io_limit_lo & PCI_IO_RANGE_MASK) << 8;
-
-	if ((io_base_lo & PCI_IO_RANGE_TYPE_MASK) == PCI_IO_RANGE_TYPE_32) {
-		u16 io_base_hi, io_limit_hi;
-
-		pci_read_config_word(dev, PCI_IO_BASE_UPPER16, &io_base_hi);
-		pci_read_config_word(dev, PCI_IO_LIMIT_UPPER16, &io_limit_hi);
-		base |= (io_base_hi << 16);
-		limit |= (io_limit_hi << 16);
-	}
-
-	res = bus->resource[0];
-	if (base <= limit) {
-		res->flags = (io_base_lo & PCI_IO_RANGE_TYPE_MASK) | IORESOURCE_IO;
-		res2.flags = res->flags;
-		region.start = base;
-		region.end = limit + 0xfff;
-		pcibios_bus_to_resource(dev, &res2, &region);
-		if (!res->start)
-			res->start = res2.start;
-		if (!res->end)
-			res->end = res2.end;
-	}
-
-	pci_read_config_word(dev, PCI_MEMORY_BASE, &mem_base_lo);
-	pci_read_config_word(dev, PCI_MEMORY_LIMIT, &mem_limit_lo);
-	base = (mem_base_lo & PCI_MEMORY_RANGE_MASK) << 16;
-	limit = (mem_limit_lo & PCI_MEMORY_RANGE_MASK) << 16;
-
-	res = bus->resource[1];
-	if (base <= limit) {
-		res->flags = ((mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) |
-			      IORESOURCE_MEM);
-		region.start = base;
-		region.end = limit + 0xfffff;
-		pcibios_bus_to_resource(dev, res, &region);
-	}
-
-	pci_read_config_word(dev, PCI_PREF_MEMORY_BASE, &mem_base_lo);
-	pci_read_config_word(dev, PCI_PREF_MEMORY_LIMIT, &mem_limit_lo);
-	base = (mem_base_lo & PCI_PREF_RANGE_MASK) << 16;
-	limit = (mem_limit_lo & PCI_PREF_RANGE_MASK) << 16;
-
-	if ((mem_base_lo & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64) {
-		u32 mem_base_hi, mem_limit_hi;
-
-		pci_read_config_dword(dev, PCI_PREF_BASE_UPPER32, &mem_base_hi);
-		pci_read_config_dword(dev, PCI_PREF_LIMIT_UPPER32, &mem_limit_hi);
-
-		/*
-		 * Some bridges set the base > limit by default, and some
-		 * (broken) BIOSes do not initialize them.  If we find
-		 * this, just assume they are not being used.
-		 */
-		if (mem_base_hi <= mem_limit_hi) {
-			base |= ((long) mem_base_hi) << 32;
-			limit |= ((long) mem_limit_hi) << 32;
-		}
-	}
-
-	res = bus->resource[2];
-	if (base <= limit) {
-		res->flags = ((mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) |
-			      IORESOURCE_MEM | IORESOURCE_PREFETCH);
-		region.start = base;
-		region.end = limit + 0xfffff;
-		pcibios_bus_to_resource(dev, res, &region);
-	}
-}
-
 /* Cook up fake bus resources for SUNW,simba PCI bridges which lack
  * a proper 'ranges' property.
  */
@@ -550,7 +463,7 @@ static void __devinit of_scan_pci_bridge(struct pci_pbm_info *pbm,
 		apb_fake_ranges(dev, bus, pbm);
 		goto after_ranges;
 	} else if (ranges == NULL) {
-		pci_cfg_fake_ranges(dev, bus, pbm);
+		pci_read_bridge_bases(bus);
 		goto after_ranges;
 	}
 	i = 1;

