Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1BJRTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:19:46 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44634 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab1BJRPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:44 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 13/30] amd64_edac: Cleanup NBCFG handling
Date: Thu, 10 Feb 2011 18:15:16 +0100
Message-Id: <1297358133-14320-14-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

The fact whether we are chipkill capable or not does not have any
bearing when computing the channel index on a ganged DCT configuration
so remove that. Also, simplify debug statements. Finally, remove old
error injection leftovers, while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   45 +++++++++++++++++++++------------------------
 drivers/edac/amd64_edac.h |    9 +++------
 2 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 9a8a313..dfa7ac7 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1011,7 +1011,7 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 	syndrome = extract_syndrome(err_info);
 
 	/* CHIPKILL enabled */
-	if (err_info->nbcfg & K8_NBCFG_CHIPKILL) {
+	if (err_info->nbcfg & NBCFG_CHIPKILL) {
 		channel = get_channel_from_ecc_syndrome(mci, syndrome);
 		if (channel < 0) {
 			/*
@@ -1461,7 +1461,7 @@ static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 	 * ganged. Otherwise @chan should already contain the channel at
 	 * this point.
 	 */
-	if (dct_ganging_enabled(pvt) && (pvt->nbcfg & K8_NBCFG_CHIPKILL))
+	if (dct_ganging_enabled(pvt))
 		chan = get_channel_from_ecc_syndrome(mci, syndrome);
 
 	if (chan >= 0)
@@ -2050,14 +2050,13 @@ static int init_csrows(struct mem_ctl_info *mci)
 	u32 val;
 	int i, empty = 1;
 
-	amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &val);
+	amd64_read_pci_cfg(pvt->F3, NBCFG, &val);
 
 	pvt->nbcfg = val;
-	pvt->ctl_error_info.nbcfg = val;
 
 	debugf0("node %d, NBCFG=0x%08x[ChipKillEccCap: %d|DramEccEn: %d]\n",
 		pvt->mc_node_id, val,
-		!!(val & K8_NBCFG_CHIPKILL), !!(val & K8_NBCFG_ECC_ENABLE));
+		!!(val & NBCFG_CHIPKILL), !!(val & NBCFG_ECC_ENABLE));
 
 	for_each_chip_select(i, 0, pvt) {
 		csrow = &mci->csrows[i];
@@ -2099,9 +2098,9 @@ static int init_csrows(struct mem_ctl_info *mci)
 		/*
 		 * determine whether CHIPKILL or JUST ECC or NO ECC is operating
 		 */
-		if (pvt->nbcfg & K8_NBCFG_ECC_ENABLE)
+		if (pvt->nbcfg & NBCFG_ECC_ENABLE)
 			csrow->edac_mode =
-			    (pvt->nbcfg & K8_NBCFG_CHIPKILL) ?
+			    (pvt->nbcfg & NBCFG_CHIPKILL) ?
 			    EDAC_S4ECD4ED : EDAC_SECDED;
 		else
 			csrow->edac_mode = EDAC_NONE;
@@ -2211,24 +2210,23 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 	value |= mask;
 	amd64_write_pci_cfg(F3, NBCTL, value);
 
-	amd64_read_pci_cfg(F3, K8_NBCFG, &value);
+	amd64_read_pci_cfg(F3, NBCFG, &value);
 
-	debugf0("1: node %d, NBCFG=0x%08x[ChipKillEccCap: %d|DramEccEn: %d]\n",
-		nid, value,
-		!!(value & K8_NBCFG_CHIPKILL), !!(value & K8_NBCFG_ECC_ENABLE));
+	debugf0("1: node %d, NBCFG=0x%08x[DramEccEn: %d]\n",
+		nid, value, !!(value & NBCFG_ECC_ENABLE));
 
-	if (!(value & K8_NBCFG_ECC_ENABLE)) {
+	if (!(value & NBCFG_ECC_ENABLE)) {
 		amd64_warn("DRAM ECC disabled on this node, enabling...\n");
 
 		s->flags.nb_ecc_prev = 0;
 
 		/* Attempt to turn on DRAM ECC Enable */
-		value |= K8_NBCFG_ECC_ENABLE;
-		amd64_write_pci_cfg(F3, K8_NBCFG, value);
+		value |= NBCFG_ECC_ENABLE;
+		amd64_write_pci_cfg(F3, NBCFG, value);
 
-		amd64_read_pci_cfg(F3, K8_NBCFG, &value);
+		amd64_read_pci_cfg(F3, NBCFG, &value);
 
-		if (!(value & K8_NBCFG_ECC_ENABLE)) {
+		if (!(value & NBCFG_ECC_ENABLE)) {
 			amd64_warn("Hardware rejected DRAM ECC enable,"
 				   "check memory DIMM configuration.\n");
 			ret = false;
@@ -2239,9 +2237,8 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 		s->flags.nb_ecc_prev = 1;
 	}
 
-	debugf0("2: node %d, NBCFG=0x%08x[ChipKillEccCap: %d|DramEccEn: %d]\n",
-		nid, value,
-		!!(value & K8_NBCFG_CHIPKILL), !!(value & K8_NBCFG_ECC_ENABLE));
+	debugf0("2: node %d, NBCFG=0x%08x[DramEccEn: %d]\n",
+		nid, value, !!(value & NBCFG_ECC_ENABLE));
 
 	return ret;
 }
@@ -2263,9 +2260,9 @@ static void restore_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 
 	/* restore previous BIOS DRAM ECC "off" setting we force-enabled */
 	if (!s->flags.nb_ecc_prev) {
-		amd64_read_pci_cfg(F3, K8_NBCFG, &value);
-		value &= ~K8_NBCFG_ECC_ENABLE;
-		amd64_write_pci_cfg(F3, K8_NBCFG, value);
+		amd64_read_pci_cfg(F3, NBCFG, &value);
+		value &= ~NBCFG_ECC_ENABLE;
+		amd64_write_pci_cfg(F3, NBCFG, value);
 	}
 
 	/* restore the NB Enable MCGCTL bit */
@@ -2291,9 +2288,9 @@ static bool ecc_enabled(struct pci_dev *F3, u8 nid)
 	u8 ecc_en = 0;
 	bool nb_mce_en = false;
 
-	amd64_read_pci_cfg(F3, K8_NBCFG, &value);
+	amd64_read_pci_cfg(F3, NBCFG, &value);
 
-	ecc_en = !!(value & K8_NBCFG_ECC_ENABLE);
+	ecc_en = !!(value & NBCFG_ECC_ENABLE);
 	amd64_info("DRAM ECC %s.\n", (ecc_en ? "enabled" : "disabled"));
 
 	nb_mce_en = amd64_nb_mce_bank_enabled_on_node(nid);
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index fc609d1..6c52736 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -246,9 +246,9 @@
  */
 #define NBCTL				0x40
 
-#define K8_NBCFG			0x44
-#define K8_NBCFG_CHIPKILL		BIT(23)
-#define K8_NBCFG_ECC_ENABLE		BIT(22)
+#define NBCFG				0x44
+#define NBCFG_CHIPKILL			BIT(23)
+#define NBCFG_ECC_ENABLE		BIT(22)
 
 #define K8_NBSL				0x48
 
@@ -420,9 +420,6 @@ struct amd64_pvt {
 	/* x4 or x8 syndromes in use */
 	u8 syn_type;
 
-	/* temp storage for when input is received from sysfs */
-	struct err_regs ctl_error_info;
-
 	/* place to store error injection parameters prior to issue */
 	struct error_injection injection;
 
-- 
1.7.4.rc2

