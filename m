Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984Ab0JEKwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:52:44 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37962 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944Ab0JEKwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:52:41 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/8] EDAC, MCE: Adjust DC decoders to F14h
Date: Tue,  5 Oct 2010 12:54:03 +0200
Message-Id: <1286276048-20556-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286276048-20556-1-git-send-email-bp@amd64.org>
References: <1286276048-20556-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a per-family data cache decoders. Since there is a certain overlap
between the different DC MCE signatures, reuse functionality between the
families as far as possible.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |  162 ++++++++++++++++++++++++++++++++++++++++--------
 drivers/edac/mce_amd.h |   40 ++++++++++++
 2 files changed, 175 insertions(+), 27 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 5eb8042..326db40 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -1,6 +1,10 @@
 #include <linux/module.h>
+#include <linux/slab.h>
+
 #include "mce_amd.h"
 
+static struct amd_decoder_ops *fam_ops;
+
 static bool report_gart_errors;
 static void (*nb_bus_decoder)(int node_id, struct mce *m, u32 nbcfg);
 
@@ -97,41 +101,120 @@ const char *ext_msgs[] = {
 };
 EXPORT_SYMBOL_GPL(ext_msgs);
 
-static void amd_decode_dc_mce(struct mce *m)
+static bool f10h_dc_mce(u16 ec)
 {
-	u32 ec  = m->status & 0xffff;
-	u32 xec = (m->status >> 16) & 0xf;
+	u8 r4  = (ec >> 4) & 0xf;
+	bool ret = false;
 
-	pr_emerg(HW_ERR "Data Cache Error: ");
+	if (r4 == R4_GEN) {
+		pr_cont("during data scrub.\n");
+		return true;
+	}
 
-	if (xec == 1 && TLB_ERROR(ec))
-		pr_cont(": %s TLB multimatch.\n", LL_MSG(ec));
-	else if (xec == 0) {
-		if (m->status & (1ULL << 40))
-			pr_cont(" during Data Scrub.\n");
-		else if (TLB_ERROR(ec))
-			pr_cont(": %s TLB parity error.\n", LL_MSG(ec));
-		else if (MEM_ERROR(ec)) {
-			u8 ll   = ec & 0x3;
-			u8 tt   = (ec >> 2) & 0x3;
-			u8 rrrr = (ec >> 4) & 0xf;
+	if (MEM_ERROR(ec)) {
+		u8 ll = ec & 0x3;
+		ret = true;
 
-			/* see F10h BKDG (31116), Table 92. */
-			if (ll == 0x1) {
-				if (tt != 0x1)
-					goto wrong_dc_mce;
+		if (ll == LL_L2)
+			pr_cont("during L1 linefill from L2.\n");
+		else if (ll == LL_L1)
+			pr_cont("Data/Tag %s error.\n", RRRR_MSG(ec));
+		else
+			ret = false;
+	}
+	return ret;
+}
 
-				pr_cont(": Data/Tag %s error.\n", RRRR_MSG(ec));
+static bool k8_dc_mce(u16 ec)
+{
+	if (BUS_ERROR(ec)) {
+		pr_cont("during system linefill.\n");
+		return true;
+	}
 
-			} else if (ll == 0x2 && rrrr == 0x3)
-				pr_cont(" during L1 linefill from L2.\n");
-			else
-				goto wrong_dc_mce;
-		} else if (BUS_ERROR(ec) && boot_cpu_data.x86 == 0xf)
-			pr_cont(" during system linefill.\n");
+	return f10h_dc_mce(ec);
+}
+
+static bool f14h_dc_mce(u16 ec)
+{
+	u8 r4	 = (ec >> 4) & 0xf;
+	u8 ll	 = ec & 0x3;
+	u8 tt	 = (ec >> 2) & 0x3;
+	u8 ii	 = tt;
+	bool ret = true;
+
+	if (MEM_ERROR(ec)) {
+
+		if (tt != TT_DATA || ll != LL_L1)
+			return false;
+
+		switch (r4) {
+		case R4_DRD:
+		case R4_DWR:
+			pr_cont("Data/Tag parity error due to %s.\n",
+				(r4 == R4_DRD ? "load/hw prf" : "store"));
+			break;
+		case R4_EVICT:
+			pr_cont("Copyback parity error on a tag miss.\n");
+			break;
+		case R4_SNOOP:
+			pr_cont("Tag parity error during snoop.\n");
+			break;
+		default:
+			ret = false;
+		}
+	} else if (BUS_ERROR(ec)) {
+
+		if ((ii != II_MEM && ii != II_IO) || ll != LL_LG)
+			return false;
+
+		pr_cont("System read data error on a ");
+
+		switch (r4) {
+		case R4_RD:
+			pr_cont("TLB reload.\n");
+			break;
+		case R4_DWR:
+			pr_cont("store.\n");
+			break;
+		case R4_DRD:
+			pr_cont("load.\n");
+			break;
+		default:
+			ret = false;
+		}
+	} else {
+		ret = false;
+	}
+
+	return ret;
+}
+
+static void amd_decode_dc_mce(struct mce *m)
+{
+	u16 ec = m->status & 0xffff;
+	u8 xec = (m->status >> 16) & 0xf;
+
+	pr_emerg(HW_ERR "Data Cache Error: ");
+
+	/*
+	 * check this after F14h BKDG is updated
+	 *
+	 * TLB error signatures are the same across families
+	 */
+	if (TLB_ERROR(ec)) {
+		u8 tt = (ec >> 2) & 0x3;
+
+		if (tt == TT_DATA) {
+			pr_cont("%s TLB %s.\n", LL_MSG(ec),
+				(xec ? "multimatch" : "parity error"));
+			return;
+		}
 		else
 			goto wrong_dc_mce;
-	} else
+	}
+
+	if (!fam_ops->dc_mce(ec))
 		goto wrong_dc_mce;
 
 	return;
@@ -395,6 +478,30 @@ static int __init mce_amd_init(void)
 	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
 		return 0;
 
+	fam_ops = kzalloc(sizeof(struct amd_decoder_ops), GFP_KERNEL);
+	if (!fam_ops)
+		return -ENOMEM;
+
+	switch (boot_cpu_data.x86) {
+	case 0xf:
+		fam_ops->dc_mce = k8_dc_mce;
+		break;
+
+	case 0x10:
+		fam_ops->dc_mce = f10h_dc_mce;
+		break;
+
+	case 0x14:
+		fam_ops->dc_mce = f14h_dc_mce;
+		break;
+
+	default:
+		printk(KERN_WARNING "Huh? What family is that: %d?!\n",
+				    boot_cpu_data.x86);
+		kfree(fam_ops);
+		return -EINVAL;
+	}
+
 	atomic_notifier_chain_register(&x86_mce_decoder_chain, &amd_mce_dec_nb);
 
 	return 0;
@@ -405,6 +512,7 @@ early_initcall(mce_amd_init);
 static void __exit mce_amd_exit(void)
 {
 	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, &amd_mce_dec_nb);
+	kfree(fam_ops);
 }
 
 MODULE_DESCRIPTION("AMD MCE decoder");
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index 2712a90..85985c2 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -44,6 +44,39 @@
 #define K8_NBSH_UECC			BIT(13)
 #define K8_NBSH_ERR_SCRUBER		BIT(8)
 
+enum tt_ids {
+	TT_INSTR = 0,
+	TT_DATA,
+	TT_GEN,
+	TT_RESV,
+};
+
+enum ll_ids {
+	LL_RESV = 0,
+	LL_L1,
+	LL_L2,
+	LL_LG,
+};
+
+enum ii_ids {
+	II_MEM = 0,
+	II_RESV,
+	II_IO,
+	II_GEN,
+};
+
+enum rrrr_ids {
+	R4_GEN	= 0,
+	R4_RD,
+	R4_WR,
+	R4_DRD,
+	R4_DWR,
+	R4_IRD,
+	R4_PREF,
+	R4_EVICT,
+	R4_SNOOP,
+};
+
 extern const char *tt_msgs[];
 extern const char *ll_msgs[];
 extern const char *rrrr_msgs[];
@@ -63,6 +96,13 @@ struct err_regs {
 	u32 nbeal;
 };
 
+/*
+ * per-family decoder ops
+ */
+struct amd_decoder_ops {
+	bool (*dc_mce)(u16);
+};
+
 void amd_report_gart_errors(bool);
 void amd_register_ecc_decoder(void (*f)(int, struct mce *, u32));
 void amd_unregister_ecc_decoder(void (*f)(int, struct mce *, u32));
-- 
1.7.3.1.50.g1e633

