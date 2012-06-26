Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab2FZS4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:56:22 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30591 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab2FZS4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:56:17 -0400
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
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v12 15/15] PCI: Don't shrink too much for hotplug bridge
Date: Tue, 26 Jun 2012 11:54:09 -0700
Message-Id: <1340736849-14875-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise may have problem later if we plug pcie cards with bridges.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 118fe5b..f66f1b1 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -811,6 +811,7 @@ static int __devinit pci_bridge_check_busn_broken(struct pci_bus *bus,
 
 static unsigned int __devinit __pci_scan_child_bus(struct pci_bus *bus,
 						 int pass);
+#define HOTPLUG_BRIDGE_RESERVE_BUSNR 8
 /*
  * If it's a bridge, configure it and scan the bus behind it.
  * For CardBus bridges, we don't scan behind as the devices will
@@ -1019,6 +1020,11 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		/*
 		 * Set the subordinate bus number to its real value.
 		 */
+		if (dev->is_hotplug_bridge && child->busn_res.end > max &&
+		   (max - child->busn_res.start) < HOTPLUG_BRIDGE_RESERVE_BUSNR)
+			max = min_t(int, child->busn_res.start +
+					 HOTPLUG_BRIDGE_RESERVE_BUSNR,
+				    child->busn_res.end);
 		shrink_size = (int)child->busn_res.end - max;
 		pci_write_config_byte(dev, PCI_SUBORDINATE_BUS, max);
 		pci_bus_update_busn_res_end(child, max);
-- 
1.7.7

