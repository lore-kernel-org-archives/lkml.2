Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2FZSz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:55:28 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30176 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173Ab2FZSzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:55:25 -0400
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
Subject: [PATCH -v12 08/15] PCI: Strict checking of valid range for bridge
Date: Tue, 26 Jun 2012 11:54:02 -0700
Message-Id: <1340736849-14875-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Children bridges busn range should be allocated from parent bus range.

So we could avoid overlapping between sibling bridges on same bus.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 1cae8fe..98a9911 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -759,6 +759,28 @@ static int __devinit pci_bridge_probe_busn_res(struct pci_bus *bus,
 	return ret;
 }
 
+static int __devinit pci_bridge_check_busn_broken(struct pci_bus *bus,
+				struct pci_dev *dev,
+				int secondary, int subordinate)
+{
+	int ret;
+	struct resource busn_res;
+
+	memset(&busn_res, 0, sizeof(struct resource));
+	dev_printk(KERN_DEBUG, &dev->dev,
+		 "check if busn %02x-%02x is in busn_res: %pR\n",
+		 secondary, subordinate, &bus->busn_res);
+	ret = allocate_resource(&bus->busn_res, &busn_res,
+			 (subordinate - secondary + 1),
+			 secondary, subordinate,
+			 1, NULL, NULL);
+	if (ret)
+		return 1;
+
+	release_resource(&busn_res);
+
+	return 0;
+}
 /*
  * If it's a bridge, configure it and scan the bus behind it.
  * For CardBus bridges, we don't scan behind as the devices will
@@ -797,6 +819,11 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 	    (primary != bus->number || secondary <= bus->number))
 		broken = 1;
 
+	/* more strict checking */
+	if (!pass && !broken && !dev->subordinate)
+		broken = pci_bridge_check_busn_broken(bus, dev,
+						   secondary, subordinate);
+
 	if (broken)
 		dev_dbg(&dev->dev, "bus configuration invalid, reconfiguring\n");
 
-- 
1.7.7

