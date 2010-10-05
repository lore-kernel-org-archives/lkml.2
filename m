Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab0JEKxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:53:46 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37953 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900Ab0JEKwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:52:36 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/8] EDAC, MCE: Adjust IC decoders to F14h
Date: Tue,  5 Oct 2010 12:54:04 +0200
Message-Id: <1286276048-20556-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286276048-20556-1-git-send-email-bp@amd64.org>
References: <1286276048-20556-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add support for IC MCEs for F14h CPUs. K8 and F10h are almost identical
so use one function for both.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |  118 ++++++++++++++++++++++++++++-------------------
 drivers/edac/mce_amd.h |    1 +
 2 files changed, 71 insertions(+), 48 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 326db40..6e49f1e 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -223,61 +223,80 @@ wrong_dc_mce:
 	pr_emerg(HW_ERR "Corrupted DC MCE info?\n");
 }
 
-static void amd_decode_ic_mce(struct mce *m)
+static bool k8_ic_mce(u16 ec)
 {
-	u32 ec  = m->status & 0xffff;
-	u32 xec = (m->status >> 16) & 0xf;
+	u8 ll	 = ec & 0x3;
+	u8 r4	 = (ec >> 4) & 0xf;
+	bool ret = true;
 
-	pr_emerg(HW_ERR "Instruction Cache Error");
+	if (!MEM_ERROR(ec))
+		return false;
 
-	if (xec == 1 && TLB_ERROR(ec))
-		pr_cont(": %s TLB multimatch.\n", LL_MSG(ec));
-	else if (xec == 0) {
-		if (TLB_ERROR(ec))
-			pr_cont(": %s TLB Parity error.\n", LL_MSG(ec));
-		else if (BUS_ERROR(ec)) {
-			if (boot_cpu_data.x86 == 0xf &&
-			    (m->status & BIT(58)))
-				pr_cont(" during system linefill.\n");
-			else
-				pr_cont(" during attempted NB data read.\n");
-		} else if (MEM_ERROR(ec)) {
-			u8 ll   = ec & 0x3;
-			u8 rrrr = (ec >> 4) & 0xf;
+	if (ll == 0x2)
+		pr_cont("during a linefill from L2.\n");
+	else if (ll == 0x1) {
+		switch (r4) {
+		case R4_IRD:
+			pr_cont("Parity error during data load.\n");
+			break;
 
-			if (ll == 0x2)
-				pr_cont(" during a linefill from L2.\n");
-			else if (ll == 0x1) {
-
-				switch (rrrr) {
-				case 0x5:
-					pr_cont(": Parity error during "
-					       "data load.\n");
-					break;
-
-				case 0x7:
-					pr_cont(": Copyback Parity/Victim"
-						" error.\n");
-					break;
-
-				case 0x8:
-					pr_cont(": Tag Snoop error.\n");
-					break;
-
-				default:
-					goto wrong_ic_mce;
-					break;
-				}
-			}
-		} else
-			goto wrong_ic_mce;
+		case R4_EVICT:
+			pr_cont("Copyback Parity/Victim error.\n");
+			break;
+
+		case R4_SNOOP:
+			pr_cont("Tag Snoop error.\n");
+			break;
+
+		default:
+			ret = false;
+			break;
+		}
 	} else
-		goto wrong_ic_mce;
+		ret = false;
 
-	return;
+	return ret;
+}
+
+static bool f14h_ic_mce(u16 ec)
+{
+	u8 ll    = ec & 0x3;
+	u8 tt    = (ec >> 2) & 0x3;
+	u8 r4  = (ec >> 4) & 0xf;
+	bool ret = true;
 
-wrong_ic_mce:
-	pr_emerg(HW_ERR "Corrupted IC MCE info?\n");
+	if (MEM_ERROR(ec)) {
+		if (tt != 0 || ll != 1)
+			ret = false;
+
+		if (r4 == R4_IRD)
+			pr_cont("Data/tag array parity error for a tag hit.\n");
+		else if (r4 == R4_SNOOP)
+			pr_cont("Tag error during snoop/victimization.\n");
+		else
+			ret = false;
+	}
+	return ret;
+}
+
+static void amd_decode_ic_mce(struct mce *m)
+{
+	u16 ec = m->status & 0xffff;
+	u8 xec = (m->status >> 16) & 0xf;
+
+	pr_emerg(HW_ERR "Instruction Cache Error: ");
+
+	if (TLB_ERROR(ec))
+		pr_cont("%s TLB %s.\n", LL_MSG(ec),
+			(xec ? "multimatch" : "parity error"));
+	else if (BUS_ERROR(ec)) {
+		bool k8 = (boot_cpu_data.x86 == 0xf && (m->status & BIT(58)));
+
+		pr_cont("during %s.\n", (k8 ? "system linefill" : "NB data read"));
+	} else if (fam_ops->ic_mce(ec))
+		;
+	else
+		pr_emerg(HW_ERR "Corrupted IC MCE info?\n");
 }
 
 static void amd_decode_bu_mce(struct mce *m)
@@ -485,14 +504,17 @@ static int __init mce_amd_init(void)
 	switch (boot_cpu_data.x86) {
 	case 0xf:
 		fam_ops->dc_mce = k8_dc_mce;
+		fam_ops->ic_mce = k8_ic_mce;
 		break;
 
 	case 0x10:
 		fam_ops->dc_mce = f10h_dc_mce;
+		fam_ops->ic_mce = k8_ic_mce;
 		break;
 
 	case 0x14:
 		fam_ops->dc_mce = f14h_dc_mce;
+		fam_ops->ic_mce = f14h_ic_mce;
 		break;
 
 	default:
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index 85985c2..dc81dba 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -101,6 +101,7 @@ struct err_regs {
  */
 struct amd_decoder_ops {
 	bool (*dc_mce)(u16);
+	bool (*ic_mce)(u16);
 };
 
 void amd_report_gart_errors(bool);
-- 
1.7.3.1.50.g1e633

