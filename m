Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1BJRS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:18:59 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44648 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab1BJRPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:52 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 17/30] amd64_edac: Simplify decoding path
Date: Thu, 10 Feb 2011 18:15:20 +0100
Message-Id: <1297358133-14320-18-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Use the struct mce directly instead of copying from it into a custom
struct err_regs.

No functionality change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   76 ++++++++++++++++-----------------------------
 drivers/edac/amd64_edac.h |   12 +++++--
 drivers/edac/mce_amd.h    |   12 -------
 3 files changed, 35 insertions(+), 65 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 1ec0145..c917330 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -788,11 +788,6 @@ static int sys_addr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr)
 
 static int get_channel_from_ecc_syndrome(struct mem_ctl_info *, u16);
 
-static u16 extract_syndrome(struct err_regs *err)
-{
-	return ((err->nbsh >> 15) & 0xff) | ((err->nbsl >> 16) & 0xff00);
-}
-
 /*
  * Determine if the DIMMs have ECC enabled. ECC is enabled ONLY if all the DIMMs
  * are ECC capable.
@@ -975,12 +970,10 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 	return (flag) ? 2 : 1;
 }
 
-/* Extract the ERROR ADDRESS for the K8 CPUs */
-static u64 k8_get_error_address(struct mem_ctl_info *mci,
-				struct err_regs *info)
+static u64 k8_get_error_address(struct mem_ctl_info *mci, struct mce *m)
 {
-	return (((u64) (info->nbeah & 0xff)) << 32) +
-			(info->nbeal & ~0x03);
+	/* ErrAddr[39:3] */
+	return m->addr & GENMASK(3, 39);
 }
 
 static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
@@ -1000,18 +993,16 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_HI + off, &pvt->ranges[range].lim.hi);
 }
 
-static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
-				    struct err_regs *err_info, u64 sys_addr)
+static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
+				    u16 syndrome)
 {
 	struct mem_ctl_info *src_mci;
+	struct amd64_pvt *pvt = mci->pvt_info;
 	int channel, csrow;
 	u32 page, offset;
-	u16 syndrome;
-
-	syndrome = extract_syndrome(err_info);
 
 	/* CHIPKILL enabled */
-	if (err_info->nbcfg & NBCFG_CHIPKILL) {
+	if (pvt->nbcfg & NBCFG_CHIPKILL) {
 		channel = get_channel_from_ecc_syndrome(mci, syndrome);
 		if (channel < 0) {
 			/*
@@ -1136,11 +1127,9 @@ static int f10_dbam_to_chip_select(struct amd64_pvt *pvt, int cs_mode)
 	return dbam_map[cs_mode];
 }
 
-static u64 f10_get_error_address(struct mem_ctl_info *mci,
-			struct err_regs *info)
+static u64 f10_get_error_address(struct mem_ctl_info *mci, struct mce *m)
 {
-	return (((u64) (info->nbeah & 0xffff)) << 32) +
-			(info->nbeal & ~0x01);
+	return m->addr & GENMASK(1, 47);
 }
 
 static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
@@ -1434,14 +1423,12 @@ static int f10_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
  * The @sys_addr is usually an error address received from the hardware
  * (MCX_ADDR).
  */
-static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
-				     struct err_regs *err_info,
-				     u64 sys_addr)
+static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
+				     u16 syndrome)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u32 page, offset;
 	int nid, csrow, chan = 0;
-	u16 syndrome;
 
 	csrow = f10_translate_sysaddr_to_cs(pvt, sys_addr, &nid, &chan);
 
@@ -1452,8 +1439,6 @@ static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 
 	error_address_to_page_and_offset(sys_addr, &page, &offset);
 
-	syndrome = extract_syndrome(err_info);
-
 	/*
 	 * We need the syndromes for channel detection only when we're
 	 * ganged. Otherwise @chan should already contain the channel at
@@ -1740,29 +1725,29 @@ static int get_channel_from_ecc_syndrome(struct mem_ctl_info *mci, u16 syndrome)
  * Handle any Correctable Errors (CEs) that have occurred. Check for valid ERROR
  * ADDRESS and process.
  */
-static void amd64_handle_ce(struct mem_ctl_info *mci,
-			    struct err_regs *info)
+static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u64 sys_addr;
+	u16 syndrome;
 
 	/* Ensure that the Error Address is VALID */
-	if (!(info->nbsh & NBSH_VALID_ERROR_ADDR)) {
+	if (!(m->status & MCI_STATUS_ADDRV)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
 		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
 		return;
 	}
 
-	sys_addr = pvt->ops->get_error_address(mci, info);
+	sys_addr = pvt->ops->get_error_address(mci, m);
+	syndrome = extract_syndrome(m->status);
 
 	amd64_mc_err(mci, "CE ERROR_ADDRESS= 0x%llx\n", sys_addr);
 
-	pvt->ops->map_sysaddr_to_csrow(mci, info, sys_addr);
+	pvt->ops->map_sysaddr_to_csrow(mci, sys_addr, syndrome);
 }
 
 /* Handle any Un-correctable Errors (UEs) */
-static void amd64_handle_ue(struct mem_ctl_info *mci,
-			    struct err_regs *info)
+static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	struct mem_ctl_info *log_mci, *src_mci = NULL;
@@ -1772,13 +1757,13 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 
 	log_mci = mci;
 
-	if (!(info->nbsh & NBSH_VALID_ERROR_ADDR)) {
+	if (!(m->status & MCI_STATUS_ADDRV)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
 		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
 		return;
 	}
 
-	sys_addr = pvt->ops->get_error_address(mci, info);
+	sys_addr = pvt->ops->get_error_address(mci, m);
 
 	/*
 	 * Find out which node the error address belongs to. This may be
@@ -1806,11 +1791,11 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 }
 
 static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
-					    struct err_regs *info)
+					    struct mce *m)
 {
-	u16 ec = EC(info->nbsl);
-	u8 xec = XEC(info->nbsl, 0x1f);
-	int ecc_type = (info->nbsh >> 13) & 0x3;
+	u16 ec = EC(m->status);
+	u8 xec = XEC(m->status, 0x1f);
+	u8 ecc_type = (m->status >> 45) & 0x3;
 
 	/* Bail early out if this was an 'observed' error */
 	if (PP(ec) == NBSL_PP_OBS)
@@ -1821,23 +1806,16 @@ static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
 		return;
 
 	if (ecc_type == 2)
-		amd64_handle_ce(mci, info);
+		amd64_handle_ce(mci, m);
 	else if (ecc_type == 1)
-		amd64_handle_ue(mci, info);
+		amd64_handle_ue(mci, m);
 }
 
 void amd64_decode_bus_error(int node_id, struct mce *m, u32 nbcfg)
 {
 	struct mem_ctl_info *mci = mcis[node_id];
-	struct err_regs regs;
-
-	regs.nbsl  = (u32) m->status;
-	regs.nbsh  = (u32)(m->status >> 32);
-	regs.nbeal = (u32) m->addr;
-	regs.nbeah = (u32)(m->addr >> 32);
-	regs.nbcfg = nbcfg;
 
-	__amd64_decode_bus_error(mci, &regs);
+	__amd64_decode_bus_error(mci, m);
 }
 
 /*
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 04293306..ba16535 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -397,6 +397,11 @@ static inline u64 get_dram_limit(struct amd64_pvt *pvt, unsigned i)
 	return (((u64)pvt->ranges[i].lim.hi & 0x000000ff) << 40) | lim;
 }
 
+static inline u16 extract_syndrome(u64 status)
+{
+	return ((status >> 47) & 0xff) | ((status >> 16) & 0xff00);
+}
+
 /*
  * per-node ECC settings descriptor
  */
@@ -440,11 +445,10 @@ extern struct mcidev_sysfs_attribute amd64_dbg_attrs[NUM_DBG_ATTRS],
 struct low_ops {
 	int (*early_channel_count)	(struct amd64_pvt *pvt);
 
-	u64 (*get_error_address)	(struct mem_ctl_info *mci,
-					 struct err_regs *info);
+	u64 (*get_error_address)	(struct mem_ctl_info *mci, struct mce *m);
 	void (*read_dram_ctl_register)	(struct amd64_pvt *pvt);
-	void (*map_sysaddr_to_csrow)	(struct mem_ctl_info *mci,
-					 struct err_regs *info, u64 SystemAddr);
+	void (*map_sysaddr_to_csrow)	(struct mem_ctl_info *mci, u64 sys_addr,
+					 u16 syndrome);
 	int (*dbam_to_cs)		(struct amd64_pvt *pvt, int cs_mode);
 	int (*read_dct_pci_cfg)		(struct amd64_pvt *pvt, int offset,
 					 u32 *val, const char *func);
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index 70a0bb2..795a320 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -34,7 +34,6 @@
 /*
  * F3x4C bits (MCi_STATUS' high half)
  */
-#define NBSH_VALID_ERROR_ADDR		BIT(26)
 #define NBSH_ERR_CPU_VAL		BIT(24)
 
 enum tt_ids {
@@ -78,17 +77,6 @@ extern const char *to_msgs[];
 extern const char *ii_msgs[];
 
 /*
- * relevant NB regs
- */
-struct err_regs {
-	u32 nbcfg;
-	u32 nbsh;
-	u32 nbsl;
-	u32 nbeah;
-	u32 nbeal;
-};
-
-/*
  * per-family decoder ops
  */
 struct amd_decoder_ops {
-- 
1.7.4.rc2

