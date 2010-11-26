Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab0KZTFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:05:40 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46351 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab0KZTFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:38 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 12/16] amd64_edac: Carve out ECC-related hw settings
Date: Fri, 26 Nov 2010 20:04:19 +0100
Message-Id: <1290798263-13074-13-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is in preparation for the init path reorganization where we want
only to

1) test whether a particular node supports ECC
2) can it be enabled

and only then do the necessary allocation/initialization. For that,
we need to decouple the ECC settings of the node from the instance's
descriptor.

The should be no functional change introduced by this patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   59 ++++++++++++++++++++++++++++++--------------
 drivers/edac/amd64_edac.h |   14 +++++++----
 2 files changed, 49 insertions(+), 24 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 99d3334..2388bb9 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -18,6 +18,7 @@ static struct msr __percpu *msrs;
 /* Per-node driver instances */
 static struct mem_ctl_info **mcis;
 static struct amd64_pvt **pvts;
+static struct ecc_settings **ecc_stngs;
 
 /*
  * Address to DRAM bank mapping: see F2x80 for K8 and F2x[1,0]80 for Fam10 and
@@ -2293,7 +2294,7 @@ out:
 	return ret;
 }
 
-static int amd64_toggle_ecc_err_reporting(struct amd64_pvt *pvt, bool on)
+static int amd64_toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
 {
 	cpumask_var_t cmask;
 	int cpu;
@@ -2303,7 +2304,7 @@ static int amd64_toggle_ecc_err_reporting(struct amd64_pvt *pvt, bool on)
 		return false;
 	}
 
-	get_cpus_on_this_dct_cpumask(cmask, pvt->mc_node_id);
+	get_cpus_on_this_dct_cpumask(cmask, nid);
 
 	rdmsr_on_cpus(cmask, MSR_IA32_MCG_CTL, msrs);
 
@@ -2313,14 +2314,14 @@ static int amd64_toggle_ecc_err_reporting(struct amd64_pvt *pvt, bool on)
 
 		if (on) {
 			if (reg->l & K8_MSR_MCGCTL_NBE)
-				pvt->flags.nb_mce_enable = 1;
+				s->flags.nb_mce_enable = 1;
 
 			reg->l |= K8_MSR_MCGCTL_NBE;
 		} else {
 			/*
 			 * Turn off NB MCE reporting only when it was off before
 			 */
-			if (!pvt->flags.nb_mce_enable)
+			if (!s->flags.nb_mce_enable)
 				reg->l &= ~K8_MSR_MCGCTL_NBE;
 		}
 	}
@@ -2334,18 +2335,20 @@ static int amd64_toggle_ecc_err_reporting(struct amd64_pvt *pvt, bool on)
 static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
+	u8 nid = pvt->mc_node_id;
+	struct ecc_settings *s = ecc_stngs[nid];
 	u32 value, mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
 
 	amd64_read_pci_cfg(pvt->F3, K8_NBCTL, &value);
 
-	/* turn on UECCn and CECCEn bits */
-	pvt->old_nbctl = value & mask;
-	pvt->nbctl_mcgctl_saved = 1;
+	/* turn on UECCEn and CECCEn bits */
+	s->old_nbctl   = value & mask;
+	s->nbctl_valid = true;
 
 	value |= mask;
 	pci_write_config_dword(pvt->F3, K8_NBCTL, value);
 
-	if (amd64_toggle_ecc_err_reporting(pvt, ON))
+	if (amd64_toggle_ecc_err_reporting(s, nid, ON))
 		amd64_warn("Error enabling ECC reporting over MCGCTL!\n");
 
 	amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &value);
@@ -2357,7 +2360,7 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 	if (!(value & K8_NBCFG_ECC_ENABLE)) {
 		amd64_warn("DRAM ECC disabled on this node, enabling...\n");
 
-		pvt->flags.nb_ecc_prev = 0;
+		s->flags.nb_ecc_prev = 0;
 
 		/* Attempt to turn on DRAM ECC Enable */
 		value |= K8_NBCFG_ECC_ENABLE;
@@ -2372,7 +2375,7 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 			amd64_info("Hardware accepted DRAM ECC Enable\n");
 		}
 	} else {
-		pvt->flags.nb_ecc_prev = 1;
+		s->flags.nb_ecc_prev = 1;
 	}
 
 	debugf0("NBCFG(2)= 0x%x  CHIPKILL= %s ECC_ENABLE= %s\n", value,
@@ -2384,26 +2387,28 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 
 static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 {
+	u8 nid = pvt->mc_node_id;
+	struct ecc_settings *s = ecc_stngs[nid];
 	u32 value, mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
 
-	if (!pvt->nbctl_mcgctl_saved)
+	if (!s->nbctl_valid)
 		return;
 
 	amd64_read_pci_cfg(pvt->F3, K8_NBCTL, &value);
 	value &= ~mask;
-	value |= pvt->old_nbctl;
+	value |= s->old_nbctl;
 
 	pci_write_config_dword(pvt->F3, K8_NBCTL, value);
 
-	/* restore previous BIOS DRAM ECC "off" setting which we force-enabled */
-	if (!pvt->flags.nb_ecc_prev) {
+	/* restore previous BIOS DRAM ECC "off" setting we force-enabled */
+	if (!s->flags.nb_ecc_prev) {
 		amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &value);
 		value &= ~K8_NBCFG_ECC_ENABLE;
 		pci_write_config_dword(pvt->F3, K8_NBCFG, value);
 	}
 
 	/* restore the NB Enable MCGCTL bit */
-	if (amd64_toggle_ecc_err_reporting(pvt, OFF))
+	if (amd64_toggle_ecc_err_reporting(s, nid, OFF))
 		amd64_warn("Error restoring NB MCGCTL settings!\n");
 }
 
@@ -2654,6 +2659,8 @@ static int __devinit amd64_init_one_instance(struct pci_dev *pdev,
 					     const struct pci_device_id *mc_type)
 {
 	int ret = 0;
+	u8 nid = get_node_id(pdev);
+	struct ecc_settings *s;
 
 	ret = pci_enable_device(pdev);
 	if (ret < 0) {
@@ -2661,9 +2668,16 @@ static int __devinit amd64_init_one_instance(struct pci_dev *pdev,
 		return -EIO;
 	}
 
+	ret = -ENOMEM;
+	s = kzalloc(sizeof(struct ecc_settings), GFP_KERNEL);
+	if (!s)
+		return ret;
+
+	ecc_stngs[nid] = s;
+
 	ret = amd64_probe_one_instance(pdev);
 	if (ret < 0)
-		amd64_err("Error probing instance: %d\n", get_node_id(pdev));
+		amd64_err("Error probing instance: %d\n", nid);
 
 	return ret;
 }
@@ -2688,6 +2702,9 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 	amd_report_gart_errors(false);
 	amd_unregister_ecc_decoder(amd64_decode_bus_error);
 
+	kfree(ecc_stngs[pvt->mc_node_id]);
+	ecc_stngs[pvt->mc_node_id] = NULL;
+
 	/* Free the EDAC CORE resources */
 	mci->pvt_info = NULL;
 	mcis[pvt->mc_node_id] = NULL;
@@ -2767,9 +2784,10 @@ static int __init amd64_edac_init(void)
 		goto err_ret;
 
 	err = -ENOMEM;
-	pvts = kzalloc(amd_nb_num() * sizeof(pvts[0]), GFP_KERNEL);
-	mcis = kzalloc(amd_nb_num() * sizeof(mcis[0]), GFP_KERNEL);
-	if (!(pvts && mcis))
+	pvts	  = kzalloc(amd_nb_num() * sizeof(pvts[0]), GFP_KERNEL);
+	mcis	  = kzalloc(amd_nb_num() * sizeof(mcis[0]), GFP_KERNEL);
+	ecc_stngs = kzalloc(amd_nb_num() * sizeof(ecc_stngs[0]), GFP_KERNEL);
+	if (!(pvts && mcis && ecc_stngs))
 		goto err_ret;
 
 	msrs = msrs_alloc();
@@ -2820,6 +2838,9 @@ static void __exit amd64_edac_exit(void)
 
 	pci_unregister_driver(&amd64_pci_driver);
 
+	kfree(ecc_stngs);
+	ecc_stngs = NULL;
+
 	kfree(mcis);
 	mcis = NULL;
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 4bc6f18..b76dce9 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -461,17 +461,21 @@ struct amd64_pvt {
 	/* place to store error injection parameters prior to issue */
 	struct error_injection injection;
 
-	/* Save old hw registers' values before we modified them */
-	u32 nbctl_mcgctl_saved;		/* When true, following 2 are valid */
-	u32 old_nbctl;
-
 	/* DCT per-family scrubrate setting */
 	u32 min_scrubrate;
 
 	/* family name this instance is running on */
 	const char *ctl_name;
 
-	/* misc settings */
+};
+
+/*
+ * per-node ECC settings descriptor
+ */
+struct ecc_settings {
+	u32 old_nbctl;
+	bool nbctl_valid;
+
 	struct flags {
 		unsigned long nb_mce_enable:1;
 		unsigned long nb_ecc_prev:1;
-- 
1.7.3.1.50.g1e633

