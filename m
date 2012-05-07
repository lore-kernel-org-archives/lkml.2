Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab2EGUcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:32:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51090 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab2EGUah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:37 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        sparclinux@vger.kernel.org
Subject: [PATCH 16/21] sparc/PCI: register busn_res for root buses
Date: Mon,  7 May 2012 13:30:01 -0700
Message-Id: <1336422606-4244-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the host bridge bus number aperture to the resource list.
Like the MMIO and I/O port apertures, this is used when assigning
resources to hot-added devices or in the case of conflicts.

[bhelgaas: write changelog]
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/kernel/pci.c      |    8 +++++---
 arch/sparc/kernel/pci_impl.h |    1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index c85bfd7..74e4bf3 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -535,7 +535,7 @@ static void __devinit of_scan_pci_bridge(struct pci_pbm_info *pbm,
 	}
 
 	bus->primary = dev->bus->number;
-	bus->busn_res.end = busrange[1];
+	pci_bus_insert_busn_res(bus, busrange[0], busrange[1]);
 	bus->bridge_ctl = 0;
 
 	/* parse ranges property, or cook one up by hand for Simba */
@@ -685,6 +685,10 @@ struct pci_bus * __devinit pci_scan_one_pbm(struct pci_pbm_info *pbm,
 				pbm->io_space.start);
 	pci_add_resource_offset(&resources, &pbm->mem_space,
 				pbm->mem_space.start);
+	pbm->busn.start = pbm->pci_first_busno;
+	pbm->busn.end	= pbm->pci_last_busn;
+	pbm->busn.flags	= IORESOURCE_BUS;
+	pci_add_resource(&resources, &pbm->busn);
 	bus = pci_create_root_bus(parent, pbm->pci_first_busno, pbm->pci_ops,
 				  pbm, &resources);
 	if (!bus) {
@@ -693,8 +697,6 @@ struct pci_bus * __devinit pci_scan_one_pbm(struct pci_pbm_info *pbm,
 		pci_free_resource_list(&resources);
 		return NULL;
 	}
-	bus->busn_res.start = pbm->pci_first_busno;
-	bus->busn_res.end = pbm->pci_last_busno;
 
 	pci_of_scan_bus(pbm, node, bus);
 	pci_bus_add_devices(bus);
diff --git a/arch/sparc/kernel/pci_impl.h b/arch/sparc/kernel/pci_impl.h
index 6beb60d..918a203 100644
--- a/arch/sparc/kernel/pci_impl.h
+++ b/arch/sparc/kernel/pci_impl.h
@@ -97,6 +97,7 @@ struct pci_pbm_info {
 	/* PBM I/O and Memory space resources. */
 	struct resource			io_space;
 	struct resource			mem_space;
+	struct resource			busn;
 
 	/* Base of PCI Config space, can be per-PBM or shared. */
 	unsigned long			config_space;
-- 
1.7.7

