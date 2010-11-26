Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0KZTF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:05:27 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46313 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab0KZTFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:24 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 06/16] amd64_edac: Concentrate per-family init even more
Date: Fri, 26 Nov 2010 20:04:13 +0100
Message-Id: <1290798263-13074-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Move the remaining per-family init code into the proper place and
simplify the rest of the initialization. Reorganize error handling in
amd64_init_one_instance().

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   31 +++++++++++++++----------------
 drivers/edac/amd64_edac.h |   15 ++-------------
 2 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 3edaf4d..9370812 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2573,11 +2573,13 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 	switch (fam) {
 	case 0xf:
 		fam_type		= &amd64_family_types[K8_CPUS];
+		pvt->ops		= &amd64_family_types[K8_CPUS].ops;
 		pvt->ctl_name		= fam_type->ctl_name;
 		pvt->min_scrubrate	= K8_MIN_SCRUB_RATE_BITS;
 		break;
 	case 0x10:
 		fam_type		= &amd64_family_types[F10_CPUS];
+		pvt->ops		= &amd64_family_types[F10_CPUS].ops;
 		pvt->ctl_name		= fam_type->ctl_name;
 		pvt->min_scrubrate	= F10_MIN_SCRUB_RATE_BITS;
 		break;
@@ -2587,6 +2589,8 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 		return NULL;
 	}
 
+	pvt->ext_model = boot_cpu_data.x86_model >> 4;
+
 	amd64_printk(KERN_INFO, "%s %s detected.\n", pvt->ctl_name,
 		     (fam == 0xf ?
 				(pvt->ext_model >= K8_REV_F  ? "revF or later"
@@ -2607,8 +2611,7 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
  * later come back in a finish-setup function to perform that final
  * initialization. See also amd64_init_2nd_stage() for that.
  */
-static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl,
-				    int mc_type_index)
+static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl)
 {
 	struct amd64_pvt *pvt = NULL;
 	struct amd64_family_type *fam_type = NULL;
@@ -2619,12 +2622,8 @@ static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl,
 	if (!pvt)
 		goto err_exit;
 
-	pvt->mc_node_id = get_node_id(dram_f2_ctl);
-
-	pvt->dram_f2_ctl	= dram_f2_ctl;
-	pvt->ext_model		= boot_cpu_data.x86_model >> 4;
-	pvt->mc_type_index	= mc_type_index;
-	pvt->ops		= family_ops(mc_type_index);
+	pvt->mc_node_id	 = get_node_id(dram_f2_ctl);
+	pvt->dram_f2_ctl = dram_f2_ctl;
 
 	ret = -EINVAL;
 	fam_type = amd64_per_family_init(pvt);
@@ -2743,20 +2742,22 @@ err_exit:
 
 
 static int __devinit amd64_init_one_instance(struct pci_dev *pdev,
-				 const struct pci_device_id *mc_type)
+					     const struct pci_device_id *mc_type)
 {
 	int ret = 0;
 
 	debugf0("(MC node=%d)\n", get_node_id(pdev));
 
 	ret = pci_enable_device(pdev);
-	if (ret < 0)
-		ret = -EIO;
-	else
-		ret = amd64_probe_one_instance(pdev, mc_type->driver_data);
+	if (ret < 0) {
+		debugf0("ret=%d\n", ret);
+		return -EIO;
+	}
 
+	ret = amd64_probe_one_instance(pdev);
 	if (ret < 0)
-		debugf0("ret=%d\n", ret);
+		amd64_printk(KERN_ERR, "Error probing instance: %d\n",
+					get_node_id(pdev));
 
 	return ret;
 }
@@ -2805,7 +2806,6 @@ static const struct pci_device_id amd64_pci_table[] __devinitdata = {
 		.subdevice	= PCI_ANY_ID,
 		.class		= 0,
 		.class_mask	= 0,
-		.driver_data	= K8_CPUS
 	},
 	{
 		.vendor		= PCI_VENDOR_ID_AMD,
@@ -2814,7 +2814,6 @@ static const struct pci_device_id amd64_pci_table[] __devinitdata = {
 		.subdevice	= PCI_ANY_ID,
 		.class		= 0,
 		.class_mask	= 0,
-		.driver_data	= F10_CPUS
 	},
 	{0, }
 };
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 064e0d6..007b68a 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -383,6 +383,8 @@ struct error_injection {
 };
 
 struct amd64_pvt {
+	struct low_ops *ops;
+
 	/* pci_device handles which we utilize */
 	struct pci_dev *addr_f1_ctl;
 	struct pci_dev *dram_f2_ctl;
@@ -390,9 +392,6 @@ struct amd64_pvt {
 
 	int mc_node_id;		/* MC index of this MC node */
 	int ext_model;		/* extended model value of this node */
-
-	struct low_ops *ops;	/* pointer to per PCI Device ID func table */
-
 	int channel_count;
 
 	/* Raw registers */
@@ -458,9 +457,6 @@ struct amd64_pvt {
 	u32 nbctl_mcgctl_saved;		/* When true, following 2 are valid */
 	u32 old_nbctl;
 
-	/* MC Type Index value: socket F vs Family 10h */
-	u32 mc_type_index;
-
 	/* DCT per-family scrubrate setting */
 	u32 min_scrubrate;
 
@@ -527,13 +523,6 @@ struct amd64_family_type {
 	struct low_ops ops;
 };
 
-static struct amd64_family_type amd64_family_types[];
-
-static inline struct low_ops *family_ops(int index)
-{
-	return &amd64_family_types[index].ops;
-}
-
 static inline int amd64_read_pci_cfg_dword(struct pci_dev *pdev, int offset,
 					   u32 *val, const char *func)
 {
-- 
1.7.3.1.50.g1e633

