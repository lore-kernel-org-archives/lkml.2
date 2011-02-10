Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab1BJRTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:19:45 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44639 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab1BJRPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:45 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 14/30] amd64_edac: Cleanup NBSH cruft
Date: Thu, 10 Feb 2011 18:15:17 +0100
Message-Id: <1297358133-14320-15-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Remove reporting of errors with UC bit set - this is done by the MCE
decoding code anyway and this driver deals with DRAM ECC errors only. UC
(NB uncorrectable error) doesn't necessarily mean it is a DRAM error.
Remove unused macros while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   15 ++-------------
 drivers/edac/mce_amd.c    |    2 +-
 drivers/edac/mce_amd.h    |   18 +++++-------------
 3 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index dfa7ac7..04d481b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1748,7 +1748,7 @@ static void amd64_handle_ce(struct mem_ctl_info *mci,
 	u64 sys_addr;
 
 	/* Ensure that the Error Address is VALID */
-	if (!(info->nbsh & K8_NBSH_VALID_ERROR_ADDR)) {
+	if (!(info->nbsh & NBSH_VALID_ERROR_ADDR)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
 		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
 		return;
@@ -1773,7 +1773,7 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 
 	log_mci = mci;
 
-	if (!(info->nbsh & K8_NBSH_VALID_ERROR_ADDR)) {
+	if (!(info->nbsh & NBSH_VALID_ERROR_ADDR)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
 		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
 		return;
@@ -1839,17 +1839,6 @@ void amd64_decode_bus_error(int node_id, struct mce *m, u32 nbcfg)
 	regs.nbcfg = nbcfg;
 
 	__amd64_decode_bus_error(mci, &regs);
-
-	/*
-	 * Check the UE bit of the NB status high register, if set generate some
-	 * logs. If NOT a GART error, then process the event as a NO-INFO event.
-	 * If it was a GART error, skip that process.
-	 *
-	 * FIXME: this should go somewhere else, if at all.
-	 */
-	if (regs.nbsh & K8_NBSH_UC_ERR && !report_gart_errors)
-		edac_mc_handle_ue_no_info(mci, "UE bit is set");
-
 }
 
 /*
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index f6cf73d..1afca60 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -604,7 +604,7 @@ void amd_decode_nb_mce(int node_id, struct mce *m, u32 nbcfg)
 	/* F10h, revD can disable ErrCpu[3:0] through ErrCpuVal */
 	if ((boot_cpu_data.x86 == 0x10) &&
 	    (boot_cpu_data.x86_model > 7)) {
-		if (nbsh & K8_NBSH_ERR_CPU_VAL)
+		if (nbsh & NBSH_ERR_CPU_VAL)
 			core = nbsh & nb_err_cpumask;
 	} else {
 		u8 assoc_cpus = nbsh & nb_err_cpumask;
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index 45dda47..70a0bb2 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -31,19 +31,11 @@
 #define R4(x)				(((x) >> 4) & 0xf)
 #define R4_MSG(x)			((R4(x) < 9) ?  rrrr_msgs[R4(x)] : "Wrong R4!")
 
-#define K8_NBSH				0x4C
-
-#define K8_NBSH_VALID_BIT		BIT(31)
-#define K8_NBSH_OVERFLOW		BIT(30)
-#define K8_NBSH_UC_ERR			BIT(29)
-#define K8_NBSH_ERR_EN			BIT(28)
-#define K8_NBSH_MISCV			BIT(27)
-#define K8_NBSH_VALID_ERROR_ADDR	BIT(26)
-#define K8_NBSH_PCC			BIT(25)
-#define K8_NBSH_ERR_CPU_VAL		BIT(24)
-#define K8_NBSH_CECC			BIT(14)
-#define K8_NBSH_UECC			BIT(13)
-#define K8_NBSH_ERR_SCRUBER		BIT(8)
+/*
+ * F3x4C bits (MCi_STATUS' high half)
+ */
+#define NBSH_VALID_ERROR_ADDR		BIT(26)
+#define NBSH_ERR_CPU_VAL		BIT(24)
 
 enum tt_ids {
 	TT_INSTR = 0,
-- 
1.7.4.rc2

