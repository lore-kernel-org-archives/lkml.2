Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab0KZTFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:05:20 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46285 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab0KZTFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:15 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 04/16] amd64_edac: Simplify CPU family detection
Date: Fri, 26 Nov 2010 20:04:11 +0100
Message-Id: <1290798263-13074-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Concentrate CPU family detection in the per-family init function.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   56 +++++++++++++++++++++++---------------------
 drivers/edac/amd64_edac.h |    8 ++----
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index bb9a342..a59c1da 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -783,19 +783,6 @@ static u16 extract_syndrome(struct err_regs *err)
 	return ((err->nbsh >> 15) & 0xff) | ((err->nbsl >> 16) & 0xff00);
 }
 
-static void amd64_cpu_display_info(struct amd64_pvt *pvt)
-{
-	if (boot_cpu_data.x86 == 0x10)
-		edac_printk(KERN_DEBUG, EDAC_MC, "F10h CPU detected\n");
-	else if (boot_cpu_data.x86 == 0xf)
-		edac_printk(KERN_DEBUG, EDAC_MC, "%s detected\n",
-			(pvt->ext_model >= K8_REV_F) ?
-			"Rev F or later" : "Rev E or earlier");
-	else
-		/* we'll hardly ever ever get here */
-		edac_printk(KERN_ERR, EDAC_MC, "Unknown cpu!\n");
-}
-
 /*
  * Determine if the DIMMs have ECC enabled. ECC is enabled ONLY if all the DIMMs
  * are ECC capable.
@@ -1719,7 +1706,7 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 
 static struct amd64_family_type amd64_family_types[] = {
 	[K8_CPUS] = {
-		.ctl_name = "RevF",
+		.ctl_name = "K8",
 		.addr_f1_ctl = PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP,
 		.misc_f3_ctl = PCI_DEVICE_ID_AMD_K8_NB_MISC,
 		.ops = {
@@ -1731,7 +1718,7 @@ static struct amd64_family_type amd64_family_types[] = {
 		}
 	},
 	[F10_CPUS] = {
-		.ctl_name = "Family 10h",
+		.ctl_name = "F10h",
 		.addr_f1_ctl = PCI_DEVICE_ID_AMD_10H_NB_MAP,
 		.misc_f3_ctl = PCI_DEVICE_ID_AMD_10H_NB_MISC,
 		.ops = {
@@ -2137,8 +2124,6 @@ static void amd64_read_mc_registers(struct amd64_pvt *pvt)
 	} else
 		debugf0("  TOP_MEM2 disabled.\n");
 
-	amd64_cpu_display_info(pvt);
-
 	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCAP, &pvt->nbcap);
 
 	if (pvt->ops->read_dram_ctl_register)
@@ -2583,7 +2568,7 @@ static void amd64_setup_mci_misc_attributes(struct mem_ctl_info *mci)
 	mci->edac_cap		= amd64_determine_edac_cap(pvt);
 	mci->mod_name		= EDAC_MOD_STR;
 	mci->mod_ver		= EDAC_AMD64_VERSION;
-	mci->ctl_name		= get_amd_family_name(pvt->mc_type_index);
+	mci->ctl_name		= pvt->ctl_name;
 	mci->dev_name		= pci_name(pvt->dram_f2_ctl);
 	mci->ctl_page_to_phys	= NULL;
 
@@ -2592,21 +2577,37 @@ static void amd64_setup_mci_misc_attributes(struct mem_ctl_info *mci)
 	mci->get_sdram_scrub_rate = amd64_get_scrub_rate;
 }
 
-static int amd64_per_family_init(struct amd64_pvt *pvt)
+/*
+ * returns a pointer to the family descriptor on success, NULL otherwise.
+ */
+static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 {
-	switch (boot_cpu_data.x86) {
+	u8 fam = boot_cpu_data.x86;
+	struct amd64_family_type *fam_type = NULL;
+
+	switch (fam) {
 	case 0xf:
-		pvt->min_scrubrate = K8_MIN_SCRUB_RATE_BITS;
+		fam_type		= &amd64_family_types[K8_CPUS];
+		pvt->ctl_name		= fam_type->ctl_name;
+		pvt->min_scrubrate	= K8_MIN_SCRUB_RATE_BITS;
 		break;
 	case 0x10:
-		pvt->min_scrubrate = F10_MIN_SCRUB_RATE_BITS;
+		fam_type		= &amd64_family_types[F10_CPUS];
+		pvt->ctl_name		= fam_type->ctl_name;
+		pvt->min_scrubrate	= F10_MIN_SCRUB_RATE_BITS;
 		break;
 
 	default:
 		amd64_printk(KERN_ERR, "Unsupported family!\n");
-		return -EINVAL;
+		return NULL;
 	}
-	return 0;
+
+	amd64_printk(KERN_INFO, "%s %s detected.\n", pvt->ctl_name,
+		     (fam == 0xf ?
+				(pvt->ext_model >= K8_REV_F  ? "revF or later"
+							     : "revE or earlier")
+				 : ""));
+	return fam_type;
 }
 
 /*
@@ -2625,6 +2626,7 @@ static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl,
 				    int mc_type_index)
 {
 	struct amd64_pvt *pvt = NULL;
+	struct amd64_family_type *fam_type = NULL;
 	int err = 0, ret;
 
 	ret = -ENOMEM;
@@ -2640,7 +2642,8 @@ static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl,
 	pvt->ops		= family_ops(mc_type_index);
 
 	ret = -EINVAL;
-	if (amd64_per_family_init(pvt))
+	fam_type = amd64_per_family_init(pvt);
+	if (!fam_type)
 		goto err_free;
 
 	/*
@@ -2762,8 +2765,7 @@ static int __devinit amd64_init_one_instance(struct pci_dev *pdev,
 {
 	int ret = 0;
 
-	debugf0("(MC node=%d,mc_type='%s')\n", get_node_id(pdev),
-		get_amd_family_name(mc_type->driver_data));
+	debugf0("(MC node=%d)\n", get_node_id(pdev));
 
 	ret = pci_enable_device(pdev);
 	if (ret < 0)
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index e5204fe..064e0d6 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -464,6 +464,9 @@ struct amd64_pvt {
 	/* DCT per-family scrubrate setting */
 	u32 min_scrubrate;
 
+	/* family name this instance is running on */
+	const char *ctl_name;
+
 	/* misc settings */
 	struct flags {
 		unsigned long cf8_extcfg:1;
@@ -526,11 +529,6 @@ struct amd64_family_type {
 
 static struct amd64_family_type amd64_family_types[];
 
-static inline const char *get_amd_family_name(int index)
-{
-	return amd64_family_types[index].ctl_name;
-}
-
 static inline struct low_ops *family_ops(int index)
 {
 	return &amd64_family_types[index].ops;
-- 
1.7.3.1.50.g1e633

