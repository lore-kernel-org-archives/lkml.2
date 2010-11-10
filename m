Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab0KJTEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:04:32 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49294 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337Ab0KJTDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:03:40 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 10/12] EDAC, MCE: Shorten error report formatting
Date: Wed, 10 Nov 2010 20:02:19 +0100
Message-Id: <1289415741-15000-11-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1289415741-15000-1-git-send-email-bp@amd64.org>
References: <1289415741-15000-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Shorten up MCi_STATUS flags and add BD's new deferred and poison types.
Also, simplify formatting.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |   54 ++++++++++++++++++++++++++++-------------------
 1 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 53d4dc0..0a19d26 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -723,19 +723,22 @@ wrong_fp_mce:
 
 static inline void amd_decode_err_code(u16 ec)
 {
-	if (TLB_ERROR(ec)) {
-		pr_emerg(HW_ERR "Transaction: %s, Cache Level: %s\n",
-			 TT_MSG(ec), LL_MSG(ec));
-	} else if (MEM_ERROR(ec)) {
-		pr_emerg(HW_ERR "Transaction: %s, Type: %s, Cache Level: %s\n",
-			 R4_MSG(ec), TT_MSG(ec), LL_MSG(ec));
-	} else if (BUS_ERROR(ec)) {
-		pr_emerg(HW_ERR "Transaction: %s (%s), %s, Cache Level: %s, "
-			 "Participating Processor: %s\n",
-			  R4_MSG(ec), II_MSG(ec), TO_MSG(ec), LL_MSG(ec),
-			  PP_MSG(ec));
-	} else
-		pr_emerg(HW_ERR "Huh? Unknown MCE error 0x%x\n", ec);
+
+	pr_emerg(HW_ERR "cache level: %s", LL_MSG(ec));
+
+	if (BUS_ERROR(ec))
+		pr_cont(", mem/io: %s", II_MSG(ec));
+	else
+		pr_cont(", tx: %s", TT_MSG(ec));
+
+	if (MEM_ERROR(ec) || BUS_ERROR(ec)) {
+		pr_cont(", mem-tx: %s", R4_MSG(ec));
+
+		if (BUS_ERROR(ec))
+			pr_cont(", part-proc: %s (%s)", PP_MSG(ec), TO_MSG(ec));
+	}
+
+	pr_cont("\n");
 }
 
 /*
@@ -757,25 +760,32 @@ static bool amd_filter_mce(struct mce *m)
 int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 {
 	struct mce *m = (struct mce *)data;
+	struct cpuinfo_x86 *c = &boot_cpu_data;
 	int node, ecc;
 
 	if (amd_filter_mce(m))
 		return NOTIFY_STOP;
 
-	pr_emerg(HW_ERR "MC%d_STATUS: ", m->bank);
+	pr_emerg(HW_ERR "MC%d_STATUS[%s|%s|%s|%s|%s",
+		m->bank,
+		((m->status & MCI_STATUS_OVER)	? "Over"  : "-"),
+		((m->status & MCI_STATUS_UC)	? "UE"	  : "CE"),
+		((m->status & MCI_STATUS_MISCV)	? "MiscV" : "-"),
+		((m->status & MCI_STATUS_PCC)	? "PCC"	  : "-"),
+		((m->status & MCI_STATUS_ADDRV)	? "AddrV" : "-"));
 
-	pr_cont("%sorrected error, other errors lost: %s, "
-		 "CPU context corrupt: %s",
-		 ((m->status & MCI_STATUS_UC) ? "Unc"  : "C"),
-		 ((m->status & MCI_STATUS_OVER) ? "yes"  : "no"),
-		 ((m->status & MCI_STATUS_PCC) ? "yes" : "no"));
+	if (c->x86 == 0x15)
+		pr_cont("|%s|%s",
+			((m->status & BIT(44))	? "Deferred" : "-"),
+			((m->status & BIT(43))	? "Poison"   : "-"));
 
 	/* do the two bits[14:13] together */
 	ecc = (m->status >> 45) & 0x3;
 	if (ecc)
-		pr_cont(", %sECC Error", ((ecc == 2) ? "C" : "U"));
+		pr_cont("|%sECC", ((ecc == 2) ? "C" : "U"));
+
+	pr_cont("]: 0x%016llx\n", m->status);
 
-	pr_cont("\n");
 
 	switch (m->bank) {
 	case 0:
@@ -787,7 +797,7 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 		break;
 
 	case 2:
-		if (boot_cpu_data.x86 == 0x15)
+		if (c->x86 == 0x15)
 			amd_decode_cu_mce(m);
 		else
 			amd_decode_bu_mce(m);
-- 
1.7.3.1.50.g1e633

