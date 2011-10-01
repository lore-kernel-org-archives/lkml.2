Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab1JATX5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:23:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51544 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab1JATXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:23:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 09/11] ARM: pci: always export pcibios_bus_to_resource
Date: Sat,  1 Oct 2011 21:21:58 +0200
Message-Id: <1317496920-7764-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317496920-7764-1-git-send-email-arnd@arndb.de>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:rchvz3DfTdQcnlOZM3cbQ449Z/7hYf2MKDFagdo+vV9
 RM2KJT81FufnQhqJ2DpEkRwuL9xxVElmJ3r0el5RyMWjXA63V/
 2WA1I/7GoyNnxbWv5/WqhiHNCw7AUnKyjnxWcSVbRoU0NU0inV
 m/k22UelUnERJsyiOO/BeWD2i2RC7BroGqcfFuJJsAxhSDaO4H
 sRPM+L3Fh8GU86tWr1eFR2jEfZnov7B3k3Lns6GjdVvjn75Dww
 7fdDpIwZW28qcMSdIObBwd94Gl1iJP+EWGsdxvjhBrJMrlk8h0
 4M5QpXGfh8WLNUyrnkFEkBYB4amalHs/32jDQ98QL2dehLt2MG
 7soSTywkZ5JvG+vG6TtrsmJBIaALFEQioU9jAap0JGkjlroVQ1
 V+DfP3sS7/SXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PCI drivers call pcibios_bus_to_resource directly,
but it is only exported when CONFIG_HOTPLUG is set,
because it was initially mean for pccard support.

Moving the export out of the #ifdef lets us avoid these
build errors:

ERROR: "pcibios_bus_to_resource" [drivers/video/vt8623fb.ko] undefined!
ERROR: "pcibios_bus_to_resource" [drivers/video/arkfb.ko] undefined!
ERROR: "pcibios_bus_to_resource" [drivers/video/s3fb.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/kernel/bios32.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index d6df359..c0d9203 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -412,6 +412,9 @@ void pcibios_fixup_bus(struct pci_bus *bus)
 	printk(KERN_INFO "PCI: bus%d: Fast back to back transfers %sabled\n",
 		bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
 }
+#ifdef CONFIG_HOTPLUG
+EXPORT_SYMBOL(pcibios_fixup_bus);
+#endif
 
 /*
  * Convert from Linux-centric to bus-centric addresses for bridge devices.
@@ -431,6 +434,7 @@ pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
 	region->start = res->start - offset;
 	region->end   = res->end - offset;
 }
+EXPORT_SYMBOL(pcibios_resource_to_bus);
 
 void __devinit
 pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
@@ -447,12 +451,7 @@ pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 	res->start = region->start + offset;
 	res->end   = region->end + offset;
 }
-
-#ifdef CONFIG_HOTPLUG
-EXPORT_SYMBOL(pcibios_fixup_bus);
-EXPORT_SYMBOL(pcibios_resource_to_bus);
 EXPORT_SYMBOL(pcibios_bus_to_resource);
-#endif
 
 /*
  * Swizzle the device pin each time we cross a bridge.
-- 
1.7.5.4

