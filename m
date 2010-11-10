Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0KJTD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:03:28 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49268 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab0KJTD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:03:27 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 03/12] EDAC, MCE: Add F15h IC MCE decoder
Date: Wed, 10 Nov 2010 20:02:12 +0100
Message-Id: <1289415741-15000-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1289415741-15000-1-git-send-email-bp@amd64.org>
References: <1289415741-15000-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add support for decoding F15h IC MCEs.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |   53 +++++++++++++++++++++++++++++++++++++++++++++--
 drivers/edac/mce_amd.h |    2 +-
 2 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 12bae3b..158cd5f 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -75,6 +75,26 @@ static const char *f10h_nb_mce_desc[] = {
 	"ECC Error in the Probe Filter directory"
 };
 
+static const char * const f15h_ic_mce_desc[] = {
+	"UC during a demand linefill from L2",
+	"Parity error during data load from IC",
+	"Parity error for IC valid bit",
+	"Main tag parity error",
+	"Parity error in prediction queue",
+	"PFB data/address parity error",
+	"Parity error in the branch status reg",
+	"PFB promotion address error",
+	"Tag error during probe/victimization",
+	"Parity error for IC probe tag valid bit",
+	"PFB non-cacheable bit parity error",
+	"PFB valid bit parity error",			/* xec = 0xd */
+	"patch RAM",					/* xec = 010 */
+	"uop queue",
+	"insn buffer",
+	"predecode buffer",
+	"fetch address FIFO"
+};
+
 static bool f12h_dc_mce(u16 ec, u8 xec)
 {
 	bool ret = false;
@@ -241,7 +261,7 @@ static void amd_decode_dc_mce(struct mce *m)
 		pr_emerg(HW_ERR "Corrupted DC MCE info?\n");
 }
 
-static bool k8_ic_mce(u16 ec)
+static bool k8_ic_mce(u16 ec, u8 xec)
 {
 	u8 ll	 = ec & 0x3;
 	u8 r4	 = (ec >> 4) & 0xf;
@@ -276,7 +296,7 @@ static bool k8_ic_mce(u16 ec)
 	return ret;
 }
 
-static bool f14h_ic_mce(u16 ec)
+static bool f14h_ic_mce(u16 ec, u8 xec)
 {
 	u8 ll    = ec & 0x3;
 	u8 tt    = (ec >> 2) & 0x3;
@@ -297,6 +317,32 @@ static bool f14h_ic_mce(u16 ec)
 	return ret;
 }
 
+static bool f15h_ic_mce(u16 ec, u8 xec)
+{
+	bool ret = true;
+
+	if (!MEM_ERROR(ec))
+		return false;
+
+	switch (xec) {
+	case 0x0 ... 0xa:
+		pr_cont("%s.\n", f15h_ic_mce_desc[xec]);
+		break;
+
+	case 0xd:
+		pr_cont("%s.\n", f15h_ic_mce_desc[xec-2]);
+		break;
+
+	case 0x10 ... 0x14:
+		pr_cont("Decoder %s parity error.\n", f15h_ic_mce_desc[xec-4]);
+		break;
+
+	default:
+		ret = false;
+	}
+	return ret;
+}
+
 static void amd_decode_ic_mce(struct mce *m)
 {
 	u16 ec = m->status & 0xffff;
@@ -311,7 +357,7 @@ static void amd_decode_ic_mce(struct mce *m)
 		bool k8 = (boot_cpu_data.x86 == 0xf && (m->status & BIT_64(58)));
 
 		pr_cont("during %s.\n", (k8 ? "system linefill" : "NB data read"));
-	} else if (fam_ops->ic_mce(ec))
+	} else if (fam_ops->ic_mce(ec, xec))
 		;
 	else
 		pr_emerg(HW_ERR "Corrupted IC MCE info?\n");
@@ -697,6 +743,7 @@ static int __init mce_amd_init(void)
 	case 0x15:
 		xec_mask = 0x1f;
 		fam_ops->dc_mce = f15h_dc_mce;
+		fam_ops->ic_mce = f15h_ic_mce;
 		break;
 
 	default:
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index c12394d..8398847 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -101,7 +101,7 @@ struct err_regs {
  */
 struct amd_decoder_ops {
 	bool (*dc_mce)(u16, u8);
-	bool (*ic_mce)(u16);
+	bool (*ic_mce)(u16, u8);
 	bool (*nb_mce)(u16, u8);
 };
 
-- 
1.7.3.1.50.g1e633

