Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab0KJTDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:03:30 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49263 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab0KJTD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:03:27 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 02/12] EDAC, MCE: Add F15h DC MCE decoder
Date: Wed, 10 Nov 2010 20:02:11 +0100
Message-Id: <1289415741-15000-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1289415741-15000-1-git-send-email-bp@amd64.org>
References: <1289415741-15000-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a decoder for F15h DC MCEs to support the new types of DC MCEs
introduced by the BD microarchitecture.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |   79 +++++++++++++++++++++++++++++++++++++-----------
 drivers/edac/mce_amd.h |    2 +-
 2 files changed, 62 insertions(+), 19 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 01853ee..12bae3b 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -75,7 +75,7 @@ static const char *f10h_nb_mce_desc[] = {
 	"ECC Error in the Probe Filter directory"
 };
 
-static bool f12h_dc_mce(u16 ec)
+static bool f12h_dc_mce(u16 ec, u8 xec)
 {
 	bool ret = false;
 
@@ -93,7 +93,7 @@ static bool f12h_dc_mce(u16 ec)
 	return ret;
 }
 
-static bool f10h_dc_mce(u16 ec)
+static bool f10h_dc_mce(u16 ec, u8 xec)
 {
 	u8 r4  = (ec >> 4) & 0xf;
 	u8 ll  = ec & 0x3;
@@ -102,20 +102,20 @@ static bool f10h_dc_mce(u16 ec)
 		pr_cont("during data scrub.\n");
 		return true;
 	}
-	return f12h_dc_mce(ec);
+	return f12h_dc_mce(ec, xec);
 }
 
-static bool k8_dc_mce(u16 ec)
+static bool k8_dc_mce(u16 ec, u8 xec)
 {
 	if (BUS_ERROR(ec)) {
 		pr_cont("during system linefill.\n");
 		return true;
 	}
 
-	return f10h_dc_mce(ec);
+	return f10h_dc_mce(ec, xec);
 }
 
-static bool f14h_dc_mce(u16 ec)
+static bool f14h_dc_mce(u16 ec, u8 xec)
 {
 	u8 r4	 = (ec >> 4) & 0xf;
 	u8 ll	 = ec & 0x3;
@@ -170,6 +170,54 @@ static bool f14h_dc_mce(u16 ec)
 	return ret;
 }
 
+static bool f15h_dc_mce(u16 ec, u8 xec)
+{
+	bool ret = true;
+
+	if (MEM_ERROR(ec)) {
+
+		switch (xec) {
+		case 0x0:
+			pr_cont("Data Array access error.\n");
+			break;
+
+		case 0x1:
+			pr_cont("UC error during a linefill from L2/NB.\n");
+			break;
+
+		case 0x2:
+		case 0x11:
+			pr_cont("STQ access error.\n");
+			break;
+
+		case 0x3:
+			pr_cont("SCB access error.\n");
+			break;
+
+		case 0x10:
+			pr_cont("Tag error.\n");
+			break;
+
+		case 0x12:
+			pr_cont("LDQ access error.\n");
+			break;
+
+		default:
+			ret = false;
+		}
+	} else if (BUS_ERROR(ec)) {
+
+		if (!xec)
+			pr_cont("during system linefill.\n");
+		else
+			pr_cont(" Internal %s condition.\n",
+				((xec == 1) ? "livelock" : "deadlock"));
+	} else
+		ret = false;
+
+	return ret;
+}
+
 static void amd_decode_dc_mce(struct mce *m)
 {
 	u16 ec = m->status & 0xffff;
@@ -183,20 +231,14 @@ static void amd_decode_dc_mce(struct mce *m)
 
 		if (tt == TT_DATA) {
 			pr_cont("%s TLB %s.\n", LL_MSG(ec),
-				(xec ? "multimatch" : "parity error"));
+				((xec == 2) ? "locked miss"
+					    : (xec ? "multimatch" : "parity")));
 			return;
 		}
-		else
-			goto wrong_dc_mce;
-	}
-
-	if (!fam_ops->dc_mce(ec))
-		goto wrong_dc_mce;
-
-	return;
-
-wrong_dc_mce:
-	pr_emerg(HW_ERR "Corrupted DC MCE info?\n");
+	} else if (fam_ops->dc_mce(ec, xec))
+		;
+	else
+		pr_emerg(HW_ERR "Corrupted DC MCE info?\n");
 }
 
 static bool k8_ic_mce(u16 ec)
@@ -654,6 +696,7 @@ static int __init mce_amd_init(void)
 
 	case 0x15:
 		xec_mask = 0x1f;
+		fam_ops->dc_mce = f15h_dc_mce;
 		break;
 
 	default:
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index 35f6e0e..c12394d 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -100,7 +100,7 @@ struct err_regs {
  * per-family decoder ops
  */
 struct amd_decoder_ops {
-	bool (*dc_mce)(u16);
+	bool (*dc_mce)(u16, u8);
 	bool (*ic_mce)(u16);
 	bool (*nb_mce)(u16, u8);
 };
-- 
1.7.3.1.50.g1e633

