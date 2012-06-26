Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab2FZS4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:56:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37365 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab2FZS4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:56:15 -0400
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
Subject: [PATCH -v12 14/15] PCI: More strict checking of valid range for bridge
Date: Tue, 26 Jun 2012 11:54:08 -0700
Message-Id: <1340736849-14875-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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
index 93b61b8..118fe5b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -743,6 +743,48 @@ static int __devinit pci_bridge_probe_busn_res(struct pci_bus *bus,
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
@@ -763,7 +805,8 @@ static int __devinit pci_bridge_check_busn_broken(struct pci_bus *bus,
 
 	release_resource(&busn_res);
 
-	return 0;
+	return pci_bridge_check_busn_broken_with_unscaned(bus, dev,
+					secondary, subordinate);
 }
 
 static unsigned int __devinit __pci_scan_child_bus(struct pci_bus *bus,
-- 
1.7.7

