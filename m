Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965749Ab2B2XJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:09:44 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:26028 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964869Ab2B2XIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:08:48 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 28/39] PCI, powerpc: Register busn_res for root buses
Date: Wed, 29 Feb 2012 15:07:27 -0800
Message-Id: <1330556858-11768-29-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090202.4F4EAFEC.0072,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/include/asm/pci-bridge.h |    1 +
 arch/powerpc/kernel/pci-common.c      |   10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
index 5d48765..11cebf0 100644
--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -30,6 +30,7 @@ struct pci_controller {
 	int first_busno;
 	int last_busno;
 	int self_busno;
+	struct resource busn;
 
 	void __iomem *io_base_virt;
 #ifdef CONFIG_PPC64
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 910b9de..ee8c0c9 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1648,6 +1648,11 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
 	/* Wire up PHB bus resources */
 	pcibios_setup_phb_resources(hose, &resources);
 
+	hose->busn.start = hose->first_busno;
+	hose->busn.end	 = hose->last_busno;
+	hose->busn.flags = IORESOURCE_BUS;
+	pci_add_resource(&resources, &hose->busn);
+
 	/* Create an empty bus for the toplevel */
 	bus = pci_create_root_bus(hose->parent, hose->first_busno,
 				  hose->ops, hose, &resources);
@@ -1670,8 +1675,11 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
 		of_scan_bus(node, bus);
 	}
 
-	if (mode == PCI_PROBE_NORMAL)
+	if (mode == PCI_PROBE_NORMAL) {
+		pci_bus_update_busn_res_end(bus, 255);
 		hose->last_busno = bus->subordinate = pci_scan_child_bus(bus);
+		pci_bus_update_busn_res_end(bus, bus->subordinate);
+	}
 
 	/* Platform gets a chance to do some global fixups before
 	 * we proceed to resource allocation
-- 
1.7.7

