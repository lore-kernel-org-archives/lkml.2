Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab1BJRQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:16:10 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44672 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab1BJRQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:16:05 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 25/30] amd64_edac: Sanitize ->read_dram_ctl_register
Date: Thu, 10 Feb 2011 18:15:28 +0100
Message-Id: <1297358133-14320-26-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This function is relevant for F10h and higher, and it has only one
callsite so drop its function pointer from the low_ops struct.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   14 +++++++-------
 drivers/edac/amd64_edac.h |    2 --
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 1cd82f9..b85487d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1138,16 +1138,18 @@ static int f10_dbam_to_chip_select(struct amd64_pvt *pvt, int cs_mode)
 	return dbam_map[cs_mode];
 }
 
-static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
+static void read_dram_ctl_register(struct amd64_pvt *pvt)
 {
 
+	if (boot_cpu_data.x86 == 0xf)
+		return;
+
 	if (!amd64_read_dct_pci_cfg(pvt, DCT_SEL_LO, &pvt->dct_sel_lo)) {
 		debugf0("F2x110 (DCTSelLow): 0x%08x, High range addrs at: 0x%x\n",
 			pvt->dct_sel_lo, dct_sel_baseaddr(pvt));
 
-		debugf0("  mode: %s, All DCTs on: %s\n",
-			(dct_ganging_enabled(pvt) ? "ganged" : "unganged"),
-			(dct_dram_enabled(pvt) ? "yes"   : "no"));
+		debugf0("  DCTs operate in %s mode.\n",
+			(dct_ganging_enabled(pvt) ? "ganged" : "unganged"));
 
 		if (!dct_ganging_enabled(pvt))
 			debugf0("  Address range split per DCT: %s\n",
@@ -1579,7 +1581,6 @@ static struct amd64_family_type amd64_family_types[] = {
 		.f3_id = PCI_DEVICE_ID_AMD_10H_NB_MISC,
 		.ops = {
 			.early_channel_count	= f1x_early_channel_count,
-			.read_dram_ctl_register	= f10_read_dram_ctl_register,
 			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
 			.dbam_to_cs		= f10_dbam_to_chip_select,
 			.read_dct_pci_cfg	= f10_read_dct_pci_cfg,
@@ -1939,8 +1940,7 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 
 	amd64_read_pci_cfg(pvt->F3, NBCAP, &pvt->nbcap);
 
-	if (pvt->ops->read_dram_ctl_register)
-		pvt->ops->read_dram_ctl_register(pvt);
+	read_dram_ctl_register(pvt);
 
 	for (range = 0; range < DRAM_RANGES; range++) {
 		u8 rw;
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 3c60b2f..e14a8d0 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -236,7 +236,6 @@
 #define dct_ganging_enabled(pvt)	((boot_cpu_data.x86 == 0x10) && ((pvt)->dct_sel_lo & BIT(4)))
 
 #define dct_data_intlv_enabled(pvt)	((pvt)->dct_sel_lo & BIT(5))
-#define dct_dram_enabled(pvt)		((pvt)->dct_sel_lo & BIT(8))
 #define dct_memory_cleared(pvt)		((pvt)->dct_sel_lo & BIT(10))
 
 #define SWAP_INTLV_REG			0x10c
@@ -444,7 +443,6 @@ extern struct mcidev_sysfs_attribute amd64_dbg_attrs[NUM_DBG_ATTRS],
  */
 struct low_ops {
 	int (*early_channel_count)	(struct amd64_pvt *pvt);
-	void (*read_dram_ctl_register)	(struct amd64_pvt *pvt);
 	void (*map_sysaddr_to_csrow)	(struct mem_ctl_info *mci, u64 sys_addr,
 					 u16 syndrome);
 	int (*dbam_to_cs)		(struct amd64_pvt *pvt, int cs_mode);
-- 
1.7.4.rc2

