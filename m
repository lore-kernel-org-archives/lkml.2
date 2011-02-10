Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab1BJRRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:17:04 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44686 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1BJRQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:16:12 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 29/30] amd64_edac: Adjust ECC symbol size to F15h
Date: Thu, 10 Feb 2011 18:15:32 +0100
Message-Id: <1297358133-14320-30-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

F15h has the same ECC symbol size options as F10h revD and later so
adjust checks to that. Simplify code a bit.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   32 +++++++++++++++-----------------
 drivers/edac/amd64_edac.h |    2 +-
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 0caf05e..e4b2792 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -824,7 +824,7 @@ static void dump_misc_regs(struct amd64_pvt *pvt)
 
 	amd64_debug_display_dimm_sizes(1, pvt);
 
-	amd64_info("using %s syndromes.\n", ((pvt->syn_type == 8) ? "x8" : "x4"));
+	amd64_info("using %s syndromes.\n", ((pvt->ecc_sym_sz == 8) ? "x8" : "x4"));
 
 	/* Only if NOT ganged does dclr1 have valid info */
 	if (!dct_ganging_enabled(pvt))
@@ -1778,20 +1778,20 @@ static int get_channel_from_ecc_syndrome(struct mem_ctl_info *mci, u16 syndrome)
 	struct amd64_pvt *pvt = mci->pvt_info;
 	int err_sym = -1;
 
-	if (pvt->syn_type == 8)
+	if (pvt->ecc_sym_sz == 8)
 		err_sym = decode_syndrome(syndrome, x8_vectors,
 					  ARRAY_SIZE(x8_vectors),
-					  pvt->syn_type);
-	else if (pvt->syn_type == 4)
+					  pvt->ecc_sym_sz);
+	else if (pvt->ecc_sym_sz == 4)
 		err_sym = decode_syndrome(syndrome, x4_vectors,
 					  ARRAY_SIZE(x4_vectors),
-					  pvt->syn_type);
+					  pvt->ecc_sym_sz);
 	else {
-		amd64_warn("Illegal syndrome type: %u\n", pvt->syn_type);
+		amd64_warn("Illegal syndrome type: %u\n", pvt->ecc_sym_sz);
 		return err_sym;
 	}
 
-	return map_err_sym_to_channel(err_sym, pvt->syn_type);
+	return map_err_sym_to_channel(err_sym, pvt->ecc_sym_sz);
 }
 
 /*
@@ -1936,6 +1936,7 @@ static void free_mc_sibling_devs(struct amd64_pvt *pvt)
  */
 static void read_mc_regs(struct amd64_pvt *pvt)
 {
+	struct cpuinfo_x86 *c = &boot_cpu_data;
 	u64 msr_val;
 	u32 tmp;
 	int range;
@@ -1997,19 +1998,16 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 		amd64_read_dct_pci_cfg(pvt, DCHR1, &pvt->dchr1);
 	}
 
-	if (boot_cpu_data.x86 >= 0x10) {
+	pvt->ecc_sym_sz = 4;
+
+	if (c->x86 >= 0x10) {
 		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
 		amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
-	}
-
-	if (boot_cpu_data.x86 == 0x10 &&
-	    boot_cpu_data.x86_model > 7 &&
-	    /* F3x180[EccSymbolSize]=1 => x8 symbols */
-	    tmp & BIT(25))
-		pvt->syn_type = 8;
-	else
-		pvt->syn_type = 4;
 
+		/* F10h, revD and later can do x8 ECC too */
+		if ((c->x86 > 0x10 || c->x86_model > 7) && tmp & BIT(25))
+			pvt->ecc_sym_sz = 8;
+	}
 	dump_misc_regs(pvt);
 }
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 3f853ed..4de31c8 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -363,7 +363,7 @@ struct amd64_pvt {
 	u32 online_spare;	/* On-Line spare Reg */
 
 	/* x4 or x8 syndromes in use */
-	u8 syn_type;
+	u8 ecc_sym_sz;
 
 	/* place to store error injection parameters prior to issue */
 	struct error_injection injection;
-- 
1.7.4.rc2

