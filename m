Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3AHXgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:36:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:63339 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab3AHXgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:36:49 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 22/77] PCI hotplug: shpchp: don't blindly claim non-AMD 0x7450 device IDs
Date: Tue, 8 Jan 2013 18:35:01 -0500
Message-ID: <1357688156-25387-23-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/hotplug/shpchp_core.c | 4 ++--
 drivers/pci/hotplug/shpchp_hpc.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index a7bd504..2ee01b6 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -278,8 +278,8 @@ static int get_adapter_status (struct hotplug_slot *hotplug_slot, u8 *value)
 
 static int is_shpc_capable(struct pci_dev *dev)
 {
-	if ((dev->vendor == PCI_VENDOR_ID_AMD) || (dev->device ==
-						PCI_DEVICE_ID_AMD_GOLAM_7450))
+	if (dev->vendor == PCI_VENDOR_ID_AMD &&
+	    dev->device == PCI_DEVICE_ID_AMD_GOLAM_7450)
 		return 1;
 	if (!pci_find_capability(dev, PCI_CAP_ID_SHPC))
 		return 0;
diff --git a/drivers/pci/hotplug/shpchp_hpc.c b/drivers/pci/hotplug/shpchp_hpc.c
index 5f5e8d2..f13e724 100644
--- a/drivers/pci/hotplug/shpchp_hpc.c
+++ b/drivers/pci/hotplug/shpchp_hpc.c
@@ -953,8 +953,8 @@ int shpc_init(struct controller *ctrl, struct pci_dev *pdev)
 	ctrl->pci_dev = pdev;  /* pci_dev of the P2P bridge */
 	ctrl_dbg(ctrl, "Hotplug Controller:\n");
 
-	if ((pdev->vendor == PCI_VENDOR_ID_AMD) || (pdev->device ==
-				PCI_DEVICE_ID_AMD_GOLAM_7450)) {
+	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
+	    pdev->device == PCI_DEVICE_ID_AMD_GOLAM_7450) {
 		/* amd shpc driver doesn't use Base Offset; assume 0 */
 		ctrl->mmio_base = pci_resource_start(pdev, 0);
 		ctrl->mmio_size = pci_resource_len(pdev, 0);
-- 
1.7.12.1

