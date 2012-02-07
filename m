Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2BGO2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:28:10 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34168 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab2BGO0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:26:50 -0500
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/6] MCE, AMD: Rework NB MCE signatures
Date: Tue,  7 Feb 2012 15:26:05 +0100
Message-Id: <1328624767-7956-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1328624767-7956-1-git-send-email-bp@amd64.org>
References: <1328624767-7956-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Correct their formulation, replace per-family functions with a single,
unified lookup table.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Reviewed-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/edac/mce_amd.c |  176 +++++++++++++-----------------------------------
 drivers/edac/mce_amd.h |    1 -
 2 files changed, 48 insertions(+), 129 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index bf6dd99..f6ebe5e 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -64,17 +64,6 @@ EXPORT_SYMBOL_GPL(to_msgs);
 const char *ii_msgs[] = { "MEM", "RESV", "IO", "GEN" };
 EXPORT_SYMBOL_GPL(ii_msgs);
 
-static const char *f10h_nb_mce_desc[] = {
-	"HT link data error",
-	"Protocol error (link, L3, probe filter, etc.)",
-	"Parity error in NB-internal arrays",
-	"Link Retry due to IO link transmission error",
-	"L3 ECC data cache error",
-	"ECC error in L3 cache tag",
-	"L3 LRU parity bits error",
-	"ECC Error in the Probe Filter directory"
-};
-
 static const char * const f15h_ic_mce_desc[] = {
 	"UC during a demand linefill from L2",
 	"Parity error during data load from IC",
@@ -112,6 +101,28 @@ static const char * const f15h_cu_mce_desc[] = {
 	"PRB address parity error"
 };
 
+static const char *nb_mce_desc[] = {
+	"DRAM ECC error detected on the NB",
+	"CRC error detected on HT link",
+	"Link-defined sync error packets detected on HT link",
+	"HT Master abort",
+	"HT Target abort",
+	"Invalid GART PTE entry during GART table walk",
+	"Unsupported atomic RMW received from an IO link",
+	"Watchdog timeout due to lack of progress",
+	"DRAM ECC error detected on the NB",
+	"SVM DMA Exclusion Vector error",
+	"HT data error detected on link",
+	"Protocol error (link, L3, probe filter)",
+	"NB internal arrays parity error",
+	"DRAM addr/ctl signals parity error",
+	"IO link transmission error",
+	"L3 data cache ECC error",			/* xec = 0x1c */
+	"L3 cache tag error",
+	"L3 LRU parity bits error",
+	"ECC Error in the Probe Filter directory"
+};
+
 static const char * const fr_ex_mce_desc[] = {
 	"CPU Watchdog timer expire",
 	"Wakeup array dest tag",
@@ -499,58 +510,31 @@ wrong_ls_mce:
 	pr_emerg(HW_ERR "Corrupted LS MCE info?\n");
 }
 
-static bool k8_nb_mce(u16 ec, u8 xec)
+void amd_decode_nb_mce(struct mce *m)
 {
-	bool ret = true;
-
-	switch (xec) {
-	case 0x1:
-		pr_cont("CRC error detected on HT link.\n");
-		break;
-
-	case 0x5:
-		pr_cont("Invalid GART PTE entry during GART table walk.\n");
-		break;
-
-	case 0x6:
-		pr_cont("Unsupported atomic RMW received from an IO link.\n");
-		break;
-
-	case 0x0:
-	case 0x8:
-		if (boot_cpu_data.x86 == 0x11)
-			return false;
-
-		pr_cont("DRAM ECC error detected on the NB.\n");
-		break;
-
-	case 0xd:
-		pr_cont("Parity error on the DRAM addr/ctl signals.\n");
-		break;
-
-	default:
-		ret = false;
-		break;
-	}
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	int node_id = amd_get_nb_id(m->extcpu);
+	u16 ec = EC(m->status);
+	u8 xec = XEC(m->status, 0x1f);
+	u8 offset = 0;
 
-	return ret;
-}
+	pr_emerg(HW_ERR "Northbridge Error (node %d): ", node_id);
 
-static bool f10h_nb_mce(u16 ec, u8 xec)
-{
-	bool ret = true;
-	u8 offset = 0;
+	switch (xec) {
+	case 0x0 ... 0xe:
 
-	if (k8_nb_mce(ec, xec))
-		return true;
+		/* special handling for DRAM ECCs */
+		if (xec == 0x0 || xec == 0x8) {
+			/* no ECCs on F11h */
+			if (c->x86 == 0x11)
+				goto wrong_nb_mce;
 
-	switch(xec) {
-	case 0xa ... 0xc:
-		offset = 10;
-		break;
+			pr_cont("%s.\n", nb_mce_desc[xec]);
 
-	case 0xe:
-		offset = 11;
+			if (nb_bus_decoder)
+				nb_bus_decoder(node_id, m);
+			return;
+		}
 		break;
 
 	case 0xf:
@@ -559,83 +543,25 @@ static bool f10h_nb_mce(u16 ec, u8 xec)
 		else if (BUS_ERROR(ec))
 			pr_cont("DMA Exclusion Vector Table Walk error.\n");
 		else
-			ret = false;
-
-		goto out;
-		break;
+			goto wrong_nb_mce;
+		return;
 
 	case 0x19:
 		if (boot_cpu_data.x86 == 0x15)
 			pr_cont("Compute Unit Data Error.\n");
 		else
-			ret = false;
-
-		goto out;
-		break;
+			goto wrong_nb_mce;
+		return;
 
 	case 0x1c ... 0x1f:
-		offset = 24;
+		offset = 13;
 		break;
 
 	default:
-		ret = false;
-
-		goto out;
-		break;
-	}
-
-	pr_cont("%s.\n", f10h_nb_mce_desc[xec - offset]);
-
-out:
-	return ret;
-}
-
-static bool nb_noop_mce(u16 ec, u8 xec)
-{
-	return false;
-}
-
-void amd_decode_nb_mce(struct mce *m)
-{
-	struct cpuinfo_x86 *c = &boot_cpu_data;
-	int node_id = amd_get_nb_id(m->extcpu);
-	u16 ec = EC(m->status);
-	u8 xec = XEC(m->status, 0x1f);
-
-	pr_emerg(HW_ERR "Northbridge Error (node %d): ", node_id);
-
-	switch (xec) {
-	case 0x2:
-		pr_cont("Sync error (sync packets on HT link detected).\n");
-		return;
-
-	case 0x3:
-		pr_cont("HT Master abort.\n");
-		return;
-
-	case 0x4:
-		pr_cont("HT Target abort.\n");
-		return;
-
-	case 0x7:
-		pr_cont("NB Watchdog timeout.\n");
-		return;
-
-	case 0x9:
-		pr_cont("SVM DMA Exclusion Vector error.\n");
-		return;
-
-	default:
-		break;
-	}
-
-	if (!fam_ops->nb_mce(ec, xec))
 		goto wrong_nb_mce;
+	}
 
-	if (c->x86 == 0xf || c->x86 == 0x10 || c->x86 == 0x15)
-		if ((xec == 0x8 || xec == 0x0) && nb_bus_decoder)
-			nb_bus_decoder(node_id, m);
-
+	pr_cont("%s.\n", nb_mce_desc[xec - offset]);
 	return;
 
 wrong_nb_mce:
@@ -844,39 +770,33 @@ static int __init mce_amd_init(void)
 	case 0xf:
 		fam_ops->dc_mce = k8_dc_mce;
 		fam_ops->ic_mce = k8_ic_mce;
-		fam_ops->nb_mce = k8_nb_mce;
 		break;
 
 	case 0x10:
 		fam_ops->dc_mce = f10h_dc_mce;
 		fam_ops->ic_mce = k8_ic_mce;
-		fam_ops->nb_mce = f10h_nb_mce;
 		break;
 
 	case 0x11:
 		fam_ops->dc_mce = k8_dc_mce;
 		fam_ops->ic_mce = k8_ic_mce;
-		fam_ops->nb_mce = f10h_nb_mce;
 		break;
 
 	case 0x12:
 		fam_ops->dc_mce = f12h_dc_mce;
 		fam_ops->ic_mce = k8_ic_mce;
-		fam_ops->nb_mce = nb_noop_mce;
 		break;
 
 	case 0x14:
 		nb_err_cpumask  = 0x3;
 		fam_ops->dc_mce = f14h_dc_mce;
 		fam_ops->ic_mce = f14h_ic_mce;
-		fam_ops->nb_mce = nb_noop_mce;
 		break;
 
 	case 0x15:
 		xec_mask = 0x1f;
 		fam_ops->dc_mce = f15h_dc_mce;
 		fam_ops->ic_mce = f15h_ic_mce;
-		fam_ops->nb_mce = f10h_nb_mce;
 		break;
 
 	default:
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index 0106747..6fcf599 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -82,7 +82,6 @@ extern const char *ii_msgs[];
 struct amd_decoder_ops {
 	bool (*dc_mce)(u16, u8);
 	bool (*ic_mce)(u16, u8);
-	bool (*nb_mce)(u16, u8);
 };
 
 void amd_report_gart_errors(bool);
-- 
1.7.8.rc0

