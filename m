Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab0KZTID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:08:03 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46304 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab0KZTFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:20 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 05/16] amd64_edac: Cleanup the CPU PCI device reservation
Date: Fri, 26 Nov 2010 20:04:12 +0100
Message-Id: <1290798263-13074-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Shorten code and clarify comments, return proper -E* values on error.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   42 ++++++++++++------------------------------
 1 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index a59c1da..3edaf4d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2035,42 +2035,27 @@ void amd64_decode_bus_error(int node_id, struct mce *m, u32 nbcfg)
 }
 
 /*
- * Input:
- *	1) struct amd64_pvt which contains pvt->dram_f2_ctl pointer
- *	2) AMD Family index value
- *
- * Ouput:
- *	Upon return of 0, the following filled in:
- *
- *		struct pvt->addr_f1_ctl
- *		struct pvt->misc_f3_ctl
- *
- *	Filled in with related device funcitions of 'dram_f2_ctl'
- *	These devices are "reserved" via the pci_get_device()
- *
- *	Upon return of 1 (error status):
- *
- *		Nothing reserved
+ * Use pvt->dram_f2_ctl which contains the F2 CPU PCI device to get the related
+ * F1 (AddrMap) and F3 (Misc) devices. Return negative value on error.
  */
-static int amd64_reserve_mc_sibling_devices(struct amd64_pvt *pvt, int mc_idx)
+static int amd64_reserve_mc_sibling_devices(struct amd64_pvt *pvt, u16 f1_id,
+					    u16 f3_id)
 {
-	const struct amd64_family_type *amd64_dev = &amd64_family_types[mc_idx];
-
 	/* Reserve the ADDRESS MAP Device */
 	pvt->addr_f1_ctl = pci_get_related_function(pvt->dram_f2_ctl->vendor,
-						    amd64_dev->addr_f1_ctl,
+						    f1_id,
 						    pvt->dram_f2_ctl);
 
 	if (!pvt->addr_f1_ctl) {
 		amd64_printk(KERN_ERR, "error address map device not found: "
 			     "vendor %x device 0x%x (broken BIOS?)\n",
-			     PCI_VENDOR_ID_AMD, amd64_dev->addr_f1_ctl);
-		return 1;
+			     PCI_VENDOR_ID_AMD, f1_id);
+		return -ENODEV;
 	}
 
 	/* Reserve the MISC Device */
 	pvt->misc_f3_ctl = pci_get_related_function(pvt->dram_f2_ctl->vendor,
-						    amd64_dev->misc_f3_ctl,
+						    f3_id,
 						    pvt->dram_f2_ctl);
 
 	if (!pvt->misc_f3_ctl) {
@@ -2079,8 +2064,8 @@ static int amd64_reserve_mc_sibling_devices(struct amd64_pvt *pvt, int mc_idx)
 
 		amd64_printk(KERN_ERR, "error miscellaneous device not found: "
 			     "vendor %x device 0x%x (broken BIOS?)\n",
-			     PCI_VENDOR_ID_AMD, amd64_dev->misc_f3_ctl);
-		return 1;
+			     PCI_VENDOR_ID_AMD, f3_id);
+		return -ENODEV;
 	}
 
 	debugf1("    Addr Map device PCI Bus ID:\t%s\n",
@@ -2646,12 +2631,9 @@ static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl,
 	if (!fam_type)
 		goto err_free;
 
-	/*
-	 * We have the dram_f2_ctl device as an argument, now go reserve its
-	 * sibling devices from the PCI system.
-	 */
 	ret = -ENODEV;
-	err = amd64_reserve_mc_sibling_devices(pvt, mc_type_index);
+	err = amd64_reserve_mc_sibling_devices(pvt, fam_type->addr_f1_ctl,
+					       fam_type->misc_f3_ctl);
 	if (err)
 		goto err_free;
 
-- 
1.7.3.1.50.g1e633

