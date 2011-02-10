Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab1BJRTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:19:00 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44651 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab1BJRPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:52 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 18/30] amd64_edac: Unify get_error_address
Date: Thu, 10 Feb 2011 18:15:21 +0100
Message-Id: <1297358133-14320-19-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

The address bits from MC4_STATUS differ only between K8 and the rest so
no need for a per-family method.

No functional change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   26 +++++++++++++-------------
 drivers/edac/amd64_edac.h |    2 --
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c917330..7a7bd77 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -970,10 +970,18 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 	return (flag) ? 2 : 1;
 }
 
-static u64 k8_get_error_address(struct mem_ctl_info *mci, struct mce *m)
+/* On F10h and later ErrAddr is MC4_ADDR[47:1] */
+static u64 get_error_address(struct mce *m)
 {
-	/* ErrAddr[39:3] */
-	return m->addr & GENMASK(3, 39);
+	u8 start_bit = 1;
+	u8 end_bit   = 47;
+
+	if (boot_cpu_data.x86 == 0xf) {
+		start_bit = 3;
+		end_bit   = 39;
+	}
+
+	return m->addr & GENMASK(start_bit, end_bit);
 }
 
 static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
@@ -1127,11 +1135,6 @@ static int f10_dbam_to_chip_select(struct amd64_pvt *pvt, int cs_mode)
 	return dbam_map[cs_mode];
 }
 
-static u64 f10_get_error_address(struct mem_ctl_info *mci, struct mce *m)
-{
-	return m->addr & GENMASK(1, 47);
-}
-
 static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
 {
 
@@ -1512,7 +1515,6 @@ static struct amd64_family_type amd64_family_types[] = {
 		.f3_id = PCI_DEVICE_ID_AMD_K8_NB_MISC,
 		.ops = {
 			.early_channel_count	= k8_early_channel_count,
-			.get_error_address	= k8_get_error_address,
 			.map_sysaddr_to_csrow	= k8_map_sysaddr_to_csrow,
 			.dbam_to_cs		= k8_dbam_to_chip_select,
 			.read_dct_pci_cfg	= k8_read_dct_pci_cfg,
@@ -1524,7 +1526,6 @@ static struct amd64_family_type amd64_family_types[] = {
 		.f3_id = PCI_DEVICE_ID_AMD_10H_NB_MISC,
 		.ops = {
 			.early_channel_count	= f1x_early_channel_count,
-			.get_error_address	= f10_get_error_address,
 			.read_dram_ctl_register	= f10_read_dram_ctl_register,
 			.map_sysaddr_to_csrow	= f10_map_sysaddr_to_csrow,
 			.dbam_to_cs		= f10_dbam_to_chip_select,
@@ -1738,7 +1739,7 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 		return;
 	}
 
-	sys_addr = pvt->ops->get_error_address(mci, m);
+	sys_addr = get_error_address(m);
 	syndrome = extract_syndrome(m->status);
 
 	amd64_mc_err(mci, "CE ERROR_ADDRESS= 0x%llx\n", sys_addr);
@@ -1749,7 +1750,6 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 /* Handle any Un-correctable Errors (UEs) */
 static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 {
-	struct amd64_pvt *pvt = mci->pvt_info;
 	struct mem_ctl_info *log_mci, *src_mci = NULL;
 	int csrow;
 	u64 sys_addr;
@@ -1763,7 +1763,7 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 		return;
 	}
 
-	sys_addr = pvt->ops->get_error_address(mci, m);
+	sys_addr = get_error_address(m);
 
 	/*
 	 * Find out which node the error address belongs to. This may be
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index ba16535..6ae8aa8 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -444,8 +444,6 @@ extern struct mcidev_sysfs_attribute amd64_dbg_attrs[NUM_DBG_ATTRS],
  */
 struct low_ops {
 	int (*early_channel_count)	(struct amd64_pvt *pvt);
-
-	u64 (*get_error_address)	(struct mem_ctl_info *mci, struct mce *m);
 	void (*read_dram_ctl_register)	(struct amd64_pvt *pvt);
 	void (*map_sysaddr_to_csrow)	(struct mem_ctl_info *mci, u64 sys_addr,
 					 u16 syndrome);
-- 
1.7.4.rc2

