Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2LQTjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:39:48 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:14396
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753410Ab2LQTjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:39:47 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1155h)
X-WSS-ID: 0MF6XA2-02-5TY-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>, Doug Thompson <dougthompson@xmission.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 1/2] MCE, AMD: Make MC2 decoding part of amd_decoder_ops as well
Date: Mon, 17 Dec 2012 13:39:47 -0600
Message-ID: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently only AMD Family 15h processors have special handling for MC2
errors, since upcoming Family 16h will also need unique handling,
let's make MC2 handling part of amd_decoder_ops.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 drivers/edac/mce_amd.c |   58 ++++++++++++++++++++++++++----------------------
 drivers/edac/mce_amd.h |    1 +
 2 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index ad63757..84320f9 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -399,12 +399,9 @@ static void decode_mc1_mce(struct mce *m)
 		pr_emerg(HW_ERR "Corrupted MC1 MCE info?\n");
 }
 
-static void decode_mc2_mce(struct mce *m)
+static bool k8_mc2_mce(u16 ec, u8 xec)
 {
-	u16 ec = EC(m->status);
-	u8 xec = XEC(m->status, xec_mask);
-
-	pr_emerg(HW_ERR "MC2 Error");
+	bool ret = true;
 
 	if (xec == 0x1)
 		pr_cont(" in the write data buffers.\n");
@@ -429,24 +426,18 @@ static void decode_mc2_mce(struct mce *m)
 				pr_cont(": %s parity/ECC error during data "
 					"access from L2.\n", R4_MSG(ec));
 			else
-				goto wrong_mc2_mce;
+				ret = false;
 		} else
-			goto wrong_mc2_mce;
+			ret = false;
 	} else
-		goto wrong_mc2_mce;
-
-	return;
+		ret = false;
 
- wrong_mc2_mce:
-	pr_emerg(HW_ERR "Corrupted MC2 MCE info?\n");
+	return ret;
 }
 
-static void decode_f15_mc2_mce(struct mce *m)
+static bool f15h_mc2_mce(u16 ec, u8 xec)
 {
-	u16 ec = EC(m->status);
-	u8 xec = XEC(m->status, xec_mask);
-
-	pr_emerg(HW_ERR "MC2 Error: ");
+	bool ret = true;
 
 	if (TLB_ERROR(ec)) {
 		if (xec == 0x0)
@@ -454,10 +445,10 @@ static void decode_f15_mc2_mce(struct mce *m)
 		else if (xec == 0x1)
 			pr_cont("Poison data provided for TLB fill.\n");
 		else
-			goto wrong_f15_mc2_mce;
+			ret = false;
 	} else if (BUS_ERROR(ec)) {
 		if (xec > 2)
-			goto wrong_f15_mc2_mce;
+			ret = false;
 
 		pr_cont("Error during attempted NB data read.\n");
 	} else if (MEM_ERROR(ec)) {
@@ -471,14 +462,24 @@ static void decode_f15_mc2_mce(struct mce *m)
 			break;
 
 		default:
-			goto wrong_f15_mc2_mce;
+			ret = false;
 		}
 	}
 
-	return;
+	return ret;
+}
 
- wrong_f15_mc2_mce:
-	pr_emerg(HW_ERR "Corrupted MC2 MCE info?\n");
+static void decode_mc2_mce(struct mce *m)
+{
+	u16 ec = EC(m->status);
+	u8 xec = XEC(m->status, xec_mask);
+
+	pr_emerg(HW_ERR "MC2 Error: ");
+
+	if (fam_ops->mc2_mce(ec, xec))
+		;
+	else
+		pr_emerg(HW_ERR "Corrupted MC2 MCE info?\n");
 }
 
 static void decode_mc3_mce(struct mce *m)
@@ -702,10 +703,7 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 		break;
 
 	case 2:
-		if (c->x86 == 0x15)
-			decode_f15_mc2_mce(m);
-		else
-			decode_mc2_mce(m);
+		decode_mc2_mce(m);
 		break;
 
 	case 3:
@@ -783,33 +781,39 @@ static int __init mce_amd_init(void)
 	case 0xf:
 		fam_ops->mc0_mce = k8_mc0_mce;
 		fam_ops->mc1_mce = k8_mc1_mce;
+		fam_ops->mc2_mce = k8_mc2_mce;
 		break;
 
 	case 0x10:
 		fam_ops->mc0_mce = f10h_mc0_mce;
 		fam_ops->mc1_mce = k8_mc1_mce;
+		fam_ops->mc2_mce = k8_mc2_mce;
 		break;
 
 	case 0x11:
 		fam_ops->mc0_mce = k8_mc0_mce;
 		fam_ops->mc1_mce = k8_mc1_mce;
+		fam_ops->mc2_mce = k8_mc2_mce;
 		break;
 
 	case 0x12:
 		fam_ops->mc0_mce = f12h_mc0_mce;
 		fam_ops->mc1_mce = k8_mc1_mce;
+		fam_ops->mc2_mce = k8_mc2_mce;
 		break;
 
 	case 0x14:
 		nb_err_cpumask  = 0x3;
 		fam_ops->mc0_mce = f14h_mc0_mce;
 		fam_ops->mc1_mce = f14h_mc1_mce;
+		fam_ops->mc2_mce = k8_mc2_mce;
 		break;
 
 	case 0x15:
 		xec_mask = 0x1f;
 		fam_ops->mc0_mce = f15h_mc0_mce;
 		fam_ops->mc1_mce = f15h_mc1_mce;
+		fam_ops->mc2_mce = f15h_mc2_mce;
 		break;
 
 	default:
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index 6796799..000f6e2 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -78,6 +78,7 @@ extern const char * const ii_msgs[];
 struct amd_decoder_ops {
 	bool (*mc0_mce)(u16, u8);
 	bool (*mc1_mce)(u16, u8);
+	bool (*mc2_mce)(u16, u8);
 };
 
 void amd_report_gart_errors(bool);
-- 
1.7.9.5


