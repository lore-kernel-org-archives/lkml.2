Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab2K3Io5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:44:57 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46380 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab2K3Io4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:44:56 -0500
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4 v8] AMD64 EDAC: Fix PCI function lookup
Date: Fri, 30 Nov 2012 16:44:19 +0800
Message-Id: <1354265060-22956-1-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix locating sibling memory controller PCI functions by using the
correct PCI domain and use Northbridge only if found. Tested on
multi-socket server and multi-server, multi-socket NumaConnect setup.

v7: Refactor patches grouping changes
v8: Restructure searching for PCI function for clarity; use Northbridge
    only if found

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 drivers/edac/amd64_edac.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 60e93fa..6c1005f 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -983,6 +983,22 @@ static u64 get_error_address(struct mce *m)
 	return addr;
 }
 
+static struct pci_dev *pci_get_related_function(unsigned int vendor,
+						unsigned int device,
+						struct pci_dev *related)
+{
+	struct pci_dev *dev = NULL;
+
+	while ((dev = pci_get_device(vendor, device, dev))) {
+		if (pci_domain_nr(dev->bus) == pci_domain_nr(related->bus) &&
+		    (dev->bus->number == related->bus->number) &&
+		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
+			break;
+	}
+
+	return dev;
+}
+
 static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
@@ -1002,11 +1018,17 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 
 	/* Factor in CC6 save area by reading dst node's limit reg */
 	if (c->x86 == 0x15) {
-		struct pci_dev *f1 = NULL;
+		struct pci_dev *misc, *f1 = NULL;
 		u8 nid = dram_dst_node(pvt, range);
+		struct amd_northbridge *nb = node_to_amd_nb(nid);
 		u32 llim;
 
-		f1 = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0x18 + nid, 1));
+		/* If DRAM base/limit registers point to a non-AMD device, nb won't have been found */
+		if (!nb)
+			return;
+
+		misc = nb->misc;
+		f1 = pci_get_related_function(misc->vendor, PCI_DEVICE_ID_AMD_15H_NB_F1, misc);
 		if (WARN_ON(!f1))
 			return;
 
@@ -1713,23 +1735,6 @@ static struct amd64_family_type amd64_family_types[] = {
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

