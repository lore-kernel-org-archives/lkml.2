Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965622Ab2B1CLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:11:41 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:48960 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965497Ab2B1CLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:11:32 -0500
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
Subject: [PATCH 17/18] PCI: Double checking setting for bus register and bus struct.
Date: Mon, 27 Feb 2012 18:10:08 -0800
Message-Id: <1330395009-29260-18-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
References: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F4C37CA.00A4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User could use setpci change bridge's bus register. that could make value of register
and struct is out of sync.
User later will use rescan to see the devices is moving.

In the rescaning, we need to double check the range and remove the old struct at first.

to make thing working user may need have script to remove children devices under bridge
at first, and then use setpci update bus register and then rescan.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a4ecae0..554839e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -843,6 +843,46 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 	    (primary != bus->number || secondary <= bus->number))
 		broken = 1;
 
+	if (!pass && dev->subordinate) {
+		child = dev->subordinate;
+		/*
+		 * User could change bus register in bridge manually with
+		 * setpci and rescan. So double check the setting, and remove
+		 * old structs.  Don't set broken yet, let following check
+		 * to see if the new setting good.
+		 */
+		if (primary != child->primary ||
+		    secondary != child->secondary ||
+		    subordinate != child->subordinate) {
+			dev_info(&dev->dev,
+				"someone changed bus register from pri:%02x, sec:%02x, sub:%02x to pri:%02x, sec:%02x, sub:%02x\n",
+				child->primary, child->secondary, child->subordinate,
+				primary, secondary, subordinate);
+			if (!list_empty(&dev->subordinate->devices)) {
+				u32 old_buses;
+
+				dev_info(&dev->dev,
+				 "but children devices are not removed manually before that.\n");
+				/*
+				 * Try best to remove left children devices
+				 * but we need to set bus register back, otherwise
+				 * We can not access children device and stop them
+				 */
+				old_buses = (buses & 0xff000000)
+				   | ((unsigned int)(child->primary)     <<  0)
+				   | ((unsigned int)(child->secondary)   <<  8)
+				   | ((unsigned int)(child->subordinate) << 16);
+				pci_write_config_dword(dev, PCI_PRIMARY_BUS,
+							 old_buses);
+				pci_stop_and_remove_behind_bridge(dev);
+				pci_write_config_dword(dev, PCI_PRIMARY_BUS,
+							 buses);
+			}
+			pci_remove_bus(dev->subordinate);
+			dev->subordinate = NULL;
+		}
+	}
+
 	/* more strict checking */
 	if (!pass && !broken && !dev->subordinate)
 		broken = pci_bridge_check_busn_broken(bus, dev,
-- 
1.7.7

