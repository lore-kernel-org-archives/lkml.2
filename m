Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab1LGRJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:09:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334Ab1LGRDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:03:21 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:56:00 2011
Message-Id: <20111207165600.688571105@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:54:36 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Joerg Roedel <joerg.roedel@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [03/27] PCI hotplug: shpchp: dont blindly claim non-AMD 0x7450 device IDs
In-Reply-To: <20111207165611.GA19872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 4cac2eb158c6da0c761689345c6cc5df788a6292 upstream.

Previously we claimed device ID 0x7450, regardless of the vendor, which is
clearly wrong.  Now we'll claim that device ID only for AMD.

I suspect this was just a typo in the original code, but it's possible this
change will break shpchp on non-7450 AMD bridges.  If so, we'll have to fix
them as we find them.

Reference: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=638863
Reported-by: Ralf Jung <ralfjung-e@gmx.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/hotplug/shpchp_core.c |    4 ++--
 drivers/pci/hotplug/shpchp_hpc.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -312,8 +312,8 @@ static int get_cur_bus_speed (struct hot
 
 static int is_shpc_capable(struct pci_dev *dev)
 {
-	if ((dev->vendor == PCI_VENDOR_ID_AMD) || (dev->device ==
-						PCI_DEVICE_ID_AMD_GOLAM_7450))
+	if (dev->vendor == PCI_VENDOR_ID_AMD &&
+	    dev->device == PCI_DEVICE_ID_AMD_GOLAM_7450)
 		return 1;
 	if (!pci_find_capability(dev, PCI_CAP_ID_SHPC))
 		return 0;
--- a/drivers/pci/hotplug/shpchp_hpc.c
+++ b/drivers/pci/hotplug/shpchp_hpc.c
@@ -951,8 +951,8 @@ int shpc_init(struct controller *ctrl, s
 	ctrl->pci_dev = pdev;  /* pci_dev of the P2P bridge */
 	ctrl_dbg(ctrl, "Hotplug Controller:\n");
 
-	if ((pdev->vendor == PCI_VENDOR_ID_AMD) || (pdev->device ==
-				PCI_DEVICE_ID_AMD_GOLAM_7450)) {
+	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
+	    pdev->device == PCI_DEVICE_ID_AMD_GOLAM_7450) {
 		/* amd shpc driver doesn't use Base Offset; assume 0 */
 		ctrl->mmio_base = pci_resource_start(pdev, 0);
 		ctrl->mmio_size = pci_resource_len(pdev, 0);


