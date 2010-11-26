Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab0KZTFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:05:22 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46289 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab0KZTFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:15 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 01/16] amd64_edac: Remove F11h support
Date: Fri, 26 Nov 2010 20:04:08 +0100
Message-Id: <1290798263-13074-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

F11h doesn't support DRAM ECC so whack it away.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   50 ++------------------------------------------
 drivers/edac/amd64_edac.h |    2 -
 2 files changed, 3 insertions(+), 49 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 774f950..b7bde66 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -172,9 +172,6 @@ static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 bandwidth)
 	case 0x10:
 		min_scrubrate = F10_MIN_SCRUB_RATE_BITS;
 		break;
-	case 0x11:
-		min_scrubrate = F11_MIN_SCRUB_RATE_BITS;
-		break;
 
 	default:
 		amd64_printk(KERN_ERR, "Unsupported family!\n");
@@ -803,9 +800,7 @@ static u16 extract_syndrome(struct err_regs *err)
 
 static void amd64_cpu_display_info(struct amd64_pvt *pvt)
 {
-	if (boot_cpu_data.x86 == 0x11)
-		edac_printk(KERN_DEBUG, EDAC_MC, "F11h CPU detected\n");
-	else if (boot_cpu_data.x86 == 0x10)
+	if (boot_cpu_data.x86 == 0x10)
 		edac_printk(KERN_DEBUG, EDAC_MC, "F10h CPU detected\n");
 	else if (boot_cpu_data.x86 == 0xf)
 		edac_printk(KERN_DEBUG, EDAC_MC, "%s detected\n",
@@ -965,14 +960,8 @@ static void amd64_set_dct_base_and_mask(struct amd64_pvt *pvt)
 		pvt->dcsm_mask		= REV_F_F1Xh_DCSM_MASK_BITS;
 		pvt->dcs_mask_notused	= REV_F_F1Xh_DCS_NOTUSED_BITS;
 		pvt->dcs_shift		= REV_F_F1Xh_DCS_SHIFT;
-
-		if (boot_cpu_data.x86 == 0x11) {
-			pvt->cs_count = 4;
-			pvt->num_dcsm = 2;
-		} else {
-			pvt->cs_count = 8;
-			pvt->num_dcsm = 4;
-		}
+		pvt->cs_count		= 8;
+		pvt->num_dcsm		= 4;
 	}
 }
 
@@ -1744,17 +1733,6 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 	}
 }
 
-/*
- * There currently are 3 types type of MC devices for AMD Athlon/Opterons
- * (as per PCI DEVICE_IDs):
- *
- * Family K8: That is the Athlon64 and Opteron CPUs. They all have the same PCI
- * DEVICE ID, even though there is differences between the different Revisions
- * (CG,D,E,F).
- *
- * Family F10h and F11h.
- *
- */
 static struct amd64_family_type amd64_family_types[] = {
 	[K8_CPUS] = {
 		.ctl_name = "RevF",
@@ -1781,19 +1759,6 @@ static struct amd64_family_type amd64_family_types[] = {
 			.dbam_to_cs		= f10_dbam_to_chip_select,
 		}
 	},
-	[F11_CPUS] = {
-		.ctl_name = "Family 11h",
-		.addr_f1_ctl = PCI_DEVICE_ID_AMD_11H_NB_MAP,
-		.misc_f3_ctl = PCI_DEVICE_ID_AMD_11H_NB_MISC,
-		.ops = {
-			.early_channel_count	= f10_early_channel_count,
-			.get_error_address	= f10_get_error_address,
-			.read_dram_base_limit	= f10_read_dram_base_limit,
-			.read_dram_ctl_register	= f10_read_dram_ctl_register,
-			.map_sysaddr_to_csrow	= f10_map_sysaddr_to_csrow,
-			.dbam_to_cs		= f10_dbam_to_chip_select,
-		}
-	},
 };
 
 static struct pci_dev *pci_get_related_function(unsigned int vendor,
@@ -2862,15 +2827,6 @@ static const struct pci_device_id amd64_pci_table[] __devinitdata = {
 		.class_mask	= 0,
 		.driver_data	= F10_CPUS
 	},
-	{
-		.vendor		= PCI_VENDOR_ID_AMD,
-		.device		= PCI_DEVICE_ID_AMD_11H_NB_DRAM,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.class		= 0,
-		.class_mask	= 0,
-		.driver_data	= F11_CPUS
-	},
 	{0, }
 };
 MODULE_DEVICE_TABLE(pci, amd64_pci_table);
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 044aee4..c8f2734 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -373,7 +373,6 @@ static inline int get_node_id(struct pci_dev *pdev)
 enum amd64_chipset_families {
 	K8_CPUS = 0,
 	F10_CPUS,
-	F11_CPUS,
 };
 
 /* Error injection control structure */
@@ -556,7 +555,6 @@ static inline int amd64_read_pci_cfg_dword(struct pci_dev *pdev, int offset,
  */
 #define K8_MIN_SCRUB_RATE_BITS	0x0
 #define F10_MIN_SCRUB_RATE_BITS	0x5
-#define F11_MIN_SCRUB_RATE_BITS	0x6
 
 int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 			     u64 *hole_offset, u64 *hole_size);
-- 
1.7.3.1.50.g1e633

