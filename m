Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0FAN33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:29:29 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45653 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab0FAN3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:29:22 -0400
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <norsk5@yahoo.com>
Cc: <hpa@zytor.com>, <tglx@linutronix.de>, <linux-edac@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/6] amd64_edac: Dump syndrome size in debug mode
Date: Tue,  1 Jun 2010 15:29:26 +0200
Message-Id: <1275398971-12439-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275398971-12439-1-git-send-email-bp@amd64.org>
References: <1275398971-12439-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Cache ECC syndrome size and dump it in debug output.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   30 ++++++++++++++++++++----------
 drivers/edac/amd64_edac.h |    4 ++++
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index cf17dbb..297cc12 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -888,6 +888,8 @@ static void amd64_dump_misc_regs(struct amd64_pvt *pvt)
 		return;
 	}
 
+	debugf1("F3x180 (ECC symb.): %s\n", (pvt->x8_syndromes ? "x8" : "x4"));
+
 	/* Only if NOT ganged does dclr1 have valid info */
 	if (!dct_ganging_enabled(pvt))
 		amd64_dump_dramcfg_low(pvt->dclr1, 1);
@@ -1955,23 +1957,19 @@ static int map_err_sym_to_channel(int err_sym, int sym_size)
 static int get_channel_from_ecc_syndrome(struct mem_ctl_info *mci, u16 syndrome)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	u32 value = 0;
-	int err_sym = 0;
-
-	amd64_read_pci_cfg(pvt->misc_f3_ctl, 0x180, &value);
+	int err_sym = 0, sym_size = 0;
 
-	/* F3x180[EccSymbolSize]=1, x8 symbols */
-	if (boot_cpu_data.x86 == 0x10 &&
-	    boot_cpu_data.x86_model > 7 &&
-	    value & BIT(25)) {
+	if (pvt->x8_syndromes)	{
+		sym_size = 8;
 		err_sym = decode_syndrome(syndrome, x8_vectors,
 					  ARRAY_SIZE(x8_vectors), 8);
-		return map_err_sym_to_channel(err_sym, 8);
 	} else {
+		sym_size = 4;
 		err_sym = decode_syndrome(syndrome, x4_vectors,
 					  ARRAY_SIZE(x4_vectors), 4);
-		return map_err_sym_to_channel(err_sym, 4);
 	}
+
+	return map_err_sym_to_channel(err_sym, sym_size);
 }
 
 /*
@@ -2284,6 +2282,7 @@ static void amd64_free_mc_sibling_devices(struct amd64_pvt *pvt)
 static void amd64_read_mc_registers(struct amd64_pvt *pvt)
 {
 	u64 msr_val;
+	u32 tmp;
 	int dram;
 
 	/*
@@ -2353,6 +2352,17 @@ static void amd64_read_mc_registers(struct amd64_pvt *pvt)
 		amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCLR_1, &pvt->dclr1);
 		amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCHR_1, &pvt->dchr1);
 	}
+
+	amd64_read_pci_cfg(pvt->misc_f3_ctl, EXT_NB_MCA_CFG, &tmp);
+
+	/* F3x180[EccSymbolSize]=1, x8 symbols */
+	if (boot_cpu_data.x86 == 0x10 &&
+	    boot_cpu_data.x86_model > 7 &&
+	    tmp & BIT(25))
+		pvt->x8_syndromes = true;
+	else
+		pvt->x8_syndromes = false;
+
 	amd64_dump_misc_regs(pvt);
 }
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 0d4bf56..93bfdb4 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -382,6 +382,8 @@ enum {
 #define K8_NBCAP_SECDED			BIT(3)
 #define K8_NBCAP_DCT_DUAL		BIT(0)
 
+#define EXT_NB_MCA_CFG			0x180
+
 /* MSRs */
 #define K8_MSR_MCGCTL_NBE		BIT(4)
 
@@ -471,6 +473,8 @@ struct amd64_pvt {
 	u32 dram_ctl_select_high;	/* DRAM Controller Select High Reg */
 	u32 online_spare;               /* On-Line spare Reg */
 
+	bool x8_syndromes;
+
 	/* temp storage for when input is received from sysfs */
 	struct err_regs ctl_error_info;
 
-- 
1.7.1

