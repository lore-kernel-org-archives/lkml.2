Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab0KJTEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:04:12 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49304 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab0KJTDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:03:44 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 09/12] EDAC, MCE: Overhaul error fields extraction macros
Date: Wed, 10 Nov 2010 20:02:18 +0100
Message-Id: <1289415741-15000-10-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1289415741-15000-1-git-send-email-bp@amd64.org>
References: <1289415741-15000-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Make macro names shorter thus making code shorter and more clear.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    4 +-
 drivers/edac/mce_amd.c    |   83 +++++++++++++++++++-------------------------
 drivers/edac/mce_amd.h    |   10 +++---
 3 files changed, 43 insertions(+), 54 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 8521401..dfbaa97 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2055,8 +2055,8 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
 					    struct err_regs *info)
 {
-	u32 ec  = ERROR_CODE(info->nbsl);
-	u32 xec = EXT_ERROR_CODE(info->nbsl);
+	u16 ec = EC(info->nbsl);
+	u8 xec = XEC(info->nbsl, 0x1f);
 	int ecc_type = (info->nbsh >> 13) & 0x3;
 
 	/* Bail early out if this was an 'observed' error */
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index c14abe3..53d4dc0 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -133,13 +133,13 @@ static bool f12h_dc_mce(u16 ec, u8 xec)
 	bool ret = false;
 
 	if (MEM_ERROR(ec)) {
-		u8 ll = ec & 0x3;
+		u8 ll = LL(ec);
 		ret = true;
 
 		if (ll == LL_L2)
 			pr_cont("during L1 linefill from L2.\n");
 		else if (ll == LL_L1)
-			pr_cont("Data/Tag %s error.\n", RRRR_MSG(ec));
+			pr_cont("Data/Tag %s error.\n", R4_MSG(ec));
 		else
 			ret = false;
 	}
@@ -148,10 +148,7 @@ static bool f12h_dc_mce(u16 ec, u8 xec)
 
 static bool f10h_dc_mce(u16 ec, u8 xec)
 {
-	u8 r4  = (ec >> 4) & 0xf;
-	u8 ll  = ec & 0x3;
-
-	if (r4 == R4_GEN && ll == LL_L1) {
+	if (R4(ec) == R4_GEN && LL(ec) == LL_L1) {
 		pr_cont("during data scrub.\n");
 		return true;
 	}
@@ -170,15 +167,12 @@ static bool k8_dc_mce(u16 ec, u8 xec)
 
 static bool f14h_dc_mce(u16 ec, u8 xec)
 {
-	u8 r4	 = (ec >> 4) & 0xf;
-	u8 ll	 = ec & 0x3;
-	u8 tt	 = (ec >> 2) & 0x3;
-	u8 ii	 = tt;
+	u8 r4	 = R4(ec);
 	bool ret = true;
 
 	if (MEM_ERROR(ec)) {
 
-		if (tt != TT_DATA || ll != LL_L1)
+		if (TT(ec) != TT_DATA || LL(ec) != LL_L1)
 			return false;
 
 		switch (r4) {
@@ -198,7 +192,7 @@ static bool f14h_dc_mce(u16 ec, u8 xec)
 		}
 	} else if (BUS_ERROR(ec)) {
 
-		if ((ii != II_MEM && ii != II_IO) || ll != LL_LG)
+		if ((II(ec) != II_MEM && II(ec) != II_IO) || LL(ec) != LL_LG)
 			return false;
 
 		pr_cont("System read data error on a ");
@@ -273,16 +267,14 @@ static bool f15h_dc_mce(u16 ec, u8 xec)
 
 static void amd_decode_dc_mce(struct mce *m)
 {
-	u16 ec = m->status & 0xffff;
-	u8 xec = (m->status >> 16) & xec_mask;
+	u16 ec = EC(m->status);
+	u8 xec = XEC(m->status, xec_mask);
 
 	pr_emerg(HW_ERR "Data Cache Error: ");
 
 	/* TLB error signatures are the same across families */
 	if (TLB_ERROR(ec)) {
-		u8 tt = (ec >> 2) & 0x3;
-
-		if (tt == TT_DATA) {
+		if (TT(ec) == TT_DATA) {
 			pr_cont("%s TLB %s.\n", LL_MSG(ec),
 				((xec == 2) ? "locked miss"
 					    : (xec ? "multimatch" : "parity")));
@@ -296,8 +288,7 @@ static void amd_decode_dc_mce(struct mce *m)
 
 static bool k8_ic_mce(u16 ec, u8 xec)
 {
-	u8 ll	 = ec & 0x3;
-	u8 r4	 = (ec >> 4) & 0xf;
+	u8 ll	 = LL(ec);
 	bool ret = true;
 
 	if (!MEM_ERROR(ec))
@@ -306,7 +297,7 @@ static bool k8_ic_mce(u16 ec, u8 xec)
 	if (ll == 0x2)
 		pr_cont("during a linefill from L2.\n");
 	else if (ll == 0x1) {
-		switch (r4) {
+		switch (R4(ec)) {
 		case R4_IRD:
 			pr_cont("Parity error during data load.\n");
 			break;
@@ -331,13 +322,11 @@ static bool k8_ic_mce(u16 ec, u8 xec)
 
 static bool f14h_ic_mce(u16 ec, u8 xec)
 {
-	u8 ll    = ec & 0x3;
-	u8 tt    = (ec >> 2) & 0x3;
-	u8 r4  = (ec >> 4) & 0xf;
+	u8 r4    = R4(ec);
 	bool ret = true;
 
 	if (MEM_ERROR(ec)) {
-		if (tt != 0 || ll != 1)
+		if (TT(ec) != 0 || LL(ec) != 1)
 			ret = false;
 
 		if (r4 == R4_IRD)
@@ -378,8 +367,8 @@ static bool f15h_ic_mce(u16 ec, u8 xec)
 
 static void amd_decode_ic_mce(struct mce *m)
 {
-	u16 ec = m->status & 0xffff;
-	u8 xec = (m->status >> 16) & xec_mask;
+	u16 ec = EC(m->status);
+	u8 xec = XEC(m->status, xec_mask);
 
 	pr_emerg(HW_ERR "Instruction Cache Error: ");
 
@@ -398,8 +387,8 @@ static void amd_decode_ic_mce(struct mce *m)
 
 static void amd_decode_bu_mce(struct mce *m)
 {
-	u32 ec = m->status & 0xffff;
-	u32 xec = (m->status >> 16) & xec_mask;
+	u16 ec = EC(m->status);
+	u8 xec = XEC(m->status, xec_mask);
 
 	pr_emerg(HW_ERR "Bus Unit Error");
 
@@ -408,23 +397,23 @@ static void amd_decode_bu_mce(struct mce *m)
 	else if (xec == 0x3)
 		pr_cont(" in the victim data buffers.\n");
 	else if (xec == 0x2 && MEM_ERROR(ec))
-		pr_cont(": %s error in the L2 cache tags.\n", RRRR_MSG(ec));
+		pr_cont(": %s error in the L2 cache tags.\n", R4_MSG(ec));
 	else if (xec == 0x0) {
 		if (TLB_ERROR(ec))
 			pr_cont(": %s error in a Page Descriptor Cache or "
 				"Guest TLB.\n", TT_MSG(ec));
 		else if (BUS_ERROR(ec))
 			pr_cont(": %s/ECC error in data read from NB: %s.\n",
-				RRRR_MSG(ec), PP_MSG(ec));
+				R4_MSG(ec), PP_MSG(ec));
 		else if (MEM_ERROR(ec)) {
-			u8 rrrr = (ec >> 4) & 0xf;
+			u8 r4 = R4(ec);
 
-			if (rrrr >= 0x7)
+			if (r4 >= 0x7)
 				pr_cont(": %s error during data copyback.\n",
-					RRRR_MSG(ec));
-			else if (rrrr <= 0x1)
+					R4_MSG(ec));
+			else if (r4 <= 0x1)
 				pr_cont(": %s parity/ECC error during data "
-					"access from L2.\n", RRRR_MSG(ec));
+					"access from L2.\n", R4_MSG(ec));
 			else
 				goto wrong_bu_mce;
 		} else
@@ -440,8 +429,8 @@ wrong_bu_mce:
 
 static void amd_decode_cu_mce(struct mce *m)
 {
-	u16 ec = m->status & 0xffff;
-	u8 xec = (m->status >> 16) & xec_mask;
+	u16 ec = EC(m->status);
+	u8 xec = XEC(m->status, xec_mask);
 
 	pr_emerg(HW_ERR "Combined Unit Error: ");
 
@@ -480,8 +469,8 @@ wrong_cu_mce:
 
 static void amd_decode_ls_mce(struct mce *m)
 {
-	u16 ec = m->status & 0xffff;
-	u8 xec = (m->status >> 16) & xec_mask;
+	u16 ec = EC(m->status);
+	u8 xec = XEC(m->status, xec_mask);
 
 	if (boot_cpu_data.x86 >= 0x14) {
 		pr_emerg("You shouldn't be seeing an LS MCE on this cpu family,"
@@ -492,12 +481,12 @@ static void amd_decode_ls_mce(struct mce *m)
 	pr_emerg(HW_ERR "Load Store Error");
 
 	if (xec == 0x0) {
-		u8 r4 = (ec >> 4) & 0xf;
+		u8 r4 = R4(ec);
 
 		if (!BUS_ERROR(ec) || (r4 != R4_DRD && r4 != R4_DWR))
 			goto wrong_ls_mce;
 
-		pr_cont(" during %s.\n", RRRR_MSG(ec));
+		pr_cont(" during %s.\n", R4_MSG(ec));
 	} else
 		goto wrong_ls_mce;
 
@@ -605,8 +594,8 @@ static bool nb_noop_mce(u16 ec, u8 xec)
 
 void amd_decode_nb_mce(int node_id, struct mce *m, u32 nbcfg)
 {
-	u8 xec   = (m->status >> 16) & 0x1f;
-	u16 ec   = m->status & 0xffff;
+	u16 ec   = EC(m->status);
+	u8 xec   = XEC(m->status, 0x1f);
 	u32 nbsh = (u32)(m->status >> 32);
 
 	pr_emerg(HW_ERR "Northbridge Error, node %d: ", node_id);
@@ -668,7 +657,7 @@ EXPORT_SYMBOL_GPL(amd_decode_nb_mce);
 static void amd_decode_fr_mce(struct mce *m)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
-	u8 xec = (m->status >> 16) & xec_mask;
+	u8 xec = XEC(m->status, xec_mask);
 
 	if (c->x86 == 0xf || c->x86 == 0x11)
 		goto wrong_fr_mce;
@@ -694,7 +683,7 @@ wrong_fr_mce:
 
 static void amd_decode_fp_mce(struct mce *m)
 {
-	u8 xec = (m->status >> 16) & xec_mask;
+	u8 xec = XEC(m->status, xec_mask);
 
 	pr_emerg(HW_ERR "Floating Point Unit Error: ");
 
@@ -739,11 +728,11 @@ static inline void amd_decode_err_code(u16 ec)
 			 TT_MSG(ec), LL_MSG(ec));
 	} else if (MEM_ERROR(ec)) {
 		pr_emerg(HW_ERR "Transaction: %s, Type: %s, Cache Level: %s\n",
-			 RRRR_MSG(ec), TT_MSG(ec), LL_MSG(ec));
+			 R4_MSG(ec), TT_MSG(ec), LL_MSG(ec));
 	} else if (BUS_ERROR(ec)) {
 		pr_emerg(HW_ERR "Transaction: %s (%s), %s, Cache Level: %s, "
 			 "Participating Processor: %s\n",
-			  RRRR_MSG(ec), II_MSG(ec), TO_MSG(ec), LL_MSG(ec),
+			  R4_MSG(ec), II_MSG(ec), TO_MSG(ec), LL_MSG(ec),
 			  PP_MSG(ec));
 	} else
 		pr_emerg(HW_ERR "Huh? Unknown MCE error 0x%x\n", ec);
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index 8398847..45dda47 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -7,8 +7,8 @@
 
 #define BIT_64(n)			(U64_C(1) << (n))
 
-#define ERROR_CODE(x)			((x) & 0xffff)
-#define EXT_ERROR_CODE(x)		(((x) >> 16) & 0x1f)
+#define EC(x)				((x) & 0xffff)
+#define XEC(x, mask)			(((x) >> 16) & mask)
 
 #define LOW_SYNDROME(x)			(((x) >> 15) & 0xff)
 #define HIGH_SYNDROME(x)		(((x) >> 24) & 0xff)
@@ -21,15 +21,15 @@
 #define TT_MSG(x)			tt_msgs[TT(x)]
 #define II(x)				(((x) >> 2) & 0x3)
 #define II_MSG(x)			ii_msgs[II(x)]
-#define LL(x)				(((x) >> 0) & 0x3)
+#define LL(x)				((x) & 0x3)
 #define LL_MSG(x)			ll_msgs[LL(x)]
 #define TO(x)				(((x) >> 8) & 0x1)
 #define TO_MSG(x)			to_msgs[TO(x)]
 #define PP(x)				(((x) >> 9) & 0x3)
 #define PP_MSG(x)			pp_msgs[PP(x)]
 
-#define RRRR(x)				(((x) >> 4) & 0xf)
-#define RRRR_MSG(x)			((RRRR(x) < 9) ?  rrrr_msgs[RRRR(x)] : "Wrong R4!")
+#define R4(x)				(((x) >> 4) & 0xf)
+#define R4_MSG(x)			((R4(x) < 9) ?  rrrr_msgs[R4(x)] : "Wrong R4!")
 
 #define K8_NBSH				0x4C
 
-- 
1.7.3.1.50.g1e633

