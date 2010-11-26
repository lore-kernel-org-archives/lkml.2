Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab0KZTGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:06:39 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46346 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab0KZTFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:35 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 11/16] amd64_edac: Remove PCI ECS enabling functions
Date: Fri, 26 Nov 2010 20:04:18 +0100
Message-Id: <1290798263-13074-12-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

PCI ECS is being enabled by default since 2.6.26 on AMD so this code is
just superfluous now, remove it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   55 ---------------------------------------------
 drivers/edac/amd64_edac.h |    4 ---
 2 files changed, 0 insertions(+), 59 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index a7922da..99d3334 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1204,31 +1204,6 @@ static int f10_dbam_to_chip_select(struct amd64_pvt *pvt, int cs_mode)
 	return dbam_map[cs_mode];
 }
 
-/* Enable extended configuration access via 0xCF8 feature */
-static void amd64_setup(struct amd64_pvt *pvt)
-{
-	u32 reg;
-
-	amd64_read_pci_cfg(pvt->F3, F10_NB_CFG_HIGH, &reg);
-
-	pvt->flags.cf8_extcfg = !!(reg & F10_NB_CFG_LOW_ENABLE_EXT_CFG);
-	reg |= F10_NB_CFG_LOW_ENABLE_EXT_CFG;
-	pci_write_config_dword(pvt->F3, F10_NB_CFG_HIGH, reg);
-}
-
-/* Restore the extended configuration access via 0xCF8 feature */
-static void amd64_teardown(struct amd64_pvt *pvt)
-{
-	u32 reg;
-
-	amd64_read_pci_cfg(pvt->F3, F10_NB_CFG_HIGH, &reg);
-
-	reg &= ~F10_NB_CFG_LOW_ENABLE_EXT_CFG;
-	if (pvt->flags.cf8_extcfg)
-		reg |= F10_NB_CFG_LOW_ENABLE_EXT_CFG;
-	pci_write_config_dword(pvt->F3, F10_NB_CFG_HIGH, reg);
-}
-
 static u64 f10_get_error_address(struct mem_ctl_info *mci,
 			struct err_regs *info)
 {
@@ -1251,8 +1226,6 @@ static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 
 	/* read the 'raw' DRAM BASE Address register */
 	amd64_read_pci_cfg(pvt->F1, low_offset, &low_base);
-
-	/* Read from the ECS data register */
 	amd64_read_pci_cfg(pvt->F1, high_offset, &high_base);
 
 	/* Extract parts into separate data entries */
@@ -1271,8 +1244,6 @@ static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 
 	/* read the 'raw' LIMIT registers */
 	amd64_read_pci_cfg(pvt->F1, low_offset, &low_limit);
-
-	/* Read from the ECS data register for the HIGH portion */
 	amd64_read_pci_cfg(pvt->F1, high_offset, &high_limit);
 
 	pvt->dram_DstNode[dram] = (low_limit & 0x7);
@@ -2560,18 +2531,6 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 	return fam_type;
 }
 
-/*
- * Init stuff for this DRAM Controller device.
- *
- * Due to a hardware feature on Fam10h CPUs, the Enable Extended Configuration
- * Space feature MUST be enabled on ALL Processors prior to actually reading
- * from the ECS registers. Since the loading of the module can occur on any
- * 'core', and cores don't 'see' all the other processors ECS data when the
- * others are NOT enabled. Our solution is to first enable ECS access in this
- * routine on all processors, gather some data in a amd64_pvt structure and
- * later come back in a finish-setup function to perform that final
- * initialization. See also amd64_init_2nd_stage() for that.
- */
 static int amd64_probe_one_instance(struct pci_dev *F2)
 {
 	struct amd64_pvt *pvt = NULL;
@@ -2603,14 +2562,6 @@ static int amd64_probe_one_instance(struct pci_dev *F2)
 		goto err_put;
 
 	/*
-	 * Key operation here: setup of HW prior to performing ops on it. Some
-	 * setup is required to access ECS data. After this is performed, the
-	 * 'teardown' function must be called upon error and normal exit paths.
-	 */
-	if (boot_cpu_data.x86 >= 0x10)
-		amd64_setup(pvt);
-
-	/*
 	 * Save the pointer to the private data for use in 2nd initialization
 	 * stage
 	 */
@@ -2690,9 +2641,6 @@ err_exit:
 
 	amd64_restore_ecc_error_reporting(pvt);
 
-	if (boot_cpu_data.x86 > 0xf)
-		amd64_teardown(pvt);
-
 	amd64_free_mc_sibling_devices(pvt);
 
 	kfree(pvts[pvt->mc_node_id]);
@@ -2734,9 +2682,6 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 
 	amd64_restore_ecc_error_reporting(pvt);
 
-	if (boot_cpu_data.x86 > 0xf)
-		amd64_teardown(pvt);
-
 	amd64_free_mc_sibling_devices(pvt);
 
 	/* unregister from EDAC MCE */
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 5538cc1..4bc6f18 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -335,9 +335,6 @@
 #define K8_SCRCTRL			0x58
 
 #define F10_NB_CFG_LOW			0x88
-#define	F10_NB_CFG_LOW_ENABLE_EXT_CFG	BIT(14)
-
-#define F10_NB_CFG_HIGH			0x8C
 
 #define F10_ONLINE_SPARE		0xB0
 #define F10_ONLINE_SPARE_SWAPDONE0(x)	((x) & BIT(1))
@@ -476,7 +473,6 @@ struct amd64_pvt {
 
 	/* misc settings */
 	struct flags {
-		unsigned long cf8_extcfg:1;
 		unsigned long nb_mce_enable:1;
 		unsigned long nb_ecc_prev:1;
 	} flags;
-- 
1.7.3.1.50.g1e633

