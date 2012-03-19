Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160996Ab2CSFqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:46:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28811 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030884Ab2CSFqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:46:05 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v11 29/30] PCI: More strict checking of valid range for bridge
Date: Sun, 18 Mar 2012 22:43:00 -0700
Message-Id: <1332135781-13695-30-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F66C815.00A8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found one sick system with two sibling bridge have overlaping range from BIOS.
00:02.1 bus range is 0x30-0x30
00:02.2 bus range is 0x30-0x3f, and it have two children under it.

RHEL 6.2 kernel, will just 00:02.1 have child bus 0x30, and bridge 00:02.2 will
not have.

before this patch, this patchset will have 00:02.1 to have bus 0x30,
and 00:02.2 will have reallocate range bus 01.
but 00:02.1 will have scaned at first, so later it will have two fake devices.

To fix the problem, We need to check with unscaned sibling bridge about range
overlapping.
If there is overlapping found, will mark both sides to be broken.
So we could prevent one side take too big range.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8a4e90f..01ba48e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -714,6 +714,48 @@ static int __devinit pci_bridge_probe_busn_res(struct pci_bus *bus,
 	return ret;
 }
 
+static int __devinit pci_bridge_check_busn_broken_with_unscaned(
+				struct pci_bus *bus,
+				struct pci_dev *dev,
+				int secondary, int subordinate)
+{
+	u32 buses2;
+	int broken = 0;
+	struct pci_dev *dev2;
+	int secondary2, subordinate2;
+	int common_start, common_end;
+
+	/* need to check with not scaned sibling bridges */
+	list_for_each_entry(dev2, &bus->devices, bus_list) {
+		if (dev2->hdr_type != PCI_HEADER_TYPE_BRIDGE &&
+		    dev2->hdr_type != PCI_HEADER_TYPE_CARDBUS)
+			continue;
+		if (dev2->subordinate)
+			continue;
+		if (dev2 == dev)
+			continue;
+
+		pci_read_config_dword(dev2, PCI_PRIMARY_BUS, &buses2);
+		secondary2 = (buses2 >> 8) & 0xFF;
+		subordinate2 = (buses2 >> 16) & 0xFF;
+
+		/* overlapping between them ? */
+		common_start = max(secondary, secondary2);
+		common_end = min(subordinate, subordinate2);
+		if (common_start <= common_end) {
+			/*
+			 * Temporarily disable forwarding of the
+			 * configuration cycles on this sibling bridge
+			 */
+			pci_write_config_dword(dev2, PCI_PRIMARY_BUS,
+					       buses2 & ~0xffffff);
+			broken = 1;
+		}
+	}
+
+	return broken;
+}
+
 static int __devinit pci_bridge_check_busn_broken(struct pci_bus *bus,
 				struct pci_dev *dev,
 				int secondary, int subordinate)
@@ -734,7 +776,8 @@ static int __devinit pci_bridge_check_busn_broken(struct pci_bus *bus,
 
 	release_resource(&busn_res);
 
-	return 0;
+	return pci_bridge_check_busn_broken_with_unscaned(bus, dev,
+					secondary, subordinate);
 }
 
 static unsigned int __devinit __pci_scan_child_bus(struct pci_bus *bus,
-- 
1.7.7

