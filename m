Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2EGUbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:31:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51108 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289Ab2EGUak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:40 -0400
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
Subject: [PATCH 21/21] PCI: insert busn_res for child bus
Date: Mon,  7 May 2012 13:30:06 -0700
Message-Id: <1336422606-4244-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we can insert busn_res now, after all root bus's get inserted.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 9f68b9d..0840409 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -755,7 +755,7 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 			if (!child)
 				goto out;
 			child->primary = primary;
-			child->busn_res.end = subordinate;
+			pci_bus_insert_busn_res(child, secondary, subordinate);
 			child->bridge_ctl = bctl;
 		}
 
@@ -793,6 +793,7 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 			child = pci_add_new_bus(bus, dev, ++max);
 			if (!child)
 				goto out;
+			pci_bus_insert_busn_res(child, max, 0xff);
 		}
 		buses = (buses & 0xff000000)
 		      | ((unsigned int)(child->primary)     <<  0)
@@ -864,7 +865,7 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		/*
 		 * Set the subordinate bus number to its real value.
 		 */
-		child->busn_res.end = max;
+		pci_bus_update_busn_res_end(child, max);
 		pci_write_config_byte(dev, PCI_SUBORDINATE_BUS, max);
 	}
 
-- 
1.7.7

