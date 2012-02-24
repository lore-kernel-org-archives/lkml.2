Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab2BXKUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:20:30 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:17019 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab2BXKUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:20:23 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 22/23] PCI: make pci_rescan_bus_bridge_resize use pci_scan_bridge instead
Date: Fri, 24 Feb 2012 02:19:10 -0800
Message-Id: <1330078751-7299-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330078751-7299-1-git-send-email-yinghai@kernel.org>
References: <1330078751-7299-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F47645D.0091,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So after remove all children and then using setpci change bus register and rescan
bridge could use new set bus number.

Otherwise need to rescan parent bus, it would have too much overhead.

also need to use pci_bus_add_single_device to make sure new change bus have directory
 /sys/../.../pci_bus.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 1c36b39..8063cf1 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1961,14 +1961,16 @@ EXPORT_SYMBOL(pci_scan_bus);
  */
 unsigned int __ref pci_rescan_bus_bridge_resize(struct pci_dev *bridge)
 {
-	unsigned int max;
-	struct pci_bus *bus = bridge->subordinate;
+	unsigned int max = 0;
+	int pass;
+	struct pci_bus *bus = bridge->bus;
 
-	max = pci_scan_child_bus(bus);
+	for (pass = 0; pass < 2; pass++)
+		max = pci_scan_bridge(bus, bridge, max, pass);
 
 	pci_assign_unassigned_bridge_resources(bridge);
 
-	pci_bus_add_devices(bus);
+	pci_bus_add_single_device(bridge);
 
 	return max;
 }
-- 
1.7.7

