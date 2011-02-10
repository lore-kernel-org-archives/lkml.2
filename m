Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab1BJRQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:16:36 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44689 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab1BJRQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:16:14 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 30/30] amd64_edac: Enable driver on F15h
Date: Thu, 10 Feb 2011 18:15:33 +0100
Message-Id: <1297358133-14320-31-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add the PCI device ids required for driver registration. Remove
pvt->ctl_name and use the family descriptor directly, instead. Then,
bump driver version and fixup its format. Finally, enable DRAM ECC
decoding on F15h.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   30 +++++++++++++++++++++++-------
 drivers/edac/amd64_edac.h |    8 +++-----
 drivers/edac/mce_amd.c    |    6 +++---
 3 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e4b2792..70e0f84 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1604,6 +1604,8 @@ static struct amd64_family_type amd64_family_types[] = {
 	},
 	[F15_CPUS] = {
 		.ctl_name = "F15h",
+		.f1_id = PCI_DEVICE_ID_AMD_15H_NB_F1,
+		.f3_id = PCI_DEVICE_ID_AMD_15H_NB_F3,
 		.ops = {
 			.early_channel_count	= f1x_early_channel_count,
 			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
@@ -2363,7 +2365,8 @@ static void set_mc_sysfs_attrs(struct mem_ctl_info *mci)
 	mci->mc_driver_sysfs_attributes = sysfs_attrs;
 }
 
-static void setup_mci_misc_attrs(struct mem_ctl_info *mci)
+static void setup_mci_misc_attrs(struct mem_ctl_info *mci,
+				 struct amd64_family_type *fam)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 
@@ -2379,7 +2382,7 @@ static void setup_mci_misc_attrs(struct mem_ctl_info *mci)
 	mci->edac_cap		= amd64_determine_edac_cap(pvt);
 	mci->mod_name		= EDAC_MOD_STR;
 	mci->mod_ver		= EDAC_AMD64_VERSION;
-	mci->ctl_name		= pvt->ctl_name;
+	mci->ctl_name		= fam->ctl_name;
 	mci->dev_name		= pci_name(pvt->F2);
 	mci->ctl_page_to_phys	= NULL;
 
@@ -2400,12 +2403,16 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 	case 0xf:
 		fam_type		= &amd64_family_types[K8_CPUS];
 		pvt->ops		= &amd64_family_types[K8_CPUS].ops;
-		pvt->ctl_name		= fam_type->ctl_name;
 		break;
+
 	case 0x10:
 		fam_type		= &amd64_family_types[F10_CPUS];
 		pvt->ops		= &amd64_family_types[F10_CPUS].ops;
-		pvt->ctl_name		= fam_type->ctl_name;
+		break;
+
+	case 0x15:
+		fam_type		= &amd64_family_types[F15_CPUS];
+		pvt->ops		= &amd64_family_types[F15_CPUS].ops;
 		break;
 
 	default:
@@ -2415,7 +2422,7 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 
 	pvt->ext_model = boot_cpu_data.x86_model >> 4;
 
-	amd64_info("%s %sdetected (node %d).\n", pvt->ctl_name,
+	amd64_info("%s %sdetected (node %d).\n", fam_type->ctl_name,
 		     (fam == 0xf ?
 				(pvt->ext_model >= K8_REV_F  ? "revF or later "
 							     : "revE or earlier ")
@@ -2469,7 +2476,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	mci->pvt_info = pvt;
 	mci->dev = &pvt->F2->dev;
 
-	setup_mci_misc_attrs(mci);
+	setup_mci_misc_attrs(mci, fam_type);
 
 	if (init_csrows(mci))
 		mci->edac_cap = EDAC_FLAG_NONE;
@@ -2612,6 +2619,15 @@ static const struct pci_device_id amd64_pci_table[] __devinitdata = {
 		.class		= 0,
 		.class_mask	= 0,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_AMD,
+		.device		= PCI_DEVICE_ID_AMD_15H_NB_F2,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.class		= 0,
+		.class_mask	= 0,
+	},
+
 	{0, }
 };
 MODULE_DEVICE_TABLE(pci, amd64_pci_table);
@@ -2652,7 +2668,7 @@ static int __init amd64_edac_init(void)
 {
 	int err = -ENODEV;
 
-	edac_printk(KERN_INFO, EDAC_MOD_STR, EDAC_AMD64_VERSION "\n");
+	printk(KERN_INFO "AMD64 EDAC driver v%s\n", EDAC_AMD64_VERSION);
 
 	opstate_init();
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 4de31c8..4ece4f4 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -144,7 +144,7 @@
  *         sections 3.5.4 and 3.5.5 for more information.
  */
 
-#define EDAC_AMD64_VERSION		"v3.3.0"
+#define EDAC_AMD64_VERSION		"3.4.0"
 #define EDAC_MOD_STR			"amd64_edac"
 
 /* Extended Model from CPUID, for CPU Revision numbers */
@@ -170,6 +170,8 @@
 /*
  * PCI-defined configuration space registers
  */
+#define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
+#define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
 
 
 /*
@@ -367,10 +369,6 @@ struct amd64_pvt {
 
 	/* place to store error injection parameters prior to issue */
 	struct error_injection injection;
-
-	/* family name this instance is running on */
-	const char *ctl_name;
-
 };
 
 static inline u64 get_dram_base(struct amd64_pvt *pvt, unsigned i)
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 1afca60..795cfbc 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -594,6 +594,7 @@ static bool nb_noop_mce(u16 ec, u8 xec)
 
 void amd_decode_nb_mce(int node_id, struct mce *m, u32 nbcfg)
 {
+	struct cpuinfo_x86 *c = &boot_cpu_data;
 	u16 ec   = EC(m->status);
 	u8 xec   = XEC(m->status, 0x1f);
 	u32 nbsh = (u32)(m->status >> 32);
@@ -602,8 +603,7 @@ void amd_decode_nb_mce(int node_id, struct mce *m, u32 nbcfg)
 	pr_emerg(HW_ERR "Northbridge Error (node %d", node_id);
 
 	/* F10h, revD can disable ErrCpu[3:0] through ErrCpuVal */
-	if ((boot_cpu_data.x86 == 0x10) &&
-	    (boot_cpu_data.x86_model > 7)) {
+	if (c->x86 == 0x10 && c->x86_model > 7) {
 		if (nbsh & NBSH_ERR_CPU_VAL)
 			core = nbsh & nb_err_cpumask;
 	} else {
@@ -646,7 +646,7 @@ void amd_decode_nb_mce(int node_id, struct mce *m, u32 nbcfg)
 	if (!fam_ops->nb_mce(ec, xec))
 		goto wrong_nb_mce;
 
-	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10)
+	if (c->x86 == 0xf || c->x86 == 0x10 || c->x86 == 0x15)
 		if ((xec == 0x8 || xec == 0x0) && nb_bus_decoder)
 			nb_bus_decoder(node_id, m, nbcfg);
 
-- 
1.7.4.rc2

