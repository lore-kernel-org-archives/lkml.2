Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2CEDeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 22:34:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:59254 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982Ab2CEDeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 22:34:22 -0500
Message-ID: <1330918440.11728.87.camel@pasglop>
Subject: Re: linux-next: boot failure for next-20120227 and later (pci tree
 related)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Mon, 05 Mar 2012 14:34:00 +1100
In-Reply-To: <1330725132.11728.52.camel@pasglop>
References: <20120302170638.3d172369d04335d9b921a28c@canb.auug.org.au>
	 <CAErSpo6xQa4Rnv+RkkXCRjQ2HDZdBhorRv2c6pmWyXqRzhM4Vw@mail.gmail.com>
	 <1330725132.11728.52.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-03 at 08:52 +1100, Benjamin Herrenschmidt wrote:

> Or give me a chance to dig :-) I'll have a look next week.

This is indeed what bjorn suspected on irc, this patch fixes it:

(Bjorn, please fold it in the original offending patch)

Cheers,
Ben.

diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index b37d0b5..5dd63f1 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -75,6 +75,7 @@ static void of_pci_parse_addrs(struct device_node *node, struct pci_dev *dev)
 {
 	u64 base, size;
 	unsigned int flags;
+	struct pci_bus_region region;
 	struct resource *res;
 	const u32 *addrs;
 	u32 i;
@@ -106,10 +107,12 @@ static void of_pci_parse_addrs(struct device_node *node, struct pci_dev *dev)
 			printk(KERN_ERR "PCI: bad cfg reg num 0x%x\n", i);
 			continue;
 		}
-		res->start = base;
-		res->end = base + size - 1;
+
 		res->flags = flags;
 		res->name = pci_name(dev);
+		region.start = base;
+		region.end = base + size - 1;
+		pcibios_bus_to_resource(dev, res, &region);
 	}
 }
 
@@ -209,6 +212,7 @@ void __devinit of_scan_pci_bridge(struct pci_dev *dev)
 	struct pci_bus *bus;
 	const u32 *busrange, *ranges;
 	int len, i, mode;
+	struct pci_bus_region region;
 	struct resource *res;
 	unsigned int flags;
 	u64 size;
@@ -270,9 +274,10 @@ void __devinit of_scan_pci_bridge(struct pci_dev *dev)
 			res = bus->resource[i];
 			++i;
 		}
-		res->start = of_read_number(&ranges[1], 2);
-		res->end = res->start + size - 1;
 		res->flags = flags;
+		region.start = of_read_number(&ranges[1], 2);
+		region.end = region.start + size - 1;		
+		pcibios_bus_to_resource(dev, res, &region);
 	}
 	sprintf(bus->name, "PCI Bus %04x:%02x", pci_domain_nr(bus),
 		bus->number);


