Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab2K0GfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:35:19 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37202 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2K0GfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:35:12 -0500
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4 v7] AMD64 EDAC: Fix PCI function lookup
Date: Tue, 27 Nov 2012 14:32:11 +0800
Message-Id: <1353997932-8475-3-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353997932-8475-1-git-send-email-daniel@numascale-asia.com>
References: <1353997932-8475-1-git-send-email-daniel@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix locating sibling memory controller PCI functions by using the
correct PCI domain.

v7: Refactor patches grouping changes

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 drivers/edac/amd64_edac.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 60e93fa..62b7b17 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -983,6 +983,24 @@ static u64 get_error_address(struct mce *m)
 	return addr;
 }
 
+static struct pci_dev *pci_get_related_function(unsigned int vendor,
+						unsigned int device,
+						struct pci_dev *related)
+{
+	struct pci_dev *dev = NULL;
+
+	dev = pci_get_device(vendor, device, dev);
+	while (dev) {
+		if (pci_domain_nr(dev->bus) == pci_domain_nr(related->bus) &&
+		    (dev->bus->number == related->bus->number) &&
+		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
+			break;
+		dev = pci_get_device(vendor, device, dev);
+	}
+
+	return dev;
+}
+
 static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
@@ -1002,11 +1020,12 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 
 	/* Factor in CC6 save area by reading dst node's limit reg */
 	if (c->x86 == 0x15) {
-		struct pci_dev *f1 = NULL;
+		struct pci_dev *misc, *f1 = NULL;
 		u8 nid = dram_dst_node(pvt, range);
 		u32 llim;
 
-		f1 = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0x18 + nid, 1));
+		misc = node_to_amd_nb(nid)->misc;
+		f1 = pci_get_related_function(misc->vendor, PCI_DEVICE_ID_AMD_15H_NB_F1, misc);
 		if (WARN_ON(!f1))
 			return;
 
@@ -1713,23 +1732,6 @@ static struct amd64_family_type amd64_family_types[] = {
 	},
 };
 
-static struct pci_dev *pci_get_related_function(unsigned int vendor,
-						unsigned int device,
-						struct pci_dev *related)
-{
-	struct pci_dev *dev = NULL;
-
-	dev = pci_get_device(vendor, device, dev);
-	while (dev) {
-		if ((dev->bus->number == related->bus->number) &&
-		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
-			break;
-		dev = pci_get_device(vendor, device, dev);
-	}
-
-	return dev;
-}
-
 /*
  * These are tables of eigenvectors (one per line) which can be used for the
  * construction of the syndrome tables. The modified syndrome search algorithm
-- 
1.7.10.4

