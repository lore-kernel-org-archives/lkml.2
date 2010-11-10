Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab0KJTDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:03:35 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49274 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab0KJTDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:03:31 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 04/12] EDAC, MCE: Add F15h CU MCE decoder
Date: Wed, 10 Nov 2010 20:02:13 +0100
Message-Id: <1289415741-15000-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1289415741-15000-1-git-send-email-bp@amd64.org>
References: <1289415741-15000-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

MCE bank 2 is redefined from a BU to a CU (Combined Unit) bank on F15h.
Add a decoder function for CU MCEs.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 61 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 158cd5f..7eb2706 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -95,6 +95,23 @@ static const char * const f15h_ic_mce_desc[] = {
 	"fetch address FIFO"
 };
 
+static const char * const f15h_cu_mce_desc[] = {
+	"Fill ECC error on data fills",			/* xec = 0x4 */
+	"Fill parity error on insn fills",
+	"Prefetcher request FIFO parity error",
+	"PRQ address parity error",
+	"PRQ data parity error",
+	"WCC Tag ECC error",
+	"WCC Data ECC error",
+	"WCB Data parity error",
+	"VB Data/ECC error",
+	"L2 Tag ECC error",				/* xec = 0x10 */
+	"Hard L2 Tag ECC error",
+	"Multiple hits on L2 tag",
+	"XAB parity error",
+	"PRB address parity error"
+};
+
 static bool f12h_dc_mce(u16 ec, u8 xec)
 {
 	bool ret = false;
@@ -405,6 +422,46 @@ wrong_bu_mce:
 	pr_emerg(HW_ERR "Corrupted BU MCE info?\n");
 }
 
+static void amd_decode_cu_mce(struct mce *m)
+{
+	u16 ec = m->status & 0xffff;
+	u8 xec = (m->status >> 16) & xec_mask;
+
+	pr_emerg(HW_ERR "Combined Unit Error: ");
+
+	if (TLB_ERROR(ec)) {
+		if (xec == 0x0)
+			pr_cont("Data parity TLB read error.\n");
+		else if (xec == 0x1)
+			pr_cont("Poison data provided for TLB fill.\n");
+		else
+			goto wrong_cu_mce;
+	} else if (BUS_ERROR(ec)) {
+		if (xec > 2)
+			goto wrong_cu_mce;
+
+		pr_cont("Error during attempted NB data read.\n");
+	} else if (MEM_ERROR(ec)) {
+		switch (xec) {
+		case 0x4 ... 0xc:
+			pr_cont("%s.\n", f15h_cu_mce_desc[xec - 0x4]);
+			break;
+
+		case 0x10 ... 0x14:
+			pr_cont("%s.\n", f15h_cu_mce_desc[xec - 0x7]);
+			break;
+
+		default:
+			goto wrong_cu_mce;
+		}
+	}
+
+	return;
+
+wrong_cu_mce:
+	pr_emerg(HW_ERR "Corrupted CU MCE info?\n");
+}
+
 static void amd_decode_ls_mce(struct mce *m)
 {
 	u16 ec = m->status & 0xffff;
@@ -665,7 +722,10 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 		break;
 
 	case 2:
-		amd_decode_bu_mce(m);
+		if (boot_cpu_data.x86 == 0x15)
+			amd_decode_cu_mce(m);
+		else
+			amd_decode_bu_mce(m);
 		break;
 
 	case 3:
-- 
1.7.3.1.50.g1e633

