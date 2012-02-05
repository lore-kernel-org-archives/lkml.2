Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab2BEHCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 02:02:43 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:24828 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2BEHAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 02:00:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 19/24] PCI, pciehp: Remove not needed bus number range checking
Date: Sat,  4 Feb 2012 22:58:03 -0800
Message-Id: <1328425088-6562-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F2E290D.001D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found hotplug adding one EM with bridge fail, bios only leave one bus range
 for slot.

[ 1169.621444] pciehp: No bus number available for hot-added bridge 0000:55:00.0
[ 1169.633277] pcieport 0000:40:03.0: PCI bridge to [bus 55-55]

With busn_res tracking and allocating, we don't need that checking anymore.

Parent bridges' bus number will be extended safely.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/hotplug/pciehp_pci.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index a4031df..df1f3ed 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -37,18 +37,8 @@
 static int __ref pciehp_add_bridge(struct pci_dev *dev)
 {
 	struct pci_bus *parent = dev->bus;
-	int pass, busnr, start = parent->secondary;
-	int end = parent->subordinate;
+	int pass, busnr = parent->secondary;
 
-	for (busnr = start; busnr <= end; busnr++) {
-		if (!pci_find_bus(pci_domain_nr(parent), busnr))
-			break;
-	}
-	if (busnr-- > end) {
-		err("No bus number available for hot-added bridge %s\n",
-				pci_name(dev));
-		return -1;
-	}
 	for (pass = 0; pass < 2; pass++)
 		busnr = pci_scan_bridge(parent, dev, busnr, pass);
 	if (!dev->subordinate)
-- 
1.7.7

