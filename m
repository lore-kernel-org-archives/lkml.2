Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab2EGUau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:30:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18616 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab2EGUam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:42 -0400
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
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 19/21] tile/PCI: Use pci_scan_root_bus instead pci_scan_bus
Date: Mon,  7 May 2012 13:30:04 -0700
Message-Id: <1336422606-4244-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will update busn_res accordingly, so we get that for last_busno.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index 7aa2743..4a951b87 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -310,6 +310,7 @@ int __devinit pcibios_init(void)
 		if (pci_scan_flags[i] == 0 && controllers[i].ops != NULL) {
 			struct pci_controller *controller = &controllers[i];
 			struct pci_bus *bus;
+			LIST_HEAD(resources);
 
 			if (tile_init_irqs(i, controller)) {
 				pr_err("PCI: Could not initialize IRQs\n");
@@ -327,7 +328,9 @@ int __devinit pcibios_init(void)
 			 * This is inlined in linux/pci.h and calls into
 			 * pci_scan_bus_parented() in probe.c.
 			 */
-			bus = pci_scan_bus(0, controller->ops, controller);
+			pci_add_resource(&resources, &ioport_resource);
+			pci_add_resource(&resources, &iomem_resource);
+			bus = pci_scan_root_bus(NULL, 0, controller->ops, controller, &resources);
 			controller->root_bus = bus;
 			controller->last_busno = bus->busn_res.end;
 		}
-- 
1.7.7

