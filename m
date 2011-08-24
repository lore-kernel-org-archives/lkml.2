Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab1HXGYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:24:42 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40679 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab1HXGYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:24:37 -0400
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: jbarnes@virtuousgeek.org, ralf@linux-mips.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, eyal@mips.com, zenon@mips.com,
        dengcheng.zhu@gmail.com
Subject: [RFC PATCH 1/3] MIPS: PCI: Use pci_bus_remove_resources()/pci_bus_add_resource() to set up root resources
Date: Wed, 24 Aug 2011 14:24:21 +0800
Message-Id: <1314167063-15785-2-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1314167063-15785-1-git-send-email-dengcheng.zhu@gmail.com>
References: <1314167063-15785-1-git-send-email-dengcheng.zhu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this new style (instead of filling in the pci_bus->resource[] array
directly) to hide some ugly implementation details.

Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
 arch/mips/pci/pci.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 33bba7b..7473214 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -261,6 +261,14 @@ static void pcibios_fixup_device_resources(struct pci_dev *dev,
 	}
 }
 
+static void __devinit
+pcibios_setup_root_resources(struct pci_bus *bus, struct pci_controller *ctrl)
+{
+	pci_bus_remove_resources(bus);
+	pci_bus_add_resource(bus, ctrl->io_resource, 0);
+	pci_bus_add_resource(bus, ctrl->mem_resource, 0);
+}
+
 void __devinit pcibios_fixup_bus(struct pci_bus *bus)
 {
 	/* Propagate hose info into the subordinate devices.  */
@@ -270,8 +278,7 @@ void __devinit pcibios_fixup_bus(struct pci_bus *bus)
 	struct pci_dev *dev = bus->self;
 
 	if (!dev) {
-		bus->resource[0] = hose->io_resource;
-		bus->resource[1] = hose->mem_resource;
+		pcibios_setup_root_resources(bus, hose);
 	} else if (pci_probe_only &&
 		   (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
 		pci_read_bridge_bases(bus);
-- 
1.7.1

