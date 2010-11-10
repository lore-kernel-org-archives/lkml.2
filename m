Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0KJTDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:03:37 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49287 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab0KJTDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:03:35 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 07/12] EDAC, MCE: Add F15 EX MCE decoder
Date: Wed, 10 Nov 2010 20:02:16 +0100
Message-Id: <1289415741-15000-8-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1289415741-15000-1-git-send-email-bp@amd64.org>
References: <1289415741-15000-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Integrate the single FIROB signature into an expanded table along with
the new BD MCE types.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index efbcb53..afda6de5 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -112,6 +112,22 @@ static const char * const f15h_cu_mce_desc[] = {
 	"PRB address parity error"
 };
 
+static const char * const fr_ex_mce_desc[] = {
+	"CPU Watchdog timer expire",
+	"Wakeup array dest tag",
+	"AG payload array",
+	"EX payload array",
+	"IDRF array",
+	"Retire dispatch queue",
+	"Mapper checkpoint array",
+	"Physical register file EX0 port",
+	"Physical register file EX1 port",
+	"Physical register file AG0 port",
+	"Physical register file AG1 port",
+	"Flag register file",
+	"DE correctable error could not be corrected"
+};
+
 static bool f12h_dc_mce(u16 ec, u8 xec)
 {
 	bool ret = false;
@@ -651,15 +667,26 @@ EXPORT_SYMBOL_GPL(amd_decode_nb_mce);
 
 static void amd_decode_fr_mce(struct mce *m)
 {
-	if (boot_cpu_data.x86 == 0xf ||
-	    boot_cpu_data.x86 == 0x11)
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	u8 xec = (m->status >> 16) & xec_mask;
+
+	if (c->x86 == 0xf || c->x86 == 0x11)
 		goto wrong_fr_mce;
 
-	/* we have only one error signature so match all fields at once. */
-	if ((m->status & 0xffff) == 0x0f0f) {
-		pr_emerg(HW_ERR "FR Error: CPU Watchdog timer expire.\n");
-		return;
-	}
+	if (c->x86 != 0x15 && xec != 0x0)
+		goto wrong_fr_mce;
+
+	pr_emerg(HW_ERR "%s Error: ",
+		 (c->x86 == 0x15 ? "Execution Unit" : "FIROB"));
+
+	if (xec == 0x0 || xec == 0xc)
+		pr_cont("%s.\n", fr_ex_mce_desc[xec]);
+	else if (xec < 0xd)
+		pr_cont("%s parity error.\n", fr_ex_mce_desc[xec]);
+	else
+		goto wrong_fr_mce;
+
+	return;
 
 wrong_fr_mce:
 	pr_emerg(HW_ERR "Corrupted FR MCE info?\n");
-- 
1.7.3.1.50.g1e633

