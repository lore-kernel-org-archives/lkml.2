Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0HZOF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:05:59 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34059 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab0HZOF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:05:56 -0400
From: Borislav Petkov <bp@amd64.org>
To: <torvalds@linux-foundation.org>
Cc: <norsk5@yahoo.com>, <linux-kernel@vger.kernel.org>,
        <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/2] amd64_edac: Do not report error overflow as a separate error
Date: Thu, 26 Aug 2010 16:06:29 +0200
Message-Id: <1282831589-4274-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282831589-4274-1-git-send-email-bp@amd64.org>
References: <1282831589-4274-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

When the Overflow MCi_STATUS bit is set, EDAC reports the lost error
with a "no information available" message which often puzzles users
parsing the dmesg. This doesn't make much sense since this error has
been lost anyway so no need for reporting it separately. Thus, report
the overflow bit setting in the MCE dump instead. While at it, remove
reporting of MiscV and ErrorEnable (en) which are superfluous.

Now it looks like this:

[ 1501.650024] MC4_STATUS: Corrected error, other errors lost: yes, CPU context corrupt: no, CECC Error
[ 1501.666887] Northbridge Error, node 2

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c   |   10 ----------
 drivers/edac/edac_mce_amd.c |    5 ++---
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 670239a..e7d5d6b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2071,16 +2071,6 @@ static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
 		amd64_handle_ce(mci, info);
 	else if (ecc_type == 1)
 		amd64_handle_ue(mci, info);
-
-	/*
-	 * If main error is CE then overflow must be CE.  If main error is UE
-	 * then overflow is unknown.  We'll call the overflow a CE - if
-	 * panic_on_ue is set then we're already panic'ed and won't arrive
-	 * here. Else, then apparently someone doesn't think that UE's are
-	 * catastrophic.
-	 */
-	if (info->nbsh & K8_NBSH_OVERFLOW)
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR " Error Overflow");
 }
 
 void amd64_decode_bus_error(int node_id, struct err_regs *regs)
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 352dcc6..9014df6 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -365,11 +365,10 @@ static int amd_decode_mce(struct notifier_block *nb, unsigned long val,
 
 	pr_emerg("MC%d_STATUS: ", m->bank);
 
-	pr_cont("%sorrected error, report: %s, MiscV: %svalid, "
+	pr_cont("%sorrected error, other errors lost: %s, "
 		 "CPU context corrupt: %s",
 		 ((m->status & MCI_STATUS_UC) ? "Unc"  : "C"),
-		 ((m->status & MCI_STATUS_EN) ? "yes"  : "no"),
-		 ((m->status & MCI_STATUS_MISCV) ? ""  : "in"),
+		 ((m->status & MCI_STATUS_OVER) ? "yes"  : "no"),
 		 ((m->status & MCI_STATUS_PCC) ? "yes" : "no"));
 
 	/* do the two bits[14:13] together */
-- 
1.7.1

