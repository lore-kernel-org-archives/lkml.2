Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab1LGQt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:49:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757669Ab1LGQUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:20:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:15 2011
Message-Id: <20111207161215.761489201@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:14 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Joerg Roedel <joerg.roedel@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [012/104] PCI hotplug: shpchp: dont blindly claim non-AMD 0x7450 device IDs
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -278,8 +278,8 @@ static int get_adapter_status (struct ho
 
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
@@ -944,8 +944,8 @@ int shpc_init(struct controller *ctrl, s
 	ctrl->pci_dev = pdev;  /* pci_dev of the P2P bridge */
 	ctrl_dbg(ctrl, "Hotplug Controller:\n");
 
-	if ((pdev->vendor == PCI_VENDOR_ID_AMD) || (pdev->device ==
-				PCI_DEVICE_ID_AMD_GOLAM_7450)) {
+	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
+	    pdev->device == PCI_DEVICE_ID_AMD_GOLAM_7450) {
 		/* amd shpc driver doesn't use Base Offset; assume 0 */
 		ctrl->mmio_base = pci_resource_start(pdev, 0);
 		ctrl->mmio_size = pci_resource_len(pdev, 0);


