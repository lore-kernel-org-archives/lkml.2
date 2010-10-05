Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab0JEKwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:52:45 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37967 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945Ab0JEKwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:52:42 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 6/8] EDAC, MCE: Complete NB MCE decoders
Date: Tue,  5 Oct 2010 12:54:06 +0200
Message-Id: <1286276048-20556-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286276048-20556-1-git-send-email-bp@amd64.org>
References: <1286276048-20556-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add support for decoding F14h BU MCEs and improve decoding of the
remaining families.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.h |    1 -
 drivers/edac/mce_amd.c    |  210 +++++++++++++++++++++++++++++++++-----------
 drivers/edac/mce_amd.h    |    3 +-
 3 files changed, 158 insertions(+), 56 deletions(-)

diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 13e1d6f..044aee4 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -482,7 +482,6 @@ extern const char *rrrr_msgs[16];
 extern const char *to_msgs[2];
 extern const char *pp_msgs[4];
 extern const char *ii_msgs[4];
-extern const char *ext_msgs[32];
 extern const char *htlink_msgs[8];
 
 #ifdef CONFIG_EDAC_DEBUG
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index adb5d25..cf6d44a 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -5,6 +5,8 @@
 
 static struct amd_decoder_ops *fam_ops;
 
+static u8 nb_err_cpumask = 0xf;
+
 static bool report_gart_errors;
 static void (*nb_bus_decoder)(int node_id, struct mce *m, u32 nbcfg);
 
@@ -61,45 +63,16 @@ EXPORT_SYMBOL_GPL(to_msgs);
 const char *ii_msgs[] = { "MEM", "RESV", "IO", "GEN" };
 EXPORT_SYMBOL_GPL(ii_msgs);
 
-/*
- * Map the 4 or 5 (family-specific) bits of Extended Error code to the
- * string table.
- */
-const char *ext_msgs[] = {
-	"K8 ECC error",					/* 0_0000b */
-	"CRC error on link",				/* 0_0001b */
-	"Sync error packets on link",			/* 0_0010b */
-	"Master Abort during link operation",		/* 0_0011b */
-	"Target Abort during link operation",		/* 0_0100b */
-	"Invalid GART PTE entry during table walk",	/* 0_0101b */
-	"Unsupported atomic RMW command received",	/* 0_0110b */
-	"WDT error: NB transaction timeout",		/* 0_0111b */
-	"ECC/ChipKill ECC error",			/* 0_1000b */
-	"SVM DEV Error",				/* 0_1001b */
-	"Link Data error",				/* 0_1010b */
-	"Link/L3/Probe Filter Protocol error",		/* 0_1011b */
-	"NB Internal Arrays Parity error",		/* 0_1100b */
-	"DRAM Address/Control Parity error",		/* 0_1101b */
-	"Link Transmission error",			/* 0_1110b */
-	"GART/DEV Table Walk Data error"		/* 0_1111b */
-	"Res 0x100 error",				/* 1_0000b */
-	"Res 0x101 error",				/* 1_0001b */
-	"Res 0x102 error",				/* 1_0010b */
-	"Res 0x103 error",				/* 1_0011b */
-	"Res 0x104 error",				/* 1_0100b */
-	"Res 0x105 error",				/* 1_0101b */
-	"Res 0x106 error",				/* 1_0110b */
-	"Res 0x107 error",				/* 1_0111b */
-	"Res 0x108 error",				/* 1_1000b */
-	"Res 0x109 error",				/* 1_1001b */
-	"Res 0x10A error",				/* 1_1010b */
-	"Res 0x10B error",				/* 1_1011b */
-	"ECC error in L3 Cache Data",			/* 1_1100b */
-	"L3 Cache Tag error",				/* 1_1101b */
-	"L3 Cache LRU Parity error",			/* 1_1110b */
-	"Probe Filter error"				/* 1_1111b */
+static const char *f10h_nb_mce_desc[] = {
+	"HT link data error",
+	"Protocol error (link, L3, probe filter, etc.)",
+	"Parity error in NB-internal arrays",
+	"Link Retry due to IO link transmission error",
+	"L3 ECC data cache error",
+	"ECC error in L3 cache tag",
+	"L3 LRU parity bits error",
+	"ECC Error in the Probe Filter directory"
 };
-EXPORT_SYMBOL_GPL(ext_msgs);
 
 static bool f10h_dc_mce(u16 ec)
 {
@@ -370,19 +343,97 @@ wrong_ls_mce:
 	pr_emerg(HW_ERR "Corrupted LS MCE info?\n");
 }
 
+static bool k8_nb_mce(u16 ec, u8 xec)
+{
+	bool ret = true;
+
+	switch (xec) {
+	case 0x1:
+		pr_cont("CRC error detected on HT link.\n");
+		break;
+
+	case 0x5:
+		pr_cont("Invalid GART PTE entry during GART table walk.\n");
+		break;
+
+	case 0x6:
+		pr_cont("Unsupported atomic RMW received from an IO link.\n");
+		break;
+
+	case 0x0:
+	case 0x8:
+		pr_cont("DRAM ECC error detected on the NB.\n");
+		break;
+
+	case 0xd:
+		pr_cont("Parity error on the DRAM addr/ctl signals.\n");
+		break;
+
+	default:
+		ret = false;
+		break;
+	}
+
+	return ret;
+}
+
+static bool f10h_nb_mce(u16 ec, u8 xec)
+{
+	bool ret = true;
+	u8 offset = 0;
+
+	if (k8_nb_mce(ec, xec))
+		return true;
+
+	switch(xec) {
+	case 0xa ... 0xc:
+		offset = 10;
+		break;
+
+	case 0xe:
+		offset = 11;
+		break;
+
+	case 0xf:
+		if (TLB_ERROR(ec))
+			pr_cont("GART Table Walk data error.\n");
+		else if (BUS_ERROR(ec))
+			pr_cont("DMA Exclusion Vector Table Walk error.\n");
+		else
+			ret = false;
+
+		goto out;
+		break;
+
+	case 0x1c ... 0x1f:
+		offset = 24;
+		break;
+
+	default:
+		ret = false;
+
+		goto out;
+		break;
+	}
+
+	pr_cont("%s.\n", f10h_nb_mce_desc[xec - offset]);
+
+out:
+	return ret;
+}
+
+static bool f14h_nb_mce(u16 ec, u8 xec)
+{
+	return false;
+}
+
 void amd_decode_nb_mce(int node_id, struct mce *m, u32 nbcfg)
 {
-	u32 ec   = m->status & 0xffff;
+	u8 xec   = (m->status >> 16) & 0x1f;
+	u16 ec   = m->status & 0xffff;
 	u32 nbsh = (u32)(m->status >> 32);
-	u32 nbsl = (u32)m->status;
-
-	/*
-	 * GART TLB error reporting is disabled by default. Bail out early.
-	 */
-	if (TLB_ERROR(ec) && !report_gart_errors)
-		return;
 
-	pr_emerg(HW_ERR "Northbridge Error, node %d", node_id);
+	pr_emerg(HW_ERR "Northbridge Error, node %d: ", node_id);
 
 	/*
 	 * F10h, revD can disable ErrCpu[3:0] so check that first and also the
@@ -391,20 +442,50 @@ void amd_decode_nb_mce(int node_id, struct mce *m, u32 nbcfg)
 	if ((boot_cpu_data.x86 == 0x10) &&
 	    (boot_cpu_data.x86_model > 7)) {
 		if (nbsh & K8_NBSH_ERR_CPU_VAL)
-			pr_cont(", core: %u\n", (u8)(nbsh & 0xf));
+			pr_cont(", core: %u", (u8)(nbsh & nb_err_cpumask));
 	} else {
-		u8 assoc_cpus = nbsh & 0xf;
+		u8 assoc_cpus = nbsh & nb_err_cpumask;
 
 		if (assoc_cpus > 0)
 			pr_cont(", core: %d", fls(assoc_cpus) - 1);
+	}
 
-		pr_cont("\n");
+	switch (xec) {
+	case 0x2:
+		pr_cont("Sync error (sync packets on HT link detected).\n");
+		return;
+
+	case 0x3:
+		pr_cont("HT Master abort.\n");
+		return;
+
+	case 0x4:
+		pr_cont("HT Target abort.\n");
+		return;
+
+	case 0x7:
+		pr_cont("NB Watchdog timeout.\n");
+		return;
+
+	case 0x9:
+		pr_cont("SVM DMA Exclusion Vector error.\n");
+		return;
+
+	default:
+		break;
 	}
 
-	pr_emerg(HW_ERR "%s.\n", EXT_ERR_MSG(nbsl));
+	if (!fam_ops->nb_mce(ec, xec))
+		goto wrong_nb_mce;
+
+	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10)
+		if ((xec == 0x8 || xec == 0x0) && nb_bus_decoder)
+			nb_bus_decoder(node_id, m, nbcfg);
 
-	if (BUS_ERROR(ec) && nb_bus_decoder)
-		nb_bus_decoder(node_id, m, nbcfg);
+	return;
+
+wrong_nb_mce:
+	pr_emerg(HW_ERR "Corrupted NB MCE info?\n");
 }
 EXPORT_SYMBOL_GPL(amd_decode_nb_mce);
 
@@ -434,11 +515,30 @@ static inline void amd_decode_err_code(u16 ec)
 		pr_emerg(HW_ERR "Huh? Unknown MCE error 0x%x\n", ec);
 }
 
+/*
+ * Filter out unwanted MCE signatures here.
+ */
+static bool amd_filter_mce(struct mce *m)
+{
+	u8 xec = (m->status >> 16) & 0x1f;
+
+	/*
+	 * NB GART TLB error reporting is disabled by default.
+	 */
+	if (m->bank == 4 && xec == 0x5 && !report_gart_errors)
+		return true;
+
+	return false;
+}
+
 int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 {
 	struct mce *m = (struct mce *)data;
 	int node, ecc;
 
+	if (amd_filter_mce(m))
+		return NOTIFY_STOP;
+
 	pr_emerg(HW_ERR "MC%d_STATUS: ", m->bank);
 
 	pr_cont("%sorrected error, other errors lost: %s, "
@@ -513,16 +613,20 @@ static int __init mce_amd_init(void)
 	case 0xf:
 		fam_ops->dc_mce = k8_dc_mce;
 		fam_ops->ic_mce = k8_ic_mce;
+		fam_ops->nb_mce = k8_nb_mce;
 		break;
 
 	case 0x10:
 		fam_ops->dc_mce = f10h_dc_mce;
 		fam_ops->ic_mce = k8_ic_mce;
+		fam_ops->nb_mce = f10h_nb_mce;
 		break;
 
 	case 0x14:
+		nb_err_cpumask  = 0x3;
 		fam_ops->dc_mce = f14h_dc_mce;
 		fam_ops->ic_mce = f14h_ic_mce;
+		fam_ops->nb_mce = f14h_nb_mce;
 		break;
 
 	default:
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index dc81dba..0d0637d 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -7,7 +7,6 @@
 
 #define ERROR_CODE(x)			((x) & 0xffff)
 #define EXT_ERROR_CODE(x)		(((x) >> 16) & 0x1f)
-#define EXT_ERR_MSG(x)			ext_msgs[EXT_ERROR_CODE(x)]
 
 #define LOW_SYNDROME(x)			(((x) >> 15) & 0xff)
 #define HIGH_SYNDROME(x)		(((x) >> 24) & 0xff)
@@ -83,7 +82,6 @@ extern const char *rrrr_msgs[];
 extern const char *pp_msgs[];
 extern const char *to_msgs[];
 extern const char *ii_msgs[];
-extern const char *ext_msgs[];
 
 /*
  * relevant NB regs
@@ -102,6 +100,7 @@ struct err_regs {
 struct amd_decoder_ops {
 	bool (*dc_mce)(u16);
 	bool (*ic_mce)(u16);
+	bool (*nb_mce)(u16, u8);
 };
 
 void amd_report_gart_errors(bool);
-- 
1.7.3.1.50.g1e633

